local var0 = class("ShipUpgradeLayer2", import("..base.BaseUI"))
local var1 = 3

function var0.getUIName(arg0)
	return "ShipBreakOutUI"
end

function var0.setItems(arg0, arg1)
	arg0.items = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0.leftPanel = arg0:findTF("blur_panel/left_panel")
	arg0.stages = arg0:findTF("stageScrollRect/stages", arg0.leftPanel)
	arg0.stagesSnap = arg0:findTF("stageScrollRect", arg0.leftPanel):GetComponent("HorizontalScrollSnap")
	arg0.breakView = arg0:findTF("content/Text", arg0.leftPanel)
	arg0.rightPanel = arg0:findTF("blur_panel/right_panel")
	arg0.attrs = arg0:findTF("top/attrs", arg0.rightPanel)
	arg0.starTpl = arg0:findTF("top/rare/startpl", arg0.rightPanel)

	setActive(arg0.starTpl, false)

	arg0.starsFrom = arg0:findTF("top/rare/stars_from", arg0.rightPanel)
	arg0.starsTo = arg0:findTF("top/rare/stars_to", arg0.rightPanel)
	arg0.starOpera = arg0:findTF("top/rare/opera", arg0.rightPanel)
	arg0.materials = arg0:findTF("bottom/materials", arg0.rightPanel)
	arg0.breakOutBtn = arg0:findTF("bottom/break_btn/tip_active/image", arg0.rightPanel)
	arg0.appendStarTips = arg0:findTF("bottom/panel_title/tip", arg0.rightPanel)
	arg0.tipActive = arg0:findTF("bottom/break_btn/tip_active", arg0.rightPanel)
	arg0.tipDeactive = arg0:findTF("bottom/break_btn/tip_deactive", arg0.rightPanel)
	arg0.recommandBtn = arg0.rightPanel:Find("bottom/auto_btn")
	arg0.isEnoughItems = true
	arg0.sea = arg0:findTF("sea", arg0.leftPanel)
	arg0.rawImage = arg0.sea:GetComponent("RawImage")

	setActive(arg0.rawImage, false)

	arg0.healTF = arg0:findTF("resources/heal")
	arg0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0.healTF, false)

	arg0.qCharaContain = arg0:findTF("top/panel_bg/q_chara", arg0.rightPanel)
	arg0.seaLoading = arg0:findTF("bg/loading", arg0.leftPanel)

	arg0:playLoadingAni()

	arg0.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0._tf, arg0.event)
end

function var0.loadChar(arg0)
	if not arg0.shipPrefab then
		local var0 = arg0.shipVO:getPrefab()

		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0.shipPrefab = var0
			arg0.shipModel = arg0
			tf(arg0).localScale = Vector3(0.8, 0.8, 1)

			arg0:GetComponent("SpineAnimUI"):SetAction("stand", 0)
			setParent(arg0, arg0.qCharaContain)
		end)
	end
end

function var0.recycleSpineChar(arg0)
	if arg0.shipPrefab and arg0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.shipPrefab, arg0.shipModel)

		arg0.shipPrefab = nil
		arg0.shipModel = nil
	end
end

function var0.enabledToggles(arg0, arg1)
	eachChild(arg0.toggles, function(arg0)
		arg0:GetComponent("Toggle").enabled = arg1
	end)
end

function var0.addDragListenter(arg0)
	local var0 = GetOrAddComponent(arg0._tf, "EventTriggerListener")

	arg0.dragTrigger = var0

	local var1
	local var2 = 0

	var0:AddBeginDragFunc(function()
		var1 = nil
		var2 = 0
	end)
	var0:AddDragFunc(function(arg0, arg1)
		local var0 = arg1.position

		if not var1 then
			var1 = var0
		end

		var2 = var0.x - var1.x
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if var2 < -50 then
			arg0:emit(ShipUpgradeMediator2.NEXTSHIP, -1)
		elseif var2 > 50 then
			arg0:emit(ShipUpgradeMediator2.NEXTSHIP)
		end
	end)
end

function var0.didEnter(arg0)
	arg0.UIMgr = pg.UIMgr.GetInstance()

	arg0.UIMgr:BlurPanel(arg0._tf, false, {
		groupName = arg0:getGroupNameFromData(),
		weight = LayerWeightConst.LOWER_LAYER
	})
	arg0:addDragListenter()
	onButton(arg0, arg0.seaLoading, function()
		if not arg0.previewer then
			arg0:showBarrage()
		end
	end)
	onButton(arg0, arg0.breakOutBtn, function()
		local var0 = {}

		if arg0.shipVO:isActivityNpc() then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("npc_breakout_tip"),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0.shipVO)

			if not var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return
			end

			if arg0.breakCfg.breakout_id == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_maxLevel"))

				return
			end

			if arg0.shipVO.level < arg0.breakCfg.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_lvLimit"))

				return
			end

			if not arg0.isEnoughItems then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_noEnoughMatrail"))

				return
			end

			if arg0.player.gold < arg0.breakCfg.use_gold then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0.breakCfg.use_gold - arg0.player.gold,
						arg0.breakCfg.use_gold
					}
				})

				return
			end

			if not arg0.contextData.materialShipIds or #arg0.contextData.materialShipIds < arg0.breakCfg.use_char_num then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_select_material_tip"))

				return
			end

			arg0:emit(ShipUpgradeMediator2.UPGRADE_SHIP, arg0.contextData.materialShipIds)
		end)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.recommandBtn, function()
		local var0 = getProxy(BayProxy)

		if arg0.contextData.materialShipIds and #arg0.contextData.materialShipIds == arg0.breakCfg.use_char_num then
			return
		end

		local var1 = var0:getUpgradeRecommendShip(arg0.shipVO, arg0.contextData.materialShipIds or {}, arg0.breakCfg.use_char_num)

		if #var1 > 0 then
			local var2 = {}

			table.insert(var2, function(arg0)
				local var0, var1 = ShipCalcHelper.GetEliteAndHightLevelShips(underscore.map(var1, function(arg0)
					return var0:getShipById(arg0)
				end))

				if #var0 > 0 or #var1 > 0 then
					arg0.destroyConfirmWindow:ExecuteAction("Show", var0, var1, false, arg0)
				else
					arg0()
				end
			end)
			seriesAsync(var2, function()
				arg0.contextData.materialShipIds = var1

				arg0:updateBreakOutView(arg0.shipVO)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_selected_ship"))
		end
	end, SFX_CONFIRM)
	arg0:initMaterialShips()
end

function var0.getMaterialShip(arg0, arg1)
	local var0

	for iter0 = #arg1, 1, -1 do
		if not arg1[iter0]:isTestShip() then
			var0 = iter0

			break
		end
	end

	var0 = var0 or #arg1

	return var0
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1
	arg0.shipTempCfg = pg.ship_data_template
	arg0.shipBreakOutCfg = pg.ship_data_breakout
	arg0.breakIds = arg0:getStages()
	arg0.itemTFs = {}

	for iter0 = 1, 3 do
		arg0.itemTFs[iter0] = arg0:findTF("item_" .. iter0, arg0.materials)
	end

	arg0:updateBattleView()
	arg0:updateBreakOutView(arg0.shipVO)

	local var0 = arg0.shipVO.level < arg0.breakCfg.level or arg0.breakCfg.breakout_id == 0

	setActive(arg0.tipActive, not var0)
	setActive(arg0.tipDeactive, var0)
	setButtonEnabled(arg0.breakOutBtn, not var0)
	setActive(arg0.recommandBtn, arg0.breakCfg.breakout_id ~= 0)
	arg0:loadChar()
end

function var0.getStages(arg0)
	local var0 = {}
	local var1 = math.floor(arg0.shipVO.configId / 10)

	for iter0 = 1, 4 do
		local var2 = tonumber(var1 .. iter0)

		assert(arg0.shipBreakOutCfg[var2], "必须存在配置" .. var2)
		table.insert(var0, var2)
	end

	return var0
end

function var0.updateStagesScrollView(arg0)
	local var0 = table.indexof(arg0.breakIds, arg0.shipVO.configId)

	if var0 and var0 >= 1 and var0 <= var1 then
		arg0:findTF("stage" .. var0, arg0.stages):GetComponent(typeof(Toggle)).isOn = true
	end
end

function var0.updateBattleView(arg0)
	if #arg0.breakIds < var1 then
		return
	end

	for iter0 = 1, var1 do
		local var0 = arg0.breakIds[iter0]
		local var1 = arg0.shipBreakOutCfg[var0]

		assert(var1, "不存在配置" .. var0)

		local var2 = arg0:findTF("stage" .. iter0, arg0.stages)

		onToggle(arg0, var2, function(arg0)
			if arg0 then
				local var0 = var1.breakout_view
				local var1 = checkExist(pg.ship_data_template[var1.breakout_id], {
					"specific_type"
				}) or {}

				for iter0, iter1 in ipairs(var1) do
					var0 = var0 .. "/" .. i18n(ShipType.SpecificTableTips[iter1])
				end

				changeToScrollText(arg0.breakView, var0)
				arg0:switchStage(var0)
			end
		end, SFX_PANEL)
	end

	arg0:findTF("stage1", arg0.stages):GetComponent(typeof(Toggle)).group:SetAllTogglesOff()

	local var3 = table.indexof(arg0.breakIds, arg0.shipVO.configId)
	local var4 = math.clamp(var3, 1, var1)

	if var4 and var4 >= 1 and var4 <= var1 then
		local var5 = arg0:findTF("stage" .. var4, arg0.stages)

		triggerToggle(var5, true)
	end
end

local var2 = {
	"durability",
	"cannon",
	"torpedo",
	"antiaircraft",
	"air",
	"antisub"
}

function var0.showBarrage(arg0)
	arg0.previewer = WeaponPreviewer.New(arg0.rawImage)

	arg0.previewer:configUI(arg0.healTF)
	arg0.previewer:setDisplayWeapon(arg0:getWaponIdsById(arg0.breakOutId))
	arg0.previewer:load(40000, arg0.shipVO, arg0:getAllWeaponIds(), function()
		arg0:stopLoadingAni()
	end)
end

function var0.getWaponIdsById(arg0, arg1)
	return arg0.shipBreakOutCfg[arg1].weapon_ids
end

function var0.switchStage(arg0, arg1)
	if arg0.breakOutId == arg1 then
		return
	end

	arg0.breakOutId = arg1

	if arg0.previewer then
		arg0.previewer:setDisplayWeapon(arg0:getWaponIdsById(arg0.breakOutId))
	end
end

function var0.getAllWeaponIds(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.breakIds) do
		local var1 = Clone(arg0.shipBreakOutCfg[iter1].weapon_ids)
		local var2 = {
			__add = function(arg0, arg1)
				for iter0, iter1 in ipairs(arg0) do
					if not table.contains(arg1, iter1) then
						table.insert(arg1, iter1)
					end
				end

				return arg1
			end
		}

		setmetatable(var0, var2)

		var0 = var0 + var1
	end

	return var0
end

function var0.updateBreakOutView(arg0, arg1)
	arg0.breakCfg = arg0.shipBreakOutCfg[arg1.configId]

	for iter0, iter1 in ipairs(arg0.itemTFs) do
		setActive(iter1, false)
	end

	local var0 = arg1:getShipProperties()
	local var1 = Clone(arg1)

	var1.configId = arg0.breakCfg.breakout_id

	local var2 = {}
	local var3 = arg0.breakCfg.breakout_id == 0
	local var4 = arg1:getBattleTotalExpend()
	local var5
	local var6
	local var7 = arg0.tipDeactive:Find("values/label")
	local var8 = arg0.tipDeactive:Find("values/value")

	setText(var7, "")
	setText(var8, "")

	if var3 then
		var2 = var0
		var5 = var4

		setText(var7, i18n("word_level_upperLimit"))
	else
		var6 = arg0.shipTempCfg[arg0.breakCfg.breakout_id].max_level
		var2 = var1:getShipProperties()
		var2.level = var6 >= arg1:getMaxLevel() and var6 or arg1:getMaxLevel()
		var5 = var1:getBattleTotalExpend()

		setColorCount(var8, arg0.shipVO.level, arg0.breakCfg.level)
		setText(var7, i18n("word_level_require"))
	end

	local function var9(arg0, arg1)
		setText(arg0:Find("name"), arg1.name)
		setText(arg0:Find("value"), arg1.preAttr)

		local var0 = arg0:Find("value1")
		local var1 = arg0:Find("addition")
		local var2

		if arg1.afterAttr == 0 then
			var2 = setColorStr(arg1.afterAttr, "#FFFFFFFF")
		else
			var2 = setColorStr(arg1.afterAttr, COLOR_GREEN)
		end

		setText(var0, var2)
		setActive(var1, arg1.afterAttr - arg1.preAttr ~= 0)
		setText(var1, "(+" .. arg1.afterAttr - arg1.preAttr .. ")")
	end

	local var10 = 0

	if var6 and var6 ~= arg0.shipTempCfg[arg1.configId].max_level then
		local var11 = arg0:findTF("attr_1", arg0.attrs)

		var9(var11, {
			preAttr = arg0.shipTempCfg[arg1.configId].max_level,
			afterAttr = var6,
			name = i18n("word_level_upperLimit")
		})

		var10 = 1
	end

	for iter2 = 1, #var2 do
		local var12 = arg0:findTF("attr_" .. var10 + iter2, arg0.attrs)

		setActive(var12, true)

		local var13 = math.floor(var0[var2[iter2]])
		local var14 = math.floor(var2[var2[iter2]])

		var9(var12, {
			preAttr = var13,
			afterAttr = var14,
			name = i18n("word_attr_" .. var2[iter2])
		})
	end

	local var15 = var10 + #var2 + 1
	local var16 = arg0:findTF("attr_" .. var15, arg0.attrs)

	setActive(var16, true)
	var9(var16, {
		preAttr = var4,
		afterAttr = var5,
		name = i18n("word_attr_luck")
	})

	for iter3 = var15 + 1, 8 do
		local var17 = arg0:findTF("attr_" .. iter3, arg0.attrs)

		setActive(var17, false)
	end

	removeAllChildren(arg0.starsFrom)

	for iter4 = 1, arg1:getStar() do
		cloneTplTo(arg0.starTpl, arg0.starsFrom)
	end

	if var3 then
		return
	end

	removeAllChildren(arg0.starsTo)

	if var1:getStar() > arg1:getStar() and not var3 then
		for iter5 = 1, var1:getStar() do
			cloneTplTo(arg0.starTpl, arg0.starsTo)
		end
	end

	setActive(arg0.appendStarTips, var1:getStar() ~= arg1:getStar())
	setActive(arg0.starOpera, var1:getStar() ~= arg1:getStar())

	local var18 = arg0.breakCfg.use_gold

	if var18 > arg0.player.gold then
		var18 = "<color=#FB4A2C>" .. var18 .. "</color>"
	end

	setText(arg0.tipActive:Find("text"), var18)
	arg0:initMaterialShips()
end

function var0.initMaterialShips(arg0)
	local var0 = arg0.breakCfg.use_char_num
	local var1 = getProxy(BayProxy)

	for iter0 = 1, 3 do
		SetActive(arg0.itemTFs[iter0], iter0 <= var0)

		local var2 = arg0.itemTFs[iter0]:Find("IconTpl")
		local var3 = arg0.contextData.materialShipIds

		if iter0 <= var0 and var3 and var3[iter0] then
			local var4 = var1:getShipById(var3[iter0])

			updateShip(var2, var4, {
				initStar = true
			})
			SetActive(var2, true)
		else
			SetActive(var2, false)
		end

		onButton(arg0, arg0.itemTFs[iter0], function()
			arg0:emit(ShipUpgradeMediator2.ON_SELECT_SHIP, arg0.shipVO, var0)
		end)
	end
end

function var0.willExit(arg0)
	arg0.UIMgr:UnblurPanel(arg0._tf, arg0.UIMain)
	arg0:recycleSpineChar()

	if arg0.previewer then
		arg0.previewer:clear()

		arg0.previewer = nil
	end

	if arg0.dragTrigger then
		ClearEventTrigger(arg0.dragTrigger)

		arg0.dragTrigger = nil
	end

	arg0.destroyConfirmWindow:Destroy()
end

function var0.playLoadingAni(arg0)
	setActive(arg0.seaLoading, true)
end

function var0.stopLoadingAni(arg0)
	setActive(arg0.seaLoading, false)
end

function var0.onBackPressed(arg0)
	if arg0.destroyConfirmWindow:isShowing() then
		arg0.destroyConfirmWindow:ActionInvoke("Hide")

		return
	end

	arg0:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0

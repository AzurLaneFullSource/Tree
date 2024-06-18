local var0_0 = class("ShipUpgradeLayer2", import("..base.BaseUI"))
local var1_0 = 3

function var0_0.getUIName(arg0_1)
	return "ShipBreakOutUI"
end

function var0_0.setItems(arg0_2, arg1_2)
	arg0_2.items = arg1_2
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.player = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.leftPanel = arg0_4:findTF("blur_panel/left_panel")
	arg0_4.stages = arg0_4:findTF("stageScrollRect/stages", arg0_4.leftPanel)
	arg0_4.stagesSnap = arg0_4:findTF("stageScrollRect", arg0_4.leftPanel):GetComponent("HorizontalScrollSnap")
	arg0_4.breakView = arg0_4:findTF("content/Text", arg0_4.leftPanel)
	arg0_4.rightPanel = arg0_4:findTF("blur_panel/right_panel")
	arg0_4.attrs = arg0_4:findTF("top/attrs", arg0_4.rightPanel)
	arg0_4.starTpl = arg0_4:findTF("top/rare/startpl", arg0_4.rightPanel)

	setActive(arg0_4.starTpl, false)

	arg0_4.starsFrom = arg0_4:findTF("top/rare/stars_from", arg0_4.rightPanel)
	arg0_4.starsTo = arg0_4:findTF("top/rare/stars_to", arg0_4.rightPanel)
	arg0_4.starOpera = arg0_4:findTF("top/rare/opera", arg0_4.rightPanel)
	arg0_4.materials = arg0_4:findTF("bottom/materials", arg0_4.rightPanel)
	arg0_4.breakOutBtn = arg0_4:findTF("bottom/break_btn/tip_active/image", arg0_4.rightPanel)
	arg0_4.appendStarTips = arg0_4:findTF("bottom/panel_title/tip", arg0_4.rightPanel)
	arg0_4.tipActive = arg0_4:findTF("bottom/break_btn/tip_active", arg0_4.rightPanel)
	arg0_4.tipDeactive = arg0_4:findTF("bottom/break_btn/tip_deactive", arg0_4.rightPanel)
	arg0_4.recommandBtn = arg0_4.rightPanel:Find("bottom/auto_btn")
	arg0_4.isEnoughItems = true
	arg0_4.sea = arg0_4:findTF("sea", arg0_4.leftPanel)
	arg0_4.rawImage = arg0_4.sea:GetComponent("RawImage")

	setActive(arg0_4.rawImage, false)

	arg0_4.healTF = arg0_4:findTF("resources/heal")
	arg0_4.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_4.healTF, false)

	arg0_4.qCharaContain = arg0_4:findTF("top/panel_bg/q_chara", arg0_4.rightPanel)
	arg0_4.seaLoading = arg0_4:findTF("bg/loading", arg0_4.leftPanel)

	arg0_4:playLoadingAni()

	arg0_4.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_4._tf, arg0_4.event)
end

function var0_0.loadChar(arg0_5)
	if not arg0_5.shipPrefab then
		local var0_5 = arg0_5.shipVO:getPrefab()

		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var0_5, true, function(arg0_6)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_5.shipPrefab = var0_5
			arg0_5.shipModel = arg0_6
			tf(arg0_6).localScale = Vector3(0.8, 0.8, 1)

			arg0_6:GetComponent("SpineAnimUI"):SetAction("stand", 0)
			setParent(arg0_6, arg0_5.qCharaContain)
		end)
	end
end

function var0_0.recycleSpineChar(arg0_7)
	if arg0_7.shipPrefab and arg0_7.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_7.shipPrefab, arg0_7.shipModel)

		arg0_7.shipPrefab = nil
		arg0_7.shipModel = nil
	end
end

function var0_0.enabledToggles(arg0_8, arg1_8)
	eachChild(arg0_8.toggles, function(arg0_9)
		arg0_9:GetComponent("Toggle").enabled = arg1_8
	end)
end

function var0_0.addDragListenter(arg0_10)
	local var0_10 = GetOrAddComponent(arg0_10._tf, "EventTriggerListener")

	arg0_10.dragTrigger = var0_10

	local var1_10
	local var2_10 = 0

	var0_10:AddBeginDragFunc(function()
		var1_10 = nil
		var2_10 = 0
	end)
	var0_10:AddDragFunc(function(arg0_12, arg1_12)
		local var0_12 = arg1_12.position

		if not var1_10 then
			var1_10 = var0_12
		end

		var2_10 = var0_12.x - var1_10.x
	end)
	var0_10:AddDragEndFunc(function(arg0_13, arg1_13)
		if var2_10 < -50 then
			arg0_10:emit(ShipUpgradeMediator2.NEXTSHIP, -1)
		elseif var2_10 > 50 then
			arg0_10:emit(ShipUpgradeMediator2.NEXTSHIP)
		end
	end)
end

function var0_0.didEnter(arg0_14)
	arg0_14.UIMgr = pg.UIMgr.GetInstance()

	arg0_14.UIMgr:BlurPanel(arg0_14._tf, false, {
		groupName = arg0_14:getGroupNameFromData(),
		weight = LayerWeightConst.LOWER_LAYER
	})
	arg0_14:addDragListenter()
	onButton(arg0_14, arg0_14.seaLoading, function()
		if not arg0_14.previewer then
			arg0_14:showBarrage()
		end
	end)
	onButton(arg0_14, arg0_14.breakOutBtn, function()
		local var0_16 = {}

		if arg0_14.shipVO:isActivityNpc() then
			table.insert(var0_16, function(arg0_17)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("npc_breakout_tip"),
					onYes = arg0_17
				})
			end)
		end

		seriesAsync(var0_16, function()
			local var0_18, var1_18 = ShipStatus.ShipStatusCheck("onModify", arg0_14.shipVO)

			if not var0_18 then
				pg.TipsMgr.GetInstance():ShowTips(var1_18)

				return
			end

			if arg0_14.breakCfg.breakout_id == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_maxLevel"))

				return
			end

			if arg0_14.shipVO.level < arg0_14.breakCfg.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_lvLimit"))

				return
			end

			if not arg0_14.isEnoughItems then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_noEnoughMatrail"))

				return
			end

			if arg0_14.player.gold < arg0_14.breakCfg.use_gold then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0_14.breakCfg.use_gold - arg0_14.player.gold,
						arg0_14.breakCfg.use_gold
					}
				})

				return
			end

			if not arg0_14.contextData.materialShipIds or #arg0_14.contextData.materialShipIds < arg0_14.breakCfg.use_char_num then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_select_material_tip"))

				return
			end

			arg0_14:emit(ShipUpgradeMediator2.UPGRADE_SHIP, arg0_14.contextData.materialShipIds)
		end)
	end, SFX_CONFIRM)
	onButton(arg0_14, arg0_14.recommandBtn, function()
		local var0_19 = getProxy(BayProxy)

		if arg0_14.contextData.materialShipIds and #arg0_14.contextData.materialShipIds == arg0_14.breakCfg.use_char_num then
			return
		end

		local var1_19 = var0_19:getUpgradeRecommendShip(arg0_14.shipVO, arg0_14.contextData.materialShipIds or {}, arg0_14.breakCfg.use_char_num)

		if #var1_19 > 0 then
			local var2_19 = {}

			table.insert(var2_19, function(arg0_20)
				local var0_20, var1_20 = ShipCalcHelper.GetEliteAndHightLevelShips(underscore.map(var1_19, function(arg0_21)
					return var0_19:getShipById(arg0_21)
				end))

				if #var0_20 > 0 or #var1_20 > 0 then
					arg0_14.destroyConfirmWindow:ExecuteAction("Show", var0_20, var1_20, false, arg0_20)
				else
					arg0_20()
				end
			end)
			seriesAsync(var2_19, function()
				arg0_14.contextData.materialShipIds = var1_19

				arg0_14:updateBreakOutView(arg0_14.shipVO)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_selected_ship"))
		end
	end, SFX_CONFIRM)
	arg0_14:initMaterialShips()
end

function var0_0.getMaterialShip(arg0_23, arg1_23)
	local var0_23

	for iter0_23 = #arg1_23, 1, -1 do
		if not arg1_23[iter0_23]:isTestShip() then
			var0_23 = iter0_23

			break
		end
	end

	var0_23 = var0_23 or #arg1_23

	return var0_23
end

function var0_0.setShip(arg0_24, arg1_24)
	arg0_24.shipVO = arg1_24
	arg0_24.shipTempCfg = pg.ship_data_template
	arg0_24.shipBreakOutCfg = pg.ship_data_breakout
	arg0_24.breakIds = arg0_24:getStages()
	arg0_24.itemTFs = {}

	for iter0_24 = 1, 3 do
		arg0_24.itemTFs[iter0_24] = arg0_24:findTF("item_" .. iter0_24, arg0_24.materials)
	end

	arg0_24:updateBattleView()
	arg0_24:updateBreakOutView(arg0_24.shipVO)

	local var0_24 = arg0_24.shipVO.level < arg0_24.breakCfg.level or arg0_24.breakCfg.breakout_id == 0

	setActive(arg0_24.tipActive, not var0_24)
	setActive(arg0_24.tipDeactive, var0_24)
	setButtonEnabled(arg0_24.breakOutBtn, not var0_24)
	setActive(arg0_24.recommandBtn, arg0_24.breakCfg.breakout_id ~= 0)
	arg0_24:loadChar()
end

function var0_0.getStages(arg0_25)
	local var0_25 = {}
	local var1_25 = math.floor(arg0_25.shipVO.configId / 10)

	for iter0_25 = 1, 4 do
		local var2_25 = tonumber(var1_25 .. iter0_25)

		assert(arg0_25.shipBreakOutCfg[var2_25], "必须存在配置" .. var2_25)
		table.insert(var0_25, var2_25)
	end

	return var0_25
end

function var0_0.updateStagesScrollView(arg0_26)
	local var0_26 = table.indexof(arg0_26.breakIds, arg0_26.shipVO.configId)

	if var0_26 and var0_26 >= 1 and var0_26 <= var1_0 then
		arg0_26:findTF("stage" .. var0_26, arg0_26.stages):GetComponent(typeof(Toggle)).isOn = true
	end
end

function var0_0.updateBattleView(arg0_27)
	if #arg0_27.breakIds < var1_0 then
		return
	end

	for iter0_27 = 1, var1_0 do
		local var0_27 = arg0_27.breakIds[iter0_27]
		local var1_27 = arg0_27.shipBreakOutCfg[var0_27]

		assert(var1_27, "不存在配置" .. var0_27)

		local var2_27 = arg0_27:findTF("stage" .. iter0_27, arg0_27.stages)

		onToggle(arg0_27, var2_27, function(arg0_28)
			if arg0_28 then
				local var0_28 = var1_27.breakout_view
				local var1_28 = checkExist(pg.ship_data_template[var1_27.breakout_id], {
					"specific_type"
				}) or {}

				for iter0_28, iter1_28 in ipairs(var1_28) do
					var0_28 = var0_28 .. "/" .. i18n(ShipType.SpecificTableTips[iter1_28])
				end

				changeToScrollText(arg0_27.breakView, var0_28)
				arg0_27:switchStage(var0_27)
			end
		end, SFX_PANEL)
	end

	arg0_27:findTF("stage1", arg0_27.stages):GetComponent(typeof(Toggle)).group:SetAllTogglesOff()

	local var3_27 = table.indexof(arg0_27.breakIds, arg0_27.shipVO.configId)
	local var4_27 = math.clamp(var3_27, 1, var1_0)

	if var4_27 and var4_27 >= 1 and var4_27 <= var1_0 then
		local var5_27 = arg0_27:findTF("stage" .. var4_27, arg0_27.stages)

		triggerToggle(var5_27, true)
	end
end

local var2_0 = {
	"durability",
	"cannon",
	"torpedo",
	"antiaircraft",
	"air",
	"antisub"
}

function var0_0.showBarrage(arg0_29)
	arg0_29.previewer = WeaponPreviewer.New(arg0_29.rawImage)

	arg0_29.previewer:configUI(arg0_29.healTF)
	arg0_29.previewer:setDisplayWeapon(arg0_29:getWaponIdsById(arg0_29.breakOutId))
	arg0_29.previewer:load(40000, arg0_29.shipVO, arg0_29:getAllWeaponIds(), function()
		arg0_29:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_31, arg1_31)
	return arg0_31.shipBreakOutCfg[arg1_31].weapon_ids
end

function var0_0.switchStage(arg0_32, arg1_32)
	if arg0_32.breakOutId == arg1_32 then
		return
	end

	arg0_32.breakOutId = arg1_32

	if arg0_32.previewer then
		arg0_32.previewer:setDisplayWeapon(arg0_32:getWaponIdsById(arg0_32.breakOutId))
	end
end

function var0_0.getAllWeaponIds(arg0_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in ipairs(arg0_33.breakIds) do
		local var1_33 = Clone(arg0_33.shipBreakOutCfg[iter1_33].weapon_ids)
		local var2_33 = {
			__add = function(arg0_34, arg1_34)
				for iter0_34, iter1_34 in ipairs(arg0_34) do
					if not table.contains(arg1_34, iter1_34) then
						table.insert(arg1_34, iter1_34)
					end
				end

				return arg1_34
			end
		}

		setmetatable(var0_33, var2_33)

		var0_33 = var0_33 + var1_33
	end

	return var0_33
end

function var0_0.updateBreakOutView(arg0_35, arg1_35)
	arg0_35.breakCfg = arg0_35.shipBreakOutCfg[arg1_35.configId]

	for iter0_35, iter1_35 in ipairs(arg0_35.itemTFs) do
		setActive(iter1_35, false)
	end

	local var0_35 = arg1_35:getShipProperties()
	local var1_35 = Clone(arg1_35)

	var1_35.configId = arg0_35.breakCfg.breakout_id

	local var2_35 = {}
	local var3_35 = arg0_35.breakCfg.breakout_id == 0
	local var4_35 = arg1_35:getBattleTotalExpend()
	local var5_35
	local var6_35
	local var7_35 = arg0_35.tipDeactive:Find("values/label")
	local var8_35 = arg0_35.tipDeactive:Find("values/value")

	setText(var7_35, "")
	setText(var8_35, "")

	if var3_35 then
		var2_35 = var0_35
		var5_35 = var4_35

		setText(var7_35, i18n("word_level_upperLimit"))
	else
		var6_35 = arg0_35.shipTempCfg[arg0_35.breakCfg.breakout_id].max_level
		var2_35 = var1_35:getShipProperties()
		var2_35.level = var6_35 >= arg1_35:getMaxLevel() and var6_35 or arg1_35:getMaxLevel()
		var5_35 = var1_35:getBattleTotalExpend()

		setColorCount(var8_35, arg0_35.shipVO.level, arg0_35.breakCfg.level)
		setText(var7_35, i18n("word_level_require"))
	end

	local function var9_35(arg0_36, arg1_36)
		setText(arg0_36:Find("name"), arg1_36.name)
		setText(arg0_36:Find("value"), arg1_36.preAttr)

		local var0_36 = arg0_36:Find("value1")
		local var1_36 = arg0_36:Find("addition")
		local var2_36

		if arg1_36.afterAttr == 0 then
			var2_36 = setColorStr(arg1_36.afterAttr, "#FFFFFFFF")
		else
			var2_36 = setColorStr(arg1_36.afterAttr, COLOR_GREEN)
		end

		setText(var0_36, var2_36)
		setActive(var1_36, arg1_36.afterAttr - arg1_36.preAttr ~= 0)
		setText(var1_36, "(+" .. arg1_36.afterAttr - arg1_36.preAttr .. ")")
	end

	local var10_35 = 0

	if var6_35 and var6_35 ~= arg0_35.shipTempCfg[arg1_35.configId].max_level then
		local var11_35 = arg0_35:findTF("attr_1", arg0_35.attrs)

		var9_35(var11_35, {
			preAttr = arg0_35.shipTempCfg[arg1_35.configId].max_level,
			afterAttr = var6_35,
			name = i18n("word_level_upperLimit")
		})

		var10_35 = 1
	end

	for iter2_35 = 1, #var2_0 do
		local var12_35 = arg0_35:findTF("attr_" .. var10_35 + iter2_35, arg0_35.attrs)

		setActive(var12_35, true)

		local var13_35 = math.floor(var0_35[var2_0[iter2_35]])
		local var14_35 = math.floor(var2_35[var2_0[iter2_35]])

		var9_35(var12_35, {
			preAttr = var13_35,
			afterAttr = var14_35,
			name = i18n("word_attr_" .. var2_0[iter2_35])
		})
	end

	local var15_35 = var10_35 + #var2_0 + 1
	local var16_35 = arg0_35:findTF("attr_" .. var15_35, arg0_35.attrs)

	setActive(var16_35, true)
	var9_35(var16_35, {
		preAttr = var4_35,
		afterAttr = var5_35,
		name = i18n("word_attr_luck")
	})

	for iter3_35 = var15_35 + 1, 8 do
		local var17_35 = arg0_35:findTF("attr_" .. iter3_35, arg0_35.attrs)

		setActive(var17_35, false)
	end

	removeAllChildren(arg0_35.starsFrom)

	for iter4_35 = 1, arg1_35:getStar() do
		cloneTplTo(arg0_35.starTpl, arg0_35.starsFrom)
	end

	if var3_35 then
		return
	end

	removeAllChildren(arg0_35.starsTo)

	if var1_35:getStar() > arg1_35:getStar() and not var3_35 then
		for iter5_35 = 1, var1_35:getStar() do
			cloneTplTo(arg0_35.starTpl, arg0_35.starsTo)
		end
	end

	setActive(arg0_35.appendStarTips, var1_35:getStar() ~= arg1_35:getStar())
	setActive(arg0_35.starOpera, var1_35:getStar() ~= arg1_35:getStar())

	local var18_35 = arg0_35.breakCfg.use_gold

	if var18_35 > arg0_35.player.gold then
		var18_35 = "<color=#FB4A2C>" .. var18_35 .. "</color>"
	end

	setText(arg0_35.tipActive:Find("text"), var18_35)
	arg0_35:initMaterialShips()
end

function var0_0.initMaterialShips(arg0_37)
	local var0_37 = arg0_37.breakCfg.use_char_num
	local var1_37 = getProxy(BayProxy)

	for iter0_37 = 1, 3 do
		SetActive(arg0_37.itemTFs[iter0_37], iter0_37 <= var0_37)

		local var2_37 = arg0_37.itemTFs[iter0_37]:Find("IconTpl")
		local var3_37 = arg0_37.contextData.materialShipIds

		if iter0_37 <= var0_37 and var3_37 and var3_37[iter0_37] then
			local var4_37 = var1_37:getShipById(var3_37[iter0_37])

			updateShip(var2_37, var4_37, {
				initStar = true
			})
			SetActive(var2_37, true)
		else
			SetActive(var2_37, false)
		end

		onButton(arg0_37, arg0_37.itemTFs[iter0_37], function()
			arg0_37:emit(ShipUpgradeMediator2.ON_SELECT_SHIP, arg0_37.shipVO, var0_37)
		end)
	end
end

function var0_0.willExit(arg0_39)
	arg0_39.UIMgr:UnblurPanel(arg0_39._tf, arg0_39.UIMain)
	arg0_39:recycleSpineChar()

	if arg0_39.previewer then
		arg0_39.previewer:clear()

		arg0_39.previewer = nil
	end

	if arg0_39.dragTrigger then
		ClearEventTrigger(arg0_39.dragTrigger)

		arg0_39.dragTrigger = nil
	end

	arg0_39.destroyConfirmWindow:Destroy()
end

function var0_0.playLoadingAni(arg0_40)
	setActive(arg0_40.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_41)
	setActive(arg0_41.seaLoading, false)
end

function var0_0.onBackPressed(arg0_42)
	if arg0_42.destroyConfirmWindow:isShowing() then
		arg0_42.destroyConfirmWindow:ActionInvoke("Hide")

		return
	end

	arg0_42:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0

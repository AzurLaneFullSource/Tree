local var0_0 = class("ShipUpgradeLayer2", import("..base.BaseUI"))
local var1_0 = 3

function var0_0.getUIName(arg0_1)
	return "ShipBreakOutUI"
end

function var0_0.getGroupName(arg0_2)
	return "ShipMainScene"
end

function var0_0.setItems(arg0_3, arg1_3)
	arg0_3.items = arg1_3
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.player = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.leftPanel = arg0_5._tf:Find("blur_panel/left_panel")
	arg0_5.stages = arg0_5.leftPanel:Find("stageScrollRect/stages")

	setText(arg0_5.leftPanel:Find("bg/title/Image"), i18n("word_preview"))

	arg0_5.stagesSnap = arg0_5.leftPanel:Find("stageScrollRect"):GetComponent("HorizontalScrollSnap")
	arg0_5.breakView = arg0_5.leftPanel:Find("content/Text")
	arg0_5.rightPanel = arg0_5._tf:Find("blur_panel/right_panel")
	arg0_5.attrs = arg0_5.rightPanel:Find("top/attrs")
	arg0_5.starTpl = arg0_5.rightPanel:Find("top/rare/startpl")

	setActive(arg0_5.starTpl, false)

	arg0_5.starsFrom = arg0_5.rightPanel:Find("top/rare/stars_from")
	arg0_5.starsTo = arg0_5.rightPanel:Find("top/rare/stars_to")
	arg0_5.starOpera = arg0_5.rightPanel:Find("top/rare/opera")
	arg0_5.materials = arg0_5.rightPanel:Find("bottom/materials")
	arg0_5.breakOutBtn = arg0_5.rightPanel:Find("bottom/break_btn/tip_active/image")
	arg0_5.appendStarTips = arg0_5.rightPanel:Find("bottom/panel_title/tip")
	arg0_5.tipActive = arg0_5.rightPanel:Find("bottom/break_btn/tip_active")
	arg0_5.tipDeactive = arg0_5.rightPanel:Find("bottom/break_btn/tip_deactive")

	setText(arg0_5.rightPanel:Find("bottom/panel_title/tip"), i18n("breakout_tip"))
	setText(arg0_5.rightPanel:Find("bottom/break_btn/tip_deactive/values/ok"), i18n("text_confirm"))
	setText(arg0_5.rightPanel:Find("bottom/break_btn/tip_active/image/ok"), i18n("text_confirm"))

	arg0_5.recommandBtn = arg0_5.rightPanel:Find("bottom/auto_btn")
	arg0_5.isEnoughItems = true
	arg0_5.sea = arg0_5.leftPanel:Find("sea")
	arg0_5.rawImage = arg0_5.sea:GetComponent("RawImage")

	setActive(arg0_5.rawImage, false)

	arg0_5.healTF = arg0_5._tf:Find("resources/heal")
	arg0_5.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_5.healTF, false)

	arg0_5.qCharaContain = arg0_5.rightPanel:Find("top/panel_bg/q_chara")
	arg0_5.seaLoading = arg0_5.leftPanel:Find("bg/loading")

	arg0_5:playLoadingAni()

	arg0_5.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_5._tf, arg0_5.event)
end

function var0_0.loadChar(arg0_6)
	if not arg0_6.shipPrefab then
		local var0_6 = arg0_6.shipVO:getPrefab()

		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var0_6, true, function(arg0_7)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_6.shipPrefab = var0_6
			arg0_6.shipModel = arg0_7
			tf(arg0_7).localScale = Vector3(0.8, 0.8, 1)

			arg0_7:GetComponent("SpineAnimUI"):SetAction("stand", 0)
			setParent(arg0_7, arg0_6.qCharaContain)
		end)
	end
end

function var0_0.recycleSpineChar(arg0_8)
	if arg0_8.shipPrefab and arg0_8.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_8.shipPrefab, arg0_8.shipModel)

		arg0_8.shipPrefab = nil
		arg0_8.shipModel = nil
	end
end

function var0_0.enabledToggles(arg0_9, arg1_9)
	eachChild(arg0_9.toggles, function(arg0_10)
		arg0_10:GetComponent("Toggle").enabled = arg1_9
	end)
end

function var0_0.addDragListenter(arg0_11)
	local var0_11 = GetOrAddComponent(arg0_11._tf, "EventTriggerListener")

	arg0_11.dragTrigger = var0_11

	local var1_11
	local var2_11 = 0

	var0_11:AddBeginDragFunc(function()
		var1_11 = nil
		var2_11 = 0
	end)
	var0_11:AddDragFunc(function(arg0_13, arg1_13)
		local var0_13 = arg1_13.position

		if not var1_11 then
			var1_11 = var0_13
		end

		var2_11 = var0_13.x - var1_11.x
	end)
	var0_11:AddDragEndFunc(function(arg0_14, arg1_14)
		if var2_11 < -50 then
			arg0_11:emit(ShipUpgradeMediator2.NEXTSHIP, -1)
		elseif var2_11 > 50 then
			arg0_11:emit(ShipUpgradeMediator2.NEXTSHIP)
		end
	end)
end

function var0_0.didEnter(arg0_15)
	arg0_15:BlurPanel(arg0_15._tf, {
		groupDelta = -1
	})
	arg0_15:addDragListenter()
	onButton(arg0_15, arg0_15.seaLoading, function()
		if not arg0_15.previewer then
			arg0_15:showBarrage()
		end
	end)
	onButton(arg0_15, arg0_15.breakOutBtn, function()
		local var0_17 = {}

		if arg0_15.shipVO:isActivityNpc() then
			table.insert(var0_17, function(arg0_18)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("npc_breakout_tip"),
					onYes = arg0_18
				})
			end)
		end

		seriesAsync(var0_17, function()
			local var0_19, var1_19 = ShipStatus.ShipStatusCheck("onModify", arg0_15.shipVO)

			if not var0_19 then
				pg.TipsMgr.GetInstance():ShowTips(var1_19)

				return
			end

			if arg0_15.breakCfg.breakout_id == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_maxLevel"))

				return
			end

			if arg0_15.shipVO.level < arg0_15.breakCfg.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_lvLimit"))

				return
			end

			if not arg0_15.isEnoughItems then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_noEnoughMatrail"))

				return
			end

			if arg0_15.player.gold < arg0_15.breakCfg.use_gold then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0_15.breakCfg.use_gold - arg0_15.player.gold,
						arg0_15.breakCfg.use_gold
					}
				})

				return
			end

			if not arg0_15.contextData.materialShipIds or #arg0_15.contextData.materialShipIds < arg0_15.breakCfg.use_char_num then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_select_material_tip"))

				return
			end

			arg0_15:emit(ShipUpgradeMediator2.UPGRADE_SHIP, arg0_15.contextData.materialShipIds)
		end)
	end, SFX_CONFIRM)
	onButton(arg0_15, arg0_15.recommandBtn, function()
		local var0_20 = getProxy(BayProxy)

		if arg0_15.contextData.materialShipIds and #arg0_15.contextData.materialShipIds == arg0_15.breakCfg.use_char_num then
			return
		end

		local var1_20 = var0_20:getUpgradeRecommendShip(arg0_15.shipVO, arg0_15.contextData.materialShipIds or {}, arg0_15.breakCfg.use_char_num)

		if #var1_20 > 0 then
			local var2_20 = {}

			table.insert(var2_20, function(arg0_21)
				local var0_21, var1_21 = ShipCalcHelper.GetEliteAndHightLevelShips(underscore.map(var1_20, function(arg0_22)
					return var0_20:getShipById(arg0_22)
				end))

				if #var0_21 > 0 or #var1_21 > 0 then
					arg0_15.destroyConfirmWindow:ExecuteAction("Show", var0_21, var1_21, false, arg0_21)
				else
					arg0_21()
				end
			end)
			seriesAsync(var2_20, function()
				arg0_15.contextData.materialShipIds = var1_20

				arg0_15:updateBreakOutView(arg0_15.shipVO)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_selected_ship"))
		end
	end, SFX_CONFIRM)
	arg0_15:initMaterialShips()
end

function var0_0.getMaterialShip(arg0_24, arg1_24)
	local var0_24

	for iter0_24 = #arg1_24, 1, -1 do
		if not arg1_24[iter0_24]:isTestShip() then
			var0_24 = iter0_24

			break
		end
	end

	var0_24 = var0_24 or #arg1_24

	return var0_24
end

function var0_0.setShip(arg0_25, arg1_25)
	arg0_25.shipVO = arg1_25
	arg0_25.shipTempCfg = pg.ship_data_template
	arg0_25.shipBreakOutCfg = pg.ship_data_breakout
	arg0_25.breakIds = arg0_25:getStages()
	arg0_25.itemTFs = {}

	for iter0_25 = 1, 3 do
		arg0_25.itemTFs[iter0_25] = arg0_25.materials:Find("item_" .. iter0_25)
	end

	arg0_25:updateBattleView()
	arg0_25:updateBreakOutView(arg0_25.shipVO)

	local var0_25 = arg0_25.shipVO.level < arg0_25.breakCfg.level or arg0_25.breakCfg.breakout_id == 0

	setActive(arg0_25.tipActive, not var0_25)
	setActive(arg0_25.tipDeactive, var0_25)
	setButtonEnabled(arg0_25.breakOutBtn, not var0_25)
	setActive(arg0_25.recommandBtn, arg0_25.breakCfg.breakout_id ~= 0)
	arg0_25:loadChar()
end

function var0_0.getStages(arg0_26)
	local var0_26 = {}
	local var1_26 = math.floor(arg0_26.shipVO.configId / 10)

	for iter0_26 = 1, 4 do
		local var2_26 = tonumber(var1_26 .. iter0_26)

		assert(arg0_26.shipBreakOutCfg[var2_26], "必须存在配置" .. var2_26)
		table.insert(var0_26, var2_26)
	end

	return var0_26
end

function var0_0.updateStagesScrollView(arg0_27)
	local var0_27 = table.indexof(arg0_27.breakIds, arg0_27.shipVO.configId)

	if var0_27 and var0_27 >= 1 and var0_27 <= var1_0 then
		arg0_27.stages:Find("stage" .. var0_27):GetComponent(typeof(Toggle)).isOn = true
	end
end

function var0_0.updateBattleView(arg0_28)
	if #arg0_28.breakIds < var1_0 then
		return
	end

	for iter0_28 = 1, var1_0 do
		local var0_28 = arg0_28.breakIds[iter0_28]
		local var1_28 = arg0_28.shipBreakOutCfg[var0_28]

		assert(var1_28, "不存在配置" .. var0_28)

		local var2_28 = arg0_28.stages:Find("stage" .. iter0_28)

		onToggle(arg0_28, var2_28, function(arg0_29)
			if arg0_29 then
				local var0_29 = var1_28.breakout_view
				local var1_29 = checkExist(pg.ship_data_template[var1_28.breakout_id], {
					"specific_type"
				}) or {}

				for iter0_29, iter1_29 in ipairs(var1_29) do
					var0_29 = var0_29 .. "/" .. i18n(ShipType.SpecificTableTips[iter1_29])
				end

				changeToScrollText(arg0_28.breakView, var0_29)
				arg0_28:switchStage(var0_28)
			end
		end, SFX_PANEL)
	end

	arg0_28.stages:Find("stage1"):GetComponent(typeof(Toggle)).group:SetAllTogglesOff()

	local var3_28 = table.indexof(arg0_28.breakIds, arg0_28.shipVO.configId)
	local var4_28 = math.clamp(var3_28, 1, var1_0)

	if var4_28 and var4_28 >= 1 and var4_28 <= var1_0 then
		local var5_28 = arg0_28.stages:Find("stage" .. var4_28)

		triggerToggle(var5_28, true)
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

function var0_0.showBarrage(arg0_30)
	arg0_30.previewer = WeaponPreviewer.New(arg0_30.rawImage)

	arg0_30.previewer:configUI(arg0_30.healTF)
	arg0_30.previewer:setDisplayWeapon(arg0_30:getWaponIdsById(arg0_30.breakOutId))
	arg0_30.previewer:load(40000, arg0_30.shipVO, arg0_30:getAllWeaponIds(), function()
		arg0_30:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_32, arg1_32)
	return arg0_32.shipBreakOutCfg[arg1_32].weapon_ids
end

function var0_0.switchStage(arg0_33, arg1_33)
	if arg0_33.breakOutId == arg1_33 then
		return
	end

	arg0_33.breakOutId = arg1_33

	if arg0_33.previewer then
		arg0_33.previewer:setDisplayWeapon(arg0_33:getWaponIdsById(arg0_33.breakOutId))
	end
end

function var0_0.getAllWeaponIds(arg0_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in ipairs(arg0_34.breakIds) do
		local var1_34 = Clone(arg0_34.shipBreakOutCfg[iter1_34].weapon_ids)
		local var2_34 = {
			__add = function(arg0_35, arg1_35)
				for iter0_35, iter1_35 in ipairs(arg0_35) do
					if not table.contains(arg1_35, iter1_35) then
						table.insert(arg1_35, iter1_35)
					end
				end

				return arg1_35
			end
		}

		setmetatable(var0_34, var2_34)

		var0_34 = var0_34 + var1_34
	end

	return var0_34
end

function var0_0.updateBreakOutView(arg0_36, arg1_36)
	arg0_36.breakCfg = arg0_36.shipBreakOutCfg[arg1_36.configId]

	for iter0_36, iter1_36 in ipairs(arg0_36.itemTFs) do
		setActive(iter1_36, false)
	end

	local var0_36 = arg1_36:getShipProperties()
	local var1_36 = Clone(arg1_36)

	var1_36.configId = arg0_36.breakCfg.breakout_id

	local var2_36 = {}
	local var3_36 = arg0_36.breakCfg.breakout_id == 0
	local var4_36 = arg1_36:getBattleTotalExpend()
	local var5_36
	local var6_36
	local var7_36 = arg0_36.tipDeactive:Find("values/label")
	local var8_36 = arg0_36.tipDeactive:Find("values/value")

	setText(var7_36, "")
	setText(var8_36, "")

	if var3_36 then
		var2_36 = var0_36
		var5_36 = var4_36

		setText(var7_36, i18n("word_level_upperLimit"))
	else
		var6_36 = arg0_36.shipTempCfg[arg0_36.breakCfg.breakout_id].max_level
		var2_36 = var1_36:getShipProperties()
		var2_36.level = var6_36 >= arg1_36:getMaxLevel() and var6_36 or arg1_36:getMaxLevel()
		var5_36 = var1_36:getBattleTotalExpend()

		setColorCount(var8_36, arg0_36.shipVO.level, arg0_36.breakCfg.level)
		setText(var7_36, i18n("word_level_require"))
	end

	local function var9_36(arg0_37, arg1_37)
		setText(arg0_37:Find("name"), arg1_37.name)
		setText(arg0_37:Find("value"), arg1_37.preAttr)

		local var0_37 = arg0_37:Find("value1")
		local var1_37 = arg0_37:Find("addition")
		local var2_37

		if arg1_37.afterAttr == 0 then
			var2_37 = setColorStr(arg1_37.afterAttr, "#FFFFFFFF")
		else
			var2_37 = setColorStr(arg1_37.afterAttr, COLOR_GREEN)
		end

		setText(var0_37, var2_37)
		setActive(var1_37, arg1_37.afterAttr - arg1_37.preAttr ~= 0)
		setText(var1_37, "(+" .. arg1_37.afterAttr - arg1_37.preAttr .. ")")
	end

	local var10_36 = 0

	if var6_36 and var6_36 ~= arg0_36.shipTempCfg[arg1_36.configId].max_level then
		local var11_36 = arg0_36.attrs:Find("attr_1")

		var9_36(var11_36, {
			preAttr = arg0_36.shipTempCfg[arg1_36.configId].max_level,
			afterAttr = var6_36,
			name = i18n("word_level_upperLimit")
		})

		var10_36 = 1
	end

	for iter2_36 = 1, #var2_0 do
		local var12_36 = arg0_36.attrs:Find("attr_" .. var10_36 + iter2_36)

		setActive(var12_36, true)

		local var13_36 = math.floor(var0_36[var2_0[iter2_36]])
		local var14_36 = math.floor(var2_36[var2_0[iter2_36]])

		var9_36(var12_36, {
			preAttr = var13_36,
			afterAttr = var14_36,
			name = i18n("word_attr_" .. var2_0[iter2_36])
		})
	end

	local var15_36 = var10_36 + #var2_0 + 1
	local var16_36 = arg0_36.attrs:Find("attr_" .. var15_36)

	setActive(var16_36, true)
	var9_36(var16_36, {
		preAttr = var4_36,
		afterAttr = var5_36,
		name = i18n("word_attr_luck")
	})

	for iter3_36 = var15_36 + 1, 8 do
		local var17_36 = arg0_36.attrs:Find("attr_" .. iter3_36)

		setActive(var17_36, false)
	end

	removeAllChildren(arg0_36.starsFrom)

	for iter4_36 = 1, arg1_36:getStar() do
		cloneTplTo(arg0_36.starTpl, arg0_36.starsFrom)
	end

	if var3_36 then
		return
	end

	removeAllChildren(arg0_36.starsTo)

	if var1_36:getStar() > arg1_36:getStar() and not var3_36 then
		for iter5_36 = 1, var1_36:getStar() do
			cloneTplTo(arg0_36.starTpl, arg0_36.starsTo)
		end
	end

	setActive(arg0_36.appendStarTips, var1_36:getStar() ~= arg1_36:getStar())
	setActive(arg0_36.starOpera, var1_36:getStar() ~= arg1_36:getStar())

	local var18_36 = arg0_36.breakCfg.use_gold

	if var18_36 > arg0_36.player.gold then
		var18_36 = "<color=#FB4A2C>" .. var18_36 .. "</color>"
	end

	setText(arg0_36.tipActive:Find("text"), var18_36)
	arg0_36:initMaterialShips()
end

function var0_0.initMaterialShips(arg0_38)
	local var0_38 = arg0_38.breakCfg.use_char_num
	local var1_38 = getProxy(BayProxy)

	for iter0_38 = 1, 3 do
		SetActive(arg0_38.itemTFs[iter0_38], iter0_38 <= var0_38)

		local var2_38 = arg0_38.itemTFs[iter0_38]:Find("IconTpl")
		local var3_38 = arg0_38.contextData.materialShipIds

		if iter0_38 <= var0_38 and var3_38 and var3_38[iter0_38] then
			local var4_38 = var1_38:getShipById(var3_38[iter0_38])

			updateShip(var2_38, var4_38, {
				initStar = true
			})
			SetActive(var2_38, true)
		else
			SetActive(var2_38, false)
		end

		onButton(arg0_38, arg0_38.itemTFs[iter0_38], function()
			arg0_38:emit(ShipUpgradeMediator2.ON_SELECT_SHIP, arg0_38.shipVO, var0_38)
		end)
	end
end

function var0_0.willExit(arg0_40)
	arg0_40:UnOverlayPanel(arg0_40._tf)
	arg0_40:recycleSpineChar()

	if arg0_40.previewer then
		arg0_40.previewer:clear()

		arg0_40.previewer = nil
	end

	if arg0_40.dragTrigger then
		ClearEventTrigger(arg0_40.dragTrigger)

		arg0_40.dragTrigger = nil
	end

	arg0_40.destroyConfirmWindow:Destroy()
end

function var0_0.playLoadingAni(arg0_41)
	setActive(arg0_41.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_42)
	setActive(arg0_42.seaLoading, false)
end

function var0_0.onBackPressed(arg0_43)
	if arg0_43.destroyConfirmWindow:isShowing() then
		arg0_43.destroyConfirmWindow:ActionInvoke("Hide")

		return
	end

	arg0_43:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0

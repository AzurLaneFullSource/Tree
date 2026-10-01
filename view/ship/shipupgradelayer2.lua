local var0_0 = class("ShipUpgradeLayer2", import("..base.BaseUI"))
local var1_0 = 3

function var0_0.getUIName(arg0_1)
	return "ShipBreakOutUI"
end

function var0_0.getGroupName(arg0_2)
	return "ShipMainScene"
end

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = getProxy(BayProxy):getShipById(arg1_3.shipId)
	local var1_3 = ys.Battle.BattleResourceManager.GetInstance()
	local var2_3 = var1_3.GetMapResource(40000)

	table.insertto(var2_3, var1_3.GetDisplayCommonResource())
	table.insertto(var2_3, var1_3.GetShipResource(var0_3.configId, var0_3.skinId))

	local var3_3 = {}
	local var4_3 = math.floor(var0_3.configId / 10)

	for iter0_3 = 1, 4 do
		table.insert(var3_3, tonumber(var4_3 .. iter0_3))
	end

	for iter1_3, iter2_3 in ipairs(var3_3) do
		for iter3_3, iter4_3 in ipairs(pg.ship_data_breakout[iter2_3].weapon_ids) do
			if iter4_3 ~= 0 then
				local var5_3 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter4_3)

				for iter5_3, iter6_3 in ipairs(var5_3.weapon_id) do
					table.insertto(var2_3, var1_3.GetWeaponResource(iter6_3))
				end
			end
		end
	end

	return table.insertto(var2_3, var0_0.super.getResource(arg0_3, arg1_3))
end

function var0_0.setItems(arg0_4, arg1_4)
	arg0_4.items = arg1_4
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5
end

function var0_0.init(arg0_6)
	arg0_6.leftPanel = arg0_6._tf:Find("blur_panel/left_panel")
	arg0_6.stages = arg0_6.leftPanel:Find("stageScrollRect/stages")

	setText(arg0_6.leftPanel:Find("bg/title/Image"), i18n("word_preview"))

	arg0_6.stagesSnap = arg0_6.leftPanel:Find("stageScrollRect"):GetComponent("HorizontalScrollSnap")
	arg0_6.breakView = arg0_6.leftPanel:Find("content/Text")
	arg0_6.rightPanel = arg0_6._tf:Find("blur_panel/right_panel")
	arg0_6.attrs = arg0_6.rightPanel:Find("top/attrs")
	arg0_6.starTpl = arg0_6.rightPanel:Find("top/rare/startpl")

	setActive(arg0_6.starTpl, false)

	arg0_6.starsFrom = arg0_6.rightPanel:Find("top/rare/stars_from")
	arg0_6.starsTo = arg0_6.rightPanel:Find("top/rare/stars_to")
	arg0_6.starOpera = arg0_6.rightPanel:Find("top/rare/opera")
	arg0_6.materials = arg0_6.rightPanel:Find("bottom/materials")
	arg0_6.breakOutBtn = arg0_6.rightPanel:Find("bottom/break_btn/tip_active/image")
	arg0_6.appendStarTips = arg0_6.rightPanel:Find("bottom/panel_title/tip")
	arg0_6.tipActive = arg0_6.rightPanel:Find("bottom/break_btn/tip_active")
	arg0_6.tipDeactive = arg0_6.rightPanel:Find("bottom/break_btn/tip_deactive")

	setText(arg0_6.rightPanel:Find("bottom/panel_title/tip"), i18n("breakout_tip"))
	setText(arg0_6.rightPanel:Find("bottom/break_btn/tip_deactive/values/ok"), i18n("text_confirm"))
	setText(arg0_6.rightPanel:Find("bottom/break_btn/tip_active/image/ok"), i18n("text_confirm"))

	arg0_6.recommandBtn = arg0_6.rightPanel:Find("bottom/auto_btn")
	arg0_6.isEnoughItems = true
	arg0_6.sea = arg0_6.leftPanel:Find("sea")
	arg0_6.rawImage = arg0_6.sea:GetComponent("RawImage")

	setActive(arg0_6.rawImage, false)

	arg0_6.healTF = arg0_6._tf:Find("resources/heal")
	arg0_6.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_6.healTF, false)

	arg0_6.qCharaContain = arg0_6.rightPanel:Find("top/panel_bg/q_chara")
	arg0_6.seaLoading = arg0_6.leftPanel:Find("bg/loading")

	arg0_6:playLoadingAni()

	arg0_6.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_6._tf, arg0_6.event)
end

function var0_0.loadChar(arg0_7)
	if not arg0_7.shipPrefab then
		local var0_7 = arg0_7.shipVO:getPrefab()

		pg.UIMgr.GetInstance():LoadingOn()

		local var1_7 = SpineAnimChar.New()

		var1_7:SetPaint(var0_7)
		var1_7:Load(true, function(arg0_8)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_7.shipPrefab = var0_7
			arg0_7.shipModel = arg0_8

			arg0_8:SetLocalScale(Vector3(0.8, 0.8, 1))
			arg0_8:SetParent(arg0_7.qCharaContain)
			arg0_8:SetAction("stand", 0)
		end)
	end
end

function var0_0.recycleSpineChar(arg0_9)
	if arg0_9.shipPrefab and arg0_9.shipModel then
		arg0_9.shipModel:Dispose()

		arg0_9.shipPrefab = nil
		arg0_9.shipModel = nil
	end
end

function var0_0.enabledToggles(arg0_10, arg1_10)
	eachChild(arg0_10.toggles, function(arg0_11)
		arg0_11:GetComponent("Toggle").enabled = arg1_10
	end)
end

function var0_0.addDragListenter(arg0_12)
	local var0_12 = GetOrAddComponent(arg0_12._tf, "EventTriggerListener")

	arg0_12.dragTrigger = var0_12

	local var1_12
	local var2_12 = 0

	var0_12:AddBeginDragFunc(function()
		var1_12 = nil
		var2_12 = 0
	end)
	var0_12:AddDragFunc(function(arg0_14, arg1_14)
		local var0_14 = arg1_14.position

		if not var1_12 then
			var1_12 = var0_14
		end

		var2_12 = var0_14.x - var1_12.x
	end)
	var0_12:AddDragEndFunc(function(arg0_15, arg1_15)
		if var2_12 < -50 then
			arg0_12:emit(ShipUpgradeMediator2.NEXTSHIP, -1)
		elseif var2_12 > 50 then
			arg0_12:emit(ShipUpgradeMediator2.NEXTSHIP)
		end
	end)
end

function var0_0.didEnter(arg0_16)
	arg0_16:BlurPanel(arg0_16._tf, {
		groupDelta = -1
	})
	arg0_16:addDragListenter()
	onButton(arg0_16, arg0_16.seaLoading, function()
		if not arg0_16.previewer then
			arg0_16:showBarrage()
		end
	end)
	onButton(arg0_16, arg0_16.breakOutBtn, function()
		local var0_18 = {}

		if arg0_16.shipVO:isActivityNpc() then
			table.insert(var0_18, function(arg0_19)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("npc_breakout_tip"),
					onYes = arg0_19
				})
			end)
		end

		seriesAsync(var0_18, function()
			local var0_20, var1_20 = ShipStatus.ShipStatusCheck("onModify", arg0_16.shipVO)

			if not var0_20 then
				pg.TipsMgr.GetInstance():ShowTips(var1_20)

				return
			end

			if arg0_16.breakCfg.breakout_id == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_maxLevel"))

				return
			end

			if arg0_16.shipVO.level < arg0_16.breakCfg.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_lvLimit"))

				return
			end

			if not arg0_16.isEnoughItems then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_error_noEnoughMatrail"))

				return
			end

			if arg0_16.player.gold < arg0_16.breakCfg.use_gold then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0_16.breakCfg.use_gold - arg0_16.player.gold,
						arg0_16.breakCfg.use_gold
					}
				})

				return
			end

			if not arg0_16.contextData.materialShipIds or #arg0_16.contextData.materialShipIds < arg0_16.breakCfg.use_char_num then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_upgradeStar_select_material_tip"))

				return
			end

			arg0_16:emit(ShipUpgradeMediator2.UPGRADE_SHIP, arg0_16.contextData.materialShipIds)
		end)
	end, SFX_CONFIRM)
	onButton(arg0_16, arg0_16.recommandBtn, function()
		local var0_21 = getProxy(BayProxy)

		if arg0_16.contextData.materialShipIds and #arg0_16.contextData.materialShipIds == arg0_16.breakCfg.use_char_num then
			return
		end

		local var1_21 = var0_21:getUpgradeRecommendShip(arg0_16.shipVO, arg0_16.contextData.materialShipIds or {}, arg0_16.breakCfg.use_char_num)

		if #var1_21 > 0 then
			local var2_21 = {}

			table.insert(var2_21, function(arg0_22)
				local var0_22, var1_22 = ShipCalcHelper.GetEliteAndHightLevelShips(underscore.map(var1_21, function(arg0_23)
					return var0_21:getShipById(arg0_23)
				end))

				if #var0_22 > 0 or #var1_22 > 0 then
					arg0_16.destroyConfirmWindow:ExecuteAction("Show", var0_22, var1_22, false, arg0_22)
				else
					arg0_22()
				end
			end)
			seriesAsync(var2_21, function()
				arg0_16.contextData.materialShipIds = var1_21

				arg0_16:updateBreakOutView(arg0_16.shipVO)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("without_selected_ship"))
		end
	end, SFX_CONFIRM)
	arg0_16:initMaterialShips()
end

function var0_0.getMaterialShip(arg0_25, arg1_25)
	local var0_25

	for iter0_25 = #arg1_25, 1, -1 do
		if not arg1_25[iter0_25]:isTestShip() then
			var0_25 = iter0_25

			break
		end
	end

	var0_25 = var0_25 or #arg1_25

	return var0_25
end

function var0_0.setShip(arg0_26, arg1_26)
	arg0_26.shipVO = arg1_26
	arg0_26.shipTempCfg = pg.ship_data_template
	arg0_26.shipBreakOutCfg = pg.ship_data_breakout
	arg0_26.breakIds = arg0_26:getStages()
	arg0_26.itemTFs = {}

	for iter0_26 = 1, 3 do
		arg0_26.itemTFs[iter0_26] = arg0_26.materials:Find("item_" .. iter0_26)
	end

	arg0_26:updateBattleView()
	arg0_26:updateBreakOutView(arg0_26.shipVO)

	local var0_26 = arg0_26.shipVO.level < arg0_26.breakCfg.level or arg0_26.breakCfg.breakout_id == 0

	setActive(arg0_26.tipActive, not var0_26)
	setActive(arg0_26.tipDeactive, var0_26)
	setButtonEnabled(arg0_26.breakOutBtn, not var0_26)
	setActive(arg0_26.recommandBtn, arg0_26.breakCfg.breakout_id ~= 0)
	arg0_26:loadChar()
end

function var0_0.getStages(arg0_27)
	local var0_27 = {}
	local var1_27 = math.floor(arg0_27.shipVO.configId / 10)

	for iter0_27 = 1, 4 do
		local var2_27 = tonumber(var1_27 .. iter0_27)

		assert(arg0_27.shipBreakOutCfg[var2_27], "必须存在配置" .. var2_27)
		table.insert(var0_27, var2_27)
	end

	return var0_27
end

function var0_0.updateStagesScrollView(arg0_28)
	local var0_28 = table.indexof(arg0_28.breakIds, arg0_28.shipVO.configId)

	if var0_28 and var0_28 >= 1 and var0_28 <= var1_0 then
		arg0_28.stages:Find("stage" .. var0_28):GetComponent(typeof(Toggle)).isOn = true
	end
end

function var0_0.updateBattleView(arg0_29)
	if #arg0_29.breakIds < var1_0 then
		return
	end

	for iter0_29 = 1, var1_0 do
		local var0_29 = arg0_29.breakIds[iter0_29]
		local var1_29 = arg0_29.shipBreakOutCfg[var0_29]

		assert(var1_29, "不存在配置" .. var0_29)

		local var2_29 = arg0_29.stages:Find("stage" .. iter0_29)

		onToggle(arg0_29, var2_29, function(arg0_30)
			if arg0_30 then
				local var0_30 = var1_29.breakout_view
				local var1_30 = checkExist(pg.ship_data_template[var1_29.breakout_id], {
					"specific_type"
				}) or {}

				for iter0_30, iter1_30 in ipairs(var1_30) do
					var0_30 = var0_30 .. "/" .. i18n(ShipType.SpecificTableTips[iter1_30])
				end

				changeToScrollText(arg0_29.breakView, var0_30)
				arg0_29:switchStage(var0_29)
			end
		end, SFX_PANEL)
	end

	arg0_29.stages:Find("stage1"):GetComponent(typeof(Toggle)).group:SetAllTogglesOff()

	local var3_29 = table.indexof(arg0_29.breakIds, arg0_29.shipVO.configId)
	local var4_29 = math.clamp(var3_29, 1, var1_0)

	if var4_29 and var4_29 >= 1 and var4_29 <= var1_0 then
		local var5_29 = arg0_29.stages:Find("stage" .. var4_29)

		triggerToggle(var5_29, true)
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

function var0_0.showBarrage(arg0_31)
	arg0_31.previewer = WeaponPreviewer.New(arg0_31.rawImage)

	arg0_31.previewer:configUI(arg0_31.healTF)
	arg0_31.previewer:setDisplayWeapon(arg0_31:getWaponIdsById(arg0_31.breakOutId))
	arg0_31.previewer:load(40000, arg0_31.shipVO, arg0_31:getAllWeaponIds(), function()
		arg0_31:stopLoadingAni()
	end)
end

function var0_0.getWaponIdsById(arg0_33, arg1_33)
	return arg0_33.shipBreakOutCfg[arg1_33].weapon_ids
end

function var0_0.switchStage(arg0_34, arg1_34)
	if arg0_34.breakOutId == arg1_34 then
		return
	end

	arg0_34.breakOutId = arg1_34

	if arg0_34.previewer then
		arg0_34.previewer:setDisplayWeapon(arg0_34:getWaponIdsById(arg0_34.breakOutId))
	end
end

function var0_0.getAllWeaponIds(arg0_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.breakIds) do
		local var1_35 = Clone(arg0_35.shipBreakOutCfg[iter1_35].weapon_ids)
		local var2_35 = {
			__add = function(arg0_36, arg1_36)
				for iter0_36, iter1_36 in ipairs(arg0_36) do
					if not table.contains(arg1_36, iter1_36) then
						table.insert(arg1_36, iter1_36)
					end
				end

				return arg1_36
			end
		}

		setmetatable(var0_35, var2_35)

		var0_35 = var0_35 + var1_35
	end

	return var0_35
end

function var0_0.updateBreakOutView(arg0_37, arg1_37)
	arg0_37.breakCfg = arg0_37.shipBreakOutCfg[arg1_37.configId]

	for iter0_37, iter1_37 in ipairs(arg0_37.itemTFs) do
		setActive(iter1_37, false)
	end

	local var0_37 = arg1_37:getShipProperties()
	local var1_37 = Clone(arg1_37)

	var1_37.configId = arg0_37.breakCfg.breakout_id

	local var2_37 = {}
	local var3_37 = arg0_37.breakCfg.breakout_id == 0
	local var4_37 = arg1_37:getBattleTotalExpend()
	local var5_37
	local var6_37
	local var7_37 = arg0_37.tipDeactive:Find("values/label")
	local var8_37 = arg0_37.tipDeactive:Find("values/value")

	setText(var7_37, "")
	setText(var8_37, "")

	if var3_37 then
		var2_37 = var0_37
		var5_37 = var4_37

		setText(var7_37, i18n("word_level_upperLimit"))
	else
		var6_37 = arg0_37.shipTempCfg[arg0_37.breakCfg.breakout_id].max_level
		var2_37 = var1_37:getShipProperties()
		var2_37.level = var6_37 >= arg1_37:getMaxLevel() and var6_37 or arg1_37:getMaxLevel()
		var5_37 = var1_37:getBattleTotalExpend()

		setColorCount(var8_37, arg0_37.shipVO.level, arg0_37.breakCfg.level)
		setText(var7_37, i18n("word_level_require"))
	end

	local function var9_37(arg0_38, arg1_38)
		setText(arg0_38:Find("name"), arg1_38.name)
		setText(arg0_38:Find("value"), arg1_38.preAttr)

		local var0_38 = arg0_38:Find("value1")
		local var1_38 = arg0_38:Find("addition")
		local var2_38

		if arg1_38.afterAttr == 0 then
			var2_38 = setColorStr(arg1_38.afterAttr, "#FFFFFFFF")
		else
			var2_38 = setColorStr(arg1_38.afterAttr, COLOR_GREEN)
		end

		setText(var0_38, var2_38)
		setActive(var1_38, arg1_38.afterAttr - arg1_38.preAttr ~= 0)
		setText(var1_38, "(+" .. arg1_38.afterAttr - arg1_38.preAttr .. ")")
	end

	local var10_37 = 0

	if var6_37 and var6_37 ~= arg0_37.shipTempCfg[arg1_37.configId].max_level then
		local var11_37 = arg0_37.attrs:Find("attr_1")

		var9_37(var11_37, {
			preAttr = arg0_37.shipTempCfg[arg1_37.configId].max_level,
			afterAttr = var6_37,
			name = i18n("word_level_upperLimit")
		})

		var10_37 = 1
	end

	for iter2_37 = 1, #var2_0 do
		local var12_37 = arg0_37.attrs:Find("attr_" .. var10_37 + iter2_37)

		setActive(var12_37, true)

		local var13_37 = math.floor(var0_37[var2_0[iter2_37]])
		local var14_37 = math.floor(var2_37[var2_0[iter2_37]])

		var9_37(var12_37, {
			preAttr = var13_37,
			afterAttr = var14_37,
			name = i18n("word_attr_" .. var2_0[iter2_37])
		})
	end

	local var15_37 = var10_37 + #var2_0 + 1
	local var16_37 = arg0_37.attrs:Find("attr_" .. var15_37)

	setActive(var16_37, true)
	var9_37(var16_37, {
		preAttr = var4_37,
		afterAttr = var5_37,
		name = i18n("word_attr_luck")
	})

	for iter3_37 = var15_37 + 1, 8 do
		local var17_37 = arg0_37.attrs:Find("attr_" .. iter3_37)

		setActive(var17_37, false)
	end

	removeAllChildren(arg0_37.starsFrom)

	for iter4_37 = 1, arg1_37:getStar() do
		cloneTplTo(arg0_37.starTpl, arg0_37.starsFrom)
	end

	if var3_37 then
		return
	end

	removeAllChildren(arg0_37.starsTo)

	if var1_37:getStar() > arg1_37:getStar() and not var3_37 then
		for iter5_37 = 1, var1_37:getStar() do
			cloneTplTo(arg0_37.starTpl, arg0_37.starsTo)
		end
	end

	setActive(arg0_37.appendStarTips, var1_37:getStar() ~= arg1_37:getStar())
	setActive(arg0_37.starOpera, var1_37:getStar() ~= arg1_37:getStar())

	local var18_37 = arg0_37.breakCfg.use_gold

	if var18_37 > arg0_37.player.gold then
		var18_37 = "<color=#FB4A2C>" .. var18_37 .. "</color>"
	end

	setText(arg0_37.tipActive:Find("text"), var18_37)
	arg0_37:initMaterialShips()
end

function var0_0.initMaterialShips(arg0_39)
	local var0_39 = arg0_39.breakCfg.use_char_num
	local var1_39 = getProxy(BayProxy)

	for iter0_39 = 1, 3 do
		SetActive(arg0_39.itemTFs[iter0_39], iter0_39 <= var0_39)

		local var2_39 = arg0_39.itemTFs[iter0_39]:Find("IconTpl")
		local var3_39 = arg0_39.contextData.materialShipIds

		if iter0_39 <= var0_39 and var3_39 and var3_39[iter0_39] then
			local var4_39 = var1_39:getShipById(var3_39[iter0_39])

			updateShip(var2_39, var4_39, {
				initStar = true
			})
			SetActive(var2_39, true)
		else
			SetActive(var2_39, false)
		end

		onButton(arg0_39, arg0_39.itemTFs[iter0_39], function()
			arg0_39:emit(ShipUpgradeMediator2.ON_SELECT_SHIP, arg0_39.shipVO, var0_39)
		end)
	end
end

function var0_0.willExit(arg0_41)
	arg0_41:UnOverlayPanel(arg0_41._tf)
	arg0_41:recycleSpineChar()

	if arg0_41.previewer then
		arg0_41.previewer:clear()

		arg0_41.previewer = nil
	end

	if arg0_41.dragTrigger then
		ClearEventTrigger(arg0_41.dragTrigger)

		arg0_41.dragTrigger = nil
	end

	arg0_41.destroyConfirmWindow:Destroy()
end

function var0_0.playLoadingAni(arg0_42)
	setActive(arg0_42.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_43)
	setActive(arg0_43.seaLoading, false)
end

function var0_0.onBackPressed(arg0_44)
	if arg0_44.destroyConfirmWindow:isShowing() then
		arg0_44.destroyConfirmWindow:ActionInvoke("Hide")

		return
	end

	arg0_44:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0

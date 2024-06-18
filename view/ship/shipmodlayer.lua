local var0_0 = class("ShipModLayer", import("..base.BaseUI"))
local var1_0 = 12

var0_0.IGNORE_ID = 4

function var0_0.getUIName(arg0_1)
	return "ShipModUI"
end

function var0_0.setShipVOs(arg0_2, arg1_2)
	arg0_2.shipVOs = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.blurPanelTF = arg0_3:findTF("blur_panel")
	arg0_3.mainPanel = arg0_3:findTF("blur_panel/main")
	arg0_3.shipContainer = arg0_3:findTF("bg/add_ship_panel/ships", arg0_3.mainPanel)
	arg0_3.attrsPanel = arg0_3:findTF("bg/property_panel/attrs", arg0_3.mainPanel)

	setText(arg0_3:findTF("bg/add_ship_panel/title/tip", arg0_3.mainPanel), i18n("ship_mod_exp_to_attr_tip"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("ok_btn", arg0_4.mainPanel), function()
		local function var0_5()
			local var0_6, var1_6 = ShipStatus.ShipStatusCheck("onModify", arg0_4.shipVO)

			if not var0_6 then
				pg.TipsMgr.GetInstance():ShowTips(var1_6)

				return
			end

			if not arg0_4.contextData.materialShipIds or #arg0_4.contextData.materialShipIds == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

				return
			else
				arg0_4:startModShip()
			end
		end

		if arg0_4.shipVO:isActivityNpc() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("npc_strength_tip"),
				onYes = var0_5
			})
		else
			var0_5()
		end
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4:findTF("cancel_btn", arg0_4.mainPanel), function()
		local var0_7 = arg0_4.contextData.materialShipIds

		if not var0_7 or table.getCount(var0_7) == 0 then
			return
		end

		arg0_4:clearAllShip()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("select_btn", arg0_4.mainPanel), function()
		arg0_4:emit(ShipModMediator.ON_AUTO_SELECT_SHIP)
	end, SFX_CANCEL)
	arg0_4:initAttrs()

	arg0_4.inited = true

	arg0_4:emit(ShipModMediator.LOADEND, arg0_4.mainPanel)
	arg0_4:blurPanel(true)
end

function var0_0.blurPanel(arg0_9, arg1_9)
	local var0_9 = pg.UIMgr.GetInstance()

	if arg1_9 then
		var0_9:OverlayPanelPB(arg0_9.blurPanelTF, {
			pbList = {
				arg0_9.mainPanel:Find("bg")
			},
			groupName = arg0_9:getGroupNameFromData(),
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		var0_9:UnOverlayPanel(arg0_9.blurPanelTF, arg0_9._tf)
	end
end

function var0_0.startModShip(arg0_10)
	if not arg0_10.hasAddition then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_mod_no_addition_tip"),
			onYes = function()
				arg0_10:emit(ShipModMediator.MOD_SHIP, arg0_10.shipVO.id)
			end
		})
	else
		arg0_10:emit(ShipModMediator.MOD_SHIP, arg0_10.shipVO.id)
	end
end

function var0_0.setShip(arg0_12, arg1_12)
	arg0_12.shipVO = arg1_12

	arg0_12:initSelectedShips()

	if arg0_12.inited then
		arg0_12:initAttrs()
	end
end

function var0_0.clearAllShip(arg0_13)
	for iter0_13 = 1, var1_0 do
		local var0_13 = arg0_13.shipContainer:GetChild(iter0_13 - 1)

		setActive(var0_13:Find("IconTpl"), false)
		onButton(arg0_13, var0_13:Find("add"), function()
			arg0_13:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
		end, SFX_PANEL)
	end

	arg0_13.contextData.materialShipIds = nil

	arg0_13:updateAttrs()
end

function var0_0.initSelectedShips(arg0_15)
	local var0_15 = arg0_15.contextData.materialShipIds or {}
	local var1_15 = table.getCount(var0_15)

	for iter0_15 = 1, var1_0 do
		local var2_15 = arg0_15.shipContainer:GetChild(iter0_15 - 1)

		if iter0_15 <= var1_15 then
			arg0_15:updateShip(var2_15, var0_15[iter0_15])
		else
			onButton(arg0_15, var2_15:Find("add"), function()
				arg0_15:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
			end, SFX_PANEL)
		end

		setActive(var2_15:Find("IconTpl"), iter0_15 <= var1_15)
	end
end

function var0_0.updateShip(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.shipVOs[arg2_17]

	onButton(arg0_17, arg1_17, function()
		for iter0_18, iter1_18 in ipairs(arg0_17.contextData.materialShipIds) do
			if arg2_17 == iter1_18 then
				local var0_18 = arg1_17:Find("add")

				setActive(arg1_17:Find("IconTpl"), false)
				onButton(arg0_17, var0_18, function()
					arg0_17:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
				end, SFX_PANEL)
				table.remove(arg0_17.contextData.materialShipIds, iter0_18)
				arg0_17:updateAttrs()

				break
			end
		end
	end, SFX_PANEL)
	updateShip(arg0_17:findTF("IconTpl", arg1_17), var0_17, {
		initStar = true
	})
	setText(arg1_17:Find("IconTpl/icon_bg/lv/Text"), var0_17.level)
end

function var0_0.initAttrs(arg0_20)
	arg0_20.attrTFs = {}

	for iter0_20, iter1_20 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_20.IGNORE_ID ~= iter0_20 then
			local var0_20 = arg0_20.attrsPanel:Find("attr_" .. iter0_20)

			arg0_20.attrTFs[iter0_20] = var0_20
		end
	end

	arg0_20:updateAttrs()
end

function var0_0.updateAttrs(arg0_21)
	arg0_21.hasAddition = nil

	for iter0_21, iter1_21 in pairs(arg0_21.attrTFs) do
		arg0_21:updateAttr(iter0_21)
	end
end

function var0_0.updateAttr(arg0_22, arg1_22)
	local var0_22 = arg0_22.attrTFs[arg1_22]
	local var1_22 = arg0_22:findTF("info", var0_22)
	local var2_22 = var0_22:GetComponent(typeof(CanvasGroup))
	local var3_22 = ShipModAttr.ID_TO_ATTR[arg1_22]
	local var4_22 = arg0_22.shipVO:getModAttrTopLimit(var3_22)
	local var5_22 = intProperties(arg0_22.shipVO:getShipProperties())
	local var6_22 = arg0_22:getMaterialShips(arg0_22.contextData.materialShipIds)
	local var7_22 = var0_0.getExpAddition(arg0_22.shipVO, var6_22, var3_22)
	local var8_22 = arg0_22.shipVO:getModExpRatio(var3_22)
	local var9_22 = math.max(arg0_22.shipVO:getModExpRatio(var3_22), 1)

	if var7_22 ~= 0 then
		arg0_22.hasAddition = true
	end

	local var10_22 = arg0_22.shipVO:getModAttrBaseMax(var3_22)
	local var11_22 = arg0_22.getRemainExp(arg0_22.shipVO, var3_22)
	local var12_22 = math.max(math.min(math.floor((var11_22 + var7_22) / var9_22), var10_22 - var5_22[var3_22]), 0)

	setText(arg0_22:findTF("info_container/addition", var1_22), "+" .. var12_22)
	setText(arg0_22:findTF("info_container/name", var1_22), AttributeType.Type2Name(var3_22))
	setText(arg0_22:findTF("max_container/Text", var1_22), var10_22)
	setText(arg0_22:findTF("info_container/value", var1_22), var5_22[var3_22])

	var2_22.alpha = var5_22[var3_22] == 0 and 0.3 or 1

	local var13_22 = arg0_22:findTF("prev_slider", var1_22):GetComponent(typeof(Slider))

	arg0_22:setSliderValue(var13_22, (var7_22 + var11_22) / var9_22)

	local var14_22 = var11_22 / var9_22
	local var15_22 = var11_22 + var7_22 .. "/" .. var8_22

	if var10_22 == var5_22[var3_22] and var5_22[var3_22] ~= 0 then
		var14_22 = 1
		var15_22 = "MAX"
	end

	local var16_22 = arg0_22:findTF("cur_slider", var1_22):GetComponent(typeof(Slider))

	arg0_22:setSliderValue(var16_22, var14_22)
	setText(arg0_22:findTF("exp_container/Text", var0_22), var15_22)
end

function var0_0.modAttrAnim(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg3_23 or 0.3
	local var1_23 = intProperties(arg1_23:getShipProperties())
	local var2_23 = intProperties(arg2_23:getShipProperties())

	arg0_23.tweens = {}

	for iter0_23, iter1_23 in pairs(arg0_23.attrTFs) do
		local var3_23 = ShipModAttr.ID_TO_ATTR[iter0_23]
		local var4_23 = arg1_23:getModAttrTopLimit(var3_23)
		local var5_23 = arg0_23.shipVO:getModAttrBaseMax(var3_23)

		if var4_23 == 0 then
			arg0_23:updateAttr(iter0_23)
		else
			local var6_23 = arg0_23.attrTFs[iter0_23]
			local var7_23 = arg0_23:findTF("info", var6_23)
			local var8_23 = arg0_23:findTF("info_container/value", var7_23)
			local var9_23 = var1_23[var3_23] - var2_23[var3_23]
			local var10_23 = math.max(arg1_23:getModExpRatio(var3_23), 1)
			local var11_23 = arg0_23:findTF("cur_slider", var7_23)
			local var12_23 = arg0_23:findTF("prev_slider", var7_23)
			local var13_23 = var11_23:GetComponent(typeof(Slider))
			local var14_23 = var12_23:GetComponent(typeof(Slider))
			local var15_23 = arg0_23.getRemainExp(arg1_23, var3_23)
			local var16_23 = arg0_23:findTF("info_container/addition", var7_23)
			local var17_23 = arg0_23:findTF("exp_container/Text", var6_23)

			arg0_23:setSliderValue(var14_23, 0)
			setText(arg0_23:findTF("exp_container/Text", var6_23), var15_23 .. "/" .. var10_23)

			local function var18_23(arg0_24, arg1_24)
				setText(var8_23, arg0_24)
				setText(var16_23, "+" .. arg1_24)
			end

			if var9_23 >= 1 then
				local var19_23 = var2_23[var3_23]

				arg0_23:tweenValue(var13_23, var13_23.value, 1, var0_23, nil, function(arg0_25)
					arg0_23:setSliderValue(var13_23, arg0_25)
				end, function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

					var19_23 = var19_23 + 1

					var18_23(var19_23, var1_23[var3_23] - var19_23)

					local var0_26 = var1_23[var3_23] - var19_23

					if var0_26 > 0 then
						arg0_23:tweenValue(var13_23, 0, 1, var0_23, nil, function(arg0_27)
							arg0_23:setSliderValue(var13_23, arg0_27)
						end, function()
							pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

							var19_23 = var19_23 + 1

							var18_23(var19_23, var1_23[var3_23] - var19_23)

							if var19_23 == var1_23[var3_23] then
								arg0_23:tweenValue(var13_23, 0, var15_23 / var10_23, var0_23, nil, function(arg0_29)
									arg0_23:setSliderValue(var13_23, arg0_29)
								end, function()
									if var5_23 == var1_23[var3_23] then
										arg0_23:setSliderValue(var13_23, 1)
										setText(var17_23, "MAX")
									end
								end)
							end
						end, var0_26)
					else
						arg0_23:tweenValue(var13_23, 0, var15_23 / var10_23, var0_23, nil, function(arg0_31)
							arg0_23:setSliderValue(var13_23, arg0_31)
						end, function()
							if var5_23 == var1_23[var3_23] then
								arg0_23:setSliderValue(var13_23, 1)
								setText(var17_23, "MAX")
							end
						end)
					end
				end)
			else
				arg0_23:tweenValue(var13_23, var13_23.value, var15_23 / var10_23, var0_23, nil, function(arg0_33)
					arg0_23:setSliderValue(var13_23, arg0_33)
				end, function()
					if var5_23 == var1_23[var3_23] then
						arg0_23:setSliderValue(var13_23, 1)
						setText(var17_23, "MAX")
					end
				end)
			end
		end
	end
end

function var0_0.tweenValue(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35, arg5_35, arg6_35, arg7_35, arg8_35)
	assert(not arg0_35.exited, "tween after ui exited")

	if not arg0_35.tweens then
		return
	end

	arg0_35.tweens[arg1_35] = arg1_35

	LeanTween.cancel(go(arg1_35))

	local var0_35 = LeanTween.value(go(arg1_35), arg2_35, arg3_35, arg4_35):setOnUpdate(System.Action_float(function(arg0_36)
		if arg6_35 then
			arg6_35(arg0_36)
		end
	end)):setDelay(arg5_35 or 0):setOnComplete(System.Action(function()
		if arg7_35 then
			arg7_35()
		end
	end))

	if arg8_35 and arg8_35 > 0 then
		var0_35:setRepeat(arg8_35)
	end
end

function var0_0.getBuffExp()
	local var0_38 = BuffHelper.GetShipModExpBuff()
	local var1_38 = 0

	for iter0_38, iter1_38 in ipairs(var0_38) do
		var1_38 = math.max(iter1_38 and iter1_38:getConfig("benefit_effect") / 100 or 0, var1_38)
	end

	return var1_38
end

function var0_0.getModExpAdditions(arg0_39, arg1_39)
	local var0_39 = pg.ship_data_template
	local var1_39 = var0_39[arg0_39.configId].group_type
	local var2_39 = pg.ship_data_strengthen
	local var3_39 = {}
	local var4_39 = var0_0.getBuffExp()

	for iter0_39, iter1_39 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var5_39 = 0

		if iter0_39 ~= ShipModLayer.IGNORE_ID then
			for iter2_39, iter3_39 in pairs(arg1_39) do
				local var6_39 = var0_39[iter3_39.configId]
				local var7_39 = var6_39.strengthen_id

				assert(var2_39[var7_39], "ship_data_strengthen>>" .. var7_39)

				local var8_39 = var2_39[var7_39].attr_exp[iter0_39 - 1]

				if var6_39.group_type == var1_39 then
					var8_39 = var8_39 * 2
				end

				var5_39 = var5_39 + var8_39
			end
		end

		var3_39[iter1_39] = math.floor(var5_39 * (1 + var4_39))
	end

	return var3_39
end

function var0_0.getMaterialShips(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in ipairs(arg1_40 or {}) do
		table.insert(var0_40, arg0_40.shipVOs[iter1_40])
	end

	return var0_40
end

function var0_0.getExpAddition(arg0_41, arg1_41, arg2_41)
	local var0_41 = var0_0.getModExpAdditions(arg0_41, arg1_41)

	if arg0_41:getModAttrTopLimit(arg2_41) == 0 then
		return 0, 0
	else
		local var1_41 = Clone(arg0_41)

		var1_41:addModAttrExp(arg2_41, var0_41[arg2_41])

		return var1_41:getModProperties(arg2_41) - arg0_41:getModProperties(arg2_41)
	end
end

function var0_0.getRemainExp(arg0_42, arg1_42)
	local var0_42 = math.max(arg0_42:getModExpRatio(arg1_42), 1)

	return arg0_42:getModProperties(arg1_42) % var0_42
end

function var0_0.setSliderValue(arg0_43, arg1_43, arg2_43)
	arg1_43.value = arg2_43 == 0 and arg2_43 or math.max(arg2_43, 0.08)
end

function var0_0.willExit(arg0_44)
	arg0_44:blurPanel(false)

	for iter0_44, iter1_44 in pairs(arg0_44.tweens or {}) do
		LeanTween.cancel(go(iter1_44))
	end

	arg0_44.tweens = nil
end

function var0_0.onBackPressed(arg0_45)
	arg0_45:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0

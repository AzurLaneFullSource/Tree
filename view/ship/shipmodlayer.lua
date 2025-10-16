local var0_0 = class("ShipModLayer", import("..base.BaseUI"))
local var1_0 = 12

var0_0.IGNORE_ID = 4

function var0_0.getUIName(arg0_1)
	return "ShipModUI"
end

function var0_0.getGroupName(arg0_2)
	return "ShipMainScene"
end

function var0_0.setShipVOs(arg0_3, arg1_3)
	arg0_3.shipVOs = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.blurPanelTF = arg0_4._tf:Find("blur_panel")
	arg0_4.mainPanel = arg0_4._tf:Find("blur_panel/main")
	arg0_4.shipContainer = arg0_4.mainPanel:Find("bg/add_ship_panel/ships")
	arg0_4.attrsPanel = arg0_4.mainPanel:Find("bg/property_panel/attrs")

	setText(arg0_4.mainPanel:Find("bg/add_ship_panel/title/tip"), i18n("ship_mod_exp_to_attr_tip"))
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.mainPanel:Find("ok_btn"), function()
		local function var0_6()
			local var0_7, var1_7 = ShipStatus.ShipStatusCheck("onModify", arg0_5.shipVO)

			if not var0_7 then
				pg.TipsMgr.GetInstance():ShowTips(var1_7)

				return
			end

			if not arg0_5.contextData.materialShipIds or #arg0_5.contextData.materialShipIds == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

				return
			else
				arg0_5:startModShip()
			end
		end

		if arg0_5.shipVO:isActivityNpc() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("npc_strength_tip"),
				onYes = var0_6
			})
		else
			var0_6()
		end
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.mainPanel:Find("cancel_btn"), function()
		local var0_8 = arg0_5.contextData.materialShipIds

		if not var0_8 or table.getCount(var0_8) == 0 then
			return
		end

		arg0_5:clearAllShip()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.mainPanel:Find("select_btn"), function()
		arg0_5:emit(ShipModMediator.ON_AUTO_SELECT_SHIP)
	end, SFX_CANCEL)
	arg0_5:initAttrs()

	arg0_5.inited = true

	arg0_5:emit(ShipModMediator.LOADEND, arg0_5.mainPanel)
	arg0_5:blurPanel(true)
end

function var0_0.blurPanel(arg0_10, arg1_10)
	if arg1_10 then
		arg0_10:OverlayPanel(arg0_10.blurPanelTF, {
			pbList = {
				arg0_10.mainPanel:Find("bg")
			},
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_10:UnOverlayPanel(arg0_10.blurPanelTF, arg0_10._tf)
	end
end

function var0_0.startModShip(arg0_11)
	if not arg0_11.hasAddition then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_mod_no_addition_tip"),
			onYes = function()
				arg0_11:emit(ShipModMediator.MOD_SHIP, arg0_11.shipVO.id)
			end
		})
	else
		arg0_11:emit(ShipModMediator.MOD_SHIP, arg0_11.shipVO.id)
	end
end

function var0_0.setShip(arg0_13, arg1_13)
	arg0_13.shipVO = arg1_13

	arg0_13:initSelectedShips()

	if arg0_13.inited then
		arg0_13:initAttrs()
	end
end

function var0_0.clearAllShip(arg0_14)
	for iter0_14 = 1, var1_0 do
		local var0_14 = arg0_14.shipContainer:GetChild(iter0_14 - 1)

		setActive(var0_14:Find("IconTpl"), false)
		onButton(arg0_14, var0_14:Find("add"), function()
			arg0_14:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
		end, SFX_PANEL)
	end

	arg0_14.contextData.materialShipIds = nil

	arg0_14:updateAttrs()
end

function var0_0.initSelectedShips(arg0_16)
	local var0_16 = arg0_16.contextData.materialShipIds or {}
	local var1_16 = table.getCount(var0_16)

	for iter0_16 = 1, var1_0 do
		local var2_16 = arg0_16.shipContainer:GetChild(iter0_16 - 1)

		if iter0_16 <= var1_16 then
			arg0_16:updateShip(var2_16, var0_16[iter0_16])
		else
			onButton(arg0_16, var2_16:Find("add"), function()
				arg0_16:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
			end, SFX_PANEL)
		end

		setActive(var2_16:Find("IconTpl"), iter0_16 <= var1_16)
	end
end

function var0_0.updateShip(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.shipVOs[arg2_18]

	onButton(arg0_18, arg1_18, function()
		for iter0_19, iter1_19 in ipairs(arg0_18.contextData.materialShipIds) do
			if arg2_18 == iter1_19 then
				local var0_19 = arg1_18:Find("add")

				setActive(arg1_18:Find("IconTpl"), false)
				onButton(arg0_18, var0_19, function()
					arg0_18:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
				end, SFX_PANEL)
				table.remove(arg0_18.contextData.materialShipIds, iter0_19)
				arg0_18:updateAttrs()

				break
			end
		end
	end, SFX_PANEL)
	updateShip(arg1_18:Find("IconTpl"), var0_18, {
		initStar = true
	})
	setText(arg1_18:Find("IconTpl/icon_bg/lv/Text"), var0_18.level)
end

function var0_0.initAttrs(arg0_21)
	arg0_21.attrTFs = {}

	for iter0_21, iter1_21 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_21.IGNORE_ID ~= iter0_21 then
			local var0_21 = arg0_21.attrsPanel:Find("attr_" .. iter0_21)

			arg0_21.attrTFs[iter0_21] = var0_21
		end
	end

	arg0_21:updateAttrs()
end

function var0_0.updateAttrs(arg0_22)
	arg0_22.hasAddition = nil

	for iter0_22, iter1_22 in pairs(arg0_22.attrTFs) do
		arg0_22:updateAttr(iter0_22)
	end
end

function var0_0.updateAttr(arg0_23, arg1_23)
	local var0_23 = arg0_23.attrTFs[arg1_23]
	local var1_23 = var0_23:Find("info")
	local var2_23 = var0_23:GetComponent(typeof(CanvasGroup))
	local var3_23 = ShipModAttr.ID_TO_ATTR[arg1_23]
	local var4_23 = arg0_23.shipVO:getModAttrTopLimit(var3_23)
	local var5_23 = intProperties(arg0_23.shipVO:getShipProperties())
	local var6_23 = arg0_23:getMaterialShips(arg0_23.contextData.materialShipIds)
	local var7_23 = var0_0.getExpAddition(arg0_23.shipVO, var6_23, var3_23)
	local var8_23 = arg0_23.shipVO:getModExpRatio(var3_23)
	local var9_23 = math.max(arg0_23.shipVO:getModExpRatio(var3_23), 1)

	if var7_23 ~= 0 then
		arg0_23.hasAddition = true
	end

	local var10_23 = arg0_23.shipVO:getModAttrBaseMax(var3_23)
	local var11_23 = arg0_23.getRemainExp(arg0_23.shipVO, var3_23)
	local var12_23 = math.max(math.min(math.floor((var11_23 + var7_23) / var9_23), var10_23 - var5_23[var3_23]), 0)

	setText(var1_23:Find("info_container/addition"), "+" .. var12_23)
	setText(var1_23:Find("info_container/name"), AttributeType.Type2Name(var3_23))
	setText(var1_23:Find("max_container/Text"), var10_23)
	setText(var1_23:Find("info_container/value"), var5_23[var3_23])

	var2_23.alpha = var5_23[var3_23] == 0 and 0.3 or 1

	local var13_23 = var1_23:Find("prev_slider"):GetComponent(typeof(Slider))

	arg0_23:setSliderValue(var13_23, (var7_23 + var11_23) / var9_23)

	local var14_23 = var11_23 / var9_23
	local var15_23 = var11_23 + var7_23 .. "/" .. var8_23

	if var10_23 == var5_23[var3_23] and var5_23[var3_23] ~= 0 then
		var14_23 = 1
		var15_23 = "MAX"
	end

	local var16_23 = var1_23:Find("cur_slider"):GetComponent(typeof(Slider))

	arg0_23:setSliderValue(var16_23, var14_23)
	setText(var0_23:Find("exp_container/Text"), var15_23)
end

function var0_0.modAttrAnim(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg3_24 or 0.3
	local var1_24 = intProperties(arg1_24:getShipProperties())
	local var2_24 = intProperties(arg2_24:getShipProperties())

	arg0_24.tweens = {}

	for iter0_24, iter1_24 in pairs(arg0_24.attrTFs) do
		local var3_24 = ShipModAttr.ID_TO_ATTR[iter0_24]
		local var4_24 = arg1_24:getModAttrTopLimit(var3_24)
		local var5_24 = arg0_24.shipVO:getModAttrBaseMax(var3_24)

		if var4_24 == 0 then
			arg0_24:updateAttr(iter0_24)
		else
			local var6_24 = arg0_24.attrTFs[iter0_24]
			local var7_24 = var6_24:Find("info")
			local var8_24 = var7_24:Find("info_container/value")
			local var9_24 = var1_24[var3_24] - var2_24[var3_24]
			local var10_24 = math.max(arg1_24:getModExpRatio(var3_24), 1)
			local var11_24 = var7_24:Find("cur_slider")
			local var12_24 = var7_24:Find("prev_slider")
			local var13_24 = var11_24:GetComponent(typeof(Slider))
			local var14_24 = var12_24:GetComponent(typeof(Slider))
			local var15_24 = arg0_24.getRemainExp(arg1_24, var3_24)
			local var16_24 = var7_24:Find("info_container/addition")
			local var17_24 = var6_24:Find("exp_container/Text")

			arg0_24:setSliderValue(var14_24, 0)
			setText(var6_24:Find("exp_container/Text"), var15_24 .. "/" .. var10_24)

			local function var18_24(arg0_25, arg1_25)
				setText(var8_24, arg0_25)
				setText(var16_24, "+" .. arg1_25)
			end

			if var9_24 >= 1 then
				local var19_24 = var2_24[var3_24]

				arg0_24:tweenValue(var13_24, var13_24.value, 1, var0_24, nil, function(arg0_26)
					arg0_24:setSliderValue(var13_24, arg0_26)
				end, function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

					var19_24 = var19_24 + 1

					var18_24(var19_24, var1_24[var3_24] - var19_24)

					local var0_27 = var1_24[var3_24] - var19_24

					if var0_27 > 0 then
						arg0_24:tweenValue(var13_24, 0, 1, var0_24, nil, function(arg0_28)
							arg0_24:setSliderValue(var13_24, arg0_28)
						end, function()
							pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

							var19_24 = var19_24 + 1

							var18_24(var19_24, var1_24[var3_24] - var19_24)

							if var19_24 == var1_24[var3_24] then
								arg0_24:tweenValue(var13_24, 0, var15_24 / var10_24, var0_24, nil, function(arg0_30)
									arg0_24:setSliderValue(var13_24, arg0_30)
								end, function()
									if var5_24 == var1_24[var3_24] then
										arg0_24:setSliderValue(var13_24, 1)
										setText(var17_24, "MAX")
									end
								end)
							end
						end, var0_27)
					else
						arg0_24:tweenValue(var13_24, 0, var15_24 / var10_24, var0_24, nil, function(arg0_32)
							arg0_24:setSliderValue(var13_24, arg0_32)
						end, function()
							if var5_24 == var1_24[var3_24] then
								arg0_24:setSliderValue(var13_24, 1)
								setText(var17_24, "MAX")
							end
						end)
					end
				end)
			else
				arg0_24:tweenValue(var13_24, var13_24.value, var15_24 / var10_24, var0_24, nil, function(arg0_34)
					arg0_24:setSliderValue(var13_24, arg0_34)
				end, function()
					if var5_24 == var1_24[var3_24] then
						arg0_24:setSliderValue(var13_24, 1)
						setText(var17_24, "MAX")
					end
				end)
			end
		end
	end
end

function var0_0.tweenValue(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36, arg8_36)
	assert(not arg0_36.exited, "tween after ui exited")

	if not arg0_36.tweens then
		return
	end

	arg0_36.tweens[arg1_36] = arg1_36

	LeanTween.cancel(go(arg1_36))

	local var0_36 = LeanTween.value(go(arg1_36), arg2_36, arg3_36, arg4_36):setOnUpdate(System.Action_float(function(arg0_37)
		if arg6_36 then
			arg6_36(arg0_37)
		end
	end)):setDelay(arg5_36 or 0):setOnComplete(System.Action(function()
		if arg7_36 then
			arg7_36()
		end
	end))

	if arg8_36 and arg8_36 > 0 then
		var0_36:setRepeat(arg8_36)
	end
end

function var0_0.getBuffExp()
	local var0_39 = BuffHelper.GetShipModExpBuff()
	local var1_39 = 0

	for iter0_39, iter1_39 in ipairs(var0_39) do
		var1_39 = math.max(iter1_39 and iter1_39:getConfig("benefit_effect") / 100 or 0, var1_39)
	end

	return var1_39
end

function var0_0.getModExpAdditions(arg0_40, arg1_40)
	local var0_40 = pg.ship_data_template
	local var1_40 = var0_40[arg0_40.configId].group_type
	local var2_40 = pg.ship_data_strengthen
	local var3_40 = {}
	local var4_40 = var0_0.getBuffExp()

	for iter0_40, iter1_40 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var5_40 = 0

		if iter0_40 ~= ShipModLayer.IGNORE_ID then
			for iter2_40, iter3_40 in pairs(arg1_40) do
				local var6_40 = var0_40[iter3_40.configId]
				local var7_40 = var6_40.strengthen_id

				assert(var2_40[var7_40], "ship_data_strengthen>>" .. var7_40)

				local var8_40 = var2_40[var7_40].attr_exp[iter0_40 - 1]

				if var6_40.group_type == var1_40 then
					var8_40 = var8_40 * 2
				end

				var5_40 = var5_40 + var8_40
			end
		end

		var3_40[iter1_40] = math.floor(var5_40 * (1 + var4_40))
	end

	return var3_40
end

function var0_0.getMaterialShips(arg0_41, arg1_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg1_41 or {}) do
		table.insert(var0_41, arg0_41.shipVOs[iter1_41])
	end

	return var0_41
end

function var0_0.getExpAddition(arg0_42, arg1_42, arg2_42)
	local var0_42 = var0_0.getModExpAdditions(arg0_42, arg1_42)

	if arg0_42:getModAttrTopLimit(arg2_42) == 0 then
		return 0, 0
	else
		local var1_42 = Clone(arg0_42)

		var1_42:addModAttrExp(arg2_42, var0_42[arg2_42])

		return var1_42:getModProperties(arg2_42) - arg0_42:getModProperties(arg2_42)
	end
end

function var0_0.getRemainExp(arg0_43, arg1_43)
	local var0_43 = math.max(arg0_43:getModExpRatio(arg1_43), 1)

	return arg0_43:getModProperties(arg1_43) % var0_43
end

function var0_0.setSliderValue(arg0_44, arg1_44, arg2_44)
	arg1_44.value = arg2_44 == 0 and arg2_44 or math.max(arg2_44, 0.08)
end

function var0_0.willExit(arg0_45)
	arg0_45:blurPanel(false)

	for iter0_45, iter1_45 in pairs(arg0_45.tweens or {}) do
		LeanTween.cancel(go(iter1_45))
	end

	arg0_45.tweens = nil
end

function var0_0.onBackPressed(arg0_46)
	arg0_46:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0_0

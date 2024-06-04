local var0 = class("ShipModLayer", import("..base.BaseUI"))
local var1 = 12

var0.IGNORE_ID = 4

function var0.getUIName(arg0)
	return "ShipModUI"
end

function var0.setShipVOs(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.init(arg0)
	arg0.blurPanelTF = arg0:findTF("blur_panel")
	arg0.mainPanel = arg0:findTF("blur_panel/main")
	arg0.shipContainer = arg0:findTF("bg/add_ship_panel/ships", arg0.mainPanel)
	arg0.attrsPanel = arg0:findTF("bg/property_panel/attrs", arg0.mainPanel)

	setText(arg0:findTF("bg/add_ship_panel/title/tip", arg0.mainPanel), i18n("ship_mod_exp_to_attr_tip"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("ok_btn", arg0.mainPanel), function()
		local function var0()
			local var0, var1 = ShipStatus.ShipStatusCheck("onModify", arg0.shipVO)

			if not var0 then
				pg.TipsMgr.GetInstance():ShowTips(var1)

				return
			end

			if not arg0.contextData.materialShipIds or #arg0.contextData.materialShipIds == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

				return
			else
				arg0:startModShip()
			end
		end

		if arg0.shipVO:isActivityNpc() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("npc_strength_tip"),
				onYes = var0
			})
		else
			var0()
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0:findTF("cancel_btn", arg0.mainPanel), function()
		local var0 = arg0.contextData.materialShipIds

		if not var0 or table.getCount(var0) == 0 then
			return
		end

		arg0:clearAllShip()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("select_btn", arg0.mainPanel), function()
		arg0:emit(ShipModMediator.ON_AUTO_SELECT_SHIP)
	end, SFX_CANCEL)
	arg0:initAttrs()

	arg0.inited = true

	arg0:emit(ShipModMediator.LOADEND, arg0.mainPanel)
	arg0:blurPanel(true)
end

function var0.blurPanel(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance()

	if arg1 then
		var0:OverlayPanelPB(arg0.blurPanelTF, {
			pbList = {
				arg0.mainPanel:Find("bg")
			},
			groupName = arg0:getGroupNameFromData(),
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		var0:UnOverlayPanel(arg0.blurPanelTF, arg0._tf)
	end
end

function var0.startModShip(arg0)
	if not arg0.hasAddition then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_mod_no_addition_tip"),
			onYes = function()
				arg0:emit(ShipModMediator.MOD_SHIP, arg0.shipVO.id)
			end
		})
	else
		arg0:emit(ShipModMediator.MOD_SHIP, arg0.shipVO.id)
	end
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1

	arg0:initSelectedShips()

	if arg0.inited then
		arg0:initAttrs()
	end
end

function var0.clearAllShip(arg0)
	for iter0 = 1, var1 do
		local var0 = arg0.shipContainer:GetChild(iter0 - 1)

		setActive(var0:Find("IconTpl"), false)
		onButton(arg0, var0:Find("add"), function()
			arg0:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
		end, SFX_PANEL)
	end

	arg0.contextData.materialShipIds = nil

	arg0:updateAttrs()
end

function var0.initSelectedShips(arg0)
	local var0 = arg0.contextData.materialShipIds or {}
	local var1 = table.getCount(var0)

	for iter0 = 1, var1 do
		local var2 = arg0.shipContainer:GetChild(iter0 - 1)

		if iter0 <= var1 then
			arg0:updateShip(var2, var0[iter0])
		else
			onButton(arg0, var2:Find("add"), function()
				arg0:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
			end, SFX_PANEL)
		end

		setActive(var2:Find("IconTpl"), iter0 <= var1)
	end
end

function var0.updateShip(arg0, arg1, arg2)
	local var0 = arg0.shipVOs[arg2]

	onButton(arg0, arg1, function()
		for iter0, iter1 in ipairs(arg0.contextData.materialShipIds) do
			if arg2 == iter1 then
				local var0 = arg1:Find("add")

				setActive(arg1:Find("IconTpl"), false)
				onButton(arg0, var0, function()
					arg0:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
				end, SFX_PANEL)
				table.remove(arg0.contextData.materialShipIds, iter0)
				arg0:updateAttrs()

				break
			end
		end
	end, SFX_PANEL)
	updateShip(arg0:findTF("IconTpl", arg1), var0, {
		initStar = true
	})
	setText(arg1:Find("IconTpl/icon_bg/lv/Text"), var0.level)
end

function var0.initAttrs(arg0)
	arg0.attrTFs = {}

	for iter0, iter1 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0.IGNORE_ID ~= iter0 then
			local var0 = arg0.attrsPanel:Find("attr_" .. iter0)

			arg0.attrTFs[iter0] = var0
		end
	end

	arg0:updateAttrs()
end

function var0.updateAttrs(arg0)
	arg0.hasAddition = nil

	for iter0, iter1 in pairs(arg0.attrTFs) do
		arg0:updateAttr(iter0)
	end
end

function var0.updateAttr(arg0, arg1)
	local var0 = arg0.attrTFs[arg1]
	local var1 = arg0:findTF("info", var0)
	local var2 = var0:GetComponent(typeof(CanvasGroup))
	local var3 = ShipModAttr.ID_TO_ATTR[arg1]
	local var4 = arg0.shipVO:getModAttrTopLimit(var3)
	local var5 = intProperties(arg0.shipVO:getShipProperties())
	local var6 = arg0:getMaterialShips(arg0.contextData.materialShipIds)
	local var7 = var0.getExpAddition(arg0.shipVO, var6, var3)
	local var8 = arg0.shipVO:getModExpRatio(var3)
	local var9 = math.max(arg0.shipVO:getModExpRatio(var3), 1)

	if var7 ~= 0 then
		arg0.hasAddition = true
	end

	local var10 = arg0.shipVO:getModAttrBaseMax(var3)
	local var11 = arg0.getRemainExp(arg0.shipVO, var3)
	local var12 = math.max(math.min(math.floor((var11 + var7) / var9), var10 - var5[var3]), 0)

	setText(arg0:findTF("info_container/addition", var1), "+" .. var12)
	setText(arg0:findTF("info_container/name", var1), AttributeType.Type2Name(var3))
	setText(arg0:findTF("max_container/Text", var1), var10)
	setText(arg0:findTF("info_container/value", var1), var5[var3])

	var2.alpha = var5[var3] == 0 and 0.3 or 1

	local var13 = arg0:findTF("prev_slider", var1):GetComponent(typeof(Slider))

	arg0:setSliderValue(var13, (var7 + var11) / var9)

	local var14 = var11 / var9
	local var15 = var11 + var7 .. "/" .. var8

	if var10 == var5[var3] and var5[var3] ~= 0 then
		var14 = 1
		var15 = "MAX"
	end

	local var16 = arg0:findTF("cur_slider", var1):GetComponent(typeof(Slider))

	arg0:setSliderValue(var16, var14)
	setText(arg0:findTF("exp_container/Text", var0), var15)
end

function var0.modAttrAnim(arg0, arg1, arg2, arg3)
	local var0 = arg3 or 0.3
	local var1 = intProperties(arg1:getShipProperties())
	local var2 = intProperties(arg2:getShipProperties())

	arg0.tweens = {}

	for iter0, iter1 in pairs(arg0.attrTFs) do
		local var3 = ShipModAttr.ID_TO_ATTR[iter0]
		local var4 = arg1:getModAttrTopLimit(var3)
		local var5 = arg0.shipVO:getModAttrBaseMax(var3)

		if var4 == 0 then
			arg0:updateAttr(iter0)
		else
			local var6 = arg0.attrTFs[iter0]
			local var7 = arg0:findTF("info", var6)
			local var8 = arg0:findTF("info_container/value", var7)
			local var9 = var1[var3] - var2[var3]
			local var10 = math.max(arg1:getModExpRatio(var3), 1)
			local var11 = arg0:findTF("cur_slider", var7)
			local var12 = arg0:findTF("prev_slider", var7)
			local var13 = var11:GetComponent(typeof(Slider))
			local var14 = var12:GetComponent(typeof(Slider))
			local var15 = arg0.getRemainExp(arg1, var3)
			local var16 = arg0:findTF("info_container/addition", var7)
			local var17 = arg0:findTF("exp_container/Text", var6)

			arg0:setSliderValue(var14, 0)
			setText(arg0:findTF("exp_container/Text", var6), var15 .. "/" .. var10)

			local function var18(arg0, arg1)
				setText(var8, arg0)
				setText(var16, "+" .. arg1)
			end

			if var9 >= 1 then
				local var19 = var2[var3]

				arg0:tweenValue(var13, var13.value, 1, var0, nil, function(arg0)
					arg0:setSliderValue(var13, arg0)
				end, function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

					var19 = var19 + 1

					var18(var19, var1[var3] - var19)

					local var0 = var1[var3] - var19

					if var0 > 0 then
						arg0:tweenValue(var13, 0, 1, var0, nil, function(arg0)
							arg0:setSliderValue(var13, arg0)
						end, function()
							pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

							var19 = var19 + 1

							var18(var19, var1[var3] - var19)

							if var19 == var1[var3] then
								arg0:tweenValue(var13, 0, var15 / var10, var0, nil, function(arg0)
									arg0:setSliderValue(var13, arg0)
								end, function()
									if var5 == var1[var3] then
										arg0:setSliderValue(var13, 1)
										setText(var17, "MAX")
									end
								end)
							end
						end, var0)
					else
						arg0:tweenValue(var13, 0, var15 / var10, var0, nil, function(arg0)
							arg0:setSliderValue(var13, arg0)
						end, function()
							if var5 == var1[var3] then
								arg0:setSliderValue(var13, 1)
								setText(var17, "MAX")
							end
						end)
					end
				end)
			else
				arg0:tweenValue(var13, var13.value, var15 / var10, var0, nil, function(arg0)
					arg0:setSliderValue(var13, arg0)
				end, function()
					if var5 == var1[var3] then
						arg0:setSliderValue(var13, 1)
						setText(var17, "MAX")
					end
				end)
			end
		end
	end
end

function var0.tweenValue(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	assert(not arg0.exited, "tween after ui exited")

	if not arg0.tweens then
		return
	end

	arg0.tweens[arg1] = arg1

	LeanTween.cancel(go(arg1))

	local var0 = LeanTween.value(go(arg1), arg2, arg3, arg4):setOnUpdate(System.Action_float(function(arg0)
		if arg6 then
			arg6(arg0)
		end
	end)):setDelay(arg5 or 0):setOnComplete(System.Action(function()
		if arg7 then
			arg7()
		end
	end))

	if arg8 and arg8 > 0 then
		var0:setRepeat(arg8)
	end
end

function var0.getBuffExp()
	local var0 = BuffHelper.GetShipModExpBuff()
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		var1 = math.max(iter1 and iter1:getConfig("benefit_effect") / 100 or 0, var1)
	end

	return var1
end

function var0.getModExpAdditions(arg0, arg1)
	local var0 = pg.ship_data_template
	local var1 = var0[arg0.configId].group_type
	local var2 = pg.ship_data_strengthen
	local var3 = {}
	local var4 = var0.getBuffExp()

	for iter0, iter1 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var5 = 0

		if iter0 ~= ShipModLayer.IGNORE_ID then
			for iter2, iter3 in pairs(arg1) do
				local var6 = var0[iter3.configId]
				local var7 = var6.strengthen_id

				assert(var2[var7], "ship_data_strengthen>>" .. var7)

				local var8 = var2[var7].attr_exp[iter0 - 1]

				if var6.group_type == var1 then
					var8 = var8 * 2
				end

				var5 = var5 + var8
			end
		end

		var3[iter1] = math.floor(var5 * (1 + var4))
	end

	return var3
end

function var0.getMaterialShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1 or {}) do
		table.insert(var0, arg0.shipVOs[iter1])
	end

	return var0
end

function var0.getExpAddition(arg0, arg1, arg2)
	local var0 = var0.getModExpAdditions(arg0, arg1)

	if arg0:getModAttrTopLimit(arg2) == 0 then
		return 0, 0
	else
		local var1 = Clone(arg0)

		var1:addModAttrExp(arg2, var0[arg2])

		return var1:getModProperties(arg2) - arg0:getModProperties(arg2)
	end
end

function var0.getRemainExp(arg0, arg1)
	local var0 = math.max(arg0:getModExpRatio(arg1), 1)

	return arg0:getModProperties(arg1) % var0
end

function var0.setSliderValue(arg0, arg1, arg2)
	arg1.value = arg2 == 0 and arg2 or math.max(arg2, 0.08)
end

function var0.willExit(arg0)
	arg0:blurPanel(false)

	for iter0, iter1 in pairs(arg0.tweens or {}) do
		LeanTween.cancel(go(iter1))
	end

	arg0.tweens = nil
end

function var0.onBackPressed(arg0)
	arg0:emit(BaseUI.ON_BACK_PRESSED, true)
end

return var0

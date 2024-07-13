local var0_0 = class("FragResolvePanel", BaseSubPanel)

function var0_0.getUIName(arg0_1)
	return "FragResolveUI"
end

local var1_0 = {
	"control",
	"resolve"
}

function var0_0.OnInit(arg0_2)
	arg0_2.bagProxy = getProxy(BagProxy)
	arg0_2.technologyProxy = getProxy(TechnologyProxy)
	arg0_2.toggles = {}

	for iter0_2, iter1_2 in ipairs(var1_0) do
		arg0_2[iter1_2 .. "Panel"] = arg0_2._tf:Find(iter1_2)

		local var0_2 = arg0_2._tf:Find("toggle_controll/" .. iter1_2)

		arg0_2.toggles[iter1_2] = var0_2

		onToggle(arg0_2, var0_2, function(arg0_3)
			arg0_2["Reset" .. iter1_2](arg0_2)
		end, SFX_PANEL)
	end

	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Back()
	end, SFX_PANEL)

	local var1_2 = arg0_2.controlPanel:Find("got/empty/Text")

	setText(arg0_2.controlPanel:Find("allMax/txt"), i18n("onebutton_max_tip"))

	local var2_2 = arg0_2._tf:Find("control/condition/text")
	local var3_2 = arg0_2.resolvePanel:Find("cancel_button/label")

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(var2_2, i18n("fenjie_lantu_tip"))
		setTextEN(var1_2, i18n("fragresolve_empty_tip"))
	else
		setText(var2_2, i18n("fenjie_lantu_tip"))
		setText(var1_2, i18n("fragresolve_empty_tip"))
	end

	setText(var3_2, i18n("msgbox_text_cancel"))

	local var4_2 = getProxy(PlayerProxy):getData()

	var0_0.keepFateTog = arg0_2._tf:Find("control/condition/keep_tog")

	setText(arg0_2:findTF("label", arg0_2.keepFateTog), i18n("keep_fate_tip"))

	local var5_2 = GetComponent(arg0_2.keepFateTog, typeof(Toggle))

	var0_0.keepFateState = not var4_2:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var5_2.isOn = var0_0.keepFateState

	onToggle(arg0_2, arg0_2.keepFateTog, function(arg0_5)
		var0_0.keepFateState = arg0_5

		arg0_2:emit(NewShopsMediator.SET_PLAYER_FLAG, SHOW_DONT_KEEP_FATE_ITEM, not arg0_5)
		arg0_2:Trigger("control")
	end)
	arg0_2:Trigger("control")
end

function var0_0.OnShow(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.OnHide(arg0_7)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf)
end

function var0_0.Reset(arg0_8)
	if arg0_8.resolveItems then
		table.clear(arg0_8.resolveItems)
	end
end

function var0_0.Resetcontrol(arg0_9)
	arg0_9.blueprintItems = arg0_9.GetAllBluePrintStrengthenItems()

	local var0_9 = arg0_9.blueprintItems
	local var1_9 = arg0_9.controlPanel
	local var2_9 = var1_9:Find("got/empty")
	local var3_9 = var1_9:Find("got/list")

	setActive(var2_9, #var0_9 <= 0)
	setActive(var3_9, #var0_9 > 0)

	if #var0_9 <= 0 then
		arg0_9:Updatecontrol()

		return
	end

	local var4_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.resolveItems or {}) do
		var4_9[iter1_9.id] = iter1_9
	end

	UIItemList.StaticAlign(var3_9, var3_9:Find("item"), #var0_9, function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_9[arg1_10 + 1]

			updateDrop(arg2_10:Find("icon"), var0_10)

			var0_10.curCount = math.clamp(var4_9[var0_10.id] and var4_9[var0_10.id].curCount or 0, 0, var0_10.maxCount)

			onButton(arg0_9, arg2_10:Find("icon/icon_bg"), function()
				arg0_9:emit(BaseUI.ON_DROP, var0_10)
			end, SFX_PANEL)

			local var1_10 = arg2_10:Find("count")

			onButton(arg0_9, var1_10:Find("max"), function()
				if var0_10.curCount ~= var0_10.maxCount then
					var0_10.curCount = var0_10.maxCount

					arg0_9:Updatecontrol()
				end
			end)
			pressPersistTrigger(var1_10:Find("number_panel/left"), 0.5, function(arg0_13)
				if var0_10.curCount <= 0 then
					arg0_13()

					return
				end

				var0_10.curCount = var0_10.curCount - 1

				arg0_9:Updatecontrol()
			end, nil, true, true, 0.1, SFX_PANEL)
			pressPersistTrigger(var1_10:Find("number_panel/right"), 0.5, function(arg0_14)
				if var0_10.curCount >= var0_10.maxCount then
					arg0_14()

					return
				end

				var0_10.curCount = var0_10.curCount + 1

				arg0_9:Updatecontrol()
			end, nil, true, true, 0.1, SFX_PANEL)
		end
	end)
	onButton(arg0_9, var1_9:Find("button_1"), function()
		local var0_15 = {}

		for iter0_15, iter1_15 in ipairs(arg0_9.blueprintItems) do
			if iter1_15.curCount > 0 then
				local var1_15 = Clone(iter1_15)

				var1_15.count = iter1_15.curCount

				table.insert(var0_15, var1_15)
			end
		end

		if #var0_15 > 0 then
			arg0_9.resolveItems = var0_15

			triggerToggle(arg0_9.toggles.resolve, true)
		end
	end, SFX_PANEL)
	onButton(arg0_9, var1_9:Find("allMax"), function()
		for iter0_16 = 1, #var0_9 do
			local var0_16 = var0_9[iter0_16]

			if var0_16.curCount ~= var0_16.maxCount then
				var0_16.curCount = var0_16.maxCount
			end

			arg0_9:Updatecontrol()
		end
	end, SFX_PANEL)
	arg0_9:Updatecontrol()
end

function var0_0.Updatecontrol(arg0_17)
	local var0_17 = arg0_17.controlPanel
	local var1_17 = var0_17:Find("got/list")
	local var2_17 = arg0_17.blueprintItems
	local var3_17 = 0

	UIItemList.StaticAlign(var1_17, var1_17:Find("item"), #var2_17, function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var2_17[arg1_18 + 1]
			local var1_18 = arg2_18:Find("count")

			setText(var1_18:Find("number_panel/value"), var0_18.curCount)

			var3_17 = var3_17 + var0_18.curCount
		end
	end)

	local var4_17 = var0_17:Find("button_1")

	setButtonEnabled(var4_17, var3_17 > 0)
	setGray(var4_17, var3_17 <= 0)

	local var5_17 = var0_17:Find("allMax")

	setGray(var5_17, not var2_17 or #var2_17 == 0)
	setButtonEnabled(var5_17, var2_17 and #var2_17 > 0)
end

function var0_0.Resetresolve(arg0_19)
	local var0_19 = arg0_19.resolvePanel
	local var1_19 = var0_19:Find("preview/got/list")
	local var2_19 = var0_19:Find("result/got/list")
	local var3_19 = arg0_19.resolveItems

	UIItemList.StaticAlign(var1_19, var1_19:Find("item"), #var3_19, function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = var3_19[arg1_20 + 1]

			updateDrop(arg2_20:Find("icon"), var0_20)
			onButton(arg0_19, arg2_20:Find("icon/icon_bg"), function()
				arg0_19:emit(BaseUI.ON_DROP, var0_20)
			end, SFX_PANEL)
			setText(arg2_20:Find("name_panel/name"), var0_20:getConfig("name"))
			setText(arg2_20:Find("name_panel/number"), "x " .. var0_20.curCount)
		end
	end)

	local var4_19 = {}
	local var5_19 = {}

	for iter0_19, iter1_19 in pairs(var3_19) do
		local var6_19 = iter1_19
		local var7_19 = Item.getConfigData(var6_19.id)

		assert(var7_19, "Can't find the price " .. var6_19.id)

		local var8_19 = (var4_19[var7_19.price[1]] or 0) + var7_19.price[2] * var6_19.count

		var4_19[var7_19.price[1]] = var8_19
	end

	for iter2_19, iter3_19 in pairs(var4_19) do
		table.insert(var5_19, {
			type = DROP_TYPE_RESOURCE,
			id = iter2_19,
			count = iter3_19
		})
	end

	UIItemList.StaticAlign(var2_19, var2_19:Find("item"), #var5_19, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var5_19[arg1_22 + 1]

			updateDrop(arg2_22:Find("icon"), var0_22)
			onButton(arg0_19, arg2_22:Find("icon/icon_bg"), function()
				arg0_19:emit(BaseUI.ON_DROP, var0_22)
			end, SFX_PANEL)
			setText(arg2_22:Find("name_panel/name"), var0_22:getConfig("name"))
			setText(arg2_22:Find("name_panel/number"), "x " .. var0_22.count)
		end
	end)
	onButton(arg0_19, var0_19:Find("cancel_button"), function()
		arg0_19:Back()
	end)
	onButton(arg0_19, var0_19:Find("destroy_button"), function()
		arg0_19:emit(NewShopsMediator.SELL_BLUEPRINT, arg0_19.resolveItems)
	end)
end

function var0_0.GetAllBluePrintStrengthenItems()
	local var0_26 = {}
	local var1_26 = getProxy(TechnologyProxy)
	local var2_26 = getProxy(BagProxy)
	local var3_26 = pg.ship_data_blueprint

	for iter0_26, iter1_26 in ipairs(var3_26.all) do
		local var4_26 = var3_26[iter1_26]

		if var1_26:getBluePrintById(iter1_26):isMaxLevel() then
			local var5_26 = var4_26.strengthen_item
			local var6_26 = var2_26:getItemById(var5_26)

			if var6_26 then
				local var7_26 = var1_26:getBluePrintById(var1_26:GetBlueprint4Item(var5_26))
				local var8_26 = var6_26.count

				if var6_26 and var6_26.count > 0 and var0_0.keepFateState then
					var8_26 = var6_26.count - var7_26:getFateMaxLeftOver()
					var8_26 = var8_26 < 0 and 0 or var8_26
				end

				table.insert(var0_26, Drop.New({
					id = var6_26.id,
					type = DROP_TYPE_ITEM,
					count = var6_26.count,
					maxCount = var8_26
				}))
			end
		end
	end

	return var0_26
end

function var0_0.Trigger(arg0_27, arg1_27)
	local var0_27 = arg0_27.toggles[arg1_27]

	if var0_27 then
		arg0_27.buffer:Show()
		triggerToggle(var0_27, true)
	end
end

function var0_0.Back(arg0_28)
	if getToggleState(arg0_28.toggles.resolve) then
		triggerToggle(arg0_28.toggles.control, true)
	elseif getToggleState(arg0_28.toggles.control) then
		arg0_28:Hide()
	end
end

return var0_0

local var0 = class("FragResolvePanel", BaseSubPanel)

function var0.getUIName(arg0)
	return "FragResolveUI"
end

local var1 = {
	"control",
	"resolve"
}

function var0.OnInit(arg0)
	arg0.bagProxy = getProxy(BagProxy)
	arg0.technologyProxy = getProxy(TechnologyProxy)
	arg0.toggles = {}

	for iter0, iter1 in ipairs(var1) do
		arg0[iter1 .. "Panel"] = arg0._tf:Find(iter1)

		local var0 = arg0._tf:Find("toggle_controll/" .. iter1)

		arg0.toggles[iter1] = var0

		onToggle(arg0, var0, function(arg0)
			arg0["Reset" .. iter1](arg0)
		end, SFX_PANEL)
	end

	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Back()
	end, SFX_PANEL)

	local var1 = arg0.controlPanel:Find("got/empty/Text")

	setText(arg0.controlPanel:Find("allMax/txt"), i18n("onebutton_max_tip"))

	local var2 = arg0._tf:Find("control/condition/text")
	local var3 = arg0.resolvePanel:Find("cancel_button/label")

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(var2, i18n("fenjie_lantu_tip"))
		setTextEN(var1, i18n("fragresolve_empty_tip"))
	else
		setText(var2, i18n("fenjie_lantu_tip"))
		setText(var1, i18n("fragresolve_empty_tip"))
	end

	setText(var3, i18n("msgbox_text_cancel"))

	local var4 = getProxy(PlayerProxy):getData()

	var0.keepFateTog = arg0._tf:Find("control/condition/keep_tog")

	setText(arg0:findTF("label", arg0.keepFateTog), i18n("keep_fate_tip"))

	local var5 = GetComponent(arg0.keepFateTog, typeof(Toggle))

	var0.keepFateState = not var4:GetCommonFlag(SHOW_DONT_KEEP_FATE_ITEM)
	var5.isOn = var0.keepFateState

	onToggle(arg0, arg0.keepFateTog, function(arg0)
		var0.keepFateState = arg0

		arg0:emit(NewShopsMediator.SET_PLAYER_FLAG, SHOW_DONT_KEEP_FATE_ITEM, not arg0)
		arg0:Trigger("control")
	end)
	arg0:Trigger("control")
end

function var0.OnShow(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.OnHide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.Reset(arg0)
	if arg0.resolveItems then
		table.clear(arg0.resolveItems)
	end
end

function var0.Resetcontrol(arg0)
	arg0.blueprintItems = arg0.GetAllBluePrintStrengthenItems()

	local var0 = arg0.blueprintItems
	local var1 = arg0.controlPanel
	local var2 = var1:Find("got/empty")
	local var3 = var1:Find("got/list")

	setActive(var2, #var0 <= 0)
	setActive(var3, #var0 > 0)

	if #var0 <= 0 then
		arg0:Updatecontrol()

		return
	end

	local var4 = {}

	for iter0, iter1 in ipairs(arg0.resolveItems or {}) do
		var4[iter1.id] = iter1
	end

	UIItemList.StaticAlign(var3, var3:Find("item"), #var0, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			updateDrop(arg2:Find("icon"), var0)

			var0.curCount = math.clamp(var4[var0.id] and var4[var0.id].curCount or 0, 0, var0.maxCount)

			onButton(arg0, arg2:Find("icon/icon_bg"), function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)

			local var1 = arg2:Find("count")

			onButton(arg0, var1:Find("max"), function()
				if var0.curCount ~= var0.maxCount then
					var0.curCount = var0.maxCount

					arg0:Updatecontrol()
				end
			end)
			pressPersistTrigger(var1:Find("number_panel/left"), 0.5, function(arg0)
				if var0.curCount <= 0 then
					arg0()

					return
				end

				var0.curCount = var0.curCount - 1

				arg0:Updatecontrol()
			end, nil, true, true, 0.1, SFX_PANEL)
			pressPersistTrigger(var1:Find("number_panel/right"), 0.5, function(arg0)
				if var0.curCount >= var0.maxCount then
					arg0()

					return
				end

				var0.curCount = var0.curCount + 1

				arg0:Updatecontrol()
			end, nil, true, true, 0.1, SFX_PANEL)
		end
	end)
	onButton(arg0, var1:Find("button_1"), function()
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.blueprintItems) do
			if iter1.curCount > 0 then
				local var1 = Clone(iter1)

				var1.count = iter1.curCount

				table.insert(var0, var1)
			end
		end

		if #var0 > 0 then
			arg0.resolveItems = var0

			triggerToggle(arg0.toggles.resolve, true)
		end
	end, SFX_PANEL)
	onButton(arg0, var1:Find("allMax"), function()
		for iter0 = 1, #var0 do
			local var0 = var0[iter0]

			if var0.curCount ~= var0.maxCount then
				var0.curCount = var0.maxCount
			end

			arg0:Updatecontrol()
		end
	end, SFX_PANEL)
	arg0:Updatecontrol()
end

function var0.Updatecontrol(arg0)
	local var0 = arg0.controlPanel
	local var1 = var0:Find("got/list")
	local var2 = arg0.blueprintItems
	local var3 = 0

	UIItemList.StaticAlign(var1, var1:Find("item"), #var2, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]
			local var1 = arg2:Find("count")

			setText(var1:Find("number_panel/value"), var0.curCount)

			var3 = var3 + var0.curCount
		end
	end)

	local var4 = var0:Find("button_1")

	setButtonEnabled(var4, var3 > 0)
	setGray(var4, var3 <= 0)

	local var5 = var0:Find("allMax")

	setGray(var5, not var2 or #var2 == 0)
	setButtonEnabled(var5, var2 and #var2 > 0)
end

function var0.Resetresolve(arg0)
	local var0 = arg0.resolvePanel
	local var1 = var0:Find("preview/got/list")
	local var2 = var0:Find("result/got/list")
	local var3 = arg0.resolveItems

	UIItemList.StaticAlign(var1, var1:Find("item"), #var3, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var3[arg1 + 1]

			updateDrop(arg2:Find("icon"), var0)
			onButton(arg0, arg2:Find("icon/icon_bg"), function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)
			setText(arg2:Find("name_panel/name"), var0:getConfig("name"))
			setText(arg2:Find("name_panel/number"), "x " .. var0.curCount)
		end
	end)

	local var4 = {}
	local var5 = {}

	for iter0, iter1 in pairs(var3) do
		local var6 = iter1
		local var7 = Item.getConfigData(var6.id)

		assert(var7, "Can't find the price " .. var6.id)

		local var8 = (var4[var7.price[1]] or 0) + var7.price[2] * var6.count

		var4[var7.price[1]] = var8
	end

	for iter2, iter3 in pairs(var4) do
		table.insert(var5, {
			type = DROP_TYPE_RESOURCE,
			id = iter2,
			count = iter3
		})
	end

	UIItemList.StaticAlign(var2, var2:Find("item"), #var5, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var5[arg1 + 1]

			updateDrop(arg2:Find("icon"), var0)
			onButton(arg0, arg2:Find("icon/icon_bg"), function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)
			setText(arg2:Find("name_panel/name"), var0:getConfig("name"))
			setText(arg2:Find("name_panel/number"), "x " .. var0.count)
		end
	end)
	onButton(arg0, var0:Find("cancel_button"), function()
		arg0:Back()
	end)
	onButton(arg0, var0:Find("destroy_button"), function()
		arg0:emit(NewShopsMediator.SELL_BLUEPRINT, arg0.resolveItems)
	end)
end

function var0.GetAllBluePrintStrengthenItems()
	local var0 = {}
	local var1 = getProxy(TechnologyProxy)
	local var2 = getProxy(BagProxy)
	local var3 = pg.ship_data_blueprint

	for iter0, iter1 in ipairs(var3.all) do
		local var4 = var3[iter1]

		if var1:getBluePrintById(iter1):isMaxLevel() then
			local var5 = var4.strengthen_item
			local var6 = var2:getItemById(var5)

			if var6 then
				local var7 = var1:getBluePrintById(var1:GetBlueprint4Item(var5))
				local var8 = var6.count

				if var6 and var6.count > 0 and var0.keepFateState then
					var8 = var6.count - var7:getFateMaxLeftOver()
					var8 = var8 < 0 and 0 or var8
				end

				table.insert(var0, Drop.New({
					id = var6.id,
					type = DROP_TYPE_ITEM,
					count = var6.count,
					maxCount = var8
				}))
			end
		end
	end

	return var0
end

function var0.Trigger(arg0, arg1)
	local var0 = arg0.toggles[arg1]

	if var0 then
		arg0.buffer:Show()
		triggerToggle(var0, true)
	end
end

function var0.Back(arg0)
	if getToggleState(arg0.toggles.resolve) then
		triggerToggle(arg0.toggles.control, true)
	elseif getToggleState(arg0.toggles.control) then
		arg0:Hide()
	end
end

return var0

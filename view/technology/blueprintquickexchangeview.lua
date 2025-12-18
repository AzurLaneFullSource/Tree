local var0_0 = class("BlueprintQuickExchangeView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BlueprintQuickExchangeUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.rtBg = arg0_2._tf:Find("bg")

	onButton(arg0_2, arg0_2.rtBg, function()
		arg0_2:Hide()
	end, SFX_CANCEL)

	arg0_2.rtPreview = arg0_2._tf:Find("window/preview/got")
	arg0_2.rtEmpty = arg0_2.rtPreview:Find("empty")

	setText(arg0_2.rtEmpty:Find("Text"), i18n("blueprint_exchange_empty_tip"))

	local var0_2 = arg0_2.rtPreview:Find("list")

	arg0_2.itemList = UIItemList.New(var0_2, var0_2:Find("item"))

	arg0_2.itemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.displayList[arg1_4]
			local var1_4 = arg0_2.awardList[arg1_4].count

			updateDrop(arg2_4:Find("icon"), var0_4)
			onButton(arg0_2, arg2_4:Find("icon"), function()
				arg0_2:emit(BaseUI.ON_DROP, var0_4)
			end, SFX_PANEL)
			setText(arg2_4:Find("calc/value"), arg0_2.countList[arg1_4])
			setScrollText(arg2_4:Find("name/Text"), var0_4:getConfig("name"))
			setText(arg2_4:Find("kc"), i18n("tec_tip_material_stock") .. ":" .. var0_4.count)
			pressPersistTrigger(arg2_4:Find("calc/plus"), 0.5, function()
				if var0_4.count > arg0_2.countList[arg1_4] and arg0_2.count + var1_4 <= arg0_2.need then
					arg0_2.countList[arg1_4] = arg0_2.countList[arg1_4] + 1

					setText(arg2_4:Find("calc/value"), arg0_2.countList[arg1_4])

					arg0_2.count = arg0_2.count + var1_4

					setText(arg0_2.rtExchange:Find("bg/count"), setColorStr(arg0_2.count, "#FFEC6E") .. "/" .. arg0_2.need)
				end
			end, nil, true, true, 0.1, SFX_PANEL)
			pressPersistTrigger(arg2_4:Find("calc/minus"), 0.5, function()
				if arg0_2.countList[arg1_4] > 0 then
					arg0_2.countList[arg1_4] = arg0_2.countList[arg1_4] - 1

					setText(arg2_4:Find("calc/value"), arg0_2.countList[arg1_4])

					arg0_2.count = arg0_2.count - var1_4

					setText(arg0_2.rtExchange:Find("bg/count"), setColorStr(arg0_2.count, "#FFEC6E") .. "/" .. arg0_2.need)
				end
			end, nil, true, true, 0.1, SFX_PANEL)
			onButton(arg0_2, arg2_4:Find("calc/max"), function()
				if var0_4.count > arg0_2.countList[arg1_4] and arg0_2.count + var1_4 <= arg0_2.need then
					local var0_8 = math.floor((arg0_2.need - arg0_2.count + var1_4 - 1) / var1_4)
					local var1_8 = math.min(var0_8, var0_4.count - arg0_2.countList[arg1_4])

					arg0_2.countList[arg1_4] = arg0_2.countList[arg1_4] + var1_8

					setText(arg2_4:Find("calc/value"), arg0_2.countList[arg1_4])

					arg0_2.count = arg0_2.count + var1_4 * var1_8

					setText(arg0_2.rtExchange:Find("bg/count"), setColorStr(arg0_2.count, "#FFEC6E") .. "/" .. arg0_2.need)
				end
			end)
		end
	end)
	setText(arg0_2._tf:Find("window/cancel_button/label"), i18n("word_cancel"))
	onButton(arg0_2, arg0_2._tf:Find("window/cancel_button"), function()
		arg0_2:Hide()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2._tf:Find("window/confirm_button"), function()
		if arg0_2.count <= 0 then
			return
		end

		local var0_10 = {}

		if arg0_2.isSwitch and not arg0_2.blueprintVO:IsFate() then
			table.insert(var0_10, function(arg0_11)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("blueprint_lab_exchange_fate_unlock"),
					onYes = arg0_11
				})
			end)
		end

		seriesAsync(var0_10, function()
			local var0_12 = {}

			for iter0_12, iter1_12 in ipairs(arg0_2.displayList) do
				if arg0_2.countList[iter0_12] > 0 then
					table.insert(var0_12, {
						id = iter1_12.id,
						count = arg0_2.countList[iter0_12],
						arg = Item.getConfigData(iter1_12.id).usage_arg[arg0_2.awardList[iter0_12].index]
					})
				end
			end

			arg0_2:emit(ShipBluePrintMediator.QUICK_EXCHAGE_BLUEPRINT, var0_12)
			arg0_2:Hide()
		end)
	end, SFX_CANCEL)

	arg0_2.rtResult = arg0_2._tf:Find("window/result")
	arg0_2.rtTarget = arg0_2.rtResult:Find("target")
	arg0_2.rtExchange = arg0_2.rtResult:Find("exchange")
	arg0_2.fate = arg0_2.rtResult:Find("fate")
	arg0_2.fateText = arg0_2.fate:Find("Text")

	setText(arg0_2.rtExchange:Find("bg/title"), i18n("blueprint_exchange_select_display"))

	arg0_2.toggleSwitch = arg0_2.rtResult:Find("switch")

	setText(arg0_2.toggleSwitch:Find("front/Text_off"), i18n("show_fate_demand_count"))
	setText(arg0_2.toggleSwitch:Find("front/Text_on"), i18n("show_design_demand_count"))
	onToggle(arg0_2, arg0_2.toggleSwitch, function(arg0_13)
		arg0_2.isSwitch = arg0_13

		arg0_2:UpdateResult()
		setActive(arg0_2.fate, arg0_2.isSwitch)
	end)
end

function var0_0.Show(arg0_14)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	setActive(arg0_14._tf, true)
end

function var0_0.Hide(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf, arg0_15._parentTf)
	setActive(arg0_15._tf, false)
end

function var0_0.UpdateBlueprint(arg0_16, arg1_16)
	arg0_16.blueprintVO = arg1_16

	local var0_16 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1_16:getItemId()
	})

	changeToScrollText(arg0_16.rtResult:Find("title/Text"), var0_16:getName())

	arg0_16.displayList = {}
	arg0_16.awardList = {}

	local var1_16 = getProxy(BagProxy)

	for iter0_16, iter1_16 in ipairs(pg.gameset.general_blueprint_list.description) do
		local var2_16 = var1_16:getItemCountById(iter1_16)

		if var2_16 > 0 then
			local var3_16

			for iter2_16, iter3_16 in ipairs(Drop.New({
				type = DROP_TYPE_ITEM,
				id = iter1_16
			}):getConfig("display_icon")) do
				if iter3_16[1] == DROP_TYPE_ITEM and iter3_16[2] == var0_16.id then
					var3_16 = {
						index = iter2_16,
						count = iter3_16[3]
					}
				end
			end

			if var3_16 then
				table.insert(arg0_16.displayList, {
					type = DROP_TYPE_ITEM,
					id = iter1_16,
					count = var2_16
				})
				table.insert(arg0_16.awardList, var3_16)
			end
		end
	end

	setActive(arg0_16.rtEmpty, #arg0_16.displayList == 0)
	setActive(arg0_16.itemList.container, #arg0_16.displayList > 0)
	updateDrop(arg0_16.rtResult:Find("target/IconTpl"), var0_16)
	GetImageSpriteFromAtlasAsync("ui/fragresolveui_atlas", "bg_" .. ItemRarity.Rarity2Print(var0_16:getConfig("rarity")), arg0_16.rtResult:Find("target/bg"))

	arg0_16.countList = underscore.map(arg0_16.displayList, function(arg0_17)
		return 0
	end)
	arg0_16.count = 0

	arg0_16.itemList:align(#arg0_16.displayList)
	triggerToggle(arg0_16.toggleSwitch, arg1_16:canFateSimulation())
	setText(arg0_16.fateText, arg1_16:IsFate() and i18n("blueprint_lab_fate_unlock") or i18n("blueprint_lab_fate_lock"))
end

function var0_0.UpdateResult(arg0_18)
	arg0_18.bagProxy = arg0_18.bagProxy or getProxy(BagProxy)
	arg0_18.need = math.max(arg0_18.blueprintVO:getUseageMaxItem() + (arg0_18.isSwitch and arg0_18.blueprintVO:getFateMaxLeftOver() or 0) - arg0_18.bagProxy:getItemCountById(arg0_18.blueprintVO:getItemId()), 0)

	local var0_18 = #arg0_18.displayList

	while var0_18 > 0 and arg0_18.count > arg0_18.need do
		if arg0_18.countList[var0_18] > 0 then
			local var1_18 = arg0_18.awardList[var0_18].count
			local var2_18 = math.floor((arg0_18.count - arg0_18.need + var1_18 - 1) / var1_18)

			if var2_18 > arg0_18.countList[var0_18] then
				arg0_18.count = arg0_18.count - var1_18 * arg0_18.countList[var0_18]
				arg0_18.countList[var0_18] = 0
			else
				arg0_18.count = arg0_18.count - var1_18 * var2_18
				arg0_18.countList[var0_18] = arg0_18.countList[var0_18] - var2_18
			end

			setText(arg0_18.itemList.container:GetChild(var0_18 - 1):Find("calc/value"), arg0_18.countList[var0_18])
		end

		var0_18 = var0_18 - 1
	end

	setText(arg0_18.rtExchange:Find("bg/count"), setColorStr(arg0_18.count, "#FFEC6E") .. "/" .. arg0_18.need)
end

return var0_0

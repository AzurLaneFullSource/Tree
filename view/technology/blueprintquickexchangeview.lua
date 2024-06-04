local var0 = class("BlueprintQuickExchangeView", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "BlueprintQuickExchangeUI"
end

function var0.OnInit(arg0)
	arg0.rtBg = arg0._tf:Find("bg")

	onButton(arg0, arg0.rtBg, function()
		arg0:Hide()
	end, SFX_CANCEL)

	arg0.rtPreview = arg0._tf:Find("window/preview/got")
	arg0.rtEmpty = arg0.rtPreview:Find("empty")

	setText(arg0.rtEmpty:Find("Text"), i18n("blueprint_exchange_empty_tip"))

	local var0 = arg0.rtPreview:Find("list")

	arg0.itemList = UIItemList.New(var0, var0:Find("item"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.displayList[arg1]
			local var1 = arg0.awardList[arg1].count

			updateDrop(arg2:Find("icon"), var0)
			onButton(arg0, arg2:Find("icon"), function()
				arg0:emit(BaseUI.ON_DROP, var0)
			end, SFX_PANEL)
			setText(arg2:Find("calc/value"), arg0.countList[arg1])
			setScrollText(arg2:Find("name/Text"), var0:getConfig("name"))
			setText(arg2:Find("kc"), i18n("tec_tip_material_stock") .. ":" .. var0.count)
			pressPersistTrigger(arg2:Find("calc/plus"), 0.5, function()
				if var0.count > arg0.countList[arg1] and arg0.count + var1 <= arg0.need then
					arg0.countList[arg1] = arg0.countList[arg1] + 1

					setText(arg2:Find("calc/value"), arg0.countList[arg1])

					arg0.count = arg0.count + var1

					setText(arg0.rtExchange:Find("bg/count"), setColorStr(arg0.count, "#FFEC6E") .. "/" .. arg0.need)
				end
			end, nil, true, true, 0.1, SFX_PANEL)
			pressPersistTrigger(arg2:Find("calc/minus"), 0.5, function()
				if arg0.countList[arg1] > 0 then
					arg0.countList[arg1] = arg0.countList[arg1] - 1

					setText(arg2:Find("calc/value"), arg0.countList[arg1])

					arg0.count = arg0.count - var1

					setText(arg0.rtExchange:Find("bg/count"), setColorStr(arg0.count, "#FFEC6E") .. "/" .. arg0.need)
				end
			end, nil, true, true, 0.1, SFX_PANEL)
			onButton(arg0, arg2:Find("calc/max"), function()
				if var0.count > arg0.countList[arg1] and arg0.count + var1 <= arg0.need then
					local var0 = math.floor((arg0.need - arg0.count + var1 - 1) / var1)
					local var1 = math.min(var0, var0.count - arg0.countList[arg1])

					arg0.countList[arg1] = arg0.countList[arg1] + var1

					setText(arg2:Find("calc/value"), arg0.countList[arg1])

					arg0.count = arg0.count + var1 * var1

					setText(arg0.rtExchange:Find("bg/count"), setColorStr(arg0.count, "#FFEC6E") .. "/" .. arg0.need)
				end
			end)
		end
	end)
	setText(arg0._tf:Find("window/cancel_button/label"), i18n("word_cancel"))
	onButton(arg0, arg0._tf:Find("window/cancel_button"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("window/confirm_button"), function()
		if arg0.count <= 0 then
			return
		end

		local var0 = {}

		for iter0, iter1 in ipairs(arg0.displayList) do
			if arg0.countList[iter0] > 0 then
				table.insert(var0, {
					id = iter1.id,
					count = arg0.countList[iter0],
					arg = Item.getConfigData(iter1.id).usage_arg[arg0.awardList[iter0].index]
				})
			end
		end

		arg0:emit(ShipBluePrintMediator.QUICK_EXCHAGE_BLUEPRINT, var0)
		arg0:Hide()
	end, SFX_CANCEL)

	arg0.rtResult = arg0._tf:Find("window/result")
	arg0.rtTarget = arg0.rtResult:Find("target")
	arg0.rtExchange = arg0.rtResult:Find("exchange")

	setText(arg0.rtExchange:Find("bg/title"), i18n("blueprint_exchange_select_display"))

	arg0.toggleSwitch = arg0.rtResult:Find("switch")

	setText(arg0.toggleSwitch:Find("front/Text_off"), i18n("show_design_demand_count"))
	setText(arg0.toggleSwitch:Find("front/Text_on"), i18n("show_fate_demand_count"))
	onToggle(arg0, arg0.toggleSwitch, function(arg0)
		arg0.isSwitch = arg0

		arg0:UpdateResult()
	end)
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.UpdateBlueprint(arg0, arg1)
	arg0.blueprintVO = arg1

	local var0 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1:getItemId()
	})

	changeToScrollText(arg0.rtResult:Find("title/Text"), var0:getName())

	arg0.displayList = {}
	arg0.awardList = {}

	local var1 = getProxy(BagProxy)

	for iter0, iter1 in ipairs(pg.gameset.general_blueprint_list.description) do
		local var2 = var1:getItemCountById(iter1)

		if var2 > 0 then
			local var3

			for iter2, iter3 in ipairs(Drop.New({
				type = DROP_TYPE_ITEM,
				id = iter1
			}):getConfig("display_icon")) do
				if iter3[1] == DROP_TYPE_ITEM and iter3[2] == var0.id then
					var3 = {
						index = iter2,
						count = iter3[3]
					}
				end
			end

			if var3 then
				table.insert(arg0.displayList, {
					type = DROP_TYPE_ITEM,
					id = iter1,
					count = var2
				})
				table.insert(arg0.awardList, var3)
			end
		end
	end

	setActive(arg0.rtEmpty, #arg0.displayList == 0)
	setActive(arg0.itemList.container, #arg0.displayList > 0)
	updateDrop(arg0.rtResult:Find("target/IconTpl"), var0)
	GetImageSpriteFromAtlasAsync("ui/fragresolveui_atlas", "bg_" .. ItemRarity.Rarity2Print(var0:getConfig("rarity")), arg0.rtResult:Find("target/bg"))

	arg0.countList = underscore.map(arg0.displayList, function(arg0)
		return 0
	end)
	arg0.count = 0

	arg0.itemList:align(#arg0.displayList)
	triggerToggle(arg0.toggleSwitch, arg1:canFateSimulation())
end

function var0.UpdateResult(arg0)
	arg0.bagProxy = arg0.bagProxy or getProxy(BagProxy)
	arg0.need = math.max(arg0.blueprintVO:getUseageMaxItem() + (arg0.isSwitch and arg0.blueprintVO:getFateMaxLeftOver() or 0) - arg0.bagProxy:getItemCountById(arg0.blueprintVO:getItemId()), 0)

	local var0 = #arg0.displayList

	while var0 > 0 and arg0.count > arg0.need do
		if arg0.countList[var0] > 0 then
			local var1 = arg0.awardList[var0].count
			local var2 = math.floor((arg0.count - arg0.need + var1 - 1) / var1)

			if var2 > arg0.countList[var0] then
				arg0.count = arg0.count - var1 * arg0.countList[var0]
				arg0.countList[var0] = 0
			else
				arg0.count = arg0.count - var1 * var2
				arg0.countList[var0] = arg0.countList[var0] - var2
			end

			setText(arg0.itemList.container:GetChild(var0 - 1):Find("calc/value"), arg0.countList[var0])
		end

		var0 = var0 - 1
	end

	setText(arg0.rtExchange:Find("bg/count"), setColorStr(arg0.count, "#FFEC6E") .. "/" .. arg0.need)
end

return var0

local var0_0 = class("IslandMsgBoxSingleMaterialWindow", import(".IslandMsgBoxSingleItemWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxWithSingleMaterial"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.valueTxt = arg0_2:findTF("calc/value/Text"):GetComponent(typeof(Text))
	arg0_2.addBtn = arg0_2:findTF("calc/add")
	arg0_2.reduceBtn = arg0_2:findTF("calc/reduce")
	arg0_2.sellBtn = arg0_2:findTF("calc/sell_btn")
	arg0_2.priceTxt = arg0_2:findTF("calc/sell_btn/price/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("calc/sell_btn/Text"), i18n1("出售"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings

	onButton(arg0_3, arg0_3.addBtn, function()
		local var0_4 = arg0_3.value + 1

		arg0_3:UpdateValue(var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.reduceBtn, function()
		local var0_5 = arg0_3.value - 1

		arg0_3:UpdateValue(var0_5)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sellBtn, function()
		local var0_6 = arg0_3.item:GetSellingPrice()
		local var1_6 = var0_6:getName()
		local var2_6 = arg0_3.item:GetName()
		local var3_6 = arg0_3.value
		local var4_6 = var0_6.count * arg0_3.value

		arg0_3:GetMsgBoxMgr():Show({
			content = i18n1(string.format("是否确认出售,%sx%d\n获得%sx%d", var2_6, var3_6, var1_6, var4_6)),
			onYes = function()
				arg0_3:emit(IslandMediator.ON_SELL_ITEM, arg0_3.item.id, arg0_3.value)
				arg0_3:Hide()
			end
		})
	end, SFX_PANEL)
	arg0_3:bind(GAME.ISLAND_SELL_ITEM_DONE, function()
		arg0_3:FlushCalc(arg0_3.item.id)
	end)

	local var1_3 = var0_3.itemId

	arg0_3:FlushCalc(var1_3)
end

function var0_0.FlushCalc(arg0_9, arg1_9)
	arg0_9.item = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetItemById(arg1_9) or IslandItem.New({
		id = arg1_9
	})
	arg0_9.value = 1

	arg0_9:UpdateValue(arg0_9.value)
end

function var0_0.UpdateValue(arg0_10, arg1_10)
	arg0_10.value = math.max(1, math.min(arg1_10, arg0_10.item:GetCount()))

	local var0_10 = arg0_10.item:GetSellingPrice()

	arg0_10.priceTxt.text = "x" .. var0_10.count * arg0_10.value
	arg0_10.valueTxt.text = arg0_10.value
end

return var0_0

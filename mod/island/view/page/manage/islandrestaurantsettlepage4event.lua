local var0_0 = class("IslandRestaurantSettlePage4Event", import(".IslandRestaurantSettlePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRestaurantSettle4EventUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.additionList = UIItemList.New(arg0_2._tf:Find("window/event/addition"), arg0_2._tf:Find("window/event/addition/tpl"))
	arg0_2.priceAdd = arg0_2._tf:Find("window/summary/price/info/addition/Text"):GetComponent(typeof(Text))

	setText(arg0_2._tf:Find("window/event/Image/Text"), i18n("island_post_event_label"))
end

function var0_0.OnShow(arg0_3, arg1_3, arg2_3)
	arg0_3:UpdateAddition(arg1_3)
	arg0_3:UpdatePriceAdd(arg1_3)

	arg0_3.itemList = arg1_3.itemList or {}

	var0_0.super.OnShow(arg0_3, arg1_3, arg2_3)
end

function var0_0.UpdateAddition(arg0_4, arg1_4)
	local var0_4 = pg.island_manage_event[arg1_4.spEventID]
	local var1_4 = arg0_4:WarpAdditionInfo(var0_4)

	arg0_4.additionList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			setText(arg2_5:Find("Text"), var1_4[arg1_5 + 1][1])
			setText(arg2_5:Find("value"), "+" .. var1_4[arg1_5 + 1][2] .. "%")
		end
	end)
	arg0_4.additionList:align(#var1_4)
end

function var0_0.WarpAdditionInfo(arg0_6, arg1_6)
	local var0_6 = {}

	table.insert(var0_6, {
		i18n("island_addition_influence"),
		arg1_6.influence_bonus
	})
	table.insert(var0_6, {
		i18n("island_addition_sale"),
		arg1_6.event_effect[1][1]
	})

	return var0_6
end

function var0_0.UpdatePriceAdd(arg0_7, arg1_7)
	arg0_7.priceAdd.text = "(+" .. arg1_7.priceAdd .. ")"
end

function var0_0.UpdateCommonItem(arg0_8, arg1_8, arg2_8)
	var0_0.super.UpdateCommonItem(arg0_8, arg1_8, arg2_8)
	setActive(arg1_8:Find("event"), table.contains(arg0_8.itemList, arg2_8.id))
end

return var0_0

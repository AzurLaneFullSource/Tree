local var0_0 = class("IslandShipOrderDelegateSlot")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.showTime = arg1_1.view_time
	arg0_1.request = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.cost or {}) do
		table.insert(arg0_1.request, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_1.id,
			count = iter1_1.num
		})
	end

	arg0_1.awards = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.reward or {}) do
		table.insert(arg0_1.awards, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter3_1.id,
			count = iter3_1.num
		})
	end
end

function var0_0.GetShowTime(arg0_2)
	return arg0_2.showTime
end

function var0_0.CanShow(arg0_3)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_3.showTime
end

function var0_0.GetRequestList(arg0_4)
	return arg0_4.request
end

function var0_0.GetAwardList(arg0_5)
	return arg0_5.awards
end

return var0_0

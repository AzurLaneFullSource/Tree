local var0_0 = class("NewServerShop", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.startTime = arg1_1.start_time
	arg0_1.stopTime = arg1_1.stop_time
	arg0_1.goods = {}
	arg0_1.phases = {}
	arg0_1.activityId = arg1_1.id

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.goods) do
		var0_1[iter1_1.id] = NewServerCommodity.New(iter1_1)
	end

	local var1_1 = getProxy(ActivityProxy):getActivityById(arg0_1.activityId)
	local var2_1 = {}

	for iter2_1, iter3_1 in ipairs(var1_1:getConfig("config_data")) do
		var2_1[iter3_1] = true
	end

	local var3_1 = pg.newserver_shop_template.get_id_list_by_unlock_time

	for iter4_1, iter5_1 in pairs(var3_1) do
		local var4_1 = arg0_1:WrapPhaseGoods(iter5_1, var0_1, var2_1)

		arg0_1.goods[iter4_1] = var4_1

		table.insert(arg0_1.phases, iter4_1)
	end
end

function var0_0.GetPtId(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(arg0_2.activityId):getConfig("config_data")

	return pg.newserver_shop_template[var0_2[1]].resource_type
end

function var0_0.WrapPhaseGoods(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		if arg3_3[iter1_3] then
			local var1_3 = arg2_3[iter1_3] or NewServerCommodity.New({
				id = iter1_3
			})

			var0_3[var1_3.id] = var1_3
		end
	end

	return var0_3
end

function var0_0.GetStartTime(arg0_4)
	return arg0_4.startTime
end

function var0_0.GetEndTime(arg0_5)
	return arg0_5.stopTime
end

function var0_0.GetCommodityById(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.goods) do
		for iter2_6, iter3_6 in pairs(iter1_6) do
			if iter2_6 == arg1_6 then
				return iter3_6
			end
		end
	end
end

function var0_0.GetOpeningGoodsList(arg0_7, arg1_7)
	local var0_7 = {}
	local var1_7 = arg0_7.goods[arg1_7]

	for iter0_7, iter1_7 in pairs(var1_7) do
		table.insert(var0_7, iter1_7)
	end

	return var0_7
end

function var0_0.IsOpenPhase(arg0_8, arg1_8)
	local var0_8 = arg0_8.phases[arg1_8]

	return arg0_8:GetStartTime() + var0_8 <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetPhases(arg0_9)
	return arg0_9.phases
end

return var0_0

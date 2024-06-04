local var0 = class("NewServerShop", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.startTime = arg1.start_time
	arg0.stopTime = arg1.stop_time
	arg0.goods = {}
	arg0.phases = {}
	arg0.activityId = arg1.id

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.goods) do
		var0[iter1.id] = NewServerCommodity.New(iter1)
	end

	local var1 = getProxy(ActivityProxy):getActivityById(arg0.activityId)
	local var2 = {}

	for iter2, iter3 in ipairs(var1:getConfig("config_data")) do
		var2[iter3] = true
	end

	local var3 = pg.newserver_shop_template.get_id_list_by_unlock_time

	for iter4, iter5 in pairs(var3) do
		local var4 = arg0:WrapPhaseGoods(iter5, var0, var2)

		arg0.goods[iter4] = var4

		table.insert(arg0.phases, iter4)
	end
end

function var0.GetPtId(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.activityId):getConfig("config_data")

	return pg.newserver_shop_template[var0[1]].resource_type
end

function var0.WrapPhaseGoods(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		if arg3[iter1] then
			local var1 = arg2[iter1] or NewServerCommodity.New({
				id = iter1
			})

			var0[var1.id] = var1
		end
	end

	return var0
end

function var0.GetStartTime(arg0)
	return arg0.startTime
end

function var0.GetEndTime(arg0)
	return arg0.stopTime
end

function var0.GetCommodityById(arg0, arg1)
	for iter0, iter1 in pairs(arg0.goods) do
		for iter2, iter3 in pairs(iter1) do
			if iter2 == arg1 then
				return iter3
			end
		end
	end
end

function var0.GetOpeningGoodsList(arg0, arg1)
	local var0 = {}
	local var1 = arg0.goods[arg1]

	for iter0, iter1 in pairs(var1) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.IsOpenPhase(arg0, arg1)
	local var0 = arg0.phases[arg1]

	return arg0:GetStartTime() + var0 <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.GetPhases(arg0)
	return arg0.phases
end

return var0

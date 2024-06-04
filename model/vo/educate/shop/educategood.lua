local var0 = class("EducateGood", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.remainCnt = arg1.num

	arg0:initTime()
end

function var0.bindConfigTable(arg0)
	return pg.child_shop_template
end

function var0.IsAlwaysTime(arg0)
	return arg0:getConfig("time") == "always"
end

function var0.initTime(arg0)
	if not arg0:IsAlwaysTime() then
		local var0 = arg0:getConfig("time")

		arg0.startTime, arg0.endTime = EducateHelper.CfgTime2Time(var0)
	end
end

function var0.CanBuy(arg0)
	return arg0:GetRemainCnt() > 0
end

function var0.GetRemainCnt(arg0)
	return arg0.remainCnt
end

function var0.ReduceRemainCnt(arg0, arg1)
	arg0.remainCnt = arg0.remainCnt - arg1
end

function var0.GetCost(arg0, arg1)
	return {
		id = arg0:getConfig("resource"),
		num = arg0:GetPrice(arg1)
	}
end

function var0.GetPrice(arg0, arg1)
	local var0 = arg0:getConfig("resource_num")

	if not arg1 then
		return var0
	end

	return math.floor(var0 * (1 - arg1 / 10000))
end

function var0.GetShowInfo(arg0)
	return {
		type = EducateConst.DROP_TYPE_ITEM,
		id = arg0:getConfig("item_id"),
		number = arg0:getConfig("buy_num")
	}
end

function var0.InTime(arg0, arg1)
	if not arg0:IsAlwaysTime() then
		return EducateHelper.InTime(arg1, arg0.startTime, arg0.endTime)
	else
		return true
	end
end

return var0

local var0_0 = class("EducateGood", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.remainCnt = arg1_1.num

	arg0_1:initTime()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_shop_template
end

function var0_0.IsAlwaysTime(arg0_3)
	return arg0_3:getConfig("time") == "always"
end

function var0_0.initTime(arg0_4)
	if not arg0_4:IsAlwaysTime() then
		local var0_4 = arg0_4:getConfig("time")

		arg0_4.startTime, arg0_4.endTime = EducateHelper.CfgTime2Time(var0_4)
	end
end

function var0_0.CanBuy(arg0_5)
	return arg0_5:GetRemainCnt() > 0
end

function var0_0.GetRemainCnt(arg0_6)
	return arg0_6.remainCnt
end

function var0_0.ReduceRemainCnt(arg0_7, arg1_7)
	arg0_7.remainCnt = arg0_7.remainCnt - arg1_7
end

function var0_0.GetCost(arg0_8, arg1_8)
	return {
		id = arg0_8:getConfig("resource"),
		num = arg0_8:GetPrice(arg1_8)
	}
end

function var0_0.GetPrice(arg0_9, arg1_9)
	local var0_9 = arg0_9:getConfig("resource_num")

	if not arg1_9 then
		return var0_9
	end

	return math.floor(var0_9 * (1 - arg1_9 / 10000))
end

function var0_0.GetShowInfo(arg0_10)
	return {
		type = EducateConst.DROP_TYPE_ITEM,
		id = arg0_10:getConfig("item_id"),
		number = arg0_10:getConfig("buy_num")
	}
end

function var0_0.InTime(arg0_11, arg1_11)
	if not arg0_11:IsAlwaysTime() then
		return EducateHelper.InTime(arg1_11, arg0_11.startTime, arg0_11.endTime)
	else
		return true
	end
end

return var0_0

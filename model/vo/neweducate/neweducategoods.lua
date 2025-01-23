local var0_0 = class("NewEducateGoods", import("model.vo.BaseVO"))

var0_0.TYPE = {
	ATTR = 2,
	RES = 3,
	BENEFIT = 1
}

function var0_0.bindConfigTable(arg0_1)
	return pg.child2_shop
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg0_2.id
	arg0_2.buyCnt = arg2_2 or 0
end

function var0_0.IsLimitTime(arg0_3)
	return arg0_3:getConfig("is_refresh") == 1
end

function var0_0.GetLimitCnt(arg0_4)
	return arg0_4:getConfig("limit_num")
end

function var0_0.IsLimitCnt(arg0_5)
	return arg0_5:GetLimitCnt() ~= -1
end

function var0_0.GetRemainCnt(arg0_6)
	return arg0_6:IsLimitCnt() and arg0_6:GetLimitCnt() - arg0_6.buyCnt or 9999
end

function var0_0.GetCostCondition(arg0_7)
	return {
		operator = ">=",
		type = NewEducateConst.DROP_TYPE.RES,
		id = arg0_7:getConfig("resource_type"),
		number = arg0_7:getConfig("resource_num")
	}
end

function var0_0.GetCostWithBenefit(arg0_8, arg1_8)
	local var0_8 = Clone(arg0_8:GetCostCondition())

	if arg1_8[var0_8.type] then
		local var1_8 = arg1_8[var0_8.type][var0_8.id]

		if var1_8 then
			var0_8.number = NewEducateHelper.GetBenefitValue(var0_8.number, var1_8)
		end
	end

	return var0_8
end

function var0_0.AddBuyCnt(arg0_9, arg1_9)
	arg0_9.buyCnt = arg0_9.buyCnt + arg1_9
end

function var0_0.IsBenefitType(arg0_10)
	return arg0_10:getConfig("goods_type") == var0_0.TYPE.BENEFIT
end

function var0_0.IsResType(arg0_11)
	return arg0_11:getConfig("goods_type") == var0_0.TYPE.RES
end

return var0_0

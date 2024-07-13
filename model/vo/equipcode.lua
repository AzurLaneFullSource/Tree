local var0_0 = class("EquipCode", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.shipGroupId = arg1_1.shipGroupId
	arg0_1.str = arg1_1.eqcode
	arg0_1.new = arg1_1.new
	arg0_1.like = arg1_1.like
	arg0_1.evaPoint = arg1_1.eval_point
	arg0_1.state = arg1_1.state

	local var0_1 = string.split(arg0_1.str, "&")

	arg0_1.valid = #var0_1 == 4 and arg0_1.shipGroupId == tonumber(var0_1[2], 32)
	arg0_1.tags = {
		tonumber(var0_1[3]),
		tonumber(var0_1[4])
	}
end

function var0_0.IsValid(arg0_2)
	return arg0_2.valid
end

function var0_0.GetLabels(arg0_3)
	return arg0_3.tags
end

function var0_0.MarkLike(arg0_4)
	arg0_4.afterLike = true
end

return var0_0

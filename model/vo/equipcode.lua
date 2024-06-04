local var0 = class("EquipCode", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.shipGroupId = arg1.shipGroupId
	arg0.str = arg1.eqcode
	arg0.new = arg1.new
	arg0.like = arg1.like
	arg0.evaPoint = arg1.eval_point
	arg0.state = arg1.state

	local var0 = string.split(arg0.str, "&")

	arg0.valid = #var0 == 4 and arg0.shipGroupId == tonumber(var0[2], 32)
	arg0.tags = {
		tonumber(var0[3]),
		tonumber(var0[4])
	}
end

function var0.IsValid(arg0)
	return arg0.valid
end

function var0.GetLabels(arg0)
	return arg0.tags
end

function var0.MarkLike(arg0)
	arg0.afterLike = true
end

return var0

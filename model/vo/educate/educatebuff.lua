local var0 = class("EducateBuff", import("model.vo.BaseVO"))

var0.TYPE_ATTR = 1
var0.TYPE_RES = 2
var0.ADDITION_TYPE_RATIO = 1
var0.ADDITION_TYPE_NUMBER = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.endTime = arg1.time or EducateHelper.GetTimeAfterWeeks(getProxy(EducateProxy):GetCurTime(), arg0:getConfig("during_time"))
end

function var0.bindConfigTable(arg0)
	return pg.child_buff
end

function var0.GetReaminTime(arg0, arg1)
	arg1 = arg1 or getProxy(EducateProxy):GetCurTime()

	return EducateHelper.GetDaysBetweenTimes(arg1, arg0.endTime)
end

function var0.GetReaminWeek(arg0, arg1)
	local var0 = arg0:GetReaminTime(arg1)

	if var0 == 0 then
		return 0
	else
		return var0 / 7
	end
end

function var0.ResetEndTime(arg0, arg1)
	arg1 = arg1 or getProxy(EducateProxy):GetCurTime()
	arg0.endTime = EducateHelper.GetTimeAfterWeeks(arg1, arg0:getConfig("during_time"))
end

function var0.IsEnd(arg0, arg1)
	return arg0:GetReaminTime(arg1) < 0
end

function var0.IsAttrType(arg0)
	return arg0:getConfig("effect")[1] == var0.TYPE_ATTR
end

function var0.IsResType(arg0)
	return arg0:getConfig("effect")[1] == var0.TYPE_RES
end

function var0.IsId(arg0, arg1)
	return arg0:getConfig("effect")[2] == arg1
end

function var0.IsRatio(arg0)
	return arg0:getConfig("effect")[3] == var0.ADDITION_TYPE_RATIO
end

function var0.IsNumber(arg0)
	return arg0:getConfig("effect")[3] == var0.ADDITION_TYPE_NUMBER
end

function var0.GetEffectValue(arg0)
	if arg0:IsRatio() then
		return arg0:getConfig("effect")[4] / 10000
	elseif arg0:IsNumber() then
		return arg0:getConfig("effect")[4]
	end

	return 0
end

function var0.GetBuffEffects(arg0)
	local var0 = 0
	local var1 = 0

	underscore.each(arg0, function(arg0)
		if arg0:IsRatio() then
			var0 = var0 + arg0:GetEffectValue()
		elseif arg0:IsNumber() then
			var1 = var1 + arg0:GetEffectValue()
		end
	end)

	return var0, var1
end

return var0

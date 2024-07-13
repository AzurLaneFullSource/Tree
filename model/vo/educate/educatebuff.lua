local var0_0 = class("EducateBuff", import("model.vo.BaseVO"))

var0_0.TYPE_ATTR = 1
var0_0.TYPE_RES = 2
var0_0.ADDITION_TYPE_RATIO = 1
var0_0.ADDITION_TYPE_NUMBER = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.endTime = arg1_1.time or EducateHelper.GetTimeAfterWeeks(getProxy(EducateProxy):GetCurTime(), arg0_1:getConfig("during_time"))
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_buff
end

function var0_0.GetReaminTime(arg0_3, arg1_3)
	arg1_3 = arg1_3 or getProxy(EducateProxy):GetCurTime()

	return EducateHelper.GetDaysBetweenTimes(arg1_3, arg0_3.endTime)
end

function var0_0.GetReaminWeek(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetReaminTime(arg1_4)

	if var0_4 == 0 then
		return 0
	else
		return var0_4 / 7
	end
end

function var0_0.ResetEndTime(arg0_5, arg1_5)
	arg1_5 = arg1_5 or getProxy(EducateProxy):GetCurTime()
	arg0_5.endTime = EducateHelper.GetTimeAfterWeeks(arg1_5, arg0_5:getConfig("during_time"))
end

function var0_0.IsEnd(arg0_6, arg1_6)
	return arg0_6:GetReaminTime(arg1_6) < 0
end

function var0_0.IsAttrType(arg0_7)
	return arg0_7:getConfig("effect")[1] == var0_0.TYPE_ATTR
end

function var0_0.IsResType(arg0_8)
	return arg0_8:getConfig("effect")[1] == var0_0.TYPE_RES
end

function var0_0.IsId(arg0_9, arg1_9)
	return arg0_9:getConfig("effect")[2] == arg1_9
end

function var0_0.IsRatio(arg0_10)
	return arg0_10:getConfig("effect")[3] == var0_0.ADDITION_TYPE_RATIO
end

function var0_0.IsNumber(arg0_11)
	return arg0_11:getConfig("effect")[3] == var0_0.ADDITION_TYPE_NUMBER
end

function var0_0.GetEffectValue(arg0_12)
	if arg0_12:IsRatio() then
		return arg0_12:getConfig("effect")[4] / 10000
	elseif arg0_12:IsNumber() then
		return arg0_12:getConfig("effect")[4]
	end

	return 0
end

function var0_0.GetBuffEffects(arg0_13)
	local var0_13 = 0
	local var1_13 = 0

	underscore.each(arg0_13, function(arg0_14)
		if arg0_14:IsRatio() then
			var0_13 = var0_13 + arg0_14:GetEffectValue()
		elseif arg0_14:IsNumber() then
			var1_13 = var1_13 + arg0_14:GetEffectValue()
		end
	end)

	return var0_13, var1_13
end

return var0_0

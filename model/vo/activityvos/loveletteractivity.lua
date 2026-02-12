local var0_0 = class("LoveLetterActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.GetDailyProgress(arg0_2)
	return arg0_2.data2, arg0_2:getConfig("config_data")[2] * arg0_2:getNDay()
end

function var0_0.AddDailyProgress(arg0_3, arg1_3)
	arg0_3.data2 = arg0_3.data2 + arg1_3

	assert(arg0_3.data2 <= arg0_3:getConfig("config_data")[2] * arg0_3:getNDay())
end

function var0_0.DayReset(arg0_4)
	return
end

function var0_0.SetTargetGroupId(arg0_5, arg1_5)
	arg0_5.data1 = arg1_5
end

function var0_0.GetTargetGroupId(arg0_6)
	return arg0_6.data1
end

function var0_0.AddChangeCount(arg0_7)
	arg0_7.data3 = arg0_7.data3 + 1
end

function var0_0.GetChangeCount(arg0_8)
	return arg0_8.data3, arg0_8:getConfig("config_data")[3]
end

function var0_0.IsLimitExpItem(arg0_9, arg1_9)
	return arg1_9 == arg0_9:getConfig("config_data")[1]
end

function var0_0.FilterExp(arg0_10, arg1_10)
	local var0_10, var1_10 = arg0_10:GetDailyProgress()

	return math.min(arg1_10, var1_10 - var0_10)
end

return var0_0

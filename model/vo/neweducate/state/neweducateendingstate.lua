local var0_0 = class("NewEducateEndingState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.endings = arg1_1.ends or {}
	arg0_1.selEnding = arg1_1.select or 0
end

function var0_0.SetEndings(arg0_2, arg1_2)
	arg0_2.endings = arg1_2
end

function var0_0.GetEndings(arg0_3)
	return arg0_3.endings
end

function var0_0.SelEnding(arg0_4, arg1_4)
	arg0_4.selEnding = arg1_4
end

function var0_0.IsFinish(arg0_5)
	return arg0_5.selEnding ~= 0
end

function var0_0.Reset(arg0_6)
	arg0_6.endings = {}
	arg0_6.selEnding = 0
end

return var0_0

local var0_0 = class("NewEducateAssessState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.finishFlag = arg1_1.is_finished == 1
end

function var0_0.MarkFinish(arg0_2)
	arg0_2.finishFlag = true
end

function var0_0.IsFinish(arg0_3)
	if getProxy(NewEducateProxy):GetCurChar():GetAssessRankIdx() == 0 then
		return true
	end

	return arg0_3.finishFlag
end

function var0_0.Reset(arg0_4)
	arg0_4.finishFlag = false
end

return var0_0

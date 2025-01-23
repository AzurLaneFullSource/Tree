local var0_0 = class("NewEducateTopicState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.topics = arg1_1.chats or {}
	arg0_1.finishFlag = arg1_1.finished == 1 and true or false
end

function var0_0.SetTopics(arg0_2, arg1_2)
	arg0_2.topics = arg1_2
end

function var0_0.GetTopics(arg0_3)
	return arg0_3.topics
end

function var0_0.MarkFinish(arg0_4)
	arg0_4.finishFlag = true
end

function var0_0.IsFinish(arg0_5)
	return arg0_5.finishFlag
end

function var0_0.Reset(arg0_6)
	arg0_6.topics = {}
	arg0_6.finishFlag = false
end

return var0_0

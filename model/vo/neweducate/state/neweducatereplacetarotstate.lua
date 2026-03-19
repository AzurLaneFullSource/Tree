local var0_0 = class("NewEducateReplaceTarotState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.queueIds = arg1_1
	arg0_1.holdId = 0
end

function var0_0.GetSystemNo(arg0_2)
	return NewEducatePriorityFSM.SYSTEM.REPLACE_TAROT
end

function var0_0.IsPriorityType(arg0_3)
	return true
end

function var0_0.ClearIds(arg0_4)
	arg0_4.queueIds = {}
	arg0_4.holdId = 0
end

function var0_0.IsFinish(arg0_5)
	return #arg0_5.queueIds == 0
end

function var0_0.GetFirstId(arg0_6)
	return arg0_6.queueIds[1]
end

function var0_0.PushId(arg0_7, arg1_7)
	table.insert(arg0_7.queueIds, arg1_7)
end

function var0_0.PopId(arg0_8)
	table.remove(arg0_8.queueIds, 1)
end

function var0_0.SetHoldId(arg0_9, arg1_9)
	arg0_9.holdId = arg1_9
end

function var0_0.GetHoldId(arg0_10)
	return arg0_10.holdId
end

function var0_0.Reset(arg0_11)
	arg0_11.queueIds = {}
	arg0_11.holdId = 0
end

return var0_0

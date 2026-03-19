local var0_0 = class("NewEducateStateMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.roundFSM = NewEducateFSM.New(arg1_1, arg2_1)
	arg0_1.priorityFSM = NewEducatePriorityFSM.New(arg1_1, arg2_1)
end

function var0_0.SetState(arg0_2, arg1_2, arg2_2)
	arg0_2.roundFSM:SetState(arg1_2, arg2_2)
end

function var0_0.GetState(arg0_3, arg1_3)
	return arg0_3.roundFSM:GetState(arg1_3)
end

function var0_0.GetCurState(arg0_4)
	return arg0_4.roundFSM:GetCurState()
end

function var0_0.SetCurNode(arg0_5, arg1_5)
	arg0_5.roundFSM:SetCurNode(arg1_5)
end

function var0_0.GetCurNode(arg0_6)
	return arg0_6.roundFSM:GetCurNode()
end

function var0_0.SetSystemNo(arg0_7, arg1_7)
	arg0_7.roundFSM:SetSystemNo(arg1_7)
end

function var0_0.GetSystemNo(arg0_8)
	return arg0_8.roundFSM:GetSystemNo()
end

function var0_0.CheckStystem(arg0_9)
	return arg0_9.roundFSM:CheckStystem()
end

function var0_0.IsImmediateBenefit(arg0_10)
	return arg0_10.roundFSM:IsImmediateBenefit()
end

function var0_0.GetPriorityState(arg0_11)
	return arg0_11.priorityFSM:GetCurState()
end

function var0_0.CheckPriorityStystem(arg0_12)
	return arg0_12.priorityFSM:CheckStystem()
end

function var0_0.AddReplaceTarotState(arg0_13, arg1_13)
	arg0_13.priorityFSM:AddReplaceTarot(arg1_13)
end

function var0_0.AddChooseState(arg0_14, arg1_14)
	arg0_14.priorityFSM:PushChooseState(arg1_14)
end

function var0_0.AddChooseUpEntryState(arg0_15)
	arg0_15.priorityFSM:PushUpEntryState()
end

function var0_0.Reset(arg0_16)
	arg0_16.roundFSM:Reset()
	arg0_16.priorityFSM:Reset()
end

return var0_0

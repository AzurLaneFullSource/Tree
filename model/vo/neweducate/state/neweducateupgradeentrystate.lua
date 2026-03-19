local var0_0 = class("NewEducateUpgradeEntryState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1)
	arg0_1.finishFlag = false
end

function var0_0.IsPriorityType(arg0_2)
	return true
end

function var0_0.GetSystemNo(arg0_3)
	return NewEducatePriorityFSM.SYSTEM.UPGRADE_ENTRY
end

function var0_0.MarkFinish(arg0_4)
	arg0_4.finishFlag = true
end

function var0_0.IsFinish(arg0_5)
	return arg0_5.finishFlag
end

function var0_0.Reset(arg0_6)
	arg0_6.finishFlag = false
end

return var0_0

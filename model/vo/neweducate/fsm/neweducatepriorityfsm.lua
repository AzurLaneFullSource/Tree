local var0_0 = class("NewEducatePriorityFSM")

var0_0.SYSTEM = {
	UPGRADE_ENTRY = 101,
	REPLACE_TAROT = 999,
	CHOOSE = 100
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.stateStack = {}

	for iter0_1, iter1_1 in ipairs(arg2_1.priority_fsm or {}) do
		table.insert(arg0_1.stateStack, arg0_1:CreatPriorityState(iter1_1))
	end

	arg0_1.replaceTarotState = NewEducateReplaceTarotState.New(arg2_1.tarot_selects)

	if not arg0_1.replaceTarotState:IsFinish() then
		arg0_1:PushReplaceTarotState()
	end
end

function var0_0.CreatPriorityState(arg0_2, arg1_2)
	local var0_2 = arg1_2.cache[1]

	return switch(arg1_2.system_no, {
		[var0_0.SYSTEM.CHOOSE] = function()
			return NewEducateChooseState.New(var0_2.cache_nin1[1])
		end,
		[var0_0.SYSTEM.UPGRADE_ENTRY] = function()
			return NewEducateUpgradeEntryState.New(var0_2.cache_affix_up[1])
		end
	}, function()
		assert(false, "未定义的priority state, no: " .. arg1_2.system_no)
	end)
end

function var0_0.GetCurState(arg0_6)
	return arg0_6.stateStack[1]
end

function var0_0.CheckStystem(arg0_7)
	if arg0_7.stateStack[1] and arg0_7.stateStack[1]:IsFinish() then
		table.remove(arg0_7.stateStack, 1)
	end

	return arg0_7.stateStack[1]
end

function var0_0.IsReplaceStateInStack(arg0_8)
	return underscore.any(arg0_8.stateStack, function(arg0_9)
		return arg0_9:GetSystemNo() == var0_0.SYSTEM.REPLACE_TAROT
	end)
end

function var0_0.AddReplaceTarot(arg0_10, arg1_10)
	arg0_10.replaceTarotState:PushId(arg1_10)

	if not arg0_10:IsReplaceStateInStack() then
		arg0_10:PushReplaceTarotState()
	end
end

function var0_0.PushReplaceTarotState(arg0_11)
	table.insert(arg0_11.stateStack, 1, arg0_11.replaceTarotState)
end

function var0_0.PushChooseState(arg0_12, arg1_12)
	local var0_12 = NewEducateChooseState.New({
		is_from_shop = false,
		selects = {},
		reroll_count = {}
	})

	table.insert(arg0_12.stateStack, 1, var0_12)
end

function var0_0.PushUpEntryState(arg0_13)
	table.insert(arg0_13.stateStack, 1, NewEducateUpgradeEntryState.New({}))
end

function var0_0.Reset(arg0_14)
	arg0_14.stateStack = {}

	arg0_14.replaceTarotState:Reset()
end

return var0_0

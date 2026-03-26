local var0_0 = class("NewEducateFSM")

var0_0.SYSTEM = {
	PLAN = 5,
	MIND = 9,
	FAIL = 999,
	ASSESS = 6,
	MAP = 4,
	CHOOSE = 10,
	ENDING = 8,
	PHASE = 7,
	TOPIC = 3,
	TALENT = 2,
	INIT = 0,
	EVENT = 1
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.systemNo = arg2_1.system_no

	warning("init systemNo", arg0_1.systemNo)

	arg0_1.curNode = arg2_1.current_node or 0

	local var0_1 = arg2_1.cache[1]

	arg0_1.states = {}
	arg0_1.states[var0_0.SYSTEM.INIT] = NewEducateStateBase.New()
	arg0_1.states[var0_0.SYSTEM.EVENT] = NewEducateStateBase.New()

	if #var0_1.cache_talent > 0 then
		arg0_1.states[var0_0.SYSTEM.TALENT] = NewEducateTalentState.New(var0_1.cache_talent[1])
	end

	arg0_1.states[var0_0.SYSTEM.CHOOSE] = NewEducateStateBase.New()

	if #var0_1.cache_chat > 0 then
		arg0_1.states[var0_0.SYSTEM.TOPIC] = NewEducateTopicState.New(var0_1.cache_chat[1])
	end

	if #var0_1.cache_site > 0 then
		arg0_1.states[var0_0.SYSTEM.MAP] = NewEducateMapState.New(arg1_1, var0_1.cache_site[1])
	end

	arg0_1.states[var0_0.SYSTEM.PLAN] = NewEducatePlanState.New(#var0_1.cache_plan > 0 and var0_1.cache_plan[1] or {})

	if #var0_1.cache_eval > 0 then
		arg0_1.states[var0_0.SYSTEM.ASSESS] = NewEducateAssessState.New(var0_1.cache_eval[1])
	elseif arg0_1.systemNo == var0_0.SYSTEM.ASSESS and #var0_1.cache_eval == 0 then
		arg0_1.states[var0_0.SYSTEM.ASSESS] = NewEducateAssessState.New({
			is_finished = 0
		})
	end

	arg0_1.states[var0_0.SYSTEM.PHASE] = NewEducateStateBase.New()

	if #var0_1.cache_end > 0 then
		arg0_1.states[var0_0.SYSTEM.ENDING] = NewEducateEndingState.New(var0_1.cache_end[1])
	end

	if #var0_1.cache_mind > 0 then
		arg0_1.states[var0_0.SYSTEM.MIND] = NewEducateStateBase.New(var0_1.cache_mind[1])
	end
end

function var0_0.SetState(arg0_2, arg1_2, arg2_2)
	arg0_2.states[arg1_2] = arg2_2
end

function var0_0.GetCurNode(arg0_3)
	return arg0_3.curNode
end

function var0_0.SetCurNode(arg0_4, arg1_4)
	arg0_4.curNode = arg1_4
end

function var0_0.GetSystemNo(arg0_5)
	return arg0_5.systemNo
end

function var0_0.SetSystemNo(arg0_6, arg1_6)
	arg0_6.systemNo = arg1_6
end

function var0_0.GetState(arg0_7, arg1_7)
	return arg0_7.states[arg1_7] or nil
end

function var0_0.GetCurState(arg0_8)
	return arg0_8.states[arg0_8.systemNo]
end

function var0_0.CheckStystem(arg0_9)
	warning(arg0_9.curNode, arg0_9.systemNo)

	if arg0_9.curNode ~= 0 then
		return arg0_9.systemNo
	end

	if not arg0_9.states[arg0_9.systemNo]:IsFinish() then
		return arg0_9.systemNo
	end

	return switch(arg0_9.systemNo, {
		[var0_0.SYSTEM.INIT] = function()
			return var0_0.SYSTEM.EVENT
		end,
		[var0_0.SYSTEM.EVENT] = function()
			return var0_0.SYSTEM.TALENT
		end,
		[var0_0.SYSTEM.TALENT] = function()
			return var0_0.SYSTEM.CHOOSE
		end,
		[var0_0.SYSTEM.CHOOSE] = function()
			return var0_0.SYSTEM.MAP
		end,
		[var0_0.SYSTEM.TOPIC] = function()
			return var0_0.SYSTEM.MAP
		end,
		[var0_0.SYSTEM.MAP] = function()
			return var0_0.SYSTEM.MAP
		end,
		[var0_0.SYSTEM.PLAN] = function()
			return var0_0.SYSTEM.ASSESS
		end,
		[var0_0.SYSTEM.ASSESS] = function()
			local var0_17 = getProxy(NewEducateProxy):GetCurChar():GetRoundData()

			if var0_17:IsEndlessFail() then
				return var0_0.SYSTEM.FAIL
			elseif not var0_17:IsEndRound() or var0_17:IsEndless() then
				return var0_0.SYSTEM.PHASE
			else
				return var0_0.SYSTEM.ENDING
			end
		end,
		[var0_0.SYSTEM.PHASE] = function()
			return var0_0.SYSTEM.EVENT
		end,
		[var0_0.SYSTEM.ENDING] = function()
			return var0_0.SYSTEM.ENDING
		end
	}, function()
		return arg0_9.systemNo
	end)
end

function var0_0.Reset(arg0_21)
	for iter0_21, iter1_21 in pairs(arg0_21.states) do
		iter1_21:Reset()
	end

	arg0_21.states[var0_0.SYSTEM.TALENT] = nil
	arg0_21.states[var0_0.SYSTEM.TOPIC] = nil
	arg0_21.states[var0_0.SYSTEM.MAP] = nil
	arg0_21.states[var0_0.SYSTEM.ENDING] = nil
	arg0_21.states[var0_0.SYSTEM.MIND] = nil
end

var0_0.BENEFIT_PENDING = {
	var0_0.SYSTEM.PLAN,
	var0_0.SYSTEM.ASSESS,
	var0_0.SYSTEM.PHASE
}

function var0_0.IsImmediateBenefit(arg0_22)
	return not table.contains(var0_0.BENEFIT_PENDING, arg0_22.systemNo)
end

return var0_0

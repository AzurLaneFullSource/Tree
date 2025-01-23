local var0_0 = class("NewEducateFSM")

var0_0.STYSTEM = {
	PLAN = 5,
	MIND = 9,
	TALENT = 2,
	ASSESS = 6,
	MAP = 4,
	INIT = 0,
	ENDING = 8,
	PHASE = 7,
	TOPIC = 3,
	EVENT = 1
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.stystemNo = arg2_1.system_no
	arg0_1.curNode = arg2_1.current_node or 0

	local var0_1 = arg2_1.cache[1]

	arg0_1.states = {}
	arg0_1.states[var0_0.STYSTEM.INIT] = NewEducateStateBase.New()
	arg0_1.states[var0_0.STYSTEM.EVENT] = NewEducateStateBase.New()

	if #var0_1.cache_talent > 0 then
		arg0_1.states[var0_0.STYSTEM.TALENT] = NewEducateTalentState.New(var0_1.cache_talent[1])
	end

	if #var0_1.cache_chat > 0 then
		arg0_1.states[var0_0.STYSTEM.TOPIC] = NewEducateTopicState.New(var0_1.cache_chat[1])
	end

	if #var0_1.cache_site > 0 then
		arg0_1.states[var0_0.STYSTEM.MAP] = NewEducateMapState.New(arg1_1, var0_1.cache_site[1])
	end

	arg0_1.states[var0_0.STYSTEM.PLAN] = NewEducatePlanState.New(#var0_1.cache_plan > 0 and var0_1.cache_plan[1] or {})
	arg0_1.states[var0_0.STYSTEM.ASSESS] = NewEducateStateBase.New()
	arg0_1.states[var0_0.STYSTEM.PHASE] = NewEducateStateBase.New()

	if #var0_1.cache_end > 0 then
		arg0_1.states[var0_0.STYSTEM.ENDING] = NewEducateEndingState.New(var0_1.cache_end[1])
	end

	if #var0_1.cache_mind > 0 then
		arg0_1.states[var0_0.STYSTEM.MIND] = NewEducateStateBase.New(var0_1.cache_mind[1])
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

function var0_0.GetStystemNo(arg0_5)
	return arg0_5.stystemNo
end

function var0_0.SetStystemNo(arg0_6, arg1_6)
	arg0_6.stystemNo = arg1_6
end

function var0_0.GetState(arg0_7, arg1_7)
	return arg0_7.states[arg1_7] or nil
end

function var0_0.GetCurState(arg0_8)
	return arg0_8.states[arg0_8.stystemNo]
end

function var0_0.CheckStystem(arg0_9)
	if arg0_9.curNode ~= 0 then
		return arg0_9.stystemNo
	end

	if not arg0_9.states[arg0_9.stystemNo]:IsFinish() then
		return arg0_9.stystemNo
	end

	return switch(arg0_9.stystemNo, {
		[var0_0.STYSTEM.INIT] = function()
			return var0_0.STYSTEM.EVENT
		end,
		[var0_0.STYSTEM.EVENT] = function()
			return var0_0.STYSTEM.TALENT
		end,
		[var0_0.STYSTEM.TALENT] = function()
			return var0_0.STYSTEM.MAP
		end,
		[var0_0.STYSTEM.TOPIC] = function()
			return var0_0.STYSTEM.MAP
		end,
		[var0_0.STYSTEM.MAP] = function()
			return var0_0.STYSTEM.MAP
		end,
		[var0_0.STYSTEM.PLAN] = function()
			return var0_0.STYSTEM.ASSESS
		end,
		[var0_0.STYSTEM.ASSESS] = function()
			if not getProxy(NewEducateProxy):GetCurChar():GetRoundData():IsEndRound() then
				return var0_0.STYSTEM.PHASE
			else
				return var0_0.STYSTEM.ENDING
			end
		end,
		[var0_0.STYSTEM.PHASE] = function()
			return var0_0.STYSTEM.EVENT
		end,
		[var0_0.STYSTEM.ENDING] = function()
			return var0_0.STYSTEM.ENDING
		end
	}, function()
		return arg0_9.stystemNo
	end)
end

function var0_0.Reset(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.states) do
		iter1_20:Reset()
	end

	arg0_20.states[var0_0.STYSTEM.TALENT] = nil
	arg0_20.states[var0_0.STYSTEM.TOPIC] = nil
	arg0_20.states[var0_0.STYSTEM.MAP] = nil
	arg0_20.states[var0_0.STYSTEM.ENDING] = nil
	arg0_20.states[var0_0.STYSTEM.MIND] = nil
end

var0_0.BENEFIT_PENDING = {
	var0_0.STYSTEM.PLAN,
	var0_0.STYSTEM.ASSESS,
	var0_0.STYSTEM.PHASE
}

function var0_0.IsImmediateBenefit(arg0_21)
	return not table.contains(var0_0.BENEFIT_PENDING, arg0_21.stystemNo)
end

return var0_0

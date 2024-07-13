local var0_0 = class("EducateGrid")

var0_0.TYPE_LOCK = -1
var0_0.TYPE_EMPTY = 0
var0_0.TYPE_PLAN = 1
var0_0.TYPE_PLAN_OCCUPY = 2
var0_0.TYPE_EVENT = 3
var0_0.TYPE_EVENT_OCCUPY = 4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.type = arg1_1.type
	arg0_1.id = arg1_1.id or 0

	arg0_1:initData(arg1_1)
end

function var0_0.initData(arg0_2)
	switch(arg0_2.type, {
		[var0_0.TYPE_LOCK] = function()
			arg0_2.data = nil
		end,
		[var0_0.TYPE_EMPTY] = function()
			arg0_2.data = nil
		end,
		[var0_0.TYPE_PLAN] = function()
			arg0_2.data = EducatePlan.New(arg0_2.id)
		end,
		[var0_0.TYPE_PLAN_OCCUPY] = function()
			arg0_2.data = EducatePlan.New(arg0_2.id)
		end,
		[var0_0.TYPE_EVENT] = function()
			arg0_2.data = EducateSpecialEvent.New(arg0_2.id)
		end,
		[var0_0.TYPE_EVENT_OCCUPY] = function()
			arg0_2.data = EducateSpecialEvent.New(arg0_2.id)
		end
	})
end

function var0_0.IsLock(arg0_9)
	return arg0_9.type == var0_0.TYPE_LOCK
end

function var0_0.IsEmpty(arg0_10)
	return arg0_10.type == var0_0.TYPE_EMPTY
end

function var0_0.IsPlan(arg0_11)
	return arg0_11.type == var0_0.TYPE_PLAN
end

function var0_0.IsPlanOccupy(arg0_12)
	return arg0_12.type == var0_0.TYPE_PLAN_OCCUPY
end

function var0_0.IsEvent(arg0_13)
	return arg0_13.type == var0_0.TYPE_EVENT
end

function var0_0.IsEventOccupy(arg0_14)
	return arg0_14.type == var0_0.TYPE_EVENT_OCCUPY
end

function var0_0.GetOccupyGridCnt(arg0_15)
	return (arg0_15:IsPlan() or arg0_15:IsPlanOccupy()) and arg0_15.data:getConfig("cost_resource3") or 1
end

function var0_0.GetName(arg0_16)
	if arg0_16.type == var0_0.TYPE_PLAN then
		return arg0_16.data:getConfig("name")
	elseif arg0_16.type == var0_0.TYPE_EVENT then
		return arg0_16.data:getConfig("id")
	end

	return ""
end

function var0_0.GetPerformance(arg0_17)
	return arg0_17.data and arg0_17.data:GetPerformance() or ""
end

function var0_0.GetResult(arg0_18)
	return arg0_18.data and arg0_18.data:GetResult() or {}
end

return var0_0

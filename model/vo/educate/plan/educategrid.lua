local var0 = class("EducateGrid")

var0.TYPE_LOCK = -1
var0.TYPE_EMPTY = 0
var0.TYPE_PLAN = 1
var0.TYPE_PLAN_OCCUPY = 2
var0.TYPE_EVENT = 3
var0.TYPE_EVENT_OCCUPY = 4

function var0.Ctor(arg0, arg1)
	arg0.type = arg1.type
	arg0.id = arg1.id or 0

	arg0:initData(arg1)
end

function var0.initData(arg0)
	switch(arg0.type, {
		[var0.TYPE_LOCK] = function()
			arg0.data = nil
		end,
		[var0.TYPE_EMPTY] = function()
			arg0.data = nil
		end,
		[var0.TYPE_PLAN] = function()
			arg0.data = EducatePlan.New(arg0.id)
		end,
		[var0.TYPE_PLAN_OCCUPY] = function()
			arg0.data = EducatePlan.New(arg0.id)
		end,
		[var0.TYPE_EVENT] = function()
			arg0.data = EducateSpecialEvent.New(arg0.id)
		end,
		[var0.TYPE_EVENT_OCCUPY] = function()
			arg0.data = EducateSpecialEvent.New(arg0.id)
		end
	})
end

function var0.IsLock(arg0)
	return arg0.type == var0.TYPE_LOCK
end

function var0.IsEmpty(arg0)
	return arg0.type == var0.TYPE_EMPTY
end

function var0.IsPlan(arg0)
	return arg0.type == var0.TYPE_PLAN
end

function var0.IsPlanOccupy(arg0)
	return arg0.type == var0.TYPE_PLAN_OCCUPY
end

function var0.IsEvent(arg0)
	return arg0.type == var0.TYPE_EVENT
end

function var0.IsEventOccupy(arg0)
	return arg0.type == var0.TYPE_EVENT_OCCUPY
end

function var0.GetOccupyGridCnt(arg0)
	return (arg0:IsPlan() or arg0:IsPlanOccupy()) and arg0.data:getConfig("cost_resource3") or 1
end

function var0.GetName(arg0)
	if arg0.type == var0.TYPE_PLAN then
		return arg0.data:getConfig("name")
	elseif arg0.type == var0.TYPE_EVENT then
		return arg0.data:getConfig("id")
	end

	return ""
end

function var0.GetPerformance(arg0)
	return arg0.data and arg0.data:GetPerformance() or ""
end

function var0.GetResult(arg0)
	return arg0.data and arg0.data:GetResult() or {}
end

return var0

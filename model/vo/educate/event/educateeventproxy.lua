local var0 = class("EducateEventProxy")

function var0.Ctor(arg0)
	arg0.planSpecEvents = {}
	arg0.siteSpecEvents = {}
	arg0.mindBubbleSpecEvents = {}
	arg0.discountBubbleSpecEvents = {}

	local var0 = pg.child_event_special.all

	for iter0, iter1 in ipairs(var0) do
		local var1 = EducateSpecialEvent.New(iter1)

		switch(var1:GetType(), {
			[EducateSpecialEvent.TYPE_PLAN] = function()
				table.insert(arg0.planSpecEvents, var1)
			end,
			[EducateSpecialEvent.TYPE_SITE] = function()
				table.insert(arg0.siteSpecEvents, var1)
			end,
			[EducateSpecialEvent.TYPE_BUBBLE_MIND] = function()
				table.insert(arg0.mindBubbleSpecEvents, var1)
			end,
			[EducateSpecialEvent.TYPE_BUBBLE_DISCOUNT] = function()
				table.insert(arg0.discountBubbleSpecEvents, var1)
			end
		})
	end
end

function var0.SetUp(arg0, arg1)
	arg0.finishSpecEventIds = arg1.finishSpecEventIds or {}
	arg0.needRequestHomeEvents = arg1.needRequestHomeEvents
	arg0.waitTriggerEventIds = arg1.home_events or {}
	arg0.curTime = getProxy(EducateProxy):GetCurTime()
end

function var0.GetFinishSpecEventIds(arg0)
	return arg0.finishSpecEventIds
end

function var0.AddFinishSpecEvent(arg0, arg1)
	table.insert(arg0.finishSpecEventIds, arg1)
end

function var0.IsFinishSpecEvent(arg0, arg1)
	return table.contains(arg0.finishSpecEventIds, arg1)
end

function var0.GetHomeSpecEvents(arg0)
	local var0 = {}
	local var1 = getProxy(EducateProxy):GetCharData():GetPersonalityId()
	local var2 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_FAVOR_AND_MIND) and table.mergeArray(arg0.mindBubbleSpecEvents, arg0.discountBubbleSpecEvents) or arg0.discountBubbleSpecEvents

	return (underscore.select(var2, function(arg0)
		return not arg0:IsFinishSpecEvent(arg0.id) and arg0:InTime(arg0.curTime) and arg0:IsMatch(var1)
	end))
end

function var0.GetSiteSpecEvents(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(EducateProxy):GetCharData():GetPersonalityId()

	return (underscore.select(arg0.siteSpecEvents, function(arg0)
		return not arg0:IsFinishSpecEvent(arg0.id) and arg0:IsMatchSite(arg1) and arg0:InTime(arg0.curTime) and arg0:IsMatch(var1)
	end))
end

function var0.GetPlanSpecEvents(arg0)
	local var0 = {}
	local var1 = getProxy(EducateProxy):GetCharData():GetPersonalityId()

	return (underscore.select(arg0.planSpecEvents, function(arg0)
		return not arg0:IsFinishSpecEvent(arg0.id) and arg0:InNextWeekTime(arg0.curTime) and arg0:IsMatch(var1)
	end))
end

function var0.NeedGetHomeEventData(arg0)
	return arg0.needRequestHomeEvents
end

function var0.SetHomeEventData(arg0, arg1)
	arg0.needRequestHomeEvents = false
	arg0.waitTriggerEventIds = arg1
end

function var0.GetHomeEventIds(arg0)
	return arg0.waitTriggerEventIds
end

function var0.RemoveEvent(arg0, arg1)
	table.removebyvalue(arg0.waitTriggerEventIds, arg1)
end

function var0.OnNewWeek(arg0, arg1)
	arg0.curTime = arg1
	arg0.needRequestHomeEvents = true
	arg0.waitTriggerEventIds = {}
end

return var0

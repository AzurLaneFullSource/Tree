local var0_0 = class("EducateEventProxy")

function var0_0.Ctor(arg0_1)
	arg0_1.planSpecEvents = {}
	arg0_1.siteSpecEvents = {}
	arg0_1.mindBubbleSpecEvents = {}
	arg0_1.discountBubbleSpecEvents = {}

	local var0_1 = pg.child_event_special.all

	for iter0_1, iter1_1 in ipairs(var0_1) do
		local var1_1 = EducateSpecialEvent.New(iter1_1)

		switch(var1_1:GetType(), {
			[EducateSpecialEvent.TYPE_PLAN] = function()
				table.insert(arg0_1.planSpecEvents, var1_1)
			end,
			[EducateSpecialEvent.TYPE_SITE] = function()
				table.insert(arg0_1.siteSpecEvents, var1_1)
			end,
			[EducateSpecialEvent.TYPE_BUBBLE_MIND] = function()
				table.insert(arg0_1.mindBubbleSpecEvents, var1_1)
			end,
			[EducateSpecialEvent.TYPE_BUBBLE_DISCOUNT] = function()
				table.insert(arg0_1.discountBubbleSpecEvents, var1_1)
			end
		})
	end
end

function var0_0.SetUp(arg0_6, arg1_6)
	arg0_6.finishSpecEventIds = arg1_6.finishSpecEventIds or {}
	arg0_6.needRequestHomeEvents = arg1_6.needRequestHomeEvents
	arg0_6.waitTriggerEventIds = arg1_6.home_events or {}
	arg0_6.curTime = getProxy(EducateProxy):GetCurTime()
end

function var0_0.GetFinishSpecEventIds(arg0_7)
	return arg0_7.finishSpecEventIds
end

function var0_0.AddFinishSpecEvent(arg0_8, arg1_8)
	table.insert(arg0_8.finishSpecEventIds, arg1_8)
end

function var0_0.IsFinishSpecEvent(arg0_9, arg1_9)
	return table.contains(arg0_9.finishSpecEventIds, arg1_9)
end

function var0_0.GetHomeSpecEvents(arg0_10)
	local var0_10 = {}
	local var1_10 = getProxy(EducateProxy):GetCharData():GetPersonalityId()
	local var2_10 = EducateHelper.IsSystemUnlock(EducateConst.SYSTEM_FAVOR_AND_MIND) and table.mergeArray(arg0_10.mindBubbleSpecEvents, arg0_10.discountBubbleSpecEvents) or arg0_10.discountBubbleSpecEvents

	return (underscore.select(var2_10, function(arg0_11)
		return not arg0_10:IsFinishSpecEvent(arg0_11.id) and arg0_11:InTime(arg0_10.curTime) and arg0_11:IsMatch(var1_10)
	end))
end

function var0_0.GetSiteSpecEvents(arg0_12, arg1_12)
	local var0_12 = {}
	local var1_12 = getProxy(EducateProxy):GetCharData():GetPersonalityId()

	return (underscore.select(arg0_12.siteSpecEvents, function(arg0_13)
		return not arg0_12:IsFinishSpecEvent(arg0_13.id) and arg0_13:IsMatchSite(arg1_12) and arg0_13:InTime(arg0_12.curTime) and arg0_13:IsMatch(var1_12)
	end))
end

function var0_0.GetPlanSpecEvents(arg0_14)
	local var0_14 = {}
	local var1_14 = getProxy(EducateProxy):GetCharData():GetPersonalityId()

	return (underscore.select(arg0_14.planSpecEvents, function(arg0_15)
		return not arg0_14:IsFinishSpecEvent(arg0_15.id) and arg0_15:InNextWeekTime(arg0_14.curTime) and arg0_15:IsMatch(var1_14)
	end))
end

function var0_0.NeedGetHomeEventData(arg0_16)
	return arg0_16.needRequestHomeEvents
end

function var0_0.SetHomeEventData(arg0_17, arg1_17)
	arg0_17.needRequestHomeEvents = false
	arg0_17.waitTriggerEventIds = arg1_17
end

function var0_0.GetHomeEventIds(arg0_18)
	return arg0_18.waitTriggerEventIds
end

function var0_0.RemoveEvent(arg0_19, arg1_19)
	table.removebyvalue(arg0_19.waitTriggerEventIds, arg1_19)
end

function var0_0.OnNewWeek(arg0_20, arg1_20)
	arg0_20.curTime = arg1_20
	arg0_20.needRequestHomeEvents = true
	arg0_20.waitTriggerEventIds = {}
end

return var0_0

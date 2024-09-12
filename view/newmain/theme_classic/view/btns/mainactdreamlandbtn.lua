local var0_0 = class("MainActDreamlandBtn", import(".MainBaseActivityBtn"))

function var0_0.InShowTime(arg0_1)
	local var0_1 = var0_0.super.InShowTime(arg0_1)
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

	return var0_1 and var1_1 and not var1_1:isEnd()
end

function var0_0.GetEventName(arg0_2)
	return "event_dreamland"
end

function var0_0.OnInit(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DREAMLAND)
	local var1_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)
	local var2_3 = DreamlandData.New(var0_3, var1_3):ExistAnyMapOrExploreAward()

	setActive(arg0_3.tipTr.gameObject, var2_3)
end

return var0_0

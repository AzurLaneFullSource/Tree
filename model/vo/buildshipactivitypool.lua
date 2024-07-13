local var0_0 = class("BuildShipActivityPool", import(".BuildShipPool"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.activityId = arg1_1.activityId
end

function var0_0.IsActivity(arg0_2)
	return true
end

function var0_0.GetActivity(arg0_3)
	return getProxy(ActivityProxy):getActivityById(arg0_3.activityId)
end

function var0_0.IsEnd(arg0_4)
	local var0_4 = arg0_4:GetActivity()

	return not var0_4 or var0_4:isEnd()
end

function var0_0.GetStageId(arg0_5)
	return (arg0_5:GetActivity():getConfig("config_client") or {}).stageid
end

function var0_0.GetActivityId(arg0_6)
	return arg0_6.activityId
end

function var0_0.IsNewServerBuild(arg0_7)
	if arg0_7:IsEnd() then
		return false
	end

	return arg0_7:GetActivity():getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

return var0_0

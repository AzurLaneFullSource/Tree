local var0 = class("BuildShipActivityPool", import(".BuildShipPool"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.activityId = arg1.activityId
end

function var0.IsActivity(arg0)
	return true
end

function var0.GetActivity(arg0)
	return getProxy(ActivityProxy):getActivityById(arg0.activityId)
end

function var0.IsEnd(arg0)
	local var0 = arg0:GetActivity()

	return not var0 or var0:isEnd()
end

function var0.GetStageId(arg0)
	return (arg0:GetActivity():getConfig("config_client") or {}).stageid
end

function var0.GetActivityId(arg0)
	return arg0.activityId
end

function var0.IsNewServerBuild(arg0)
	if arg0:IsEnd() then
		return false
	end

	return arg0:GetActivity():getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

return var0

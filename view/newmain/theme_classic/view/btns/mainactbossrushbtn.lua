local var0 = class("MainActBossRushBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_series"
end

function var0.GetActivity(arg0)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

	return (_.detect(var0, function(arg0)
		return not arg0:isEnd()
	end))
end

function var0.GetActivityID(arg0)
	local var0 = arg0:GetActivity()

	return var0 and var0.id
end

function var0.OnInit(arg0)
	setActive(arg0.tipTr.gameObject, false)
end

function var0.CustomOnClick(arg0)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
end

return var0

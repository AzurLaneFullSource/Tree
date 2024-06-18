local var0_0 = class("MainActBossRushBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_series"
end

function var0_0.GetActivity(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSSRUSH)

	return (_.detect(var0_2, function(arg0_3)
		return not arg0_3:isEnd()
	end))
end

function var0_0.GetActivityID(arg0_4)
	local var0_4 = arg0_4:GetActivity()

	return var0_4 and var0_4.id
end

function var0_0.OnInit(arg0_5)
	setActive(arg0_5.tipTr.gameObject, false)
end

function var0_0.CustomOnClick(arg0_6)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
end

return var0_0

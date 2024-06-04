local var0 = class("MainActBossSingleBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_boss_single"
end

function var0.GetActivity(arg0)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

	return (_.detect(var0, function(arg0)
		return not arg0:isEnd()
	end))
end

function var0.GetActivityID(arg0)
	local var0 = arg0:GetActivity()

	return var0 and var0.id
end

function var0.OnInit(arg0)
	setActive(arg0.tipTr.gameObject, arg0:IsShowTip())
end

function var0.CustomOnClick(arg0)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)
end

function var0.IsShowTip(arg0)
	if arg0:GetActivityID() == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
		return OtherworldMapScene.IsShowTip()
	end

	return false
end

return var0

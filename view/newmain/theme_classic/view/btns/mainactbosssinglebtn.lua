local var0_0 = class("MainActBossSingleBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_boss_single"
end

function var0_0.GetActivity(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSSSINGLE)

	return (_.detect(var0_2, function(arg0_3)
		return not arg0_3:isEnd()
	end))
end

function var0_0.GetActivityID(arg0_4)
	local var0_4 = arg0_4:GetActivity()

	return var0_4 and var0_4.id
end

function var0_0.OnInit(arg0_5)
	setActive(arg0_5.tipTr.gameObject, arg0_5:IsShowTip())
end

function var0_0.CustomOnClick(arg0_6)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.OTHERWORLD_MAP)
end

function var0_0.IsShowTip(arg0_7)
	if arg0_7:GetActivityID() == ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID then
		return OtherworldMapScene.IsShowTip()
	end

	return false
end

return var0_0

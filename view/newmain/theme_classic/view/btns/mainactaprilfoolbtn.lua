local var0 = class("MainActAprilFoolBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_aprilFool"
end

function var0.OnInit(arg0)
	local var0 = arg0:IsShowTip()

	setActive(arg0.tipTr.gameObject, var0)
end

function var0.GetActivityID(arg0)
	return arg0:GetLinkConfig().time[2]
end

function var0.IsShowTip(arg0)
	local var0 = arg0:GetActivityID()
	local var1 = var0 and getProxy(ActivityProxy):getActivityById(var0)

	return var1 and var1:readyToAchieve()
end

function var0.CustomOnClick(arg0)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
		id = arg0:GetActivityID()
	})
end

return var0

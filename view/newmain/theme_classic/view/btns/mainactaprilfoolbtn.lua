local var0_0 = class("MainActAprilFoolBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_aprilFool"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2:IsShowTip()

	setActive(arg0_2.tipTr.gameObject, var0_2)
end

function var0_0.GetActivityID(arg0_3)
	return arg0_3:GetLinkConfig().time[2]
end

function var0_0.IsShowTip(arg0_4)
	local var0_4 = arg0_4:GetActivityID()
	local var1_4 = var0_4 and getProxy(ActivityProxy):getActivityById(var0_4)

	return var1_4 and var1_4:readyToAchieve()
end

function var0_0.CustomOnClick(arg0_5)
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
		id = arg0_5:GetActivityID()
	})
end

return var0_0

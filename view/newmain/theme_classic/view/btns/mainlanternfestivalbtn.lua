local var0_0 = class("MainLanternFestivalBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_LanternFestival"
end

function var0_0.GetActivityID(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

	return var0_2 and var0_2.id
end

function var0_0.OnInit(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)
	local var1_3 = false

	if var0_3 and not var0_3:isEnd() then
		local var2_3 = getProxy(MiniGameProxy):GetHubByHubId(var0_3:getConfig("config_id"))

		var1_3 = var2_3.count > 0 and var2_3.usedtime < 7
	end

	setActive(arg0_3._tf:Find("Tip"), var1_3)
end

function var0_0.CustomOnClick(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

	if var0_4 then
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_4:getConfig("config_client").miniGame)
	end
end

return var0_0

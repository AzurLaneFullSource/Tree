local var0 = class("MainLanternFestivalBtn", import(".MainBaseActivityBtn"))

var0.LANTERNFESTIVAL_MINIGAME_ID = 64

function var0.GetEventName(arg0)
	return "event_LanternFestival"
end

function var0.GetActivityID(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)

	return var0 and var0.id
end

function var0.OnInit(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL)
	local var1 = false

	if var0 and not var0:isEnd() then
		local var2 = getProxy(MiniGameProxy):GetHubByHubId(var0:getConfig("config_id"))

		var1 = var2.count > 0 and var2.usedtime < 7
	end

	setActive(arg0._tf:Find("Tip"), var1)
end

function var0.CustomOnClick(arg0)
	if getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL) then
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0.LANTERNFESTIVAL_MINIGAME_ID)
	end
end

return var0

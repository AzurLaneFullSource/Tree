local var0_0 = class("MainActBoatAdBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_boat_ad_game"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2:IsShowTip()

	setActive(arg0_2.tipTr.gameObject, var0_2)
end

function var0_0.GetActivityID(arg0_3)
	return arg0_3:GetLinkConfig().time[2]
end

function var0_0.IsShowTip(arg0_4)
	local var0_4 = pg.mini_game[arg0_4.config.param[1]].hub_id
	local var1_4 = getProxy(MiniGameProxy):GetHubByHubId(var0_4)

	if var1_4 and var1_4.count > 0 then
		return true
	end

	return false
end

return var0_0

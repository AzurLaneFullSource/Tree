local var0_0 = class("MainSubActBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_sub_act"
end

function var0_0.GetActivity(arg0_2)
	if arg0_2.config and arg0_2.config.time and arg0_2.config.time[1] == "default" then
		local var0_2 = arg0_2.config.time[2]
		local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)

		if var1_2 and not var1_2:isEnd() then
			return var1_2
		end
	end

	return nil
end

function var0_0.GetActivityID(arg0_3)
	local var0_3 = arg0_3:GetActivity()

	return var0_3 and var0_3.id
end

function var0_0.OnInit(arg0_4)
	setActive(arg0_4.tipTr, arg0_4:IsShowTip())
end

function var0_0.IsShowTip(arg0_5)
	local var0_5 = arg0_5:GetActivityID()
	local var1_5 = arg0_5:GetActivity()
	local var2_5 = var1_5:getConfig("type")

	return switch(var2_5, {
		[ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID] = function()
			return var1_5:rereadyToAchieve()
		end
	}, function()
		return false
	end)
end

return var0_0

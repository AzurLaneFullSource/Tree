local var0_0 = class("IslandMainBtnTipHelper")

function var0_0.IsTip(arg0_1)
	return switch(arg0_1, {
		map = function()
			return var0_0.IsMapTip()
		end,
		device = function()
			return var0_0.IsDeviceTip()
		end,
		mail = function()
			return var0_0.IsMailTip()
		end,
		friend = function()
			return var0_0.IsFriendTip()
		end,
		technology = function()
			return var0_0.IsTechnologyTip()
		end,
		achievement = function()
			return var0_0.IsAchievementTip()
		end
	}, function()
		return false
	end)
end

function var0_0.IsMapTip()
	local var0_9 = getProxy(IslandProxy):GetIsland()
	local var1_9 = var0_9:GetTaskAgency():GetTraceTask()

	if var1_9 then
		local var2_9 = var1_9:GetTraceParam()
		local var3_9 = tonumber(var2_9)

		if var3_9 then
			return var0_9:GetMapId() ~= pg.island_world_objects[var3_9].mapId
		end
	end

	return false
end

function var0_0.IsDeviceTip()
	for iter0_10, iter1_10 in ipairs(pg.island_main_btns.get_id_list_by_main_type[2]) do
		local var0_10 = pg.island_main_btns[iter1_10].btn_name

		if var0_0.IsTip(var0_10) then
			return true
		end
	end

	return false
end

function var0_0.IsMailTip()
	return getProxy(MailProxy):GetUnreadCount() > 0
end

function var0_0.IsFriendTip()
	return getProxy(NotificationProxy):getRequestCount() > 0
end

function var0_0.IsTechnologyTip()
	return getProxy(IslandProxy):GetIsland():GetTechnologyAgency():IsTip()
end

function var0_0.IsAchievementTip()
	return getProxy(IslandProxy):GetIsland():GetAchievementAgency():IsTip()
end

return var0_0

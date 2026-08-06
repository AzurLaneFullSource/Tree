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
		end,
		post_manage = function()
			return var0_0.IsPostManageTip()
		end,
		book = function()
			return var0_0.IsBookTip()
		end,
		season = function()
			return var0_0.IsSeasonTip()
		end
	}, function()
		return false
	end)
end

function var0_0.IsMapTip()
	local var0_12 = getProxy(IslandProxy):GetIsland()
	local var1_12 = var0_12:GetTaskAgency():GetTraceTask()

	if var1_12 then
		local var2_12 = var1_12:GetTraceParam()
		local var3_12 = tonumber(var2_12)

		if var3_12 and var0_12:GetMapId() ~= pg.island_world_objects[var3_12].mapId then
			return true
		end
	end

	local var4_12 = var0_12:GetTaskAgency():GetMainTraceTask()

	if var4_12 then
		local var5_12 = var4_12:GetTraceParam()
		local var6_12 = tonumber(var5_12)

		if var6_12 and var0_12:GetMapId() ~= pg.island_world_objects[var6_12].mapId then
			return true
		end
	end

	return false
end

function var0_0.IsDeviceTip()
	local var0_13 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_13, iter1_13 in ipairs(pg.island_main_btns.get_id_list_by_main_type[2]) do
		local var1_13 = pg.island_main_btns[iter1_13]
		local var2_13 = var1_13.btn_name
		local var3_13 = var1_13.ability_id

		if var0_13:HasAbility(var3_13) and var0_0.IsTip(var2_13) then
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

function var0_0.IsPostManageTip()
	return var0_0.IsPostProdTip() or var0_0.IsPostRestTip()
end

function var0_0.IsPostProdTip()
	local var0_19 = pg.island_set.post_manage_produce.key_value_varchar
	local var1_19 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

	return underscore.any(var0_19, function(arg0_20)
		local var0_20 = var1_19:GetBuilding(arg0_20)

		return var0_20 and var0_20:IsPostTip()
	end)
end

function var0_0.IsPostRestTip()
	local var0_21 = pg.island_set.post_manage_operate.key_value_varchar
	local var1_21 = getProxy(IslandProxy):GetIsland():GetManageAgency()

	return underscore.any(var0_21, function(arg0_22)
		local var0_22 = var1_21:GetRestaurant(arg0_22)

		return var0_22 and var0_22:IsPostTip()
	end)
end

function var0_0.IsPostCollectionTip()
	local var0_23 = getProxy(PlayerProxy):getPlayerId()
	local var1_23 = "IslandSignAutoCollectTime" .. tostring(var0_23)
	local var2_23 = PlayerPrefs.GetInt(var1_23, 0)

	if var2_23 == 0 then
		return true
	end

	local var3_23 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(var3_23, var2_23)
end

function var0_0.IsBookTip()
	return getProxy(IslandProxy):GetIsland():GetBookAgency():IsTipFromTypes({
		IslandIllustration.TYPES.CHAR,
		IslandIllustration.TYPES.NPC,
		IslandIllustration.TYPES.ITEM,
		IslandIllustration.TYPES.FISH
	})
end

function var0_0.IsUnlock(arg0_25)
	local var0_25 = underscore.detect(pg.island_main_btns.all, function(arg0_26)
		return pg.island_main_btns[arg0_26].btn_name == arg0_25
	end)

	if not var0_25 then
		return false
	end

	local var1_25 = pg.island_main_btns[var0_25].ability_id

	return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var1_25)
end

function var0_0.IsSeasonTip()
	return IslandSeasonRedDotHelper.TipSeason()
end

return var0_0

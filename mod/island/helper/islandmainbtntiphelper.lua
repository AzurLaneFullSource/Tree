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
		end
	}, function()
		return false
	end)
end

function var0_0.IsMapTip()
	local var0_11 = getProxy(IslandProxy):GetIsland()
	local var1_11 = var0_11:GetTaskAgency():GetTraceTask()

	if var1_11 then
		local var2_11 = var1_11:GetTraceParam()
		local var3_11 = tonumber(var2_11)

		if var3_11 then
			return var0_11:GetMapId() ~= pg.island_world_objects[var3_11].mapId
		end
	end

	return false
end

function var0_0.IsDeviceTip()
	local var0_12 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	for iter0_12, iter1_12 in ipairs(pg.island_main_btns.get_id_list_by_main_type[2]) do
		local var1_12 = pg.island_main_btns[iter1_12]
		local var2_12 = var1_12.btn_name
		local var3_12 = var1_12.ability_id

		if var0_12:HasAbility(var3_12) then
			if var2_12 == "book" then
				if var0_0.IsBookTipInDeviceBtn() then
					return true
				end
			elseif var0_0.IsTip(var2_12) then
				return true
			end
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
	local var0_18 = pg.island_set.post_manage_produce.key_value_varchar
	local var1_18 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()

	return underscore.any(var0_18, function(arg0_19)
		local var0_19 = var1_18:GetBuilding(arg0_19)

		return var0_19 and var0_19:IsPostTip()
	end)
end

function var0_0.IsPostRestTip()
	local var0_20 = pg.island_set.post_manage_operate.key_value_varchar
	local var1_20 = getProxy(IslandProxy):GetIsland():GetManageAgency()

	return underscore.any(var0_20, function(arg0_21)
		local var0_21 = var1_20:GetRestaurant(arg0_21)

		return var0_21 and var0_21:IsPostTip()
	end)
end

function var0_0.IsBookTip()
	return getProxy(IslandProxy):GetIsland():GetBookAgency():IsTipFromTypes({
		IslandIllustration.TYPES.CHAR,
		IslandIllustration.TYPES.NPC,
		IslandIllustration.TYPES.ITEM
	})
end

function var0_0.IsBookTipInDeviceBtn()
	return getProxy(IslandProxy):GetIsland():GetBookAgency():IsTipFromTypes({
		IslandIllustration.TYPES.CHAR
	})
end

function var0_0.IsUnlock(arg0_24)
	local var0_24 = underscore.detect(pg.island_main_btns.all, function(arg0_25)
		return pg.island_main_btns[arg0_25].btn_name == arg0_24
	end)

	if not var0_24 then
		return false
	end

	local var1_24 = pg.island_main_btns[var0_24].ability_id

	return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var1_24)
end

return var0_0

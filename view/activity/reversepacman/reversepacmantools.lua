local var0_0 = {}

function var0_0.GetRoleListByType(arg0_1)
	local var0_1 = var0_0.GetActivity()
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1:getConfig("config_client").chasing_char) do
		if pg.activity_chasing_character[iter1_1].ai_type == arg0_1 then
			table.insert(var1_1, iter1_1)
		end
	end

	return var1_1
end

function var0_0.HasHireRole()
	local var0_2 = var0_0.GetActivity():GetFavorabilityList()

	for iter0_2, iter1_2 in pairs(var0_2) do
		return true
	end

	return false
end

function var0_0.GetInterviewItemID(arg0_3)
	return var0_0.GetActivity():getConfig("config_client").interviewItemID
end

function var0_0.GetGiftItemID(arg0_4)
	return var0_0.GetActivity():getConfig("config_client").giftItemID
end

function var0_0.GetTechnologyPTDrop(arg0_5)
	local var0_5 = var0_0.GetActivity():getConfig("config_client").technologyShopIDList[1]
	local var1_5 = pg.activity_shop_template[var0_5]

	return Drop.New({
		type = var1_5.resource_category,
		id = var1_5.resource_type
	})
end

function var0_0.GetItemCnt(arg0_6)
	return var0_0.GetActivity():GetVitemNumber(arg0_6)
end

function var0_0.IsUnlockRole(arg0_7)
	local var0_7 = pg.activity_chasing_character[arg0_7]

	if var0_7.unlock_story_id == 0 then
		return true
	end

	local var1_7 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(tonumber(var0_7.unlock_story_id))

	return pg.NewStoryMgr.GetInstance():IsPlayed(var1_7)
end

function var0_0.IsHireRole(arg0_8)
	local var0_8 = var0_0.GetActivity()

	for iter0_8, iter1_8 in pairs(var0_8:GetFavorabilityList()) do
		if iter0_8 == arg0_8 then
			return true
		end
	end

	return false
end

function var0_0.GetActivity()
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN)
end

function var0_0.GetMaxFavorabilityValue(arg0_10)
	local var0_10 = pg.activity_chasing_character[arg0_10]

	return var0_10.love_level[#var0_10.love_level][2]
end

function var0_0.GetFavorabilityValue(arg0_11)
	return var0_0.GetActivity():GetFavorability(arg0_11)
end

function var0_0.GetUpgradeFavorability(arg0_12)
	local var0_12 = var0_0.GetFavorabilityValue(arg0_12)
	local var1_12 = pg.activity_chasing_character[arg0_12]

	for iter0_12, iter1_12 in ipairs(var1_12.love_level) do
		if var0_12 == iter1_12[2] then
			return iter1_12[1]
		end
	end

	return 0
end

function var0_0.GetUnreadyHireStory()
	local var0_13 = {}
	local var1_13 = var0_0.GetActivity()

	for iter0_13, iter1_13 in pairs(var1_13:GetFavorabilityList()) do
		local var2_13 = pg.activity_chasing_character[iter0_13]

		if var2_13.love_level[1][2] == iter1_13 and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_13.love_level_show[1]) then
			table.insert(var0_13, iter0_13)
		end
	end

	return var0_13
end

function var0_0.GetFavorabilityUnreadyStory()
	local var0_14 = {}
	local var1_14 = var0_0.GetActivity()

	for iter0_14, iter1_14 in pairs(var1_14:GetFavorabilityList()) do
		local var2_14 = pg.activity_chasing_character[iter0_14]

		for iter2_14, iter3_14 in ipairs(var2_14.love_level) do
			if iter2_14 ~= 1 and iter3_14[2] == iter1_14 and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_14.love_level_show[iter2_14]) then
				table.insert(var0_14, iter0_14)
			end
		end
	end

	return var0_14
end

function var0_0.GetUnPassLevelIds()
	local var0_15 = {}
	local var1_15 = var0_0.GetActivity()
	local var2_15 = var1_15:GetStageDataList()

	for iter0_15, iter1_15 in ipairs(pg.activity_chasing_level.all) do
		if not var2_15[iter1_15] and var1_15:IsUnlockStage(iter1_15) then
			table.insert(var0_15, iter1_15)
		end
	end

	return var0_15
end

return var0_0

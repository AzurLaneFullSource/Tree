local var0_0 = class("IslandAchievementHelper")

function var0_0.GetRuntimeData(arg0_1, arg1_1)
	local var0_1 = getProxy(IslandProxy):GetIsland()
	local var1_1 = var0_1:GetCharacterAgency()

	return switch(arg0_1, {
		[IslandAchievementType.ISLAND_LV] = function()
			return var0_1:GetLevel()
		end,
		[IslandAchievementType.FINISH_MAIN_TASK] = function()
			return var0_1:GetTaskAgency():IsFinishTask(arg1_1) and 1 or 0
		end,
		[IslandAchievementType.SHIP_LV] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_5, arg1_5)
				return arg0_5 + (arg1_5:GetLevel() >= arg1_1 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_SKILL_LV] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_7, arg1_7)
				local var0_7 = arg1_7:GetSkill()

				return arg0_7 + (var0_7:IsUnlock() and var0_7:GetLevel() <= arg1_1 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_ATTR_LV_1] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_9, arg1_9)
				return arg0_9 + (arg1_9:GetAttrGradeCnt(arg1_1) >= 1 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_ATTR_LV_2] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_11, arg1_11)
				return arg0_11 + (arg1_11:GetAttrGradeCnt(arg1_1) >= 2 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_ATTR_LV_3] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_13, arg1_13)
				return arg0_13 + (arg1_13:GetAttrGradeCnt(arg1_1) >= 3 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_ATTR_LV_4] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_15, arg1_15)
				return arg0_15 + (arg1_15:GetAttrGradeCnt(arg1_1) >= 4 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_ATTR_LV_5] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_17, arg1_17)
				return arg0_17 + (arg1_17:GetAttrGradeCnt(arg1_1) >= 5 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_ATTR_LV_6] = function()
			return underscore.reduce(var1_1:GetShips(), 0, function(arg0_19, arg1_19)
				return arg0_19 + (arg1_19:GetAttrGradeCnt(arg1_1) >= 6 and 1 or 0)
			end)
		end,
		[IslandAchievementType.SHIP_SKIN] = function()
			return var1_1:GetAllSkinCnt()
		end,
		[IslandAchievementType.SHIP_DRESS_TYPE] = function()
			return var1_1:GetDiffDressCntByType(arg1_1)
		end,
		[IslandAchievementType.COMMANDER_DRESS_TYPE] = function()
			return #var0_1:GetDressUpAgency():GetHasDressByType(arg1_1)
		end,
		[IslandAchievementType.SEASON_RANK] = function()
			return var0_1:GetSeasonAgency():GetHighestRank() <= arg1_1 and 1 or 0
		end,
		[IslandAchievementType.SEASON_NUM] = function()
			return var0_1:GetSeasonAgency():GetSeasonNum()
		end,
		[IslandAchievementType.FINISH_TECH] = function()
			return var0_1:GetTechnologyAgency():GetAllTypeFinishCnt()
		end,
		[IslandAchievementType.FINISH_TYPE_TECH] = function()
			return var0_1:GetTechnologyAgency():GetFinishCntByType(arg1_1)
		end,
		[IslandAchievementType.RESTAURANT_SALES] = function()
			local var0_27 = var0_1:GetManageAgency():GetRestaurant(arg1_1)

			return var0_27 and var0_27:GetSales() or 0
		end,
		[IslandAchievementType.FURNITURE] = function()
			return arg1_1 == 0 and #var0_1:GetAgoraAgency():GetFurnitures() or #var0_1:GetAgoraAgency():GetFurnituresByType(arg1_1)
		end
	}, function()
		assert(false, "not exist runtime achv type: " .. arg0_1)
	end)
end

function var0_0.UpdateRecord(arg0_30, arg1_30, arg2_30)
	local var0_30 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	if var0_30:CheckRecordExist(arg0_30, arg1_30) then
		var0_30:UpdateRecord(arg0_30, arg1_30, arg2_30)
	end
end

function var0_0.UpdateRecordWithAdd(arg0_31, arg1_31, arg2_31)
	local var0_31 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	if var0_31:CheckRecordExist(arg0_31, arg1_31) then
		var0_31:UpdateRecordWithAdd(arg0_31, arg1_31, arg2_31)
	end
end

function var0_0.OnShipUpgrade(arg0_32, arg1_32)
	local var0_32 = IslandAchievementType.SHIP_LV
	local var1_32 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()
	local var2_32 = var1_32:GetRecordsByType(var0_32)

	for iter0_32, iter1_32 in pairs(var2_32) do
		if arg0_32 < iter0_32 and iter0_32 <= arg1_32 then
			var1_32:UpdateRecord(var0_32, iter0_32, iter1_32 + 1)
		end
	end
end

function var0_0.OnShipSkillUpgrade(arg0_33)
	local var0_33 = IslandAchievementType.SHIP_SKILL_LV
	local var1_33 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()
	local var2_33 = var1_33:GetRecordsByType(var0_33)

	for iter0_33, iter1_33 in pairs(var2_33) do
		if iter0_33 <= arg0_33 then
			var1_33:UpdateRecord(var0_33, iter0_33, iter1_33 + 1)
		end
	end
end

function var0_0.CheckAttrUpgrade(arg0_34, arg1_34)
	for iter0_34, iter1_34 in pairs(arg1_34:GetAttrs()) do
		if arg1_34:GetAttrGrade(iter0_34) ~= arg0_34:GetAttrGrade(iter0_34) then
			return true
		end
	end

	return false
end

function var0_0.OnShipAttrUpgrade(arg0_35, arg1_35)
	local var0_35 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	if var0_0.CheckAttrUpgrade(arg0_35, arg1_35) then
		for iter0_35, iter1_35 in ipairs(IslandAchievementType.GetAttrTypes()) do
			local var1_35 = var0_35:GetRecordsByType(iter1_35)

			for iter2_35, iter3_35 in pairs(var1_35) do
				var0_35:UpdateRecord(iter1_35, iter2_35, var0_0.GetRuntimeData(iter1_35, iter2_35))
			end
		end
	end
end

function var0_0.OnSeasonReset(arg0_36)
	local var0_36 = IslandAchievementType.SEASON_RANK
	local var1_36 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()
	local var2_36 = var1_36:GetRecordsByType(var0_36)

	for iter0_36, iter1_36 in pairs(var2_36) do
		if arg0_36 <= iter0_36 then
			var1_36:UpdateRecord(var0_36, iter0_36, 1)
		end
	end
end

function var0_0.OnFinishTechnolog(arg0_37)
	local var0_37 = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	var0_37:UpdateRecordWithAdd(IslandAchievementType.FINISH_TECH, 0, 1)

	local var1_37 = pg.island_technology_template[arg0_37].tech_belong

	var0_37:UpdateRecordWithAdd(IslandAchievementType.FINISH_TYPE_TECH, var1_37, 1)
end

function var0_0.OnNpcInteract(arg0_38)
	local var0_38 = IslandAchievementType.NPC_INTERACT

	if getProxy(IslandProxy):GetIsland():GetAchievementAgency():CheckRecordExist(var0_38, arg0_38) then
		pg.m02:sendNotification(GAME.ISLAND_UPDATE_ACHV, {
			records = {
				{
					value = 1,
					event_type = var0_38,
					event_arg = arg0_38
				}
			}
		})
	end
end

return var0_0

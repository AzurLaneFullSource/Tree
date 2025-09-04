local var0_0 = class("IslandTaskHelper")

function var0_0.GetRuntimeData(arg0_1, arg1_1)
	local var0_1 = arg1_1[1]
	local var1_1 = getProxy(IslandProxy):GetIsland()
	local var2_1 = var1_1:GetCharacterAgency()

	return switch(arg0_1, {
		[IslandTaskTargetType.RECYCLE] = function()
			return var1_1:GetInventoryAgency():GetOwnCount(var0_1)
		end,
		[IslandTaskTargetType.ISLAND_LV] = function()
			return var1_1:GetLevel()
		end,
		[IslandTaskTargetType.FURNITURE] = function()
			local var0_4 = var1_1:GetAgoraAgency()

			return var0_1 == 0 and #var0_4:GetFurnitures() or #var0_4:GetFurnituresByType(var0_1)
		end,
		[IslandTaskTargetType.COMMANDER_DRESS] = function()
			local var0_5 = var1_1:GetDressUpAgency()

			return var0_1 == 0 and #var0_5:GetAllHasDress() or #var0_5:GetHasDressByType(var0_1)
		end,
		[IslandTaskTargetType.SHIP_DRESS] = function()
			return var0_1 == 0 and var2_1:GetDiffDressCnt() or var2_1:GetDiffDressCntByType(var0_1)
		end,
		[IslandTaskTargetType.SHIP_SKIN] = function()
			return var0_1 == 0 and var2_1:GetAllSkinCnt() or #var2_1:GetOwnSkinListByShipId(var0_1)
		end,
		[IslandTaskTargetType.SKIN_ALL_COLOR] = function()
			local var0_8 = var2_1:GetSkinData(var0_1)

			return var0_8 and var0_8:IsOwnAllColor() and 1 or 0
		end,
		[IslandTaskTargetType.SKIN_COLOR] = function()
			local var0_9 = pg.island_skin_colordiff_template[var0_1].skin_group
			local var1_9 = var2_1:GetSkinData(var0_9)

			return var1_9 and var1_9:CheckColorOwned(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.ACHIEVEMENT] = function()
			return var1_1:GetAchievementAgency():IsGot(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.TASK] = function()
			return var1_1:GetTaskAgency():IsFinishTask(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.RESTAURANT_RANK] = function()
			return var1_1:GetManageAgency():GetCntByRestLevel(var0_1)
		end,
		[IslandTaskTargetType.STORY] = function()
			local var0_13 = pg.NewStoryMgr.GetInstance()
			local var1_13 = var0_13:StoryId2StoryName(var0_1)

			return var0_13:IsPlayed(var1_13) and 1 or 0
		end
	}, function()
		assert(false, "not exist runtime type: " .. arg0_1)
	end)
end

function var0_0.UpdateRuntimeTaskByTargetType(arg0_15)
	local var0_15 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_15, iter1_15 in pairs(var0_15:GetTasks()) do
		if iter1_15:ExistTargetType(arg0_15) then
			var0_15:UpdateTask(iter1_15)
		end
	end
end

function var0_0.UpdateClientTaskProgress(arg0_16, arg1_16)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetDiffTargetIdsByTypeAndParam(arg0_16, arg1_16)

	for iter0_16, iter1_16 in ipairs(var0_16) do
		pg.m02:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = 0,
			progress = 1,
			targetId = iter1_16
		})
	end
end

function var0_0.OnApproach(arg0_17)
	seriesAsync({
		function(arg0_18)
			local var0_18 = {}

			for iter0_18, iter1_18 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasks()) do
				if iter1_18:CheckAcceptOnApproach(arg0_17) then
					table.insert(var0_18, iter1_18.id)
				end
			end

			if #var0_18 > 0 then
				pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
					taskIds = var0_18,
					callback = arg0_18
				})
			else
				arg0_18()
			end
		end,
		function(arg0_19)
			local var0_19 = {}

			for iter0_19, iter1_19 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasks()) do
				if iter1_19:CheckSubmitOnApproach(arg0_17) then
					table.insert(var0_19, iter1_19.id)
				end
			end

			local var1_19 = {}

			for iter2_19, iter3_19 in ipairs(var0_19) do
				table.insert(var1_19, function(arg0_20)
					pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
						taskId = iter3_19,
						callback = arg0_20
					})
				end)
			end

			seriesAsync(var1_19, arg0_19)
		end
	}, function()
		var0_0.UpdateClientTaskProgress(IslandTaskTargetType.APPROACH, arg0_17)
	end)
end

return var0_0

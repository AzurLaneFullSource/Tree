local var0_0 = class("IslandTaskHelper")

function var0_0.GetRuntimeData(arg0_1, arg1_1)
	local var0_1 = arg1_1[1]
	local var1_1 = getProxy(IslandProxy):GetIsland()
	local var2_1 = var1_1:GetCharacterAgency()

	return switch(arg0_1, {
		[IslandTaskTargetType.RECYCLE] = function()
			return var1_1:GetInventoryAgency():GetOwnCount(var0_1)
		end,
		[IslandTaskTargetType.TECHNOLOGY] = function()
			return var1_1:GetTechnologyAgency():IsFinishedTech(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.ISLAND_LV] = function()
			return var1_1:GetLevel()
		end,
		[IslandTaskTargetType.FRAGMENT] = function()
			return var1_1:GetWildCollectAgency():ExistFragment(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.UNLOCK_SHIP] = function()
			return var2_1:GetShipById(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.FURNITURE] = function()
			local var0_7 = var1_1:GetAgoraAgency()

			return var0_1 == 0 and #var0_7:GetFurnitures() or #var0_7:GetFurnituresByType(var0_1)
		end,
		[IslandTaskTargetType.COMMANDER_DRESS] = function()
			local var0_8 = var1_1:GetDressUpAgency()

			return var0_1 == 0 and #var0_8:GetAllHasDress() or #var0_8:GetHasDressByType(var0_1)
		end,
		[IslandTaskTargetType.SHIP_DRESS] = function()
			return var0_1 == 0 and var2_1:GetDiffDressCnt() or var2_1:GetDiffDressCntByType(var0_1)
		end,
		[IslandTaskTargetType.SHIP_SKIN] = function()
			return var0_1 == 0 and var2_1:GetAllSkinCnt() or #var2_1:GetOwnSkinListByShipId(var0_1)
		end,
		[IslandTaskTargetType.SKIN_ALL_COLOR] = function()
			local var0_11 = var2_1:GetSkinData(var0_1)

			return var0_11 and var0_11:IsOwnAllColor() and 1 or 0
		end,
		[IslandTaskTargetType.SKIN_COLOR] = function()
			local var0_12 = pg.island_skin_colordiff_template[var0_1].skin_group
			local var1_12 = var2_1:GetSkinData(var0_12)

			return var1_12 and var1_12:CheckColorOwned(var0_1) and 1 or 0
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
			local var0_16 = pg.NewStoryMgr.GetInstance()
			local var1_16 = var0_16:StoryId2StoryName(var0_1)

			return var0_16:IsPlayed(var1_16) and 1 or 0
		end,
		[IslandTaskTargetType.ACTION] = function()
			return var1_1:GetActionAgency():ExistAction(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.COMMANDER_DRESS_ID] = function()
			return var1_1:GetDressUpAgency():CheckOwnDress(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.SHIP_DRESS_ID] = function()
			return var2_1:GetDressIdRealCount(var0_1)
		end
	}, function()
		assert(false, "not exist runtime type: " .. arg0_1)
	end)
end

function var0_0.UpdateRuntimeTaskByTargetType(arg0_21)
	local var0_21 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_21, iter1_21 in pairs(var0_21:GetTasks()) do
		if iter1_21:ExistTargetType(arg0_21) then
			var0_21:UpdateTask(iter1_21)
		end
	end
end

function var0_0.UpdateClientTaskProgress(arg0_22, arg1_22)
	local var0_22 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetDiffTargetIdsByTypeAndParam(arg0_22, arg1_22)

	for iter0_22, iter1_22 in ipairs(var0_22) do
		pg.m02:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = 0,
			progress = 1,
			targetId = iter1_22
		})
	end
end

function var0_0.OnApproach(arg0_23)
	seriesAsync({
		function(arg0_24)
			local var0_24 = {}

			for iter0_24, iter1_24 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasks()) do
				if iter1_24:CheckAcceptOnApproach(arg0_23) then
					table.insert(var0_24, iter1_24.id)
				end
			end

			if #var0_24 > 0 then
				pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
					taskIds = var0_24,
					callback = arg0_24
				})
			else
				arg0_24()
			end
		end,
		function(arg0_25)
			local var0_25 = {}

			for iter0_25, iter1_25 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasks()) do
				if iter1_25:CheckSubmitOnApproach(arg0_23) then
					table.insert(var0_25, iter1_25.id)
				end
			end

			local var1_25 = {}

			for iter2_25, iter3_25 in ipairs(var0_25) do
				table.insert(var1_25, function(arg0_26)
					pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
						taskId = iter3_25,
						callback = arg0_26
					})
				end)
			end

			seriesAsync(var1_25, arg0_25)
		end
	}, function()
		var0_0.UpdateClientTaskProgress(IslandTaskTargetType.APPROACH, arg0_23)
	end)
end

function var0_0.OnActionEnd(arg0_28)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, arg0_28)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, 0)
end

function var0_0._GetTaskAcceptStoryId(arg0_29)
	local var0_29 = pg.island_task[arg0_29].rec_perform

	return pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_29)
end

function var0_0._GetTaskTargetLinkStoryIds(arg0_30)
	if pg.island_task_target[arg0_30].type ~= IslandTaskTargetType.INTERACTION then
		return nil
	end

	local var0_30 = pg.island_task_target[arg0_30].target_param[1]
	local var1_30 = pg.island_interaction[var0_30]

	if var1_30.type == IslandInteractionUntil.TYPE_STORY then
		local var2_30 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_30.param)

		return var2_30 and {
			var2_30
		} or nil
	elseif var1_30.type == IslandInteractionUntil.TYPE_PERFORMANCE then
		return IslandPerformancePerformer.GetStoryNameList(var1_30.param)
	end

	return nil
end

function var0_0._GetTaskSubmitStoryIds(arg0_31)
	local var0_31 = pg.island_task[arg0_31].com_perform
	local var1_31 = var0_31[1]

	if not var1_31 then
		return nil
	end

	local var2_31 = var0_31[2]

	if var1_31 == 1 then
		local var3_31 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var2_31)

		return var3_31 and {
			var3_31
		} or nil
	elseif var1_31 == 2 then
		return IslandPerformancePerformer.GetStoryNameList(var2_31)
	end

	return nil
end

function var0_0._GetTaskLinkStoryIds(arg0_32)
	local var0_32 = {}
	local var1_32 = var0_0._GetTaskAcceptStoryId(arg0_32.id)

	if var1_32 then
		table.insert(var0_32, var1_32)
	end

	for iter0_32, iter1_32 in ipairs(arg0_32:GetTargetList()) do
		if iter1_32:IsFinish() then
			local var2_32 = var0_0._GetTaskTargetLinkStoryIds(iter1_32.id)

			if var2_32 then
				table.insertto(var0_32, var2_32)
			end
		end
	end

	return var0_32
end

function var0_0._GetFinishTaskLinkStoryIds(arg0_33)
	local var0_33 = {}
	local var1_33 = var0_0._GetTaskAcceptStoryId(arg0_33)

	if var1_33 then
		table.insert(var0_33, var1_33)
	end

	for iter0_33, iter1_33 in ipairs(pg.island_task[arg0_33].target_id) do
		local var2_33 = var0_0._GetTaskTargetLinkStoryIds(iter1_33)

		if var2_33 then
			table.insertto(var0_33, var2_33)
		end
	end

	local var3_33 = var0_0._GetTaskSubmitStoryIds(arg0_33)

	if var3_33 then
		table.insertto(var0_33, var3_33)
	end

	return var0_33
end

function var0_0.FixTaskLinksStory(arg0_34)
	local var0_34 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_34 = {}

	for iter0_34, iter1_34 in pairs(var0_34:GetTasks()) do
		table.insertto(var1_34, var0_0._GetTaskLinkStoryIds(iter1_34))
	end

	for iter2_34, iter3_34 in ipairs(var0_34:GetFinishedIds()) do
		table.insertto(var1_34, var0_0._GetFinishTaskLinkStoryIds(iter3_34))
	end

	if #var1_34 > 0 then
		pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
			storyIds = var1_34,
			callback = arg0_34
		})
	else
		arg0_34()
	end
end

return var0_0

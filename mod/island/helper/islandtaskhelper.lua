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
		[IslandTaskTargetType.TASK_TYPE_PLUS] = function()
			return var1_1:GetTaskAgency():GetFinishCntByType(var0_1)
		end,
		[IslandTaskTargetType.RESTAURANT_RANK] = function()
			return var1_1:GetManageAgency():GetCntByRestLevel(var0_1)
		end,
		[IslandTaskTargetType.STORY] = function()
			local var0_17 = pg.NewStoryMgr.GetInstance()
			local var1_17 = var0_17:StoryId2StoryName(var0_1)

			return var0_17:IsPlayed(var1_17) and 1 or 0
		end,
		[IslandTaskTargetType.ACTION] = function()
			return var1_1:GetActionAgency():ExistAction(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.COMMANDER_DRESS_ID] = function()
			return var1_1:GetDressUpAgency():CheckOwnDress(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.SHIP_DRESS_ID] = function()
			return var2_1:GetDressIdRealCount(var0_1)
		end,
		[IslandTaskTargetType.ACTIVITY_ORDER] = function()
			return var1_1:GetOrderAgency():GetFinishedCntByActId(var0_1)
		end
	}, function()
		assert(false, "not exist runtime type: " .. arg0_1)
	end)
end

function var0_0.UpdateRuntimeTaskByTargetType(arg0_23)
	local var0_23 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_23, iter1_23 in pairs(var0_23:GetTasks()) do
		if iter1_23:ExistTargetType(arg0_23) then
			var0_23:UpdateTask(iter1_23)
		end
	end
end

function var0_0.UpdateClientTaskProgress(arg0_24, arg1_24)
	local var0_24 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetDiffTargetIdsByTypeAndParam(arg0_24, arg1_24)

	for iter0_24, iter1_24 in ipairs(var0_24) do
		pg.m02:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = 0,
			progress = 1,
			targetId = iter1_24
		})
	end
end

function var0_0.OnApproach(arg0_25)
	seriesAsync({
		function(arg0_26)
			local var0_26 = {}

			for iter0_26, iter1_26 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasks()) do
				if iter1_26:CheckAcceptOnApproach(arg0_25) then
					table.insert(var0_26, iter1_26.id)
				end
			end

			if #var0_26 > 0 then
				pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
					taskIds = var0_26,
					callback = arg0_26
				})
			else
				arg0_26()
			end
		end,
		function(arg0_27)
			local var0_27 = {}

			for iter0_27, iter1_27 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasks()) do
				if iter1_27:CheckSubmitOnApproach(arg0_25) then
					table.insert(var0_27, iter1_27.id)
				end
			end

			local var1_27 = {}

			for iter2_27, iter3_27 in ipairs(var0_27) do
				table.insert(var1_27, function(arg0_28)
					pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
						taskId = iter3_27,
						callback = arg0_28
					})
				end)
			end

			seriesAsync(var1_27, arg0_27)
		end
	}, function()
		var0_0.UpdateClientTaskProgress(IslandTaskTargetType.APPROACH, arg0_25)
	end)
end

function var0_0.OnActionEnd(arg0_30)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, arg0_30)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, 0)
end

function var0_0._GetTaskAcceptStoryId(arg0_31)
	local var0_31 = pg.island_task[arg0_31].rec_perform

	return pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_31)
end

function var0_0._GetTaskTargetLinkStoryIds(arg0_32)
	if pg.island_task_target[arg0_32].type ~= IslandTaskTargetType.INTERACTION then
		return nil
	end

	local var0_32 = pg.island_task_target[arg0_32].target_param[1]
	local var1_32 = pg.island_interaction[var0_32]

	if var1_32.type == IslandInteractionUntil.TYPE_STORY then
		local var2_32 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_32.param)

		return var2_32 and {
			var2_32
		} or nil
	elseif var1_32.type == IslandInteractionUntil.TYPE_PERFORMANCE then
		return IslandPerformancePerformer.GetStoryNameList(var1_32.param)
	end

	return nil
end

function var0_0._GetTaskSubmitStoryIds(arg0_33)
	local var0_33 = pg.island_task[arg0_33].com_perform
	local var1_33 = var0_33[1]

	if not var1_33 then
		return nil
	end

	local var2_33 = var0_33[2]

	if var1_33 == 1 then
		local var3_33 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var2_33)

		return var3_33 and {
			var3_33
		} or nil
	elseif var1_33 == 2 then
		return IslandPerformancePerformer.GetStoryNameList(var2_33)
	end

	return nil
end

function var0_0._GetTaskLinkStoryIds(arg0_34)
	local var0_34 = {}
	local var1_34 = var0_0._GetTaskAcceptStoryId(arg0_34.id)

	if var1_34 then
		table.insert(var0_34, var1_34)
	end

	for iter0_34, iter1_34 in ipairs(arg0_34:GetTargetList()) do
		if iter1_34:IsFinish() then
			local var2_34 = var0_0._GetTaskTargetLinkStoryIds(iter1_34.id)

			if var2_34 then
				table.insertto(var0_34, var2_34)
			end
		end
	end

	return var0_34
end

function var0_0._GetFinishTaskLinkStoryIds(arg0_35)
	local var0_35 = {}
	local var1_35 = var0_0._GetTaskAcceptStoryId(arg0_35)

	if var1_35 then
		table.insert(var0_35, var1_35)
	end

	for iter0_35, iter1_35 in ipairs(pg.island_task[arg0_35].target_id) do
		local var2_35 = var0_0._GetTaskTargetLinkStoryIds(iter1_35)

		if var2_35 then
			table.insertto(var0_35, var2_35)
		end
	end

	local var3_35 = var0_0._GetTaskSubmitStoryIds(arg0_35)

	if var3_35 then
		table.insertto(var0_35, var3_35)
	end

	return var0_35
end

function var0_0.FixTaskLinksStory(arg0_36)
	local var0_36 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_36 = {}

	for iter0_36, iter1_36 in pairs(var0_36:GetTasks()) do
		table.insertto(var1_36, var0_0._GetTaskLinkStoryIds(iter1_36))
	end

	for iter2_36, iter3_36 in ipairs(var0_36:GetFinishedIds()) do
		table.insertto(var1_36, var0_0._GetFinishTaskLinkStoryIds(iter3_36))
	end

	for iter4_36 = 3110000, 3119999 do
		local var2_36 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(iter4_36)

		if var2_36 and pg.NewStoryMgr.GetInstance():GetPlayedFlag(iter4_36) then
			local var3_36 = IslandPerformancePerformer.GetStoryNameList(var2_36)

			for iter5_36, iter6_36 in ipairs(var3_36) do
				table.insert(var1_36, iter6_36)
			end
		end
	end

	if #var1_36 > 0 then
		pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
			storyIds = var1_36,
			callback = arg0_36
		})
	else
		arg0_36()
	end
end

return var0_0

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
			return pg.island_task[var0_1].count_offset == 1 and var1_1:GetTaskAgency():IsFinishTask(var0_1) and 1 or 0
		end,
		[IslandTaskTargetType.TASK_TYPE_PLUS] = function()
			return var1_1:GetTaskAgency():GetFinishCntByType(var0_1, true)
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
		end,
		[IslandTaskTargetType.ORDER_DAILY] = function()
			return var1_1:GetOrderAgency():GetFinishCnt()
		end,
		[IslandTaskTargetType.ACTION_HELLO_DAILY] = function()
			return #var1_1:GetNpcFeedbackAgency():GetNpcList()
		end,
		[IslandTaskTargetType.TASK_DAILY_IN_WEEK] = function()
			return var1_1:GetTaskAgency():GetFinishedDailyCntInWeek()
		end
	}, function()
		assert(false, "not exist runtime type: " .. arg0_1)
	end)
end

function var0_0.UpdateRuntimeTaskByTargetType(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_26, iter1_26 in pairs(var0_26:GetTasks()) do
		if iter1_26:ExistTargetType(arg0_26) then
			var0_26:UpdateTask(iter1_26)
		end
	end
end

function var0_0.UpdateClientTaskProgress(arg0_27, arg1_27)
	local var0_27 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetDiffTargetIdsByTypeAndParam(arg0_27, arg1_27)

	for iter0_27, iter1_27 in ipairs(var0_27) do
		pg.m02:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = 0,
			progress = 1,
			targetId = iter1_27
		})
	end
end

function var0_0.OnApproach(arg0_28)
	seriesAsync({
		function(arg0_29)
			local var0_29 = {}

			for iter0_29, iter1_29 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasks()) do
				if iter1_29:CheckAcceptOnApproach(arg0_28) then
					table.insert(var0_29, iter1_29.id)
				end
			end

			if #var0_29 > 0 then
				pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
					taskIds = var0_29,
					callback = arg0_29
				})
			else
				arg0_29()
			end
		end,
		function(arg0_30)
			local var0_30 = {}

			for iter0_30, iter1_30 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasks()) do
				if iter1_30:CheckSubmitOnApproach(arg0_28) then
					table.insert(var0_30, iter1_30.id)
				end
			end

			local var1_30 = {}

			for iter2_30, iter3_30 in ipairs(var0_30) do
				table.insert(var1_30, function(arg0_31)
					pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
						taskId = iter3_30,
						callback = arg0_31
					})
				end)
			end

			seriesAsync(var1_30, arg0_30)
		end
	}, function()
		var0_0.UpdateClientTaskProgress(IslandTaskTargetType.APPROACH, arg0_28)
	end)
end

function var0_0.OnActionEnd(arg0_33)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, arg0_33)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, 0)
end

function var0_0.OnSubmitTask(arg0_34)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK_TYPE_PLUS)

	if underscore.any(arg0_34, function(arg0_35)
		local var0_35 = pg.island_task[arg0_35]

		return var0_35.type == IslandTaskType.DAILY and var0_35.count_offset == 1
	end) then
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK_DAILY_IN_WEEK)
	end
end

function var0_0._GetTaskAcceptStoryId(arg0_36)
	local var0_36 = pg.island_task[arg0_36].rec_perform

	return pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_36)
end

function var0_0._GetTaskTargetLinkStoryIds(arg0_37)
	if pg.island_task_target[arg0_37].type ~= IslandTaskTargetType.INTERACTION then
		return nil
	end

	local var0_37 = pg.island_task_target[arg0_37].target_param[1]
	local var1_37 = pg.island_interaction[var0_37]

	if var1_37.type == IslandInteractionUntil.TYPE_STORY then
		local var2_37 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_37.param)

		return var2_37 and {
			var2_37
		} or nil
	elseif var1_37.type == IslandInteractionUntil.TYPE_PERFORMANCE then
		return IslandPerformancePerformer.GetStoryNameList(var1_37.param)
	end

	return nil
end

function var0_0._GetTaskSubmitStoryIds(arg0_38)
	local var0_38 = pg.island_task[arg0_38].com_perform
	local var1_38 = var0_38[1]

	if not var1_38 then
		return nil
	end

	local var2_38 = var0_38[2]

	if var1_38 == 1 then
		local var3_38 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var2_38)

		return var3_38 and {
			var3_38
		} or nil
	elseif var1_38 == 2 then
		return IslandPerformancePerformer.GetStoryNameList(var2_38)
	end

	return nil
end

function var0_0._GetTaskLinkStoryIds(arg0_39)
	local var0_39 = {}
	local var1_39 = var0_0._GetTaskAcceptStoryId(arg0_39.id)

	if var1_39 then
		table.insert(var0_39, var1_39)
	end

	for iter0_39, iter1_39 in ipairs(arg0_39:GetTargetList()) do
		if iter1_39:IsFinish() then
			local var2_39 = var0_0._GetTaskTargetLinkStoryIds(iter1_39.id)

			if var2_39 then
				table.insertto(var0_39, var2_39)
			end
		end
	end

	return var0_39
end

function var0_0._GetFinishTaskLinkStoryIds(arg0_40)
	local var0_40 = {}
	local var1_40 = var0_0._GetTaskAcceptStoryId(arg0_40)

	if var1_40 then
		table.insert(var0_40, var1_40)
	end

	for iter0_40, iter1_40 in ipairs(pg.island_task[arg0_40].target_id) do
		local var2_40 = var0_0._GetTaskTargetLinkStoryIds(iter1_40)

		if var2_40 then
			table.insertto(var0_40, var2_40)
		end
	end

	local var3_40 = var0_0._GetTaskSubmitStoryIds(arg0_40)

	if var3_40 then
		table.insertto(var0_40, var3_40)
	end

	return var0_40
end

function var0_0.FixTaskLinksStory(arg0_41)
	local var0_41 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_41 = {}

	for iter0_41, iter1_41 in pairs(var0_41:GetTasks()) do
		table.insertto(var1_41, var0_0._GetTaskLinkStoryIds(iter1_41))
	end

	for iter2_41, iter3_41 in ipairs(var0_41:GetFinishedIds()) do
		table.insertto(var1_41, var0_0._GetFinishTaskLinkStoryIds(iter3_41))
	end

	for iter4_41 = 3110000, 3119999 do
		local var2_41 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(iter4_41)

		if var2_41 and pg.NewStoryMgr.GetInstance():GetPlayedFlag(iter4_41) then
			local var3_41 = IslandPerformancePerformer.GetStoryNameList(var2_41)

			for iter5_41, iter6_41 in ipairs(var3_41) do
				table.insert(var1_41, iter6_41)
			end
		end
	end

	if #var1_41 > 0 then
		pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
			storyIds = var1_41,
			callback = arg0_41
		})
	else
		arg0_41()
	end
end

return var0_0

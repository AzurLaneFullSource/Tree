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
		end,
		[IslandTaskTargetType.GAME_MAX_SCORE] = function()
			local var0_25 = pg.mode_room[var0_1].activity_type
			local var1_25 = getProxy(ActivityProxy):getActivityByType(var0_25)

			return var1_25 and var1_25.data2 or 0
		end,
		[IslandTaskTargetType.GAME_CUR_SCORE] = function()
			local var0_26 = pg.mode_room[var0_1].activity_type
			local var1_26 = getProxy(ActivityProxy):getActivityByType(var0_26)

			return var1_26 and var1_26.data1 or 0
		end
	}, function()
		assert(false, "not exist runtime type: " .. arg0_1)
	end)
end

function var0_0.UpdateRuntimeTaskByTargetType(arg0_28)
	local var0_28 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_28, iter1_28 in pairs(var0_28:GetTasks()) do
		if iter1_28:ExistTargetType(arg0_28) then
			var0_28:UpdateTask(iter1_28)
		end
	end
end

function var0_0.UpdateClientTaskProgress(arg0_29, arg1_29)
	local var0_29 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetDiffTargetIdsByTypeAndParam(arg0_29, arg1_29)

	for iter0_29, iter1_29 in ipairs(var0_29) do
		pg.m02:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = 0,
			progress = 1,
			targetId = iter1_29
		})
	end
end

function var0_0.OnApproach(arg0_30)
	seriesAsync({
		function(arg0_31)
			local var0_31 = {}

			for iter0_31, iter1_31 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasks()) do
				if iter1_31:CheckAcceptOnApproach(arg0_30) then
					table.insert(var0_31, iter1_31.id)
				end
			end

			if #var0_31 > 0 then
				pg.m02:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
					taskIds = var0_31,
					callback = arg0_31
				})
			else
				arg0_31()
			end
		end,
		function(arg0_32)
			local var0_32 = {}

			for iter0_32, iter1_32 in pairs(getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasks()) do
				if iter1_32:CheckSubmitOnApproach(arg0_30) then
					table.insert(var0_32, iter1_32.id)
				end
			end

			local var1_32 = {}

			for iter2_32, iter3_32 in ipairs(var0_32) do
				table.insert(var1_32, function(arg0_33)
					pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
						taskId = iter3_32,
						callback = arg0_33
					})
				end)
			end

			seriesAsync(var1_32, arg0_32)
		end
	}, function()
		var0_0.UpdateClientTaskProgress(IslandTaskTargetType.APPROACH, arg0_30)
	end)
end

function var0_0.OnActionEnd(arg0_35)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, arg0_35)
	var0_0.UpdateClientTaskProgress(IslandTaskTargetType.ACTION_END, 0)
end

function var0_0.OnSubmitTask(arg0_36)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK_TYPE_PLUS)

	if underscore.any(arg0_36, function(arg0_37)
		local var0_37 = pg.island_task[arg0_37]

		return var0_37.type == IslandTaskType.DAILY and var0_37.count_offset == 1
	end) then
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK_DAILY_IN_WEEK)
	end
end

function var0_0._GetTaskAcceptStoryId(arg0_38)
	local var0_38 = pg.island_task[arg0_38].rec_perform

	return pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_38)
end

function var0_0._GetTaskTargetLinkStoryIds(arg0_39)
	if pg.island_task_target[arg0_39].type ~= IslandTaskTargetType.INTERACTION then
		return nil
	end

	local var0_39 = pg.island_task_target[arg0_39].target_param[1]
	local var1_39 = pg.island_interaction[var0_39]

	if var1_39.type == IslandInteractionUntil.TYPE_STORY then
		local var2_39 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_39.param)

		return var2_39 and {
			var2_39
		} or nil
	elseif var1_39.type == IslandInteractionUntil.TYPE_PERFORMANCE then
		return IslandPerformancePerformer.GetStoryNameList(var1_39.param)
	end

	return nil
end

function var0_0._GetTaskSubmitStoryIds(arg0_40)
	local var0_40 = pg.island_task[arg0_40].com_perform
	local var1_40 = var0_40[1]

	if not var1_40 then
		return nil
	end

	local var2_40 = var0_40[2]

	if var1_40 == 1 then
		local var3_40 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var2_40)

		return var3_40 and {
			var3_40
		} or nil
	elseif var1_40 == 2 then
		return IslandPerformancePerformer.GetStoryNameList(var2_40)
	end

	return nil
end

function var0_0._GetTaskLinkStoryIds(arg0_41)
	local var0_41 = {}
	local var1_41 = var0_0._GetTaskAcceptStoryId(arg0_41.id)

	if var1_41 then
		table.insert(var0_41, var1_41)
	end

	for iter0_41, iter1_41 in ipairs(arg0_41:GetTargetList()) do
		if iter1_41:IsFinish() then
			local var2_41 = var0_0._GetTaskTargetLinkStoryIds(iter1_41.id)

			if var2_41 then
				table.insertto(var0_41, var2_41)
			end
		end
	end

	return var0_41
end

function var0_0._GetFinishTaskLinkStoryIds(arg0_42)
	local var0_42 = {}
	local var1_42 = var0_0._GetTaskAcceptStoryId(arg0_42)

	if var1_42 then
		table.insert(var0_42, var1_42)
	end

	for iter0_42, iter1_42 in ipairs(pg.island_task[arg0_42].target_id) do
		local var2_42 = var0_0._GetTaskTargetLinkStoryIds(iter1_42)

		if var2_42 then
			table.insertto(var0_42, var2_42)
		end
	end

	local var3_42 = var0_0._GetTaskSubmitStoryIds(arg0_42)

	if var3_42 then
		table.insertto(var0_42, var3_42)
	end

	return var0_42
end

function var0_0.FixTaskLinksStory(arg0_43)
	local var0_43 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_43 = {}

	for iter0_43, iter1_43 in pairs(var0_43:GetTasks()) do
		table.insertto(var1_43, var0_0._GetTaskLinkStoryIds(iter1_43))
	end

	for iter2_43, iter3_43 in ipairs(var0_43:GetFinishedIds()) do
		table.insertto(var1_43, var0_0._GetFinishTaskLinkStoryIds(iter3_43))
	end

	for iter4_43 = 3110000, 3119999 do
		local var2_43 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(iter4_43)

		if var2_43 and pg.NewStoryMgr.GetInstance():GetPlayedFlag(iter4_43) then
			local var3_43 = IslandPerformancePerformer.GetStoryNameList(var2_43)

			for iter5_43, iter6_43 in ipairs(var3_43) do
				table.insert(var1_43, iter6_43)
			end
		end
	end

	if #var1_43 > 0 then
		pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
			storyIds = var1_43,
			callback = arg0_43
		})
	else
		arg0_43()
	end
end

return var0_0

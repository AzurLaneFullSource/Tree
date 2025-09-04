local var0_0 = class("IslandSubmitTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.taskId
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(21038, {
		task_id = var1_1
	}, 21039, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()
			local var1_2 = var0_2:GetTaskAgency()
			local var2_2 = var1_2:GetTask(var1_1)
			local var3_2 = var2_2.id == var1_2:GetTraceId()
			local var4_2 = var2_2:GetExp()

			if var2_2:GetType() == IslandTaskType.MAIN then
				IslandAchievementHelper.UpdateRecord(IslandAchievementType.FINISH_MAIN_TASK, var1_1, 1)
			end

			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandTaskSubmit(var2_2:GetType(), var2_2.id))

			local var5_2 = var0_2:GetInventoryAgency()

			for iter0_2, iter1_2 in ipairs(var2_2:GetRecycleItemInfos()) do
				var5_2:RemoveItem(iter1_2.id, iter1_2.count)
			end

			if var2_2:getConfig("is_tech_task") == 1 then
				var0_2:GetTechnologyAgency():TryAutoUnlock()
			end

			var1_2:RemoveTask(var1_1)
			var1_2:AddFinishId(var1_1)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TASK)
			var1_2:TryAcceptAutoTasks(function()
				if var3_2 then
					getProxy(IslandProxy):GetIsland():GetTaskAgency():TryAutoTrackTask()
				end
			end)

			local var6_2 = IslandDropHelper.AddItems(arg0_2, var4_2)

			arg0_1:sendNotification(GAME.ISLAND_SUBMIT_TASK_DONE, {
				taskId = var1_1,
				dropData = var6_2,
				callback = var2_1
			})
			arg0_1:UpdateGuide(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.UpdateGuide(arg0_4, arg1_4)
	switch(arg1_4, {
		[IslandGuideChecker.MOVE_TASK_ID] = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "ISLAND_GUIDE_2"
			})
		end,
		[IslandGuideChecker.ORDER_TASK_ID] = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "ISLAND_GUIDE_7"
			})
		end,
		[IslandGuideChecker.TECH_TASK_ID] = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "ISLAND_GUIDE_8"
			})
		end,
		[IslandGuideChecker.INVITE_TASK_ID] = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "ISLAND_GUIDE_9"
			})
		end
	}, function()
		return
	end)
end

return var0_0

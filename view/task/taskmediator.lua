local var0_0 = class("TaskMediator", import("..base.ContextMediator"))

var0_0.ON_TASK_SUBMIT = "TaskMediator:ON_TASK_SUBMIT"
var0_0.ON_TASK_GO = "TaskMediator:ON_TASK_GO"
var0_0.TASK_FILTER = "TaskMediator:TASK_FILTER"
var0_0.ON_SUBMIT_AVATAR_TASK = "TaskMediator:ON_SUBMIT_AVATAR_TASK"
var0_0.ON_SUBMIT_WEEK_PROGREE = "TaskMediator:ON_SUBMIT_WEEK_PROGREE"
var0_0.ON_BATCH_SUBMIT_WEEK_TASK = "TaskMediator:ON_BATCH_SUBMIT_WEEK_TASK"
var0_0.ON_SUBMIT_WEEK_TASK = "TaskMediator:ON_SUBMIT_WEEK_TASK"
var0_0.CLICK_GET_ALL = "TaskMediator:CLICK_GET_ALL"
var0_0.ON_DROP = "TaskMediator:ON_DROP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SUBMIT_WEEK_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_WEEK_TASK, {
			id = arg1_2.id
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_AVATAR_TASK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1_3.actId,
			task_ids = {
				arg1_3.id
			}
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_WEEK_PROGREE, function(arg0_4)
		arg0_1:sendNotification(GAME.SUBMIT_WEEK_TASK_PROGRESS)
	end)
	arg0_1:bind(var0_0.ON_BATCH_SUBMIT_WEEK_TASK, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK, {
			ids = arg1_5,
			callback = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_DROP, function(arg0_6, arg1_6, arg2_6)
		if arg1_6.type == DROP_TYPE_EQUIP then
			arg0_1:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = {
					equipmentId = arg1_6:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY,
					onRemoved = arg2_6,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		elseif arg1_6.type == DROP_TYPE_SPWEAPON then
			arg0_1:addSubLayers(Context.New({
				mediator = SpWeaponInfoMediator,
				viewComponent = SpWeaponInfoLayer,
				data = {
					spWeaponConfigId = arg1_6:getConfig("id"),
					type = SpWeaponInfoLayer.TYPE_DISPLAY,
					onRemoved = arg2_6,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = arg1_6,
				onNo = arg2_6,
				onYes = arg2_6,
				weight = LayerWeightConst.THIRD_LAYER
			})
		end
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_7, arg1_7)
		local var0_7 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

		if var0_7 then
			local var1_7 = var0_7:getConfig("config_data")
			local var2_7 = _.flatten(var1_7)

			if arg1_7.id == var2_7[#var2_7] then
				pg.NewStoryMgr.GetInstance():Play("YIXIAN8", function()
					arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_7.id)
				end)

				return
			end
		end

		if arg1_7.index then
			arg0_1:sendNotification(GAME.SUBMIT_TASK, {
				taskId = arg1_7.id,
				index = arg1_7.index
			})
		else
			arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_7.id)
		end
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_9
		})
	end)
	arg0_1:SetTaskVOs()

	local var0_1 = getProxy(TaskProxy)

	arg0_1.viewComponent:SetWeekTaskProgressInfo(var0_1:GetWeekTaskProgressInfo())
end

function var0_0.SetTaskVOs(arg0_10)
	local var0_10 = getProxy(TaskProxy):getData()
	local var1_10 = getProxy(BagProxy)

	for iter0_10, iter1_10 in pairs(var0_10) do
		if iter1_10:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var2_10 = tonumber(iter1_10:getConfig("target_id"))

			iter1_10.progress = var1_10:getItemCountById(tonumber(var2_10))
		elseif iter1_10:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var3_10 = tonumber(iter1_10:getConfig("target_id"))

			iter1_10.progress = getProxy(ActivityProxy):getVirtualItemNumber(var3_10)
		end
	end

	arg0_10.viewComponent:setTaskVOs(var0_10)
end

function var0_0.enterLevel(arg0_11, arg1_11)
	local var0_11 = getProxy(ChapterProxy):getChapterById(arg1_11)

	if var0_11 then
		local var1_11 = {
			mapIdx = var0_11:getConfig("map")
		}

		if var0_11.active then
			var1_11.chapterId = var0_11.id
		else
			var1_11.openChapterId = arg1_11
		end

		arg0_11:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var1_11)
	end
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SUBMIT_TASK_DONE,
		var0_0.TASK_FILTER,
		GAME.BEGIN_STAGE_DONE,
		GAME.CHAPTER_OP_DONE,
		TaskProxy.WEEK_TASK_UPDATED,
		TaskProxy.WEEK_TASKS_ADDED,
		TaskProxy.WEEK_TASKS_DELETED,
		GAME.SUBMIT_WEEK_TASK_DONE,
		GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE,
		GAME.SUBMIT_AVATAR_TASK_DONE,
		TaskProxy.WEEK_TASK_RESET,
		GAME.MERGE_TASK_ONE_STEP_AWARD_DONE,
		AvatarFrameProxy.FRAME_TASK_TIME_OUT
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()

	if var0_13 == TaskProxy.TASK_ADDED then
		if var1_13:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var2_13 = tonumber(var1_13:getConfig("target_id"))

			var1_13.progress = getProxy(BagProxy):getItemCountById(tonumber(var2_13))
		elseif var1_13:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var3_13 = tonumber(var1_13:getConfig("target_id"))

			var1_13.progress = getProxy(ActivityProxy):getVirtualItemNumber(var3_13)
		end

		arg0_13.viewComponent:addTask(var1_13)
	elseif var0_13 == GAME.CHAPTER_OP_DONE then
		if arg0_13.chapterId then
			arg0_13:enterLevel(arg0_13.chapterId)

			arg0_13.chapterId = nil
		end
	elseif var0_13 == TaskProxy.TASK_UPDATED then
		if var1_13:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var4_13 = tonumber(var1_13:getConfig("target_id"))

			var1_13.progress = getProxy(BagProxy):getItemCountById(tonumber(var4_13))
		elseif var1_13:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var5_13 = tonumber(var1_13:getConfig("target_id"))

			var1_13.progress = getProxy(ActivityProxy):getVirtualItemNumber(var5_13)
		end

		arg0_13.viewComponent:updateTask(var1_13)
	elseif var0_13 == TaskProxy.TASK_REMOVED then
		arg0_13.viewComponent:removeTask(var1_13)
	elseif var0_13 == var0_0.TASK_FILTER then
		arg0_13.viewComponent:GoToFilter(var1_13)
	elseif var0_13 == GAME.SUBMIT_TASK_DONE then
		local var6_13 = arg1_13:getType()
		local var7_13 = getProxy(TaskProxy)

		arg0_13.viewComponent.onShowAwards = true

		arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13, function()
			arg0_13.viewComponent.onShowAwards = nil

			arg0_13:accepetActivityTask()
			arg0_13.viewComponent:updateOneStepBtn()

			local var0_14 = {}

			for iter0_14, iter1_14 in ipairs(var6_13) do
				table.insert(var0_14, function(arg0_15)
					arg0_13:PlayStoryForTaskAct(iter1_14, arg0_15)
				end)
			end

			if arg0_13.refreshWeekTaskPageFlag then
				arg0_13.viewComponent:RefreshWeekTaskPage()

				arg0_13.refreshWeekTaskPageFlag = nil
			end

			table.insert(var0_14, function(arg0_16)
				getProxy(FeastProxy):HandleTaskStories(var6_13, arg0_16)
			end)

			if #var0_14 > 0 then
				seriesAsync(var0_14)
			end
		end)
	elseif var0_13 == GAME.BEGIN_STAGE_DONE then
		arg0_13:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_13)
	elseif var0_13 == TaskProxy.WEEK_TASKS_ADDED or var0_13 == TaskProxy.WEEK_TASKS_DELETED or var0_13 == TaskProxy.WEEK_TASK_UPDATED then
		arg0_13.viewComponent:RefreshWeekTaskPage()
	elseif var0_13 == GAME.SUBMIT_WEEK_TASK_DONE then
		arg0_13.viewComponent:RefreshWeekTaskPageBefore(var1_13.id)

		local function var8_13()
			arg0_13.viewComponent:RefreshWeekTaskPage()
		end

		if #var1_13.awards > 0 then
			arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards, var8_13)
		else
			var8_13()
		end
	elseif var0_13 == GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE then
		local function var9_13()
			arg0_13.viewComponent:RefreshWeekTaskProgress()
		end

		if #var1_13.awards > 0 then
			arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards, var9_13)
		else
			var9_13()
		end
	elseif var0_13 == GAME.SUBMIT_AVATAR_TASK_DONE then
		local function var10_13()
			arg0_13.viewComponent:refreshPage()

			if var1_13.callback then
				var1_13.callback()
			end
		end

		if #var1_13.awards > 0 then
			arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards, var10_13)
		else
			var10_13()
		end
	elseif var0_13 == TaskProxy.WEEK_TASK_RESET then
		arg0_13:SetTaskVOs()
		arg0_13.viewComponent:ResetWeekTaskPage()
	elseif var0_13 == GAME.MERGE_TASK_ONE_STEP_AWARD_DONE then
		arg0_13.refreshWeekTaskPageFlag = true

		arg0_13:sendNotification(GAME.SUBMIT_TASK_DONE, var1_13.awards, var1_13.taskIds)
	elseif var0_13 == AvatarFrameProxy.FRAME_TASK_TIME_OUT then
		arg0_13.viewComponent:refreshPage()
	end
end

function var0_0.accepetActivityTask(arg0_20)
	arg0_20:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
end

function var0_0.PlayStoryForTaskAct(arg0_21, arg1_21, arg2_21)
	local var0_21 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1_21

	for iter0_21, iter1_21 in ipairs(var0_21) do
		if iter1_21 and not iter1_21:isEnd() then
			local var2_21 = iter1_21:getConfig("config_data")
			local var3_21 = 0
			local var4_21 = 0

			for iter2_21, iter3_21 in ipairs(var2_21) do
				for iter4_21, iter5_21 in ipairs(iter3_21) do
					if iter5_21 == arg1_21 then
						var3_21 = iter2_21
						var4_21 = iter4_21
					end
				end
			end

			local var5_21 = iter1_21:getConfig("config_client").story or {}

			if var5_21[var3_21] then
				local var6_21 = var5_21[var3_21][var4_21]

				if var6_21 and not pg.NewStoryMgr.GetInstance():IsPlayed(var6_21) then
					var1_21 = var6_21
				end
			end
		end
	end

	if var1_21 then
		pg.NewStoryMgr.GetInstance():Play(var1_21, arg2_21)
	else
		arg2_21()
	end
end

return var0_0

local var0 = class("TaskMediator", import("..base.ContextMediator"))

var0.ON_TASK_SUBMIT = "TaskMediator:ON_TASK_SUBMIT"
var0.ON_TASK_GO = "TaskMediator:ON_TASK_GO"
var0.TASK_FILTER = "TaskMediator:TASK_FILTER"
var0.ON_SUBMIT_AVATAR_TASK = "TaskMediator:ON_SUBMIT_AVATAR_TASK"
var0.ON_SUBMIT_WEEK_PROGREE = "TaskMediator:ON_SUBMIT_WEEK_PROGREE"
var0.ON_BATCH_SUBMIT_WEEK_TASK = "TaskMediator:ON_BATCH_SUBMIT_WEEK_TASK"
var0.ON_SUBMIT_WEEK_TASK = "TaskMediator:ON_SUBMIT_WEEK_TASK"
var0.CLICK_GET_ALL = "TaskMediator:CLICK_GET_ALL"
var0.ON_DROP = "TaskMediator:ON_DROP"

function var0.register(arg0)
	arg0:bind(var0.ON_SUBMIT_WEEK_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_WEEK_TASK, {
			id = arg1.id
		})
	end)
	arg0:bind(var0.ON_SUBMIT_AVATAR_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.AVATAR_FRAME_AWARD, {
			act_id = arg1.actId,
			task_ids = {
				arg1.id
			}
		})
	end)
	arg0:bind(var0.ON_SUBMIT_WEEK_PROGREE, function(arg0)
		arg0:sendNotification(GAME.SUBMIT_WEEK_TASK_PROGRESS)
	end)
	arg0:bind(var0.ON_BATCH_SUBMIT_WEEK_TASK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK, {
			ids = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_DROP, function(arg0, arg1, arg2)
		if arg1.type == DROP_TYPE_EQUIP then
			arg0:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = {
					equipmentId = arg1:getConfig("id"),
					type = EquipmentInfoMediator.TYPE_DISPLAY,
					onRemoved = arg2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		elseif arg1.type == DROP_TYPE_SPWEAPON then
			arg0:addSubLayers(Context.New({
				mediator = SpWeaponInfoMediator,
				viewComponent = SpWeaponInfoLayer,
				data = {
					spWeaponConfigId = arg1:getConfig("id"),
					type = SpWeaponInfoLayer.TYPE_DISPLAY,
					onRemoved = arg2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = arg1,
				onNo = arg2,
				onYes = arg2,
				weight = LayerWeightConst.THIRD_LAYER
			})
		end
	end)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

		if var0 then
			local var1 = var0:getConfig("config_data")
			local var2 = _.flatten(var1)

			if arg1.id == var2[#var2] then
				pg.NewStoryMgr.GetInstance():Play("YIXIAN8", function()
					arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
				end)

				return
			end
		end

		if arg1.index then
			arg0:sendNotification(GAME.SUBMIT_TASK, {
				taskId = arg1.id,
				index = arg1.index
			})
		else
			arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
		end
	end)
	arg0:bind(var0.ON_TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:SetTaskVOs()

	local var0 = getProxy(TaskProxy)

	arg0.viewComponent:SetWeekTaskProgressInfo(var0:GetWeekTaskProgressInfo())
end

function var0.SetTaskVOs(arg0)
	local var0 = getProxy(TaskProxy):getData()
	local var1 = getProxy(BagProxy)

	for iter0, iter1 in pairs(var0) do
		if iter1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var2 = tonumber(iter1:getConfig("target_id"))

			iter1.progress = var1:getItemCountById(tonumber(var2))
		elseif iter1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var3 = tonumber(iter1:getConfig("target_id"))

			iter1.progress = getProxy(ActivityProxy):getVirtualItemNumber(var3)
		end
	end

	arg0.viewComponent:setTaskVOs(var0)
end

function var0.enterLevel(arg0, arg1)
	local var0 = getProxy(ChapterProxy):getChapterById(arg1)

	if var0 then
		local var1 = {
			mapIdx = var0:getConfig("map")
		}

		if var0.active then
			var1.chapterId = var0.id
		else
			var1.openChapterId = arg1
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var1)
	end
end

function var0.listNotificationInterests(arg0)
	return {
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SUBMIT_TASK_DONE,
		var0.TASK_FILTER,
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TaskProxy.TASK_ADDED then
		if var1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var2 = tonumber(var1:getConfig("target_id"))

			var1.progress = getProxy(BagProxy):getItemCountById(tonumber(var2))
		elseif var1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var3 = tonumber(var1:getConfig("target_id"))

			var1.progress = getProxy(ActivityProxy):getVirtualItemNumber(var3)
		end

		arg0.viewComponent:addTask(var1)
	elseif var0 == GAME.CHAPTER_OP_DONE then
		if arg0.chapterId then
			arg0:enterLevel(arg0.chapterId)

			arg0.chapterId = nil
		end
	elseif var0 == TaskProxy.TASK_UPDATED then
		if var1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var4 = tonumber(var1:getConfig("target_id"))

			var1.progress = getProxy(BagProxy):getItemCountById(tonumber(var4))
		elseif var1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var5 = tonumber(var1:getConfig("target_id"))

			var1.progress = getProxy(ActivityProxy):getVirtualItemNumber(var5)
		end

		arg0.viewComponent:updateTask(var1)
	elseif var0 == TaskProxy.TASK_REMOVED then
		arg0.viewComponent:removeTask(var1)
	elseif var0 == var0.TASK_FILTER then
		arg0.viewComponent:GoToFilter(var1)
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		local var6 = arg1:getType()
		local var7 = getProxy(TaskProxy)

		arg0.viewComponent.onShowAwards = true

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent.onShowAwards = nil

			arg0:accepetActivityTask()
			arg0.viewComponent:updateOneStepBtn()

			local var0 = {}

			for iter0, iter1 in ipairs(var6) do
				table.insert(var0, function(arg0)
					arg0:PlayStoryForTaskAct(iter1, arg0)
				end)
			end

			if arg0.refreshWeekTaskPageFlag then
				arg0.viewComponent:RefreshWeekTaskPage()

				arg0.refreshWeekTaskPageFlag = nil
			end

			table.insert(var0, function(arg0)
				getProxy(FeastProxy):HandleTaskStories(var6, arg0)
			end)

			if #var0 > 0 then
				seriesAsync(var0)
			end
		end)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == TaskProxy.WEEK_TASKS_ADDED or var0 == TaskProxy.WEEK_TASKS_DELETED or var0 == TaskProxy.WEEK_TASK_UPDATED then
		arg0.viewComponent:RefreshWeekTaskPage()
	elseif var0 == GAME.SUBMIT_WEEK_TASK_DONE then
		arg0.viewComponent:RefreshWeekTaskPageBefore(var1.id)

		local function var8()
			arg0.viewComponent:RefreshWeekTaskPage()
		end

		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var8)
		else
			var8()
		end
	elseif var0 == GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE then
		local function var9()
			arg0.viewComponent:RefreshWeekTaskProgress()
		end

		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var9)
		else
			var9()
		end
	elseif var0 == GAME.SUBMIT_AVATAR_TASK_DONE then
		local function var10()
			arg0.viewComponent:refreshPage()

			if var1.callback then
				var1.callback()
			end
		end

		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var10)
		else
			var10()
		end
	elseif var0 == TaskProxy.WEEK_TASK_RESET then
		arg0:SetTaskVOs()
		arg0.viewComponent:ResetWeekTaskPage()
	elseif var0 == GAME.MERGE_TASK_ONE_STEP_AWARD_DONE then
		arg0.refreshWeekTaskPageFlag = true

		arg0:sendNotification(GAME.SUBMIT_TASK_DONE, var1.awards, var1.taskIds)
	elseif var0 == AvatarFrameProxy.FRAME_TASK_TIME_OUT then
		arg0.viewComponent:refreshPage()
	end
end

function var0.accepetActivityTask(arg0)
	arg0:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
end

function var0.PlayStoryForTaskAct(arg0, arg1, arg2)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1

	for iter0, iter1 in ipairs(var0) do
		if iter1 and not iter1:isEnd() then
			local var2 = iter1:getConfig("config_data")
			local var3 = 0
			local var4 = 0

			for iter2, iter3 in ipairs(var2) do
				for iter4, iter5 in ipairs(iter3) do
					if iter5 == arg1 then
						var3 = iter2
						var4 = iter4
					end
				end
			end

			local var5 = iter1:getConfig("config_client").story or {}

			if var5[var3] then
				local var6 = var5[var3][var4]

				if var6 and not pg.NewStoryMgr.GetInstance():IsPlayed(var6) then
					var1 = var6
				end
			end
		end
	end

	if var1 then
		pg.NewStoryMgr.GetInstance():Play(var1, arg2)
	else
		arg2()
	end
end

return var0

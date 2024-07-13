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
var0_0.STORE_ACTIVITY_AWARDS = "TaskMediator:STORE_ACTIVITY_AWARDS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SUBMIT_WEEK_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_WEEK_TASK, {
			id = arg1_2.id
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_AVATAR_TASK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_3:getActId(),
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
	arg0_1:bind(var0_0.STORE_ACTIVITY_AWARDS, function(arg0_10, arg1_10)
		arg0_1.storeActivityAwardFlag = arg1_10
	end)
	arg0_1:SetTaskVOs()

	local var0_1 = getProxy(TaskProxy)

	arg0_1.viewComponent:SetWeekTaskProgressInfo(var0_1:GetWeekTaskProgressInfo())
end

function var0_0.SetTaskVOs(arg0_11)
	local var0_11 = getProxy(TaskProxy):getData()
	local var1_11 = getProxy(BagProxy)

	for iter0_11, iter1_11 in pairs(var0_11) do
		if iter1_11:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var2_11 = tonumber(iter1_11:getConfig("target_id"))

			iter1_11.progress = var1_11:getItemCountById(tonumber(var2_11))
		elseif iter1_11:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var3_11 = tonumber(iter1_11:getConfig("target_id"))

			iter1_11.progress = getProxy(ActivityProxy):getVirtualItemNumber(var3_11)
		end
	end

	arg0_11.viewComponent:setTaskVOs(var0_11)
end

function var0_0.enterLevel(arg0_12, arg1_12)
	local var0_12 = getProxy(ChapterProxy):getChapterById(arg1_12)

	if var0_12 then
		local var1_12 = {
			mapIdx = var0_12:getConfig("map")
		}

		if var0_12.active then
			var1_12.chapterId = var0_12.id
		else
			var1_12.openChapterId = arg1_12
		end

		arg0_12:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var1_12)
	end
end

function var0_0.listNotificationInterests(arg0_13)
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
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.SUBMIT_AVATAR_TASK_DONE,
		TaskProxy.WEEK_TASK_RESET,
		GAME.MERGE_TASK_ONE_STEP_AWARD_DONE,
		AvatarFrameProxy.FRAME_TASK_TIME_OUT
	}
end

function var0_0.handleNotification(arg0_14, arg1_14)
	local var0_14 = arg1_14:getName()
	local var1_14 = arg1_14:getBody()

	if var0_14 == TaskProxy.TASK_ADDED then
		if var1_14:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var2_14 = tonumber(var1_14:getConfig("target_id"))

			var1_14.progress = getProxy(BagProxy):getItemCountById(tonumber(var2_14))
		elseif var1_14:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var3_14 = tonumber(var1_14:getConfig("target_id"))

			var1_14.progress = getProxy(ActivityProxy):getVirtualItemNumber(var3_14)
		end

		arg0_14.viewComponent:addTask(var1_14)
	elseif var0_14 == GAME.CHAPTER_OP_DONE then
		if arg0_14.chapterId then
			arg0_14:enterLevel(arg0_14.chapterId)

			arg0_14.chapterId = nil
		end
	elseif var0_14 == TaskProxy.TASK_UPDATED then
		if var1_14:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var4_14 = tonumber(var1_14:getConfig("target_id"))

			var1_14.progress = getProxy(BagProxy):getItemCountById(tonumber(var4_14))
		elseif var1_14:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			local var5_14 = tonumber(var1_14:getConfig("target_id"))

			var1_14.progress = getProxy(ActivityProxy):getVirtualItemNumber(var5_14)
		end

		arg0_14.viewComponent:updateTask(var1_14)
	elseif var0_14 == TaskProxy.TASK_REMOVED then
		arg0_14.viewComponent:removeTask(var1_14)
	elseif var0_14 == var0_0.TASK_FILTER then
		arg0_14.viewComponent:GoToFilter(var1_14)
	elseif var0_14 == GAME.SUBMIT_TASK_DONE then
		local var6_14 = arg1_14:getType()
		local var7_14 = var1_14
		local var8_14 = getProxy(TaskProxy)

		arg0_14.viewComponent.onShowAwards = true

		if arg0_14.activityAwards and #arg0_14.activityAwards > 0 then
			for iter0_14, iter1_14 in ipairs(arg0_14.activityAwards) do
				table.insert(var7_14, iter1_14)
			end

			arg0_14.activityAwards = {}
		end

		arg0_14:addAwardShow(var7_14, function()
			arg0_14.viewComponent.onShowAwards = nil

			arg0_14:accepetActivityTask()
			arg0_14.viewComponent:refreshPage()
			arg0_14.viewComponent:updateOneStepBtn()

			local var0_15 = {}

			for iter0_15, iter1_15 in ipairs(var6_14) do
				table.insert(var0_15, function(arg0_16)
					arg0_14:PlayStoryForTaskAct(iter1_15, arg0_16)
				end)
			end

			if arg0_14.refreshWeekTaskPageFlag then
				arg0_14.viewComponent:RefreshWeekTaskPage()

				arg0_14.refreshWeekTaskPageFlag = nil
			end

			table.insert(var0_15, function(arg0_17)
				getProxy(FeastProxy):HandleTaskStories(var6_14, arg0_17)
			end)

			if #var0_15 > 0 then
				seriesAsync(var0_15)
			end
		end)
	elseif var0_14 == GAME.BEGIN_STAGE_DONE then
		arg0_14:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_14)
	elseif var0_14 == TaskProxy.WEEK_TASKS_ADDED or var0_14 == TaskProxy.WEEK_TASKS_DELETED or var0_14 == TaskProxy.WEEK_TASK_UPDATED then
		arg0_14.viewComponent:RefreshWeekTaskPage()
	elseif var0_14 == GAME.SUBMIT_WEEK_TASK_DONE then
		arg0_14.viewComponent:RefreshWeekTaskPageBefore(var1_14.id)

		local function var9_14()
			arg0_14.viewComponent:RefreshWeekTaskPage()
		end

		if #var1_14.awards > 0 then
			arg0_14.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_14.awards, var9_14)
		else
			var9_14()
		end
	elseif var0_14 == GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE then
		local function var10_14()
			arg0_14.viewComponent:RefreshWeekTaskProgress()
		end

		if #var1_14.awards > 0 then
			arg0_14.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_14.awards, var10_14)
		else
			var10_14()
		end
	elseif var0_14 == GAME.SUBMIT_AVATAR_TASK_DONE or var0_14 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		local function var11_14()
			arg0_14.viewComponent:refreshPage()
		end

		if #var1_14.awards > 0 then
			if arg0_14.storeActivityAwardFlag then
				if not arg0_14.activityAwards then
					arg0_14.activityAwards = {}
				end

				for iter2_14, iter3_14 in ipairs(var1_14.awards) do
					table.insert(arg0_14.activityAwards, iter3_14)
				end
			else
				arg0_14:addAwardShow(var1_14.awards, var11_14)
			end
		else
			var11_14()
		end
	elseif var0_14 == TaskProxy.WEEK_TASK_RESET then
		arg0_14:SetTaskVOs()
		arg0_14.viewComponent:ResetWeekTaskPage()
	elseif var0_14 == GAME.MERGE_TASK_ONE_STEP_AWARD_DONE then
		arg0_14.refreshWeekTaskPageFlag = true

		arg0_14:sendNotification(GAME.SUBMIT_TASK_DONE, var1_14.awards, var1_14.taskIds)
	elseif var0_14 == AvatarFrameProxy.FRAME_TASK_TIME_OUT then
		arg0_14.viewComponent:refreshPage()
	end
end

function var0_0.addAwardShow(arg0_21, arg1_21, arg2_21)
	if not arg1_21 or #arg1_21 == 0 then
		return
	end

	if not arg0_21.awardsShowList then
		arg0_21.awardsShowList = {}
	end

	table.insert(arg0_21.awardsShowList, {
		awards = arg1_21,
		callback = arg2_21
	})

	if arg0_21.isShowAwardFlag then
		return
	else
		arg0_21:showAwardList()
	end
end

function var0_0.showAwardList(arg0_22)
	if arg0_22.isShowAwardFlag then
		return
	end

	if arg0_22.awardsShowList and #arg0_22.awardsShowList > 0 then
		arg0_22.isShowAwardFlag = true

		local var0_22 = table.remove(arg0_22.awardsShowList, 1)

		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_22.awards, function()
			if var0_22.callback then
				var0_22.callback()
			end

			arg0_22.isShowAwardFlag = false

			arg0_22:showAwardList()
		end)
	end
end

function var0_0.accepetActivityTask(arg0_24)
	arg0_24:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
end

function var0_0.PlayStoryForTaskAct(arg0_25, arg1_25, arg2_25)
	local var0_25 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST)
	local var1_25

	for iter0_25, iter1_25 in ipairs(var0_25) do
		if iter1_25 and not iter1_25:isEnd() then
			local var2_25 = iter1_25:getConfig("config_data")
			local var3_25 = 0
			local var4_25 = 0

			for iter2_25, iter3_25 in ipairs(var2_25) do
				for iter4_25, iter5_25 in ipairs(iter3_25) do
					if iter5_25 == arg1_25 then
						var3_25 = iter2_25
						var4_25 = iter4_25
					end
				end
			end

			local var5_25 = iter1_25:getConfig("config_client").story or {}

			if var5_25[var3_25] then
				local var6_25 = var5_25[var3_25][var4_25]

				if var6_25 and not pg.NewStoryMgr.GetInstance():IsPlayed(var6_25) then
					var1_25 = var6_25
				end
			end
		end
	end

	if var1_25 then
		pg.NewStoryMgr.GetInstance():Play(var1_25, arg2_25)
	else
		arg2_25()
	end
end

return var0_0

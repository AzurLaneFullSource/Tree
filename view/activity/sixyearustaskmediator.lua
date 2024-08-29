local var0_0 = class("SixYearUsTaskMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "event on task go"
var0_0.ON_TASK_SUBMIT = "event on task submit"
var0_0.ON_TASK_SUBMIT_ONESTEP = "event on task submit one step"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3, arg2_3)
		seriesAsync({
			function(arg0_4)
				arg0_1:settleTownGold({
					arg1_3.id
				}, arg0_4)
			end,
			function(arg0_5)
				arg0_1.awardIndex = 0
				arg0_1.showAwards = {}

				arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
					act_id = arg1_3:getActId(),
					task_ids = {
						arg1_3.id
					}
				}, arg2_3)
			end
		}, function()
			return
		end)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_7, arg1_7)
		seriesAsync({
			function(arg0_8)
				arg0_1:settleTownGold(arg1_7, arg0_8)
			end,
			function(arg0_9)
				local var0_9 = arg0_1:getSubmitDatas(arg1_7)

				arg0_1.awardIndex = 0
				arg0_1.showAwards = {}

				for iter0_9, iter1_9 in pairs(var0_9) do
					arg0_1.awardIndex = arg0_1.awardIndex + 1

					arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
						act_id = iter0_9,
						task_ids = iter1_9
					})
				end
			end
		}, function()
			return
		end)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN)

	if not var0_1 or var0_1:isEnd() then
		assert(nil, "not exist act")

		return
	end

	arg0_1.townActId = var0_1.id
end

function var0_0.isSubmitTownGoldTask(arg0_11, arg1_11)
	local var0_11 = pg.task_data_template[arg1_11]

	return var0_11.sub_type == 1006 and var0_11.target_id == "1004"
end

function var0_0.settleTownGold(arg0_12, arg1_12, arg2_12)
	if underscore.any(arg1_12, function(arg0_13)
		return arg0_12:isSubmitTownGoldTask(arg0_13)
	end) then
		arg0_12:sendNotification(GAME.ACTIVITY_TOWN_OP, {
			activity_id = arg0_12.townActId,
			cmd = TownActivity.OPERATION.SETTLE_GOLD,
			callback = arg2_12
		})
	else
		arg2_12()
	end
end

function var0_0.listNotificationInterests(arg0_14)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_15, arg1_15)
	local var0_15 = arg1_15:getName()
	local var1_15 = arg1_15:getBody()

	if var0_15 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		if arg0_15.awardIndex > 0 then
			arg0_15.awardIndex = arg0_15.awardIndex - 1
		end

		for iter0_15, iter1_15 in ipairs(var1_15.awards) do
			table.insert(arg0_15.showAwards, iter1_15)
		end

		if arg0_15.awardIndex == 0 then
			arg0_15.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_15.showAwards, function()
				arg0_15.viewComponent:Show()
			end)

			arg0_15.showAwards = {}
		end
	elseif var0_15 == GAME.ACTIVITY_UPDATED then
		arg0_15.viewComponent:Show()
	end
end

function var0_0.getSubmitDatas(arg0_17, arg1_17)
	local var0_17 = getProxy(TaskProxy)
	local var1_17 = {}

	for iter0_17 = 1, #arg1_17 do
		local var2_17 = arg1_17[iter0_17]
		local var3_17 = var0_17:getTaskById(var2_17)

		if var3_17 and var3_17:getActId() then
			local var4_17 = var3_17:getActId()

			if not var1_17[var4_17] then
				var1_17[var4_17] = {}
			end

			table.insert(var1_17[var4_17], var2_17)
		end
	end

	return var1_17
end

function var0_0.GetTaskRedTip()
	local var0_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.SIX_YEAR_US_TASK_ACT_ID)
	local var1_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.SIX_YEAR_US_TASK_2_ACT_ID)

	if var0_18 and not var0_18:isEnd() then
		local var2_18 = var0_18:getConfig("config_data")

		for iter0_18, iter1_18 in pairs(var2_18) do
			local var3_18 = getProxy(TaskProxy):getTaskVO(iter1_18)

			if var3_18 and var3_18:getTaskStatus() == 1 then
				return true
			end
		end
	end

	if var1_18 and not var1_18:isEnd() then
		local var4_18 = var1_18:getConfig("config_data")

		for iter2_18, iter3_18 in pairs(var4_18) do
			local var5_18 = getProxy(TaskProxy):getTaskVO(iter3_18)

			if var5_18 and var5_18:getTaskStatus() == 1 then
				return true
			end
		end
	end

	return false
end

return var0_0

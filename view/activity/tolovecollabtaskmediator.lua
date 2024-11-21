local var0_0 = class("ToLoveCollabTaskMediator", import("view.base.ContextMediator"))

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
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_6, arg1_6)
		seriesAsync({
			function(arg0_7)
				local var0_7 = arg0_1:getSubmitDatas(arg1_6)

				arg0_1.awardIndex = 0
				arg0_1.showAwards = {}

				for iter0_7, iter1_7 in pairs(var0_7) do
					arg0_1.awardIndex = arg0_1.awardIndex + 1

					arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
						act_id = iter0_7,
						task_ids = iter1_7
					})
				end
			end
		}, function()
			return
		end)
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		if arg0_10.awardIndex > 0 then
			arg0_10.awardIndex = arg0_10.awardIndex - 1
		end

		for iter0_10, iter1_10 in ipairs(var1_10.awards) do
			table.insert(arg0_10.showAwards, iter1_10)
		end

		if arg0_10.awardIndex == 0 then
			arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_10.showAwards, function()
				arg0_10.viewComponent:Show()
			end)

			arg0_10.showAwards = {}
		end
	elseif var0_10 == GAME.ACTIVITY_UPDATED then
		arg0_10.viewComponent:Show()
	end
end

function var0_0.getSubmitDatas(arg0_12, arg1_12)
	local var0_12 = getProxy(TaskProxy)
	local var1_12 = {}

	for iter0_12 = 1, #arg1_12 do
		local var2_12 = arg1_12[iter0_12]
		local var3_12 = var0_12:getTaskById(var2_12)

		if var3_12 and var3_12:getActId() then
			local var4_12 = var3_12:getActId()

			if not var1_12[var4_12] then
				var1_12[var4_12] = {}
			end

			table.insert(var1_12[var4_12], var2_12)
		end
	end

	return var1_12
end

function var0_0.GetTaskRedTip()
	local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.TOLOVE_TASK_ID)

	if var0_13 and not var0_13:isEnd() then
		local var1_13 = var0_13:getConfig("config_data")

		for iter0_13, iter1_13 in pairs(var1_13) do
			local var2_13 = getProxy(TaskProxy):getTaskVO(iter1_13)

			if var2_13 and var2_13:getTaskStatus() == 1 then
				return true
			end
		end
	end

	return false
end

return var0_0

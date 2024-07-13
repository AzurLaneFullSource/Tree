local var0_0 = class("SenrankaguraMedalMediator", import("..base.ContextMediator"))

var0_0.SUBMIT_TASK_ALL = "activity submit task all"
var0_0.SUBMIT_TASK = "activity submit task "
var0_0.TASK_GO = "task go "

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_2, arg1_2)
		arg0_1.displayAwards = {}

		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2, function(arg0_3)
			if not arg0_3 then
				-- block empty
			end
		end)
	end)
	arg0_1:bind(var0_0.SUBMIT_TASK_ALL, function(arg0_4, arg1_4)
		local var0_4 = getProxy(TaskProxy)
		local var1_4 = false
		local var2_4 = {}

		for iter0_4 = 1, #arg1_4 do
			local var3_4 = var0_4:getTaskById(arg1_4[iter0_4])

			table.insert(var2_4, var3_4)

			if not var3_4 then
				return
			end

			if not var1_4 and var3_4:IsOverflowShipExpItem() then
				var1_4 = true

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_fullBag"),
					onYes = function()
						arg0_1.displayAwards = {}

						arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
							resultList = var2_4
						})
					end,
					onNo = function()
						return
					end
				})
			end
		end

		if not var1_4 then
			arg0_1.displayAwards = {}

			arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
				resultList = var2_4
			})
		end
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_7
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.MEMORYBOOK_UNLOCK_DONE,
		GAME.MEMORYBOOK_UNLOCK_AWARD_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.SUBMIT_TASK_DONE then
		if #var1_9 > 0 then
			for iter0_9 = 1, #var1_9 do
				if var1_9[iter0_9].configId == arg0_9.viewComponent.ptId then
					-- block empty
				else
					table.insert(arg0_9.displayAwards, var1_9[iter0_9])
				end
			end
		end

		arg0_9:checkShowTaskAward()
	elseif var0_9 == GAME.ACTIVITY_UPDATED then
		-- block empty
	elseif var0_9 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0_9.viewComponent:updateUI()
	elseif var0_9 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards, var1_9.callback)
		arg0_9.viewComponent:updateUI()
	elseif var0_9 == GAME.MEMORYBOOK_UNLOCK_AWARD_DONE then
		-- block empty
	end
end

function var0_0.checkShowTaskAward(arg0_10)
	if #arg0_10.displayAwards > 0 then
		arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_10.displayAwards)
	end

	arg0_10.viewComponent:updateUI()

	arg0_10.displayAwards = {}
end

return var0_0

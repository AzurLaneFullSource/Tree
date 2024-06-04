local var0 = class("SenrankaguraMedalMediator", import("..base.ContextMediator"))

var0.SUBMIT_TASK_ALL = "activity submit task all"
var0.SUBMIT_TASK = "activity submit task "
var0.TASK_GO = "task go "

function var0.register(arg0)
	arg0:bind(var0.SUBMIT_TASK, function(arg0, arg1)
		arg0.displayAwards = {}

		arg0:sendNotification(GAME.SUBMIT_TASK, arg1, function(arg0)
			if not arg0 then
				-- block empty
			end
		end)
	end)
	arg0:bind(var0.SUBMIT_TASK_ALL, function(arg0, arg1)
		local var0 = getProxy(TaskProxy)
		local var1 = false
		local var2 = {}

		for iter0 = 1, #arg1 do
			local var3 = var0:getTaskById(arg1[iter0])

			table.insert(var2, var3)

			if not var3 then
				return
			end

			if not var1 and var3:IsOverflowShipExpItem() then
				var1 = true

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_fullBag"),
					onYes = function()
						arg0.displayAwards = {}

						arg0:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
							resultList = var2
						})
					end,
					onNo = function()
						return
					end
				})
			end
		end

		if not var1 then
			arg0.displayAwards = {}

			arg0:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
				resultList = var2
			})
		end
	end)
	arg0:bind(var0.TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.MEMORYBOOK_UNLOCK_DONE,
		GAME.MEMORYBOOK_UNLOCK_AWARD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_TASK_DONE then
		if #var1 > 0 then
			for iter0 = 1, #var1 do
				if var1[iter0].configId == arg0.viewComponent.ptId then
					-- block empty
				else
					table.insert(arg0.displayAwards, var1[iter0])
				end
			end
		end

		arg0:checkShowTaskAward()
	elseif var0 == GAME.ACTIVITY_UPDATED then
		-- block empty
	elseif var0 == GAME.MEMORYBOOK_UNLOCK_DONE then
		arg0.viewComponent:updateUI()
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
		arg0.viewComponent:updateUI()
	elseif var0 == GAME.MEMORYBOOK_UNLOCK_AWARD_DONE then
		-- block empty
	end
end

function var0.checkShowTaskAward(arg0)
	if #arg0.displayAwards > 0 then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0.displayAwards)
	end

	arg0.viewComponent:updateUI()

	arg0.displayAwards = {}
end

return var0

local var0_0 = class("CommanderManualMediator", import("..base.ContextMediator"))

var0_0.ON_TASK_GO = "CommanderManualMediator.ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "CommanderManualMediator.ON_TASK_SUBMIT"
var0_0.GET_PT_AWARD = "CommanderManualMediator.GET_PT_AWARD"
var0_0.ON_TRIGGER = "CommanderManualMediator.ON_TRIGGER"
var0_0.ON_UPDATE = "CommanderManualMediator.ON_UPDATE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, {
			virtual = false,
			normal_submit = true,
			taskId = arg1_3.id
		}, arg2_3)
	end)
	arg0_1:bind(var0_0.GET_PT_AWARD, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.COMMANDER_MANUAL_OP, {
			operation = CommanderManualProxy.GET_PT_AWARD,
			pageId = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_TRIGGER, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_5)
	end)
	arg0_1:bind(var0_0.ON_UPDATE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
			taskId = arg1_6.id
		})
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.SUBMIT_TASK_DONE,
		GAME.COMMANDER_MANUAL_OP_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()
	local var2_8 = arg1_8:getType()

	if var0_8 == GAME.SUBMIT_TASK_DONE then
		if #var1_8 > 0 then
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8)
		end

		if arg0_8.viewComponent.contextData.currentPageId then
			local var3_8 = var2_8[1]
			local var4_8 = getProxy(CommanderManualProxy):GetPageById(arg0_8.viewComponent.contextData.currentPageId)

			if table.contains(var4_8.taskIdList, var3_8) then
				var4_8:AddFinishedTaskId(var3_8)
				var4_8:AddPt()
			end
		end

		arg0_8.viewComponent:RefreshAll()
	elseif var0_8 == GAME.COMMANDER_MANUAL_OP_DONE then
		if var1_8.operation == CommanderManualProxy.GET_TASK then
			-- block empty
		elseif var1_8.operation == CommanderManualProxy.GET_PT_AWARD then
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
		end

		arg0_8.viewComponent:RefreshAll()
	elseif var0_8 == ActivityProxy.ACTIVITY_OPERATION_DONE and var1_8 == arg0_8.viewComponent.techActivity.id then
		arg0_8.viewComponent:UpdateTechActivity()

		if isActive(arg0_8.viewComponent.techPage) then
			arg0_8.viewComponent:ShowTechPage()
		end
	end
end

return var0_0

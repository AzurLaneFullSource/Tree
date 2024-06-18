local var0_0 = class("RefluxMediator", import("..base.ContextMediator"))

var0_0.OnTaskSubmit = "RefluxMediator.OnTaskSubmit"
var0_0.OnTaskGo = "RefluxMediator.OnTaskGo"
var0_0.OPEN_CHARGE_ITEM_PANEL = "RefluxMediator:OPEN_CHARGE_ITEM_PANEL"
var0_0.OPEN_CHARGE_ITEM_BOX = "RefluxMediator:OPEN_CHARGE_ITEM_BOX"
var0_0.OPEN_CHARGE_BIRTHDAY = "RefluxMediator:OPEN_CHARGE_BIRTHDAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnTaskSubmit, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2)
	end)
	arg0_1:bind(var0_0.OnTaskGo, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_BOX, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemBoxMediator,
			viewComponent = ChargeItemBoxLayer,
			data = {
				panelConfig = arg1_5
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.REFLUX_SIGN_DONE,
		GAME.SUBMIT_TASK_DONE,
		GAME.REFLUX_GET_PT_AWARD_DONE,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SHOPPING_DONE,
		GAME.CHARGE_CONFIRM_FAILED,
		GAME.CHARGED_LIST_UPDATED,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.REFLUX_SIGN_DONE then
		if arg0_8:isCanUpdateView(arg0_8.viewComponent.signView) then
			arg0_8.viewComponent.signView:updateUI()
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
		end

		arg0_8.viewComponent:updateRedPotList()
	elseif var0_8 == GAME.SUBMIT_TASK_DONE then
		if arg0_8:isCanUpdateView(arg0_8.viewComponent.taskView) and #var1_8 > 0 then
			local var2_8 = arg0_8.viewComponent.taskView:calcLastSubmitTaskPT()

			table.insert(var1_8, var2_8)
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8)
		end

		if arg0_8:isCanUpdateView(arg0_8.viewComponent.ptView) then
			arg0_8.viewComponent.ptView:updateUI()
		end

		arg0_8.viewComponent:updateRedPotList()
	elseif var0_8 == TaskProxy.TASK_UPDATED or var0_8 == TaskProxy.TASK_REMOVED then
		if arg0_8:isCanUpdateView(arg0_8.viewComponent.taskView) then
			arg0_8.viewComponent.taskView:updateUI()
		end

		arg0_8.viewComponent:updateRedPotList()
	elseif var0_8 == GAME.REFLUX_GET_PT_AWARD_DONE then
		if arg0_8:isCanUpdateView(arg0_8.viewComponent.ptView) then
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
			arg0_8.viewComponent.ptView:updateAfterServer()
		end

		arg0_8.viewComponent:updateRedPotList()
	elseif var0_8 == GAME.SHOPPING_DONE then
		if arg0_8:isCanUpdateView(arg0_8.viewComponent.shopView) then
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
			arg0_8.viewComponent.shopView:updateUI()
		end
	elseif var0_8 == GAME.CHARGE_CONFIRM_FAILED then
		-- block empty
	elseif var0_8 == GAME.CHARGED_LIST_UPDATED then
		if arg0_8:isCanUpdateView(arg0_8.viewComponent.shopView) then
			arg0_8.viewComponent.shopView:updateUI()
		end
	elseif var0_8 == GAME.ZERO_HOUR_OP_DONE then
		arg0_8.viewComponent:closeView()
	end
end

function var0_0.isCanUpdateView(arg0_9, arg1_9)
	if arg1_9 and arg1_9:GetLoaded() then
		return true
	else
		return false
	end
end

return var0_0

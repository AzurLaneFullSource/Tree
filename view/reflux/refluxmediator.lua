local var0 = class("RefluxMediator", import("..base.ContextMediator"))

var0.OnTaskSubmit = "RefluxMediator.OnTaskSubmit"
var0.OnTaskGo = "RefluxMediator.OnTaskGo"
var0.OPEN_CHARGE_ITEM_PANEL = "RefluxMediator:OPEN_CHARGE_ITEM_PANEL"
var0.OPEN_CHARGE_ITEM_BOX = "RefluxMediator:OPEN_CHARGE_ITEM_BOX"
var0.OPEN_CHARGE_BIRTHDAY = "RefluxMediator:OPEN_CHARGE_BIRTHDAY"

function var0.register(arg0)
	arg0:bind(var0.OnTaskSubmit, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(var0.OnTaskGo, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.OPEN_CHARGE_ITEM_PANEL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_CHARGE_ITEM_BOX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemBoxMediator,
			viewComponent = ChargeItemBoxLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_CHARGE_BIRTHDAY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.REFLUX_SIGN_DONE then
		if arg0:isCanUpdateView(arg0.viewComponent.signView) then
			arg0.viewComponent.signView:updateUI()
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end

		arg0.viewComponent:updateRedPotList()
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		if arg0:isCanUpdateView(arg0.viewComponent.taskView) and #var1 > 0 then
			local var2 = arg0.viewComponent.taskView:calcLastSubmitTaskPT()

			table.insert(var1, var2)
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
		end

		if arg0:isCanUpdateView(arg0.viewComponent.ptView) then
			arg0.viewComponent.ptView:updateUI()
		end

		arg0.viewComponent:updateRedPotList()
	elseif var0 == TaskProxy.TASK_UPDATED or var0 == TaskProxy.TASK_REMOVED then
		if arg0:isCanUpdateView(arg0.viewComponent.taskView) then
			arg0.viewComponent.taskView:updateUI()
		end

		arg0.viewComponent:updateRedPotList()
	elseif var0 == GAME.REFLUX_GET_PT_AWARD_DONE then
		if arg0:isCanUpdateView(arg0.viewComponent.ptView) then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
			arg0.viewComponent.ptView:updateAfterServer()
		end

		arg0.viewComponent:updateRedPotList()
	elseif var0 == GAME.SHOPPING_DONE then
		if arg0:isCanUpdateView(arg0.viewComponent.shopView) then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
			arg0.viewComponent.shopView:updateUI()
		end
	elseif var0 == GAME.CHARGE_CONFIRM_FAILED then
		-- block empty
	elseif var0 == GAME.CHARGED_LIST_UPDATED then
		if arg0:isCanUpdateView(arg0.viewComponent.shopView) then
			arg0.viewComponent.shopView:updateUI()
		end
	elseif var0 == GAME.ZERO_HOUR_OP_DONE then
		arg0.viewComponent:closeView()
	end
end

function var0.isCanUpdateView(arg0, arg1)
	if arg1 and arg1:GetLoaded() then
		return true
	else
		return false
	end
end

return var0

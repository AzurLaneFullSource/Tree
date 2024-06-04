local var0 = class("CrusingTaskMediator", import("view.base.ContextMediator"))

var0.ON_TASK_GO = "CrusingTaskMediator.ON_TASK_GO"
var0.ON_TASK_SUBMIT = "CrusingTaskMediator.ON_TASK_SUBMIT"
var0.ON_TASK_QUICK_SUBMIT = "CrusingTaskMediator.ON_TASK_QUICK_SUBMIT"
var0.ON_BUY_QUICK_TASK_ITEM = "CrusingTaskMediator.ON_BUY_QUICK_TASK_ITEM"
var0.ON_EXIT = "CrusingTaskMediator.ON_EXIT"
var0.quickTaskGoodId = 61017

function var0.register(arg0)
	arg0:bind(var0.ON_TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)
	arg0:bind(var0.ON_TASK_QUICK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.QUICK_TASK, arg1.id)
	end)
	arg0:bind(var0.ON_BUY_QUICK_TASK_ITEM, function(arg0, arg1)
		arg0:sendNotification(GAME.SHOPPING, {
			id = var0.quickTaskGoodId,
			count = arg1
		})
	end)
	arg0:bind(var0.ON_EXIT, function(arg0)
		arg0:sendNotification(CrusingMediator.UNFROZEN_MAP_UPDATE)
	end)

	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	arg0.viewComponent:setActivity(var0)
	updateCrusingActivityTask(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		BagProxy.ITEM_UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == arg0.viewComponent.activity.id then
			arg0.viewComponent:setActivity(var1)

			if arg0.viewComponent.phase == #arg0.viewComponent.awardList then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_complete"))
				arg0.viewComponent:closeView()
			else
				arg0.viewComponent:updatePhaseInfo()
			end
		end
	elseif var0 == BagProxy.ITEM_UPDATED then
		if var1.id == Item.QUICK_TASK_PASS_TICKET_ID then
			arg0.viewComponent:updateItemInfo()
		end
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		local var3 = {}

		for iter0, iter1 in ipairs(var2) do
			var3[iter1] = true
		end

		if underscore.any(arg0.viewComponent.tempTaskGroup, function(arg0)
			return underscore.any(arg0, function(arg0)
				return var3[arg0.id]
			end)
		end) then
			arg0.viewComponent:updateCurrentTaskGroup()
		end
	end
end

return var0

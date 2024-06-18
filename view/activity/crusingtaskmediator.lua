local var0_0 = class("CrusingTaskMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "CrusingTaskMediator.ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "CrusingTaskMediator.ON_TASK_SUBMIT"
var0_0.ON_TASK_QUICK_SUBMIT = "CrusingTaskMediator.ON_TASK_QUICK_SUBMIT"
var0_0.ON_BUY_QUICK_TASK_ITEM = "CrusingTaskMediator.ON_BUY_QUICK_TASK_ITEM"
var0_0.ON_EXIT = "CrusingTaskMediator.ON_EXIT"
var0_0.quickTaskGoodId = 61017

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3.id)
	end)
	arg0_1:bind(var0_0.ON_TASK_QUICK_SUBMIT, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.QUICK_TASK, arg1_4.id)
	end)
	arg0_1:bind(var0_0.ON_BUY_QUICK_TASK_ITEM, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = var0_0.quickTaskGoodId,
			count = arg1_5
		})
	end)
	arg0_1:bind(var0_0.ON_EXIT, function(arg0_6)
		arg0_1:sendNotification(CrusingMediator.UNFROZEN_MAP_UPDATE)
	end)

	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	arg0_1.viewComponent:setActivity(var0_1)
	updateCrusingActivityTask(var0_1)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		BagProxy.ITEM_UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()
	local var2_8 = arg1_8:getType()

	if var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_8.id == arg0_8.viewComponent.activity.id then
			arg0_8.viewComponent:setActivity(var1_8)

			if arg0_8.viewComponent.phase == #arg0_8.viewComponent.awardList then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_complete"))
				arg0_8.viewComponent:closeView()
			else
				arg0_8.viewComponent:updatePhaseInfo()
			end
		end
	elseif var0_8 == BagProxy.ITEM_UPDATED then
		if var1_8.id == Item.QUICK_TASK_PASS_TICKET_ID then
			arg0_8.viewComponent:updateItemInfo()
		end
	elseif var0_8 == GAME.SUBMIT_TASK_DONE then
		local var3_8 = {}

		for iter0_8, iter1_8 in ipairs(var2_8) do
			var3_8[iter1_8] = true
		end

		if underscore.any(arg0_8.viewComponent.tempTaskGroup, function(arg0_9)
			return underscore.any(arg0_9, function(arg0_10)
				return var3_8[arg0_10.id]
			end)
		end) then
			arg0_8.viewComponent:updateCurrentTaskGroup()
		end
	end
end

return var0_0

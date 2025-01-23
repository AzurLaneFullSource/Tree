local var0_0 = class("NewEducateScheduleMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_SELECTED_PLANS = "NewEducateScheduleMediator.ON_SELECTED_PLANS"
var0_0.ON_UPGRADE_PLANS = "NewEducateScheduleMediator.ON_UPGRADE_PLANS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SELECTED_PLANS, function(arg0_2, arg1_2, arg2_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg2_2) do
			if iter1_2.plan then
				table.insert(var0_2, {
					key = iter0_2,
					value = iter1_2.plan.id
				})
			end
		end

		arg0_1:sendNotification(GAME.NEW_EDUCATE_SCHEDULE, {
			id = arg0_1.contextData.char.id,
			planKVs = var0_2,
			isSkip = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_PLANS, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_PLAN, {
			id = arg0_1.contextData.char.id,
			planIds = arg1_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.NEW_EDUCATE_UPGRADE_PLAN_DONE,
		GAME.NEW_EDUCATE_SCHEDULE_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.NEW_EDUCATE_UPGRADE_PLAN_DONE then
		arg0_5.viewComponent:OnUpgradePlans()
	elseif var0_5 == GAME.NEW_EDUCATE_SCHEDULE_DONE then
		arg0_5.viewComponent:SetScheduleData(var1_5)
		arg0_5.viewComponent:closeView()
	end
end

return var0_0

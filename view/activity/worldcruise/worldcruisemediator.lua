local var0_0 = class("WorldCruiseMediator", import("view.base.ContextMediator"))

var0_0.EVENT_GET_AWARD = "WorldCruiseMediator.EVENT_GET_AWARD"
var0_0.EVENT_GET_AWARD_PAY = "WorldCruiseMediator.EVENT_GET_AWARD_PAY"
var0_0.EVENT_GET_AWARD_ALL = "WorldCruiseMediator.EVENT_GET_AWARD_ALL"
var0_0.EVENT_OPEN_BIRTHDAY = "WorldCruiseMediator.EVENT_OPEN_BIRTHDAY"
var0_0.ON_TASK_GO = "WorldCruiseMediator.ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "WorldCruiseMediator.ON_TASK_SUBMIT"
var0_0.ON_TASK_QUICK_SUBMIT = "WorldCruiseMediator.ON_TASK_QUICK_SUBMIT"
var0_0.ON_CRUISE_SHOPPING = "WorldCruiseMediator.ON_CRUISE_SHOPPING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_GET_AWARD, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 2,
			activity_id = arg0_1.viewComponent.activity.id,
			arg1 = arg1_2
		})
	end)
	arg0_1:bind(var0_0.EVENT_GET_AWARD_PAY, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 3,
			activity_id = arg0_1.viewComponent.activity.id,
			arg1 = arg1_3
		})
	end)
	arg0_1:bind(var0_0.EVENT_GET_AWARD_ALL, function(arg0_4)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 4,
			activity_id = arg0_1.viewComponent.activity.id
		})
	end)
	arg0_1:bind(var0_0.EVENT_OPEN_BIRTHDAY, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_6
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_7.id)
	end)
	arg0_1:bind(var0_0.ON_TASK_QUICK_SUBMIT, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.QUICK_TASK, arg1_8.id)
	end)
	arg0_1:bind(var0_0.ON_CRUISE_SHOPPING, function(arg0_9, arg1_9, arg2_9)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_9,
			count = arg2_9
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.CRUSING_CMD_DONE,
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS,
		BagProxy.ITEM_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		GAME.SHOPPING_DONE,
		ShopsProxy.CRUISE_SHOP_UPDATED
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_11.id == arg0_11.viewComponent.activity.id then
			arg0_11.viewComponent:setActivity(var1_11)
			arg0_11.viewComponent:UpdatePhase()
			arg0_11.viewComponent:UpdateAwardPage()
		end
	elseif var0_11 == GAME.CRUSING_CMD_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards)
		arg0_11.viewComponent:UpdateAwardPage()
	elseif var0_11 == PlayerProxy.UPDATED then
		arg0_11.viewComponent:setPlayer(var1_11)
		arg0_11.viewComponent:UpdateRes()
	elseif var0_11 == GAME.CHARGE_SUCCESS then
		local var2_11 = Goods.Create({
			shop_id = var1_11.shopId
		}, Goods.TYPE_CHARGE)

		arg0_11.viewComponent:OnChargeSuccess(var2_11)
		arg0_11.viewComponent:UpdateRes()
	elseif var0_11 == BagProxy.ITEM_UPDATED then
		if var1_11.id == Item.QUICK_TASK_PASS_TICKET_ID then
			arg0_11.viewComponent:UpdateRes()
		end
	elseif var0_11 == GAME.SUBMIT_TASK_DONE or var0_11 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_11.viewComponent:UpdateTaskPage()
	elseif var0_11 == GAME.SHOPPING_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards)
	elseif var0_11 == ShopsProxy.CRUISE_SHOP_UPDATED then
		arg0_11.viewComponent:setShop(var1_11.shop)
		arg0_11.viewComponent:UpdateShopPage()
	end
end

return var0_0

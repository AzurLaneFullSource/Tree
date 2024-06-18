local var0_0 = class("CrusingMediator", import("view.base.ContextMediator"))

var0_0.UNFROZEN_MAP_UPDATE = "CrusingMediator.UN_FROZEN_MAP_UPDATE"
var0_0.EVENT_OPEN_TASK = "CrusingMediator.EVENT_OPEN_TASK"
var0_0.EVENT_GET_AWARD = "CrusingMediator.EVENT_GET_AWARD"
var0_0.EVENT_GET_AWARD_PAY = "CrusingMediator.EVENT_GET_AWARD_PAY"
var0_0.EVENT_GET_AWARD_ALL = "CrusingMediator.EVENT_GET_AWARD_ALL"
var0_0.EVENT_GO_CHARGE = "CrusingMediator.EVENT_GO_CHARGE"
var0_0.EVENT_OPEN_BIRTHDAY = "CrusingMediator.EVENT_OPEN_BIRTHDAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_OPEN_TASK, function(arg0_2)
		arg0_1.contextData.frozenMapUpdate = true

		arg0_1:addSubLayers(Context.New({
			mediator = CrusingTaskMediator,
			viewComponent = CrusingTaskLayer
		}))
	end)
	arg0_1:bind(var0_0.EVENT_GET_AWARD, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 2,
			activity_id = arg0_1.viewComponent.activity.id,
			arg1 = arg1_3
		})
	end)
	arg0_1:bind(var0_0.EVENT_GET_AWARD_PAY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 3,
			activity_id = arg0_1.viewComponent.activity.id,
			arg1 = arg1_4
		})
	end)
	arg0_1:bind(var0_0.EVENT_GET_AWARD_ALL, function(arg0_5)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 4,
			activity_id = arg0_1.viewComponent.activity.id
		})
	end)
	arg0_1:bind(var0_0.EVENT_GO_CHARGE, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_6
			}
		}))
	end)
	arg0_1:bind(var0_0.EVENT_OPEN_BIRTHDAY, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)

	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.CRUSING_CMD_DONE,
		var0_0.UNFROZEN_MAP_UPDATE,
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_9.id == arg0_9.viewComponent.activity.id then
			arg0_9.viewComponent:setActivity(var1_9)
			arg0_9.viewComponent:updateAwardPanel()
			arg0_9.viewComponent:updateMapStatus()
			arg0_9.viewComponent:updateMapWay()
		end
	elseif var0_9 == GAME.CRUSING_CMD_DONE then
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards)
	elseif var0_9 == var0_0.UNFROZEN_MAP_UPDATE then
		arg0_9.contextData.frozenMapUpdate = false

		arg0_9.viewComponent:updateMapWay()
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:setPlayer(var1_9)
	elseif var0_9 == GAME.CHARGE_SUCCESS then
		local var2_9 = Goods.Create({
			shop_id = var1_9.shopId
		}, Goods.TYPE_CHARGE)

		arg0_9.viewComponent:OnChargeSuccess(var2_9)
	end
end

return var0_0

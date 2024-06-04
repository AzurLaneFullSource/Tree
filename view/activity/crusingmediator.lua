local var0 = class("CrusingMediator", import("view.base.ContextMediator"))

var0.UNFROZEN_MAP_UPDATE = "CrusingMediator.UN_FROZEN_MAP_UPDATE"
var0.EVENT_OPEN_TASK = "CrusingMediator.EVENT_OPEN_TASK"
var0.EVENT_GET_AWARD = "CrusingMediator.EVENT_GET_AWARD"
var0.EVENT_GET_AWARD_PAY = "CrusingMediator.EVENT_GET_AWARD_PAY"
var0.EVENT_GET_AWARD_ALL = "CrusingMediator.EVENT_GET_AWARD_ALL"
var0.EVENT_GO_CHARGE = "CrusingMediator.EVENT_GO_CHARGE"
var0.EVENT_OPEN_BIRTHDAY = "CrusingMediator.EVENT_OPEN_BIRTHDAY"

function var0.register(arg0)
	arg0:bind(var0.EVENT_OPEN_TASK, function(arg0)
		arg0.contextData.frozenMapUpdate = true

		arg0:addSubLayers(Context.New({
			mediator = CrusingTaskMediator,
			viewComponent = CrusingTaskLayer
		}))
	end)
	arg0:bind(var0.EVENT_GET_AWARD, function(arg0, arg1)
		arg0:sendNotification(GAME.CRUSING_CMD, {
			cmd = 2,
			activity_id = arg0.viewComponent.activity.id,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.EVENT_GET_AWARD_PAY, function(arg0, arg1)
		arg0:sendNotification(GAME.CRUSING_CMD, {
			cmd = 3,
			activity_id = arg0.viewComponent.activity.id,
			arg1 = arg1
		})
	end)
	arg0:bind(var0.EVENT_GET_AWARD_ALL, function(arg0)
		arg0:sendNotification(GAME.CRUSING_CMD, {
			cmd = 4,
			activity_id = arg0.viewComponent.activity.id
		})
	end)
	arg0:bind(var0.EVENT_GO_CHARGE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.EVENT_OPEN_BIRTHDAY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)

	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	arg0.viewComponent:setActivity(var0)
	arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.CRUSING_CMD_DONE,
		var0.UNFROZEN_MAP_UPDATE,
		PlayerProxy.UPDATED,
		GAME.CHARGE_SUCCESS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1.id == arg0.viewComponent.activity.id then
			arg0.viewComponent:setActivity(var1)
			arg0.viewComponent:updateAwardPanel()
			arg0.viewComponent:updateMapStatus()
			arg0.viewComponent:updateMapWay()
		end
	elseif var0 == GAME.CRUSING_CMD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == var0.UNFROZEN_MAP_UPDATE then
		arg0.contextData.frozenMapUpdate = false

		arg0.viewComponent:updateMapWay()
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.CHARGE_SUCCESS then
		local var2 = Goods.Create({
			shop_id = var1.shopId
		}, Goods.TYPE_CHARGE)

		arg0.viewComponent:OnChargeSuccess(var2)
	end
end

return var0

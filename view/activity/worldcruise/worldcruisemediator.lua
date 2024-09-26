local var0_0 = class("WorldCruiseMediator", import("view.base.ContextMediator"))

var0_0.EVENT_GET_AWARD = "WorldCruiseMediator.EVENT_GET_AWARD"
var0_0.EVENT_GET_AWARD_PAY = "WorldCruiseMediator.EVENT_GET_AWARD_PAY"
var0_0.EVENT_GET_AWARD_ALL = "WorldCruiseMediator.EVENT_GET_AWARD_ALL"
var0_0.EVENT_GO_CHARGE = "WorldCruiseMediator.EVENT_GO_CHARGE"
var0_0.EVENT_OPEN_BIRTHDAY = "WorldCruiseMediator.EVENT_OPEN_BIRTHDAY"
var0_0.quickTaskGoodId = 61017
var0_0.ON_TASK_GO = "WorldCruiseMediator.ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "WorldCruiseMediator.ON_TASK_SUBMIT"
var0_0.ON_TASK_QUICK_SUBMIT = "WorldCruiseMediator.ON_TASK_QUICK_SUBMIT"
var0_0.ON_BUY_QUICK_TASK_ITEM = "WorldCruiseMediator.ON_BUY_QUICK_TASK_ITEM"
var0_0.ON_CRUISE_SHOPPING = "WorldCruiseMediator.ON_CRUISE_SHOPPING"
var0_0.ON_ESKIN_PREVIEW = "NewShopsMediator:ON_ESKIN_PREVIEW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ESKIN_PREVIEW, function(arg0_2, arg1_2)
		local var0_2 = pg.equip_skin_template[arg1_2]
		local var1_2 = Ship.New({
			id = var0_2.ship_config_id,
			configId = var0_2.ship_config_id,
			skin_id = var0_2.ship_skin_id
		})
		local var2_2 = {}

		if var0_2.ship_skin_id ~= 0 then
			var2_2 = {
				equipSkinId = 0,
				shipVO = var1_2,
				weaponIds = {},
				weight = arg0_1.contextData.weight and arg0_1.contextData.weight + 1
			}
		else
			var2_2 = {
				shipVO = var1_2,
				weaponIds = Clone(var0_2.weapon_ids),
				equipSkinId = arg1_2,
				weight = arg0_1.contextData.weight and arg0_1.contextData.weight + 1
			}
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = ShipPreviewLayer,
			mediator = ShipPreviewMediator,
			data = var2_2
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
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_8
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_9.id)
	end)
	arg0_1:bind(var0_0.ON_TASK_QUICK_SUBMIT, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.QUICK_TASK, arg1_10.id)
	end)
	arg0_1:bind(var0_0.ON_BUY_QUICK_TASK_ITEM, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = var0_0.quickTaskGoodId,
			count = arg1_11
		})
	end)
	arg0_1:bind(var0_0.ON_CRUISE_SHOPPING, function(arg0_12, arg1_12, arg2_12)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_12,
			count = arg2_12
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

function var0_0.listNotificationInterests(arg0_13)
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

function var0_0.handleNotification(arg0_14, arg1_14)
	local var0_14 = arg1_14:getName()
	local var1_14 = arg1_14:getBody()

	if var0_14 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_14.id == arg0_14.viewComponent.activity.id then
			arg0_14.viewComponent:setActivity(var1_14)
			arg0_14.viewComponent:UpdatePhase()
			arg0_14.viewComponent:UpdateAwardPage()
		end
	elseif var0_14 == GAME.CRUSING_CMD_DONE then
		arg0_14.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_14.awards)
		arg0_14.viewComponent:UpdateAwardPage()
	elseif var0_14 == PlayerProxy.UPDATED then
		arg0_14.viewComponent:setPlayer(var1_14)
		arg0_14.viewComponent:UpdateRes()
	elseif var0_14 == GAME.CHARGE_SUCCESS then
		local var2_14 = Goods.Create({
			shop_id = var1_14.shopId
		}, Goods.TYPE_CHARGE)

		arg0_14.viewComponent:OnChargeSuccess(var2_14)
		arg0_14.viewComponent:UpdateRes()
	elseif var0_14 == BagProxy.ITEM_UPDATED then
		if var1_14.id == Item.QUICK_TASK_PASS_TICKET_ID then
			arg0_14.viewComponent:UpdateRes()
		end
	elseif var0_14 == GAME.SUBMIT_TASK_DONE or var0_14 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_14.viewComponent:UpdateTaskPage()
	elseif var0_14 == GAME.SHOPPING_DONE then
		arg0_14.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_14.awards)
	elseif var0_14 == ShopsProxy.CRUISE_SHOP_UPDATED then
		arg0_14.viewComponent:setShop(var1_14.shop)
		arg0_14.viewComponent:UpdateShopPage()
	end
end

return var0_0

local var0_0 = class("BlackFridaySalesMediator", import("...base.ContextMediator"))

var0_0.TASK_GO = "BlackFridaySalesMediator.TASK_GO"
var0_0.TASK_SUBMIT = "BlackFridaySalesMediator.TASK_SUBMIT"
var0_0.TASK_SUBMIT_ONESTEP = "BlackFridaySalesMediator.TASK_SUBMIT_ONESTEP"
var0_0.GIFT_BUY_ITEM = "BlackFridaySalesMediator.GIFT_BUY_ITEM"
var0_0.GIFT_OPEN_ITEM_PANEL = "BlackFridaySalesMediator.GIFT_OPEN_ITEM_PANEL"
var0_0.UPDATE_SHOP_RED_DOT = "BlackFridaySalesMediator.UPDATE_SHOP_RED_DOT"
var0_0.CHARGE = "BlackFridaySalesMediator:CHARGE"
var0_0.OPEN_CHARGE_BIRTHDAY = "BlackFridaySalesMediator:OPEN_CHARGE_BIRTHDAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_2
		})
	end)
	arg0_1:bind(var0_0.TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_3.id)
	end)
	arg0_1:bind(var0_0.TASK_SUBMIT_ONESTEP, function(arg0_4, arg1_4)
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_4
		})
	end)
	arg0_1:bind(var0_0.GIFT_BUY_ITEM, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_5,
			count = arg2_5
		})
	end)
	arg0_1:bind(var0_0.GIFT_OPEN_ITEM_PANEL, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_6
			}
		}))
	end)
	arg0_1:bind(var0_0.UPDATE_SHOP_RED_DOT, function(arg0_7)
		arg0_1.viewComponent:updateShopDedDot()
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_8
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1.viewComponent:setData()
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE,
		GAME.CHARGE_SUCCESS,
		GAME.NEW_SERVER_SHOP_SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1_11.awards
		})
		arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11, function()
			arg0_11.viewComponent:onUpdateTask()
		end)
	elseif var0_11 == PlayerProxy.UPDATED then
		arg0_11.viewComponent:onUpdatePlayer(var1_11)
	elseif var0_11 == GAME.SHOPPING_DONE then
		if #var1_11.awards > 0 then
			arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards)
		end

		arg0_11.viewComponent:onUpdateGift()
	elseif var0_11 == GAME.NEW_SERVER_SHOP_SHOPPING_DONE then
		if #var1_11.awards > 0 then
			arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards)
		end

		if arg0_11.viewComponent.blackFridaySalesShopPage and arg0_11.viewComponent.blackFridaySalesShopPage:GetLoaded() then
			arg0_11.viewComponent.blackFridaySalesShopPage:Refresh()
		end
	elseif var0_11 == GAME.CHARGE_SUCCESS then
		local var2_11 = Goods.Create({
			shop_id = var1_11.shopId
		}, Goods.TYPE_CHARGE)

		arg0_11.viewComponent:onUpdateGift()
		arg0_11.viewComponent:OnChargeSuccess(var2_11)
	end
end

return var0_0

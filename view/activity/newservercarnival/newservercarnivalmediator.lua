local var0_0 = class("NewServerCarnivalMediator", import("...base.ContextMediator"))

var0_0.TASK_GO = "NewServerCarnivalMediator.TASK_GO"
var0_0.TASK_SUBMIT = "NewServerCarnivalMediator.TASK_SUBMIT"
var0_0.TASK_SUBMIT_ONESTEP = "NewServerCarnivalMediator.TASK_SUBMIT_ONESTEP"
var0_0.GIFT_BUY_ITEM = "NewServerCarnivalMediator.GIFT_BUY_ITEM"
var0_0.GIFT_OPEN_ITEM_PANEL = "NewServerCarnivalMediator.GIFT_OPEN_ITEM_PANEL"
var0_0.UPDATE_SHOP_RED_DOT = "NewServerCarnivalMediator.UPDATE_SHOP_RED_DOT"

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
	arg0_1.viewComponent:setData()
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.SUBMIT_TASK_DONE,
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE,
		GAME.NEW_SERVER_SHOP_SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.SUBMIT_TASK_DONE then
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9, function()
			arg0_9.viewComponent:onUpdateTask()
		end)
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:onUpdatePlayer(var1_9)
	elseif var0_9 == GAME.SHOPPING_DONE then
		if #var1_9.awards > 0 then
			arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards)
		end

		arg0_9.viewComponent:onUpdateGift()
	elseif var0_9 == GAME.NEW_SERVER_SHOP_SHOPPING_DONE then
		if #var1_9.awards > 0 then
			arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards)
		end

		if arg0_9.viewComponent.newServerShopPage and arg0_9.viewComponent.newServerShopPage:GetLoaded() then
			arg0_9.viewComponent.newServerShopPage:Refresh()
		end
	end
end

return var0_0

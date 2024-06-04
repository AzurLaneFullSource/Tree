local var0 = class("NewServerCarnivalMediator", import("...base.ContextMediator"))

var0.TASK_GO = "NewServerCarnivalMediator.TASK_GO"
var0.TASK_SUBMIT = "NewServerCarnivalMediator.TASK_SUBMIT"
var0.TASK_SUBMIT_ONESTEP = "NewServerCarnivalMediator.TASK_SUBMIT_ONESTEP"
var0.GIFT_BUY_ITEM = "NewServerCarnivalMediator.GIFT_BUY_ITEM"
var0.GIFT_OPEN_ITEM_PANEL = "NewServerCarnivalMediator.GIFT_OPEN_ITEM_PANEL"
var0.UPDATE_SHOP_RED_DOT = "NewServerCarnivalMediator.UPDATE_SHOP_RED_DOT"

function var0.register(arg0)
	arg0:bind(var0.TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id)
	end)
	arg0:bind(var0.TASK_SUBMIT_ONESTEP, function(arg0, arg1)
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1
		})
	end)
	arg0:bind(var0.GIFT_BUY_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.GIFT_OPEN_ITEM_PANEL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.UPDATE_SHOP_RED_DOT, function(arg0)
		arg0.viewComponent:updateShopDedDot()
	end)
	arg0.viewComponent:setData()
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_TASK_DONE,
		PlayerProxy.UPDATED,
		GAME.SHOPPING_DONE,
		GAME.NEW_SERVER_SHOP_SHOPPING_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:onUpdateTask()
		end)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:onUpdatePlayer(var1)
	elseif var0 == GAME.SHOPPING_DONE then
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end

		arg0.viewComponent:onUpdateGift()
	elseif var0 == GAME.NEW_SERVER_SHOP_SHOPPING_DONE then
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end

		if arg0.viewComponent.newServerShopPage and arg0.viewComponent.newServerShopPage:GetLoaded() then
			arg0.viewComponent.newServerShopPage:Refresh()
		end
	end
end

return var0

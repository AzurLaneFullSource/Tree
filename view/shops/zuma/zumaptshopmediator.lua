local var0 = class("ZumaPTShopMediator", import("...base.ContextMediator"))

var0.OPEN_ZUMA_PT_SHOP_BUY_WINDOW = "ZumaPTShopMediator.OPEN_ZUMA_PT_SHOP_BUY_WINDOW"

function var0.register(arg0)
	arg0:bind(var0.OPEN_ZUMA_PT_SHOP_BUY_WINDOW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ZumaPTShopWindowMediator,
			viewComponent = ZumaPTShopWindowLayer,
			data = {
				actShopVO = arg0.viewComponent.actShopVO,
				goodVO = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ISLAND_SHOPPING_DONE,
		GAME.USE_ITEM_DONE,
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ISLAND_SHOPPING_DONE then
		local var2 = arg1:getBody()
		local var3 = {}

		if #var2.awards > 0 then
			table.insert(var3, function(arg0)
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var2.awards, arg0)
			end)
		end

		seriesAsync(var3, function()
			arg0.viewComponent:updateTplByGoodID(var2.goodsId)
		end)
	elseif var0 == GAME.USE_ITEM_DONE then
		local var4 = arg1:getBody()

		if #var4 > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var4)
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updatePTPanel()
	end
end

return var0

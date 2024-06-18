local var0_0 = class("ZumaPTShopMediator", import("...base.ContextMediator"))

var0_0.OPEN_ZUMA_PT_SHOP_BUY_WINDOW = "ZumaPTShopMediator.OPEN_ZUMA_PT_SHOP_BUY_WINDOW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_ZUMA_PT_SHOP_BUY_WINDOW, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = ZumaPTShopWindowMediator,
			viewComponent = ZumaPTShopWindowLayer,
			data = {
				actShopVO = arg0_1.viewComponent.actShopVO,
				goodVO = arg1_2
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ISLAND_SHOPPING_DONE,
		GAME.USE_ITEM_DONE,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ISLAND_SHOPPING_DONE then
		local var2_4 = arg1_4:getBody()
		local var3_4 = {}

		if #var2_4.awards > 0 then
			table.insert(var3_4, function(arg0_5)
				arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var2_4.awards, arg0_5)
			end)
		end

		seriesAsync(var3_4, function()
			arg0_4.viewComponent:updateTplByGoodID(var2_4.goodsId)
		end)
	elseif var0_4 == GAME.USE_ITEM_DONE then
		local var4_4 = arg1_4:getBody()

		if #var4_4 > 0 then
			arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var4_4)
		end
	elseif var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:updatePTPanel()
	end
end

return var0_0

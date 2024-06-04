local var0 = class("SixthAnniversaryIslandShopMediator", import("..base.ContextMediator"))

var0.OPEN_GOODS_WINDOW = "SixthAnniversaryIslandShopMediator.OPEN_GOODS_WINDOW"

function var0.register(arg0)
	arg0.viewComponent:setShop(arg0.contextData.shop)
	arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
	arg0:bind(var0.OPEN_GOODS_WINDOW, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = SixthAnniversaryIslandShopWindowMediator,
			viewComponent = SixthAnniversaryIslandShopWindowLayer,
			data = {
				activityId = arg0.contextData.shop.activityId,
				shop = arg0.contextData.shop,
				goods = arg1
			}
		}))
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.ISLAND_SHOPPING_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = {}

			if #var0.awards > 0 then
				table.insert(var1, function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, arg0)
				end)
			end

			seriesAsync(var1, function()
				arg0.viewComponent:refreshGoodsCard(var0.goodsId)
			end)
		end,
		[GAME.USE_ITEM_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			if #var0 > 0 then
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0)
			end
		end,
		[PlayerProxy.UPDATED] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:setPlayer(var0)
		end
	}
end

return var0

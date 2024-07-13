local var0_0 = class("SixthAnniversaryIslandShopMediator", import("..base.ContextMediator"))

var0_0.OPEN_GOODS_WINDOW = "SixthAnniversaryIslandShopMediator.OPEN_GOODS_WINDOW"

function var0_0.register(arg0_1)
	arg0_1.viewComponent:setShop(arg0_1.contextData.shop)
	arg0_1.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
	arg0_1:bind(var0_0.OPEN_GOODS_WINDOW, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = SixthAnniversaryIslandShopWindowMediator,
			viewComponent = SixthAnniversaryIslandShopWindowLayer,
			data = {
				activityId = arg0_1.contextData.shop.activityId,
				shop = arg0_1.contextData.shop,
				goods = arg1_2
			}
		}))
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.ISLAND_SHOPPING_DONE] = function(arg0_4, arg1_4)
			local var0_4 = arg1_4:getBody()
			local var1_4 = {}

			if #var0_4.awards > 0 then
				table.insert(var1_4, function(arg0_5)
					arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_4.awards, arg0_5)
				end)
			end

			seriesAsync(var1_4, function()
				arg0_4.viewComponent:refreshGoodsCard(var0_4.goodsId)
			end)
		end,
		[GAME.USE_ITEM_DONE] = function(arg0_7, arg1_7)
			local var0_7 = arg1_7:getBody()

			if #var0_7 > 0 then
				arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_7)
			end
		end,
		[PlayerProxy.UPDATED] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			arg0_8.viewComponent:setPlayer(var0_8)
		end
	}
end

return var0_0

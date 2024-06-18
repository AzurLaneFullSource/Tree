local var0_0 = class("ItemInfoMediator", import("..base.ContextMediator"))

var0_0.USE_ITEM = "ItemInfoMediator:USE_ITEM"
var0_0.COMPOSE_ITEM = "ItemInfoMediator:COMPOSE_ITEM"
var0_0.SELL_BLUEPRINT = "sell blueprint"
var0_0.EXCHANGE_LOVE_LETTER_ITEM = "ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SELL_BLUEPRINT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.FRAG_SELL, {
			arg1_2
		})
	end)
	arg0_1:bind(var0_0.USE_ITEM, function(arg0_3, arg1_3, arg2_3)
		local var0_3 = getProxy(BagProxy):getItemById(arg1_3)

		if not UseItemCommand.Check(var0_3, arg2_3) then
			arg0_1.viewComponent:closeView()

			return
		end

		arg0_1.viewComponent:PlayOpenBox(var0_3:getConfig("display_effect"), function()
			arg0_1:sendNotification(GAME.USE_ITEM, {
				id = arg1_3,
				count = arg2_3
			})
		end)
	end)
	arg0_1:bind(var0_0.COMPOSE_ITEM, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.COMPOSE_ITEM, {
			id = arg1_5,
			count = arg2_5
		})
	end)
	arg0_1:bind(var0_0.EXCHANGE_LOVE_LETTER_ITEM, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.EXCHANGE_LOVE_LETTER_ITEM, {
			activity_id = arg1_6
		})
	end)
	arg0_1.viewComponent:setDrop(arg0_1.contextData.drop)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		BagProxy.ITEM_UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.FRAG_SELL_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == BagProxy.ITEM_UPDATED then
		if var1_8.id == arg0_8.viewComponent.itemVO.id then
			if var1_8.count <= 0 then
				arg0_8.viewComponent:closeView()
			else
				arg0_8.viewComponent:setItem(Drop.New({
					type = DROP_TYPE_ITEM,
					id = var1_8.id,
					count = var1_8.count
				}))
			end
		end
	elseif var0_8 == GAME.USE_ITEM_DONE then
		arg0_8.viewComponent:SetOperateCount(1)
	elseif var0_8 == GAME.FRAG_SELL_DONE then
		arg0_8.viewComponent:SetOperateCount(1)
	end
end

return var0_0

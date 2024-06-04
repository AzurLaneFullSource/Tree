local var0 = class("ItemInfoMediator", import("..base.ContextMediator"))

var0.USE_ITEM = "ItemInfoMediator:USE_ITEM"
var0.COMPOSE_ITEM = "ItemInfoMediator:COMPOSE_ITEM"
var0.SELL_BLUEPRINT = "sell blueprint"
var0.EXCHANGE_LOVE_LETTER_ITEM = "ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM"

function var0.register(arg0)
	arg0:bind(var0.SELL_BLUEPRINT, function(arg0, arg1)
		arg0:sendNotification(GAME.FRAG_SELL, {
			arg1
		})
	end)
	arg0:bind(var0.USE_ITEM, function(arg0, arg1, arg2)
		local var0 = getProxy(BagProxy):getItemById(arg1)

		if not UseItemCommand.Check(var0, arg2) then
			arg0.viewComponent:closeView()

			return
		end

		arg0.viewComponent:PlayOpenBox(var0:getConfig("display_effect"), function()
			arg0:sendNotification(GAME.USE_ITEM, {
				id = arg1,
				count = arg2
			})
		end)
	end)
	arg0:bind(var0.COMPOSE_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMPOSE_ITEM, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.EXCHANGE_LOVE_LETTER_ITEM, function(arg0, arg1)
		arg0:sendNotification(GAME.EXCHANGE_LOVE_LETTER_ITEM, {
			activity_id = arg1
		})
	end)
	arg0.viewComponent:setDrop(arg0.contextData.drop)
end

function var0.listNotificationInterests(arg0)
	return {
		BagProxy.ITEM_UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.FRAG_SELL_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == BagProxy.ITEM_UPDATED then
		if var1.id == arg0.viewComponent.itemVO.id then
			if var1.count <= 0 then
				arg0.viewComponent:closeView()
			else
				arg0.viewComponent:setItem(Drop.New({
					type = DROP_TYPE_ITEM,
					id = var1.id,
					count = var1.count
				}))
			end
		end
	elseif var0 == GAME.USE_ITEM_DONE then
		arg0.viewComponent:SetOperateCount(1)
	elseif var0 == GAME.FRAG_SELL_DONE then
		arg0.viewComponent:SetOperateCount(1)
	end
end

return var0

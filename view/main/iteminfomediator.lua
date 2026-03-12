local var0_0 = class("ItemInfoMediator", import("..base.ContextMediator"))

var0_0.USE_ITEM = "ItemInfoMediator:USE_ITEM"
var0_0.COMPOSE_ITEM = "ItemInfoMediator:COMPOSE_ITEM"
var0_0.SELL_BLUEPRINT = "sell blueprint"
var0_0.EXCHANGE_LOVE_LETTER_ITEM = "ItemInfoMediator.EXCHANGE_LOVE_LETTER_ITEM"
var0_0.REPAIR_LOVE_LETTER_ITEM = "ItemInfoMediator.REPAIR_LOVE_LETTER_ITEM"
var0_0.CHECK_LOVE_LETTER_MAIL = "ItemInfoMediator.CHECK_LOVE_LETTER_MAIL"
var0_0.REPAIR_LOVE_LETTER_MAIL = "ItemInfoMediator.REPAIR_LOVE_LETTER_MAIL"

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
				count = arg2_3,
				isEquipBox = var0_3:getConfig("type") == Item.EQUIPMENT_BOX_TYPE_5
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
	arg0_1:bind(var0_0.REPAIR_LOVE_LETTER_ITEM, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterSelectCharMediator,
			viewComponent = LoveLetterSelectCharLayer,
			data = {
				isRepair = true,
				itemVO = arg1_7
			}
		}))
	end)
	arg0_1:bind(var0_0.CHECK_LOVE_LETTER_MAIL, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.LOVE_ITEM_MAIL_CHECK, {
			item_id = arg1_8,
			group_id = arg2_8
		})
	end)
	arg0_1:bind(var0_0.REPAIR_LOVE_LETTER_MAIL, function(arg0_9, arg1_9, arg2_9, arg3_9)
		arg0_1:sendNotification(GAME.LOVE_ITEM_MAIL_REPAIR, {
			item_id = arg1_9,
			year = arg2_9,
			group_id = arg3_9
		})
	end)
	arg0_1.viewComponent:setDrop(arg0_1.contextData.drop)
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		BagProxy.ITEM_UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.FRAG_SELL_DONE,
		GAME.LOVE_ITEM_MAIL_CHECK_DONE
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == BagProxy.ITEM_UPDATED then
		local var2_11 = arg0_11.viewComponent.itemVO

		if var1_11.id == var2_11.id then
			if var1_11.count <= 0 or var2_11.extra and not getProxy(BagProxy):hasExtraData(var2_11.id, var2_11.extra) then
				arg0_11.viewComponent:closeView()
			else
				arg0_11.viewComponent:setItem(Drop.New({
					type = DROP_TYPE_ITEM,
					id = var1_11.id,
					count = var1_11.count,
					extra = var1_11.extra
				}))
			end
		end
	elseif var0_11 == GAME.USE_ITEM_DONE then
		arg0_11.viewComponent:SetOperateCount(1)
	elseif var0_11 == GAME.FRAG_SELL_DONE then
		arg0_11.viewComponent:SetOperateCount(1)
	elseif var0_11 == GAME.LOVE_ITEM_MAIL_CHECK_DONE then
		arg0_11.viewComponent:setDrop(arg0_11.contextData.drop)
	end
end

return var0_0

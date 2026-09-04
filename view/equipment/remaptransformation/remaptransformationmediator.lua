local var0_0 = class("ReMapTransformationMediator", import("view.base.ContextMediator"))

var0_0.ON_USE_ITEM = "EquipmentMediator:ON_USE_ITEM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_2,
			count = arg2_2,
			arg = {
				arg3_2
			}
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[BagProxy.ITEM_UPDATED] = function(arg0_4, arg1_4)
			local var0_4 = arg1_4:getBody()
			local var1_4 = arg0_4.viewComponent.itemVO

			if var0_4.id == var1_4.id then
				if var0_4.count <= 0 or var1_4.extra and not getProxy(BagProxy):hasExtraData(var1_4.id, var1_4.extra) then
					arg0_4.viewComponent:closeView()
				else
					arg0_4.viewComponent:update(Drop.New({
						type = DROP_TYPE_ITEM,
						id = var0_4.id,
						count = var0_4.count,
						extra = var0_4.extra
					}):getSubClass())
				end
			end
		end
	}
end

function var0_0.remove(arg0_5)
	return
end

return var0_0

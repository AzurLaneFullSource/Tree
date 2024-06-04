local var0 = class("EquipCodeShareMediator", import("..base.ContextMediator"))

var0.OPEN_TAG_INDEX = "EquipCodeShareMediator.OPEN_TAG_INDEX"
var0.LIKE_EQUIP_CODE = "EquipCodeShareMediator.LIKE_EQUIP_CODE"
var0.IMPEACH_EQUIP_CODE = "EquipCodeShareMediator.IMPEACH_EQUIP_CODE"

function var0.register(arg0)
	arg0:bind(var0.IMPEACH_EQUIP_CODE, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.EQUIP_CODE_IMPEACH, {
			groupId = arg1,
			shareId = arg2,
			type = arg3
		})
	end)
	arg0:bind(var0.LIKE_EQUIP_CODE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.EQUIP_CODE_LIKE, {
			groupId = arg1,
			shareId = arg2
		})
	end)
	arg0:bind(var0.OPEN_TAG_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)

	local var0 = getProxy(CollectionProxy):getShipGroup(arg0.contextData.shipGroupId)

	arg0.viewComponent:setShipGroup(var0)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.EQUIP_CODE_LIKE_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:refreshLikeCommand(var0.shareId, var0.like)
		end
	}
end

return var0

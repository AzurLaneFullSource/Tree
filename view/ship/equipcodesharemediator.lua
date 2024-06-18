local var0_0 = class("EquipCodeShareMediator", import("..base.ContextMediator"))

var0_0.OPEN_TAG_INDEX = "EquipCodeShareMediator.OPEN_TAG_INDEX"
var0_0.LIKE_EQUIP_CODE = "EquipCodeShareMediator.LIKE_EQUIP_CODE"
var0_0.IMPEACH_EQUIP_CODE = "EquipCodeShareMediator.IMPEACH_EQUIP_CODE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.IMPEACH_EQUIP_CODE, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.EQUIP_CODE_IMPEACH, {
			groupId = arg1_2,
			shareId = arg2_2,
			type = arg3_2
		})
	end)
	arg0_1:bind(var0_0.LIKE_EQUIP_CODE, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.EQUIP_CODE_LIKE, {
			groupId = arg1_3,
			shareId = arg2_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_TAG_INDEX, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_4
		}))
	end)

	local var0_1 = getProxy(CollectionProxy):getShipGroup(arg0_1.contextData.shipGroupId)

	arg0_1.viewComponent:setShipGroup(var0_1)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {
		[GAME.EQUIP_CODE_LIKE_DONE] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getBody()

			arg0_6.viewComponent:refreshLikeCommand(var0_6.shareId, var0_6.like)
		end
	}
end

return var0_0

local var0 = class("Dorm3dGiftMediator", import("view.base.ContextMediator"))

var0.GIVE_GIFT = "Dorm3dGiftMediator.GIVE_GIFT"
var0.DO_TALK = "Dorm3dGiftMediator.DO_TALK"
var0.CHECK_LEVEL_UP = "Dorm3dGiftMediator.CHECK_LEVEL_UP"

function var0.register(arg0)
	arg0:bind(var0.GIVE_GIFT, function(arg0, arg1)
		arg0:sendNotification(GAME.APARTMENT_GIVE_GIFT, {
			count = 1,
			groupId = arg0.viewComponent.apartment.configId,
			giftId = arg1
		})
	end)
	arg0:bind(var0.DO_TALK, function(arg0, arg1, arg2)
		arg0:sendNotification(Dorm3dSceneMediator.OTHER_DO_TALK, {
			moveCamera = false,
			talkId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.CHECK_LEVEL_UP, function(arg0)
		arg0:sendNotification(Dorm3dSceneMediator.OTHER_CHECK_LEVEL_UP)
	end)
	arg0.viewComponent:SetApartment(getProxy(ApartmentProxy):getApartment(arg0.contextData.groupId))
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0, arg1)
			local var0 = arg1:getBody()

			if var0.configId == arg0.contextData.groupId then
				arg0.viewComponent:SetApartment(var0)
				arg0.viewComponent:UpdateFavorPanel()
			end
		end,
		[ApartmentProxy.UPDATE_GIFT_COUNT] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:SingleUpdateGift(var0)
		end,
		[GAME.APARTMENT_GIVE_GIFT_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:AfterGiveGift(var0)
		end
	}
end

function var0.remove(arg0)
	return
end

return var0

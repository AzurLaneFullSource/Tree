local var0_0 = class("Dorm3dGiftMediator", import("view.base.ContextMediator"))

var0_0.GIVE_GIFT = "Dorm3dGiftMediator.GIVE_GIFT"
var0_0.DO_TALK = "Dorm3dGiftMediator.DO_TALK"
var0_0.CHECK_LEVEL_UP = "Dorm3dGiftMediator.CHECK_LEVEL_UP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GIVE_GIFT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.APARTMENT_GIVE_GIFT, {
			count = 1,
			groupId = arg0_1.viewComponent.apartment.configId,
			giftId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.DO_TALK, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(Dorm3dSceneMediator.OTHER_DO_TALK, {
			moveCamera = false,
			talkId = arg1_3,
			callback = arg2_3
		})
	end)
	arg0_1:bind(var0_0.CHECK_LEVEL_UP, function(arg0_4)
		arg0_1:sendNotification(Dorm3dSceneMediator.OTHER_CHECK_LEVEL_UP)
	end)
	arg0_1.viewComponent:SetApartment(getProxy(ApartmentProxy):getApartment(arg0_1.contextData.groupId))
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getBody()

			if var0_6.configId == arg0_6.contextData.groupId then
				arg0_6.viewComponent:SetApartment(var0_6)
				arg0_6.viewComponent:UpdateFavorPanel()
			end
		end,
		[ApartmentProxy.UPDATE_GIFT_COUNT] = function(arg0_7, arg1_7)
			local var0_7 = arg1_7:getBody()

			arg0_7.viewComponent:SingleUpdateGift(var0_7)
		end,
		[GAME.APARTMENT_GIVE_GIFT_DONE] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			arg0_8.viewComponent:AfterGiveGift(var0_8)
		end
	}
end

function var0_0.remove(arg0_9)
	return
end

return var0_0

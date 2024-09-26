local var0_0 = class("Dorm3dGiftMediator", import("view.base.ContextMediator"))

var0_0.GIVE_GIFT = "Dorm3dGiftMediator.GIVE_GIFT"
var0_0.DO_TALK = "Dorm3dGiftMediator.DO_TALK"
var0_0.CHECK_LEVEL_UP = "Dorm3dGiftMediator.CHECK_LEVEL_UP"
var0_0.OPEN_DROP_LAYER = "Dorm3dGiftMediator.OPEN_DROP_LAYER"
var0_0.SHOW_SHOPPING_CONFIRM_WINDOW = "Dorm3dGiftMediator.SHOW_SHOPPING_CONFIRM_WINDOW"
var0_0.FAVOR_LEVEL_UP = "Dorm3dGiftMediator.FAVOR_LEVEL_UP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.FAVOR_LEVEL_UP, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.APARTMENT_LEVEL_UP, {
			groupId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.GIVE_GIFT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.APARTMENT_GIVE_GIFT, {
			count = 1,
			groupId = arg0_1.viewComponent.apartment.configId,
			giftId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.DO_TALK, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(Dorm3dRoomMediator.OTHER_DO_TALK, {
			talkId = arg1_4,
			callback = arg2_4
		})
	end)
	arg0_1:bind(var0_0.CHECK_LEVEL_UP, function(arg0_5)
		arg0_1:sendNotification(Dorm3dRoomMediator.GUIDE_CHECK_LEVEL_UP)
	end)
	arg0_1:bind(var0_0.SHOW_SHOPPING_CONFIRM_WINDOW, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dShoppingConfirmWindowMediator,
			viewComponent = Dorm3dShoppingConfirmWindow,
			data = arg1_6
		}))
	end)
	arg0_1:bind(GAME.SHOPPING, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_7.shopId,
			count = arg1_7.count,
			silentTip = arg1_7.silentTip
		})
	end)
	arg0_1:bind(var0_0.OPEN_DROP_LAYER, function(arg0_8, arg1_8, arg2_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAwardInfoLayer,
			mediator = Dorm3dAwardInfoMediator,
			data = {
				items = arg1_8
			},
			onRemoved = arg2_8
		}))
	end)
	arg0_1.viewComponent:SetApartment(arg0_1.contextData.apartment)
end

function var0_0.initNotificationHandleDic(arg0_9)
	arg0_9.handleDic = {
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0_10, arg1_10)
			local var0_10 = arg1_10:getBody()

			if var0_10.configId == arg0_10.contextData.groupId then
				arg0_10.viewComponent:SetApartment(var0_10)
			end
		end,
		[ApartmentProxy.UPDATE_GIFT_COUNT] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			arg0_11.viewComponent:SingleUpdateGift(var0_11)
		end,
		[GAME.APARTMENT_GIVE_GIFT_DONE] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			arg0_12.viewComponent:AfterGiveGift(var0_12)
		end,
		[GAME.SHOPPING_DONE] = function(arg0_13, arg1_13)
			local var0_13 = arg1_13:getBody().awards

			if var0_13 and #var0_13 > 0 then
				arg0_13.viewComponent:emit(var0_0.OPEN_DROP_LAYER, var0_13, function()
					local var0_14 = arg1_13:getBody().id
					local var1_14 = pg.shop_template[var0_14]

					arg0_13.viewComponent:SingleUpdateGift(var1_14.effect_args[1])
				end)
			end
		end,
		[Dorm3dRoomMediator.ON_LEVEL_UP_FINISH] = function(arg0_15, arg1_15)
			arg0_15.viewComponent:CheckLevelUp()
		end
	}
end

return var0_0

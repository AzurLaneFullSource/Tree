local var0_0 = class("IslandSelfCardMediator", import("view.base.ContextMediator"))

var0_0.SET_CARD_NAME = "IslandSelfCardMediator.SET_CARD_NAME"
var0_0.SET_CARD_PHOTO = "IslandSelfCardMediator.SET_CARD_PHOTO"
var0_0.SET_CARD_WORD = "IslandSelfCardMediator.SET_CARD_WORD"
var0_0.SET_CARD_ACHVS = "IslandSelfCardMediator.SET_CARD_ACHVS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SET_CARD_NAME, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ISLAND_SET_NAME, {
			currency = 1,
			name = arg1_2
		})
	end)
	arg0_1:bind(var0_0.SET_CARD_WORD, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ISLAND_SET_CARD_WORD, {
			word = arg1_3
		})
	end)
	arg0_1:bind(var0_0.SET_CARD_PHOTO, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ISLAND_SET_CARD_PHOTO, {
			type = IslandCard.PHOTO_TYPE_ID,
			photo = tostring(arg1_4)
		})
	end)
	arg0_1:bind(var0_0.SET_CARD_ACHVS, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.ISLAND_SET_CARD_ACHVS, {
			achvIds = arg1_5
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.ISLAND_SET_NAME_DONE,
		GAME.ISLAND_SET_CARD_WORD_DONE,
		GAME.ISLAND_SET_CARD_PHOTO_DONE,
		GAME.ISLAND_SET_CARD_ACHVS_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.ISLAND_SET_NAME_DONE then
		arg0_7.viewComponent:OnSetNameDone(var1_7.name)
	elseif var0_7 == GAME.ISLAND_SET_CARD_WORD_DONE then
		arg0_7.viewComponent:OnSetWordDone(var1_7.word)
	elseif var0_7 == GAME.ISLAND_SET_CARD_PHOTO_DONE then
		arg0_7.viewComponent:OnSetPhotoDone(var1_7.photo)
	elseif var0_7 == GAME.ISLAND_SET_CARD_ACHVS_DONE then
		arg0_7.viewComponent:OnSetAchvsDone(var1_7.achvIds)
	end
end

return var0_0

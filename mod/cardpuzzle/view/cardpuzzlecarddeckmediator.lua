local var0_0 = class("CardPuzzleCardDeckMediator", ContextMediator)

var0_0.SHOW_CARD = "SHOW_CARD"
var0_0.CLOSE_LAYER = "CLOSE_LAYER"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.card
	local var1_1 = arg0_1.contextData.hand

	arg0_1.viewComponent:SetCards(var0_1, var1_1)
	arg0_1:bind(var0_0.SHOW_CARD, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = CardPuzzleCardDetailMediator,
			viewComponent = CardPuzzleCardDetailLayer,
			data = arg1_2
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_LAYER, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.RESUME_BATTLE)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

function var0_0.onBackPressed(arg0_6, arg1_6)
	arg0_6:sendNotification(GAME.RESUME_BATTLE)
	var0_0.super.onBackPressed(arg0_6, arg1_6)
end

function var0_0.remove(arg0_7)
	return
end

return var0_0

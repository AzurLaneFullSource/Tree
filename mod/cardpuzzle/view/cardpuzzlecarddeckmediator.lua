local var0 = class("CardPuzzleCardDeckMediator", ContextMediator)

var0.SHOW_CARD = "SHOW_CARD"
var0.CLOSE_LAYER = "CLOSE_LAYER"

function var0.register(arg0)
	local var0 = arg0.contextData.card
	local var1 = arg0.contextData.hand

	arg0.viewComponent:SetCards(var0, var1)
	arg0:bind(var0.SHOW_CARD, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CardPuzzleCardDetailMediator,
			viewComponent = CardPuzzleCardDetailLayer,
			data = arg1
		}))
	end)
	arg0:bind(var0.CLOSE_LAYER, function(arg0, arg1)
		arg0:sendNotification(GAME.RESUME_BATTLE)
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

function var0.onBackPressed(arg0, arg1)
	arg0:sendNotification(GAME.RESUME_BATTLE)
	var0.super.onBackPressed(arg0, arg1)
end

function var0.remove(arg0)
	return
end

return var0

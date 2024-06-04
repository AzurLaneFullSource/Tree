local var0 = class("CardPuzzleRelicDeckMediator", ContextMediator)

var0.SHOW_GIFT = "SHOW_GIFT"
var0.CLOSE_LAYER = "CLOSE_LAYER"

function var0.register(arg0)
	local var0 = arg0.contextData.relicList

	arg0.viewComponent:SetGifts(var0)
	arg0:bind(var0.SHOW_GIFT, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CardPuzzleRelicDetailMediator,
			viewComponent = CardPuzzleRelicDetailLayer,
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

function var0.remove(arg0)
	return
end

return var0

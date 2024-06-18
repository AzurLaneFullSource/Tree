local var0_0 = class("CardPuzzleRelicDeckMediator", ContextMediator)

var0_0.SHOW_GIFT = "SHOW_GIFT"
var0_0.CLOSE_LAYER = "CLOSE_LAYER"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.relicList

	arg0_1.viewComponent:SetGifts(var0_1)
	arg0_1:bind(var0_0.SHOW_GIFT, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = CardPuzzleRelicDetailMediator,
			viewComponent = CardPuzzleRelicDetailLayer,
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

function var0_0.remove(arg0_5)
	return
end

return var0_0

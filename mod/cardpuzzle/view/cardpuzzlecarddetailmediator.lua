local var0 = class("CardPuzzleCardDetailMediator", ContextMediator)

var0.DISPLAY_CARD_EFFECT = "DISPLAY_CARD_EFFECT"

function var0.register(arg0)
	arg0:bind(var0.DISPLAY_CARD_EFFECT, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CardTowerCardEffectPreviewMediator,
			viewComponent = CardTowerCardEffectPreviewWindow,
			data = {
				card = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0

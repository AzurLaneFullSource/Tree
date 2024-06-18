local var0_0 = class("CardPuzzleCardDetailMediator", ContextMediator)

var0_0.DISPLAY_CARD_EFFECT = "DISPLAY_CARD_EFFECT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.DISPLAY_CARD_EFFECT, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = CardTowerCardEffectPreviewMediator,
			viewComponent = CardTowerCardEffectPreviewWindow,
			data = {
				card = arg1_2
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0

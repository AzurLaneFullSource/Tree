local var0_0 = class("FormationSuggestionMediator", import("view.base.ContextMediator"))

var0_0.ON_CLOSE_SHIP_INFO = "FormationSuggestionMediator::ON_CLOSE_SHIP_INFO"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLOSE_SHIP_INFO, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.FORMATION_SUGGESTION_CLOSE_SHIP_INFO)
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.FORMATION_SUGGESTION_OPEN_SHIP_INFO] = function(arg0_4, arg1_4)
			arg0_4.viewComponent:OnOpenShipInfo()
		end,
		[GAME.FORMATION_SUGGESTION_EXIT_SHIP_INFO] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:OnCloseShipInfo()
		end
	}
end

function var0_0.remove(arg0_6)
	return
end

return var0_0

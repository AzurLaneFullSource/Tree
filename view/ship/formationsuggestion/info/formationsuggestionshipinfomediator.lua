local var0_0 = class("FormationSuggestionShipInfoMediator", import("view.base.ContextMediator"))

var0_0.JUMP_TO_SCENE = "FormationSuggestionShipInfoMediator::JUMP_TO_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.JUMP_TO_SCENE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.JUMP_TO_SCENE, arg1_2)
	end)
	arg0_1:sendNotification(GAME.FORMATION_SUGGESTION_OPEN_SHIP_INFO)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.FORMATION_SUGGESTION_CLOSE_SHIP_INFO] = function(arg0_4, arg1_4)
			arg0_4.viewComponent:closeView()
		end
	}
end

return var0_0

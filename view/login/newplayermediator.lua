local var0_0 = class("NewPlayerMediator", import("..base.ContextMediator"))

var0_0.ON_CREATE = "NewPlayerMediator:ON_CREATE"
var0_0.ON_SKILLINFO = "NewPlayerMediator:ON_SKILLINFO"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CREATE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.CREATE_NEW_PLAYER, {
			nickname = arg1_2,
			shipId = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_SKILLINFO, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				fromNewShip = true,
				skillId = arg1_3
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.CREATE_NEW_PLAYER_DONE,
		GAME.LOAD_PLAYER_DATA_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.CREATE_NEW_PLAYER_DONE then
		arg0_5.facade:sendNotification(GAME.LOAD_PLAYER_DATA, {
			isNewPlayer = true,
			id = var1_5
		})
	elseif var0_5 == GAME.LOAD_PLAYER_DATA_DONE then
		arg0_5:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	end
end

return var0_0

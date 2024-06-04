local var0 = class("NewPlayerMediator", import("..base.ContextMediator"))

var0.ON_CREATE = "NewPlayerMediator:ON_CREATE"
var0.ON_SKILLINFO = "NewPlayerMediator:ON_SKILLINFO"

function var0.register(arg0)
	arg0:bind(var0.ON_CREATE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.CREATE_NEW_PLAYER, {
			nickname = arg1,
			shipId = arg2
		})
	end)
	arg0:bind(var0.ON_SKILLINFO, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				fromNewShip = true,
				skillId = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CREATE_NEW_PLAYER_DONE,
		GAME.LOAD_PLAYER_DATA_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CREATE_NEW_PLAYER_DONE then
		arg0.facade:sendNotification(GAME.LOAD_PLAYER_DATA, {
			isNewPlayer = true,
			id = var1
		})
	elseif var0 == GAME.LOAD_PLAYER_DATA_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	end
end

return var0

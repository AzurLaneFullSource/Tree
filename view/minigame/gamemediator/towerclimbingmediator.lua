local var0 = class("TowerClimbingMediator", import("...base.ContextMediator"))

var0.ON_FINISH = "TowerClimbingMediator:ON_FINISH"
var0.ON_MODIFY_DATA = "TowerClimbingMediator:ON_MODIFY_DATA"
var0.ON_COLLECTION = "TowerClimbingMediator:ON_COLLECTION"
var0.ON_RECORD_MAP_SCORE = "TowerClimbingMediator:ON_RECORD_MAP_SCORE"

function var0.register(arg0)
	arg0:bind(var0.ON_RECORD_MAP_SCORE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				MiniGameDataCreator.TowerClimbingGameID,
				4,
				arg2,
				arg1
			}
		})
	end)
	arg0:bind(var0.ON_COLLECTION, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = TowerClimbingCollectionLayer,
			mediator = TowerClimbingCollectionMediator
		}))
	end)
	arg0:bind(var0.ON_FINISH, function(arg0, arg1, arg2, arg3)
		if arg3 < arg1 then
			arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = 9,
				cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
				args1 = {
					MiniGameDataCreator.TowerClimbingGameID,
					3,
					arg1,
					arg2
				}
			})
		end

		if getProxy(MiniGameProxy):GetHubByGameId(MiniGameDataCreator.TowerClimbingGameID).count <= 0 then
			return
		end

		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_COMPLETE,
			args1 = {},
			id = MiniGameDataCreator.TowerClimbingGameID
		})
	end)
	arg0:bind(var0.ON_MODIFY_DATA, function(arg0, arg1)
		arg0:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
			id = MiniGameDataCreator.TowerClimbingGameID,
			map = arg1
		})
	end)

	local var0 = getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.TowerClimbingGameID)

	if var0 and not var0:GetRuntimeData("isInited") then
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				MiniGameDataCreator.TowerClimbingGameID,
				1
			}
		})
	else
		arg0.viewComponent:Start()
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2 = {
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
				else
					arg0()
				end
			end
		}

		seriesAsync(var2)
		arg0.viewComponent:OnSendMiniGameOPDone(var1)
	elseif var0 == GAME.REMOVE_LAYERS and var1.context.mediator == TowerClimbingCollectionMediator then
		arg0.viewComponent:UpdateTip()
	end
end

return var0

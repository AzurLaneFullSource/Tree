local var0_0 = class("TowerClimbingMediator", import("...base.ContextMediator"))

var0_0.ON_FINISH = "TowerClimbingMediator:ON_FINISH"
var0_0.ON_MODIFY_DATA = "TowerClimbingMediator:ON_MODIFY_DATA"
var0_0.ON_COLLECTION = "TowerClimbingMediator:ON_COLLECTION"
var0_0.ON_RECORD_MAP_SCORE = "TowerClimbingMediator:ON_RECORD_MAP_SCORE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_RECORD_MAP_SCORE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				MiniGameDataCreator.TowerClimbingGameID,
				4,
				arg2_2,
				arg1_2
			}
		})
	end)
	arg0_1:bind(var0_0.ON_COLLECTION, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = TowerClimbingCollectionLayer,
			mediator = TowerClimbingCollectionMediator
		}))
	end)
	arg0_1:bind(var0_0.ON_FINISH, function(arg0_4, arg1_4, arg2_4, arg3_4)
		if arg3_4 < arg1_4 then
			arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = 9,
				cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
				args1 = {
					MiniGameDataCreator.TowerClimbingGameID,
					3,
					arg1_4,
					arg2_4
				}
			})
		end

		if getProxy(MiniGameProxy):GetHubByGameId(MiniGameDataCreator.TowerClimbingGameID).count <= 0 then
			return
		end

		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_COMPLETE,
			args1 = {},
			id = MiniGameDataCreator.TowerClimbingGameID
		})
	end)
	arg0_1:bind(var0_0.ON_MODIFY_DATA, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
			id = MiniGameDataCreator.TowerClimbingGameID,
			map = arg1_5
		})
	end)

	local var0_1 = getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.TowerClimbingGameID)

	if var0_1 and not var0_1:GetRuntimeData("isInited") then
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_SPECIAL_GAME,
			args1 = {
				MiniGameDataCreator.TowerClimbingGameID,
				1
			}
		})
	else
		arg0_1.viewComponent:Start()
	end
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_7 = {
			function(arg0_8)
				local var0_8 = var1_7.awards

				if #var0_8 > 0 then
					arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_8, arg0_8)
				else
					arg0_8()
				end
			end
		}

		seriesAsync(var2_7)
		arg0_7.viewComponent:OnSendMiniGameOPDone(var1_7)
	elseif var0_7 == GAME.REMOVE_LAYERS and var1_7.context.mediator == TowerClimbingCollectionMediator then
		arg0_7.viewComponent:UpdateTip()
	end
end

return var0_0

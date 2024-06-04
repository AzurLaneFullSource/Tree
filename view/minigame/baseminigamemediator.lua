local var0 = class("BaseMiniGameMediator", import("..base.ContextMediator"))

var0.MINI_GAME_SUCCESS = "BaseMiniGameMediator:MINI_GAME_SUCCESS"
var0.MINI_GAME_FAILURE = "BaseMiniGameMediator:MINI_GAME_FAILURE"
var0.MINI_GAME_OPERATOR = "BaseMiniGameMediator:MINI_GAME_OPERATOR"
var0.OPEN_SUB_LAYER = "BaseMiniGameMediator:OPEN_SUB_LAYER"
var0.MINI_GAME_COIN = "BaseMiniGameMediator:MINI_GAME_COIN"
var0.COIN_WINDOW_CHANGE = "BaseMiniGameMediator:COIN_WINDOW_CHANGE"
var0.GAME_FINISH_TRACKING = "BaseMiniGameMediator:GAME_FINISH_TRACKING"

function var0.register(arg0)
	arg0.miniGameId = arg0.contextData.miniGameId
	arg0.miniGameProxy = getProxy(MiniGameProxy)

	local var0 = arg0.miniGameProxy:GetHubByGameId(arg0.miniGameId)
	local var1 = arg0.miniGameProxy:GetMiniGameData(arg0.miniGameId)

	arg0.viewComponent:SetMGData(var1)
	arg0.viewComponent:SetMGHubData(var0)
	arg0.miniGameProxy:RequestInitData(arg0.miniGameId)

	arg0.gameRoomId = pg.mini_game[arg0.miniGameId].game_room

	if arg0.gameRoomId and arg0.gameRoomId > 0 then
		arg0.gameRoomData = pg.game_room_template[arg0.gameRoomId]
		arg0.gameRoonCoinCount = 0

		arg0.viewComponent:setGameRoomData(arg0.gameRoomData)
	end

	arg0:bind(BaseMiniGameMediator.MINI_GAME_SUCCESS, function(arg0, ...)
		arg0:OnMiniGameSuccess(...)
	end)
	arg0:bind(BaseMiniGameMediator.MINI_GAME_FAILURE, function(arg0, ...)
		arg0:OnMiniGameFailure(...)
	end)
	arg0:bind(BaseMiniGameMediator.MINI_GAME_OPERATOR, function(arg0, ...)
		arg0:OnMiniGameOPeration(...)
	end)
	arg0:bind(BaseMiniGameMediator.OPEN_SUB_LAYER, function(arg0, arg1)
		local var0 = Context.New(arg1)

		arg0:addSubLayers(var0)
	end)
	arg0:bind(BaseMiniGameMediator.MINI_GAME_COIN, function(arg0, ...)
		arg0:loadCoinLayer()
	end)
	arg0:bind(BaseMiniGameMediator.COIN_WINDOW_CHANGE, function(arg0, arg1)
		arg0:sendNotification(GameRoomCoinMediator.CHANGE_VISIBLE, arg1)
	end)
	arg0:bind(BaseMiniGameMediator.GAME_FINISH_TRACKING, function(arg0, arg1)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1.hub_id,
			cmd = MiniGameOPCommand.CMD_PLAY,
			args1 = {
				arg1.game_id,
				arg1.isComplete
			}
		})
	end)
end

function var0.onUIAvalible(arg0)
	if arg0.gameRoomData and arg0.gameRoomData.add_base > 0 then
		arg0:loadCoinLayer()
	end
end

function var0.loadCoinLayer(arg0)
	arg0.viewComponent:setCoinLayer()
	arg0:addSubLayers(Context.New({
		mediator = GameRoomCoinMediator,
		viewComponent = GameRoomCoinLayer,
		data = arg0.gameRoomData
	}))
end

function var0.OnMiniGameOPeration(arg0, ...)
	return
end

function var0.OnMiniGameSuccess(arg0, ...)
	return
end

function var0.OnMiniGameFailure(arg0, ...)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		MiniGameProxy.ON_HUB_DATA_UPDATE,
		GAME.SEND_MINI_GAME_OP_DONE,
		GAME.MODIFY_MINI_GAME_DATA_DONE,
		GAME.ON_APPLICATION_PAUSE,
		GAME.GAME_COIN_COUNT_CHANGE,
		GAME.GAME_ROOM_AWARD_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		arg0.viewComponent:SetMGHubData(var1)
	elseif var0 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2 = {
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0.viewComponent:OnGetAwardDone(var1)
				arg0()
			end
		}

		seriesAsync(var2)
		arg0.viewComponent:OnSendMiniGameOPDone(var1)
	elseif var0 == GAME.MODIFY_MINI_GAME_DATA_DONE then
		arg0.viewComponent:OnModifyMiniGameDataDone(var1)
	elseif var0 == GAME.ON_APPLICATION_PAUSE then
		arg0.viewComponent:OnApplicationPaused(var1)
	elseif var0 == GAME.GAME_COIN_COUNT_CHANGE then
		arg0.gameRoonCoinCount = var1
	elseif var0 == GAME.GAME_ROOM_AWARD_DONE then
		if #var1 > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
			arg0.viewComponent:OnGetAwardDone(var1)
		end
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0

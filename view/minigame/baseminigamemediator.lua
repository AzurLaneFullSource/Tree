local var0_0 = class("BaseMiniGameMediator", import("..base.ContextMediator"))

var0_0.MINI_GAME_SUCCESS = "BaseMiniGameMediator:MINI_GAME_SUCCESS"
var0_0.MINI_GAME_FAILURE = "BaseMiniGameMediator:MINI_GAME_FAILURE"
var0_0.MINI_GAME_OPERATOR = "BaseMiniGameMediator:MINI_GAME_OPERATOR"
var0_0.OPEN_SUB_LAYER = "BaseMiniGameMediator:OPEN_SUB_LAYER"
var0_0.MINI_GAME_COIN = "BaseMiniGameMediator:MINI_GAME_COIN"
var0_0.COIN_WINDOW_CHANGE = "BaseMiniGameMediator:COIN_WINDOW_CHANGE"
var0_0.GAME_FINISH_TRACKING = "BaseMiniGameMediator:GAME_FINISH_TRACKING"

function var0_0.register(arg0_1)
	arg0_1.miniGameId = arg0_1.contextData.miniGameId
	arg0_1.miniGameProxy = getProxy(MiniGameProxy)

	local var0_1 = arg0_1.miniGameProxy:GetHubByGameId(arg0_1.miniGameId)
	local var1_1 = arg0_1.miniGameProxy:GetMiniGameData(arg0_1.miniGameId)

	arg0_1.viewComponent:SetMGData(var1_1)
	arg0_1.viewComponent:SetMGHubData(var0_1)
	arg0_1.miniGameProxy:RequestInitData(arg0_1.miniGameId)

	arg0_1.gameRoomId = pg.mini_game[arg0_1.miniGameId].game_room

	if arg0_1.gameRoomId and arg0_1.gameRoomId > 0 then
		arg0_1.gameRoomData = pg.game_room_template[arg0_1.gameRoomId]
		arg0_1.gameRoonCoinCount = 0

		arg0_1.viewComponent:setGameRoomData(arg0_1.gameRoomData)
	end

	arg0_1:bind(BaseMiniGameMediator.MINI_GAME_SUCCESS, function(arg0_2, ...)
		arg0_1:OnMiniGameSuccess(...)
	end)
	arg0_1:bind(BaseMiniGameMediator.MINI_GAME_FAILURE, function(arg0_3, ...)
		arg0_1:OnMiniGameFailure(...)
	end)
	arg0_1:bind(BaseMiniGameMediator.MINI_GAME_OPERATOR, function(arg0_4, ...)
		arg0_1:OnMiniGameOPeration(...)
	end)
	arg0_1:bind(BaseMiniGameMediator.OPEN_SUB_LAYER, function(arg0_5, arg1_5)
		local var0_5 = Context.New(arg1_5)

		arg0_1:addSubLayers(var0_5)
	end)
	arg0_1:bind(BaseMiniGameMediator.MINI_GAME_COIN, function(arg0_6, ...)
		arg0_1:loadCoinLayer()
	end)
	arg0_1:bind(BaseMiniGameMediator.COIN_WINDOW_CHANGE, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GameRoomCoinMediator.CHANGE_VISIBLE, arg1_7)
	end)
	arg0_1:bind(BaseMiniGameMediator.GAME_FINISH_TRACKING, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1_8.hub_id,
			cmd = MiniGameOPCommand.CMD_PLAY,
			args1 = {
				arg1_8.game_id,
				arg1_8.isComplete
			}
		})
	end)
end

function var0_0.onUIAvalible(arg0_9)
	if arg0_9.gameRoomData and arg0_9.gameRoomData.add_base > 0 then
		arg0_9:loadCoinLayer()
	end
end

function var0_0.loadCoinLayer(arg0_10)
	arg0_10.viewComponent:setCoinLayer()
	arg0_10:addSubLayers(Context.New({
		mediator = GameRoomCoinMediator,
		viewComponent = GameRoomCoinLayer,
		data = arg0_10.gameRoomData
	}))
end

function var0_0.OnMiniGameOPeration(arg0_11, ...)
	return
end

function var0_0.OnMiniGameSuccess(arg0_12, ...)
	return
end

function var0_0.OnMiniGameFailure(arg0_13, ...)
	return
end

function var0_0.listNotificationInterests(arg0_14)
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

function var0_0.handleNotification(arg0_15, arg1_15)
	local var0_15 = arg1_15:getName()
	local var1_15 = arg1_15:getBody()

	if var0_15 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		arg0_15.viewComponent:SetMGHubData(var1_15)
	elseif var0_15 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_15 = {
			function(arg0_16)
				local var0_16 = var1_15.awards

				if #var0_16 > 0 then
					arg0_15.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_16, arg0_16)
				else
					arg0_16()
				end
			end,
			function(arg0_17)
				arg0_15.viewComponent:OnGetAwardDone(var1_15)
				arg0_17()
			end
		}

		seriesAsync(var2_15)
		arg0_15.viewComponent:OnSendMiniGameOPDone(var1_15)
	elseif var0_15 == GAME.MODIFY_MINI_GAME_DATA_DONE then
		arg0_15.viewComponent:OnModifyMiniGameDataDone(var1_15)
	elseif var0_15 == GAME.ON_APPLICATION_PAUSE then
		arg0_15.viewComponent:OnApplicationPaused(var1_15)
	elseif var0_15 == GAME.GAME_COIN_COUNT_CHANGE then
		arg0_15.gameRoonCoinCount = var1_15
	elseif var0_15 == GAME.GAME_ROOM_AWARD_DONE then
		if #var1_15 > 0 then
			arg0_15.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_15)
			arg0_15.viewComponent:OnGetAwardDone(var1_15)
		end
	elseif var0_15 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		arg0_15.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_15.awards, var1_15.callback)
	end
end

return var0_0

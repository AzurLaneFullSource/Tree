local var0 = class("BaseMiniGameView", import("..base.BaseUI"))

function var0.SetExtraData(arg0, arg1)
	arg0.mg_extraData = arg1
end

function var0.GetExtraValue(arg0, arg1)
	if arg0.mg_extraData[arg1] then
		return arg0.mg_extraData[arg1]
	else
		return nil
	end
end

function var0.SetMGData(arg0, arg1)
	arg0.mg_data = arg1
end

function var0.GetMGData(arg0)
	return arg0.mg_data
end

function var0.SetMGHubData(arg0, arg1)
	arg0.mg_hubData = arg1
end

function var0.GetMGHubData(arg0)
	return arg0.mg_hubData
end

function var0.setGameRoomData(arg0, arg1)
	arg0.gameRoomData = arg1
end

function var0.getGameRoomData(arg0)
	return arg0.gameRoomData or nil
end

function var0.SendSuccess(arg0, ...)
	arg0:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, ...)
end

function var0.SendFailure(arg0, ...)
	arg0:emit(BaseMiniGameMediator.MINI_GAME_FAILURE, ...)
end

function var0.StoreDataToServer(arg0, arg1)
	if arg0.mg_data:getConfig("type") == MiniGameConst.MG_TYPE_2 then
		local var0 = {
			arg0.mg_data.id,
			2
		}

		table.insertto(var0, arg1)
		arg0.mg_data:SetRuntimeData("elements", arg1)
		arg0:emit(BaseMiniGameMediator.MINI_GAME_OPERATOR, MiniGameOPCommand.CMD_SPECIAL_GAME, var0)
	end
end

function var0.SendOperator(arg0, arg1, arg2)
	arg0:emit(BaseMiniGameMediator.MINI_GAME_OPERATOR, arg1, arg2)
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	return
end

function var0.OnModifyMiniGameDataDone(arg0, arg1)
	return
end

function var0.loadCoinLayer(arg0)
	if not arg0.coinLayer then
		arg0:emit(BaseMiniGameMediator.MINI_GAME_COIN)
	end
end

function var0.setCoinLayer(arg0)
	if arg0.coinLayer then
		return
	end

	arg0:checkTicktRemind()

	arg0.coinLayer = true
end

function var0.openCoinLayer(arg0, arg1)
	if not arg0.coinLayer then
		return
	end

	if arg1 then
		arg0:checkTicktRemind()
	end

	arg0.coinLayerVisible = arg1

	arg0:emit(BaseMiniGameMediator.COIN_WINDOW_CHANGE, arg1)
end

function var0.checkTicktRemind(arg0)
	local var0 = getProxy(GameRoomProxy):ticketMaxTip()

	if var0 and not GameRoomProxy.ticket_remind then
		GameRoomProxy.ticket_remind = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = var0,
			onYes = function()
				return
			end,
			onNo = function()
				arg0:closeView()
			end
		})
	end
end

function var0.OnGetAwardDone(arg0, arg1)
	return
end

function var0.OnApplicationPaused(arg0, arg1)
	return
end

return var0

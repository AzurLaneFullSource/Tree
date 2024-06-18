local var0_0 = class("BaseMiniGameView", import("..base.BaseUI"))

function var0_0.SetExtraData(arg0_1, arg1_1)
	arg0_1.mg_extraData = arg1_1
end

function var0_0.GetExtraValue(arg0_2, arg1_2)
	if arg0_2.mg_extraData[arg1_2] then
		return arg0_2.mg_extraData[arg1_2]
	else
		return nil
	end
end

function var0_0.SetMGData(arg0_3, arg1_3)
	arg0_3.mg_data = arg1_3
end

function var0_0.GetMGData(arg0_4)
	return arg0_4.mg_data
end

function var0_0.SetMGHubData(arg0_5, arg1_5)
	arg0_5.mg_hubData = arg1_5
end

function var0_0.GetMGHubData(arg0_6)
	return arg0_6.mg_hubData
end

function var0_0.setGameRoomData(arg0_7, arg1_7)
	arg0_7.gameRoomData = arg1_7
end

function var0_0.getGameRoomData(arg0_8)
	return arg0_8.gameRoomData or nil
end

function var0_0.SendSuccess(arg0_9, ...)
	arg0_9:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, ...)
end

function var0_0.SendFailure(arg0_10, ...)
	arg0_10:emit(BaseMiniGameMediator.MINI_GAME_FAILURE, ...)
end

function var0_0.StoreDataToServer(arg0_11, arg1_11)
	if arg0_11.mg_data:getConfig("type") == MiniGameConst.MG_TYPE_2 then
		local var0_11 = {
			arg0_11.mg_data.id,
			2
		}

		table.insertto(var0_11, arg1_11)
		arg0_11.mg_data:SetRuntimeData("elements", arg1_11)
		arg0_11:emit(BaseMiniGameMediator.MINI_GAME_OPERATOR, MiniGameOPCommand.CMD_SPECIAL_GAME, var0_11)
	end
end

function var0_0.SendOperator(arg0_12, arg1_12, arg2_12)
	arg0_12:emit(BaseMiniGameMediator.MINI_GAME_OPERATOR, arg1_12, arg2_12)
end

function var0_0.OnSendMiniGameOPDone(arg0_13, arg1_13)
	return
end

function var0_0.OnModifyMiniGameDataDone(arg0_14, arg1_14)
	return
end

function var0_0.loadCoinLayer(arg0_15)
	if not arg0_15.coinLayer then
		arg0_15:emit(BaseMiniGameMediator.MINI_GAME_COIN)
	end
end

function var0_0.setCoinLayer(arg0_16)
	if arg0_16.coinLayer then
		return
	end

	arg0_16:checkTicktRemind()

	arg0_16.coinLayer = true
end

function var0_0.openCoinLayer(arg0_17, arg1_17)
	if not arg0_17.coinLayer then
		return
	end

	if arg1_17 then
		arg0_17:checkTicktRemind()
	end

	arg0_17.coinLayerVisible = arg1_17

	arg0_17:emit(BaseMiniGameMediator.COIN_WINDOW_CHANGE, arg1_17)
end

function var0_0.checkTicktRemind(arg0_18)
	local var0_18 = getProxy(GameRoomProxy):ticketMaxTip()

	if var0_18 and not GameRoomProxy.ticket_remind then
		GameRoomProxy.ticket_remind = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = var0_18,
			onYes = function()
				return
			end,
			onNo = function()
				arg0_18:closeView()
			end
		})
	end
end

function var0_0.OnGetAwardDone(arg0_21, arg1_21)
	return
end

function var0_0.OnApplicationPaused(arg0_22, arg1_22)
	return
end

return var0_0

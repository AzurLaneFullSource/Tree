local var0_0 = class("GameRoomFushun2View", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "GameRoomFushun2UI"
end

function var0_0.getBGM(arg0_2)
	return FushunAdventureGameConst.BGM_NAME
end

function var0_0.didEnter(arg0_3)
	arg0_3.game = FushunAdventureGame.New(arg0_3._go, arg0_3:GetMGHubData(), arg0_3:GetMGData())

	arg0_3.game:SetGameStateCallback(function()
		arg0_3:openCoinLayer(false)
	end, function()
		arg0_3:openCoinLayer(true)
	end)
	arg0_3.game:SetOnShowResult(function(arg0_6)
		local var0_6 = arg0_3:GetMGHubData()

		arg0_3:SendSuccess(arg0_6)
	end)
	arg0_3.game:SetOnLevelUpdate(function()
		arg0_3:CheckAaward()
	end)
	arg0_3.game:setRoomTip(arg0_3:getGameRoomData().game_help)
	arg0_3.game:setRoomId(arg0_3:getGameRoomData().id)
	onButton(arg0_3, findTF(arg0_3._go, "back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	arg0_3:CheckAaward()
end

function var0_0.CheckAaward(arg0_9)
	return
end

function var0_0.willExit(arg0_10)
	if arg0_10.game then
		arg0_10.game:Dispose()

		arg0_10.game = nil
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_11)
	if arg0_11.game then
		arg0_11.game:RefreshLevels()
	end
end

function var0_0.onBackPressed(arg0_12)
	if arg0_12.game and arg0_12.game:IsStarting() then
		arg0_12.game:ShowPauseMsgbox()
	end
end

return var0_0

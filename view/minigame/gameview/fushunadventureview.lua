local var0_0 = class("FushunAdventureView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "FushunAdventureUI"
end

function var0_0.getBGM(arg0_2)
	return FushunAdventureGameConst.BGM_NAME
end

function var0_0.didEnter(arg0_3)
	arg0_3.game = FushunAdventureGame.New(arg0_3._go, arg0_3:GetMGHubData(), arg0_3:GetMGData())

	arg0_3.game:SetOnShowResult(function(arg0_4)
		if arg0_3:GetMGHubData().count > 0 then
			arg0_3:SendSuccess(0)
		end

		if arg0_4 > ((arg0_3:GetMGData():GetRuntimeData("elements") or {})[1] or 0) then
			arg0_3:StoreDataToServer({
				arg0_4
			})
		end
	end)
	arg0_3.game:SetOnLevelUpdate(function()
		arg0_3:CheckAaward()
	end)
	onButton(arg0_3, findTF(arg0_3._go, "back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	arg0_3:CheckAaward()
end

function var0_0.CheckAaward(arg0_7)
	local var0_7 = arg0_7:GetMGHubData()
	local var1_7 = var0_7.ultimate
	local var2_7 = var0_7.usedtime
	local var3_7 = var0_7:getConfig("reward_need")

	if var1_7 == 0 and var3_7 <= var2_7 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_7.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.willExit(arg0_8)
	if arg0_8.game then
		arg0_8.game:Dispose()

		arg0_8.game = nil
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_9)
	if arg0_9.game then
		arg0_9.game:RefreshLevels()
	end
end

function var0_0.onBackPressed(arg0_10)
	if arg0_10.game and arg0_10.game:IsStarting() then
		arg0_10.game:ShowPauseMsgbox()
	end
end

return var0_0

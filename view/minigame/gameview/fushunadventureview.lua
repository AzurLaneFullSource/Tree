local var0 = class("FushunAdventureView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "FushunAdventureUI"
end

function var0.getBGM(arg0)
	return FushunAdventureGameConst.BGM_NAME
end

function var0.didEnter(arg0)
	arg0.game = FushunAdventureGame.New(arg0._go, arg0:GetMGHubData(), arg0:GetMGData())

	arg0.game:SetOnShowResult(function(arg0)
		if arg0:GetMGHubData().count > 0 then
			arg0:SendSuccess(0)
		end

		if arg0 > ((arg0:GetMGData():GetRuntimeData("elements") or {})[1] or 0) then
			arg0:StoreDataToServer({
				arg0
			})
		end
	end)
	arg0.game:SetOnLevelUpdate(function()
		arg0:CheckAaward()
	end)
	onButton(arg0, findTF(arg0._go, "back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	arg0:CheckAaward()
end

function var0.CheckAaward(arg0)
	local var0 = arg0:GetMGHubData()
	local var1 = var0.ultimate
	local var2 = var0.usedtime
	local var3 = var0:getConfig("reward_need")

	if var1 == 0 and var3 <= var2 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.willExit(arg0)
	if arg0.game then
		arg0.game:Dispose()

		arg0.game = nil
	end
end

function var0.OnSendMiniGameOPDone(arg0)
	if arg0.game then
		arg0.game:RefreshLevels()
	end
end

function var0.onBackPressed(arg0)
	if arg0.game and arg0.game:IsStarting() then
		arg0.game:ShowPauseMsgbox()
	end
end

return var0

local var0 = class("Z28SkinPage", import(".NewYearSnackPage"))

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_id")
	local var1 = getProxy(MiniGameProxy):GetHubByHubId(var0)

	arg0.needCount = var1:getConfig("reward_need")
	arg0.leftCount = var1.count
	arg0.playedCount = var1.usedtime
	arg0.isGotAward = var1.ultimate > 0
	arg0.curDay = arg0.leftCount + arg0.playedCount
end

function var0.OnFirstFlush(arg0)
	arg0.progressUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0:findTF("Locked", arg2)
			local var1 = arg0:findTF("Unlocked", arg2)
			local var2 = arg0:findTF("Finished", arg2)
			local var3 = arg0:findTF("FinalFinished", arg2)

			setActive(var0, arg1 > arg0.curDay)

			if arg1 <= arg0.curDay then
				setActive(var1, arg1 > arg0.playedCount)
				setActive(var2, arg1 <= arg0.playedCount and arg1 ~= arg0.needCount)
				setActive(var3, arg1 <= arg0.playedCount and arg1 == arg0.needCount)
			else
				setActive(var1, false)
				setActive(var2, false)
				setActive(var3, false)
			end
		end
	end)

	local var0 = 36

	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0, {
			callback = function()
				local var0 = Context.New()

				SCENE.SetSceneInfo(var0, SCENE.NEWYEAR_BACKHILL_2022)
				getProxy(ContextProxy):PushContext2Prev(var0)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_xinnian2022_z28")
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	arg0.progressUIItemList:align(arg0.needCount)
	arg0:tryGetFinalAward()
end

function var0.OnDestroy(arg0)
	return
end

function var0.tryGetFinalAward(arg0)
	local var0 = arg0.activity:getConfig("config_id")
	local var1 = getProxy(MiniGameProxy):GetHubByHubId(var0)
	local var2 = var1.usedtime
	local var3 = var1:getConfig("reward_need")
	local var4 = var1.ultimate > 0

	if var3 <= var2 and not var4 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var1.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0

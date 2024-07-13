local var0_0 = class("Z28SkinPage", import(".NewYearSnackPage"))

function var0_0.OnDataSetting(arg0_1)
	local var0_1 = arg0_1.activity:getConfig("config_id")
	local var1_1 = getProxy(MiniGameProxy):GetHubByHubId(var0_1)

	arg0_1.needCount = var1_1:getConfig("reward_need")
	arg0_1.leftCount = var1_1.count
	arg0_1.playedCount = var1_1.usedtime
	arg0_1.isGotAward = var1_1.ultimate > 0
	arg0_1.curDay = arg0_1.leftCount + arg0_1.playedCount
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.progressUIItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg1_3 = arg1_3 + 1

			local var0_3 = arg0_2:findTF("Locked", arg2_3)
			local var1_3 = arg0_2:findTF("Unlocked", arg2_3)
			local var2_3 = arg0_2:findTF("Finished", arg2_3)
			local var3_3 = arg0_2:findTF("FinalFinished", arg2_3)

			setActive(var0_3, arg1_3 > arg0_2.curDay)

			if arg1_3 <= arg0_2.curDay then
				setActive(var1_3, arg1_3 > arg0_2.playedCount)
				setActive(var2_3, arg1_3 <= arg0_2.playedCount and arg1_3 ~= arg0_2.needCount)
				setActive(var3_3, arg1_3 <= arg0_2.playedCount and arg1_3 == arg0_2.needCount)
			else
				setActive(var1_3, false)
				setActive(var2_3, false)
				setActive(var3_3, false)
			end
		end
	end)

	local var0_2 = 36

	onButton(arg0_2, arg0_2.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_2, {
			callback = function()
				local var0_5 = Context.New()

				SCENE.SetSceneInfo(var0_5, SCENE.NEWYEAR_BACKHILL_2022)
				getProxy(ContextProxy):PushContext2Prev(var0_5)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_xinnian2022_z28")
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7.progressUIItemList:align(arg0_7.needCount)
	arg0_7:tryGetFinalAward()
end

function var0_0.OnDestroy(arg0_8)
	return
end

function var0_0.tryGetFinalAward(arg0_9)
	local var0_9 = arg0_9.activity:getConfig("config_id")
	local var1_9 = getProxy(MiniGameProxy):GetHubByHubId(var0_9)
	local var2_9 = var1_9.usedtime
	local var3_9 = var1_9:getConfig("reward_need")
	local var4_9 = var1_9.ultimate > 0

	if var3_9 <= var2_9 and not var4_9 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var1_9.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

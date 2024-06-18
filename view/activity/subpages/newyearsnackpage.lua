local var0_0 = class("NewYearSnackPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.progressTpl = arg0_1:findTF("ProgressTpl")
	arg0_1.progressTplContainer = arg0_1:findTF("ProgressList")
	arg0_1.progressUIItemList = UIItemList.New(arg0_1.progressTplContainer, arg0_1.progressTpl)
	arg0_1.helpBtn = arg0_1:findTF("HelpBtn")
	arg0_1.goBtn = arg0_1:findTF("GoBtn")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").linkMiniGameID
	local var1_2 = getProxy(MiniGameProxy):GetMiniGameData(var0_2):getConfig("hub_id")
	local var2_2 = getProxy(MiniGameProxy):GetHubByHubId(var1_2)

	arg0_2.needCount = var2_2:getConfig("reward_need")
	arg0_2.leftCount = var2_2.count
	arg0_2.playedCount = var2_2.usedtime
	arg0_2.isGotAward = var2_2.ultimate > 0
	arg0_2.curDay = arg0_2.leftCount + arg0_2.playedCount
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.progressUIItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg1_4 = arg1_4 + 1

			local var0_4 = arg0_3:findTF("Locked", arg2_4)
			local var1_4 = arg0_3:findTF("Unlocked", arg2_4)
			local var2_4 = arg0_3:findTF("Finished", arg2_4)
			local var3_4 = arg0_3:findTF("FinalFinished", arg2_4)

			setActive(var0_4, arg1_4 > arg0_3.curDay)

			if arg1_4 <= arg0_3.curDay then
				setActive(var1_4, arg1_4 > arg0_3.playedCount)
				setActive(var2_4, arg1_4 <= arg0_3.playedCount and arg1_4 ~= arg0_3.needCount)
				setActive(var3_4, arg1_4 <= arg0_3.playedCount and arg1_4 == arg0_3.needCount)
			else
				setActive(var1_4, false)
				setActive(var2_4, false)
				setActive(var3_4, false)
			end
		end
	end)
	arg0_3.progressUIItemList:align(arg0_3.needCount)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 19, {
			callback = function()
				local var0_6 = Context.New()

				SCENE.SetSceneInfo(var0_6, SCENE.NEWYEAR_BACKHILL)
				getProxy(ContextProxy):PushContext2Prev(var0_6)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_xinnian2021__meishiyemian")
		})
	end, SFX_PANEL)
	arg0_3:tryGetFinalAward()
end

function var0_0.OnUpdateFlush(arg0_8)
	return
end

function var0_0.OnDestroy(arg0_9)
	return
end

function var0_0.tryGetFinalAward(arg0_10)
	local var0_10 = arg0_10.activity:getConfig("config_client").linkMiniGameID
	local var1_10 = getProxy(MiniGameProxy):GetMiniGameData(var0_10):getConfig("hub_id")
	local var2_10 = getProxy(MiniGameProxy):GetHubByHubId(var1_10)
	local var3_10 = var2_10.usedtime
	local var4_10 = var2_10:getConfig("reward_need")
	local var5_10 = var2_10.ultimate > 0

	if var4_10 <= var3_10 and not var5_10 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var2_10.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.IsTip()
	local var0_11 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id)

	if var0_11 and not var0_11:isEnd() then
		local var1_11 = var0_11:getConfig("config_client").linkMiniGameID
		local var2_11 = getProxy(MiniGameProxy):GetMiniGameData(var1_11):getConfig("hub_id")
		local var3_11 = getProxy(MiniGameProxy):GetHubByHubId(var2_11)
		local var4_11 = var3_11.usedtime
		local var5_11 = var3_11:getConfig("reward_need")
		local var6_11 = var3_11.ultimate > 0

		if var5_11 <= var4_11 and not var6_11 then
			return true
		elseif var3_11.count > 0 then
			return true
		else
			return false
		end
	end
end

return var0_0

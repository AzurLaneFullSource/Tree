local var0 = class("NewYearSnackPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.progressTpl = arg0:findTF("ProgressTpl")
	arg0.progressTplContainer = arg0:findTF("ProgressList")
	arg0.progressUIItemList = UIItemList.New(arg0.progressTplContainer, arg0.progressTpl)
	arg0.helpBtn = arg0:findTF("HelpBtn")
	arg0.goBtn = arg0:findTF("GoBtn")
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_client").linkMiniGameID
	local var1 = getProxy(MiniGameProxy):GetMiniGameData(var0):getConfig("hub_id")
	local var2 = getProxy(MiniGameProxy):GetHubByHubId(var1)

	arg0.needCount = var2:getConfig("reward_need")
	arg0.leftCount = var2.count
	arg0.playedCount = var2.usedtime
	arg0.isGotAward = var2.ultimate > 0
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
	arg0.progressUIItemList:align(arg0.needCount)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 19, {
			callback = function()
				local var0 = Context.New()

				SCENE.SetSceneInfo(var0, SCENE.NEWYEAR_BACKHILL)
				getProxy(ContextProxy):PushContext2Prev(var0)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_xinnian2021__meishiyemian")
		})
	end, SFX_PANEL)
	arg0:tryGetFinalAward()
end

function var0.OnUpdateFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

function var0.tryGetFinalAward(arg0)
	local var0 = arg0.activity:getConfig("config_client").linkMiniGameID
	local var1 = getProxy(MiniGameProxy):GetMiniGameData(var0):getConfig("hub_id")
	local var2 = getProxy(MiniGameProxy):GetHubByHubId(var1)
	local var3 = var2.usedtime
	local var4 = var2:getConfig("reward_need")
	local var5 = var2.ultimate > 0

	if var4 <= var3 and not var5 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var2.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_client").linkMiniGameID
		local var2 = getProxy(MiniGameProxy):GetMiniGameData(var1):getConfig("hub_id")
		local var3 = getProxy(MiniGameProxy):GetHubByHubId(var2)
		local var4 = var3.usedtime
		local var5 = var3:getConfig("reward_need")
		local var6 = var3.ultimate > 0

		if var5 <= var4 and not var6 then
			return true
		elseif var3.count > 0 then
			return true
		else
			return false
		end
	end
end

return var0

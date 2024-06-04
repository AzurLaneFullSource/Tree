local var0 = class("CurlingGamePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.progressTpl = arg0:findTF("ProgressTpl")
	arg0.progressTplContainer = arg0:findTF("ProgressList")
	arg0.progressUIItemList = UIItemList.New(arg0.progressTplContainer, arg0.progressTpl)
	arg0.goBtn = arg0:findTF("GoBtn")
end

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

			local var0 = arg0:findTF("Unlocked", arg2)
			local var1 = arg0:findTF("Finished", arg2)
			local var2 = arg0:findTF("Current", arg2)

			setActive(var2, arg1 == arg0.playedCount)

			if arg1 <= arg0.curDay then
				setActive(var0, arg1 > arg0.playedCount)
				setActive(var1, arg1 <= arg0.playedCount and arg1 ~= arg0.needCount)
			else
				setActive(var0, false)
				setActive(var1, false)
			end
		end
	end)
	arg0.progressUIItemList:align(arg0.needCount)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 33)
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

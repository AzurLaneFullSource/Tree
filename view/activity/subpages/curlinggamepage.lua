local var0_0 = class("CurlingGamePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.progressTpl = arg0_1:findTF("ProgressTpl")
	arg0_1.progressTplContainer = arg0_1:findTF("ProgressList")
	arg0_1.progressUIItemList = UIItemList.New(arg0_1.progressTplContainer, arg0_1.progressTpl)
	arg0_1.goBtn = arg0_1:findTF("GoBtn")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_id")
	local var1_2 = getProxy(MiniGameProxy):GetHubByHubId(var0_2)

	arg0_2.needCount = var1_2:getConfig("reward_need")
	arg0_2.leftCount = var1_2.count
	arg0_2.playedCount = var1_2.usedtime
	arg0_2.isGotAward = var1_2.ultimate > 0
	arg0_2.curDay = arg0_2.leftCount + arg0_2.playedCount
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.progressUIItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg1_4 = arg1_4 + 1

			local var0_4 = arg0_3:findTF("Unlocked", arg2_4)
			local var1_4 = arg0_3:findTF("Finished", arg2_4)
			local var2_4 = arg0_3:findTF("Current", arg2_4)

			setActive(var2_4, arg1_4 == arg0_3.playedCount)

			if arg1_4 <= arg0_3.curDay then
				setActive(var0_4, arg1_4 > arg0_3.playedCount)
				setActive(var1_4, arg1_4 <= arg0_3.playedCount and arg1_4 ~= arg0_3.needCount)
			else
				setActive(var0_4, false)
				setActive(var1_4, false)
			end
		end
	end)
	arg0_3.progressUIItemList:align(arg0_3.needCount)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 33)
	end, SFX_PANEL)
	arg0_3:tryGetFinalAward()
end

function var0_0.OnUpdateFlush(arg0_6)
	return
end

function var0_0.OnDestroy(arg0_7)
	return
end

function var0_0.tryGetFinalAward(arg0_8)
	local var0_8 = arg0_8.activity:getConfig("config_id")
	local var1_8 = getProxy(MiniGameProxy):GetHubByHubId(var0_8)
	local var2_8 = var1_8.usedtime
	local var3_8 = var1_8:getConfig("reward_need")
	local var4_8 = var1_8.ultimate > 0

	if var3_8 <= var2_8 and not var4_8 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var1_8.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

local var0_0 = class("SeventhInvitePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.rtMarks = arg0_1._tf:Find("AD/progress")
	arg0_1.rtFinish = arg0_1._tf:Find("AD/award")
	arg0_1.rtBtns = arg0_1._tf:Find("AD/btn_list")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.gameId = arg0_2.activity:getConfig("config_client").mini_game_id
	arg0_2.hubId = pg.mini_game[arg0_2.gameId].hub_id
	arg0_2.data = getProxy(MiniGameProxy):GetHubByHubId(arg0_2.hubId)
	arg0_2.ultimate = arg0_2.data.ultimate
	arg0_2.usedtime = arg0_2.data.usedtime
	arg0_2.maxtime = arg0_2.data:getConfig("reward_need")
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.rtBtns:Find("go"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg0_3.gameId)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rtBtns:Find("get"), function()
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_3.hubId,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.maxtime
	local var1_6 = arg0_6.usedtime
	local var2_6 = arg0_6.rtMarks.childCount

	for iter0_6 = 1, var2_6 do
		local var3_6 = arg0_6.rtMarks:GetChild(iter0_6 - 1)

		setActive(var3_6:Find("mark"), iter0_6 <= var1_6)
		setActive(var3_6:Find("icon"), iter0_6 == var1_6 and arg0_6.ultimate == 0)
	end

	setActive(arg0_6.rtFinish:Find("got"), arg0_6.ultimate == 1)
	setActive(arg0_6.rtBtns:Find("get"), arg0_6.ultimate == 0 and var1_6 == var0_6)
	setActive(arg0_6.rtBtns:Find("got"), arg0_6.ultimate == 1)
	setActive(arg0_6.rtBtns:Find("go"), var1_6 < var0_6)
	setActive(arg0_6.rtBtns:Find("red"), var1_6 <= var0_6 and arg0_6.ultimate ~= 1 and arg0_6.data.count > 0)
end

return var0_0

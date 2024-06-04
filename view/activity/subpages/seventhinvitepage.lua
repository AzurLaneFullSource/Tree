local var0 = class("SeventhInvitePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.rtMarks = arg0._tf:Find("AD/progress")
	arg0.rtFinish = arg0._tf:Find("AD/award")
	arg0.rtBtns = arg0._tf:Find("AD/btn_list")
end

function var0.OnDataSetting(arg0)
	arg0.gameId = arg0.activity:getConfig("config_client").mini_game_id
	arg0.hubId = pg.mini_game[arg0.gameId].hub_id
	arg0.data = getProxy(MiniGameProxy):GetHubByHubId(arg0.hubId)
	arg0.ultimate = arg0.data.ultimate
	arg0.usedtime = arg0.data.usedtime
	arg0.maxtime = arg0.data:getConfig("reward_need")
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.rtBtns:Find("go"), function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg0.gameId)
	end, SFX_PANEL)
	onButton(arg0, arg0.rtBtns:Find("get"), function()
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0.hubId,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.maxtime
	local var1 = arg0.usedtime
	local var2 = arg0.rtMarks.childCount

	for iter0 = 1, var2 do
		local var3 = arg0.rtMarks:GetChild(iter0 - 1)

		setActive(var3:Find("mark"), iter0 <= var1)
		setActive(var3:Find("icon"), iter0 == var1 and arg0.ultimate == 0)
	end

	setActive(arg0.rtFinish:Find("got"), arg0.ultimate == 1)
	setActive(arg0.rtBtns:Find("get"), arg0.ultimate == 0 and var1 == var0)
	setActive(arg0.rtBtns:Find("got"), arg0.ultimate == 1)
	setActive(arg0.rtBtns:Find("go"), var1 < var0)
	setActive(arg0.rtBtns:Find("red"), var1 <= var0 and arg0.ultimate ~= 1 and arg0.data.count > 0)
end

return var0

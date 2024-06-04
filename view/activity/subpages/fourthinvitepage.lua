local var0 = class("FourthInvitePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.icons = {
		arg0:findTF("AD/bg/npc1"),
		arg0:findTF("AD/bg/npc2"),
		arg0:findTF("AD/bg/npc3"),
		arg0:findTF("AD/bg/npc4"),
		arg0:findTF("AD/bg/npc5"),
		arg0:findTF("AD/bg/npc6"),
		arg0:findTF("AD/bg/npc7")
	}
	arg0.helpBtn = arg0:findTF("AD/help")
	arg0.goBtn = arg0:findTF("AD/go")
	arg0.gotBtn = arg0:findTF("AD/got")
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
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg0.gameId)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.catchteasure_help.tip
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	SetActive(arg0.gotBtn, arg0.ultimate == 1)
	arg0:UpdateSigned()
	arg0:CheckGet()
end

function var0.UpdateSigned(arg0)
	local var0 = arg0.maxtime
	local var1 = arg0.usedtime

	for iter0, iter1 in ipairs(arg0.icons) do
		local var2 = iter0 <= var1

		setActive(iter1, var2)
	end
end

function var0.CheckGet(arg0)
	if arg0.ultimate == 0 then
		if arg0.maxtime > arg0.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0.hubId,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0

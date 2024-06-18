local var0_0 = class("FourthInvitePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.icons = {
		arg0_1:findTF("AD/bg/npc1"),
		arg0_1:findTF("AD/bg/npc2"),
		arg0_1:findTF("AD/bg/npc3"),
		arg0_1:findTF("AD/bg/npc4"),
		arg0_1:findTF("AD/bg/npc5"),
		arg0_1:findTF("AD/bg/npc6"),
		arg0_1:findTF("AD/bg/npc7")
	}
	arg0_1.helpBtn = arg0_1:findTF("AD/help")
	arg0_1.goBtn = arg0_1:findTF("AD/go")
	arg0_1.gotBtn = arg0_1:findTF("AD/got")
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
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg0_3.gameId)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.catchteasure_help.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	SetActive(arg0_6.gotBtn, arg0_6.ultimate == 1)
	arg0_6:UpdateSigned()
	arg0_6:CheckGet()
end

function var0_0.UpdateSigned(arg0_7)
	local var0_7 = arg0_7.maxtime
	local var1_7 = arg0_7.usedtime

	for iter0_7, iter1_7 in ipairs(arg0_7.icons) do
		local var2_7 = iter0_7 <= var1_7

		setActive(iter1_7, var2_7)
	end
end

function var0_0.CheckGet(arg0_8)
	if arg0_8.ultimate == 0 then
		if arg0_8.maxtime > arg0_8.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_8.hubId,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

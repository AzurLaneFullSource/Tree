local var0_0 = class("RollingBallPage", import("...base.BaseActivityPage"))

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
end

function var0_0.SetData(arg0_2)
	local var0_2 = getProxy(MiniGameProxy):GetHubByHubId(10)

	arg0_2.data = var0_2
	arg0_2.ultimate = var0_2.ultimate
	arg0_2.usedtime = var0_2.usedtime
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3:SetData()
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 14)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.rolling_ball_help.tip
		})
	end, SFX_PANEL)
	arg0_3:UpdateSigned()
	arg0_3:CheckGet()
end

function var0_0.UpdateSigned(arg0_6)
	local var0_6 = arg0_6.data:getConfig("reward_need")
	local var1_6 = arg0_6.usedtime
	local var2_6

	var2_6 = arg0_6.ultimate == 0

	for iter0_6, iter1_6 in ipairs(arg0_6.icons) do
		local var3_6 = iter0_6 <= var1_6

		setActive(iter1_6, var3_6)
	end
end

function var0_0.CheckGet(arg0_7)
	if arg0_7.ultimate == 0 then
		if arg0_7.data:getConfig("reward_need") > arg0_7.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 10,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

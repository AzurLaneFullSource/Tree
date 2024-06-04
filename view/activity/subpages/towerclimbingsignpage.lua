local var0 = class("TowerClimbingSignPage", import("...base.BaseActivityPage"))

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
end

function var0.SetData(arg0)
	local var0 = getProxy(MiniGameProxy):GetHubByHubId(9)

	arg0.data = var0
	arg0.ultimate = var0.ultimate
	arg0.usedtime = var0.usedtime
end

function var0.OnFirstFlush(arg0)
	arg0:SetData()
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 13)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.towerclimbing_sign_help.tip
		})
	end, SFX_PANEL)
	arg0:UpdateSigned()
	arg0:CheckGet()
end

function var0.UpdateSigned(arg0)
	local var0 = arg0.data:getConfig("reward_need")
	local var1 = arg0.usedtime
	local var2

	var2 = arg0.ultimate == 0

	for iter0, iter1 in ipairs(arg0.icons) do
		local var3 = iter0 <= var1

		setActive(iter1, var3)
	end
end

function var0.CheckGet(arg0)
	if arg0.ultimate == 0 then
		if arg0.data:getConfig("reward_need") > arg0.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = 9,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0

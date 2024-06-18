local var0_0 = class("SignHalloweenPage", import("...base.BaseActivityPage"))
local var1_0 = 15

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
	arg0_1.opens = {
		arg0_1:findTF("AD/bg/open1"),
		arg0_1:findTF("AD/bg/open2"),
		arg0_1:findTF("AD/bg/open3"),
		arg0_1:findTF("AD/bg/open4"),
		arg0_1:findTF("AD/bg/open5"),
		arg0_1:findTF("AD/bg/open6"),
		arg0_1:findTF("AD/bg/open7")
	}
	arg0_1.helpBtn = arg0_1:findTF("AD/help")
	arg0_1.goBtn = arg0_1:findTF("AD/go")
end

function var0_0.SetData(arg0_2)
	local var0_2 = getProxy(MiniGameProxy)

	arg0_2.hubId = arg0_2.activity:getConfig("config_id")

	local var1_2 = var0_2:GetHubByHubId(arg0_2.hubId)

	arg0_2.data = var1_2
	arg0_2.ultimate = var1_2.ultimate
	arg0_2.usedtime = var1_2.usedtime
	arg0_2.count = var1_2.count
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3:SetData()
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_0)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_candymagic.tip
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

	local var3_6 = var1_6 + arg0_6.count

	for iter0_6, iter1_6 in ipairs(arg0_6.icons) do
		local var4_6 = iter0_6 <= var1_6
		local var5_6 = iter0_6 <= var3_6

		setActive(arg0_6.icons[iter0_6], false)
		setActive(arg0_6.opens[iter0_6], false)

		if var4_6 then
			setActive(arg0_6.icons[iter0_6], var4_6)
		elseif var5_6 then
			setActive(arg0_6.opens[iter0_6], var5_6)
		end
	end
end

function var0_0.CheckGet(arg0_7)
	if arg0_7.ultimate == 0 then
		if arg0_7.data:getConfig("reward_need") > arg0_7.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_7.hubId,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

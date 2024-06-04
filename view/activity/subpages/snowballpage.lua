local var0 = class("SnowballPage", import("...base.BaseActivityPage"))
local var1 = 14
local var2 = 18

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
	arg0.opens = {
		arg0:findTF("AD/bg/open1"),
		arg0:findTF("AD/bg/open2"),
		arg0:findTF("AD/bg/open3"),
		arg0:findTF("AD/bg/open4"),
		arg0:findTF("AD/bg/open5"),
		arg0:findTF("AD/bg/open6"),
		arg0:findTF("AD/bg/open7")
	}
	arg0.helpBtn = arg0:findTF("AD/help")
	arg0.goBtn = arg0:findTF("AD/go")
end

function var0.SetData(arg0)
	local var0 = getProxy(MiniGameProxy):GetHubByHubId(var1)

	arg0.data = var0
	arg0.ultimate = var0.ultimate
	arg0.usedtime = var0.usedtime
	arg0.count = var0.count
end

function var0.OnFirstFlush(arg0)
	arg0:SetData()
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var2)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_candymagic.tip
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

	local var3 = var1 + arg0.count

	for iter0, iter1 in ipairs(arg0.icons) do
		local var4 = iter0 <= var1
		local var5 = iter0 <= var3

		setActive(arg0.icons[iter0], false)
		setActive(arg0.opens[iter0], false)

		if var4 then
			setActive(arg0.icons[iter0], var4)
		elseif var5 then
			setActive(arg0.opens[iter0], var5)
		end
	end
end

function var0.CheckGet(arg0)
	if arg0.ultimate == 0 then
		if arg0.data:getConfig("reward_need") > arg0.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var1,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0

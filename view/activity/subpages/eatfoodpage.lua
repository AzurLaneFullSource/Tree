local var0_0 = class("EatFoodPage", import("...base.BaseActivityPage"))
local var1_0 = 35
local var2_0 = 31

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
	arg0_1.locks = {
		arg0_1:findTF("AD/bg/lock1"),
		arg0_1:findTF("AD/bg/lock2"),
		arg0_1:findTF("AD/bg/lock3"),
		arg0_1:findTF("AD/bg/lock4"),
		arg0_1:findTF("AD/bg/lock5"),
		arg0_1:findTF("AD/bg/lock6"),
		arg0_1:findTF("AD/bg/lock7")
	}
	arg0_1.helpBtn = arg0_1:findTF("AD/help")
	arg0_1.goBtn = arg0_1:findTF("AD/go")

	local var0_1 = pg.mini_game_hub[var1_0].reward_display
	local var1_1 = Drop.Create(var0_1)
	local var2_1 = arg0_1:findTF("AD/btnFinalAward")

	onButton(arg0_1, var2_1, function()
		arg0_1:emit(BaseUI.ON_DROP, var1_1)
	end, SFX_PANEL)
end

function var0_0.SetData(arg0_3)
	local var0_3 = getProxy(MiniGameProxy):GetHubByHubId(var1_0)

	arg0_3.data = var0_3
	arg0_3.ultimate = var0_3.ultimate
	arg0_3.usedtime = var0_3.usedtime
	arg0_3.count = var0_3.count
end

function var0_0.OnFirstFlush(arg0_4)
	arg0_4:SetData()
	onButton(arg0_4, arg0_4.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var2_0)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.eatgame_tips.tip
		})
	end, SFX_PANEL)
	arg0_4:UpdateSigned()
	arg0_4:CheckGet()
end

function var0_0.UpdateSigned(arg0_7)
	local var0_7 = arg0_7.data:getConfig("reward_need")
	local var1_7 = arg0_7.usedtime
	local var2_7

	var2_7 = arg0_7.ultimate == 0

	local var3_7 = var1_7 + arg0_7.count

	for iter0_7, iter1_7 in ipairs(arg0_7.icons) do
		local var4_7 = iter0_7 <= var1_7
		local var5_7 = iter0_7 <= var3_7

		setActive(arg0_7.icons[iter0_7], false)
		setActive(arg0_7.locks[iter0_7], false)

		if var4_7 then
			setActive(arg0_7.icons[iter0_7], var4_7)
		elseif not var5_7 then
			setActive(arg0_7.locks[iter0_7], not var5_7)
		end
	end
end

function var0_0.CheckGet(arg0_8)
	if arg0_8.ultimate == 0 then
		if arg0_8.data:getConfig("reward_need") > arg0_8.usedtime then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var1_0,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

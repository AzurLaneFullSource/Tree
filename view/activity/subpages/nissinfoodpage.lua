local var0_0 = class("NissinFoodPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.startBtn = arg0_1:findTF("start_btn", arg0_1.bg)
	arg0_1.cupList = arg0_1:findTF("cup_list", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.hubID = arg0_2.activity:getConfig("config_id")
	arg0_2.drop_list = arg0_2.activity:getConfig("config_client")

	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("chazi_tips")
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.startBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 29)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = getProxy(MiniGameProxy):GetHubByHubId(arg0_5.hubID)

	eachChild(arg0_5.cupList, function(arg0_6)
		local var0_6 = tonumber(arg0_6.name)

		setActive(arg0_5:findTF("lock", arg0_6), var0_6 > var0_5.count + var0_5.usedtime)
		setActive(arg0_5:findTF("got", arg0_6), var0_6 <= var0_5.usedtime)

		local var1_6 = arg0_5:findTF("mask/award", arg0_6)
		local var2_6 = arg0_5.drop_list[var0_6]
		local var3_6 = {
			type = var2_6[1],
			id = var2_6[2],
			count = var2_6[3]
		}

		updateDrop(var1_6, var3_6)
		onButton(arg0_5, var1_6, function()
			arg0_5:emit(BaseUI.ON_DROP, var3_6)
		end, SFX_PANEL)
	end)

	if var0_5.ultimate == 0 and var0_5.usedtime >= var0_5:getConfig("reward_need") then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_5.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0_0

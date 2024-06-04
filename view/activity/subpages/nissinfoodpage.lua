local var0 = class("NissinFoodPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.startBtn = arg0:findTF("start_btn", arg0.bg)
	arg0.cupList = arg0:findTF("cup_list", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	arg0.hubID = arg0.activity:getConfig("config_id")
	arg0.drop_list = arg0.activity:getConfig("config_client")

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("chazi_tips")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 29)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = getProxy(MiniGameProxy):GetHubByHubId(arg0.hubID)

	eachChild(arg0.cupList, function(arg0)
		local var0 = tonumber(arg0.name)

		setActive(arg0:findTF("lock", arg0), var0 > var0.count + var0.usedtime)
		setActive(arg0:findTF("got", arg0), var0 <= var0.usedtime)

		local var1 = arg0:findTF("mask/award", arg0)
		local var2 = arg0.drop_list[var0]
		local var3 = {
			type = var2[1],
			id = var2[2],
			count = var2[3]
		}

		updateDrop(var1, var3)
		onButton(arg0, var1, function()
			arg0:emit(BaseUI.ON_DROP, var3)
		end, SFX_PANEL)
	end)

	if var0.ultimate == 0 and var0.usedtime >= var0:getConfig("reward_need") then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return var0

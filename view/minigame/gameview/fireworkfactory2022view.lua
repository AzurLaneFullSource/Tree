local var0_0 = class("FireworkFactory2022View", import(".FireworkFactoryView"))

function var0_0.getUIName(arg0_1)
	return "FireworkFactory2022UI"
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	onButton(arg0_2, arg0_2.btn_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2022_firework.tip
		})
	end)
end

return var0_0

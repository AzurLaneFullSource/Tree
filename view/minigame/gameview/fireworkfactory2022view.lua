local var0 = class("FireworkFactory2022View", import(".FireworkFactoryView"))

function var0.getUIName(arg0)
	return "FireworkFactory2022UI"
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	onButton(arg0, arg0.btn_help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2022_firework.tip
		})
	end)
end

return var0

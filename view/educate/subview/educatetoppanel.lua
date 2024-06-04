local var0 = class("EducateTopPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateTopPanel"
end

function var0.OnInit(arg0)
	arg0.helpBtn = arg0:findTF("content/btns/help")
	arg0.homeBtn = arg0:findTF("content/btns/home")
	arg0.refresh = arg0:findTF("content/btns/refresh")

	arg0:addListener()
end

function var0.addListener(arg0)
	onButton(arg0, arg0.refresh, function()
		arg0:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_refresh_sure_tip"),
			onYes = function()
				pg.m02:sendNotification(GAME.EDUCATE_REFRESH)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child_main_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(EducateBaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	return
end

return var0

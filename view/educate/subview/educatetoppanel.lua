local var0_0 = class("EducateTopPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateTopPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.helpBtn = arg0_2:findTF("content/btns/help")
	arg0_2.homeBtn = arg0_2:findTF("content/btns/home")

	local var0_2 = arg0_2.contextData and arg0_2.contextData.hideBack

	setActive(arg0_2.homeBtn, not var0_2)

	arg0_2.refresh = arg0_2:findTF("content/btns/refresh")

	arg0_2:addListener()
end

function var0_0.addListener(arg0_3)
	onButton(arg0_3, arg0_3.refresh, function()
		arg0_3:emit(EducateBaseUI.EDUCATE_ON_MSG_TIP, {
			content = i18n("child_refresh_sure_tip"),
			onYes = function()
				pg.m02:sendNotification(GAME.EDUCATE_REFRESH)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child_main_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(EducateBaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0

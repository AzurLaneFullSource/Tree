local var0_0 = class("ActivityBossAmatsukazeScene", import(".ActivityBossGoriziaScene"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossAmatsukazeUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	onButton(arg0_2, arg0_2.top:Find("TopPage/top/btn_back"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.top:Find("TopPage/top/btn_home"), function()
		arg0_2.event:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	setText(arg0_2.top:Find("TopPage/top/deco/Text"), i18n("event_worldboss_0827_title"))
	setText(arg0_2.top:Find("TopPage/top/deco/Text/Text_1"), i18n("event_worldboss_0827_title_en"))
	setText(arg0_2.top:Find("ticket/Desc"), i18n("word_special_challenge_ticket"))
end

return var0_0

local var0_0 = class("ActivityBossAmatsukazeBuffSelectLayer", import(".ActivityBossBuffSelectLayerTemplate"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossAmatsukazeBuffSelectUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	setText(arg0_2.top:Find("TopPage/top/deco/Text"), i18n("event_worldboss_0827_title"))
	setText(arg0_2.top:Find("TopPage/top/deco/Text/Text_1"), i18n("event_worldboss_0827_title_en"))
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.top:Find("TopPage/top/btn_back"), function()
		arg0_3:closeView()
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.top:Find("TopPage/top/btn_home"), function()
		arg0_3.event:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

return var0_0

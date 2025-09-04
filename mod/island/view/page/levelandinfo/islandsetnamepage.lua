local var0_0 = class("IslandSetNamePage", import(".IslandEditNamePage"))

function var0_0.getUIName(arg0_1)
	return "IslandNewNameUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)
	setText(arg0_2:findTF("frame/title"), i18n("island_rename_subtitle"))
	setActive(arg0_2.closeBtn, false)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4 = getInputText(arg0_3.input)

		arg0_3:emit(IslandMediator.SET_NAME, var0_4, 2)
	end, SFX_PANEL)
end

function var0_0.UpdateContent(arg0_5)
	setText(arg0_5.content, "")
end

return var0_0

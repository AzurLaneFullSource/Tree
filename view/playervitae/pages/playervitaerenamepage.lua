local var0_0 = class("PlayerVitaeRenamePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PlayerVitaeRenamePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.content = arg0_2:findTF("frame/border/tip"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("frame/queren")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel")
	arg0_2.inputField = arg0_2:findTF("frame/name_field")

	setText(arg0_2._tf:Find("frame/top/title_list/infomation/title"), i18n("change_player_name_title"))
	setText(arg0_2._tf:Find("frame/border/prompt"), i18n("change_player_name_subtitle"))
	setText(arg0_2._tf:Find("frame/name_field/Placeholder"), i18n("change_player_name_input_tip"))
	setText(arg0_2.confirmBtn:Find("Image"), i18n("word_ok"))
	setText(arg0_2.cancelBtn:Find("Image"), i18n("word_cancel"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4 = getInputText(arg0_3.inputField)

		arg0_3:emit(PlayerVitaeMediator.ON_CHANGE_PLAYER_NAME, var0_4)
		setInputText(arg0_3.inputField, "")
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	local var0_7 = Drop.Create(arg1_7:getModifyNameComsume())

	arg0_7.content.text = i18n("player_name_change_windows_tip", var0_7:getName(), var0_7:getOwnedCount() .. "/" .. var0_7.count)
end

function var0_0.OnDestroy(arg0_8)
	arg0_8:Hide()
end

return var0_0

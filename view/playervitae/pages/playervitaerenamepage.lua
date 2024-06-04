local var0 = class("PlayerVitaeRenamePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "PlayerVitaeRenamePage"
end

function var0.OnLoaded(arg0)
	arg0.content = arg0:findTF("frame/border/tip"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("frame/queren")
	arg0.cancelBtn = arg0:findTF("frame/cancel")
	arg0.inputField = arg0:findTF("frame/name_field")

	setText(arg0._tf:Find("frame/top/title_list/infomation/title"), i18n("change_player_name_title"))
	setText(arg0._tf:Find("frame/border/prompt"), i18n("change_player_name_subtitle"))
	setText(arg0._tf:Find("frame/name_field/Placeholder"), i18n("change_player_name_input_tip"))
	setText(arg0.confirmBtn:Find("Image"), i18n("word_ok"))
	setText(arg0.cancelBtn:Find("Image"), i18n("word_cancel"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = getInputText(arg0.inputField)

		arg0:emit(PlayerVitaeMediator.ON_CHANGE_PLAYER_NAME, var0)
		setInputText(arg0.inputField, "")
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	local var0 = Drop.Create(arg1:getModifyNameComsume())

	arg0.content.text = i18n("player_name_change_windows_tip", var0:getName(), var0:getOwnedCount() .. "/" .. var0.count)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0

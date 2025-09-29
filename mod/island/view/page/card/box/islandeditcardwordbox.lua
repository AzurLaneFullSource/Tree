local var0_0 = class("IslandEditCardWordBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandEditCardWordBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("frame/title"), i18n("island_card_word_title"))

	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")
	arg0_2.cancelBtn = arg0_2._tf:Find("cancel")

	setText(arg0_2.cancelBtn:Find("Text"), i18n("word_cancel"))

	arg0_2.confirmBtn = arg0_2._tf:Find("confirm")

	setText(arg0_2.confirmBtn:Find("Text"), i18n("word_ok"))

	arg0_2.input = arg0_2._tf:Find("InputField")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_6 = getInputText(arg0_3.input)

		arg0_3:emit(IslandSelfCardMediator.SET_CARD_WORD, var0_6)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)
	setInputText(arg0_7.input, "")
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentTf)
end

function var0_0.OnDestroy(arg0_9)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9._tf, arg0_9._parentTf)
end

return var0_0

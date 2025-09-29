local var0_0 = class("IslandEditCardNameBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandEditCardNameBox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.input = arg0_2:findTF("frame/name/InputField")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.content = arg0_2:findTF("frame/Text")

	setText(arg0_2:findTF("frame/title"), i18n("island_rename_title"))
	setText(arg0_2:findTF("frame/confirm/Text"), i18n("word_ok"))
	setText(arg0_2:findTF("frame/name/InputField/Placeholder"), i18n("island_rename_input_tip"))

	arg0_2.animator = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.isPlayingAnimation = false
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_6 = getInputText(arg0_3.input)

		arg0_3:emit(IslandSelfCardMediator.SET_CARD_NAME, var0_6, 1)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	arg0_7.isPlayingAnimation = false
	arg0_7.callback = arg1_7

	arg0_7:UpdateContent()
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	arg0_7.animator:Play("anim_IslandEditNameUI_In")
end

function var0_0.Hide(arg0_8)
	if arg0_8.isPlayingAnimation then
		return
	end

	arg0_8.isPlayingAnimation = true

	arg0_8:PlayExitAniamtion(function()
		arg0_8.isPlayingAnimation = false

		arg0_8.aniDft:SetEndEvent(nil)
		var0_0.super.Hide(arg0_8)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentTf)
	end)
end

function var0_0.PlayExitAniamtion(arg0_10, arg1_10)
	arg0_10.aniDft:SetEndEvent(function()
		if arg1_10 then
			arg1_10()
		end
	end)
	arg0_10.animator:Play("anim_IslandEditNameUI_Out")
end

function var0_0.UpdateContent(arg0_12)
	setInputText(arg0_12.input, "")
	setText(arg0_12.content, i18n("island_rename_consutme_tip"))
end

function var0_0.OnDestroy(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
	arg0_13.aniDft:SetEndEvent(nil)
end

return var0_0

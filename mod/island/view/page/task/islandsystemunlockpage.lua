local var0_0 = class("IslandSystemUnlockPage", import(".Island3dTaskAcceptPage"))

function var0_0.getUIName(arg0_1)
	return "IslandSystemUnlockMsgBox"
end

function var0_0.Show(arg0_2, arg1_2, arg2_2)
	var0_0.super.super.Show(arg0_2)
	arg0_2:BlurPanel()
	setText(arg0_2.tipText, i18n("word_unlock"))

	local var0_2 = pg.island_ability_template[arg1_2] or {}
	local var1_2 = string.split(var0_2.show_pop_text or "", "|")

	setText(arg0_2.chapterText, var1_2[2] or "")
	setText(arg0_2.nameText, var1_2[1] or "")

	arg0_2.onExit = arg2_2

	local var2_2 = arg0_2._tf:GetComponent(typeof(Animation))
	local var3_2 = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	var3_2:SetEndEvent(function()
		var3_2:SetEndEvent(nil)
		var2_2:Play("Anim_Island3dTaskAcceptUI_loop")

		arg0_2.onAnimationLoop = true
	end)
end

function var0_0.BlurPanel(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._go.transform)

	arg0_4.isBlurPanel = true
end

function var0_0.UnBlurPanel(arg0_5)
	if arg0_5.isBlurPanel then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5._go.transform, pg.UIMgr.GetInstance().UIMain)
	end

	arg0_5.isBlurPanel = false
end

function var0_0.OnDestroy(arg0_6)
	var0_0.super.OnDestroy(arg0_6)
	arg0_6:UnBlurPanel()
end

function var0_0.Hide(arg0_7)
	var0_0.super.Hide(arg0_7)
	arg0_7:UnBlurPanel()
end

function var0_0.TouchEvent(arg0_8)
	local var0_8 = arg0_8._tf:GetComponent(typeof(Animation))

	if not arg0_8.onAnimationLoop then
		var0_8:Play("Anim_Island3dTaskAcceptUI_loop")

		arg0_8.onAnimationLoop = true

		return
	end

	local var1_8 = arg0_8._tf:GetComponent(typeof(DftAniEvent))

	var1_8:SetEndEvent(function()
		var1_8:SetEndEvent(nil)

		if arg0_8.onExit then
			arg0_8.onExit()

			arg0_8.onExit = nil
		end

		arg0_8:Hide()
	end)
	var0_8:Play("Anim_Island3dTaskAcceptUI_out")
end

return var0_0

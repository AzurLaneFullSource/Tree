local var0_0 = class("ForcePlayerNameModificationPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PlayerVitaeRenamePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.content = arg0_2:findTF("frame/border/tip"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("frame/queren")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel")
	arg0_2.inputField = arg0_2:findTF("frame/name_field")
	arg0_2.prompt = arg0_2._tf:Find("frame/border/prompt")

	setText(arg0_2._tf:Find("frame/top/title_list/infomation/title"), i18n("change_player_name_title"))
	setText(arg0_2._tf:Find("frame/name_field/Placeholder"), i18n("change_player_name_input_tip"))
	setText(arg0_2.confirmBtn:Find("Image"), i18n("word_ok"))
	setActive(arg0_2.cancelBtn, false)
	setAnchoredPosition(arg0_2.confirmBtn, {
		x = -365
	})
	setAnchoredPosition(arg0_2.inputField, {
		y = -30
	})
	setAnchoredPosition(arg0_2.prompt, {
		y = 43
	})

	local var0_2 = arg0_2.prompt:GetComponent(typeof(Text))

	var0_2.alignment = TextAnchor.MiddleCenter
	var0_2.fontSize = 27
	var0_2.lineSpacing = 0.8
	var0_2.verticalOverflow = ReflectionHelp.RefGetField(typeof("UnityEngine.VerticalWrapMode"), "Overflow")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4 = getInputText(arg0_3.inputField)

		pg.m02:sendNotification(GAME.CHANGE_PLAYER_NAME, {
			type = 2,
			name = var0_4,
			onSuccess = function()
				setInputText(arg0_3.inputField, "")

				if arg0_3.callback then
					arg0_3.callback()
				end

				arg0_3:Hide()
			end
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	arg0_6.showing = true

	var0_0.super.Show(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	local var0_6 = getProxy(PlayerProxy):getRawData()
	local var1_6 = i18n("change_player_name_illegal", var0_6.name)

	setText(arg0_6.prompt, var1_6)

	arg0_6.callback = arg1_6
end

function var0_0.Hide(arg0_7)
	if arg0_7.showing then
		arg0_7.showing = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf, arg0_7._parentTf)
		var0_0.super.Hide(arg0_7)

		arg0_7.callback = nil
	end
end

function var0_0.OnDestroy(arg0_8)
	arg0_8:Hide()
end

return var0_0

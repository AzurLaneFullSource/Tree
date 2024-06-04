local var0 = class("ForcePlayerNameModificationPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "PlayerVitaeRenamePage"
end

function var0.OnLoaded(arg0)
	arg0.content = arg0:findTF("frame/border/tip"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("frame/queren")
	arg0.cancelBtn = arg0:findTF("frame/cancel")
	arg0.inputField = arg0:findTF("frame/name_field")
	arg0.prompt = arg0._tf:Find("frame/border/prompt")

	setText(arg0._tf:Find("frame/top/title_list/infomation/title"), i18n("change_player_name_title"))
	setText(arg0._tf:Find("frame/name_field/Placeholder"), i18n("change_player_name_input_tip"))
	setText(arg0.confirmBtn:Find("Image"), i18n("word_ok"))
	setActive(arg0.cancelBtn, false)
	setAnchoredPosition(arg0.confirmBtn, {
		x = -365
	})
	setAnchoredPosition(arg0.inputField, {
		y = -30
	})
	setAnchoredPosition(arg0.prompt, {
		y = 43
	})

	local var0 = arg0.prompt:GetComponent(typeof(Text))

	var0.alignment = TextAnchor.MiddleCenter
	var0.fontSize = 27
	var0.lineSpacing = 0.8
	var0.verticalOverflow = ReflectionHelp.RefGetField(typeof("UnityEngine.VerticalWrapMode"), "Overflow")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = getInputText(arg0.inputField)

		pg.m02:sendNotification(GAME.CHANGE_PLAYER_NAME, {
			type = 2,
			name = var0,
			onSuccess = function()
				setInputText(arg0.inputField, "")

				if arg0.callback then
					arg0.callback()
				end

				arg0:Hide()
			end
		})
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	arg0.showing = true

	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = i18n("change_player_name_illegal", var0.name)

	setText(arg0.prompt, var1)

	arg0.callback = arg1
end

function var0.Hide(arg0)
	if arg0.showing then
		arg0.showing = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
		var0.super.Hide(arg0)

		arg0.callback = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0

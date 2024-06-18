local var0_0 = class("CommanderMsgBoxPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderMsgBoxUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.cancelBtn = arg0_2._tf:Find("frame/cancel_btn")
	arg0_2.text = arg0_2._tf:Find("frame/bg/content/Text")
	arg0_2.text1 = arg0_2._tf:Find("frame/bg/content/Text1")
	arg0_2.text2 = arg0_2._tf:Find("frame/bg/content/Text2")
	arg0_2.confirmBtn = arg0_2._tf:Find("frame/confirm_btn")
	arg0_2.closeBtn = arg0_2._tf:Find("frame/close_btn")

	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_4, arg1_4)
	var0_0.super.Show(arg0_4)

	if arg1_4.content1 then
		setText(arg0_4.text1, arg1_4.content)
		setText(arg0_4.text2, arg1_4.content1)
	elseif arg1_4.content then
		setText(arg0_4.text, setColorStr(arg1_4.content, "#847D7B"))
	end

	arg0_4.layer = arg1_4.layer

	onButton(arg0_4, arg0_4.cancelBtn, function()
		arg0_4:Hide()

		if arg1_4.onNo then
			arg1_4.onNo()
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.confirmBtn, function()
		arg0_4:Hide()

		if arg1_4.onYes then
			arg1_4.onYes()
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:Hide()

		if arg1_4.onClose then
			arg1_4.onClose()
		end
	end, SFX_PANEL)

	if arg1_4.onShow then
		arg1_4.onShow()
	end

	arg0_4._tf:SetAsLastSibling()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		weight = arg0_4.layer or LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)
	setText(arg0_8.text, "")
	setText(arg0_8.text1, "")
	setText(arg0_8.text2, "")
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8._parentTf)
end

function var0_0.OnDestroy(arg0_9)
	arg0_9:Hide()
end

return var0_0

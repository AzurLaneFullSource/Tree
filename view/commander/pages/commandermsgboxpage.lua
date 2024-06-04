local var0 = class("CommanderMsgBoxPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderMsgBoxUI"
end

function var0.OnInit(arg0)
	arg0.cancelBtn = arg0._tf:Find("frame/cancel_btn")
	arg0.text = arg0._tf:Find("frame/bg/content/Text")
	arg0.text1 = arg0._tf:Find("frame/bg/content/Text1")
	arg0.text2 = arg0._tf:Find("frame/bg/content/Text2")
	arg0.confirmBtn = arg0._tf:Find("frame/confirm_btn")
	arg0.closeBtn = arg0._tf:Find("frame/close_btn")

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	if arg1.content1 then
		setText(arg0.text1, arg1.content)
		setText(arg0.text2, arg1.content1)
	elseif arg1.content then
		setText(arg0.text, setColorStr(arg1.content, "#847D7B"))
	end

	arg0.layer = arg1.layer

	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()

		if arg1.onNo then
			arg1.onNo()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()

		if arg1.onYes then
			arg1.onYes()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()

		if arg1.onClose then
			arg1.onClose()
		end
	end, SFX_PANEL)

	if arg1.onShow then
		arg1.onShow()
	end

	arg0._tf:SetAsLastSibling()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg0.layer or LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	setText(arg0.text, "")
	setText(arg0.text1, "")
	setText(arg0.text2, "")
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0

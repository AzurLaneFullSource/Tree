local var0_0 = class("FriendRefusePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FriendRefuseUI"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.context = arg0_3._tf:Find("window/frame/Text"):GetComponent(typeof(Text))
	arg0_3.remind = arg0_3._tf:Find("window/remind")
	arg0_3.confirmBtn = arg0_3._tf:Find("window/confirm_btn")
	arg0_3.cancelBtn = arg0_3._tf:Find("window/cancel_btn")
	arg0_3.closeBtn = arg0_3._tf:Find("window/top/btnBack")
	arg0_3.checkLabel = arg0_3.remind:Find("Text"):GetComponent(typeof(Text))

	onButton(nil, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(nil, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(nil, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.isOn = false

	onToggle(nil, arg0_3.remind, function(arg0_7)
		arg0_3.isOn = arg0_7
	end, SFX_PANEL)
	onButton(nil, arg0_3.confirmBtn, function()
		if arg0_3.func then
			arg0_3.func(arg0_3.isOn)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_9, arg1_9, arg2_9, arg3_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)

	arg0_9.func = arg3_9
	arg0_9.context.text = arg1_9

	triggerToggle(arg0_9.remind, false)
	setActive(arg0_9._tf, true)

	arg0_9.checkLabel.text = arg2_9

	arg0_9._tf:SetAsLastSibling()
end

function var0_0.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
	setActive(arg0_10._tf, false)

	arg0_10.func = nil
	arg0_10.context.text = ""
	arg0_10.checkLabel.text = ""
end

function var0_0.OnDestroy(arg0_11)
	arg0_11:Hide()
	removeOnButton(arg0_11._tf)
	removeOnButton(arg0_11.cancelBtn)
end

return var0_0

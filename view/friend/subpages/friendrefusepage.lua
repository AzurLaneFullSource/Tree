local var0 = class("FriendRefusePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "FriendRefuseUI"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.context = arg0._tf:Find("window/frame/Text"):GetComponent(typeof(Text))
	arg0.remind = arg0._tf:Find("window/remind")
	arg0.confirmBtn = arg0._tf:Find("window/confirm_btn")
	arg0.cancelBtn = arg0._tf:Find("window/cancel_btn")
	arg0.closeBtn = arg0._tf:Find("window/top/btnBack")
	arg0.checkLabel = arg0.remind:Find("Text"):GetComponent(typeof(Text))

	onButton(nil, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(nil, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(nil, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.isOn = false

	onToggle(nil, arg0.remind, function(arg0)
		arg0.isOn = arg0
	end, SFX_PANEL)
	onButton(nil, arg0.confirmBtn, function()
		if arg0.func then
			arg0.func(arg0.isOn)
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2, arg3)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.func = arg3
	arg0.context.text = arg1

	triggerToggle(arg0.remind, false)
	setActive(arg0._tf, true)

	arg0.checkLabel.text = arg2

	arg0._tf:SetAsLastSibling()
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)

	arg0.func = nil
	arg0.context.text = ""
	arg0.checkLabel.text = ""
end

function var0.OnDestroy(arg0)
	arg0:Hide()
	removeOnButton(arg0._tf)
	removeOnButton(arg0.cancelBtn)
end

return var0

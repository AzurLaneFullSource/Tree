local var0_0 = class("IslandMailScene", import("view.main.Mail.MailScene"))

function var0_0.didEnter(arg0_1)
	var0_0.super.didEnter(arg0_1)
	onNextTick(function()
		arg0_1:ExtraHandle()
	end)
end

function var0_0.ExtraHandle(arg0_3)
	setActive(arg0_3._tf:Find("adapt/top/res"), false)
	setActive(arg0_3._tf:Find("adapt/top/option"), false)
	setActive(arg0_3._tf:Find("adapt/left_length/frame/tagRoot/store"), false)
	setActive(arg0_3._tf:Find("adapt/left_length/frame/tagRoot/collection"), false)
end

function var0_0.closeView(arg0_4)
	arg0_4.contextData.onClose()
end

function var0_0.onBackPressed(arg0_5)
	return
end

return var0_0

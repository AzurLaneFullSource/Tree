local var0_0 = class("Dorm3dInsBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.root = arg1_1
	arg0_1.chat = arg0_1.root:Find("chat")
	arg0_1.phone = arg0_1.root:Find("phone")
	arg0_1.tip = arg0_1.root:Find("tip")
end

function var0_0.Flush(arg0_2)
	setActive(arg0_2.tip, arg0_2.ShouldTip())
	setActive(arg0_2.chat, not arg0_2.IsNewPhoneCall())
	setActive(arg0_2.phone, arg0_2.IsNewPhoneCall())
end

function var0_0.IsNewPhoneCall()
	return getProxy(Dorm3dInsProxy):AnyPhoneShouldTip()
end

function var0_0.ShouldTip()
	return getProxy(Dorm3dChatProxy):ShouldShowTip() or getProxy(Dorm3dInsProxy):AllInstagramShouldTip()
end

return var0_0

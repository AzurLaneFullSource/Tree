local var0_0 = class("NewEducateOptionsHandler")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.tpl = arg0_1._tf:Find("tpl")
	arg0_1.optionUIList = UIItemList.New(arg0_1._tf, arg0_1.tpl)

	arg0_1.optionUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateOption(arg1_2, arg2_2)
		end
	end)
end

function var0_0.Play(arg0_3, arg1_3, arg2_3)
	if not arg0_3.callName then
		arg0_3.callName = getProxy(NewEducateProxy):GetCurChar():GetCallName()
	end

	setActive(arg0_3._go, true)

	arg0_3.optionIds = arg1_3
	arg0_3.callback = arg2_3

	arg0_3.optionUIList:align(#arg0_3.optionIds)
end

function var0_0._GetText(arg0_4, arg1_4)
	local var0_4 = pg.child2_word[arg1_4].word

	return string.gsub(var0_4, "$1", arg0_4.callName)
end

function var0_0.UpdateOption(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.optionIds[arg1_5 + 1]
	local var1_5 = pg.child2_node[var0_5]

	setScrollText(arg2_5:Find("mask/Text"), arg0_5:_GetText(var1_5.text))
	onButton(arg0_5, arg2_5, function()
		existCall(arg0_5.callback(var0_5))
		arg0_5:Reset()
	end, SFX_PANEL)
end

function var0_0.UpdateCallName(arg0_7)
	arg0_7.callName = getProxy(NewEducateProxy):GetCurChar():GetCallName()
end

function var0_0.Reset(arg0_8)
	arg0_8.callback = nil

	setActive(arg0_8._go, false)
end

function var0_0.Destroy(arg0_9)
	pg.DelegateInfo.Dispose(arg0_9)
end

return var0_0

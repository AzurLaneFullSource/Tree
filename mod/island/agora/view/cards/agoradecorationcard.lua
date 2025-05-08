local var0_0 = class("AgoraDecorationCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.mask = arg0_1.tr:Find("mask")
	arg0_1.mark = arg0_1.tr:Find("mark")
	arg0_1.nameTxt = arg0_1.tr:Find("name"):GetComponent(typeof(Text))
	arg0_1.using = arg0_1.tr:Find("using")
	arg0_1.usingText = arg0_1.using:Find("Text"):GetComponent(typeof(Text))
	arg0_1.notowned = arg0_1.tr:Find("notowned")
	arg0_1.cntTxt = arg0_1.tr:Find("cnt/Text"):GetComponent(typeof(Text))
	arg0_1.usingText.text = i18n1("使用中")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.item = arg1_2
	arg0_2.isUsing = arg2_2
	arg0_2.nameTxt.text = arg1_2:GetName()

	setActive(arg0_2.using, arg2_2)
	setActive(arg0_2.mark, arg0_2.item.id == arg3_2)
	setActive(arg0_2.notowned, false)

	arg0_2.cntTxt.text = 1
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0

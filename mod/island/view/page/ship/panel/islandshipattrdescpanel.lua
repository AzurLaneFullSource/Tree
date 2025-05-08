local var0_0 = class("IslandShipAttrDescPanel")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
	arg0_1.labelTxt = findTF(arg1_1, "label"):GetComponent(typeof(Text))
	arg0_1.gradeTxt = findTF(arg1_1, "label/Text"):GetComponent(typeof(Text))
	arg0_1.descTxt = findTF(arg1_1, "Text"):GetComponent(typeof(Text))
	arg0_1.hideTime = 5
end

function var0_0.Show(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.tr.localPosition = arg3_2 + Vector3(-150, -30, 0)

	setActive(arg0_2.tr, true)

	local var0_2 = arg1_2:GetAttrGradeStr(arg2_2)
	local var1_2 = IslandShipAttr.ToChinese(arg2_2)
	local var2_2 = arg1_2:GetAttrGradeValue(arg2_2)

	arg0_2.labelTxt.text = var1_2 .. i18n1("成长")
	arg0_2.gradeTxt.text = var0_2
	arg0_2.descTxt.text = i18n1(string.format("每提升一级可以增加角色%s点%s属性值", var2_2, var1_2)) .. "\n" .. i18n1("属性描述...")

	arg0_2:AddTimer()
end

function var0_0.AddTimer(arg0_3)
	arg0_3:RemoveTimer()

	arg0_3.timer = Timer.New(function()
		arg0_3:Hide()
	end, arg0_3.hideTime, 1)

	arg0_3.timer:Start()
end

function var0_0.RemoveTimer(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()
	end

	arg0_5.timer = nil
end

function var0_0.Hide(arg0_6)
	setActive(arg0_6.tr, false)
end

function var0_0.Dispose(arg0_7)
	arg0_7:Hide()
	arg0_7:RemoveTimer()
end

return var0_0

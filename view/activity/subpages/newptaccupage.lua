local var0_0 = class("NewPtAccuPage", import(".TemplatePage.PtTemplatePage"))

var0_0.TIME = 300

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.value2 = arg0_1:findTF("AD/value2")
	arg0_1.sliderTxt = arg0_1:findTF("AD/slider/Text")
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)
	setText(arg0_2.value2, arg0_2.ptData:GetValue2())

	local var0_2, var1_2, var2_2 = arg0_2.ptData:GetResProgress()

	setText(arg0_2.sliderTxt, math.floor(math.min(var2_2, 1) * 100) .. "%")
	arg0_2:GetWorldPtData(var0_0.TIME)
end

return var0_0

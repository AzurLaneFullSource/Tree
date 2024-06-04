local var0 = class("NewPtAccuPage", import(".TemplatePage.PtTemplatePage"))

var0.TIME = 300

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.value2 = arg0:findTF("AD/value2")
	arg0.sliderTxt = arg0:findTF("AD/slider/Text")
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.value2, arg0.ptData:GetValue2())

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.sliderTxt, math.floor(math.min(var2, 1) * 100) .. "%")
	arg0:GetWorldPtData(var0.TIME)
end

return var0

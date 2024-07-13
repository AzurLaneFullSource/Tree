local var0_0 = class("SiChuanOperaPage", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.dayText = arg0_1:findTF("AD/DayText")
	arg0_1.url = arg0_1:findTF("AD/url")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.url, function()
		Application.OpenURL(arg0_2.activity:getConfig("config_client"))
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)
	setText(arg0_4.dayText, string.format("%02d", arg0_4.nday))
end

return var0_0

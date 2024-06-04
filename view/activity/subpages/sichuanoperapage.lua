local var0 = class("SiChuanOperaPage", import(".TemplatePage.LoginTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.dayText = arg0:findTF("AD/DayText")
	arg0.url = arg0:findTF("AD/url")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.url, function()
		Application.OpenURL(arg0.activity:getConfig("config_client"))
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayText, string.format("%02d", arg0.nday))
end

return var0

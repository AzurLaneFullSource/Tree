local var0 = class("SettingsAccountCHTPanle", import(".SettingsAccountCHPanle"))

function var0.GetTitle(arg0)
	return "注銷"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	setText(findTF(arg0._tf, "delete/Text"), "注銷")
end

return var0

local var0_0 = class("SettingsAccountCHTPanle", import(".SettingsAccountCHPanle"))

function var0_0.GetTitle(arg0_1)
	return "注銷"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	setText(findTF(arg0_2._tf, "delete/Text"), "注銷")
end

return var0_0

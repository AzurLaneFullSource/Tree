local var0_0 = class("AccountDeletePanel", import(".MsgboxSubPanel"))

var0_0.ConfigData = {}

function var0_0.getUIName(arg0_1)
	return "AccountDeleteBox"
end

function var0_0.UpdateView(arg0_2, arg1_2)
	local var0_2 = arg1_2.onYes

	print("onYesFunc", tostring(var0_2))

	if var0_2 then
		function arg1_2.onYes()
			local var0_3 = getInputText(arg0_2.inputField)

			var0_2(var0_3)
		end
	end

	arg0_2:PreRefresh(arg1_2)

	rtf(arg0_2.viewParent._window).sizeDelta = Vector2.New(1000, 638)
	arg0_2.inputField = arg0_2:findTF("InputField", arg0_2._tf)

	local var1_2 = arg0_2:findTF("Title", arg0_2._tf)
	local var2_2 = arg0_2:findTF("InputField/Placeholder", arg0_2._tf)
	local var3_2 = i18n("box_account_del_target")
	local var4_2 = i18n("box_account_del_input", var3_2)

	setText(var1_2, var4_2)
	setText(var2_2, i18n("box_account_del_click"))
	arg0_2:PostRefresh(arg1_2)
end

return var0_0

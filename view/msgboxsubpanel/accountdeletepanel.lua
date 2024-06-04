local var0 = class("AccountDeletePanel", import(".MsgboxSubPanel"))

var0.ConfigData = {}

function var0.getUIName(arg0)
	return "AccountDeleteBox"
end

function var0.UpdateView(arg0, arg1)
	local var0 = arg1.onYes

	print("onYesFunc", tostring(var0))

	if var0 then
		function arg1.onYes()
			local var0 = getInputText(arg0.inputField)

			var0(var0)
		end
	end

	arg0:PreRefresh(arg1)

	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(1000, 638)
	arg0.inputField = arg0:findTF("InputField", arg0._tf)

	local var1 = arg0:findTF("Title", arg0._tf)
	local var2 = arg0:findTF("InputField/Placeholder", arg0._tf)
	local var3 = i18n("box_account_del_target")
	local var4 = i18n("box_account_del_input", var3)

	setText(var1, var4)
	setText(var2, i18n("box_account_del_click"))
	arg0:PostRefresh(arg1)
end

return var0

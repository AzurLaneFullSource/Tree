local var0_0 = class("Dorm3dFurnitureConfirmWindow", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dFurnitureConfirmWindow"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("Window/Confirm"), function()
		local var0_4 = arg0_3.contextData.onYes

		arg0_3:closeView()
		existCall(var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("Window/Cancel"), function()
		local var0_5 = arg0_3.contextData.onNo

		arg0_3:closeView()
		existCall(var0_5)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("Mask"), function()
		local var0_6 = arg0_3.contextData.onClose

		arg0_3:closeView()
		existCall(var0_6)
	end)
	onButton(arg0_3, arg0_3._tf:Find("Window/Close"), function()
		local var0_7 = arg0_3.contextData.onClose

		arg0_3:closeView()
		existCall(var0_7)
	end, SFX_CANCEL)
	setText(arg0_3._tf:Find("Window/Title"), arg0_3.contextData.title)
	setText(arg0_3._tf:Find("Window/Content"), arg0_3.contextData.content)
	setText(arg0_3._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_3._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
end

function var0_0.willExit(arg0_8)
	return
end

return var0_0

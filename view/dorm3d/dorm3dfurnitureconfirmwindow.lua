local var0 = class("Dorm3dFurnitureConfirmWindow", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dFurnitureConfirmWindow"
end

function var0.init(arg0)
	return
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Window/Confirm"), function()
		local var0 = arg0.contextData.onYes

		arg0:closeView()
		existCall(var0)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Window/Cancel"), function()
		local var0 = arg0.contextData.onNo

		arg0:closeView()
		existCall(var0)
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Mask"), function()
		local var0 = arg0.contextData.onClose

		arg0:closeView()
		existCall(var0)
	end)
	onButton(arg0, arg0._tf:Find("Window/Close"), function()
		local var0 = arg0.contextData.onClose

		arg0:closeView()
		existCall(var0)
	end, SFX_CANCEL)
	setText(arg0._tf:Find("Window/Title"), arg0.contextData.title)
	setText(arg0._tf:Find("Window/Content"), arg0.contextData.content)
	setText(arg0._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
end

function var0.willExit(arg0)
	return
end

return var0

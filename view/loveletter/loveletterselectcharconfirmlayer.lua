local var0_0 = class("LoveLetterSelectCharConfirmLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LoveLetterGroupSelectUI"
end

var0_0.optionsPath = {}

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.btnCancel, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.btnConfirm, function()
		arg0_2:emit(LoveLetterSelectCharConfirmMediator.SELECT_CHAR, arg0_2.ll.groupId)
	end, SFX_CONFIRM)
	arg0_2:BlurPanel(arg0_2._tf)
end

function var0_0.SetLoveLetter(arg0_5, arg1_5)
	arg0_5.ll = getProxy(LoveLetterProxy):GetGroupData(arg1_5)
end

function var0_0.SetActivity(arg0_6, arg1_6)
	arg0_6.activity = getProxy(ActivityProxy):getActivityById(arg1_6)

	local var0_6, var1_6 = arg0_6.activity:GetChangeCount()

	setText(arg0_6.textHelp, i18n("loveactivity_ui_12", var1_6 - var0_6, var1_6))
end

function var0_0.didEnter(arg0_7)
	arg0_7:UpdateDisplay()
end

function var0_0.UpdateDisplay(arg0_8)
	arg0_8:UpdatePainting()
	setText(arg0_8.textInfo, i18n("loveactivity_ui_11", setColorStr(arg0_8.ll:GetName(), "#f3709e")))
end

function var0_0.UpdatePainting(arg0_9)
	local var0_9 = arg0_9.ll:GetPainting()

	if arg0_9.paint == var0_9 then
		return
	end

	if arg0_9.paint then
		retPaintingPrefab(arg0_9.rtPainting, arg0_9.paint)

		arg0_9.paint = nil
	end

	arg0_9.paint = var0_9

	setPaintingPrefabAsync(arg0_9.rtPainting, arg0_9.paint, "biandui")
end

function var0_0.willExit(arg0_10)
	arg0_10:UnOverlayPanel(arg0_10._tf)

	if arg0_10.paint then
		retPaintingPrefab(arg0_10.rtPainting, arg0_10.paint)

		arg0_10.paint = nil
	end
end

return var0_0

local var0_0 = class("EducateNewCharLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateNewCharUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.char = getProxy(EducateProxy):GetCharData()
	arg0_3.defaultName = i18n("child_default_callname")
	arg0_3.lockNamed = PLATFORM_CODE == PLATFORM_CH and LOCK_NAMED
end

function var0_0.findUI(arg0_4)
	arg0_4.blurPanel = arg0_4._tf:Find("bg")
	arg0_4.callInput = arg0_4._tf:Find("bg/panel/input/nickname")
	arg0_4.sureBtn = arg0_4._tf:Find("bg/panel/sure_button")

	setText(arg0_4.sureBtn:Find("Image"), i18n("word_ok"))
	setText(arg0_4.callInput:Find("Placeholder"), i18n("child_callname_tip"))

	arg0_4.callInput:GetComponent(typeof(InputField)).interactable = not arg0_4.lockNamed

	setActive(arg0_4._tf:Find("bg/panel/input/pan"), not arg0_4.lockNamed)
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5.sureBtn, function()
		local var0_6 = getInputText(arg0_5.callInput)

		if var0_6 == "" then
			return
		end

		if not nameValidityCheck(var0_6, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0_5:emit(EducateNewCharMediator.ON_SET_CALL, var0_6)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_7)
	arg0_7:OverlayPanel(arg0_7.blurPanel, {
		groupDelta = 1,
		pbList = {
			arg0_7.blurPanel
		}
	})
	setInputText(arg0_7.callInput, arg0_7.defaultName)
end

function var0_0.onBackPressed(arg0_8)
	return
end

function var0_0.willExit(arg0_9)
	local var0_9 = arg0_9.contextData.callback

	if var0_9 then
		var0_9()
	end

	arg0_9:UnOverlayPanel(arg0_9.blurPanel, arg0_9._tf)
end

return var0_0

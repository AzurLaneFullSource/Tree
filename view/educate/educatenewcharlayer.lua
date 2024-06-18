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
end

function var0_0.findUI(arg0_4)
	arg0_4.blurPanel = arg0_4:findTF("bg")
	arg0_4.namedPanelTF = arg0_4:findTF("named_panel")
	arg0_4.callInput = arg0_4:findTF("bg/panel/input/nickname")
	arg0_4.sureBtn = arg0_4:findTF("bg/panel/sure_button")

	setText(arg0_4:findTF("Image", arg0_4.sureBtn), i18n("word_ok"))
	setText(arg0_4:findTF("Placeholder", arg0_4.callInput), i18n("child_callname_tip"))
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
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_7.blurPanel, {
		pbList = {
			arg0_7.blurPanel
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = arg0_7:getWeightFromData() + 1
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

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.blurPanel, arg0_9._tf)
end

return var0_0

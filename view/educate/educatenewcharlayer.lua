local var0 = class("EducateNewCharLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateNewCharUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.char = getProxy(EducateProxy):GetCharData()
	arg0.defaultName = i18n("child_default_callname")
end

function var0.findUI(arg0)
	arg0.blurPanel = arg0:findTF("bg")
	arg0.namedPanelTF = arg0:findTF("named_panel")
	arg0.callInput = arg0:findTF("bg/panel/input/nickname")
	arg0.sureBtn = arg0:findTF("bg/panel/sure_button")

	setText(arg0:findTF("Image", arg0.sureBtn), i18n("word_ok"))
	setText(arg0:findTF("Placeholder", arg0.callInput), i18n("child_callname_tip"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0.sureBtn, function()
		local var0 = getInputText(arg0.callInput)

		if var0 == "" then
			return
		end

		if not nameValidityCheck(var0, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0:emit(EducateNewCharMediator.ON_SET_CALL, var0)
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.blurPanel, {
		pbList = {
			arg0.blurPanel
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = arg0:getWeightFromData() + 1
	})
	setInputText(arg0.callInput, arg0.defaultName)
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	local var0 = arg0.contextData.callback

	if var0 then
		var0()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
end

return var0

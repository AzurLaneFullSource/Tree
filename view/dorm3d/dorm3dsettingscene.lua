local var0_0 = class("Dorm3dSettingScene", import("view.Setting.NewSettingsScene"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dSettingUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("blur_panel/adapt/top/back_btn")

	local var0_2 = arg0_2:findTF("pages")

	arg0_2.pages = {
		Settings3DPage.New(var0_2, arg0_2.event, arg0_2.contextData)
	}
	arg0_2.toggles = {
		arg0_2:findTF("blur_panel/adapt/left_length/threeD")
	}
	arg0_2.otherTip = arg0_2.toggles[1]:Find("tip")
	arg0_2.descWindow = SettingsMsgBosPage.New(arg0_2._tf, arg0_2.event)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	arg0_3:SwitchPage(1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.onBackPressed(arg0_5)
	arg0_5:closeView()
end

function var0_0.willExit(arg0_6)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf)
	var0_0.super.willExit(arg0_6)
end

return var0_0

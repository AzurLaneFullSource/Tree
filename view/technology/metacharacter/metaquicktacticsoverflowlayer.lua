local var0_0 = class("MetaQuickTacticsOverflowLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaQuickTacticsOverflowUI"
end

function var0_0.getGroupName(arg0_2)
	return "MetaCharacterScene"
end

function var0_0.init(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:addListener()
	arg0_3:overlayPanel(true)
end

function var0_0.didEnter(arg0_4)
	return
end

function var0_0.willExit(arg0_5)
	arg0_5:overlayPanel(false)
end

function var0_0.onBackPressed(arg0_6)
	arg0_6:closeView()
end

function var0_0.overlayPanel(arg0_7, arg1_7)
	if arg1_7 and arg0_7._tf then
		arg0_7:OverlayPanel(arg0_7._tf)
	elseif arg0_7._tf then
		arg0_7:UnOverlayPanel(arg0_7._tf)
	end
end

function var0_0.initData(arg0_8)
	arg0_8.shipID = arg0_8.contextData.shipID
	arg0_8.skillID = arg0_8.contextData.skillID
	arg0_8.useCountDict = arg0_8.contextData.useCountDict
	arg0_8.overExp = arg0_8.contextData.overExp
end

function var0_0.initUI(arg0_9)
	arg0_9.bg = arg0_9:findTF("BG")
	arg0_9.text = arg0_9:findTF("Content/Context/Text")
	arg0_9.cancelBtn = arg0_9:findTF("Content/CancelBtn")
	arg0_9.confirmBtn = arg0_9:findTF("Content/ConfirmBtn")

	setText(arg0_9.text, i18n("metaskill_overflow_tip", arg0_9.overExp))
end

function var0_0.addListener(arg0_10)
	local function var0_10()
		arg0_10:closeView()
	end

	onButton(arg0_10, arg0_10.bg, var0_10, SFX_PANEL)
	onButton(arg0_10, arg0_10.cancelBtn, var0_10, SFX_PANEL)
	onButton(arg0_10, arg0_10.confirmBtn, function()
		arg0_10:emit(MetaQuickTacticsOverflowMediator.USE_TACTICS_BOOK, arg0_10.shipID, arg0_10.skillID, arg0_10.useCountDict)
		arg0_10:closeView()
	end, SFX_PANEL)
end

return var0_0

local var0_0 = class("MetaQuickTacticsOverflowLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaQuickTacticsOverflowUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:overlayPanel(true)
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.willExit(arg0_4)
	arg0_4:overlayPanel(false)
end

function var0_0.onBackPressed(arg0_5)
	arg0_5:closeView()
end

function var0_0.overlayPanel(arg0_6, arg1_6)
	if arg1_6 and arg0_6._tf then
		pg.UIMgr.GetInstance():OverlayPanel(arg0_6._tf, {
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER
		})
	elseif arg0_6._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf)
	end
end

function var0_0.initData(arg0_7)
	arg0_7.shipID = arg0_7.contextData.shipID
	arg0_7.skillID = arg0_7.contextData.skillID
	arg0_7.useCountDict = arg0_7.contextData.useCountDict
	arg0_7.overExp = arg0_7.contextData.overExp
end

function var0_0.initUI(arg0_8)
	arg0_8.bg = arg0_8:findTF("BG")
	arg0_8.text = arg0_8:findTF("Content/Context/Text")
	arg0_8.cancelBtn = arg0_8:findTF("Content/CancelBtn")
	arg0_8.confirmBtn = arg0_8:findTF("Content/ConfirmBtn")

	setText(arg0_8.text, i18n("metaskill_overflow_tip", arg0_8.overExp))
end

function var0_0.addListener(arg0_9)
	local function var0_9()
		arg0_9:closeView()
	end

	onButton(arg0_9, arg0_9.bg, var0_9, SFX_PANEL)
	onButton(arg0_9, arg0_9.cancelBtn, var0_9, SFX_PANEL)
	onButton(arg0_9, arg0_9.confirmBtn, function()
		arg0_9:emit(MetaQuickTacticsOverflowMediator.USE_TACTICS_BOOK, arg0_9.shipID, arg0_9.skillID, arg0_9.useCountDict)
		arg0_9:closeView()
	end, SFX_PANEL)
end

return var0_0

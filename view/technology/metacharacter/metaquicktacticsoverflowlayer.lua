local var0 = class("MetaQuickTacticsOverflowLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaQuickTacticsOverflowUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
	arg0:overlayPanel(true)
end

function var0.didEnter(arg0)
	return
end

function var0.willExit(arg0)
	arg0:overlayPanel(false)
end

function var0.onBackPressed(arg0)
	arg0:closeView()
end

function var0.overlayPanel(arg0, arg1)
	if arg1 and arg0._tf then
		pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER
		})
	elseif arg0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	end
end

function var0.initData(arg0)
	arg0.shipID = arg0.contextData.shipID
	arg0.skillID = arg0.contextData.skillID
	arg0.useCountDict = arg0.contextData.useCountDict
	arg0.overExp = arg0.contextData.overExp
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.text = arg0:findTF("Content/Context/Text")
	arg0.cancelBtn = arg0:findTF("Content/CancelBtn")
	arg0.confirmBtn = arg0:findTF("Content/ConfirmBtn")

	setText(arg0.text, i18n("metaskill_overflow_tip", arg0.overExp))
end

function var0.addListener(arg0)
	local function var0()
		arg0:closeView()
	end

	onButton(arg0, arg0.bg, var0, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, var0, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:emit(MetaQuickTacticsOverflowMediator.USE_TACTICS_BOOK, arg0.shipID, arg0.skillID, arg0.useCountDict)
		arg0:closeView()
	end, SFX_PANEL)
end

return var0

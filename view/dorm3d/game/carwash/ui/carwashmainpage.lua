local var0_0 = class("CarWashMainPage", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

var0_0.SHOW_BLACK_SCREEN = "CarWashMainPage.SHOW_BLACK_SCREEN"
var0_0.SHOW_HELP_BOX = "CarWashMainPage.SHOW_HELP_BOX"
var0_0.SHOW_EXPRESSION_HUD = "CarWashMainPage.SHOW_EXPRESSION_HUD"
var0_0.ENABLE_BLOCK = "CarWashMainPage.ENABLE_BLOCK"
var0_0.EXPRESSION_TYPE = {
	LIKE = "LIKE",
	HATE = "HATE"
}

function var0_0.Init(arg0_1)
	arg0_1:InitUI()
	arg0_1:BindEvent()
end

function var0_0.InitUI(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("btn_back"), function()
		arg0_2:emit(BaseUI.ON_BACK)
	end)
	onButton(arg0_2, arg0_2._tf:Find("btn_help"), function()
		arg0_2:ShowHelpBox()
	end)

	arg0_2.expressionRoot = arg0_2._tf:Find("expression_root")
	arg0_2.expressionLike = arg0_2.expressionRoot:Find("vfx_car_aixin01")
	arg0_2.expressionHate = arg0_2.expressionRoot:Find("vfx_car_xixian01")

	setActive(arg0_2.expressionLike, false)
	setActive(arg0_2.expressionHate, false)

	arg0_2.blockLayer = arg0_2._tf:Find("block")

	arg0_2:EnableBlock(false)

	arg0_2.blackLayer = arg0_2._tf:Find("BlackScreen")
	arg0_2.povLayer = arg0_2._tf:Find("POVControl")

	arg0_2:UpdatePOV()
end

function var0_0.BindEvent(arg0_5)
	arg0_5:bind(var0_0.SHOW_BLACK_SCREEN, arg0_5.ShowBlackScreen)
	arg0_5:bind(var0_0.SHOW_HELP_BOX, function(arg0_6, arg1_6)
		arg0_5:ShowHelpBox(arg1_6)
	end)
	arg0_5:bind(CarWashLadySystem.UPDATE_EXPRESSION_HUD_POSITION, function(arg0_7, arg1_7)
		arg0_5:UpdateExpressionHUDPosition(arg1_7)
	end)
	arg0_5:bind(var0_0.SHOW_EXPRESSION_HUD, function(arg0_8, arg1_8)
		local var0_8 = switch(arg1_8, {
			[var0_0.EXPRESSION_TYPE.LIKE] = function()
				return arg0_5.expressionLike
			end,
			[var0_0.EXPRESSION_TYPE.HATE] = function()
				return arg0_5.expressionHate
			end
		}, function()
			assert(false, "CarWashMainPage: unknown expression type: " .. tostring(arg1_8))

			return nil
		end)

		setActive(var0_8, false)
		setActive(var0_8, true)
	end)
	arg0_5:bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function(arg0_12, arg1_12)
		if arg1_12 and arg1_12.data and arg1_12.data.hideUI == false then
			return
		end

		arg0_5:Hide()
	end)
	arg0_5:bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function(arg0_13, arg1_13)
		if arg1_13 and arg1_13.data and arg1_13.data.hideUI == false then
			return
		end

		arg0_5:Show()
	end)
	arg0_5:bind(CarWashTimelineSystem.TRANSITION_BEGIN, function()
		arg0_5:EnableBlock(true)
	end)
	arg0_5:bind(CarWashTimelineSystem.TRANSITION_END, function()
		arg0_5:EnableBlock(false)
	end)
end

function var0_0.UpdatePOV(arg0_16)
	local var0_16 = arg0_16.povLayer:Find("Move"):GetComponent(typeof(SlideController))

	var0_16:AddBeginDragFunc(function(arg0_17, arg1_17)
		arg0_16:emit(CarWashPovControlSystem.ON_STICK_MOVE_BEGIN, arg1_17)
	end)
	var0_16:SetStickFunc(function(arg0_18)
		arg0_16:emit(CarWashPovControlSystem.ON_STICK_MOVE, arg0_18)
	end)
	var0_16:AddDragEndFunc(function(arg0_19, arg1_19)
		arg0_16:emit(CarWashPovControlSystem.ON_STICK_MOVE_END, arg1_19)
	end)
	arg0_16.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_20)
		arg0_16:emit(CarWashPovControlSystem.ON_STICK_VIEW, arg0_20)
	end)
end

function var0_0.Flush(arg0_21)
	return
end

function var0_0.UpdateExpressionHUDPosition(arg0_22, arg1_22)
	if not arg1_22 then
		return
	end

	setActive(arg0_22.expressionRoot, arg1_22.visible)

	if arg1_22.visible then
		setLocalPosition(arg0_22.expressionRoot, LuaHelper.ScreenToLocal(arg0_22.expressionRoot.parent, arg1_22.screenPosition, pg.UIMgr.GetInstance().uiCameraComp))
	end
end

function var0_0.ShowHelpBox(arg0_23, arg1_23)
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		title = i18n("dorm3d_carwash_title"),
		contentText = i18n("dorm3d_carwash_tiiiiiip"),
		onConfirm = function()
			existCall(arg1_23)
		end,
		onClose = function()
			existCall(arg1_23)
		end
	})
end

function var0_0.EnableBlock(arg0_26, arg1_26)
	setActive(arg0_26.blockLayer, arg1_26)
end

function var0_0.ShowBlackScreen(arg0_27, arg1_27, arg2_27)
	local var0_27 = {
		color = "#000000",
		time = 0.3,
		delay = arg1_27 and 0 or 0.3
	}

	setImageColor(arg0_27.blackLayer, Color.NewHex(var0_27.color))
	setActive(arg0_27.blackLayer, true)
	setCanvasGroupAlpha(arg0_27.blackLayer, arg1_27 and 0 or 1)
	arg0_27:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_27 then
			setActive(arg0_27.blackLayer, false)
		end

		existCall(arg2_27)
	end, GetComponent(arg0_27.blackLayer, typeof(CanvasGroup)), arg1_27 and 1 or 0, var0_27.time):setDelay(var0_27.delay)
end

return var0_0

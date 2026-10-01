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

		arg0_5:SetTimelineUIVisible(false)
	end)
	arg0_5:bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function(arg0_13, arg1_13)
		if arg1_13 and arg1_13.data and arg1_13.data.hideUI == false then
			return
		end

		arg0_5:SetTimelineUIVisible(true)
	end)
	arg0_5:bind(CarWashTimelineSystem.TRANSITION_BEGIN, function()
		arg0_5:EnableBlock(true)
	end)
	arg0_5:bind(CarWashTimelineSystem.TRANSITION_END, function()
		arg0_5:EnableBlock(false)
	end)
end

function var0_0.SetTimelineUIVisible(arg0_16, arg1_16)
	if arg1_16 then
		for iter0_16, iter1_16 in ipairs(arg0_16.timelineUIGroups or {}) do
			iter1_16.group.alpha = iter1_16.alpha
			iter1_16.group.interactable = iter1_16.interactable
			iter1_16.group.blocksRaycasts = iter1_16.blocksRaycasts
		end

		arg0_16.timelineUIGroups = nil

		return
	end

	if arg0_16.timelineUIGroups then
		return
	end

	arg0_16.timelineUIGroups = {}

	eachChild(arg0_16._tf, function(arg0_17)
		if arg0_17.name == "HolyLightRoot" or arg0_17.name == "block" then
			return
		end

		local var0_17 = GetOrAddComponent(arg0_17, typeof(CanvasGroup))

		table.insert(arg0_16.timelineUIGroups, {
			group = var0_17,
			alpha = var0_17.alpha,
			interactable = var0_17.interactable,
			blocksRaycasts = var0_17.blocksRaycasts
		})

		var0_17.alpha = 0
		var0_17.interactable = false
		var0_17.blocksRaycasts = false
	end)
end

function var0_0.UpdatePOV(arg0_18)
	local var0_18 = arg0_18.povLayer:Find("Move"):GetComponent(typeof(SlideController))

	var0_18:AddBeginDragFunc(function(arg0_19, arg1_19)
		arg0_18:emit(CarWashPovControlSystem.ON_STICK_MOVE_BEGIN, arg1_19)
	end)
	var0_18:SetStickFunc(function(arg0_20)
		arg0_18:emit(CarWashPovControlSystem.ON_STICK_MOVE, arg0_20)
	end)
	var0_18:AddDragEndFunc(function(arg0_21, arg1_21)
		arg0_18:emit(CarWashPovControlSystem.ON_STICK_MOVE_END, arg1_21)
	end)
	arg0_18.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_22)
		arg0_18:emit(CarWashPovControlSystem.ON_STICK_VIEW, arg0_22)
	end)
end

function var0_0.Flush(arg0_23)
	return
end

function var0_0.UpdateExpressionHUDPosition(arg0_24, arg1_24)
	if not arg1_24 then
		return
	end

	setActive(arg0_24.expressionRoot, arg1_24.visible)

	if arg1_24.visible then
		setLocalPosition(arg0_24.expressionRoot, LuaHelper.ScreenToLocal(arg0_24.expressionRoot.parent, arg1_24.screenPosition, pg.UIMgr.GetInstance().uiCameraComp))
	end
end

function var0_0.ShowHelpBox(arg0_25, arg1_25)
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		title = i18n("dorm3d_carwash_title"),
		contentText = i18n("dorm3d_carwash_tiiiiiip"),
		onConfirm = function()
			existCall(arg1_25)
		end,
		onClose = function()
			existCall(arg1_25)
		end
	})
end

function var0_0.EnableBlock(arg0_28, arg1_28)
	setActive(arg0_28.blockLayer, arg1_28)
end

function var0_0.ShowBlackScreen(arg0_29, arg1_29, arg2_29)
	local var0_29 = {
		color = "#000000",
		time = 0.3,
		delay = arg1_29 and 0 or 0.3
	}

	setImageColor(arg0_29.blackLayer, Color.NewHex(var0_29.color))
	setActive(arg0_29.blackLayer, true)
	setCanvasGroupAlpha(arg0_29.blackLayer, arg1_29 and 0 or 1)
	arg0_29:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_29 then
			setActive(arg0_29.blackLayer, false)
		end

		existCall(arg2_29)
	end, GetComponent(arg0_29.blackLayer, typeof(CanvasGroup)), arg1_29 and 1 or 0, var0_29.time):setDelay(var0_29.delay)
end

return var0_0

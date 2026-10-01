local var0_0 = class("Dorm3dIKView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

var0_0.SET_CONTROL_ACTIVE = "Dorm3dIKView.SET_CONTROL_ACTIVE"
var0_0.SET_CAMERA_BUTTON_ACTIVE = "Dorm3dIKView.SET_CAMERA_BUTTON_ACTIVE"
var0_0.RESET_ENTRY_MENU = "Dorm3dIKView.RESET_ENTRY_MENU"
var0_0.SET_BACK_BUTTON_ACTIVE = "Dorm3dIKView.SET_BACK_BUTTON_ACTIVE"
var0_0.UPDATE_TEXT_TIPS = "Dorm3dIKView.UPDATE_TEXT_TIPS"
var0_0.UPDATE_TIPS = "Dorm3dIKView.UPDATE_TIPS"
var0_0.SET_TIPS_ACTIVE = "Dorm3dIKView.SET_TIPS_ACTIVE"
var0_0.SET_HAND_POSITION = "Dorm3dIKView.SET_HAND_POSITION"
var0_0.PLAY_HAND_BEGIN = "Dorm3dIKView.PLAY_HAND_BEGIN"
var0_0.PLAY_HAND_END = "Dorm3dIKView.PLAY_HAND_END"
var0_0.UPDATE_HOLD_PROGRESS = "Dorm3dIKView.UPDATE_HOLD_PROGRESS"

function var0_0.Init(arg0_1)
	arg0_1.uiContainer = arg0_1._tf:Find("UI")
	arg0_1.rtIKUI = arg0_1.uiContainer:Find("ik")
	arg0_1.ikControlUI = arg0_1._tf:Find("IKControl")
	arg0_1.controlLayer = arg0_1.ikControlUI:Find("ControlLayer")

	arg0_1:InitIKControlRoots()
	arg0_1:InitButtons()
	arg0_1:InitDragEvent()
	arg0_1:InitEvents()
end

function var0_0.InitIKControlRoots(arg0_2)
	arg0_2.ikTipsRoot = arg0_2.ikControlUI:Find("Tips")

	setActive(arg0_2.ikTipsRoot, false)

	arg0_2.ikTouchTipsRoot = arg0_2.ikControlUI:Find("TouchTips")

	assert(not IsNil(arg0_2.ikTouchTipsRoot), "Missing IKControl/TouchTips")
	setActive(arg0_2.ikTouchTipsRoot, false)

	arg0_2.ikTouchTipTpl = arg0_2.ikTouchTipsRoot:Find("tpl")

	assert(not IsNil(arg0_2.ikTouchTipTpl), "Missing IKControl/TouchTips/tpl")
	assert(not IsNil(arg0_2.ikTouchTipTpl:Find("Click")) and not IsNil(arg0_2.ikTouchTipTpl:Find("Hold")), "TouchTips/tpl missing Click or Hold")
	setActive(arg0_2.ikTouchTipTpl, false)

	arg0_2.holdProgressRoot = arg0_2.ikControlUI:Find("HoldProgress")

	assert(not IsNil(arg0_2.holdProgressRoot), "Missing IKControl/HoldProgress")

	arg0_2.holdProgressTpl = arg0_2.holdProgressRoot:Find("tpl")

	assert(not IsNil(arg0_2.holdProgressTpl), "Missing IKControl/HoldProgress/tpl")
	setActive(arg0_2.holdProgressRoot, false)
	setActive(arg0_2.holdProgressTpl, false)

	arg0_2.ikHand = arg0_2.ikControlUI:Find("Handler")

	setActive(arg0_2.ikHand, false)
	eachChild(arg0_2.ikHand, function(arg0_3)
		setActive(arg0_3, false)
	end)

	arg0_2.ikTextTipsRoot = arg0_2.ikControlUI:Find("TextTips")

	setActive(arg0_2.ikTextTipsRoot, false)
	eachChild(arg0_2.ikTextTipsRoot, function(arg0_4)
		setActive(arg0_4, false)
	end)
	setActive(arg0_2.ikControlUI, false)
end

function var0_0.InitButtons(arg0_5)
	onButton(arg0_5, arg0_5.rtIKUI:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rtIKUI:Find("Right/btn_camera"), function()
		arg0_5:emit(RoomIKSystem.CYCLE_IK_CAMERA_GROUP)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rtIKUI:Find("Right/MenuSmall"), function()
		setActive(arg0_5.rtIKUI:Find("Right/MenuSmall"), false)
		setActive(arg0_5.rtIKUI:Find("Right/Menu"), true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rtIKUI:Find("Right/Menu/Collapse"), function()
		setActive(arg0_5.rtIKUI:Find("Right/Menu"), false)
		setActive(arg0_5.rtIKUI:Find("Right/MenuSmall"), true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rtIKUI:Find("Right/Menu"), function()
		setActive(arg0_5.rtIKUI:Find("Right"), false)
		arg0_5:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_5.contextData.GetApartment():GetConfigID(), arg0_5.contextData.GetCurrentLadyEnv(), function(arg0_11, arg1_11, arg2_11)
			arg0_5:emit(RoomIKSystem.SWITCH_IK_SKIN, arg0_11, arg1_11, arg2_11)
		end, function()
			setActive(arg0_5.rtIKUI:Find("Right"), true)
		end, true)
	end, SFX_PANEL)
end

function var0_0.InitDragEvent(arg0_13)
	local var0_13 = arg0_13.controlLayer:GetComponent(typeof(SlideController))

	if var0_13 and not IsNil(var0_13) then
		var0_13:ClearEvents()

		var0_13.enabled = false
	end

	local var1_13 = GetOrAddComponent(arg0_13.controlLayer, typeof(SlideControllerHotfix))

	var1_13:ClearEvents()

	arg0_13.ikSlideController = var1_13

	var1_13:AddPointDownFunc(function(arg0_14, arg1_14)
		arg0_13:emit(RoomIKSystem.ON_CONTROL_POINTER_DOWN, arg1_14.position)
	end)
	var1_13:AddPointUpFunc(function(arg0_15, arg1_15)
		arg0_13:emit(RoomIKSystem.ON_CONTROL_POINTER_UP, arg1_15.position)
	end)
	var1_13:AddBeginDragFunc(function(arg0_16, arg1_16)
		arg0_13:emit(RoomIKSystem.ON_CONTROL_BEGIN_DRAG, arg1_16.position)
	end)
	var1_13:AddDragFunc(function(arg0_17, arg1_17)
		arg0_13:emit(RoomIKSystem.ON_CONTROL_DRAG, arg1_17.position, arg1_17.delta)
	end)
	var1_13:AddDragEndFunc(function(arg0_18, arg1_18)
		arg0_13:emit(RoomIKSystem.ON_CONTROL_END_DRAG, arg1_18.position)
	end)
end

function var0_0.InitEvents(arg0_19)
	arg0_19:bind(var0_0.SET_CONTROL_ACTIVE, function(arg0_20, arg1_20)
		setActive(arg0_19.ikControlUI, arg1_20)

		if not arg1_20 then
			arg0_19:ResetHand()
			arg0_19:ResetHoldProgress()
		end
	end)
	arg0_19:bind(var0_0.SET_CAMERA_BUTTON_ACTIVE, function(arg0_21, arg1_21)
		setActive(arg0_19.rtIKUI:Find("Right/btn_camera"), arg1_21)
	end)
	arg0_19:bind(var0_0.RESET_ENTRY_MENU, function(arg0_22, arg1_22)
		setActive(arg0_19.rtIKUI:Find("Right/MenuSmall"), arg1_22)
		setActive(arg0_19.rtIKUI:Find("Right/Menu"), false)
	end)
	arg0_19:bind(var0_0.SET_BACK_BUTTON_ACTIVE, function(arg0_23, arg1_23)
		setActive(arg0_19.rtIKUI:Find("btn_back"), arg1_23)
	end)
	arg0_19:bind(var0_0.UPDATE_TEXT_TIPS, function(arg0_24, arg1_24)
		arg0_19:UpdateTextTips(arg1_24)
	end)
	arg0_19:bind(var0_0.UPDATE_TIPS, function(arg0_25, arg1_25, arg2_25, arg3_25)
		arg0_19:UpdateTips(arg1_25, arg2_25, arg3_25)
	end)
	arg0_19:bind(var0_0.SET_TIPS_ACTIVE, function(arg0_26, arg1_26)
		arg0_19:SetTipsActive(arg1_26)
	end)
	arg0_19:bind(var0_0.SET_HAND_POSITION, function(arg0_27, arg1_27)
		setAnchoredPosition(arg0_19.ikHand, arg1_27)
	end)
	arg0_19:bind(var0_0.PLAY_HAND_BEGIN, function()
		arg0_19:PlayHandBegin()
	end)
	arg0_19:bind(var0_0.PLAY_HAND_END, function()
		arg0_19:PlayHandEnd()
	end)
	arg0_19:bind(var0_0.UPDATE_HOLD_PROGRESS, function(arg0_30, arg1_30, arg2_30, arg3_30)
		arg0_19:UpdateHoldProgress(arg1_30, arg2_30, arg3_30)
	end)
end

function var0_0.UpdateTextTips(arg0_31, arg1_31)
	eachChild(arg0_31.ikTextTipsRoot, function(arg0_32)
		setActive(arg0_32, false)
	end)
	_.each(arg1_31 or {}, function(arg0_33)
		local var0_33 = arg0_31.ikTextTipsRoot:Find(arg0_33)

		if not IsNil(var0_33) then
			setActive(var0_33, true)
		end
	end)
end

function var0_0.SetTipsActive(arg0_34, arg1_34)
	if arg1_34 and arg0_34.holdProgressActive then
		arg1_34 = false
	end

	setActive(arg0_34.ikTipsRoot, arg1_34)
	setActive(arg0_34.ikTouchTipsRoot, arg1_34)
	setActive(arg0_34.ikTextTipsRoot, arg1_34)
end

function var0_0.UpdateHoldProgress(arg0_35, arg1_35, arg2_35, arg3_35)
	if not arg1_35 then
		arg0_35:ResetHoldProgress()

		return
	end

	arg0_35.holdProgressActive = true

	arg0_35:SetTipsActive(false)
	setActive(arg0_35.holdProgressRoot, true)
	setActive(arg0_35.holdProgressTpl, true)
	setLocalPosition(arg0_35.holdProgressTpl, LuaHelper.ScreenToLocal(arg0_35.holdProgressRoot, arg2_35, pg.UIMgr.GetInstance().uiCameraComp))

	local var0_35 = arg0_35.holdProgressTpl:Find("Progress")

	if IsNil(var0_35) then
		var0_35 = arg0_35.holdProgressTpl
	end

	local var1_35 = GetComponent(var0_35, typeof(Image))

	if not IsNil(var1_35) then
		var1_35.fillAmount = math.clamp(arg3_35 or 0, 0, 1)
	end
end

function var0_0.ResetHoldProgress(arg0_36)
	arg0_36.holdProgressActive = nil

	setActive(arg0_36.holdProgressTpl, false)
	setActive(arg0_36.holdProgressRoot, false)
end

function var0_0.SetTouchTipType(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg1_37:Find("Click")
	local var1_37 = arg1_37:Find("Hold")

	assert(not IsNil(var0_37) and not IsNil(var1_37), "TouchTips/tpl item missing Click or Hold")
	setActive(var0_37, arg2_37 == RoomTouchSystem.TRIGGER_CLICK)
	setActive(var1_37, arg2_37 == RoomTouchSystem.TRIGGER_LONG_PRESS)
end

function var0_0.GetTipLocalPosition(arg0_38, arg1_38, arg2_38)
	if not arg2_38.active then
		return Vector2.zero
	end

	assert(arg2_38.screenPosition, "Missing active IK tip screen position")

	return LuaHelper.ScreenToLocal(arg1_38, arg2_38.screenPosition, pg.UIMgr.GetInstance().uiCameraComp) + (arg2_38.offset or Vector2.zero)
end

function var0_0.GetIKTipRotation(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39:PointToNormalized(Vector2.zero)
	local var1_39 = Vector2.zero

	if var0_39.x < 0.5 and var0_39.y < 0.5 then
		var1_39 = arg1_39.max
	elseif var0_39.x >= 0.5 and var0_39.y < 0.5 then
		var1_39 = Vector2.New(arg1_39.xMin, arg1_39.yMax)
	elseif var0_39.x < 0.5 and var0_39.y >= 0.5 then
		var1_39 = Vector2.New(arg1_39.xMax, arg1_39.yMin)
	elseif var0_39.x >= 0.5 and var0_39.y >= 0.5 then
		var1_39 = arg1_39.min
	end

	if var0_39.x == 0.5 then
		if arg2_39.x < 0 then
			var1_39.x = arg1_39.xMax
		else
			var1_39.x = arg1_39.xMin
		end
	end

	if var0_39.y == 0.5 then
		if arg2_39.y < 0 then
			var1_39.y = arg1_39.yMax
		else
			var1_39.y = arg1_39.yMin
		end
	end

	local var2_39 = var1_39 - arg1_39.center

	return Quaternion.LookRotation(Vector3.forward, Vector3.New(var2_39.x, var2_39.y, 0))
end

function var0_0.UpdateTouchTips(arg0_40, arg1_40)
	UIItemList.StaticAlign(arg0_40.ikTouchTipsRoot, arg0_40.ikTouchTipTpl, #(arg1_40 or {}), function(arg0_41, arg1_41, arg2_41)
		if arg0_41 ~= UIItemList.EventUpdate then
			return
		end

		arg1_41 = arg1_41 + 1

		local var0_41 = arg1_40[arg1_41]

		arg0_40:SetTouchTipType(arg2_41, var0_41.triggerType)
		setLocalPosition(arg2_41, arg0_40:GetTipLocalPosition(arg0_40.ikTouchTipsRoot, var0_41))
		setActive(arg2_41, var0_41.active)
	end)
end

function var0_0.UpdateIKTips(arg0_42, arg1_42)
	UIItemList.StaticAlign(arg0_42.ikTipsRoot, arg0_42.ikTipsRoot:GetChild(0), #(arg1_42 or {}), function(arg0_43, arg1_43, arg2_43)
		if arg0_43 ~= UIItemList.EventUpdate then
			return
		end

		arg1_43 = arg1_43 + 1

		local var0_43 = arg1_42[arg1_43]
		local var1_43 = arg0_42:GetTipLocalPosition(arg0_42.ikTipsRoot, var0_43)
		local var2_43 = var0_43.active and arg0_42:GetIKTipRotation(var0_43.triggerRect, var1_43) or Quaternion.identity

		setLocalPosition(arg2_43, var1_43)
		setLocalRotation(arg2_43, var2_43)
		setActive(arg2_43, var0_43.active)
	end)
end

function var0_0.PlayHandBegin(arg0_44)
	setActive(arg0_44.ikHand, true)
	eachChild(arg0_44.ikHand, function(arg0_45)
		setActive(arg0_45, false)
	end)
	arg0_44:StopHandTimer()
	setActive(arg0_44.ikHand:Find("Begin"), true)

	arg0_44.handTimer = Timer.New(function()
		setActive(arg0_44.ikHand:Find("Begin"), false)
		setActive(arg0_44.ikHand:Find("Normal"), true)
	end, 0.5, 1)

	arg0_44.handTimer:Start()
end

function var0_0.ResetHand(arg0_47)
	arg0_47:StopHandTimer()
	eachChild(arg0_47.ikHand, function(arg0_48)
		setActive(arg0_48, false)
	end)
	setActive(arg0_47.ikHand, false)
end

function var0_0.PlayHandEnd(arg0_49)
	arg0_49:StopHandTimer()
	setActive(arg0_49.ikHand:Find("Begin"), false)
	setActive(arg0_49.ikHand:Find("Normal"), false)
	setActive(arg0_49.ikHand:Find("End"), true)

	arg0_49.handTimer = Timer.New(function()
		setActive(arg0_49.ikHand:Find("End"), false)
		setActive(arg0_49.ikHand, false)
	end, 0.5, 1)

	arg0_49.handTimer:Start()
end

function var0_0.StopHandTimer(arg0_51)
	if not arg0_51.handTimer then
		return
	end

	arg0_51.handTimer:Stop()

	arg0_51.handTimer = nil
end

function var0_0.UpdateTips(arg0_52, arg1_52, arg2_52, arg3_52)
	if arg1_52 then
		arg0_52:UpdateIKTips(arg2_52 or {})
		arg0_52:UpdateTouchTips(arg3_52 or {})
	end

	arg0_52:SetTipsActive(arg1_52)
end

function var0_0.Dispose(arg0_53)
	if arg0_53.ikSlideController then
		arg0_53.ikSlideController:ClearEvents()

		arg0_53.ikSlideController = nil
	end

	arg0_53:ResetHand()
	arg0_53:ResetHoldProgress()
	var0_0.super.Dispose(arg0_53)
end

return var0_0

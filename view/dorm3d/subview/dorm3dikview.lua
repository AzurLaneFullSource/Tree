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
	local var0_13
	local var1_13 = arg0_13.controlLayer:GetComponent(typeof(SlideController))

	if var1_13 and not IsNil(var1_13) then
		var1_13:ClearEvents()

		var1_13.enabled = false
	end

	local var2_13 = GetOrAddComponent(arg0_13.controlLayer, typeof(SlideControllerHotfix))

	var2_13:ClearEvents()

	arg0_13.ikSlideController = var2_13

	var2_13:AddPointDownFunc(function(arg0_14, arg1_14)
		local var0_14 = arg0_13.contextData.GetCurrentLadyEnv()
		local var1_14 = arg0_13:GetTouchTarget(var0_14, arg1_14.position)

		if not var1_14 then
			return
		end

		arg0_13.touchPressTarget = var1_14

		arg0_13:EmitTouchPress(true, var1_14, arg1_14.position)
	end)
	var2_13:AddPointUpFunc(function(arg0_15, arg1_15)
		local var0_15 = arg0_13.touchPressTarget

		arg0_13.touchPressTarget = nil

		if not var0_15 then
			return
		end

		arg0_13:EmitTouchPress(false, var0_15, arg1_15.position)
	end)
	var2_13:AddBeginDragFunc(function(arg0_16, arg1_16)
		local var0_16 = arg0_13.contextData.GetCurrentLadyEnv()

		if not var0_16.IKSettings then
			return
		end

		local var1_16 = arg1_16.position
		local var2_16 = CameraMgr.instance:Raycast(var0_16.IKSettings.CameraRaycaster, var1_16):ToTable()

		if #var2_16 <= 0 then
			return
		end

		local var3_16 = var2_16[1].gameObject.transform
		local var4_16 = table.keyof(var0_16.IKSettings.Colliders, var3_16)

		warning(var3_16, var4_16)

		if not var4_16 then
			return
		end

		arg0_13:emit(RoomIKSystem.ON_BEGIN_DRAG_CHARACTER_BODY, var0_16, var4_16, var1_16)

		var0_13 = tobool(var0_16.ikHandler)
	end)
	var2_13:AddDragFunc(function(arg0_17, arg1_17)
		local var0_17 = arg0_13.contextData.GetCurrentLadyEnv()

		if var0_17.ikHandler then
			arg0_13:emit(RoomIKSystem.ON_DRAG_CHARACTER_BODY, var0_17, arg1_17.position)

			return
		end

		if var0_13 then
			return
		end

		arg0_13:emit(Dorm3dRoomTemplateScene.ON_STICK_MOVE, arg1_17.delta)
	end)
	var2_13:AddDragEndFunc(function(arg0_18, arg1_18)
		var0_13 = nil

		local var0_18 = arg0_13.contextData.GetCurrentLadyEnv()

		if var0_18.ikHandler then
			arg0_13:emit(RoomIKSystem.ON_RELEASE_CHARACTER_BODY, var0_18)
		end
	end)
end

function var0_0.GetTouchTarget(arg0_19, arg1_19, arg2_19)
	if not arg1_19 or not arg1_19.IKSettings then
		return
	end

	local var0_19 = CameraMgr.instance:Raycast(arg1_19.IKSettings.CameraRaycaster, arg2_19):ToTable()

	for iter0_19, iter1_19 in ipairs(var0_19) do
		local var1_19 = iter1_19.gameObject.transform
		local var2_19 = table.keyof(arg1_19.IKSettings.Colliders, var1_19)

		if var2_19 then
			return {
				source = "body",
				target = var2_19
			}
		end

		local var3_19 = arg0_19:GetTouchSceneItem(arg1_19, var1_19)

		if var3_19 then
			return {
				source = "scene_item",
				target = var3_19
			}
		end
	end
end

function var0_0.GetTouchSceneItem(arg0_20, arg1_20, arg2_20)
	if not arg1_20.iKTouchDatas then
		return
	end

	for iter0_20, iter1_20 in ipairs(arg1_20.iKTouchDatas) do
		local var0_20 = pg.dorm3d_ik_touch[iter1_20[1]]

		if #var0_20.scene_item > 0 then
			local var1_20 = arg0_20.contextData.GetSceneItem(var0_20.scene_item)

			if var1_20 and var0_0.IsTransformInHierarchy(arg2_20, var1_20) then
				return var0_20.scene_item
			end
		end
	end
end

function var0_0.IsTransformInHierarchy(arg0_21, arg1_21)
	while arg0_21 do
		if arg0_21 == arg1_21 then
			return true
		end

		arg0_21 = arg0_21.parent
	end

	return false
end

function var0_0.EmitTouchPress(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg2_22.source == "body" then
		arg0_22:emit(arg1_22 and RoomTouchSystem.ON_TOUCH_CHARACTER_DOWN or RoomTouchSystem.ON_TOUCH_CHARACTER_UP, arg2_22.target, arg3_22)
	elseif arg2_22.source == "scene_item" then
		arg0_22:emit(arg1_22 and RoomTouchSystem.ON_TOUCH_SCENE_ITEM_DOWN or RoomTouchSystem.ON_TOUCH_SCENE_ITEM_UP, arg2_22.target, arg3_22)
	end
end

function var0_0.InitEvents(arg0_23)
	arg0_23:bind(var0_0.SET_CONTROL_ACTIVE, function(arg0_24, arg1_24)
		setActive(arg0_23.ikControlUI, arg1_24)

		if not arg1_24 then
			arg0_23:ResetHand()
			arg0_23:ResetHoldProgress()

			arg0_23.touchPressTarget = nil
		end
	end)
	arg0_23:bind(var0_0.SET_CAMERA_BUTTON_ACTIVE, function(arg0_25, arg1_25)
		setActive(arg0_23.rtIKUI:Find("Right/btn_camera"), arg1_25)
	end)
	arg0_23:bind(var0_0.RESET_ENTRY_MENU, function(arg0_26, arg1_26)
		setActive(arg0_23.rtIKUI:Find("Right/MenuSmall"), arg1_26)
		setActive(arg0_23.rtIKUI:Find("Right/Menu"), false)
	end)
	arg0_23:bind(var0_0.SET_BACK_BUTTON_ACTIVE, function(arg0_27, arg1_27)
		setActive(arg0_23.rtIKUI:Find("btn_back"), arg1_27)
	end)
	arg0_23:bind(var0_0.UPDATE_TEXT_TIPS, function(arg0_28, arg1_28)
		arg0_23:UpdateTextTips(arg1_28)
	end)
	arg0_23:bind(var0_0.UPDATE_TIPS, function(arg0_29, arg1_29, arg2_29)
		arg0_23:UpdateTips(arg1_29, arg2_29)
	end)
	arg0_23:bind(var0_0.SET_TIPS_ACTIVE, function(arg0_30, arg1_30)
		arg0_23:SetTipsActive(arg1_30)
	end)
	arg0_23:bind(var0_0.SET_HAND_POSITION, function(arg0_31, arg1_31)
		setAnchoredPosition(arg0_23.ikHand, arg1_31)
	end)
	arg0_23:bind(var0_0.PLAY_HAND_BEGIN, function()
		arg0_23:PlayHandBegin()
	end)
	arg0_23:bind(var0_0.PLAY_HAND_END, function()
		arg0_23:PlayHandEnd()
	end)
	arg0_23:bind(var0_0.UPDATE_HOLD_PROGRESS, function(arg0_34, arg1_34, arg2_34, arg3_34)
		arg0_23:UpdateHoldProgress(arg1_34, arg2_34, arg3_34)
	end)
end

function var0_0.UpdateTextTips(arg0_35, arg1_35)
	eachChild(arg0_35.ikTextTipsRoot, function(arg0_36)
		setActive(arg0_36, false)
	end)
	_.each(arg1_35 or {}, function(arg0_37)
		local var0_37 = arg0_37:getConfig("tip_text")

		if not var0_37 or #var0_37 == 0 then
			return
		end

		local var1_37 = arg0_35.ikTextTipsRoot:Find(var0_37)

		if not IsNil(var1_37) then
			setActive(var1_37, true)
		end
	end)
end

function var0_0.SetTipsActive(arg0_38, arg1_38)
	if arg1_38 and arg0_38.holdProgressActive then
		arg1_38 = false
	end

	setActive(arg0_38.ikTipsRoot, arg1_38)
	setActive(arg0_38.ikTouchTipsRoot, arg1_38)
	setActive(arg0_38.ikTextTipsRoot, arg1_38)
end

function var0_0.UpdateHoldProgress(arg0_39, arg1_39, arg2_39, arg3_39)
	if not arg1_39 then
		arg0_39:ResetHoldProgress()

		return
	end

	arg0_39.holdProgressActive = true

	arg0_39:SetTipsActive(false)
	setActive(arg0_39.holdProgressRoot, true)
	setActive(arg0_39.holdProgressTpl, true)
	setLocalPosition(arg0_39.holdProgressTpl, LuaHelper.ScreenToLocal(arg0_39.holdProgressRoot, arg2_39, pg.UIMgr.GetInstance().uiCameraComp))

	local var0_39 = arg0_39.holdProgressTpl:Find("Progress")

	if IsNil(var0_39) then
		var0_39 = arg0_39.holdProgressTpl
	end

	local var1_39 = GetComponent(var0_39, typeof(Image))

	if not IsNil(var1_39) then
		var1_39.fillAmount = math.clamp(arg3_39 or 0, 0, 1)
	end
end

function var0_0.ResetHoldProgress(arg0_40)
	arg0_40.holdProgressActive = nil

	setActive(arg0_40.holdProgressTpl, false)
	setActive(arg0_40.holdProgressRoot, false)
end

function var0_0.SetTouchTipType(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg1_41:Find("Click")
	local var1_41 = arg1_41:Find("Hold")

	assert(not IsNil(var0_41) and not IsNil(var1_41), "TouchTips/tpl item missing Click or Hold")
	setActive(var0_41, arg2_41 == RoomTouchSystem.TRIGGER_CLICK)
	setActive(var1_41, arg2_41 == RoomTouchSystem.TRIGGER_LONG_PRESS)
end

function var0_0.UpdateTouchTips(arg0_42, arg1_42, arg2_42)
	UIItemList.StaticAlign(arg0_42.ikTouchTipsRoot, arg0_42.ikTouchTipTpl, #arg2_42, function(arg0_43, arg1_43, arg2_43)
		if arg0_43 ~= UIItemList.EventUpdate then
			return
		end

		arg1_43 = arg1_43 + 1

		local var0_43
		local var1_43 = Vector2.zero
		local var2_43 = arg2_42[arg1_43][1]
		local var3_43 = pg.dorm3d_ik_touch[var2_43]

		arg0_42:SetTouchTipType(arg2_43, var3_43.trigger_type)

		if var3_43.tip_offset and var3_43.tip_offset ~= "" then
			var1_43 = Vector2.New(unpack(var3_43.tip_offset))
		end

		if #var3_43.scene_item > 0 then
			var0_43 = arg0_42.contextData.GetSceneItem(var3_43.scene_item)
		else
			var0_43 = arg1_42.IKSettings.Colliders[var3_43.body]
		end

		if var0_43 then
			local var4_43 = var0_43.position
			local var5_43 = var0_43:GetComponent(typeof(UnityEngine.Collider))

			if var5_43 then
				var4_43 = var5_43.bounds.center
			end

			setLocalPosition(arg2_43, arg0_42.contextData.GetLocalPosition(arg0_42.contextData.GetScreenPosition(var4_43, arg1_42.IKSettings.CameraRaycaster.eventCamera), arg0_42.ikTouchTipsRoot) + var1_43)
		end

		setActive(arg2_43, var0_43)
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

function var0_0.UpdateTips(arg0_52, arg1_52, arg2_52)
	if arg1_52 and arg2_52 then
		local var0_52 = _.filter(arg2_52.readyIKLayers or {}, function(arg0_53)
			return not arg0_53.ignoreDrag
		end)

		UIItemList.StaticAlign(arg0_52.ikTipsRoot, arg0_52.ikTipsRoot:GetChild(0), #var0_52, function(arg0_54, arg1_54, arg2_54)
			if arg0_54 ~= UIItemList.EventUpdate then
				return
			end

			arg1_54 = arg1_54 + 1

			local var0_54
			local var1_54 = Vector2.zero
			local var2_54 = var0_52[arg1_54]
			local var3_54 = var2_54:GetTriggerBoneName()
			local var4_54 = var3_54 and arg2_52.IKSettings.Colliders[var3_54] or nil
			local var5_54 = var2_54:GetIKTipOffset()

			if var4_54 then
				local var6_54 = var4_54.position
				local var7_54 = var4_54:GetComponent(typeof(UnityEngine.Collider))

				if var7_54 then
					var6_54 = var7_54.bounds.center
				end

				local var8_54 = arg0_52.contextData.GetLocalPosition(arg0_52.contextData.GetScreenPosition(var6_54, arg2_52.IKSettings.CameraRaycaster.eventCamera), arg0_52.ikTipsRoot) + var5_54

				setLocalPosition(arg2_54, var8_54)

				local var9_54 = var2_54:GetTriggerRect()
				local var10_54 = var9_54:PointToNormalized(Vector2.zero)
				local var11_54 = Vector2.zero

				if var10_54.x < 0.5 and var10_54.y < 0.5 then
					var11_54 = var9_54.max
				elseif var10_54.x >= 0.5 and var10_54.y < 0.5 then
					var11_54 = Vector2.New(var9_54.xMin, var9_54.yMax)
				elseif var10_54.x < 0.5 and var10_54.y >= 0.5 then
					var11_54 = Vector2.New(var9_54.xMax, var9_54.yMin)
				elseif var10_54.x >= 0.5 and var10_54.y >= 0.5 then
					var11_54 = var9_54.min
				end

				if var10_54.x == 0.5 then
					if var8_54.x < 0 then
						var11_54.x = var9_54.xMax
					else
						var11_54.x = var9_54.xMin
					end
				end

				if var10_54.y == 0.5 then
					if var8_54.y < 0 then
						var11_54.y = var9_54.yMax
					else
						var11_54.y = var9_54.yMin
					end
				end

				local var12_54 = var11_54 - var9_54.center

				setLocalRotation(arg2_54, Quaternion.LookRotation(Vector3.forward, Vector3.New(var12_54.x, var12_54.y, 0)))
			end

			setActive(arg2_54, var4_54)
		end)
		arg0_52:UpdateTouchTips(arg2_52, arg2_52.iKTouchDatas or {})
	end

	arg0_52:SetTipsActive(arg1_52)
end

function var0_0.Dispose(arg0_55)
	if arg0_55.ikSlideController then
		arg0_55.ikSlideController:ClearEvents()

		arg0_55.ikSlideController = nil
	end

	arg0_55:ResetHand()
	arg0_55:ResetHoldProgress()
	var0_0.super.Dispose(arg0_55)
end

return var0_0

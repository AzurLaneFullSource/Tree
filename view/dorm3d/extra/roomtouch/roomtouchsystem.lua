local var0_0 = class("RoomTouchSystem", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.ENTER_TOUCH_MODE = "RoomTouchSystem.ENTER_TOUCH_MODE"
var0_0.EXIT_TOUCH_MODE = "RoomTouchSystem.EXIT_TOUCH_MODE"
var0_0.EXIT_HEARTBEAT_MODE = "RoomTouchSystem.EXIT_HEARTBEAT_MODE"
var0_0.ON_TOUCH_CHARACTER_DOWN = "RoomTouchSystem.ON_TOUCH_CHARACTER_DOWN"
var0_0.ON_TOUCH_CHARACTER_UP = "RoomTouchSystem.ON_TOUCH_CHARACTER_UP"
var0_0.ON_TOUCH_SCENE_ITEM_DOWN = "RoomTouchSystem.ON_TOUCH_SCENE_ITEM_DOWN"
var0_0.ON_TOUCH_SCENE_ITEM_UP = "RoomTouchSystem.ON_TOUCH_SCENE_ITEM_UP"
var0_0.CANCEL_TOUCH_PRESS = "RoomTouchSystem.CANCEL_TOUCH_PRESS"
var0_0.VALIDATE_TOUCH_CONFIGS = "RoomTouchSystem.VALIDATE_TOUCH_CONFIGS"
var0_0.UPDATE_TOUCH_PANEL = "RoomTouchSystem.UPDATE_TOUCH_PANEL"
var0_0.UPDATE_TOUCH_COUNT = "RoomTouchSystem.UPDATE_TOUCH_COUNT"
var0_0.UPDATE_TOUCH_LEVEL = "RoomTouchSystem.UPDATE_TOUCH_LEVEL"
var0_0.UPDATE_TOUCH_DISPLAY = "RoomTouchSystem.UPDATE_TOUCH_DISPLAY"
var0_0.GET_TOUCH_GAME_STATE = "RoomTouchSystem.GET_TOUCH_GAME_STATE"
var0_0.SET_TOUCH_EXIT_CALL = "RoomTouchSystem.SET_TOUCH_EXIT_CALL"
var0_0.TRIGGER_CLICK = 1
var0_0.TRIGGER_LONG_PRESS = 2
var0_0.HOLD_PROGRESS_SHOW_DELAY = 0.5

function var0_0.RegisterEvents(arg0_1)
	arg0_1:Bind(var0_0.ENTER_TOUCH_MODE, function(arg0_2, arg1_2)
		arg0_1:EnterTouchMode(arg1_2)
	end)
	arg0_1:Bind(var0_0.EXIT_TOUCH_MODE, function()
		arg0_1:ExitTouchMode()
	end)
	arg0_1:Bind(var0_0.EXIT_HEARTBEAT_MODE, function()
		arg0_1:ExitHeartbeatMode()
	end)
	arg0_1:Bind(var0_0.ON_TOUCH_CHARACTER_DOWN, function(arg0_5, arg1_5, arg2_5)
		arg0_1:OnTouchPressDown("body", arg1_5, arg2_5)
	end)
	arg0_1:Bind(var0_0.ON_TOUCH_CHARACTER_UP, function(arg0_6, arg1_6)
		arg0_1:OnTouchPressUp("body", arg1_6)
	end)
	arg0_1:Bind(var0_0.ON_TOUCH_SCENE_ITEM_DOWN, function(arg0_7, arg1_7, arg2_7)
		arg0_1:OnTouchPressDown("scene_item", arg1_7, arg2_7)
	end)
	arg0_1:Bind(var0_0.ON_TOUCH_SCENE_ITEM_UP, function(arg0_8, arg1_8)
		arg0_1:OnTouchPressUp("scene_item", arg1_8)
	end)
	arg0_1:Bind(var0_0.CANCEL_TOUCH_PRESS, function()
		arg0_1:CancelAllTouchPress()
	end)
	arg0_1:Bind(var0_0.VALIDATE_TOUCH_CONFIGS, function(arg0_10, arg1_10, arg2_10)
		arg0_1:ValidateTouchConfigs(arg1_10, arg2_10)
	end)
	arg0_1:Bind(RoomIKSystem.ON_IK_STATUS_CHANGED, function(arg0_11, arg1_11, arg2_11)
		local var0_11 = arg0_1:GetCurrentLadyEnv()

		if not arg0_1:Func("GetBlackboardValue", var0_11, "inTouching") then
			return
		end

		arg0_1:DoTouch(arg1_11, arg2_11)
	end)
	arg0_1:Bind(RoomIKSystem.ON_IK_LAYER_ACTION, function(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
		arg0_1:TouchModeAction(arg1_12, arg2_12, unpack(arg3_12))(arg4_12)
	end)
	arg0_1:Bind(var0_0.GET_TOUCH_GAME_STATE, function(arg0_13, arg1_13)
		if arg1_13 then
			arg1_13.inTouchGame = arg0_1.inTouchGame
		end
	end)
	arg0_1:Bind(var0_0.SET_TOUCH_EXIT_CALL, function(arg0_14, arg1_14)
		arg0_1.touchExitCall = arg1_14
	end)
end

function var0_0.OnDispose(arg0_15)
	arg0_15:CancelAllTouchPress()

	if arg0_15.downTimer then
		arg0_15.downTimer:Stop()

		arg0_15.downTimer = nil
	end

	if arg0_15.sliderLT and LeanTween.isTweening(arg0_15.sliderLT) then
		LeanTween.cancel(arg0_15.sliderLT)

		arg0_15.sliderLT = nil
	end
end

function var0_0.OnUpdate(arg0_16)
	arg0_16:UpdateHoldProgress()
end

function var0_0.EnterTouchMode(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetCurrentLadyEnv()

	if arg0_17:Func("GetBlackboardValue", var0_17, "inTouching") then
		return
	end

	arg1_17 = arg1_17 or arg0_17:GetRoom():getApartmentZoneConfig(var0_17.ladyBaseZone, "touch_id", arg0_17:Get("apartment"):GetConfigID())
	arg0_17.touchConfig = pg.dorm3d_touch_data[arg1_17]

	if not arg0_17.touchConfig then
		warning("dorm3d_touch_data no config for id:" .. tostring(arg1_17))

		return
	end

	arg0_17.inTouchGame = arg0_17.touchConfig.heartbeat_enable > 0

	arg0_17:Emit(var0_0.UPDATE_TOUCH_PANEL, arg0_17.inTouchGame)

	if arg0_17.inTouchGame then
		arg0_17.touchCount = 0
		arg0_17.touchLevel = 1
		arg0_17.lastCount = 0
		arg0_17.topCount = 0

		arg0_17:Emit(var0_0.UPDATE_TOUCH_DISPLAY, arg0_17.touchLevel, arg0_17.touchCount)

		arg0_17.downTimer = Timer.New(function()
			local var0_18 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_17.touchLevel > 1 then
				var0_18 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_17:UpdateTouchCount(var0_18)
		end, 1, -1)

		arg0_17.downTimer:Start()
	end

	local var1_17 = {}

	table.insert(var1_17, function(arg0_19)
		arg0_17:Func("SetBlackboardValue", var0_17, "inTouching", true)
		arg0_17:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
		arg0_17:Func("SetUI", arg0_19, "blank")
	end)
	table.insert(var1_17, function(arg0_20)
		local var0_20 = arg0_17.touchConfig.ik_status[1]

		arg0_17:Emit(RoomIKSystem.SET_IK_CONFIG, var0_17, var0_20)
		arg0_17:Emit(RoomIKSystem.SET_IK_STATE, true, arg0_20)
	end)
	table.insert(var1_17, function(arg0_21)
		existCall(arg0_21)
	end)
	seriesAsync(var1_17, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_17:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_23)
	local var0_23 = arg0_23:GetCurrentLadyEnv()

	if not arg0_23:Func("GetBlackboardValue", var0_23, "inTouching") then
		return
	end

	local var1_23 = {}

	arg0_23:CancelAllTouchPress()

	if arg0_23.inTouchGame then
		table.insert(var1_23, function(arg0_24)
			arg0_23:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
			arg0_23:Emit(var0_0.UPDATE_TOUCH_PANEL, false, true, arg0_24)
		end)
		table.insert(var1_23, function(arg0_25)
			local var0_25 = 0

			for iter0_25, iter1_25 in ipairs(arg0_23.touchConfig.heartbeat_favor) do
				if iter1_25[1] > arg0_23.topCount then
					break
				else
					var0_25 = iter1_25[2]
				end
			end

			if var0_25 > 0 then
				arg0_23:Emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_23:Get("apartment").configId, var0_25)
			end

			arg0_23.touchCount = nil
			arg0_23.touchLevel = nil
			arg0_23.topCount = nil

			if arg0_23.downTimer then
				arg0_23.downTimer:Stop()

				arg0_23.downTimer = nil
			end

			arg0_23.inTouchGame = false

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_25()
		end)
	else
		table.insert(var1_23, function(arg0_26)
			arg0_23:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)

			local var0_26 = arg0_23.touchConfig.default_favor

			if var0_26 > 0 then
				arg0_23:Emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_23:Get("apartment").configId, var0_26)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_26()
		end)
	end

	table.insert(var1_23, function(arg0_27)
		var0_23.ikConfig = {
			character_position = var0_23.ladyBaseZone,
			character_action = arg0_23.touchConfig.finish_action
		}

		arg0_23:Emit(Dorm3dStockingMgr.ON_EXIT_TOUCH_MODE)
		arg0_23:Emit(RoomIKSystem.SET_IK_STATE, false, arg0_27)
	end)
	table.insert(var1_23, function(arg0_28)
		var0_23.ikConfig = nil

		arg0_23:Emit(RoomIKSystem.SET_IK_SPECIAL_CALL, nil)
		arg0_23:Func("SetUI", arg0_28, "back")
	end)
	seriesAsync(var1_23, function()
		arg0_23:Func("SetBlackboardValue", var0_23, "inTouching", false)
		arg0_23:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)

		arg0_23.touchConfig = nil

		local var0_29 = arg0_23.touchExitCall

		arg0_23.touchExitCall = nil

		existCall(var0_29)
	end)
end

function var0_0.TouchModeAction(arg0_30, arg1_30, arg2_30, arg3_30, ...)
	return switch(arg3_30, {
		function(arg0_31, arg1_31)
			return function(arg0_32)
				seriesAsync({
					function(arg0_33)
						if not arg1_31 or arg1_31 == "" then
							return arg0_33()
						end

						arg0_30:Func("PlaySingleAction", arg1_30, arg1_31, arg0_33)
					end,
					function(arg0_34)
						arg0_30:Emit(RoomIKSystem.SET_IK_CONFIG, arg1_30, arg0_31)
						arg0_30:Emit(RoomIKSystem.SET_IK_STATE, true, arg0_34)
					end,
					arg0_32
				})
			end
		end,
		function()
			return function()
				local var0_36 = {}

				arg0_30:Emit(RoomIKSystem.CONSUME_IK_SPECIAL_CALL, var0_36)

				if var0_36.consumed then
					return
				end

				arg0_30:ExitTouchMode()
			end
		end,
		function(arg0_37, arg1_37)
			return function(arg0_38)
				arg0_30:Func("PlaySingleAction", arg1_30, arg1_37, arg0_38)
			end
		end,
		function(arg0_39, arg1_39, arg2_39)
			return function(arg0_40)
				seriesAsync({
					function(arg0_41)
						arg0_30:Func("DoTalk", arg1_39, arg0_41)
					end,
					function(arg0_42)
						if not arg2_39 or arg2_39 == 0 then
							return arg0_42()
						end

						arg0_30:Emit(RoomIKSystem.SET_IK_CONFIG, arg1_30, arg2_39)
						arg0_30:Emit(RoomIKSystem.SET_IK_STATE, true, arg0_42)
					end,
					arg0_40
				})
			end
		end,
		function(arg0_43, arg1_43, arg2_43, arg3_43)
			return function(arg0_44)
				arg0_30:Func("PlaySceneItemAnim", arg2_43, arg3_43)
				arg0_30:Func("PlaySingleAction", arg1_30, arg1_43, arg0_44)
			end
		end,
		function(arg0_45)
			return function(arg0_46)
				local var0_46 = pg.dorm3d_ik_touch[arg2_30]

				if #var0_46.scene_item == 0 then
					return
				end

				local var1_46 = arg0_30:GetSceneItem(var0_46.scene_item)

				if not var1_46 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_30, var0_46.scene_item))

					return
				end

				local var2_46 = var1_46:Find(arg0_45)

				if not IsNil(var2_46) then
					setActive(var2_46, false)
					setActive(var2_46, true)
				end

				arg0_46()
			end
		end,
		function(arg0_47)
			local var0_47 = pg.dorm3d_ik_touch_move[arg0_47]
			local var1_47 = var0_47.target_ik
			local var2_47 = var0_47.move_time
			local var3_47 = var0_47.ik_point
			local var4_47 = var0_47.touch_step

			arg1_30.IKSettings.forceMove = arg1_30.IKSettings.forceMove or {}

			local var5_47 = arg1_30.IKSettings.forceMove

			var5_47[var1_47] = var5_47[var1_47] or {}
			var5_47[var1_47].count = var5_47[var1_47].count or 0

			return function(arg0_48)
				seriesAsync({
					function(arg0_49)
						if var5_47[var1_47].count >= #var4_47 then
							return arg0_49()
						end

						local var0_49 = Dorm3dIK.New({
							configId = var1_47
						})
						local var1_49 = Vector2.New(unpack(var3_47))
						local var2_49 = var5_47[var1_47].count

						var5_47[var1_47].count = var2_49 + 1

						pg.IKMgr.GetInstance():ResetIK(var0_49:GetTriggerBoneName())

						local var3_49 = arg1_30.IKSettings.Colliders[var0_49:GetTriggerBoneName()]
						local var4_49 = arg0_30:Get("raycastCamera"):WorldToScreenPoint(var3_49.position)

						pg.IKMgr.GetInstance():PlayIKMove(var4_49, var0_49:GetTriggerBoneName(), var1_49, var4_47[var2_49 + 1], var2_47, function()
							var5_47[var1_47].count = 0

							arg0_49()
						end)
					end,
					arg0_48
				})
			end
		end,
		function(arg0_51)
			return function(arg0_52)
				arg0_30:Emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_51)
			end
		end,
		function(arg0_53, arg1_53)
			return function()
				local var0_54 = arg0_30:Get("apartment"):GetConfigID()

				arg0_30:Emit(RoomIKSystem.SET_IK_SWITCH_SKIN_ID, arg0_30:Get("apartment"):GetCurSkinId())
				arg1_30:SwitchCharacterSkin(var0_54, arg0_53)
				arg0_30:Emit(RoomIKSystem.SET_IK_CONFIG, arg1_30, arg1_53)
				arg0_30:Emit(RoomIKSystem.SET_IK_STATE, true)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.GetTouchPressKey(arg0_57, arg1_57, arg2_57)
	return tostring(arg1_57) .. ":" .. tostring(arg2_57)
end

function var0_0.AssertTouchSource(arg0_58, arg1_58, arg2_58)
	assert(arg1_58 == "body" or arg1_58 == "scene_item", "Unknown touch source: " .. tostring(arg1_58))
	assert(arg2_58 and arg2_58 ~= "", "Invalid touch target: " .. tostring(arg2_58))
end

function var0_0.GetTouchConfigSourceTarget(arg0_59, arg1_59, arg2_59)
	local var0_59 = type(arg1_59.body) == "string" and arg1_59.body ~= ""
	local var1_59 = type(arg1_59.scene_item) == "string" and arg1_59.scene_item ~= ""

	assert(var0_59 ~= var1_59, "Invalid dorm3d_ik_touch source: " .. tostring(arg2_59 or arg1_59.id))

	if var1_59 then
		return "scene_item", arg1_59.scene_item
	else
		return "body", arg1_59.body
	end
end

function var0_0.AssertTouchConfig(arg0_60, arg1_60)
	local var0_60 = pg.dorm3d_ik_touch[arg1_60]

	assert(var0_60, "Missing dorm3d_ik_touch config: " .. tostring(arg1_60))
	assert(var0_60.trigger_type == var0_0.TRIGGER_CLICK or var0_60.trigger_type == var0_0.TRIGGER_LONG_PRESS, "Invalid dorm3d_ik_touch trigger_type: " .. tostring(arg1_60))

	if var0_60.trigger_type == var0_0.TRIGGER_LONG_PRESS then
		assert(type(var0_60.hold_time) == "number" and var0_60.hold_time > 0, "Invalid dorm3d_ik_touch hold_time: " .. tostring(arg1_60))
	end

	arg0_60:GetTouchConfigSourceTarget(var0_60, arg1_60)

	return var0_60
end

function var0_0.ValidateTouchConfigs(arg0_61, arg1_61, arg2_61)
	assert(type(arg1_61) == "table", "Invalid dorm3d_ik_status touch_data: " .. tostring(arg2_61))

	local var0_61 = {}

	_.each(arg1_61, function(arg0_62)
		local var0_62 = arg0_62[1]
		local var1_62 = arg0_61:AssertTouchConfig(var0_62)
		local var2_62, var3_62 = arg0_61:GetTouchConfigSourceTarget(var1_62, var0_62)
		local var4_62 = var2_62 .. ":" .. var3_62 .. ":" .. tostring(var1_62.trigger_type)

		assert(not var0_61[var4_62], string.format("Duplicate dorm3d_ik_touch trigger: ids=%s,%s source=%s target=%s trigger_type=%s", tostring(var0_61[var4_62]), tostring(var0_62), var2_62, var3_62, tostring(var1_62.trigger_type)))

		var0_61[var4_62] = var0_62
	end)
end

function var0_0.GetTouchInfos(arg0_63, arg1_63, arg2_63, arg3_63)
	arg0_63:AssertTouchSource(arg1_63, arg2_63)

	local var0_63 = arg0_63:GetCurrentLadyEnv()

	if not var0_63.ikConfig then
		return {}, var0_63
	end

	assert(type(var0_63.iKTouchDatas) == "table", "Invalid current IK touch data")

	local var1_63 = {}

	for iter0_63, iter1_63 in ipairs(var0_63.iKTouchDatas) do
		local var2_63, var3_63, var4_63 = unpack(iter1_63)
		local var5_63 = arg0_63:AssertTouchConfig(var2_63)
		local var6_63, var7_63 = arg0_63:GetTouchConfigSourceTarget(var5_63, var2_63)

		if var6_63 == arg1_63 and var7_63 == arg2_63 and var5_63.trigger_type == arg3_63 then
			table.insert(var1_63, iter1_63)
		end
	end

	assert(#var1_63 <= 1, string.format("Duplicate dorm3d_ik_touch trigger: source=%s target=%s trigger_type=%s", tostring(arg1_63), tostring(arg2_63), tostring(arg3_63)))

	return var1_63, var0_63
end

function var0_0.GetFirstLongPressInfo(arg0_64, arg1_64, arg2_64)
	return arg0_64:GetTouchInfos(arg1_64, arg2_64, var0_0.TRIGGER_LONG_PRESS)[1]
end

function var0_0.OnTouchPressDown(arg0_65, arg1_65, arg2_65, arg3_65)
	arg0_65:AssertTouchSource(arg1_65, arg2_65)
	arg0_65:ClearTouchPressConsumed(arg1_65, arg2_65)
	arg0_65:CancelTouchPress(arg1_65, arg2_65)

	local var0_65 = arg0_65:GetFirstLongPressInfo(arg1_65, arg2_65)

	if not var0_65 then
		return
	end

	assert(arg3_65, "Missing touch press screenPosition")

	local var1_65 = var0_65[1]
	local var2_65 = arg0_65:AssertTouchConfig(var1_65)
	local var3_65 = arg0_65:GetTouchPressKey(arg1_65, arg2_65)
	local var4_65 = {
		triggered = false,
		holdTime = var2_65.hold_time,
		screenPosition = arg3_65,
		startTime = Time.time
	}

	var4_65.timer = Timer.New(function()
		var4_65.triggered = true
		var4_65.timer = nil

		arg0_65:HideHoldProgress()
		arg0_65:SetTouchPressConsumed(arg1_65, arg2_65)
		arg0_65:TriggerTouchInfo(var0_65)
	end, var2_65.hold_time, 1)

	var4_65.timer:Start()

	arg0_65.touchPressStates = arg0_65.touchPressStates or {}
	arg0_65.touchPressStates[var3_65] = var4_65
end

function var0_0.OnTouchPressUp(arg0_67, arg1_67, arg2_67)
	arg0_67:AssertTouchSource(arg1_67, arg2_67)

	local var0_67 = arg0_67:GetTouchPressKey(arg1_67, arg2_67)
	local var1_67 = arg0_67.touchPressStates and arg0_67.touchPressStates[var0_67] or nil
	local var2_67 = var1_67 and var1_67.triggered or arg0_67.touchPressConsumed and arg0_67.touchPressConsumed[var0_67]

	arg0_67:CancelTouchPress(arg1_67, arg2_67)
	arg0_67:ClearTouchPressConsumed(arg1_67, arg2_67)

	if var2_67 then
		return
	end

	local var3_67 = arg0_67:GetTouchInfos(arg1_67, arg2_67, var0_0.TRIGGER_CLICK)

	if not var3_67[1] then
		return
	end

	arg0_67:TriggerTouchInfo(var3_67[1])
end

function var0_0.SetTouchPressConsumed(arg0_68, arg1_68, arg2_68)
	arg0_68.touchPressConsumed = arg0_68.touchPressConsumed or {}
	arg0_68.touchPressConsumed[arg0_68:GetTouchPressKey(arg1_68, arg2_68)] = true
end

function var0_0.ClearTouchPressConsumed(arg0_69, arg1_69, arg2_69)
	if not arg0_69.touchPressConsumed then
		return
	end

	arg0_69.touchPressConsumed[arg0_69:GetTouchPressKey(arg1_69, arg2_69)] = nil
end

function var0_0.CancelTouchPress(arg0_70, arg1_70, arg2_70)
	if not arg0_70.touchPressStates then
		return
	end

	local var0_70 = arg0_70:GetTouchPressKey(arg1_70, arg2_70)
	local var1_70 = arg0_70.touchPressStates[var0_70]

	if var1_70 and var1_70.timer then
		var1_70.timer:Stop()
	end

	arg0_70:HideHoldProgress()

	arg0_70.touchPressStates[var0_70] = nil
end

function var0_0.CancelAllTouchPress(arg0_71)
	arg0_71:HideHoldProgress()

	if not arg0_71.touchPressStates then
		return
	end

	for iter0_71, iter1_71 in pairs(arg0_71.touchPressStates) do
		if iter1_71.timer then
			iter1_71.timer:Stop()
		end
	end

	arg0_71.touchPressStates = nil
end

function var0_0.HideHoldProgress(arg0_72)
	if not arg0_72.holdProgressActive then
		return
	end

	arg0_72.holdProgressActive = nil

	arg0_72:Emit(Dorm3dIKView.UPDATE_HOLD_PROGRESS, false)
end

function var0_0.UpdateHoldProgress(arg0_73)
	if not arg0_73.touchPressStates then
		arg0_73:HideHoldProgress()

		return
	end

	for iter0_73, iter1_73 in pairs(arg0_73.touchPressStates) do
		if not iter1_73.triggered and iter1_73.holdTime > var0_0.HOLD_PROGRESS_SHOW_DELAY then
			local var0_73 = Time.time - iter1_73.startTime

			if var0_73 >= var0_0.HOLD_PROGRESS_SHOW_DELAY then
				arg0_73.holdProgressActive = true

				arg0_73:Emit(Dorm3dIKView.UPDATE_HOLD_PROGRESS, true, iter1_73.screenPosition, var0_73 / iter1_73.holdTime)

				return
			end
		end
	end

	arg0_73:HideHoldProgress()
end

function var0_0.TriggerTouchInfo(arg0_74, arg1_74)
	local var0_74 = arg0_74:GetCurrentLadyEnv()
	local var1_74, var2_74, var3_74 = unpack(arg1_74)
	local var4_74 = arg0_74:AssertTouchConfig(var1_74)
	local var5_74 = var4_74.action_emote

	if #var5_74 > 0 then
		arg0_74:Func("PlayFaceAnim", var0_74, var5_74)
	end

	local var6_74 = var4_74.vibrate

	if type(var6_74) == "table" and VibrateMgr.Instance:IsSupport() then
		local var7_74 = {}
		local var8_74 = {}
		local var9_74 = {}

		underscore.each(var6_74, function(arg0_75)
			local var0_75 = arg0_75[1]

			if PLATFORM == PLATFORM_IPHONEPLAYER then
				var0_75 = var0_75 / 1000
			end

			table.insert(var7_74, var0_75)
			table.insert(var8_74, arg0_75[2])
			table.insert(var9_74, 1)
		end)

		if PLATFORM == PLATFORM_ANDROID then
			VibrateMgr.Instance:VibrateWaveform(var7_74, var8_74)
		elseif PLATFORM == PLATFORM_IPHONEPLAYER then
			VibrateMgr.Instance:VibrateWaveform(var7_74, var8_74, var9_74)
		end
	end

	arg0_74:Emit(RoomIKSystem.SET_IK_BLOCK, true)
	arg0_74:TouchModeAction(var0_74, var1_74, unpack(var3_74))(function()
		arg0_74:Emit(RoomIKSystem.RESET_IK_TIP_TIMER)
		arg0_74:Emit(RoomIKSystem.SET_IK_BLOCK, nil)
	end)
end

function var0_0.UpdateTouchCount(arg0_77, arg1_77)
	if arg0_77.touchLevel > 1 then
		arg1_77 = math.min(0, arg1_77)
	end

	local var0_77 = arg0_77.touchLevel > 1 and 100 or 0
	local var1_77 = arg0_77.touchLevel > 1 and 200 or 100

	arg0_77.touchCount = math.clamp(arg0_77.touchCount + arg1_77, var0_77, var1_77)

	local var2_77

	if arg0_77.touchLevel == 1 and arg0_77.touchCount >= 100 then
		var2_77 = 2
	elseif arg0_77.touchLevel > 1 and arg0_77.touchCount <= 100 then
		var2_77 = 1
	end

	if var2_77 and var2_77 ~= arg0_77.touchLevel then
		local var3_77 = {}

		arg0_77:Emit(RoomIKSystem.GET_IK_BLOCK, var3_77)

		if var3_77.blockIK then
			arg0_77:Emit(var0_0.UPDATE_TOUCH_COUNT, arg0_77.touchCount)

			arg0_77.topCount = math.max(arg0_77.topCount, arg0_77.touchCount)

			return
		end

		arg0_77.touchLevel = var2_77

		local var4_77 = arg0_77.touchConfig.ik_status[var2_77]

		if var4_77 then
			if var2_77 > 1 then
				arg0_77.touchCount = 200
			elseif var2_77 == 1 then
				arg0_77.touchCount = 0
			end

			local var5_77 = arg0_77:GetCurrentLadyEnv()

			seriesAsync({
				function(arg0_78)
					arg0_77:Func("ShowBlackScreen", true, arg0_78)
				end,
				function(arg0_79)
					arg0_77:Emit(RoomIKSystem.SET_IK_CONFIG, var5_77, var4_77)
					arg0_77:Emit(RoomIKSystem.SET_IK_STATE, true, arg0_79)

					if var2_77 > 1 and arg0_77.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_77:Func("SwitchAnim", var5_77, arg0_77.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_80)
					arg0_77:Func("ShowBlackScreen", false, arg0_80)
				end
			})
		end

		arg0_77:Emit(var0_0.UPDATE_TOUCH_DISPLAY, arg0_77.touchLevel, arg0_77.touchCount)
	else
		arg0_77:Emit(var0_0.UPDATE_TOUCH_COUNT, arg0_77.touchCount)
	end

	arg0_77.topCount = math.max(arg0_77.topCount, arg0_77.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_81)
	if not arg0_81.touchLevel or arg0_81.touchLevel == 1 then
		return
	end

	arg0_81.touchCount = 0

	arg0_81:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_82, arg1_82, arg2_82)
	if arg0_82.inTouchGame then
		switch(arg2_82, {
			function()
				arg0_82:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_82:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_82:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_82:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

return var0_0

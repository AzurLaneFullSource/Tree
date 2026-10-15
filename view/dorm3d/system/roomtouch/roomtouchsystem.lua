local var0_0 = class("RoomTouchSystem", import("view.dorm3d.Core.BaseSystem"))
local var1_0 = import("view.dorm3d.System.RoomTouch.RoomTouchTriggerRunner")

var0_0.ENTER_TOUCH_MODE = "RoomTouchSystem.ENTER_TOUCH_MODE"
var0_0.EXIT_TOUCH_MODE = "RoomTouchSystem.EXIT_TOUCH_MODE"
var0_0.EXIT_HEARTBEAT_MODE = "RoomTouchSystem.EXIT_HEARTBEAT_MODE"
var0_0.ON_TOUCH_CHARACTER_DOWN = "RoomTouchSystem.ON_TOUCH_CHARACTER_DOWN"
var0_0.ON_TOUCH_CHARACTER_UP = "RoomTouchSystem.ON_TOUCH_CHARACTER_UP"
var0_0.ON_TOUCH_SCENE_ITEM_DOWN = "RoomTouchSystem.ON_TOUCH_SCENE_ITEM_DOWN"
var0_0.ON_TOUCH_SCENE_ITEM_UP = "RoomTouchSystem.ON_TOUCH_SCENE_ITEM_UP"
var0_0.CANCEL_TOUCH_PRESS = "RoomTouchSystem.CANCEL_TOUCH_PRESS"
var0_0.SET_ACTIVE_IK_TOUCH_DATA = "RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA"
var0_0.UPDATE_TOUCH_PANEL = "RoomTouchSystem.UPDATE_TOUCH_PANEL"
var0_0.UPDATE_TOUCH_COUNT = "RoomTouchSystem.UPDATE_TOUCH_COUNT"
var0_0.UPDATE_TOUCH_LEVEL = "RoomTouchSystem.UPDATE_TOUCH_LEVEL"
var0_0.UPDATE_TOUCH_DISPLAY = "RoomTouchSystem.UPDATE_TOUCH_DISPLAY"
var0_0.GET_TOUCH_GAME_STATE = "RoomTouchSystem.GET_TOUCH_GAME_STATE"
var0_0.SET_TOUCH_EXIT_CALL = "RoomTouchSystem.SET_TOUCH_EXIT_CALL"
var0_0.TRIGGER_CLICK = var1_0.TRIGGER_CLICK
var0_0.TRIGGER_LONG_PRESS = var1_0.TRIGGER_LONG_PRESS
var0_0.MODE_STATE = {
	IDLE = "idle",
	ENTERING = "entering",
	EXITING = "exiting",
	ACTIVE = "active"
}

function var0_0.OnInit(arg0_1)
	arg0_1.modeState = var0_0.MODE_STATE.IDLE
	arg0_1.transitionSerial = 0
	arg0_1.touchTriggerRunner = var1_0.New(arg0_1)
	arg0_1.activeIkTouchData = nil
	arg0_1.touchForceMove = nil
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.ENTER_TOUCH_MODE, function(arg0_3, arg1_3)
		arg0_2:EnterTouchMode(arg1_3)
	end)
	arg0_2:Bind(var0_0.EXIT_TOUCH_MODE, function()
		arg0_2:ExitTouchMode()
	end)
	arg0_2:Bind(var0_0.EXIT_HEARTBEAT_MODE, function()
		arg0_2:ExitHeartbeatMode()
	end)
	arg0_2:Bind(var0_0.ON_TOUCH_CHARACTER_DOWN, function(arg0_6, arg1_6, arg2_6)
		arg0_2.touchTriggerRunner:OnTouchPressDown("body", arg1_6, arg2_6)
	end)
	arg0_2:Bind(var0_0.ON_TOUCH_CHARACTER_UP, function(arg0_7, arg1_7)
		arg0_2.touchTriggerRunner:OnTouchPressUp("body", arg1_7)
	end)
	arg0_2:Bind(var0_0.ON_TOUCH_SCENE_ITEM_DOWN, function(arg0_8, arg1_8, arg2_8)
		arg0_2.touchTriggerRunner:OnTouchPressDown("scene_item", arg1_8, arg2_8)
	end)
	arg0_2:Bind(var0_0.ON_TOUCH_SCENE_ITEM_UP, function(arg0_9, arg1_9)
		arg0_2.touchTriggerRunner:OnTouchPressUp("scene_item", arg1_9)
	end)
	arg0_2:Bind(var0_0.CANCEL_TOUCH_PRESS, function()
		arg0_2.touchTriggerRunner:CancelAllTouchPress()
	end)
	arg0_2:Bind(var0_0.SET_ACTIVE_IK_TOUCH_DATA, function(arg0_11, arg1_11, arg2_11)
		arg0_2:SetActiveIKTouchData(arg1_11, arg2_11)
	end)
	arg0_2:Bind(RoomIKSystem.ON_IK_STATUS_CHANGED, function(arg0_12, arg1_12, arg2_12)
		if not arg0_2:IsTouchModeActive() then
			return
		end

		arg0_2:DoTouch(arg1_12, arg2_12)
	end)
	arg0_2:Bind(RoomIKSystem.ON_IK_LAYER_ACTION, function(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
		arg0_2:TouchModeAction(arg1_13, arg2_13, unpack(arg3_13))(arg4_13)
	end)
	arg0_2:Bind(var0_0.GET_TOUCH_GAME_STATE, function(arg0_14, arg1_14)
		if arg1_14 then
			arg1_14.inTouchGame = arg0_2.inTouchGame
		end
	end)
	arg0_2:Bind(var0_0.SET_TOUCH_EXIT_CALL, function(arg0_15, arg1_15)
		arg0_2.touchExitCall = arg1_15
	end)
end

function var0_0.OnDispose(arg0_16)
	arg0_16.transitionSerial = arg0_16.transitionSerial + 1

	arg0_16.touchTriggerRunner:CancelAllTouchPress()

	arg0_16.modeState = var0_0.MODE_STATE.IDLE
	arg0_16.activeIkTouchData = nil
	arg0_16.touchForceMove = nil

	if arg0_16.downTimer then
		arg0_16.downTimer:Stop()

		arg0_16.downTimer = nil
	end

	if arg0_16.sliderLT and LeanTween.isTweening(arg0_16.sliderLT) then
		LeanTween.cancel(arg0_16.sliderLT)

		arg0_16.sliderLT = nil
	end
end

function var0_0.SetActiveIKTouchData(arg0_17, arg1_17, arg2_17)
	if arg1_17 then
		arg0_17.touchTriggerRunner:ValidateTouchConfigs(arg1_17, arg2_17)
	end

	arg0_17.activeIkTouchData = arg1_17
	arg0_17.touchForceMove = arg1_17 and {} or nil
end

function var0_0.GetActiveIKTouchData(arg0_18)
	return arg0_18.activeIkTouchData
end

function var0_0.IsTouchModeActive(arg0_19)
	return arg0_19.modeState == var0_0.MODE_STATE.ACTIVE
end

function var0_0.BeginTouchTransition(arg0_20, arg1_20)
	arg0_20.transitionSerial = arg0_20.transitionSerial + 1
	arg0_20.modeState = arg1_20

	return arg0_20.transitionSerial
end

function var0_0.IsTouchTransitionActive(arg0_21, arg1_21, arg2_21)
	return arg0_21.transitionSerial == arg1_21 and arg0_21.modeState == arg2_21
end

function var0_0.OnUpdate(arg0_22)
	arg0_22.touchTriggerRunner:Update()
end

function var0_0.EnterTouchMode(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetCurrentLadyEnv()

	if arg0_23.modeState ~= var0_0.MODE_STATE.IDLE then
		return
	end

	local var1_23 = arg0_23:GetApartment():GetConfigID()

	arg1_23 = arg1_23 or arg0_23:GetRoom():getApartmentZoneConfig(arg0_23:GetLadyBaseZone(var1_23), "touch_id", var1_23)
	arg0_23.touchConfig = pg.dorm3d_touch_data[arg1_23]

	assert(arg0_23.touchConfig, "Missing dorm3d_touch_data config: " .. tostring(arg1_23))

	local var2_23 = arg0_23:BeginTouchTransition(var0_0.MODE_STATE.ENTERING)

	arg0_23.inTouchGame = arg0_23.touchConfig.heartbeat_enable > 0

	arg0_23:Emit(var0_0.UPDATE_TOUCH_PANEL, arg0_23.inTouchGame)

	if arg0_23.inTouchGame then
		arg0_23.touchCount = 0
		arg0_23.touchLevel = 1
		arg0_23.lastCount = 0
		arg0_23.topCount = 0

		arg0_23:Emit(var0_0.UPDATE_TOUCH_DISPLAY, arg0_23.touchLevel, arg0_23.touchCount)

		arg0_23.downTimer = Timer.New(function()
			if not arg0_23:IsTouchModeActive() then
				return
			end

			local var0_24 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_23.touchLevel > 1 then
				var0_24 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_23:UpdateTouchCount(var0_24)
		end, 1, -1)

		arg0_23.downTimer:Start()
	end

	local var3_23 = {}

	table.insert(var3_23, function(arg0_25)
		if not arg0_23:IsTouchTransitionActive(var2_23, var0_0.MODE_STATE.ENTERING) then
			return
		end

		arg0_23:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, var0_23, "inTouching", true)
		arg0_23:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
		arg0_23:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_25, "blank")
	end)
	table.insert(var3_23, function(arg0_26)
		if not arg0_23:IsTouchTransitionActive(var2_23, var0_0.MODE_STATE.ENTERING) then
			return
		end

		local var0_26 = arg0_23.touchConfig.ik_status[1]

		arg0_23:Emit(RoomIKSystem.ENTER_IK, var0_26, arg0_26)
	end)
	table.insert(var3_23, function(arg0_27)
		if not arg0_23:IsTouchTransitionActive(var2_23, var0_0.MODE_STATE.ENTERING) then
			return
		end

		existCall(arg0_27)
	end)
	seriesAsync(var3_23, function()
		if not arg0_23:IsTouchTransitionActive(var2_23, var0_0.MODE_STATE.ENTERING) then
			return
		end

		arg0_23.modeState = var0_0.MODE_STATE.ACTIVE

		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_23:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_29)
	local var0_29 = arg0_29:GetCurrentLadyEnv()

	if arg0_29.modeState ~= var0_0.MODE_STATE.ACTIVE then
		return
	end

	local var1_29 = arg0_29:BeginTouchTransition(var0_0.MODE_STATE.EXITING)
	local var2_29 = {}

	arg0_29.touchTriggerRunner:CancelAllTouchPress()
	table.insert(var2_29, function(arg0_30)
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_29:Emit(AimIKSystem.ON_EXIT_TOUCH_MODE, arg0_30)
	end)

	if arg0_29.inTouchGame then
		table.insert(var2_29, function(arg0_31)
			if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_29:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
			arg0_29:Emit(var0_0.UPDATE_TOUCH_PANEL, false, true, arg0_31)
		end)
		table.insert(var2_29, function(arg0_32)
			if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
				return
			end

			local var0_32 = 0

			for iter0_32, iter1_32 in ipairs(arg0_29.touchConfig.heartbeat_favor) do
				if iter1_32[1] > arg0_29.topCount then
					break
				else
					var0_32 = iter1_32[2]
				end
			end

			if var0_32 > 0 then
				arg0_29:Emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_29:GetApartment().configId, var0_32)
			end

			arg0_29.touchCount = nil
			arg0_29.touchLevel = nil
			arg0_29.topCount = nil

			if arg0_29.downTimer then
				arg0_29.downTimer:Stop()

				arg0_29.downTimer = nil
			end

			arg0_29.inTouchGame = false

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_32()
		end)
	else
		table.insert(var2_29, function(arg0_33)
			if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_29:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)

			local var0_33 = arg0_29.touchConfig.default_favor

			if var0_33 > 0 then
				arg0_29:Emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_29:GetApartment().configId, var0_33)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_33()
		end)
	end

	table.insert(var2_29, function(arg0_34)
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		local var0_34 = {
			character_position = arg0_29:GetLadyBaseZone(arg0_29:GetApartment():GetConfigID()),
			character_action = arg0_29.touchConfig.finish_action
		}

		arg0_29:Emit(Dorm3dStockingMgr.ON_EXIT_TOUCH_MODE)
		arg0_29:Emit(RoomIKSystem.EXIT_IK_WITH_RETURN, var0_34, arg0_34)
	end)
	table.insert(var2_29, function(arg0_35)
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_29:Emit(RoomIKSystem.SET_IK_SPECIAL_CALL, nil)
		arg0_29:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_35, "back")
	end)
	seriesAsync(var2_29, function()
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_29:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, var0_29, "inTouching", false)
		arg0_29:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)

		arg0_29.touchConfig = nil

		local var0_36 = arg0_29.touchExitCall

		arg0_29.touchExitCall = nil
		arg0_29.modeState = var0_0.MODE_STATE.IDLE

		existCall(var0_36)
	end)
end

function var0_0.TouchModeAction(arg0_37, arg1_37, arg2_37, arg3_37, ...)
	return switch(arg3_37, {
		function(arg0_38, arg1_38)
			return function(arg0_39)
				seriesAsync({
					function(arg0_40)
						if not arg1_38 or arg1_38 == "" then
							return arg0_40()
						end

						arg0_37:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION, arg1_37, arg1_38, arg0_40)
					end,
					function(arg0_41)
						arg0_37:Emit(RoomIKSystem.REPLACE_IK_STATUS, arg0_38, arg0_41)
					end,
					arg0_39
				})
			end
		end,
		function()
			return function()
				local var0_43 = {}

				arg0_37:Emit(RoomIKSystem.CONSUME_IK_SPECIAL_CALL, var0_43)

				if var0_43.consumed then
					return
				end

				arg0_37:ExitTouchMode()
			end
		end,
		function(arg0_44, arg1_44)
			return function(arg0_45)
				arg0_37:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION, arg1_37, arg1_44, arg0_45)
			end
		end,
		function(arg0_46, arg1_46, arg2_46)
			return function(arg0_47)
				seriesAsync({
					function(arg0_48)
						arg0_37:Emit(Dorm3dRoomScene.EXTRA_DO_TALK, arg1_46, arg0_48)
					end,
					function(arg0_49)
						if not arg2_46 or arg2_46 == 0 then
							return arg0_49()
						end

						arg0_37:Emit(RoomIKSystem.REPLACE_IK_STATUS, arg2_46, arg0_49)
					end,
					arg0_47
				})
			end
		end,
		function(arg0_50, arg1_50, arg2_50, arg3_50)
			return function(arg0_51)
				arg0_37:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SCENE_ITEM_ANIM, arg2_50, arg3_50)
				arg0_37:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION, arg1_37, arg1_50, arg0_51)
			end
		end,
		function(arg0_52)
			return function(arg0_53)
				local var0_53 = pg.dorm3d_ik_touch[arg2_37]

				if #var0_53.scene_item == 0 then
					return
				end

				local var1_53 = arg0_37:GetSceneItem(var0_53.scene_item)

				if not var1_53 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_37, var0_53.scene_item))

					return
				end

				local var2_53 = var1_53:Find(arg0_52)

				if not IsNil(var2_53) then
					setActive(var2_53, false)
					setActive(var2_53, true)
				end

				arg0_53()
			end
		end,
		function(arg0_54)
			local var0_54 = pg.dorm3d_ik_touch_move[arg0_54]

			assert(var0_54, "Missing dorm3d_ik_touch_move config: " .. tostring(arg0_54))

			local var1_54 = var0_54.target_ik
			local var2_54 = var0_54.move_time
			local var3_54 = var0_54.ik_point
			local var4_54 = var0_54.touch_step
			local var5_54 = arg0_37.touchForceMove

			assert(var5_54, "Missing touch force move runtime")

			var5_54[var1_54] = var5_54[var1_54] or {}
			var5_54[var1_54].count = var5_54[var1_54].count or 0

			return function(arg0_55)
				seriesAsync({
					function(arg0_56)
						if var5_54[var1_54].count >= #var4_54 then
							return arg0_56()
						end

						local var0_56 = var5_54[var1_54].count

						var5_54[var1_54].count = var0_56 + 1

						arg0_37:Emit(RoomIKSystem.PLAY_TOUCH_IK_MOVE, var1_54, var3_54, var4_54[var0_56 + 1], var2_54, function()
							var5_54[var1_54].count = 0

							arg0_56()
						end)
					end,
					arg0_55
				})
			end
		end,
		function(arg0_58)
			return function(arg0_59)
				arg0_37:Emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_58)
			end
		end,
		function(arg0_60, arg1_60)
			return function()
				local var0_61 = arg0_37:GetApartment():GetConfigID()

				arg0_37:Emit(RoomIKSystem.SET_IK_SWITCH_SKIN_ID, arg0_37:GetApartment():GetCurSkinId())
				arg1_37:SwitchCharacterSkin(var0_61, arg0_60)
				arg0_37:Emit(RoomIKSystem.REPLACE_IK_STATUS, arg1_60)
			end
		end,
		function(arg0_62)
			return function()
				arg0_37:Emit(AimIKSystem.ENTER_TOUCH_AIMIK_STATUS, arg0_62)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.TriggerTouchInfo(arg0_66, arg1_66)
	local var0_66 = arg0_66:GetCurrentLadyEnv()
	local var1_66, var2_66, var3_66 = unpack(arg1_66)
	local var4_66 = arg0_66.touchTriggerRunner:AssertTouchConfig(var1_66)
	local var5_66 = var4_66.action_emote

	if #var5_66 > 0 then
		arg0_66:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_FACE_ANIM, var0_66, var5_66)
	end

	local var6_66 = var4_66.vibrate

	if type(var6_66) == "table" and VibrateMgr.Instance:IsSupport() then
		local var7_66 = {}
		local var8_66 = {}
		local var9_66 = {}

		underscore.each(var6_66, function(arg0_67)
			local var0_67 = arg0_67[1]

			if PLATFORM == PLATFORM_IPHONEPLAYER then
				var0_67 = var0_67 / 1000
			end

			table.insert(var7_66, var0_67)
			table.insert(var8_66, arg0_67[2])
			table.insert(var9_66, 1)
		end)

		if PLATFORM == PLATFORM_ANDROID then
			VibrateMgr.Instance:VibrateWaveform(var7_66, var8_66)
		elseif PLATFORM == PLATFORM_IPHONEPLAYER then
			VibrateMgr.Instance:VibrateWaveform(var7_66, var8_66, var9_66)
		end
	end

	arg0_66:Emit(RoomIKSystem.SET_IK_BLOCK, true)
	arg0_66:TouchModeAction(var0_66, var1_66, unpack(var3_66))(function()
		arg0_66:Emit(RoomIKSystem.RESET_IK_TIP_TIMER)
		arg0_66:Emit(RoomIKSystem.SET_IK_BLOCK, nil)
	end)
end

function var0_0.UpdateTouchCount(arg0_69, arg1_69)
	if not arg0_69:IsTouchModeActive() then
		return
	end

	if arg0_69.touchLevel > 1 then
		arg1_69 = math.min(0, arg1_69)
	end

	local var0_69 = arg0_69.touchLevel > 1 and 100 or 0
	local var1_69 = arg0_69.touchLevel > 1 and 200 or 100

	arg0_69.touchCount = math.clamp(arg0_69.touchCount + arg1_69, var0_69, var1_69)

	local var2_69

	if arg0_69.touchLevel == 1 and arg0_69.touchCount >= 100 then
		var2_69 = 2
	elseif arg0_69.touchLevel > 1 and arg0_69.touchCount <= 100 then
		var2_69 = 1
	end

	if var2_69 and var2_69 ~= arg0_69.touchLevel then
		local var3_69 = {}

		arg0_69:Emit(RoomIKSystem.GET_IK_BLOCK, var3_69)

		if var3_69.blockIK then
			arg0_69:Emit(var0_0.UPDATE_TOUCH_COUNT, arg0_69.touchCount)

			arg0_69.topCount = math.max(arg0_69.topCount, arg0_69.touchCount)

			return
		end

		arg0_69.touchLevel = var2_69

		local var4_69 = arg0_69.touchConfig.ik_status[var2_69]

		if var4_69 then
			if var2_69 > 1 then
				arg0_69.touchCount = 200
			elseif var2_69 == 1 then
				arg0_69.touchCount = 0
			end

			local var5_69 = arg0_69:GetCurrentLadyEnv()

			seriesAsync({
				function(arg0_70)
					arg0_69:Emit(Dorm3dRoomTemplateScene.EXTRA_SHOW_BLACK_SCREEN, true, arg0_70)
				end,
				function(arg0_71)
					arg0_69:Emit(RoomIKSystem.REPLACE_IK_STATUS, var4_69, arg0_71)

					if var2_69 > 1 and arg0_69.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_69:Emit(Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM, var5_69, arg0_69.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_72)
					arg0_69:Emit(Dorm3dRoomTemplateScene.EXTRA_SHOW_BLACK_SCREEN, false, arg0_72)
				end
			})
		end

		arg0_69:Emit(var0_0.UPDATE_TOUCH_DISPLAY, arg0_69.touchLevel, arg0_69.touchCount)
	else
		arg0_69:Emit(var0_0.UPDATE_TOUCH_COUNT, arg0_69.touchCount)
	end

	arg0_69.topCount = math.max(arg0_69.topCount, arg0_69.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_73)
	if not arg0_73.touchLevel or arg0_73.touchLevel == 1 then
		return
	end

	arg0_73.touchCount = 0

	arg0_73:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_74, arg1_74, arg2_74)
	if arg0_74.inTouchGame then
		switch(arg2_74, {
			function()
				arg0_74:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_74:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_74:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_74:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

return var0_0

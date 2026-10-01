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

	if arg0_29.inTouchGame then
		table.insert(var2_29, function(arg0_30)
			if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_29:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
			arg0_29:Emit(var0_0.UPDATE_TOUCH_PANEL, false, true, arg0_30)
		end)
		table.insert(var2_29, function(arg0_31)
			if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
				return
			end

			local var0_31 = 0

			for iter0_31, iter1_31 in ipairs(arg0_29.touchConfig.heartbeat_favor) do
				if iter1_31[1] > arg0_29.topCount then
					break
				else
					var0_31 = iter1_31[2]
				end
			end

			if var0_31 > 0 then
				arg0_29:Emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_29:GetApartment().configId, var0_31)
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
			arg0_31()
		end)
	else
		table.insert(var2_29, function(arg0_32)
			if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_29:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)

			local var0_32 = arg0_29.touchConfig.default_favor

			if var0_32 > 0 then
				arg0_29:Emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_29:GetApartment().configId, var0_32)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_32()
		end)
	end

	table.insert(var2_29, function(arg0_33)
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		local var0_33 = {
			character_position = arg0_29:GetLadyBaseZone(arg0_29:GetApartment():GetConfigID()),
			character_action = arg0_29.touchConfig.finish_action
		}

		arg0_29:Emit(Dorm3dStockingMgr.ON_EXIT_TOUCH_MODE)
		arg0_29:Emit(RoomIKSystem.EXIT_IK_WITH_RETURN, var0_33, arg0_33)
	end)
	table.insert(var2_29, function(arg0_34)
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_29:Emit(RoomIKSystem.SET_IK_SPECIAL_CALL, nil)
		arg0_29:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_34, "back")
	end)
	seriesAsync(var2_29, function()
		if not arg0_29:IsTouchTransitionActive(var1_29, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_29:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, var0_29, "inTouching", false)
		arg0_29:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)

		arg0_29.touchConfig = nil

		local var0_35 = arg0_29.touchExitCall

		arg0_29.touchExitCall = nil
		arg0_29.modeState = var0_0.MODE_STATE.IDLE

		existCall(var0_35)
	end)
end

function var0_0.TouchModeAction(arg0_36, arg1_36, arg2_36, arg3_36, ...)
	return switch(arg3_36, {
		function(arg0_37, arg1_37)
			return function(arg0_38)
				seriesAsync({
					function(arg0_39)
						if not arg1_37 or arg1_37 == "" then
							return arg0_39()
						end

						arg0_36:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION, arg1_36, arg1_37, arg0_39)
					end,
					function(arg0_40)
						arg0_36:Emit(RoomIKSystem.REPLACE_IK_STATUS, arg0_37, arg0_40)
					end,
					arg0_38
				})
			end
		end,
		function()
			return function()
				local var0_42 = {}

				arg0_36:Emit(RoomIKSystem.CONSUME_IK_SPECIAL_CALL, var0_42)

				if var0_42.consumed then
					return
				end

				arg0_36:ExitTouchMode()
			end
		end,
		function(arg0_43, arg1_43)
			return function(arg0_44)
				arg0_36:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION, arg1_36, arg1_43, arg0_44)
			end
		end,
		function(arg0_45, arg1_45, arg2_45)
			return function(arg0_46)
				seriesAsync({
					function(arg0_47)
						arg0_36:Emit(Dorm3dRoomScene.EXTRA_DO_TALK, arg1_45, arg0_47)
					end,
					function(arg0_48)
						if not arg2_45 or arg2_45 == 0 then
							return arg0_48()
						end

						arg0_36:Emit(RoomIKSystem.REPLACE_IK_STATUS, arg2_45, arg0_48)
					end,
					arg0_46
				})
			end
		end,
		function(arg0_49, arg1_49, arg2_49, arg3_49)
			return function(arg0_50)
				arg0_36:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SCENE_ITEM_ANIM, arg2_49, arg3_49)
				arg0_36:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION, arg1_36, arg1_49, arg0_50)
			end
		end,
		function(arg0_51)
			return function(arg0_52)
				local var0_52 = pg.dorm3d_ik_touch[arg2_36]

				if #var0_52.scene_item == 0 then
					return
				end

				local var1_52 = arg0_36:GetSceneItem(var0_52.scene_item)

				if not var1_52 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_36, var0_52.scene_item))

					return
				end

				local var2_52 = var1_52:Find(arg0_51)

				if not IsNil(var2_52) then
					setActive(var2_52, false)
					setActive(var2_52, true)
				end

				arg0_52()
			end
		end,
		function(arg0_53)
			local var0_53 = pg.dorm3d_ik_touch_move[arg0_53]

			assert(var0_53, "Missing dorm3d_ik_touch_move config: " .. tostring(arg0_53))

			local var1_53 = var0_53.target_ik
			local var2_53 = var0_53.move_time
			local var3_53 = var0_53.ik_point
			local var4_53 = var0_53.touch_step
			local var5_53 = arg0_36.touchForceMove

			assert(var5_53, "Missing touch force move runtime")

			var5_53[var1_53] = var5_53[var1_53] or {}
			var5_53[var1_53].count = var5_53[var1_53].count or 0

			return function(arg0_54)
				seriesAsync({
					function(arg0_55)
						if var5_53[var1_53].count >= #var4_53 then
							return arg0_55()
						end

						local var0_55 = var5_53[var1_53].count

						var5_53[var1_53].count = var0_55 + 1

						arg0_36:Emit(RoomIKSystem.PLAY_TOUCH_IK_MOVE, var1_53, var3_53, var4_53[var0_55 + 1], var2_53, function()
							var5_53[var1_53].count = 0

							arg0_55()
						end)
					end,
					arg0_54
				})
			end
		end,
		function(arg0_57)
			return function(arg0_58)
				arg0_36:Emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_57)
			end
		end,
		function(arg0_59, arg1_59)
			return function()
				local var0_60 = arg0_36:GetApartment():GetConfigID()

				arg0_36:Emit(RoomIKSystem.SET_IK_SWITCH_SKIN_ID, arg0_36:GetApartment():GetCurSkinId())
				arg1_36:SwitchCharacterSkin(var0_60, arg0_59)
				arg0_36:Emit(RoomIKSystem.REPLACE_IK_STATUS, arg1_59)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.TriggerTouchInfo(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetCurrentLadyEnv()
	local var1_63, var2_63, var3_63 = unpack(arg1_63)
	local var4_63 = arg0_63.touchTriggerRunner:AssertTouchConfig(var1_63)
	local var5_63 = var4_63.action_emote

	if #var5_63 > 0 then
		arg0_63:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_FACE_ANIM, var0_63, var5_63)
	end

	local var6_63 = var4_63.vibrate

	if type(var6_63) == "table" and VibrateMgr.Instance:IsSupport() then
		local var7_63 = {}
		local var8_63 = {}
		local var9_63 = {}

		underscore.each(var6_63, function(arg0_64)
			local var0_64 = arg0_64[1]

			if PLATFORM == PLATFORM_IPHONEPLAYER then
				var0_64 = var0_64 / 1000
			end

			table.insert(var7_63, var0_64)
			table.insert(var8_63, arg0_64[2])
			table.insert(var9_63, 1)
		end)

		if PLATFORM == PLATFORM_ANDROID then
			VibrateMgr.Instance:VibrateWaveform(var7_63, var8_63)
		elseif PLATFORM == PLATFORM_IPHONEPLAYER then
			VibrateMgr.Instance:VibrateWaveform(var7_63, var8_63, var9_63)
		end
	end

	arg0_63:Emit(RoomIKSystem.SET_IK_BLOCK, true)
	arg0_63:TouchModeAction(var0_63, var1_63, unpack(var3_63))(function()
		arg0_63:Emit(RoomIKSystem.RESET_IK_TIP_TIMER)
		arg0_63:Emit(RoomIKSystem.SET_IK_BLOCK, nil)
	end)
end

function var0_0.UpdateTouchCount(arg0_66, arg1_66)
	if not arg0_66:IsTouchModeActive() then
		return
	end

	if arg0_66.touchLevel > 1 then
		arg1_66 = math.min(0, arg1_66)
	end

	local var0_66 = arg0_66.touchLevel > 1 and 100 or 0
	local var1_66 = arg0_66.touchLevel > 1 and 200 or 100

	arg0_66.touchCount = math.clamp(arg0_66.touchCount + arg1_66, var0_66, var1_66)

	local var2_66

	if arg0_66.touchLevel == 1 and arg0_66.touchCount >= 100 then
		var2_66 = 2
	elseif arg0_66.touchLevel > 1 and arg0_66.touchCount <= 100 then
		var2_66 = 1
	end

	if var2_66 and var2_66 ~= arg0_66.touchLevel then
		local var3_66 = {}

		arg0_66:Emit(RoomIKSystem.GET_IK_BLOCK, var3_66)

		if var3_66.blockIK then
			arg0_66:Emit(var0_0.UPDATE_TOUCH_COUNT, arg0_66.touchCount)

			arg0_66.topCount = math.max(arg0_66.topCount, arg0_66.touchCount)

			return
		end

		arg0_66.touchLevel = var2_66

		local var4_66 = arg0_66.touchConfig.ik_status[var2_66]

		if var4_66 then
			if var2_66 > 1 then
				arg0_66.touchCount = 200
			elseif var2_66 == 1 then
				arg0_66.touchCount = 0
			end

			local var5_66 = arg0_66:GetCurrentLadyEnv()

			seriesAsync({
				function(arg0_67)
					arg0_66:Emit(Dorm3dRoomTemplateScene.EXTRA_SHOW_BLACK_SCREEN, true, arg0_67)
				end,
				function(arg0_68)
					arg0_66:Emit(RoomIKSystem.REPLACE_IK_STATUS, var4_66, arg0_68)

					if var2_66 > 1 and arg0_66.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_66:Emit(Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM, var5_66, arg0_66.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_69)
					arg0_66:Emit(Dorm3dRoomTemplateScene.EXTRA_SHOW_BLACK_SCREEN, false, arg0_69)
				end
			})
		end

		arg0_66:Emit(var0_0.UPDATE_TOUCH_DISPLAY, arg0_66.touchLevel, arg0_66.touchCount)
	else
		arg0_66:Emit(var0_0.UPDATE_TOUCH_COUNT, arg0_66.touchCount)
	end

	arg0_66.topCount = math.max(arg0_66.topCount, arg0_66.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_70)
	if not arg0_70.touchLevel or arg0_70.touchLevel == 1 then
		return
	end

	arg0_70.touchCount = 0

	arg0_70:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_71, arg1_71, arg2_71)
	if arg0_71.inTouchGame then
		switch(arg2_71, {
			function()
				arg0_71:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_71:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_71:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_71:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

return var0_0

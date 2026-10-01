local var0_0 = class("RoomTouchTriggerRunner")

var0_0.TRIGGER_CLICK = 1
var0_0.TRIGGER_LONG_PRESS = 2
var0_0.HOLD_PROGRESS_SHOW_DELAY = 0.5

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.owner = arg1_1
end

function var0_0.Dispose(arg0_2)
	arg0_2:CancelAllTouchPress()
end

function var0_0.Update(arg0_3)
	arg0_3:UpdateHoldProgress()
end

function var0_0.GetTouchPressKey(arg0_4, arg1_4, arg2_4)
	return tostring(arg1_4) .. ":" .. tostring(arg2_4)
end

function var0_0.AssertTouchSource(arg0_5, arg1_5, arg2_5)
	assert(arg1_5 == "body" or arg1_5 == "scene_item", "Unknown touch source: " .. tostring(arg1_5))
	assert(arg2_5 and arg2_5 ~= "", "Invalid touch target: " .. tostring(arg2_5))
end

function var0_0.GetTouchConfigSourceTarget(arg0_6, arg1_6, arg2_6)
	local var0_6 = type(arg1_6.body) == "string" and arg1_6.body ~= ""
	local var1_6 = type(arg1_6.scene_item) == "string" and arg1_6.scene_item ~= ""

	assert(var0_6 ~= var1_6, "Invalid dorm3d_ik_touch source: " .. tostring(arg2_6 or arg1_6.id))

	if var1_6 then
		return "scene_item", arg1_6.scene_item
	else
		return "body", arg1_6.body
	end
end

function var0_0.AssertTouchConfig(arg0_7, arg1_7)
	local var0_7 = pg.dorm3d_ik_touch[arg1_7]

	assert(var0_7, "Missing dorm3d_ik_touch config: " .. tostring(arg1_7))
	assert(var0_7.trigger_type == var0_0.TRIGGER_CLICK or var0_7.trigger_type == var0_0.TRIGGER_LONG_PRESS, "Invalid dorm3d_ik_touch trigger_type: " .. tostring(arg1_7))

	if var0_7.trigger_type == var0_0.TRIGGER_LONG_PRESS then
		assert(type(var0_7.hold_time) == "number" and var0_7.hold_time > 0, "Invalid dorm3d_ik_touch hold_time: " .. tostring(arg1_7))
	end

	arg0_7:GetTouchConfigSourceTarget(var0_7, arg1_7)

	return var0_7
end

function var0_0.ValidateTouchConfigs(arg0_8, arg1_8, arg2_8)
	assert(type(arg1_8) == "table", "Invalid dorm3d_ik_status touch_data: " .. tostring(arg2_8))

	local var0_8 = {}

	_.each(arg1_8, function(arg0_9)
		local var0_9 = arg0_9[1]
		local var1_9 = arg0_8:AssertTouchConfig(var0_9)
		local var2_9, var3_9 = arg0_8:GetTouchConfigSourceTarget(var1_9, var0_9)
		local var4_9 = var2_9 .. ":" .. var3_9 .. ":" .. tostring(var1_9.trigger_type)

		assert(not var0_8[var4_9], string.format("Duplicate dorm3d_ik_touch trigger: ids=%s,%s source=%s target=%s trigger_type=%s", tostring(var0_8[var4_9]), tostring(var0_9), var2_9, var3_9, tostring(var1_9.trigger_type)))

		var0_8[var4_9] = var0_9
	end)
end

function var0_0.GetTouchInfos(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10:AssertTouchSource(arg1_10, arg2_10)

	local var0_10 = arg0_10.owner:GetActiveIKTouchData()

	if not var0_10 then
		return {}
	end

	assert(type(var0_10) == "table", "Invalid current IK touch data")

	local var1_10 = {}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var2_10 = iter1_10[1]
		local var3_10 = arg0_10:AssertTouchConfig(var2_10)
		local var4_10, var5_10 = arg0_10:GetTouchConfigSourceTarget(var3_10, var2_10)

		if var4_10 == arg1_10 and var5_10 == arg2_10 and var3_10.trigger_type == arg3_10 then
			table.insert(var1_10, iter1_10)
		end
	end

	assert(#var1_10 <= 1, string.format("Duplicate dorm3d_ik_touch trigger: source=%s target=%s trigger_type=%s", tostring(arg1_10), tostring(arg2_10), tostring(arg3_10)))

	return var1_10
end

function var0_0.GetFirstLongPressInfo(arg0_11, arg1_11, arg2_11)
	return arg0_11:GetTouchInfos(arg1_11, arg2_11, var0_0.TRIGGER_LONG_PRESS)[1]
end

function var0_0.OnTouchPressDown(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12:AssertTouchSource(arg1_12, arg2_12)
	arg0_12:ClearTouchPressConsumed(arg1_12, arg2_12)
	arg0_12:CancelTouchPress(arg1_12, arg2_12)

	local var0_12 = arg0_12:GetFirstLongPressInfo(arg1_12, arg2_12)

	if not var0_12 then
		return
	end

	assert(arg3_12, "Missing touch press screenPosition")

	local var1_12 = var0_12[1]
	local var2_12 = arg0_12:AssertTouchConfig(var1_12)
	local var3_12 = arg0_12:GetTouchPressKey(arg1_12, arg2_12)
	local var4_12 = {
		triggered = false,
		holdTime = var2_12.hold_time,
		screenPosition = arg3_12,
		startTime = Time.time
	}

	var4_12.timer = Timer.New(function()
		var4_12.triggered = true
		var4_12.timer = nil

		arg0_12:HideHoldProgress()
		arg0_12:SetTouchPressConsumed(arg1_12, arg2_12)
		arg0_12.owner:TriggerTouchInfo(var0_12)
	end, var2_12.hold_time, 1)

	var4_12.timer:Start()

	arg0_12.touchPressStates = arg0_12.touchPressStates or {}
	arg0_12.touchPressStates[var3_12] = var4_12
end

function var0_0.OnTouchPressUp(arg0_14, arg1_14, arg2_14)
	arg0_14:AssertTouchSource(arg1_14, arg2_14)

	local var0_14 = arg0_14:GetTouchPressKey(arg1_14, arg2_14)
	local var1_14 = arg0_14.touchPressStates and arg0_14.touchPressStates[var0_14] or nil
	local var2_14 = var1_14 and var1_14.triggered or arg0_14.touchPressConsumed and arg0_14.touchPressConsumed[var0_14]

	arg0_14:CancelTouchPress(arg1_14, arg2_14)
	arg0_14:ClearTouchPressConsumed(arg1_14, arg2_14)

	if var2_14 then
		return
	end

	local var3_14 = arg0_14:GetTouchInfos(arg1_14, arg2_14, var0_0.TRIGGER_CLICK)

	if not var3_14[1] then
		return
	end

	arg0_14.owner:TriggerTouchInfo(var3_14[1])
end

function var0_0.SetTouchPressConsumed(arg0_15, arg1_15, arg2_15)
	arg0_15.touchPressConsumed = arg0_15.touchPressConsumed or {}
	arg0_15.touchPressConsumed[arg0_15:GetTouchPressKey(arg1_15, arg2_15)] = true
end

function var0_0.ClearTouchPressConsumed(arg0_16, arg1_16, arg2_16)
	if not arg0_16.touchPressConsumed then
		return
	end

	arg0_16.touchPressConsumed[arg0_16:GetTouchPressKey(arg1_16, arg2_16)] = nil
end

function var0_0.CancelTouchPress(arg0_17, arg1_17, arg2_17)
	if not arg0_17.touchPressStates then
		return
	end

	local var0_17 = arg0_17:GetTouchPressKey(arg1_17, arg2_17)
	local var1_17 = arg0_17.touchPressStates[var0_17]

	if var1_17 and var1_17.timer then
		var1_17.timer:Stop()
	end

	arg0_17:HideHoldProgress()

	arg0_17.touchPressStates[var0_17] = nil
end

function var0_0.CancelAllTouchPress(arg0_18)
	arg0_18:HideHoldProgress()

	if not arg0_18.touchPressStates then
		return
	end

	for iter0_18, iter1_18 in pairs(arg0_18.touchPressStates) do
		if iter1_18.timer then
			iter1_18.timer:Stop()
		end
	end

	arg0_18.touchPressStates = nil
end

function var0_0.HideHoldProgress(arg0_19)
	if not arg0_19.holdProgressActive then
		return
	end

	arg0_19.holdProgressActive = nil

	arg0_19.owner:Emit(Dorm3dIKView.UPDATE_HOLD_PROGRESS, false)
end

function var0_0.UpdateHoldProgress(arg0_20)
	if not arg0_20.touchPressStates then
		arg0_20:HideHoldProgress()

		return
	end

	for iter0_20, iter1_20 in pairs(arg0_20.touchPressStates) do
		if not iter1_20.triggered and iter1_20.holdTime > var0_0.HOLD_PROGRESS_SHOW_DELAY then
			local var0_20 = Time.time - iter1_20.startTime

			if var0_20 >= var0_0.HOLD_PROGRESS_SHOW_DELAY then
				arg0_20.holdProgressActive = true

				arg0_20.owner:Emit(Dorm3dIKView.UPDATE_HOLD_PROGRESS, true, iter1_20.screenPosition, var0_20 / iter1_20.holdTime)

				return
			end
		end
	end

	arg0_20:HideHoldProgress()
end

return var0_0

local var0_0 = class("Dorm3dIK", import("model.vo.BaseVO"))

var0_0.TRIGGER = {
	TOUCH_BODY = 2
}
var0_0.ACTION_TRIGGER = {
	RELEASE = 1,
	TOUCH_TARGET = 3,
	RELEASE_ON_TARGET = 2
}
var0_0.ACTION = {
	ANIM = 1,
	TIMELINE = 2
}

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_ik
end

function var0_0.GetShipGroupId(arg0_2)
	return arg0_2:getConfig("char_id")
end

function var0_0.GetControllerPath(arg0_3)
	return arg0_3:getConfig("controller")
end

function var0_0.GetTriggerParams(arg0_4)
	return arg0_4:getConfig("trigger_param")
end

function var0_0.IsTrigger(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GetTriggerParams()

	if var0_5[1] ~= arg1_5 then
		return false
	end

	return switch(arg1_5, {
		[var0_0.TRIGGER.TOUCH_BODY] = function()
			return arg2_5 == var0_5[2]
		end
	})
end

function var0_0.GetTriggerBoneName(arg0_7)
	local var0_7 = arg0_7:GetTriggerParams()

	if var0_7[1] ~= var0_0.TRIGGER.TOUCH_BODY then
		return
	end

	return var0_7[2]
end

function var0_0.GetActionTriggerParams(arg0_8)
	return arg0_8:getConfig("action_trigger")
end

function var0_0.GetSubTargets(arg0_9)
	local var0_9 = arg0_9:getConfig("sub_targets")

	if type(var0_9) ~= "table" then
		return {}
	end

	return var0_9
end

function var0_0.GetRect(arg0_10)
	local var0_10 = arg0_10:getConfig("rect")

	return (UnityEngine.Rect.New(unpack(var0_10)))
end

function var0_0.GetTriggerRect(arg0_11)
	local var0_11 = arg0_11:getConfig("trigger_rect")

	return (UnityEngine.Rect.New(unpack(var0_11)))
end

function var0_0.GetPlaneRotations(arg0_12)
	local var0_12 = arg0_12:getConfig("plane_rotation")

	return _.map(var0_12, function(arg0_13)
		return Quaternion.New(unpack(arg0_13))
	end)
end

function var0_0.GetPlaneScales(arg0_14)
	local var0_14 = arg0_14:getConfig("plane_scale")

	return _.map(var0_14, function(arg0_15)
		return Vector3.New(unpack(arg0_15))
	end)
end

function var0_0.GetRevertTime(arg0_16)
	return arg0_16:getConfig("back_time")
end

function var0_0.GetHeadTrackPath(arg0_17)
	return arg0_17:getConfig("head_track")
end

function var0_0.GetTriggerFaceAnim(arg0_18)
	return arg0_18:getConfig("action_emote")
end

function var0_0.GetIKTipOffset(arg0_19)
	local var0_19 = arg0_19:getConfig("tip_offset")

	if type(var0_19) ~= "table" then
		return Vector2.zero
	end

	return Vector2.New(unpack(var0_19))
end

return var0_0

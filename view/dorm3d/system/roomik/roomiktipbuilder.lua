local var0_0 = class("RoomIKTipBuilder")

function var0_0.GetWorldTipPosition(arg0_1)
	if not arg0_1 then
		return
	end

	local var0_1 = arg0_1.position
	local var1_1 = arg0_1:GetComponent(typeof(UnityEngine.Collider))

	if var1_1 then
		var0_1 = var1_1.bounds.center
	end

	return var0_1
end

local function var1_0(arg0_2, arg1_2)
	local var0_2 = var0_0.GetWorldTipPosition(arg0_2)

	if not var0_2 then
		return
	end

	return arg1_2(var0_2)
end

function var0_0.BuildTextTips(arg0_3)
	local var0_3 = {}

	_.each(arg0_3 or {}, function(arg0_4)
		local var0_4 = arg0_4:getConfig("tip_text")

		if var0_4 and #var0_4 > 0 then
			table.insert(var0_3, var0_4)
		end
	end)

	return var0_3
end

function var0_0.BuildTouchTips(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = {}

	if not arg2_5 then
		return var0_5
	end

	_.each(arg0_5 or {}, function(arg0_6)
		local var0_6 = arg1_5[arg0_6[1]]

		assert(var0_6, "Missing dorm3d_ik_touch config: " .. tostring(arg0_6[1]))

		local var1_6
		local var2_6 = Vector2.zero

		if var0_6.tip_offset and var0_6.tip_offset ~= "" then
			var2_6 = Vector2.New(unpack(var0_6.tip_offset))
		end

		if #var0_6.scene_item > 0 then
			var1_6 = arg3_5(var0_6.scene_item)
		else
			var1_6 = arg2_5.Colliders[var0_6.body]
		end

		table.insert(var0_5, {
			active = tobool(var1_6),
			screenPosition = var1_0(var1_6, arg4_5),
			offset = var2_6,
			triggerType = var0_6.trigger_type
		})
	end)

	return var0_5
end

function var0_0.BuildIKTips(arg0_7, arg1_7, arg2_7)
	local var0_7 = {}

	if not arg1_7 then
		return var0_7
	end

	local var1_7 = _.filter(arg0_7 or {}, function(arg0_8)
		return not arg0_8.ignoreDrag
	end)

	_.each(var1_7, function(arg0_9)
		local var0_9 = arg0_9:GetTriggerBoneName()
		local var1_9 = var0_9 and arg1_7.Colliders[var0_9] or nil

		table.insert(var0_7, {
			active = tobool(var1_9),
			screenPosition = var1_0(var1_9, arg2_7),
			offset = arg0_9:GetIKTipOffset(),
			triggerRect = arg0_9:GetTriggerRect()
		})
	end)

	return var0_7
end

return var0_0

local var0_0 = class("RoomIKConfigCompiler")

local function var1_0(arg0_1)
	local var0_1 = arg0_1[1]

	return switch(var0_1, {
		function(arg0_2, arg1_2)
			return 0
		end,
		function()
			return 0
		end,
		function(arg0_4, arg1_4)
			return arg0_4
		end,
		function(arg0_5, arg1_5)
			return arg0_5
		end,
		function(arg0_6, arg1_6, arg2_6, arg3_6)
			return arg0_6
		end,
		function(arg0_7)
			return 0
		end
	}, function(arg0_8)
		return type(arg0_8) == "number" and arg0_8 or 0
	end, unpack(arg0_1, 2))
end

function var0_0.BuildSubTargets(arg0_9)
	local var0_9 = arg0_9:GetSubTargets()
	local var1_9 = arg0_9:GetPlaneRotations()
	local var2_9 = arg0_9:GetPlaneScales()

	return _.map(_.range(#var0_9), function(arg0_10)
		return {
			name = var0_9[arg0_10][1],
			planeRot = var1_9[arg0_10],
			planeScale = var2_9[arg0_10]
		}
	end)
end

function var0_0.BuildController(arg0_11, arg1_11)
	arg1_11 = arg1_11 or {}

	return Dorm3dIKController.New({
		triggerName = arg0_11:getConfig("trigger_param")[2],
		controllerName = arg0_11:GetControllerPath(),
		subTargets = var0_0.BuildSubTargets(arg0_11),
		actionType = arg0_11:GetActionTriggerParams()[1],
		controlRect = arg0_11:GetRect(),
		actionRect = arg0_11:GetTriggerRect(),
		backTime = arg1_11.backTime or arg0_11:GetRevertTime(),
		actionRevertTime = arg1_11.actionRevertTime or arg0_11:GetActionRevertTime(),
		timelineActionEvent = arg1_11.timelineActionEvent,
		ignoreDrag = arg1_11.ignoreDrag or false
	})
end

local function var2_0(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg2_12.target_ik

	if _.detect(arg0_12, function(arg0_13)
		return arg0_13[1] == var0_12
	end) then
		return
	end

	arg1_12[var0_12] = {
		back_time = arg2_12.back_time
	}

	local var1_12 = {
		var0_12,
		0,
		{}
	}

	if arg2_12.trigger_dialogue > 0 then
		var1_12[3] = {
			4,
			0,
			arg2_12.trigger_dialogue
		}
	end

	table.insert(arg0_12, var1_12)
end

local function var3_0(arg0_14, arg1_14)
	local var0_14 = Dorm3dIK.New({
		configId = arg0_14[1]
	})
	local var1_14 = arg0_14[3]
	local var2_14 = var1_0(var1_14)
	local var3_14 = var0_14:GetRevertTime()
	local var4_14 = arg1_14[var0_14:GetConfigID()]
	local var5_14 = tobool(var4_14)

	if var5_14 then
		var2_14 = var4_14.back_time
		var3_14 = var4_14.back_time
		var0_14.ignoreDrag = true
	end

	return {
		ikData = var0_14,
		link = var1_14,
		controller = var0_0.BuildController(var0_14, {
			backTime = var3_14,
			actionRevertTime = var2_14,
			ignoreDrag = var5_14
		})
	}
end

function var0_0.Compile(arg0_15)
	assert(type(arg0_15) == "table", "Invalid IK status config")
	assert(type(arg0_15.ik_id) == "table", "Invalid IK status ik_id: " .. tostring(arg0_15.id))
	assert(type(arg0_15.touch_data) == "table", "Invalid IK status touch_data: " .. tostring(arg0_15.id))

	local var0_15 = table.shallowCopy(arg0_15.ik_id)
	local var1_15 = {}

	_.each(arg0_15.touch_data, function(arg0_16)
		assert(type(arg0_16) == "table" and type(arg0_16[3]) == "table", "Invalid IK touch link in status: " .. tostring(arg0_15.id))

		local var0_16 = arg0_16[3]

		if var0_16[1] == 7 then
			local var1_16 = var0_16[2]

			assert(var1_16, "Missing IK touch move id in status: " .. tostring(arg0_15.id))

			local var2_16 = pg.dorm3d_ik_touch_move[var1_16]

			assert(var2_16, "Missing dorm3d_ik_touch_move config: " .. tostring(var1_16))
			var2_0(var0_15, var1_15, var2_16)
		end
	end)

	local var2_15 = {}
	local var3_15 = {}
	local var4_15 = {}

	_.each(var0_15, function(arg0_17)
		local var0_17 = var3_0(arg0_17, var1_15)

		table.insert(var2_15, var0_17.ikData)
		table.insert(var3_15, var0_17.controller)

		var4_15[var0_17.ikData:GetControllerPath()] = var0_17.link
	end)

	local var5_15 = {}
	local var6_15 = {}

	_.each(arg0_15.touch_data, function(arg0_18)
		local var0_18 = pg.dorm3d_ik_touch[arg0_18[1]]

		assert(var0_18, "Missing dorm3d_ik_touch config: " .. tostring(arg0_18[1]))

		if #var0_18.scene_item > 0 and not var6_15[var0_18.scene_item] then
			var6_15[var0_18.scene_item] = true

			table.insert(var5_15, {
				id = arg0_18[1],
				path = var0_18.scene_item
			})
		end
	end)

	return {
		touchDatas = arg0_15.touch_data,
		layers = var2_15,
		controllers = var3_15,
		actionDict = var4_15,
		sceneItems = var5_15
	}
end

return var0_0

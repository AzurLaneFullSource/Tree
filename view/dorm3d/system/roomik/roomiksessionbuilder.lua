local var0_0 = class("RoomIKSessionBuilder")

local function var1_0(arg0_1, arg1_1)
	if arg1_1 then
		return arg1_1
	end

	local var0_1 = {}

	if not arg0_1 or IsNil(arg0_1) then
		return var0_1
	end

	local var1_1 = {}

	table.Foreach(DormConst.boneMap, function(arg0_2, arg1_2)
		var1_1[arg1_2] = arg0_2
	end)
	table.IpairsCArray(arg0_1:GetComponentsInChildren(typeof(Transform), true), function(arg0_3, arg1_3)
		local var0_3 = var1_1[arg1_3.name]

		if var0_3 then
			var0_1[var0_3] = arg1_3
		end
	end)

	return var0_1
end

local function var2_0(arg0_4, arg1_4)
	assert(arg0_4 and not IsNil(arg0_4), arg1_4)

	return arg0_4
end

local function var3_0(arg0_5)
	_.each(arg0_5.controllers, function(arg0_6)
		local var0_6 = arg0_6:GetControllerPath()

		assert(type(var0_6) == "string" and var0_6 ~= "", "Invalid IK controller path")

		local var1_6 = var2_0(arg0_5.ikRoot:Find(var0_6), "Missing IK layer: " .. var0_6)
		local var2_6 = var2_0(var1_6:GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder)), "Missing IKExecutionOrder: " .. var0_6)
		local var3_6 = var2_0(tf(var2_6):Find("Container/SubTargets"), "Missing IK SubTargets: " .. var0_6)

		_.each(arg0_6:GetSubTargets(), function(arg0_7)
			local var0_7 = arg0_7.name

			var2_0(arg0_5.boneMaps[var0_7], string.format("Missing IK BoneMap: %s (%s)", tostring(var0_7), var0_6))

			local var1_7 = var2_0(var3_6:Find(var0_7), string.format("Missing IK SubTarget: %s (%s)", tostring(var0_7), var0_6))
			local var2_7 = var2_0(var1_7:Find("Plane"), string.format("Missing IK SubTarget Plane: %s (%s)", tostring(var0_7), var0_6))

			var2_0(var2_7:GetComponent(typeof(UnityEngine.MeshCollider)), string.format("Missing IK SubTarget MeshCollider: %s (%s)", tostring(var0_7), var0_6))
			var2_0(var1_7:Find("Target"), string.format("Missing IK SubTarget Target: %s (%s)", tostring(var0_7), var0_6))
		end)
	end)
end

function var0_0.Ctor(arg0_8, arg1_8)
	arg0_8.system = arg1_8
end

function var0_0.BuildNormal(arg0_9, arg1_9, arg2_9, arg3_9)
	assert(arg1_9, "Missing LadyEnv when building IK session")
	assert(arg2_9, "Missing IK config when building session")

	local var0_9 = RoomIKConfigCompiler.Compile(arg2_9)
	local var1_9 = arg0_9.system:GetCameraRoot()
	local var2_9 = arg0_9.system:GetIKPointByName(arg2_9.character_position)

	return {
		mode = "normal",
		statusId = arg2_9.id,
		config = arg2_9,
		ladyEnv = arg1_9,
		compiled = var0_9,
		layers = var0_9.layers,
		controllers = var0_9.controllers,
		actionDict = var0_9.actionDict,
		touchDatas = var0_9.touchDatas,
		sceneItems = var0_9.sceneItems,
		ikRoot = arg1_9.ladyIKRoot,
		boneMaps = var1_0(arg1_9.lady, arg1_9.ladyBoneMaps),
		colliders = arg1_9.ladyColliders,
		raycaster = arg0_9.system:GetSceneRaycaster(),
		ikCameraTF = var1_9 and var1_9:Find(arg2_9.ik_camera),
		stayPoint = var2_9 and var2_9:Find("StayPoint"),
		onLayerAction = arg3_9
	}
end

function var0_0.BuildTimeline(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	assert(arg1_10, "Missing timeline lady GameObject")

	local var0_10 = pg.dorm3d_ik_timeline_status[arg2_10]

	assert(var0_10, "Missing dorm3d_ik_timeline_status config: " .. tostring(arg2_10))

	local var1_10 = arg1_10.transform
	local var2_10 = {}
	local var3_10 = {}

	table.IpairsCArray(arg1_10:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_11, arg1_11)
		local var0_11 = tf(arg1_11)

		if arg1_11.name == "SafeCollider" then
			table.insert(var3_10, {
				active = false,
				target = var0_11
			})

			return
		end

		if arg1_11:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var1_11 = var0_11.name
		local var2_11 = var1_11 and string.find(var1_11, "Collider") or -1

		if var2_11 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var1_11)

			return
		end

		local var3_11 = string.sub(var1_11, 1, var2_11 - 1)

		if var3_11 == "Body" or var3_11 == "Safe" then
			table.insert(var3_10, {
				active = false,
				target = var0_11
			})

			return
		end

		if DormConst.BONE_TO_TOUCH[var3_11] == nil then
			return
		end

		var2_10[var3_11] = var0_11

		table.insert(var3_10, {
			active = true,
			target = var0_11
		})
	end)

	local var4_10 = {}
	local var5_10 = _.map(var0_10.ik_id, function(arg0_12)
		local var0_12 = Dorm3dIK.New({
			configId = arg0_12
		})

		table.insert(var4_10, var0_12)

		return RoomIKConfigCompiler.BuildController(var0_12, {
			timelineActionEvent = var0_12:GetTimelineAction()
		})
	end)

	return {
		mode = "timeline",
		statusId = arg2_10,
		config = var0_10,
		ladyEnv = arg0_10.system:GetCurrentLadyEnv(),
		layers = var4_10,
		controllers = var5_10,
		actionDict = {},
		touchDatas = {},
		sceneItems = {},
		ikRoot = var1_10 and var1_10:Find("IKLayers"),
		boneMaps = var1_0(var1_10),
		colliders = var2_10,
		colliderChanges = var3_10,
		raycaster = arg3_10 and arg3_10:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster)),
		raycastCameraTF = arg3_10,
		onLayerAction = arg4_10
	}
end

function var0_0.ValidateSpec(arg0_13, arg1_13)
	assert(type(arg1_13) == "table", "Invalid RoomIK SessionSpec")
	assert(arg1_13.mode == "normal" or arg1_13.mode == "timeline", "Invalid RoomIK session mode: " .. tostring(arg1_13.mode))
	assert(arg1_13.statusId, "Missing RoomIK status id")
	assert(type(arg1_13.layers) == "table", "Missing RoomIK layers")
	assert(arg1_13.mode == "normal" or #arg1_13.layers > 0, "Missing RoomIK timeline layers")
	assert(type(arg1_13.controllers) == "table" and #arg1_13.controllers == #arg1_13.layers, "RoomIK layer/controller count mismatch")
	assert(type(arg1_13.actionDict) == "table", "Missing RoomIK action dictionary")
	assert(type(arg1_13.touchDatas) == "table", "Missing RoomIK touch data")
	assert(type(arg1_13.sceneItems) == "table", "Missing RoomIK scene items")

	if #arg1_13.controllers > 0 then
		var2_0(arg1_13.ikRoot, "Missing RoomIK IK root")
	end

	assert(type(arg1_13.boneMaps) == "table", "Missing RoomIK BoneMap")
	assert(type(arg1_13.colliders) == "table", "Missing RoomIK colliders")
	assert(arg1_13.raycaster or arg1_13.raycastCameraTF, "Missing RoomIK raycaster source")

	if arg1_13.raycaster then
		var2_0(arg1_13.raycaster, "Missing RoomIK raycaster")
	else
		var2_0(arg1_13.raycastCameraTF, "Missing RoomIK raycast camera")
	end

	var3_0(arg1_13)
	_.each(arg1_13.layers, function(arg0_14)
		if not arg0_14.ignoreDrag then
			local var0_14 = arg0_14:GetTriggerBoneName()

			var2_0(arg1_13.colliders[var0_14], "Missing IK collider: " .. tostring(var0_14))
		end
	end)
	_.each(arg1_13.touchDatas, function(arg0_15)
		local var0_15 = pg.dorm3d_ik_touch[arg0_15[1]]

		assert(var0_15, "Missing dorm3d_ik_touch config: " .. tostring(arg0_15[1]))

		if #var0_15.scene_item > 0 then
			var2_0(arg0_13.system:GetSceneItem(var0_15.scene_item), "Missing IK scene item: " .. var0_15.scene_item)
		else
			var2_0(arg1_13.colliders[var0_15.body], "Missing IK touch collider: " .. tostring(var0_15.body))
		end
	end)

	if arg1_13.mode == "normal" then
		var2_0(arg1_13.ladyEnv and arg1_13.ladyEnv.ladyCollider, "Missing IK lady collider")
		var2_0(arg1_13.ikCameraTF, "Missing IK camera: " .. tostring(arg1_13.config.ik_camera))
		var2_0(arg1_13.stayPoint, "Missing IK StayPoint: " .. tostring(arg1_13.config.character_position))
		_.each(arg1_13.sceneItems, function(arg0_16)
			arg0_16.target = var2_0(arg0_13.system:GetSceneItem(arg0_16.path), string.format("dorm3d_ik_touch:%d without scene_item:%s", arg0_16.id, arg0_16.path))
		end)
		_.each(arg1_13.config.hide_scene_item or {}, function(arg0_17)
			var2_0(arg0_13.system:GetSceneItem(arg0_17), "Missing IK hidden scene item: " .. tostring(arg0_17))
		end)
		_.each(arg1_13.config.enter_scene_anim or {}, function(arg0_18)
			local var0_18 = pg.dorm3d_scene_animator[arg0_18[1]]

			assert(var0_18, "Missing dorm3d_scene_animator config: " .. tostring(arg0_18[1]))
			var2_0(arg0_13.system:GetSceneItem(var0_18.item_name), "Missing IK animated scene item: " .. tostring(var0_18.item_name))
		end)
	else
		_.each(arg1_13.colliderChanges or {}, function(arg0_19)
			var2_0(arg0_19.target, "Missing timeline IK collider")
		end)
	end

	assert(type(arg1_13.onLayerAction) == "function", "Missing RoomIK layer action callback")

	arg1_13.validated = true

	return arg1_13
end

return var0_0

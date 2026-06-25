pg = pg or {}

local var0_0 = singletonClass("IKMgr")

pg.IKMgr = var0_0

function var0_0.Ctor(arg0_1)
	arg0_1.activeIKLayers = {}
	arg0_1.holdingStatus = {}
	arg0_1.cacheIKInfos = {}
end

function var0_0.RegisterEnv(arg0_2, arg1_2, arg2_2)
	arg0_2.ladyIKRoot = arg1_2
	arg0_2.ladyBoneMaps = arg2_2

	arg0_2:CreateUpdate()
end

function var0_0.RegisterOnIKLayerActive(arg0_3, arg1_3)
	arg0_3.onIKLayerActive = arg1_3
end

function var0_0.RegisterOnIKLayerDeactive(arg0_4, arg1_4)
	arg0_4.onIKLayerDeactive = arg1_4
end

function var0_0.RegisterOnIKLayerDrag(arg0_5, arg1_5)
	arg0_5.onIKLayerDrag = arg1_5
end

function var0_0.RegisterOnIKLayerAction(arg0_6, arg1_6)
	arg0_6.onIKLayerAction = arg1_6
end

function var0_0.UnregisterEnv(arg0_7)
	arg0_7.onIKLayerActive = nil
	arg0_7.onIKLayerDeactive = nil
	arg0_7.onIKLayerDrag = nil
	arg0_7.onIKLayerAction = nil

	arg0_7:ExitIKStatus()

	arg0_7.ladyIKRoot = nil
	arg0_7.ladyBoneMaps = nil

	arg0_7:DisposeUpdate()
end

function var0_0.CreateUpdate(arg0_8)
	if arg0_8.updateHandler then
		return
	end

	arg0_8.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_8:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_8.updateHandler)
end

function var0_0.DisposeUpdate(arg0_12)
	if not arg0_12.updateHandler then
		return
	end

	UpdateBeat:RemoveListener(arg0_12.updateHandler)

	arg0_12.updateHandler = nil
end

function var0_0.SetIKStatus(arg0_13, arg1_13)
	arg0_13.readyIKLayers = arg1_13

	table.Foreach(arg1_13, function(arg0_14, arg1_14)
		arg0_13.cacheIKInfos[arg1_14] = {}

		local var0_14 = arg1_14:GetControllerPath()
		local var1_14 = arg0_13.ladyIKRoot:Find(var0_14):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
		local var2_14 = {}

		table.IpairsCArray(var1_14.IKComponents, function(arg0_15, arg1_15)
			var2_14[arg0_15 + 1] = arg1_15:GetIKSolver()
		end)

		arg0_13.cacheIKInfos[arg1_14].solvers = var2_14

		local var3_14 = _.map(var2_14, function(arg0_16)
			return arg0_16.IKPositionWeight
		end)

		arg0_13.cacheIKInfos[arg1_14].weights = var3_14

		local var4_14 = tf(var1_14):Find("Container/SubTargets")
		local var5_14 = arg1_14:GetSubTargets()

		table.Foreach(var5_14, function(arg0_17, arg1_17)
			local var0_17 = var4_14:Find(arg1_17.name .. "/Plane")

			var0_17.localRotation = arg1_17.planeRot
			var0_17.localScale = arg1_17.planeScale
		end)
	end)
end

function var0_0.ExitIKStatus(arg0_18)
	arg0_18:ResetAllIKLayers()

	arg0_18.readyIKLayers = nil
	arg0_18.ikHandler = nil
	arg0_18.ikRevertHandler = nil

	table.clear(arg0_18.activeIKLayers)
	table.clear(arg0_18.cacheIKInfos)
	table.clear(arg0_18.holdingStatus)
end

function var0_0.Update(arg0_19)
	(function()
		if not arg0_19.ikHandler then
			return
		end

		if not arg0_19.ikHandler.targetScreenOffset then
			return
		end

		local var0_20 = arg0_19.ikHandler.rect
		local var1_20 = var0_20:PointToNormalized(Vector2.zero)
		local var2_20 = var0_20:PointToNormalized(arg0_19.ikHandler.targetScreenOffset) - var1_20

		_.each(arg0_19.ikHandler.subPlanes, function(arg0_21)
			local var0_21 = arg0_21.target
			local var1_21 = arg0_21.planeData

			var0_21.position = var0_0.GetPostionByRatio(var1_21, var2_20)
		end)
	end)()

	if arg0_19.ikRevertHandler then
		arg0_19.ikRevertHandler()
	end
end

function var0_0.OnDragBegin(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = _.detect(arg0_22.readyIKLayers, function(arg0_23)
		return arg0_23:GetTriggerName() == arg1_22
	end)

	if not var0_22 then
		return
	end

	if not arg3_22 and var0_22:IsIgnoreDrag() then
		return
	end

	warning("ENABLEIK", var0_22:GetControllerPath())

	local var1_22 = var0_22:GetControllerPath()
	local var2_22 = arg0_22.ladyIKRoot:Find(var1_22):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
	local var3_22 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect

	arg2_22 = Vector2.New(arg2_22.x / Screen.width * var3_22.width, arg2_22.y / Screen.height * var3_22.height)

	local var4_22 = {
		ikData = var0_22,
		list = var2_22
	}

	if not arg0_22.holdingStatus[var0_22] then
		var4_22.rect = var0_22:GetControlRect()

		local var5_22 = var0_22:GetActionType()

		if var5_22 == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET or var5_22 == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET then
			var4_22.triggerRect = var0_22:GetActionRect()
		end

		var4_22.originScreenPosition = arg2_22

		local var6_22 = tf(var2_22):Find("Container/SubTargets")
		local var7_22 = {}

		assert(var6_22)

		local var8_22 = var0_22:GetSubTargets()

		_.each(var8_22, function(arg0_24)
			local var0_24 = var6_22:Find(arg0_24.name)
			local var1_24 = var0_24:Find("Plane")
			local var2_24 = var0_24:Find("Target")
			local var3_24 = var0_0.TransformMesh(var1_24:GetComponent(typeof(UnityEngine.MeshCollider)))
			local var4_24 = arg0_22.ladyBoneMaps[arg0_24.name]

			var3_24.origin = var4_24.position

			local var5_24 = var4_22.rect
			local var6_24 = Vector2.New(var5_24.center.x / var5_24.width, var5_24.center.y / var5_24.height)

			var1_24.position = var0_0.GetPostionByRatio(var3_24, var6_24)
			var2_24.position = var4_24.position

			local var7_24 = {
				planeData = var3_24,
				target = var2_24
			}

			table.insert(var7_22, var7_24)
		end)

		var4_22.subPlanes = var7_22

		setActive(var2_22, true)
	else
		var4_22 = arg0_22.holdingStatus[var0_22].ikHandler

		local var9_22 = arg2_22 - var4_22.screenPosition

		var4_22.originScreenPosition = var4_22.originScreenPosition + var9_22
		arg0_22.holdingStatus[var0_22] = nil
	end

	arg0_22.ikHandler = var4_22

	existCall(arg0_22.onIKLayerActive, var4_22)
end

function var0_0.HandleBodyDrag(arg0_25, arg1_25)
	if not arg0_25.ikHandler then
		return
	end

	local var0_25 = arg0_25.ikHandler
	local var1_25 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect

	arg1_25 = Vector2.New(arg1_25.x / Screen.width * var1_25.width, arg1_25.y / Screen.height * var1_25.height)
	var0_25.screenPosition = arg1_25

	local var2_25 = arg1_25 - var0_25.originScreenPosition
	local var3_25 = var0_25.ikData
	local var4_25 = var0_25.rect
	local var5_25 = var4_25:Contains(var2_25)
	local var6_25 = var0_25.triggerRect and var0_25.triggerRect:Contains(var2_25)

	if not var5_25 and var3_25:GetActionType() == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET and var6_25 then
		arg0_25.ikHandler = nil

		existCall(arg0_25.onIKLayerDeactive, var0_25, true)
		table.insert(arg0_25.activeIKLayers, var3_25)
		arg0_25:PlayIKAction(var0_25)

		return
	end

	local function var7_25()
		if var5_25 then
			return var2_25
		end

		local var0_26 = var2_25
		local var1_26 = var4_25.center
		local var2_26 = {
			{
				Vector2.New(var4_25.xMin, var4_25.yMin),
				Vector2.New(var4_25.xMin, var4_25.yMax)
			},
			{
				Vector2.New(var4_25.xMin, var4_25.yMax),
				Vector2.New(var4_25.xMax, var4_25.yMax)
			},
			{
				Vector2.New(var4_25.xMax, var4_25.yMax),
				Vector2.New(var4_25.xMax, var4_25.yMin)
			},
			{
				Vector2.New(var4_25.xMax, var4_25.yMin),
				Vector2.New(var4_25.xMin, var4_25.yMin)
			}
		}

		for iter0_26 = 1, 4 do
			local var3_26, var4_26 = SegmentUtil.GetCrossPoint(var1_26, var0_26, unpack(var2_26[iter0_26]))

			if var3_26 then
				return var4_26
			end
		end

		assert(false)

		return var0_26
	end

	arg0_25.ikHandler.targetScreenOffset = var7_25()

	existCall(arg0_25.onIKLayerDrag, arg0_25.ikHandler)
end

function var0_0.ReleaseDrag(arg0_27)
	if not arg0_27.ikHandler then
		return
	end

	local var0_27 = arg0_27.ikHandler
	local var1_27 = var0_27.ikData
	local var2_27
	local var3_27 = var1_27:GetActionType()

	if var3_27 == Dorm3dIK.ACTION_TRIGGER.RELEASE then
		var2_27 = true
	elseif var3_27 == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET then
		local var4_27 = var0_27.screenPosition - var0_27.originScreenPosition

		if var0_27.triggerRect and var0_27.triggerRect:Contains(var4_27) then
			var2_27 = true
		end
	end

	arg0_27.ikHandler = nil

	existCall(arg0_27.onIKLayerDeactive, var0_27, var2_27)

	if var2_27 then
		table.insert(arg0_27.activeIKLayers, var1_27)
		arg0_27:PlayIKAction(var0_27)

		return
	end

	local var5_27 = var1_27:GetBackTime()

	if var5_27 < 999 then
		table.insert(arg0_27.activeIKLayers, var1_27)
		arg0_27:PlayIKRevert(var5_27)
	else
		arg0_27.holdingStatus[var1_27] = {
			ikHandler = var0_27
		}
	end
end

function var0_0.PlayIKRevert(arg0_28, arg1_28, arg2_28)
	local var0_28 = Time.time

	function arg0_28.ikRevertHandler()
		local var0_29 = Time.time - var0_28

		_.each(arg0_28.activeIKLayers, function(arg0_30)
			local var0_30 = 1

			if arg1_28 > 0 then
				var0_30 = var0_29 / arg1_28
			end

			local var1_30 = arg0_28.cacheIKInfos[arg0_30].solvers
			local var2_30 = arg0_28.cacheIKInfos[arg0_30].weights

			table.Foreach(var1_30, function(arg0_31, arg1_31)
				arg1_31.IKPositionWeight = math.lerp(var2_30[arg0_31], 0, var0_30)
			end)
		end)

		if var0_29 >= arg1_28 then
			arg0_28:ResetActiveIKs()

			arg0_28.ikRevertHandler = nil

			existCall(arg2_28)
		end
	end

	arg0_28.ikRevertHandler()
end

function var0_0.ResetIK(arg0_32, arg1_32)
	local var0_32 = _.detect(arg0_32.readyIKLayers, function(arg0_33)
		return arg0_33:GetTriggerName() == arg1_32
	end)

	if not var0_32 then
		return
	end

	local var1_32 = var0_32:GetControllerPath()
	local var2_32 = arg0_32.ladyIKRoot:Find(var1_32):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

	setActive(var2_32, false)

	local var3_32 = arg0_32.cacheIKInfos[var0_32].solvers
	local var4_32 = arg0_32.cacheIKInfos[var0_32].weights

	table.Foreach(var3_32, function(arg0_34, arg1_34)
		arg1_34.IKPositionWeight = var4_32[arg0_34]

		arg1_34:FixTransforms()
	end)

	arg0_32.holdingStatus[var0_32] = nil

	if arg0_32.moveTimer then
		arg0_32.moveTimer:Stop()

		arg0_32.moveTimer = nil
	end
end

function var0_0.ResetIKLayers(arg0_35, arg1_35)
	local var0_35 = {}

	_.each(arg1_35 or {}, function(arg0_36)
		if not arg0_36 or var0_35[arg0_36] then
			return
		end

		var0_35[arg0_36] = true

		local var0_36 = arg0_36:GetControllerPath()
		local var1_36 = arg0_35.ladyIKRoot and arg0_35.ladyIKRoot:Find(var0_36)

		if var1_36 and not IsNil(var1_36) then
			setActive(var1_36, false)
		end

		local var2_36 = arg0_35.cacheIKInfos[arg0_36]

		if var2_36 then
			local var3_36 = var2_36.solvers
			local var4_36 = var2_36.weights

			table.Foreach(var3_36, function(arg0_37, arg1_37)
				arg1_37.IKPositionWeight = var4_36[arg0_37]
			end)
		end
	end)
end

function var0_0.ResetAllIKLayers(arg0_38)
	local var0_38 = {}

	local function var1_38(arg0_39)
		if not arg0_39 then
			return
		end

		table.insert(var0_38, arg0_39)
	end

	_.each(arg0_38.readyIKLayers or {}, var1_38)
	_.each(arg0_38.activeIKLayers or {}, var1_38)
	_.each(_.keys(arg0_38.holdingStatus), var1_38)

	if arg0_38.ikHandler then
		var1_38(arg0_38.ikHandler.ikData)
	end

	arg0_38:ResetIKLayers(var0_38)
	table.clear(arg0_38.activeIKLayers)
	table.clear(arg0_38.holdingStatus)

	arg0_38.ikHandler = nil
	arg0_38.ikRevertHandler = nil

	if arg0_38.moveTimer then
		arg0_38.moveTimer:Stop()

		arg0_38.moveTimer = nil
	end
end

function var0_0.ResetActiveIKs(arg0_40)
	table.insertto(arg0_40.activeIKLayers, _.keys(arg0_40.holdingStatus))
	table.clear(arg0_40.holdingStatus)
	arg0_40:ResetIKLayers(arg0_40.activeIKLayers)
	table.clear(arg0_40.activeIKLayers)

	if arg0_40.moveTimer then
		arg0_40.moveTimer:Stop()

		arg0_40.moveTimer = nil
	end
end

function var0_0.PlayIKAction(arg0_41, arg1_41)
	warning("Trigger IK", arg1_41.ikData:GetControllerPath())
	seriesAsync({
		function(arg0_42)
			table.insertto(arg0_41.activeIKLayers, _.keys(arg0_41.holdingStatus))
			table.clear(arg0_41.holdingStatus)
			arg0_41:PlayIKRevert(arg1_41.ikData:GetActionRevertTime(), arg0_42)
		end,
		function(arg0_43)
			existCall(arg0_41.onIKLayerAction, arg1_41)
		end
	})
end

function var0_0.PlayIKMove(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44, arg6_44)
	if arg0_44.moveTimer then
		arg0_44.moveTimer:Stop()

		arg0_44.moveTimer = nil
	end

	arg0_44.ikRevertHandler = nil

	local var0_44 = _.detect(arg0_44.readyIKLayers, function(arg0_45)
		return arg0_45:GetTriggerName() == arg2_44
	end)

	if not var0_44 then
		existCall(arg6_44)

		return
	end

	warning("PLAY IKMOVE", var0_44:GetControllerPath())
	arg0_44:OnDragBegin(arg2_44, arg1_44, true)

	if not arg0_44.ikHandler then
		existCall(arg6_44)

		return
	end

	local var1_44 = Time.time + arg5_44
	local var2_44 = arg1_44
	local var3_44 = arg0_44.ikHandler.originScreenPosition + arg0_44.ikHandler.rect:NormalizedToPoint(arg3_44) * arg4_44

	local function var4_44()
		if not arg0_44.ikHandler or Time.time > var1_44 then
			arg0_44:ReleaseDrag()

			if arg0_44.moveTimer then
				arg0_44.moveTimer:Stop()

				arg0_44.moveTimer = nil
			end

			existCall(arg6_44)

			return
		end

		local var0_46 = math.max(0, var1_44 - Time.time) / arg5_44
		local var1_46 = Vector2.Lerp(var3_44, var2_44, var0_46)
		local var2_46 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
		local var3_46 = Vector2.New(var1_46.x / var2_46.width * Screen.width, var1_46.y / var2_46.height * Screen.height)

		arg0_44:HandleBodyDrag(var3_46)
	end

	arg0_44.moveTimer = FrameTimer.New(var4_44, 1, -1)

	arg0_44.moveTimer:Start()
	var4_44()
end

function var0_0.TransformMesh(arg0_47)
	local var0_47 = arg0_47.sharedMesh
	local var1_47 = {}
	local var2_47 = arg0_47.transform:TransformPoint(var0_47.vertices[0])
	local var3_47 = arg0_47.transform:TransformPoint(var0_47.vertices[1])
	local var4_47 = arg0_47.transform:TransformPoint(var0_47.vertices[2])

	var1_47.horizontal = var3_47 - var2_47
	var1_47.verticle = var4_47 - var2_47
	var1_47.origin = var2_47

	return var1_47
end

function var0_0.GetPostionByRatio(arg0_48, arg1_48)
	return arg0_48.horizontal * arg1_48.x + arg0_48.verticle * arg1_48.y + arg0_48.origin
end

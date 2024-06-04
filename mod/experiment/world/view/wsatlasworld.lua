local var0 = class("WSAtlasWorld", import(".WSAtlas"))

var0.Fields = {
	isDragging = "boolean",
	tfMapModel = "userdata",
	tfModel = "userdata",
	tfAreaScene = "userdata",
	nowArea = "number",
	dragTrigger = "userdata",
	wsTimer = "table",
	twRotateId = "number",
	isTransAnim = "boolean",
	areaLockPressingAward = "table",
	entranceTplDic = "table",
	twFocusIds = "table"
}
var0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance",
	onUpdatePortMark = "OnUpdatePortMark",
	onUpdatePressingAward = "OnUpdatePressingAward",
	onUpdateProgress = "OnUpdateProgress"
}
var0.EventUpdateselectEntrance = "WSAtlasWorld.EventUpdateselectEntrance"
var0.baseDistance = -217.4
var0.frontDistance = -101.6237
var0.basePoint = Vector2(1024, 550)
var0.baseMoveDistance = 100
var0.baseDuration = 0.8
var0.selectOffsetPos = Vector2(107, 61)

function var0.Dispose(arg0)
	arg0:DisposeEntranceTplDic()
	var0.super.Dispose(arg0)
end

function var0.Init(arg0)
	var0.super.Init(arg0)

	arg0.entranceTplDic = {}
	arg0.twFocusIds = {}
	arg0.areaLockPressingAward = {}
end

function var0.UpdateAtlas(arg0, arg1)
	if arg0.atlas ~= arg1 then
		arg0:RemoveAtlasListener()
		arg0:DisposeEntranceTplDic()

		arg0.atlas = arg1

		arg0:AddAtlasListener()
		arg0:NewEntranceTplDic()
		arg0:UpdateModelMask()
		arg0:OnUpdateActiveEntrance(nil, nil, arg0.atlas:GetActiveEntrance())
		arg0:OnUpdatePressingAward()
	end
end

function var0.AddAtlasListener(arg0)
	if arg0.atlas then
		arg0.atlas:AddListener(WorldAtlas.EventUpdatePortMark, arg0.onUpdatePortMark)
	end

	var0.super.AddAtlasListener(arg0)
end

function var0.RemoveAtlasListener(arg0)
	if arg0.atlas then
		arg0.atlas:RemoveListener(WorldAtlas.EventUpdatePortMark, arg0.onUpdatePortMark)
	end

	var0.super.RemoveAtlasListener(arg0)
end

function var0.LoadModel(arg0, arg1)
	local var0 = {}

	if not arg0.tfModel then
		table.insert(var0, function(arg0)
			local var0 = PoolMgr.GetInstance()

			var0:GetPrefab("model/worldmapmodel", "WorldMapModel", true, function(arg0)
				if arg0.transform then
					arg0.tfModel = tf(arg0)

					setParent(arg0.tfModel, arg0.tfMapModel, false)
				else
					var0:ReturnPrefab("model/worldmapmodel", "WorldMapModel", arg0, true)
				end

				return arg0()
			end)
		end)
	end

	seriesAsync(var0, function()
		return existCall(arg1)
	end)
end

function var0.ReturnModel(arg0)
	if arg0.tfModel then
		PoolMgr.GetInstance():ReturnPrefab("model/worldmapmodel", "WorldMapModel", go(arg0.tfModel), true)
	end
end

function var0.LoadScene(arg0, arg1)
	SceneOpMgr.Inst:LoadSceneAsync("scenes/worldmap3d", "worldmap3d", LoadSceneMode.Additive, function(arg0, arg1)
		arg0.transform = tf(arg0:GetRootGameObjects()[0])

		setActive(arg0.transform, false)

		arg0.tfEntity = arg0.transform:Find("entity")
		arg0.tfAreaScene = arg0.tfEntity:Find("area_scene")
		arg0.tfMapScene = arg0.tfEntity:Find("map_scene")
		arg0.tfMapModel = arg0.tfEntity:Find("model")
		arg0.tfMapSelect = arg0.tfMapScene:Find("selected_layer")
		arg0.tfSpriteScene = arg0.tfEntity:Find("sprite_scene")
		arg0.tfCamera = arg0.transform:Find("Main Camera")
		arg0.tfCamera:GetComponent("Camera").depthTextureMode = UnityEngine.DepthTextureMode.Depth
		arg0.defaultSprite = arg0.tfEntity:Find("decolation_layer/edge"):GetComponent("SpriteRenderer").material
		arg0.addSprite = arg0.tfEntity:Find("map_scene/mask_layer"):GetComponent("SpriteRenderer").material

		local var0 = math.deg2Rad * 30
		local var1 = arg0.frontDistance / UnityEngine.Screen.height

		arg0.dragTrigger = arg0.tfEntity:Find("Plane"):GetComponent("EventTriggerListener")

		arg0.dragTrigger:AddDragFunc(function(arg0, arg1)
			arg0.isDragging = true

			if not arg0.nowArea or arg0:CheckIsTweening() then
				return
			end

			if arg0.selectEntrance then
				arg0:UpdateSelect()
			end

			local var0 = Vector3(arg1.delta.x, 0, arg1.delta.y / math.cos(var0)) * var1

			arg0.tfCamera.localPosition = arg0.tfCamera.localPosition + var0
		end)
		arg0.dragTrigger:AddDragEndFunc(function(arg0, arg1)
			arg0.isDragging = false
		end)
		arg0:UpdateCenterEffectDisplay()
		arg0:BuildActiveMark()

		local var2 = nowWorld()

		arg0.cmPointer = arg0.tfEntity:Find("Plane"):GetComponent(typeof(PointerInfo))

		arg0.cmPointer:AddColorMaskClickListener(function(arg0, arg1)
			if arg0.isDragging then
				return
			end

			local var0 = var2:ColorToEntrance(arg0)

			if var0 then
				arg0.onClickColor(var0, arg1.position)
			end
		end)

		return existCall(arg1)
	end)
end

function var0.ReturnScene(arg0)
	arg0:ReturnModel()

	if arg0.transform then
		local var0 = arg0.tfMapScene:GetComponent("FMultiSpriteRenderCtrl")

		var0.alpha = 1

		var0:UpdateAlpha()

		local var1 = arg0.tfAreaScene:GetComponent("FMultiSpriteRenderCtrl")

		var1.alpha = 1

		var1:UpdateAlpha()
		SceneOpMgr.Inst:UnloadSceneAsync("scene/worldmap3d", "worldmap3d")

		arg0.cmPointer = nil
	end
end

function var0.ShowOrHide(arg0, arg1)
	var0.super.ShowOrHide(arg0, arg1)

	if arg1 then
		SceneManager.SetActiveScene(SceneManager.GetSceneByName("WorldMap3D"))
	else
		SceneManager.SetActiveScene(SceneManager.GetSceneByName("main"))
	end
end

function var0.GetOffsetMapPos(arg0)
	local var0 = var0.selectOffsetPos
	local var1 = arg0.tfEntity.localEulerAngles.y
	local var2 = math.rad(-var1)

	return Vector2(var0.x * math.cos(var2) - var0.y * math.sin(var2), var0.y * math.cos(var2) + var0.x * math.sin(var2))
end

function var0.UpdateSelect(arg0, arg1, arg2, arg3)
	if arg1 then
		arg0.nowArea = arg1:GetAreaId()

		arg0:FocusPos(Vector2(arg1.config.area_pos[1], arg1.config.area_pos[2]) + arg0:GetOffsetMapPos(), nil, 1, true, function()
			var0.super.UpdateSelect(arg0, arg1)
			arg0:DispatchEvent(var0.EventUpdateselectEntrance, arg1, arg2, arg3)
		end)
	else
		var0.super.UpdateSelect(arg0, arg1)
		arg0:DispatchEvent(var0.EventUpdateselectEntrance, arg1, arg2, arg3)
	end
end

function var0.UpdateModelMask(arg0)
	var0.super.UpdateModelMask(arg0)
	arg0:UpdateAreaLock()
end

function var0.UpdateEntranceMask(arg0, arg1)
	local var0 = arg0.entranceTplDic[arg1.id]

	if arg1:HasPort() then
		var0:UpdatePort(arg0.atlas:GetEntrancePortInfo(arg1.id))
	end

	var0.super.UpdateEntranceMask(arg0, arg1)
end

function var0.OnUpdateProgress(arg0, arg1, arg2, arg3)
	var0.super.OnUpdateProgress(arg0, arg1, arg2, arg3)
	arg0:UpdateAreaLock()
end

function var0.UpdateAreaLock(arg0)
	for iter0 = 1, 5 do
		local var0 = nowWorld():CheckAreaUnlock(iter0)

		setActive(arg0.tfAreaScene:Find("lock_layer/" .. iter0), not var0)
		setActive(arg0.tfMapScene:Find("mask_layer/" .. iter0), var0)

		if var0 and arg0.areaLockPressingAward[iter0] then
			for iter1, iter2 in ipairs(arg0.areaLockPressingAward[iter0]) do
				arg0.entranceTplDic[iter2]:UpdatePressingAward()
			end

			arg0.areaLockPressingAward[iter0] = nil
		end
	end
end

function var0.OnUpdateActiveEntrance(arg0, arg1, arg2, arg3)
	var0.super.OnUpdateActiveEntrance(arg0, arg1, arg2, arg3)

	if arg3 then
		local var0 = arg3:HasPort()

		arg0:DoUpdatExtraMark(arg0.tfActiveMark, "mark_active_1", not var0)
		arg0:DoUpdatExtraMark(arg0.tfActiveMark, "mark_active_port", var0)
	end

	local var1 = arg3 and arg3:GetAreaId()

	for iter0 = 1, 5 do
		setActive(arg0.tfAreaScene:Find("selected_layer/B" .. iter0 .. "_2"), iter0 == var1)
		setActive(arg0.tfAreaScene:Find("base_layer/B" .. iter0), iter0 ~= var1)
	end
end

function var0.OnUpdatePressingAward(arg0, arg1, arg2, arg3)
	arg3 = arg3 or arg0.atlas.transportDic

	for iter0, iter1 in pairs(arg3) do
		if iter1 then
			local var0 = arg0.atlas:GetEntrance(iter0):GetAreaId()

			if nowWorld():CheckAreaUnlock(var0) then
				arg0.entranceTplDic[iter0]:UpdatePressingAward()
			else
				arg0.areaLockPressingAward[var0] = arg0.areaLockPressingAward[var0] or {}

				table.insert(arg0.areaLockPressingAward[var0], iter0)
			end
		end
	end

	var0.super.OnUpdatePressingAward(arg0, arg1, arg2, arg3)
end

function var0.OnUpdatePortMark(arg0, arg1, arg2, arg3)
	for iter0, iter1 in pairs(arg3) do
		if iter1 then
			arg0.entranceTplDic[iter0]:UpdatePort(arg0.atlas:GetEntrancePortInfo(iter0))
		end
	end
end

function var0.NewEntranceTplDic(arg0)
	for iter0, iter1 in pairs(arg0.atlas.entranceDic) do
		arg0.entranceTplDic[iter1.id] = arg0:NewEntranceTpl(iter1)
	end
end

function var0.DisposeEntranceTplDic(arg0)
	WPool:ReturnArray(_.values(arg0.entranceTplDic))

	arg0.entranceTplDic = {}
end

function var0.NewEntranceTpl(arg0, arg1)
	local var0 = WPool:Get(WSEntranceTpl)

	var0.transform:SetParent(arg0.tfSpriteScene, false)

	var0.transform.localPosition = WorldConst.CalcModelPosition(arg1, arg0.spriteBaseSize)
	var0.tfArea = arg0.tfAreaScene:Find("display_layer")
	var0.tfMap = arg0.tfMapScene:Find("display_layer")

	var0:Setup()
	var0:UpdateEntrance(arg1)

	return var0
end

function var0.FindEntranceTpl(arg0, arg1)
	return arg0.entranceTplDic[arg1.id]
end

function var0.UpdateScale(arg0, arg1)
	arg1 = arg1 or 0

	local var0 = arg0.tfCamera.localEulerAngles.x / 180 * math.pi
	local var1 = arg0.tfCamera.localPosition.y / -math.sin(var0)
	local var2 = var0.baseDistance * (1 - arg1) + arg0.frontDistance * arg1 - var1
	local var3 = Vector3(0, -math.sin(var0) * var2, math.cos(var0) * var2)

	arg0.tfCamera.localPosition = arg0.tfCamera.localPosition + var3
end

function var0.FocusPos(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg0.twRotateId then
		LeanTween.cancel(arg0.twRotateId)

		arg0.twRotateId = nil
	end

	arg3 = arg3 or 0
	arg2 = 0

	if not arg1 then
		local var0 = math.rad(-arg2)

		arg1 = var0.basePoint - var0.spriteBaseSize / 2
		arg1 = Vector2(arg1.x * math.cos(var0) - arg1.y * math.sin(var0), arg1.y * math.cos(var0) + arg1.x * math.sin(var0))
		arg1 = arg1 + var0.spriteBaseSize / 2
	end

	local var1 = math.rad(arg0.tfEntity.localEulerAngles.y - arg2)

	arg1 = arg1 - var0.spriteBaseSize / 2
	arg1 = Vector2(arg1.x * math.cos(var1) - arg1.y * math.sin(var1), arg1.y * math.cos(var1) + arg1.x * math.sin(var1))

	local var2 = Vector3(arg1.x, 0, arg1.y) / PIXEL_PER_UNIT
	local var3 = arg0.transform:InverseTransformPoint(arg0.tfSpriteScene:TransformPoint(var2))
	local var4 = math.rad(arg0.tfCamera.localEulerAngles.x)
	local var5 = var3 - Vector3(0, var3.y, var3.y / -math.tan(var4)) + Vector3(0, arg0.tfCamera.localPosition.y, arg0.tfCamera.localPosition.y / -math.tan(var4))
	local var6 = var5.y / -math.sin(var4)
	local var7 = var0.baseDistance * (1 - arg3) + var0.frontDistance * arg3 - var6
	local var8 = var5 + Vector3(0, -math.sin(var4) * var7, math.cos(var4) * var7)

	if arg4 then
		local var9 = math.min(Vector3.Distance(arg0.tfCamera.localPosition, var8) / var0.baseMoveDistance, 1) * var0.baseDuration
		local var10 = math.min(math.abs(arg2 - arg0.tfEntity.localEulerAngles.y) / 180, 1) * var0.baseDuration
		local var11 = {}

		table.insert(var11, function(arg0)
			local var0 = LeanTween.moveLocal(go(arg0.tfCamera), var8, var9):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0)).uniqueId

			table.insert(arg0.twFocusIds, var0)
			arg0.wsTimer:AddTween(var0)
		end)
		table.insert(var11, function(arg0)
			local var0 = LeanTween.rotateY(go(arg0.tfEntity), arg2, var10):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0)).uniqueId

			table.insert(arg0.twFocusIds, var0)
			arg0.wsTimer:AddTween(var0)
		end)
		parallelAsync(var11, function()
			existCall(arg5)
		end)
	else
		arg0.tfCamera.localPosition = var8
		arg0.tfEntity.localEulerAngles = Vector3(0, arg2, 0)

		return existCall(arg5)
	end
end

function var0.FocusPosInArea(arg0, arg1, arg2, arg3)
	if arg1 then
		local var0 = pg.world_regions_data[arg1]

		arg0:FocusPos(Vector2(var0.regions_pos[1], var0.regions_pos[2]), var0.regions_rotation[1], 1, arg2, arg3)
	else
		arg0:FocusPos(var0.basePoint, 0, 0, arg2, arg3)
	end
end

function var0.SwitchArea(arg0, arg1, arg2, arg3)
	local var0 = {}

	if arg2 and tobool(arg1) ~= tobool(arg0.nowArea) then
		table.insert(var0, function(arg0)
			arg0:SwitchMode(arg1, arg2, arg0)
		end)
	end

	table.insert(var0, function(arg0)
		setActive(arg0.tfAreaScene, not arg1)
		setActive(arg0.tfMapScene, arg1)
		setActive(arg0.tfMapModel, not arg1)
		arg0()
	end)

	arg0.nowArea = arg1

	parallelAsync({
		function(arg0)
			seriesAsync(var0, arg0)
		end,
		function(arg0)
			arg0:FocusPosInArea(arg1, arg2, arg0)
		end
	}, function()
		return existCall(arg3)
	end)
end

function var0.SwitchMode(arg0, arg1, arg2, arg3)
	local var0 = function(arg0)
		setActive(arg0.tfAreaScene, true)

		local var0 = arg0.tfAreaScene:GetComponent("FMultiSpriteRenderCtrl")

		var0:Init()

		var0.alpha = arg1 and 1 or 0

		var0:UpdateAlpha()

		local var1 = LeanTween.value(go(arg0.tfAreaScene), arg1 and 1 or 0, arg1 and 0 or 1, var0.baseDuration):setOnUpdate(System.Action_float(function(arg0)
			var0.alpha = arg0
		end)):setOnComplete(System.Action(function()
			var0.alpha = 1

			var0:UpdateAlpha()
			setActive(arg0.tfAreaScene, not arg1)

			return arg0()
		end)).uniqueId

		table.insert(arg0.twFocusIds, var1)
		arg0.wsTimer:AddTween(var1)
	end

	local function var1(arg0)
		setActive(arg0.tfMapScene, true)

		local var0 = arg0.tfMapScene:GetComponent("FMultiSpriteRenderCtrl")

		var0:Init()

		var0.alpha = arg1 and 0 or 1

		var0:UpdateAlpha()

		local var1 = LeanTween.value(go(arg0.tfMapScene), arg1 and 0 or 1, arg1 and 1 or 0, var0.baseDuration):setOnUpdate(System.Action_float(function(arg0)
			var0.alpha = arg0
		end)):setOnComplete(System.Action(function()
			var0.alpha = 1

			var0:UpdateAlpha()
			setActive(arg0.tfMapScene, arg1)

			return arg0()
		end)).uniqueId

		table.insert(arg0.twFocusIds, var1)
		arg0.wsTimer:AddTween(var1)
	end

	local function var2(arg0)
		setActive(arg0.tfMapModel, true)

		local var0 = {}
		local var1 = var0.baseDuration

		table.insert(var0, function(arg0)
			local var0 = arg0.tfModel:Find("Terrain_LOD9_perfect")
			local var1 = var0:GetComponent("MeshRenderer").material

			var1:SetFloat("_Invisible", arg1 and 1 or 0)

			local var2 = LeanTween.value(go(var0), arg1 and 1 or 0, arg1 and 0 or 1, var1):setOnUpdate(System.Action_float(function(arg0)
				var1:SetFloat("_Invisible", arg0)
			end)):setOnComplete(System.Action(function()
				var1:SetFloat("_Invisible", arg1 and 0 or 1)
				arg0()
			end)).uniqueId

			table.insert(arg0.twFocusIds, var2)
			arg0.wsTimer:AddTween(var2)
		end)
		table.insert(var0, function(arg0)
			local var0 = arg0.tfModel:Find("decolation_model")
			local var1 = var0:GetComponent("FMultiSpriteRenderCtrl")

			var1:Init()

			var1.alpha = arg1 and 1 or 0

			var1:UpdateAlpha()

			local var2 = LeanTween.value(go(var0), arg1 and 1 or 0, arg1 and 0 or 1, var1):setOnUpdate(System.Action_float(function(arg0)
				var1.alpha = arg0
			end)):setOnComplete(System.Action(function()
				var1.alpha = 1

				var1:UpdateAlpha()
				arg0()
			end)).uniqueId

			table.insert(arg0.twFocusIds, var2)
			arg0.wsTimer:AddTween(var2)
		end)
		parallelAsync(var0, function()
			setActive(arg0.tfMapModel, not arg1)

			return arg0()
		end)
	end

	local function var3()
		arg0:BreathRotate(not arg1)

		return existCall(arg3)
	end

	if arg2 then
		parallelAsync({
			var0,
			var1,
			var2
		}, function()
			return var3()
		end)
	else
		return var3()
	end
end

var0.LowRotation = -5
var0.HeightRotation = 5
var0.BreathTime = 18

function var0.BreathRotate(arg0, arg1)
	if arg0.twRotateId then
		LeanTween.cancel(arg0.twRotateId)

		arg0.twRotateId = nil
	end

	if not arg1 then
		return
	end

	local var0 = -1

	local function var1()
		var0 = -1 * var0
		arg0.twRotateId = LeanTween.rotateY(go(arg0.tfEntity), var0 == 1 and var0.HeightRotation or var0.LowRotation, var0.BreathTime):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
			var1()
		end)).uniqueId
	end

	arg0.twRotateId = LeanTween.rotateY(go(arg0.tfEntity), var0.LowRotation, var0.BreathTime / 2):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
		var1()
	end)):setDelay(1).uniqueId
end

function var0.CheckIsTweening(arg0)
	while #arg0.twFocusIds > 0 and not LeanTween.isTweening(arg0.twFocusIds[1]) do
		table.remove(arg0.twFocusIds, 1)
	end

	return arg0.isTransAnim or #arg0.twFocusIds > 0
end

function var0.ActiveTrans(arg0, arg1)
	if arg0.entranceTplDic[arg1.id].portCamp then
		-- block empty
	else
		local var0 = arg0.tfMapSelect:Find("A" .. arg1:GetColormaskUniqueID() .. "_2")

		setActive(var0, true)

		local var1 = var0:GetComponent("SpriteRenderer").color

		var1.a = 0
		var0:GetComponent("SpriteRenderer").color = var1

		LeanTween.alpha(go(var0), 1, 0.3):setOnComplete(System.Action(function()
			LeanTween.alpha(go(var0), 0, 0.2):setDelay(0.1):setOnComplete(System.Action(function()
				setActive(var0, arg0.selectEntrance == arg1)

				var1.a = 1
				var0:GetComponent("SpriteRenderer").color = var1
			end))
		end))
	end
end

function var0.DisplayTransport(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.atlas.transportDic) do
		if iter1 and not arg1[iter0] then
			var0[iter0] = true
		end
	end

	arg0:UpdateTransMark(var0, arg2)
end

function var0.UpdateTransMark(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg1) do
		if iter1 then
			arg0.isTransAnim = true

			arg0:ActiveTrans(arg0.atlas:GetEntrance(iter0))
		end
	end

	if arg0.isTransAnim then
		arg0.wsTimer:AddTimer(function()
			arg0.isTransAnim = false

			arg2()
		end, 0.6):Start()
	else
		arg2()
	end
end

function var0.UpdateActiveMark(arg0)
	local var0 = nowWorld():GetActiveMap():CkeckTransport()

	eachChild(arg0.tfActiveMark, function(arg0)
		setActive(arg0:Find("base"), var0)
		setActive(arg0:Find("limit"), not var0)
	end)
end

return var0

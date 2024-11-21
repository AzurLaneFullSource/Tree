local var0_0 = class("WSAtlasWorld", import(".WSAtlas"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance",
	onUpdatePortMark = "OnUpdatePortMark",
	onUpdatePressingAward = "OnUpdatePressingAward",
	onUpdateProgress = "OnUpdateProgress"
}
var0_0.EventUpdateselectEntrance = "WSAtlasWorld.EventUpdateselectEntrance"
var0_0.baseDistance = -217.4
var0_0.frontDistance = -101.6237
var0_0.basePoint = Vector2(1024, 550)
var0_0.baseMoveDistance = 100
var0_0.baseDuration = 0.8
var0_0.selectOffsetPos = Vector2(107, 61)

function var0_0.Dispose(arg0_1)
	arg0_1:DisposeEntranceTplDic()
	var0_0.super.Dispose(arg0_1)
end

function var0_0.Init(arg0_2)
	var0_0.super.Init(arg0_2)

	arg0_2.entranceTplDic = {}
	arg0_2.twFocusIds = {}
	arg0_2.areaLockPressingAward = {}
end

function var0_0.UpdateAtlas(arg0_3, arg1_3)
	if arg0_3.atlas ~= arg1_3 then
		arg0_3:RemoveAtlasListener()
		arg0_3:DisposeEntranceTplDic()

		arg0_3.atlas = arg1_3

		arg0_3:AddAtlasListener()
		arg0_3:NewEntranceTplDic()
		arg0_3:UpdateModelMask()
		arg0_3:OnUpdateActiveEntrance(nil, nil, arg0_3.atlas:GetActiveEntrance())
		arg0_3:OnUpdatePressingAward()
	end
end

function var0_0.AddAtlasListener(arg0_4)
	if arg0_4.atlas then
		arg0_4.atlas:AddListener(WorldAtlas.EventUpdatePortMark, arg0_4.onUpdatePortMark)
	end

	var0_0.super.AddAtlasListener(arg0_4)
end

function var0_0.RemoveAtlasListener(arg0_5)
	if arg0_5.atlas then
		arg0_5.atlas:RemoveListener(WorldAtlas.EventUpdatePortMark, arg0_5.onUpdatePortMark)
	end

	var0_0.super.RemoveAtlasListener(arg0_5)
end

function var0_0.LoadModel(arg0_6, arg1_6)
	local var0_6 = {}

	if not arg0_6.tfModel then
		table.insert(var0_6, function(arg0_7)
			local var0_7 = PoolMgr.GetInstance()

			var0_7:GetPrefab("model/worldmapmodel", "WorldMapModel", true, function(arg0_8)
				if arg0_6.transform then
					arg0_6.tfModel = tf(arg0_8)

					setParent(arg0_6.tfModel, arg0_6.tfMapModel, false)
				else
					var0_7:ReturnPrefab("model/worldmapmodel", "WorldMapModel", arg0_8, true)
				end

				return arg0_7()
			end)
		end)
	end

	seriesAsync(var0_6, function()
		return existCall(arg1_6)
	end)
end

function var0_0.ReturnModel(arg0_10)
	if arg0_10.tfModel then
		PoolMgr.GetInstance():ReturnPrefab("model/worldmapmodel", "WorldMapModel", go(arg0_10.tfModel), true)
	end
end

function var0_0.LoadScene(arg0_11, arg1_11)
	gcAll(true)
	SceneOpMgr.Inst:LoadSceneAsync("scenes/worldmap3d", "worldmap3d", LoadSceneMode.Additive, function(arg0_12, arg1_12)
		arg0_11.transform = tf(arg0_12:GetRootGameObjects()[0])

		setActive(arg0_11.transform, false)

		arg0_11.tfEntity = arg0_11.transform:Find("entity")
		arg0_11.tfAreaScene = arg0_11.tfEntity:Find("area_scene")
		arg0_11.tfMapScene = arg0_11.tfEntity:Find("map_scene")
		arg0_11.tfMapModel = arg0_11.tfEntity:Find("model")
		arg0_11.tfMapSelect = arg0_11.tfMapScene:Find("selected_layer")
		arg0_11.tfSpriteScene = arg0_11.tfEntity:Find("sprite_scene")
		arg0_11.tfCamera = arg0_11.transform:Find("Main Camera")
		arg0_11.tfCamera:GetComponent("Camera").depthTextureMode = UnityEngine.DepthTextureMode.Depth
		arg0_11.defaultSprite = arg0_11.tfEntity:Find("decolation_layer/edge"):GetComponent("SpriteRenderer").material
		arg0_11.addSprite = arg0_11.tfEntity:Find("map_scene/mask_layer"):GetComponent("SpriteRenderer").material

		local var0_12 = math.deg2Rad * 30
		local var1_12 = arg0_11.frontDistance / UnityEngine.Screen.height

		arg0_11.dragTrigger = arg0_11.tfEntity:Find("Plane"):GetComponent("EventTriggerListener")

		arg0_11.dragTrigger:AddDragFunc(function(arg0_13, arg1_13)
			arg0_11.isDragging = true

			if not arg0_11.nowArea or arg0_11:CheckIsTweening() then
				return
			end

			if arg0_11.selectEntrance then
				arg0_11:UpdateSelect()
			end

			local var0_13 = Vector3(arg1_13.delta.x, 0, arg1_13.delta.y / math.cos(var0_12)) * var1_12

			arg0_11.tfCamera.localPosition = arg0_11.tfCamera.localPosition + var0_13
		end)
		arg0_11.dragTrigger:AddDragEndFunc(function(arg0_14, arg1_14)
			arg0_11.isDragging = false
		end)
		arg0_11:UpdateCenterEffectDisplay()
		arg0_11:BuildActiveMark()

		local var2_12 = nowWorld()

		arg0_11.cmPointer = arg0_11.tfEntity:Find("Plane"):GetComponent(typeof(PointerInfo))

		arg0_11.cmPointer:AddColorMaskClickListener(function(arg0_15, arg1_15)
			if arg0_11.isDragging then
				return
			end

			local var0_15 = var2_12:ColorToEntrance(arg0_15)

			if var0_15 then
				arg0_11.onClickColor(var0_15, arg1_15.position)
			end
		end)

		return existCall(arg1_11)
	end)
end

function var0_0.ReturnScene(arg0_16)
	arg0_16:ReturnModel()

	if arg0_16.transform then
		local var0_16 = arg0_16.tfMapScene:GetComponent("FMultiSpriteRenderCtrl")

		var0_16.alpha = 1

		var0_16:UpdateAlpha()

		local var1_16 = arg0_16.tfAreaScene:GetComponent("FMultiSpriteRenderCtrl")

		var1_16.alpha = 1

		var1_16:UpdateAlpha()
		SceneOpMgr.Inst:UnloadSceneAsync("scene/worldmap3d", "worldmap3d")

		arg0_16.cmPointer = nil
	end
end

function var0_0.ShowOrHide(arg0_17, arg1_17)
	var0_0.super.ShowOrHide(arg0_17, arg1_17)

	if arg1_17 then
		SceneManager.SetActiveScene(SceneManager.GetSceneByName("WorldMap3D"))
	else
		SceneManager.SetActiveScene(SceneManager.GetSceneByName("main"))
	end
end

function var0_0.GetOffsetMapPos(arg0_18)
	local var0_18 = var0_0.selectOffsetPos
	local var1_18 = arg0_18.tfEntity.localEulerAngles.y
	local var2_18 = math.rad(-var1_18)

	return Vector2(var0_18.x * math.cos(var2_18) - var0_18.y * math.sin(var2_18), var0_18.y * math.cos(var2_18) + var0_18.x * math.sin(var2_18))
end

function var0_0.UpdateSelect(arg0_19, arg1_19, arg2_19, arg3_19)
	if arg1_19 then
		arg0_19.nowArea = arg1_19:GetAreaId()

		arg0_19:FocusPos(Vector2(arg1_19.config.area_pos[1], arg1_19.config.area_pos[2]) + arg0_19:GetOffsetMapPos(), nil, 1, true, function()
			var0_0.super.UpdateSelect(arg0_19, arg1_19)
			arg0_19:DispatchEvent(var0_0.EventUpdateselectEntrance, arg1_19, arg2_19, arg3_19)
		end)
	else
		var0_0.super.UpdateSelect(arg0_19, arg1_19)
		arg0_19:DispatchEvent(var0_0.EventUpdateselectEntrance, arg1_19, arg2_19, arg3_19)
	end
end

function var0_0.UpdateModelMask(arg0_21)
	var0_0.super.UpdateModelMask(arg0_21)
	arg0_21:UpdateAreaLock()
end

function var0_0.UpdateEntranceMask(arg0_22, arg1_22)
	local var0_22 = arg0_22.entranceTplDic[arg1_22.id]

	if arg1_22:HasPort() then
		var0_22:UpdatePort(arg0_22.atlas:GetEntrancePortInfo(arg1_22.id))
	end

	var0_0.super.UpdateEntranceMask(arg0_22, arg1_22)
end

function var0_0.OnUpdateProgress(arg0_23, arg1_23, arg2_23, arg3_23)
	var0_0.super.OnUpdateProgress(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23:UpdateAreaLock()
end

function var0_0.UpdateAreaLock(arg0_24)
	for iter0_24 = 1, 5 do
		local var0_24 = nowWorld():CheckAreaUnlock(iter0_24)

		setActive(arg0_24.tfAreaScene:Find("lock_layer/" .. iter0_24), not var0_24)
		setActive(arg0_24.tfMapScene:Find("mask_layer/" .. iter0_24), var0_24)

		if var0_24 and arg0_24.areaLockPressingAward[iter0_24] then
			for iter1_24, iter2_24 in ipairs(arg0_24.areaLockPressingAward[iter0_24]) do
				arg0_24.entranceTplDic[iter2_24]:UpdatePressingAward()
			end

			arg0_24.areaLockPressingAward[iter0_24] = nil
		end
	end
end

function var0_0.OnUpdateActiveEntrance(arg0_25, arg1_25, arg2_25, arg3_25)
	var0_0.super.OnUpdateActiveEntrance(arg0_25, arg1_25, arg2_25, arg3_25)

	if arg3_25 then
		local var0_25 = arg3_25:HasPort()

		arg0_25:DoUpdatExtraMark(arg0_25.tfActiveMark, "mark_active_1", not var0_25)
		arg0_25:DoUpdatExtraMark(arg0_25.tfActiveMark, "mark_active_port", var0_25)
	end

	local var1_25 = arg3_25 and arg3_25:GetAreaId()

	for iter0_25 = 1, 5 do
		setActive(arg0_25.tfAreaScene:Find("selected_layer/B" .. iter0_25 .. "_2"), iter0_25 == var1_25)
		setActive(arg0_25.tfAreaScene:Find("base_layer/B" .. iter0_25), iter0_25 ~= var1_25)
	end
end

function var0_0.OnUpdatePressingAward(arg0_26, arg1_26, arg2_26, arg3_26)
	arg3_26 = arg3_26 or arg0_26.atlas.transportDic

	for iter0_26, iter1_26 in pairs(arg3_26) do
		if iter1_26 then
			local var0_26 = arg0_26.atlas:GetEntrance(iter0_26):GetAreaId()

			if nowWorld():CheckAreaUnlock(var0_26) then
				arg0_26.entranceTplDic[iter0_26]:UpdatePressingAward()
			else
				arg0_26.areaLockPressingAward[var0_26] = arg0_26.areaLockPressingAward[var0_26] or {}

				table.insert(arg0_26.areaLockPressingAward[var0_26], iter0_26)
			end
		end
	end

	var0_0.super.OnUpdatePressingAward(arg0_26, arg1_26, arg2_26, arg3_26)
end

function var0_0.OnUpdatePortMark(arg0_27, arg1_27, arg2_27, arg3_27)
	for iter0_27, iter1_27 in pairs(arg3_27) do
		if iter1_27 then
			arg0_27.entranceTplDic[iter0_27]:UpdatePort(arg0_27.atlas:GetEntrancePortInfo(iter0_27))
		end
	end
end

function var0_0.NewEntranceTplDic(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.atlas.entranceDic) do
		arg0_28.entranceTplDic[iter1_28.id] = arg0_28:NewEntranceTpl(iter1_28)
	end
end

function var0_0.DisposeEntranceTplDic(arg0_29)
	WPool:ReturnArray(_.values(arg0_29.entranceTplDic))

	arg0_29.entranceTplDic = {}
end

function var0_0.NewEntranceTpl(arg0_30, arg1_30)
	local var0_30 = WPool:Get(WSEntranceTpl)

	var0_30.transform:SetParent(arg0_30.tfSpriteScene, false)

	var0_30.transform.localPosition = WorldConst.CalcModelPosition(arg1_30, arg0_30.spriteBaseSize)
	var0_30.tfArea = arg0_30.tfAreaScene:Find("display_layer")
	var0_30.tfMap = arg0_30.tfMapScene:Find("display_layer")

	var0_30:Setup()
	var0_30:UpdateEntrance(arg1_30)

	return var0_30
end

function var0_0.FindEntranceTpl(arg0_31, arg1_31)
	return arg0_31.entranceTplDic[arg1_31.id]
end

function var0_0.UpdateScale(arg0_32, arg1_32)
	arg1_32 = arg1_32 or 0

	local var0_32 = arg0_32.tfCamera.localEulerAngles.x / 180 * math.pi
	local var1_32 = arg0_32.tfCamera.localPosition.y / -math.sin(var0_32)
	local var2_32 = var0_0.baseDistance * (1 - arg1_32) + arg0_32.frontDistance * arg1_32 - var1_32
	local var3_32 = Vector3(0, -math.sin(var0_32) * var2_32, math.cos(var0_32) * var2_32)

	arg0_32.tfCamera.localPosition = arg0_32.tfCamera.localPosition + var3_32
end

function var0_0.FocusPos(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33)
	if arg0_33.twRotateId then
		LeanTween.cancel(arg0_33.twRotateId)

		arg0_33.twRotateId = nil
	end

	arg3_33 = arg3_33 or 0
	arg2_33 = 0

	if not arg1_33 then
		local var0_33 = math.rad(-arg2_33)

		arg1_33 = var0_0.basePoint - var0_0.spriteBaseSize / 2
		arg1_33 = Vector2(arg1_33.x * math.cos(var0_33) - arg1_33.y * math.sin(var0_33), arg1_33.y * math.cos(var0_33) + arg1_33.x * math.sin(var0_33))
		arg1_33 = arg1_33 + var0_0.spriteBaseSize / 2
	end

	local var1_33 = math.rad(arg0_33.tfEntity.localEulerAngles.y - arg2_33)

	arg1_33 = arg1_33 - var0_0.spriteBaseSize / 2
	arg1_33 = Vector2(arg1_33.x * math.cos(var1_33) - arg1_33.y * math.sin(var1_33), arg1_33.y * math.cos(var1_33) + arg1_33.x * math.sin(var1_33))

	local var2_33 = Vector3(arg1_33.x, 0, arg1_33.y) / PIXEL_PER_UNIT
	local var3_33 = arg0_33.transform:InverseTransformPoint(arg0_33.tfSpriteScene:TransformPoint(var2_33))
	local var4_33 = math.rad(arg0_33.tfCamera.localEulerAngles.x)
	local var5_33 = var3_33 - Vector3(0, var3_33.y, var3_33.y / -math.tan(var4_33)) + Vector3(0, arg0_33.tfCamera.localPosition.y, arg0_33.tfCamera.localPosition.y / -math.tan(var4_33))
	local var6_33 = var5_33.y / -math.sin(var4_33)
	local var7_33 = var0_0.baseDistance * (1 - arg3_33) + var0_0.frontDistance * arg3_33 - var6_33
	local var8_33 = var5_33 + Vector3(0, -math.sin(var4_33) * var7_33, math.cos(var4_33) * var7_33)

	if arg4_33 then
		local var9_33 = math.min(Vector3.Distance(arg0_33.tfCamera.localPosition, var8_33) / var0_0.baseMoveDistance, 1) * var0_0.baseDuration
		local var10_33 = math.min(math.abs(arg2_33 - arg0_33.tfEntity.localEulerAngles.y) / 180, 1) * var0_0.baseDuration
		local var11_33 = {}

		table.insert(var11_33, function(arg0_34)
			local var0_34 = LeanTween.moveLocal(go(arg0_33.tfCamera), var8_33, var9_33):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0_34)).uniqueId

			table.insert(arg0_33.twFocusIds, var0_34)
			arg0_33.wsTimer:AddTween(var0_34)
		end)
		table.insert(var11_33, function(arg0_35)
			local var0_35 = LeanTween.rotateY(go(arg0_33.tfEntity), arg2_33, var10_33):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg0_35)).uniqueId

			table.insert(arg0_33.twFocusIds, var0_35)
			arg0_33.wsTimer:AddTween(var0_35)
		end)
		parallelAsync(var11_33, function()
			existCall(arg5_33)
		end)
	else
		arg0_33.tfCamera.localPosition = var8_33
		arg0_33.tfEntity.localEulerAngles = Vector3(0, arg2_33, 0)

		return existCall(arg5_33)
	end
end

function var0_0.FocusPosInArea(arg0_37, arg1_37, arg2_37, arg3_37)
	if arg1_37 then
		local var0_37 = pg.world_regions_data[arg1_37]

		arg0_37:FocusPos(Vector2(var0_37.regions_pos[1], var0_37.regions_pos[2]), var0_37.regions_rotation[1], 1, arg2_37, arg3_37)
	else
		arg0_37:FocusPos(var0_0.basePoint, 0, 0, arg2_37, arg3_37)
	end
end

function var0_0.SwitchArea(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = {}

	if arg2_38 and tobool(arg1_38) ~= tobool(arg0_38.nowArea) then
		table.insert(var0_38, function(arg0_39)
			arg0_38:SwitchMode(arg1_38, arg2_38, arg0_39)
		end)
	end

	table.insert(var0_38, function(arg0_40)
		setActive(arg0_38.tfAreaScene, not arg1_38)
		setActive(arg0_38.tfMapScene, arg1_38)
		setActive(arg0_38.tfMapModel, not arg1_38)
		arg0_40()
	end)

	arg0_38.nowArea = arg1_38

	parallelAsync({
		function(arg0_41)
			seriesAsync(var0_38, arg0_41)
		end,
		function(arg0_42)
			arg0_38:FocusPosInArea(arg1_38, arg2_38, arg0_42)
		end
	}, function()
		return existCall(arg3_38)
	end)
end

function var0_0.SwitchMode(arg0_44, arg1_44, arg2_44, arg3_44)
	local function var0_44(arg0_45)
		setActive(arg0_44.tfAreaScene, true)

		local var0_45 = arg0_44.tfAreaScene:GetComponent("FMultiSpriteRenderCtrl")

		var0_45:Init()

		var0_45.alpha = arg1_44 and 1 or 0

		var0_45:UpdateAlpha()

		local var1_45 = LeanTween.value(go(arg0_44.tfAreaScene), arg1_44 and 1 or 0, arg1_44 and 0 or 1, var0_0.baseDuration):setOnUpdate(System.Action_float(function(arg0_46)
			var0_45.alpha = arg0_46
		end)):setOnComplete(System.Action(function()
			var0_45.alpha = 1

			var0_45:UpdateAlpha()
			setActive(arg0_44.tfAreaScene, not arg1_44)

			return arg0_45()
		end)).uniqueId

		table.insert(arg0_44.twFocusIds, var1_45)
		arg0_44.wsTimer:AddTween(var1_45)
	end

	local function var1_44(arg0_48)
		setActive(arg0_44.tfMapScene, true)

		local var0_48 = arg0_44.tfMapScene:GetComponent("FMultiSpriteRenderCtrl")

		var0_48:Init()

		var0_48.alpha = arg1_44 and 0 or 1

		var0_48:UpdateAlpha()

		local var1_48 = LeanTween.value(go(arg0_44.tfMapScene), arg1_44 and 0 or 1, arg1_44 and 1 or 0, var0_0.baseDuration):setOnUpdate(System.Action_float(function(arg0_49)
			var0_48.alpha = arg0_49
		end)):setOnComplete(System.Action(function()
			var0_48.alpha = 1

			var0_48:UpdateAlpha()
			setActive(arg0_44.tfMapScene, arg1_44)

			return arg0_48()
		end)).uniqueId

		table.insert(arg0_44.twFocusIds, var1_48)
		arg0_44.wsTimer:AddTween(var1_48)
	end

	local function var2_44(arg0_51)
		setActive(arg0_44.tfMapModel, true)

		local var0_51 = {}
		local var1_51 = var0_0.baseDuration

		table.insert(var0_51, function(arg0_52)
			local var0_52 = arg0_44.tfModel:Find("Terrain_LOD9_perfect")
			local var1_52 = var0_52:GetComponent("MeshRenderer").material

			var1_52:SetFloat("_Invisible", arg1_44 and 1 or 0)

			local var2_52 = LeanTween.value(go(var0_52), arg1_44 and 1 or 0, arg1_44 and 0 or 1, var1_51):setOnUpdate(System.Action_float(function(arg0_53)
				var1_52:SetFloat("_Invisible", arg0_53)
			end)):setOnComplete(System.Action(function()
				var1_52:SetFloat("_Invisible", arg1_44 and 0 or 1)
				arg0_52()
			end)).uniqueId

			table.insert(arg0_44.twFocusIds, var2_52)
			arg0_44.wsTimer:AddTween(var2_52)
		end)
		table.insert(var0_51, function(arg0_55)
			local var0_55 = arg0_44.tfModel:Find("decolation_model")
			local var1_55 = var0_55:GetComponent("FMultiSpriteRenderCtrl")

			var1_55:Init()

			var1_55.alpha = arg1_44 and 1 or 0

			var1_55:UpdateAlpha()

			local var2_55 = LeanTween.value(go(var0_55), arg1_44 and 1 or 0, arg1_44 and 0 or 1, var1_51):setOnUpdate(System.Action_float(function(arg0_56)
				var1_55.alpha = arg0_56
			end)):setOnComplete(System.Action(function()
				var1_55.alpha = 1

				var1_55:UpdateAlpha()
				arg0_55()
			end)).uniqueId

			table.insert(arg0_44.twFocusIds, var2_55)
			arg0_44.wsTimer:AddTween(var2_55)
		end)
		parallelAsync(var0_51, function()
			setActive(arg0_44.tfMapModel, not arg1_44)

			return arg0_51()
		end)
	end

	local function var3_44()
		arg0_44:BreathRotate(not arg1_44)

		return existCall(arg3_44)
	end

	if arg2_44 then
		parallelAsync({
			var0_44,
			var1_44,
			var2_44
		}, function()
			return var3_44()
		end)
	else
		return var3_44()
	end
end

var0_0.LowRotation = -5
var0_0.HeightRotation = 5
var0_0.BreathTime = 18

function var0_0.BreathRotate(arg0_61, arg1_61)
	if arg0_61.twRotateId then
		LeanTween.cancel(arg0_61.twRotateId)

		arg0_61.twRotateId = nil
	end

	if not arg1_61 then
		return
	end

	local var0_61 = -1

	local function var1_61()
		var0_61 = -1 * var0_61
		arg0_61.twRotateId = LeanTween.rotateY(go(arg0_61.tfEntity), var0_61 == 1 and var0_0.HeightRotation or var0_0.LowRotation, var0_0.BreathTime):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
			var1_61()
		end)).uniqueId
	end

	arg0_61.twRotateId = LeanTween.rotateY(go(arg0_61.tfEntity), var0_0.LowRotation, var0_0.BreathTime / 2):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function()
		var1_61()
	end)):setDelay(1).uniqueId
end

function var0_0.CheckIsTweening(arg0_65)
	while #arg0_65.twFocusIds > 0 and not LeanTween.isTweening(arg0_65.twFocusIds[1]) do
		table.remove(arg0_65.twFocusIds, 1)
	end

	return arg0_65.isTransAnim or #arg0_65.twFocusIds > 0
end

function var0_0.ActiveTrans(arg0_66, arg1_66)
	if arg0_66.entranceTplDic[arg1_66.id].portCamp then
		-- block empty
	else
		local var0_66 = arg0_66.tfMapSelect:Find("A" .. arg1_66:GetColormaskUniqueID() .. "_2")

		setActive(var0_66, true)

		local var1_66 = var0_66:GetComponent("SpriteRenderer").color

		var1_66.a = 0
		var0_66:GetComponent("SpriteRenderer").color = var1_66

		LeanTween.alpha(go(var0_66), 1, 0.3):setOnComplete(System.Action(function()
			LeanTween.alpha(go(var0_66), 0, 0.2):setDelay(0.1):setOnComplete(System.Action(function()
				setActive(var0_66, arg0_66.selectEntrance == arg1_66)

				var1_66.a = 1
				var0_66:GetComponent("SpriteRenderer").color = var1_66
			end))
		end))
	end
end

function var0_0.DisplayTransport(arg0_69, arg1_69, arg2_69)
	local var0_69 = {}

	for iter0_69, iter1_69 in pairs(arg0_69.atlas.transportDic) do
		if iter1_69 and not arg1_69[iter0_69] then
			var0_69[iter0_69] = true
		end
	end

	arg0_69:UpdateTransMark(var0_69, arg2_69)
end

function var0_0.UpdateTransMark(arg0_70, arg1_70, arg2_70)
	for iter0_70, iter1_70 in pairs(arg1_70) do
		if iter1_70 then
			arg0_70.isTransAnim = true

			arg0_70:ActiveTrans(arg0_70.atlas:GetEntrance(iter0_70))
		end
	end

	if arg0_70.isTransAnim then
		arg0_70.wsTimer:AddTimer(function()
			arg0_70.isTransAnim = false

			arg2_70()
		end, 0.6):Start()
	else
		arg2_70()
	end
end

function var0_0.UpdateActiveMark(arg0_72)
	local var0_72 = nowWorld():GetActiveMap():CkeckTransport()

	eachChild(arg0_72.tfActiveMark, function(arg0_73)
		setActive(arg0_73:Find("base"), var0_72)
		setActive(arg0_73:Find("limit"), not var0_72)
	end)
end

return var0_0

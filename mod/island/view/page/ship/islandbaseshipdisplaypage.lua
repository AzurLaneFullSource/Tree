local var0_0 = class("IslandBaseShipDisplayPage", import("...base.IslandBasePage"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.displayUnit = IslandDisplayShipUnit.New()
	arg0_1.gcCounter = 0
end

function var0_0.Preload(arg0_2, arg1_2)
	arg0_2:PrepareCharacterScene(arg1_2)
end

function var0_0.PrepareCharacterScene(arg0_3, arg1_3)
	arg0_3.isLoadCharacterScene = true

	seriesAsync({
		function(arg0_4)
			arg0_3:CreateCharacterContainer()
			arg0_3:CreateToolContainer()
			arg0_3:LoadCharacterScene(arg0_4)
		end,
		function(arg0_5)
			arg0_3:ModifyCameraMask()
			arg0_3:ActivityCharacterCamera()
			arg0_3:InitSceneTimeline()
			arg0_5()
		end
	}, arg1_3)
end

function var0_0.CreateCharacterContainer(arg0_6)
	arg0_6.roleContainer = GameObject.New("roleContainer").transform

	pg.ViewUtils.SetLayer(arg0_6.roleContainer, Layer.Character3D)
end

function var0_0.LoadCharacterScene(arg0_7, arg1_7)
	local var0_7 = "island/scenesres/scenes/character/map_shipmainui_scene"

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var0_7, "map_shipmainui", LoadSceneMode.Additive, function(arg0_8)
		if arg0_8 == 1 then
			arg1_7()
		end
	end)
end

function var0_0.ModifyCameraMask(arg0_9)
	local var0_9 = IslandCameraMgr.instance

	if IsNil(var0_9) then
		var0_9 = CheatTavernCameraMgr.instance
	end

	local var1_9 = var0_9._mainCamera

	arg0_9.defaultCullingMask = var1_9.cullingMask

	LuaHelper.SetCamCullingMask(var1_9, "Character3D")
end

function var0_0.ActivityCharacterCamera(arg0_10)
	local var0_10 = arg0_10:GetActiveCamName()
	local var1_10 = IslandCameraMgr.instance

	if IsNil(var1_10) then
		var1_10 = CheatTavernCameraMgr.instance
	end

	local var2_10 = var1_10:GetVirtualCamera(var0_10)

	var2_10.Follow = arg0_10.roleContainer
	var2_10.LookAt = arg0_10.roleContainer

	var1_10:ActiveVirtualCamera(var0_10)
end

function var0_0.InitSceneTimeline(arg0_11)
	local var0_11 = GameObject.Find("[sequence]")

	if var0_11 then
		local var1_11 = var0_11:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		TimelineSupport.DynamicBinding(var1_11)
		var1_11:Play()
	end
end

function var0_0.ClearCharacterScene(arg0_12, arg1_12)
	if arg0_12.isLoadCharacterScene then
		arg0_12:UnLoadCharacterScene(arg1_12)
		arg0_12:ClearCharacterContainer()
		arg0_12:ClearToolContainer()
		arg0_12:ResetCameraMask()
		arg0_12:ActivityPlayerCamera()
		arg0_12:emitCore(ISLAND_EVT.REFRESH_WEATHER_SYSTEM)
	end

	arg0_12.isLoadCharacterScene = false
end

function var0_0.OnHome(arg0_13)
	arg0_13:ClearCharacterScene(function()
		arg0_13:emit(BaseUI.ON_HOME)
	end)
end

function var0_0.LoadCharacter(arg0_15, arg1_15, arg2_15)
	arg0_15:UnloadCharacter(arg0_15.loadData)

	local var0_15 = {
		isCommander = arg2_15,
		modelData = arg1_15
	}

	arg0_15.loadData = var0_15

	local function var1_15(arg0_16, arg1_16)
		if var0_15.modelData.model ~= arg0_15.loadData.modelData.model then
			arg0_15:UnloadCharacter(var0_15)

			return
		end

		arg0_15.role = arg0_16

		pg.ViewUtils.SetLayer(arg0_15.role.transform, Layer.Character3D)
		setParent(arg0_15.role, arg0_15.roleContainer)

		arg0_15.role.transform.eulerAngles = Vector3(0, 180, 0)

		local var0_16 = 0
		local var1_16 = arg0_15._tf.rect.width / arg0_15._tf.rect.height

		if var1_16 < 1.77777777777778 then
			var0_16 = 0.5 * (1.77777777777778 - var1_16) / 0.444444444444444
		end

		arg0_15.role.transform.localPosition = Vector3(var0_16, 0, 0)

		local var2_16 = arg0_15:GetSmoothRotateObject()
		local var3_16 = GetOrAddComponent(var2_16, typeof(SmoothRotateObject))

		var3_16:SetUp(arg0_15.role.transform)

		var3_16.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_15.displayUnit:OnAttach(arg0_16, arg0_15.toolContainer)

		if arg1_16 and arg1_16 ~= "" then
			local var4_16 = GetOrAddComponent(arg0_15.role.transform:GetChild(0), typeof(Animator))

			for iter0_16 = 1, var4_16.layerCount do
				var4_16:CrossFadeInFixedTime(arg1_16, 0, iter0_16 - 1)
			end
		end

		GetOrAddComponent(arg0_15.role, typeof(CharacterFootprintMgr)):SetSpawnMode(1)
		arg0_15:OnCharLoaded(var0_15.modelData)
	end

	arg0_15:_LoadModel(var0_15, var1_15)
end

function var0_0._LoadModel(arg0_17, arg1_17, arg2_17)
	pg.UIMgr.GetInstance():LoadingOn()

	local var0_17 = arg1_17.modelData

	if arg1_17.isCommander then
		arg0_17:GetPoolMgr():GetCommanderModel(var0_17, function(arg0_18)
			arg2_17(arg0_18, var0_17.personal_ani)
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	elseif arg0_17:IsPreviewScene() then
		arg0_17:GetPoolMgr():GetPreviewModel(var0_17, function(arg0_19)
			arg2_17(arg0_19, var0_17.personal_ani)
			pg.UIMgr.GetInstance():LoadingOff()
		end, arg0_17:GetDressByType(), arg0_17:GetColorByDressId())
	else
		arg0_17:GetPoolMgr():GetCharacter(var0_17.model, var0_17.animator, function(arg0_20)
			arg2_17(arg0_20, var0_17.personal_ani)
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end
end

function var0_0.UnloadCharacter(arg0_21, arg1_21)
	if not arg1_21 then
		return
	end

	local var0_21 = arg1_21.modelData
	local var1_21 = arg1_21.isCommander
	local var2_21 = arg0_21:GetSmoothRotateObject():GetComponent(typeof(SmoothRotateObject))

	if var2_21 then
		Object.Destroy(var2_21)

		local var3_21
	end

	if arg0_21.role then
		arg0_21.displayUnit:OnDetach()
		pg.ViewUtils.SetLayer(arg0_21.role.transform, Layer.Default)

		if arg0_21.isCommander then
			arg0_21:GetPoolMgr():ReturnCommanderModel(arg0_21.role)
		elseif arg0_21:IsPreviewScene() then
			Object.Destroy(arg0_21.role)
		else
			arg0_21:GetPoolMgr():ReturnCharacter(var0_21.model, var0_21.animator, arg0_21.role)
		end

		arg0_21.role = nil
	end

	if arg0_21.gcCounter >= 3 then
		arg0_21.gcCounter = 0

		IslandHelper.RunGC(true)
	else
		arg0_21.gcCounter = arg0_21.gcCounter + 1
	end
end

function var0_0.ClearCharacterContainer(arg0_22)
	arg0_22:UnloadCharacter(arg0_22.loadData)

	arg0_22.loadData = nil

	if not IsNil(arg0_22.roleContainer) then
		Object.Destroy(arg0_22.roleContainer.gameObject)

		arg0_22.roleContainer = nil
	end
end

function var0_0.UnLoadCharacterScene(arg0_23, arg1_23)
	local var0_23 = "island/scenesres/scenes/character/map_shipmainui_scene"

	SceneOpMgr.Inst:UnloadSceneAsync(var0_23, "map_shipmainui", function()
		if arg1_23 then
			arg1_23()
		end
	end)
end

function var0_0.ResetCameraMask(arg0_25)
	local var0_25 = IslandCameraMgr.instance

	if IsNil(var0_25) then
		var0_25 = CheatTavernCameraMgr.instance
	end

	if arg0_25.defaultCullingMask and var0_25 then
		local var1_25 = var0_25._mainCamera

		LuaHelper.ResetCamCullingMask(var1_25, arg0_25.defaultCullingMask)
	end
end

function var0_0.ActivityPlayerCamera(arg0_26)
	if not IslandCameraMgr.instance then
		return
	end

	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
end

function var0_0.CreateToolContainer(arg0_27)
	arg0_27.toolContainer = GameObject.New("toolContainer").transform

	pg.ViewUtils.SetLayer(arg0_27.roleContainer, Layer.Default)
end

function var0_0.ClearToolContainer(arg0_28)
	if not IsNil(arg0_28.toolContainer) then
		Object.Destroy(arg0_28.toolContainer.gameObject)

		arg0_28.toolContainer = nil
	end
end

function var0_0.OnClearItemAnimator(arg0_29)
	arg0_29.displayUnit:OnClearItemAnimator()
end

function var0_0.Hide(arg0_30)
	var0_0.super.Hide(arg0_30)
	arg0_30:ClearCharacterScene()
end

function var0_0.OnDisable(arg0_31)
	arg0_31:ClearCharacterScene()
end

function var0_0.OnDestroy(arg0_32)
	arg0_32:ClearCharacterScene()

	for iter0_32, iter1_32 in pairs(arg0_32.cards or {}) do
		iter1_32:Dispose()
	end

	arg0_32.cards = nil
end

function var0_0.GetActiveCamName(arg0_33)
	return IslandConst.CHARA_CAMERA_NAME
end

function var0_0.GetSmoothRotateObject(arg0_34)
	assert(false, "Write me")
end

function var0_0.OnCharLoaded(arg0_35)
	return
end

function var0_0.IsPreviewScene(arg0_36)
	return false
end

function var0_0.GetDressByType(arg0_37)
	return {}
end

function var0_0.GetColorByDressId(arg0_38)
	return {}
end

return var0_0

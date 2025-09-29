local var0_0 = class("IslandBaseShipDisplayPage", import("...base.IslandBasePage"))

function var0_0.Preload(arg0_1, arg1_1)
	arg0_1:PrepareCharacterScene(arg1_1)
end

function var0_0.PrepareCharacterScene(arg0_2, arg1_2)
	arg0_2.isLoadCharacterScene = true

	seriesAsync({
		function(arg0_3)
			arg0_2:CreateCharacterContainer()
			arg0_2:LoadCharacterScene(arg0_3)
		end,
		function(arg0_4)
			arg0_2:ModifyCameraMask()
			arg0_2:ActivityCharacterCamera()
			arg0_2:InitSceneTimeline()
			arg0_4()
		end
	}, arg1_2)
end

function var0_0.CreateCharacterContainer(arg0_5)
	arg0_5.roleContainer = GameObject.New("roleContainer").transform

	pg.ViewUtils.SetLayer(arg0_5.roleContainer, Layer.Character3D)
end

function var0_0.LoadCharacterScene(arg0_6, arg1_6)
	local var0_6 = "island/scenesres/scenes/character/map_shipmainui_scene"

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var0_6, "map_shipmainui", LoadSceneMode.Additive, function(arg0_7)
		if arg0_7 == 1 then
			arg1_6()
		end
	end)
end

function var0_0.ModifyCameraMask(arg0_8)
	local var0_8 = IslandCameraMgr.instance._mainCamera

	arg0_8.defaultCullingMask = var0_8.cullingMask

	LuaHelper.SetCamCullingMask(var0_8, "Character3D")
end

function var0_0.ActivityCharacterCamera(arg0_9)
	local var0_9 = arg0_9:GetActiveCamName()
	local var1_9 = IslandCameraMgr.instance:GetVirtualCamera(var0_9)

	var1_9.Follow = arg0_9.roleContainer
	var1_9.LookAt = arg0_9.roleContainer

	IslandCameraMgr.instance:ActiveVirtualCamera(var0_9)
end

function var0_0.InitSceneTimeline(arg0_10)
	local var0_10 = GameObject.Find("[sequence]")

	if var0_10 then
		local var1_10 = var0_10:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		TimelineSupport.DynamicBinding(var1_10)
		var1_10:Play()
	end
end

function var0_0.ClearCharacterScene(arg0_11, arg1_11)
	if arg0_11.isLoadCharacterScene then
		arg0_11:UnLoadCharacterScene(arg1_11)
		arg0_11:ClearCharacterContainer()
		arg0_11:ResetCameraMask()
		arg0_11:ActivityPlayerCamera()
		arg0_11:emitCore(ISLAND_EVT.REFRESH_WEATHER_SYSTEM)
	end

	arg0_11.isLoadCharacterScene = false
end

function var0_0.OnHome(arg0_12)
	arg0_12:ClearCharacterScene(function()
		arg0_12:emit(BaseUI.ON_HOME)
	end)
end

function var0_0.LoadCharacter(arg0_14, arg1_14, arg2_14)
	arg0_14:UnloadCharacter(arg0_14.loadData)

	local var0_14 = {
		isCommander = arg2_14,
		modelData = arg1_14
	}

	arg0_14.loadData = var0_14

	local function var1_14(arg0_15, arg1_15)
		if var0_14.modelData.model ~= arg0_14.loadData.modelData.model then
			arg0_14:UnloadCharacter(var0_14)

			return
		end

		arg0_14.role = arg0_15

		pg.ViewUtils.SetLayer(arg0_14.role.transform, Layer.Character3D)
		setParent(arg0_14.role, arg0_14.roleContainer)

		arg0_14.role.transform.eulerAngles = Vector3(0, 180, 0)

		local var0_15 = 0
		local var1_15 = arg0_14._tf.rect.width / arg0_14._tf.rect.height

		if var1_15 < 1.77777777777778 then
			var0_15 = 0.5 * (1.77777777777778 - var1_15) / 0.444444444444444
		end

		arg0_14.role.transform.localPosition = Vector3(var0_15, 0, 0)

		local var2_15 = arg0_14:GetSmoothRotateObject()
		local var3_15 = GetOrAddComponent(var2_15, typeof(SmoothRotateObject))

		var3_15:SetUp(arg0_14.role.transform)

		var3_15.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		if arg1_15 and arg1_15 ~= "" then
			local var4_15 = GetOrAddComponent(arg0_14.role.transform:GetChild(0), typeof(Animator))

			for iter0_15 = 1, var4_15.layerCount do
				var4_15:CrossFadeInFixedTime(arg1_15, 0, iter0_15 - 1)
			end
		end

		arg0_14:OnCharLoaded(var0_14.modelData)
	end

	arg0_14:_LoadModel(var0_14, var1_14)
end

function var0_0._LoadModel(arg0_16, arg1_16, arg2_16)
	pg.UIMgr.GetInstance():LoadingOn()

	local var0_16 = arg1_16.modelData

	if arg1_16.isCommander then
		arg0_16:GetPoolMgr():GetCommanderModel(var0_16, function(arg0_17)
			arg2_16(arg0_17, var0_16.personal_ani)
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	else
		arg0_16:GetPoolMgr():GetCharacter(var0_16.model, var0_16.animator, function(arg0_18)
			arg2_16(arg0_18, var0_16.personal_ani)
			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end
end

function var0_0.UnloadCharacter(arg0_19, arg1_19)
	if not arg1_19 then
		return
	end

	local var0_19 = arg1_19.modelData
	local var1_19 = arg1_19.isCommander
	local var2_19 = arg0_19:GetSmoothRotateObject():GetComponent(typeof(SmoothRotateObject))

	if var2_19 then
		Object.Destroy(var2_19)

		local var3_19
	end

	if arg0_19.role then
		pg.ViewUtils.SetLayer(arg0_19.role.transform, Layer.Default)

		if arg0_19.isCommander then
			arg0_19:GetPoolMgr():ReturnCommanderModel(arg0_19.role)
		else
			arg0_19:GetPoolMgr():ReturnCharacter(var0_19.model, var0_19.animator, arg0_19.role)
		end

		arg0_19.role = nil
	end
end

function var0_0.ClearCharacterContainer(arg0_20)
	arg0_20:UnloadCharacter(arg0_20.loadData)

	arg0_20.loadData = nil

	if not IsNil(arg0_20.roleContainer) then
		Object.Destroy(arg0_20.roleContainer.gameObject)

		arg0_20.roleContainer = nil
	end
end

function var0_0.UnLoadCharacterScene(arg0_21, arg1_21)
	local var0_21 = "island/scenesres/scenes/character/map_shipmainui_scene"

	SceneOpMgr.Inst:UnloadSceneAsync(var0_21, "map_shipmainui", function()
		if arg1_21 then
			arg1_21()
		end
	end)
end

function var0_0.ResetCameraMask(arg0_23)
	if arg0_23.defaultCullingMask and IslandCameraMgr.instance then
		local var0_23 = IslandCameraMgr.instance._mainCamera

		LuaHelper.ResetCamCullingMask(var0_23, arg0_23.defaultCullingMask)
	end
end

function var0_0.ActivityPlayerCamera(arg0_24)
	if not IslandCameraMgr.instance then
		return
	end

	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
end

function var0_0.Hide(arg0_25)
	var0_0.super.Hide(arg0_25)
	arg0_25:ClearCharacterScene()
end

function var0_0.OnDisable(arg0_26)
	arg0_26:ClearCharacterScene()
end

function var0_0.OnDestroy(arg0_27)
	arg0_27:ClearCharacterScene()

	for iter0_27, iter1_27 in pairs(arg0_27.cards or {}) do
		iter1_27:Dispose()
	end

	arg0_27.cards = nil
end

function var0_0.GetActiveCamName(arg0_28)
	return IslandConst.CHARA_CAMERA_NAME
end

function var0_0.GetSmoothRotateObject(arg0_29)
	assert(false, "Write me")
end

function var0_0.OnCharLoaded(arg0_30)
	return
end

return var0_0

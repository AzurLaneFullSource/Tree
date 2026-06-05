local var0_0 = class("IslandBaseDressupPage", import("...base.IslandBasePage"))

function var0_0.Preload(arg0_1, arg1_1)
	arg0_1:PrepareCharacterScene(arg1_1)
end

function var0_0.PrepareCharacterScene(arg0_2, arg1_2)
	arg0_2.isLoadCharacterScene = true

	seriesAsync({
		function(arg0_3)
			arg0_2:LoadCharacterScene(arg0_3)
		end,
		function(arg0_4)
			arg0_2:CreateCharacterContainer()
			arg0_2:ModifyCameraMask()
			onNextTick(function()
				arg0_2:ActivityCharacterCamera()
			end)
			arg0_4()
		end
	}, arg1_2)
end

function var0_0.LoadCharacterScene(arg0_6, arg1_6)
	local var0_6 = "island/scenesres/scenes/character/map_ship_dressup_scene"

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var0_6, "map_ship_dressup", LoadSceneMode.Additive, function(arg0_7)
		if arg0_7 == 1 then
			SceneOpMgr.Inst:SetActiveSceneByIndex(1)
			arg1_6()
		end
	end)
end

function var0_0.CreateCharacterContainer(arg0_8)
	arg0_8.roleContainer = GameObject.New("roleContainer").transform

	pg.ViewUtils.SetLayer(arg0_8.roleContainer, Layer.Character3D)
end

function var0_0.ModifyCameraMask(arg0_9)
	local var0_9 = IslandCameraMgr.instance._mainCamera

	arg0_9.defaultCullingMask = var0_9.cullingMask

	LuaHelper.SetCamCullingMask(var0_9, "Character3D")
end

function var0_0.ActivityCharacterCamera(arg0_10)
	local var0_10 = arg0_10:GetActiveCamName()
	local var1_10 = IslandCameraMgr.instance:GetVirtualCamera(var0_10)

	var1_10.Follow = arg0_10.roleContainer
	var1_10.LookAt = arg0_10.roleContainer

	IslandCameraMgr.instance:ActiveVirtualCamera(var0_10)
end

function var0_0.GetActiveCamName(arg0_11)
	return IslandConst.DRESSUP_CAMERA_NAME
end

function var0_0.UnLoadCharacterScene(arg0_12, arg1_12)
	local var0_12 = "island/scenesres/scenes/character/map_ship_dressup_scene"

	SceneOpMgr.Inst:UnloadSceneAsync(var0_12, "map_ship_dressup", function()
		if arg1_12 then
			arg1_12()
		end
	end)
end

function var0_0.ClearCharacterScene(arg0_14, arg1_14)
	if arg0_14.isLoadCharacterScene then
		arg0_14:UnLoadCharacterScene(arg1_14)
		arg0_14:ClearCharacterContainer()
	end

	arg0_14.isLoadCharacterScene = false
end

function var0_0.ClearCharacterContainer(arg0_15)
	arg0_15:UnloadCharacter()

	if arg0_15.roleContainer then
		Object.Destroy(arg0_15.roleContainer.gameObject)

		arg0_15.roleContainer = nil
	end
end

function var0_0.LoadCharacter(arg0_16, arg1_16)
	arg0_16:UnloadCharacter()
	arg0_16:GetPoolMgr():GetCommanderModel(arg1_16, function(arg0_17)
		arg0_16.role = arg0_17

		pg.ViewUtils.SetLayer(arg0_16.role.transform, Layer.Character3D)
		setParent(arg0_16.role, arg0_16.roleContainer)

		arg0_16.role.transform.eulerAngles = Vector3(0, 180, 0)

		local var0_17 = (1.77777777777778 - Screen.width / Screen.height) * 0.5
		local var1_17 = 0.9

		IslandCameraMgr.instance:CinemachineComposerTrackObjOffset(arg0_16:GetActiveCamName(), Vector3(var1_17 - var0_17, 1, 0))

		arg0_16.role.transform.localPosition = Vector3(0, 0, 0)

		local var2_17 = arg0_16:GetSmoothRotateObject()
		local var3_17 = GetOrAddComponent(var2_17, typeof(SmoothRotateObject))

		var3_17:SetUp(arg0_16.role.transform)

		var3_17.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_16:OnCharLoaded()
		GetOrAddComponent(arg0_16.role, typeof(CharacterFootprintMgr)):SetSpawnMode(1)
	end)
end

function var0_0.UnloadCharacter(arg0_18)
	local var0_18 = arg0_18:GetSmoothRotateObject():GetComponent(typeof(SmoothRotateObject))

	if var0_18 then
		Object.Destroy(var0_18)
	end

	if arg0_18.role then
		arg0_18:GetPoolMgr():ReturnCommanderModel(arg0_18.role)

		arg0_18.role = nil
	end
end

function var0_0.Hide(arg0_19)
	var0_0.super.Hide(arg0_19)
end

function var0_0.OnDestroy(arg0_20)
	arg0_20:ClearCharacterScene()

	for iter0_20, iter1_20 in pairs(arg0_20.cards or {}) do
		iter1_20:Dispose()
	end

	arg0_20.cards = nil
end

return var0_0

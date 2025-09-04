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

function var0_0.ClearCharacterScene(arg0_10, arg1_10)
	if arg0_10.isLoadCharacterScene then
		arg0_10:UnLoadCharacterScene(arg1_10)
		arg0_10:ClearCharacterContainer()
		arg0_10:ResetCameraMask()
		arg0_10:ActivityPlayerCamera()
	end

	arg0_10.isLoadCharacterScene = false
end

function var0_0.OnHome(arg0_11)
	arg0_11:ClearCharacterScene(function()
		arg0_11:emit(BaseUI.ON_HOME)
	end)
end

function var0_0.LoadCharacter(arg0_13, arg1_13, arg2_13)
	arg0_13:UnloadCharacter()

	arg0_13.isCommander = arg2_13
	arg0_13.modelData = arg1_13

	local function var0_13(arg0_14)
		arg0_13.role = arg0_14

		pg.ViewUtils.SetLayer(arg0_13.role.transform, Layer.Character3D)
		setParent(arg0_13.role, arg0_13.roleContainer)

		arg0_13.role.transform.eulerAngles = Vector3(0, 180, 0)

		local var0_14 = arg0_13:GetSmoothRotateObject()

		var0_14:SetUp(arg0_13.role.transform)

		var0_14.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_13:OnCharLoaded()
	end

	if arg0_13.isCommander then
		arg0_13:GetPoolMgr():GetCommanderModel(arg1_13, function(arg0_15)
			var0_13(arg0_15)
		end)
	else
		arg0_13:GetPoolMgr():GetCharacter(arg1_13.model, arg1_13.animator, function(arg0_16)
			var0_13(arg0_16)
		end)
	end
end

function var0_0.UnloadCharacter(arg0_17)
	local var0_17 = arg0_17:GetSmoothRotateObject()

	if var0_17 then
		Object.Destroy(var0_17)
	end

	if arg0_17.role then
		if arg0_17.isCommander then
			arg0_17:GetPoolMgr():ReturnCommanderModel(arg0_17.role)
		elseif arg0_17.modelData then
			arg0_17:GetPoolMgr():ReturnCharacter(arg0_17.modelData.model, arg0_17.modelData.animator, arg0_17.role)

			arg0_17.modelData = nil
		end

		arg0_17.role = nil
	end
end

function var0_0.ClearCharacterContainer(arg0_18)
	arg0_18:UnloadCharacter()

	if not IsNil(arg0_18.roleContainer) then
		Object.Destroy(arg0_18.roleContainer.gameObject)

		arg0_18.roleContainer = nil
	end
end

function var0_0.UnLoadCharacterScene(arg0_19, arg1_19)
	local var0_19 = "island/scenesres/scenes/character/map_shipmainui_scene"

	SceneOpMgr.Inst:UnloadSceneAsync(var0_19, "map_shipmainui", function()
		if arg1_19 then
			arg1_19()
		end
	end)
end

function var0_0.ResetCameraMask(arg0_21)
	if arg0_21.defaultCullingMask and IslandCameraMgr.instance then
		local var0_21 = IslandCameraMgr.instance._mainCamera

		LuaHelper.ResetCamCullingMask(var0_21, arg0_21.defaultCullingMask)
	end
end

function var0_0.ActivityPlayerCamera(arg0_22)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
end

function var0_0.Hide(arg0_23)
	var0_0.super.Hide(arg0_23)
	arg0_23:ClearCharacterScene()
end

function var0_0.OnDisable(arg0_24)
	arg0_24:ClearCharacterScene()
end

function var0_0.OnDestroy(arg0_25)
	arg0_25:ClearCharacterScene()

	for iter0_25, iter1_25 in pairs(arg0_25.cards or {}) do
		iter1_25:Dispose()
	end

	arg0_25.cards = nil
end

function var0_0.GetActiveCamName(arg0_26)
	return IslandConst.CHARA_CAMERA_NAME
end

function var0_0.GetSmoothRotateObject(arg0_27)
	assert(false, "Write me")
end

function var0_0.OnCharLoaded(arg0_28)
	return
end

return var0_0

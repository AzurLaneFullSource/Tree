local var0_0 = class("BaseSystem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg1_1
	arg0_1.scene = arg2_1
	arg0_1.context = arg0_1:WrapContext(arg2_1)
	arg0_1.bindings = {}
	arg0_1.isInitialized = false
end

function var0_0.WrapContext(arg0_2, arg1_2)
	return {
		GetModelRoot = function()
			return arg1_2:GetModelRoot()
		end,
		GetCurrentLadyEnv = function()
			return arg1_2:GetCurrentLadyEnv()
		end,
		GetLadyBaseZone = function(arg0_5)
			return arg1_2:GetLadyBaseZone(arg0_5)
		end,
		GetSceneItem = function(arg0_6)
			return arg1_2:GetSceneItem(arg0_6)
		end,
		GetFurnitureSlotRoot = function()
			return arg1_2.slotRoot
		end,
		GetZoneByName = function(arg0_8)
			return arg1_2:GetZoneByName(arg0_8)
		end,
		GetIKPointByName = function(arg0_9)
			return arg1_2:GetIKPointByName(arg0_9)
		end,
		GetLoader = function()
			return arg1_2.loader
		end,
		GetRoom = function()
			return arg1_2.room
		end,
		GetTimeIndex = function()
			return arg1_2.contextData and arg1_2.contextData.timeIndex
		end,
		CheckSceneItemActive = function(arg0_13)
			if arg1_2.CheckSceneItemActive then
				return arg1_2:CheckSceneItemActive(arg0_13)
			end

			return true
		end,
		IsModeInHidePending = function(arg0_14)
			if arg1_2.IsModeInHidePending then
				return arg1_2:IsModeInHidePending(arg0_14)
			end

			return false
		end,
		GetIsInFurnitureSelect = function()
			return arg1_2.isInFurnitureSelect
		end,
		GetSceneRaycaster = function()
			return arg1_2.sceneRaycaster
		end,
		GetPlayer = function()
			return arg1_2.player
		end,
		GetLadyDict = function()
			return arg1_2.ladyDict
		end,
		GetSkinDict = function()
			return arg1_2.skinDict
		end,
		GetMainCameraTF = function()
			return arg1_2.mainCameraTF
		end,
		GetPosConfigRoot = function()
			return arg1_2.posConfigRoot
		end,
		GetCameraRoot = function()
			return arg1_2.cameraRoot
		end,
		GetApartment = function()
			return arg1_2.apartment
		end,
		GetUIState = function()
			return arg1_2.uiState
		end,
		GetCamBrain = function()
			return arg1_2.camBrain
		end,
		GetCameras = function()
			return arg1_2.cameras
		end,
		GetRaycastCamera = function()
			return arg1_2.raycastCamera
		end,
		GetNowTimelinePlayer = function()
			return arg1_2.nowTimelinePlayer
		end,
		_raw = arg1_2
	}
end

function var0_0.Init(arg0_29)
	if arg0_29.isInitialized then
		warning(arg0_29.__cname .. " already initialized")

		return
	end

	arg0_29.isInitialized = true

	arg0_29:OnInit()
	arg0_29:RegisterEvents()
end

function var0_0.OnInit(arg0_30)
	return
end

function var0_0.RegisterEvents(arg0_31)
	return
end

function var0_0.Emit(arg0_32, arg1_32, ...)
	arg0_32.event:emit(arg1_32, ...)
end

function var0_0.Bind(arg0_33, arg1_33, arg2_33)
	arg0_33.bindings[arg1_33] = arg0_33.bindings[arg1_33] or {}

	table.insert(arg0_33.bindings[arg1_33], arg2_33)
	arg0_33.event:connect(arg1_33, arg2_33)
end

function var0_0.Unbind(arg0_34, arg1_34)
	local var0_34 = arg0_34.bindings[arg1_34]

	if not var0_34 then
		return
	end

	for iter0_34, iter1_34 in ipairs(var0_34) do
		arg0_34.event:disconnect(arg1_34, iter1_34)
	end

	arg0_34.bindings[arg1_34] = nil
end

function var0_0.UnbindAll(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.bindings) do
		arg0_35:Unbind(iter0_35)
	end

	arg0_35.bindings = {}
end

function var0_0.Update(arg0_36, arg1_36)
	if not arg0_36.isInitialized then
		return
	end

	arg0_36:OnUpdate(arg1_36)
end

function var0_0.OnUpdate(arg0_37, arg1_37)
	return
end

function var0_0.LateUpdate(arg0_38, arg1_38)
	if not arg0_38.isInitialized then
		return
	end

	arg0_38:OnLateUpdate(arg1_38)
end

function var0_0.OnLateUpdate(arg0_39, arg1_39)
	return
end

function var0_0.HandleNotification(arg0_40, arg1_40, arg2_40)
	if not arg0_40.isInitialized then
		return
	end

	arg0_40:OnHandleNotification(arg1_40, arg2_40)
end

function var0_0.OnHandleNotification(arg0_41, arg1_41, arg2_41)
	return
end

function var0_0.GetInterests()
	return {}
end

function var0_0.Func(arg0_43, arg1_43, ...)
	if not arg0_43.isInitialized then
		return nil
	end

	local var0_43 = arg0_43.scene

	if not var0_43 then
		warning("Scene is nil")

		return nil
	end

	local var1_43 = var0_43[arg1_43]

	if not var1_43 then
		warning("Method " .. arg1_43 .. " not found in scene")

		return nil
	end

	return var1_43(var0_43, ...)
end

function var0_0.Get(arg0_44, arg1_44)
	if not arg0_44.isInitialized then
		return nil
	end

	return arg0_44.scene[arg1_44]
end

function var0_0.GetModelRoot(arg0_45)
	return arg0_45.context.GetModelRoot()
end

function var0_0.GetCurrentLadyEnv(arg0_46)
	return arg0_46.context.GetCurrentLadyEnv()
end

function var0_0.GetLadyBaseZone(arg0_47, arg1_47)
	return arg0_47.context.GetLadyBaseZone(arg1_47)
end

function var0_0.GetSceneItem(arg0_48, arg1_48)
	return arg0_48.context.GetSceneItem(arg1_48)
end

function var0_0.GetFurnitureSlotRoot(arg0_49)
	return arg0_49.context.GetFurnitureSlotRoot()
end

function var0_0.GetZoneByName(arg0_50, arg1_50)
	return arg0_50.context.GetZoneByName(arg1_50)
end

function var0_0.GetIKPointByName(arg0_51, arg1_51)
	return arg0_51.context.GetIKPointByName(arg1_51)
end

function var0_0.GetLoader(arg0_52)
	return arg0_52.context.GetLoader()
end

function var0_0.GetRoom(arg0_53)
	return arg0_53.context.GetRoom()
end

function var0_0.GetTimeIndex(arg0_54)
	return arg0_54.context.GetTimeIndex()
end

function var0_0.CheckSceneItemActive(arg0_55, arg1_55)
	return arg0_55.context.CheckSceneItemActive(arg1_55)
end

function var0_0.IsModeInHidePending(arg0_56, arg1_56)
	return arg0_56.context.IsModeInHidePending(arg1_56)
end

function var0_0.GetIsInFurnitureSelect(arg0_57)
	return arg0_57.context.GetIsInFurnitureSelect()
end

function var0_0.GetSceneRaycaster(arg0_58)
	return arg0_58.context.GetSceneRaycaster()
end

function var0_0.GetPlayer(arg0_59)
	return arg0_59.context.GetPlayer()
end

function var0_0.GetLadyDict(arg0_60)
	return arg0_60.context.GetLadyDict()
end

function var0_0.GetSkinDict(arg0_61)
	return arg0_61.context.GetSkinDict()
end

function var0_0.GetMainCameraTF(arg0_62)
	return arg0_62.context.GetMainCameraTF()
end

function var0_0.GetPosConfigRoot(arg0_63)
	return arg0_63.context.GetPosConfigRoot()
end

function var0_0.GetCameraRoot(arg0_64)
	return arg0_64.context.GetCameraRoot()
end

function var0_0.GetApartment(arg0_65)
	return arg0_65.context.GetApartment()
end

function var0_0.GetUIState(arg0_66)
	return arg0_66.context.GetUIState()
end

function var0_0.GetCamBrain(arg0_67)
	return arg0_67.context.GetCamBrain()
end

function var0_0.GetCameras(arg0_68)
	return arg0_68.context.GetCameras()
end

function var0_0.GetRaycastCamera(arg0_69)
	return arg0_69.context.GetRaycastCamera()
end

function var0_0.GetNowTimelinePlayer(arg0_70)
	return arg0_70.context.GetNowTimelinePlayer()
end

function var0_0.IsOpen()
	return true
end

function var0_0.GetName(arg0_72)
	return arg0_72.__cname or "BaseSystem"
end

function var0_0.Dispose(arg0_73)
	arg0_73:OnDispose()
	arg0_73:UnbindAll()

	arg0_73.event = nil
	arg0_73.context = nil
	arg0_73.scene = nil
	arg0_73.isInitialized = false
end

function var0_0.OnDispose(arg0_74)
	return
end

return var0_0

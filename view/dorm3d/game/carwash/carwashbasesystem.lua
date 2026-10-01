local var0_0 = class("CarWashBaseSystem", import("view.dorm3d.Core.BaseSystem"))

function var0_0.WrapContext(arg0_1, arg1_1)
	return {
		_raw = arg1_1,
		GetMainCameraTF = function()
			return arg1_1.mainCameraTF
		end,
		GetMainCamera = function()
			return arg1_1.mainCamera
		end,
		GetCameraRoot = function()
			return arg1_1.cameraRoot
		end,
		GetRaycaster = function()
			return arg1_1.sceneRaycaster
		end,
		GetLadyGO = function()
			return arg1_1.ladyGO
		end,
		GetGameConfig = function()
			return arg1_1.contextData.gameConfig
		end,
		GetContextData = function()
			return arg1_1.contextData
		end,
		GetLoader = function()
			return arg1_1.loader
		end,
		GetHxHelper = function()
			return arg1_1.hxHelper
		end,
		GetHolyLightRoot = function()
			return arg1_1.holyLightRoot
		end
	}
end

function var0_0.GetMainCameraTF(arg0_12)
	return arg0_12.context:GetMainCameraTF()
end

function var0_0.GetMainCamera(arg0_13)
	return arg0_13.context:GetMainCamera()
end

function var0_0.GetCameraRoot(arg0_14)
	return arg0_14.context:GetCameraRoot()
end

function var0_0.GetRaycaster(arg0_15)
	return arg0_15.context:GetRaycaster()
end

function var0_0.GetLadyGO(arg0_16)
	return arg0_16.context:GetLadyGO()
end

function var0_0.GetGameConfig(arg0_17)
	return arg0_17.context:GetGameConfig()
end

function var0_0.GetContextData(arg0_18)
	return arg0_18.context:GetContextData()
end

function var0_0.GetLoader(arg0_19)
	return arg0_19.context:GetLoader()
end

function var0_0.GetHxHelper(arg0_20)
	return arg0_20.context:GetHxHelper()
end

function var0_0.GetHolyLightRoot(arg0_21)
	return arg0_21.context:GetHolyLightRoot()
end

return var0_0

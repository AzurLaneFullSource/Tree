local var0_0 = class("CarWashBaseSystem", import("view.dorm3d.Extra.BaseExtraSystem"))

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
		end
	}
end

function var0_0.GetMainCameraTF(arg0_10)
	return arg0_10.context:GetMainCameraTF()
end

function var0_0.GetMainCamera(arg0_11)
	return arg0_11.context:GetMainCamera()
end

function var0_0.GetCameraRoot(arg0_12)
	return arg0_12.context:GetCameraRoot()
end

function var0_0.GetRaycaster(arg0_13)
	return arg0_13.context:GetRaycaster()
end

function var0_0.GetLadyGO(arg0_14)
	return arg0_14.context:GetLadyGO()
end

function var0_0.GetGameConfig(arg0_15)
	return arg0_15.context:GetGameConfig()
end

function var0_0.GetContextData(arg0_16)
	return arg0_16.context:GetContextData()
end

function var0_0.GetLoader(arg0_17)
	return arg0_17.context:GetLoader()
end

return var0_0

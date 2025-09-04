GraphApiHelper = {}

local var0_0 = GraphApiHelper

var0_0.SaveKey_Graphics_API = "Force_Graphics_API"
var0_0.Api = {
	Force_Vulkan = 1,
	Force_OpenGLES = 2
}

function var0_0.GetGraphApiSaveValue()
	return PlayerPrefs.GetInt(var0_0.SaveKey_Graphics_API, 0)
end

function var0_0.IsForceVulkan()
	return var0_0.GetGraphApiSaveValue() == var0_0.Api.Force_Vulkan
end

function var0_0.IsForceOpenGLES()
	return var0_0.GetGraphApiSaveValue() == var0_0.Api.Force_OpenGLES
end

function var0_0.SetForceGraphApi(arg0_4)
	if not table.contains(var0_0.Api, arg0_4) then
		arg0_4 = 0
	end

	warning("Set Graphi Api " .. arg0_4)
	PlayerPrefs.SetInt(var0_0.SaveKey_Graphics_API, arg0_4)
	PlayerPrefs.Save()
end

function var0_0.GetCurGraphApi()
	return tostring(SystemInfo.graphicsDeviceType)
end

function var0_0.IsUsingVulkan()
	local var0_6 = var0_0.GetCurGraphApi()

	return string.find(string.lower(var0_6), "vulkan")
end

return var0_0

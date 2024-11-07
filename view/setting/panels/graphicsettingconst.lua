GraphicSettingConst = {}

local var0_0 = GraphicSettingConst
local var1_0 = {
	toggle = 1,
	select = 2
}

var0_0.assetPath = {
	"Default_LowQualitySettings",
	"Default_MediumQualitySettings",
	"Default_HighQualitySettings",
	"Default_QualitySettings"
}
var0_0.settings = {
	{
		CsharpValue = "enableGPUDriver",
		playerPrefsname = "allowGpGpu",
		cfgId = 1,
		tips = i18n("grapihcs3d_setting_gpgpu_warning")
	},
	{
		CsharpValue = "enableHighRenderingQuality",
		playerPrefsname = "enableHighRenderingQuality",
		cfgId = 2
	},
	{
		CsharpValue = "depthRenderingMode",
		playerPrefsname = "depthRenderingMode",
		cfgId = 3,
		EnumType = "RenderingMode",
		Enum = {
			Auto = 1,
			Enabled = 2
		}
	},
	{
		CsharpValue = "shaderQuality",
		playerPrefsname = "shaderQuality",
		cfgId = 4,
		EnumType = "Quality",
		Enum = {
			High = 3,
			Medium = 2,
			Low = 1
		}
	},
	{
		CsharpValue = "msaaSamples",
		playerPrefsname = "msaaSamples",
		cfgId = 5,
		EnumType = "MSAASamples",
		Enum = {
			None = 1,
			MSAA2x = 2,
			MSAA8x = 4,
			MSAA4x = 3
		}
	},
	{
		CsharpValue = "resolution",
		playerPrefsname = "maximumResolution",
		cfgId = 6,
		EnumType = "Resolution",
		Enum = {
			_900P = 2,
			_720P = 1,
			_1080P = 3,
			_2k = 4
		}
	},
	{
		CsharpValue = "staticResolution",
		playerPrefsname = "staticResolution",
		cfgId = 7,
		EnumType = "ResolutionSize",
		Enum = {
			_10 = 1,
			_60 = 6,
			Full = 10,
			_30 = 3,
			Half = 5,
			_40 = 4,
			_70 = 7,
			_90 = 9,
			_80 = 8,
			_20 = 2
		}
	},
	{
		CsharpValue = "staticMinResolution",
		playerPrefsname = "staticMinResolution",
		cfgId = 8,
		EnumType = "MinResolution",
		Enum = {
			_540P = 2,
			_720P = 3,
			_360P = 1
		}
	},
	{
		CsharpValue = "textureSize",
		playerPrefsname = "textureSize",
		cfgId = 9,
		EnumType = "TextureSize",
		Enum = {
			Half = 2,
			Full = 1,
			Eighth = 4,
			Quarter = 3
		}
	},
	{
		CsharpValue = "bakedShadowMode",
		playerPrefsname = "bakedShadowMode",
		cfgId = 10,
		EnumType = "BakedShadowMode",
		Enum = {
			StaticShadowMapSoft = 2,
			Shadowmask = 4,
			StaticShadowMapHard = 3,
			Disabled = 1
		}
	},
	{
		CsharpValue = "enableShadow",
		playerPrefsname = "enableShadow",
		cfgId = 11
	},
	{
		CsharpValue = "enableReflection",
		playerPrefsname = "enableReflection",
		cfgId = 12
	},
	{
		CsharpValue = "enableAddLights",
		playerPrefsname = "enableAddLights",
		cfgId = 13
	},
	{
		CsharpValue = "enableOutline",
		playerPrefsname = "enableOutline",
		cfgId = 14
	},
	{
		CsharpValue = "postProcessQuality",
		playerPrefsname = "postProcessQuality",
		cfgId = 15,
		EnumType = "PostQuality",
		Enum = {
			Off = 1,
			On = 2,
			HighQuality = 3
		},
		childList = {
			16,
			17,
			18,
			19
		}
	},
	{
		CsharpValue = "enablePostAntialiasing",
		playerPrefsname = "enablePostAntialiasing",
		parentSetting = "postProcessQuality",
		cfgId = 16
	},
	{
		CsharpValue = "enableHDR",
		playerPrefsname = "enableHDR",
		parentSetting = "postProcessQuality",
		cfgId = 17
	},
	{
		CsharpValue = "enableDOF",
		playerPrefsname = "enableDOF",
		parentSetting = "postProcessQuality",
		cfgId = 18
	},
	{
		CsharpValue = "enableDistort",
		playerPrefsname = "enableDistort",
		parentSetting = "postProcessQuality",
		cfgId = 19
	}
}

function var0_0.HandleCustomSetting()
	local var0_1 = PlayerPrefs.GetInt("dorm3d_graphics_settings", 2)
	local var1_1 = var0_0.assetPath[var0_1]
	local var2_1 = LoadAny("three3dquaitysettings/defaultsettings", var1_1)

	if var0_1 ~= 4 then
		return var2_1
	end

	for iter0_1, iter1_1 in ipairs(var0_0.settings) do
		local var3_1 = pg.dorm3d_graphic_setting[iter1_1.cfgId]
		local var4_1 = PlayerPrefs.GetInt(iter1_1.playerPrefsname, 0)

		if var4_1 ~= 0 then
			if var3_1.displayType == var1_0.toggle then
				var4_1 = var4_1 == 2 and true or false
			end
		else
			var4_1 = ReflectionHelp.RefGetField(var2_1:GetType(), iter1_1.CsharpValue, var2_1)
		end

		if var3_1.displayType == var1_0.select then
			if iter1_1.childList ~= nil and var4_1 == 1 then
				print(123)
			else
				for iter2_1, iter3_1 in pairs(iter1_1.Enum) do
					if iter3_1 == var4_1 then
						var4_1 = iter2_1

						break
					end
				end

				local var5_1 = ReflectionHelp.RefGetField(typeof("BLHX.Rendering." .. iter1_1.EnumType), tostring(var4_1), nil)

				ReflectionHelp.RefSetField(var2_1:GetType(), iter1_1.CsharpValue, var2_1, var5_1)
			end
		else
			ReflectionHelp.RefSetField(var2_1:GetType(), iter1_1.CsharpValue, var2_1, var4_1)
		end
	end

	return var2_1
end

return var0_0

GraphicSettingConst = {}

local var0_0 = GraphicSettingConst

var0_0.SettingType = {
	toggle = 1,
	select = 2
}
var0_0.SettingLevel = {
	High = 3,
	Mid = 2,
	Low = 1,
	Custom = 4
}
var0_0.assetPath = {
	"Default_LowQualitySettings",
	"Default_MediumQualitySettings",
	"Default_HighQualitySettings",
	"Default_QualitySettings"
}
var0_0.settings = {
	{
		tips = "grapihcs3d_setting_gpgpu_warning",
		settingType = 1,
		Cname = "EnableGPUDriver",
		playerPrefsname = "enableGPUDriver",
		settingName = "允许GPGPU",
		isShow = 1
	},
	{
		settingType = 2,
		Cname = "Resolution",
		playerPrefsname = "resolution",
		settingName = "最大分辨率",
		isShow = 1,
		optionNames = {
			"720p",
			"1080p",
			"2K"
		},
		options = {
			1280,
			1920,
			2560
		}
	},
	{
		settingType = 2,
		Cname = "RenderingQuality",
		playerPrefsname = "renderingQuality",
		settingName = "渲染精度",
		isShow = 1,
		optionNames = {
			"低",
			"高"
		},
		options = {
			0,
			1
		}
	},
	{
		settingType = 2,
		Cname = "ShaderQuality",
		playerPrefsname = "shaderQuality",
		settingName = "Shader级别",
		isShow = 1,
		optionNames = {
			"低",
			"高"
		},
		options = {
			0,
			1
		}
	},
	{
		settingType = 1,
		Cname = "EnableAdditionalLights",
		playerPrefsname = "enableAdditionalLights",
		settingName = "多光源",
		isShow = 1
	},
	{
		settingType = 2,
		Cname = "ShadowQuality",
		playerPrefsname = "shadowQuality",
		settingName = "阴影精度",
		isShow = 1,
		optionNames = {
			"关",
			"低",
			"中",
			"高"
		},
		options = {
			0,
			1,
			2,
			3
		}
	},
	{
		settingType = 2,
		Cname = "ShadowUpdateMode",
		playerPrefsname = "shadowUpdateMode",
		settingName = "阴影更新频率",
		isShow = 1,
		optionNames = {
			"低更新频率",
			"中更新频率",
			"高更新频率",
			"每帧更新"
		},
		options = {
			0,
			1,
			2,
			3
		}
	},
	{
		settingType = 1,
		Cname = "EnablePostProcess",
		playerPrefsname = "enablePostProcess",
		settingName = "后处理",
		isShow = 1
	},
	{
		settingType = 1,
		Cname = "EnableReflection",
		playerPrefsname = "enableReflection",
		settingName = "反射",
		isShow = 1
	},
	{
		parentId = 8,
		settingType = 1,
		Cname = "EnablePostAntialiasing",
		playerPrefsname = "enablePostAntialiasing",
		settingName = "抗锯齿",
		isShow = 1
	},
	{
		parentId = 8,
		settingType = 1,
		Cname = "EnableHDR",
		playerPrefsname = "enableHDR",
		settingName = "HDR",
		isShow = 1
	},
	{
		parentId = 8,
		settingType = 1,
		Cname = "EnableDof",
		playerPrefsname = "enableDOF",
		settingName = "景深",
		isShow = 1
	},
	{
		parentId = 8,
		settingType = 1,
		Cname = "EnableDistort",
		playerPrefsname = "enableDistort",
		settingName = "扭曲",
		isShow = 1
	},
	{
		settingType = 2,
		Cname = "CharacterQuality",
		playerPrefsname = "characterQuality",
		settingName = "角色精度",
		isShow = 1,
		optionNames = {
			"低",
			"中",
			"高"
		},
		options = {
			0,
			1,
			2
		}
	},
	{
		settingType = 2,
		Cname = "TerrainLayerQuality",
		playerPrefsname = "terrainLayerQuality",
		settingName = "地形精度",
		isShow = 1,
		optionNames = {
			"低",
			"中",
			"高"
		},
		options = {
			0,
			1,
			2
		}
	}
}

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_1 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_1 = SystemInfo.deviceModel or ""

			local function var2_1(arg0_2)
				local var0_2 = string.match(arg0_2, "iPad(%d+)")
				local var1_2 = tonumber(var0_2)

				if var1_2 and var1_2 >= 8 then
					return true
				end

				return false
			end

			local function var3_1(arg0_3)
				local var0_3 = string.match(arg0_3, "iPhone(%d+)")
				local var1_3 = tonumber(var0_3)

				if var1_3 and var1_3 >= 13 then
					return true
				end

				return false
			end

			if var2_1(var1_1) or var3_1(var1_1) then
				var0_1 = DevicePerformanceLevel.High
			end
		end

		local var4_1 = var0_1 == DevicePerformanceLevel.High and 3 or var0_1 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_1)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_1
	end
end

function var0_0.SettingQuality()
	local var0_4 = PlayerPrefs.GetInt("dorm3d_graphics_settings", 4)
	local var1_4 = var0_0.assetPath[var0_4]
	local var2_4 = LoadAny("three3dquaitysettings/defaultsettings", var1_4)

	if var0_4 ~= 4 then
		BLHX.Rendering.GlobalQualitySettings.SetOverrideQualitySettings(var2_4)

		return
	end

	for iter0_4, iter1_4 in ipairs(var0_0.settings) do
		local var3_4 = PlayerPrefs.GetInt(iter1_4.playerPrefsname, -1)

		if var3_4 ~= -1 then
			if iter1_4.settingType == var0_0.SettingType.toggle then
				var3_4 = var3_4 == 1 and true or false
			end

			var2_4[iter1_4.Cname] = var3_4
		end
	end

	BLHX.Rendering.GlobalQualitySettings.SetOverrideQualitySettings(var2_4)
end

function var0_0.ClearPlayerPrefs()
	for iter0_5, iter1_5 in ipairs(var0_0.settings) do
		PlayerPrefs.DeleteKey(iter1_5.playerPrefsname)
	end
end

return var0_0

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
		settingName = "grapihcs3d_setting_enable_gup_driver",
		isShow = 1
	},
	{
		settingType = 2,
		Cname = "Resolution",
		playerPrefsname = "resolution",
		settingName = "grapihcs3d_setting_resolution",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_resolution_optionname0",
			"grapihcs3d_setting_resolution_optionname1",
			"grapihcs3d_setting_resolution_optionname2"
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
		settingName = "grapihcs3d_setting_rendering_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_rendering_quality_optionname0",
			"grapihcs3d_setting_rendering_quality_optionname1"
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
		settingName = "grapihcs3d_setting_shader_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_shader_quality_optionname0",
			"grapihcs3d_setting_shader_quality_optionname1"
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
		settingName = "grapihcs3d_setting_enable_additional_lights",
		isShow = 1
	},
	{
		settingType = 2,
		Cname = "ShadowQuality",
		playerPrefsname = "shadowQuality",
		settingName = "grapihcs3d_setting_shadow_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_shadow_quality_optionname0",
			"grapihcs3d_setting_shadow_quality_optionname1",
			"grapihcs3d_setting_shadow_quality_optionname2",
			"grapihcs3d_setting_shadow_quality_optionname3"
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
		settingName = "grapihcs3d_setting_shadow_update_mode",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_shadow_update_mode_optionname0",
			"grapihcs3d_setting_shadow_update_mode_optionname1",
			"grapihcs3d_setting_shadow_update_mode_optionname2",
			"grapihcs3d_setting_shadow_update_mode_optionname3"
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
		Cname = "TerrainLayerQuality",
		playerPrefsname = "terrainLayerQuality",
		settingName = "grapihcs3d_setting_terrain_layer_quality",
		isShow = 0,
		optionNames = {
			"grapihcs3d_setting_terrain_layer_quality_optionname0",
			"grapihcs3d_setting_terrain_layer_quality_optionname1",
			"grapihcs3d_setting_terrain_layer_quality_optionname2"
		},
		options = {
			0,
			1,
			2
		}
	},
	{
		settingType = 2,
		Cname = "CharacterQuality",
		playerPrefsname = "characterQuality",
		settingName = "grapihcs3d_setting_character_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_character_quality_optionname0",
			"grapihcs3d_setting_character_quality_optionname1",
			"grapihcs3d_setting_character_quality_optionname2"
		},
		options = {
			0,
			1,
			2
		}
	},
	{
		settingType = 1,
		Cname = "EnableReflection",
		playerPrefsname = "enableReflection",
		settingName = "grapihcs3d_setting_enable_reflection",
		isShow = 1
	},
	{
		settingType = 1,
		Cname = "EnablePostProcess",
		playerPrefsname = "enablePostProcess",
		settingName = "grapihcs3d_setting_enable_post_process",
		isShow = 1
	},
	{
		parentId = 11,
		settingType = 1,
		Cname = "EnablePostAntialiasing",
		playerPrefsname = "enablePostAntialiasing",
		settingName = "grapihcs3d_setting_enable_post_antialiasing",
		isShow = 1
	},
	{
		parentId = 11,
		settingType = 1,
		Cname = "EnableHDR",
		playerPrefsname = "enableHDR",
		settingName = "grapihcs3d_setting_enable_hdr",
		isShow = 1
	},
	{
		parentId = 11,
		settingType = 1,
		Cname = "EnableDof",
		playerPrefsname = "enableDOF",
		settingName = "grapihcs3d_setting_enable_dof",
		isShow = 1
	},
	{
		parentId = 11,
		settingType = 1,
		Cname = "EnableDistort",
		playerPrefsname = "enableDistort",
		settingName = "grapihcs3d_setting_enable_distort",
		isShow = 1
	}
}
var0_0.volumeSettings = {
	{
		parentId = 11,
		settingType = 2,
		playerPrefsname = "volume_bloom_intensity",
		settingName = "grapihcs3d_setting_bloom",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_bloom_optionname0",
			"grapihcs3d_setting_bloom_optionname1"
		},
		options = {
			0,
			1
		},
		OnSetting = function()
			tolua.loadassembly("Yongshi.BLHotUpdate.Runtime.Rendering")
			ReflectionHelp.RefCallStaticMethod(typeof("BLHX.Rendering.HotUpdate.BloomIntensity"), "SetEnabled", {
				typeof("System.Boolean")
			}, {
				PlayerPrefs.GetInt("volume_bloom_intensity", 0) == 1
			})
		end
	}
}
var0_0.TYPE_GLOBAL_QUALITY = 1
var0_0.TYPE_VOLUME = 2

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings_new", 0) == 0 then
		local var0_2 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_2 = SystemInfo.deviceModel or ""

			local function var2_2(arg0_3)
				local var0_3 = string.match(arg0_3, "iPad(%d+)")
				local var1_3 = tonumber(var0_3)

				if var1_3 and var1_3 >= 8 then
					return true
				end

				return false
			end

			local function var3_2(arg0_4)
				local var0_4 = string.match(arg0_4, "iPhone(%d+)")
				local var1_4 = tonumber(var0_4)

				if var1_4 and var1_4 >= 13 then
					return true
				end

				return false
			end

			if var2_2(var1_2) or var3_2(var1_2) then
				var0_2 = DevicePerformanceLevel.High
			end
		end

		local var4_2 = var0_2 == DevicePerformanceLevel.High and 3 or var0_2 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings_new", var4_2)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_2
	end
end

function var0_0.SettingQuality()
	local var0_5 = PlayerPrefs.GetInt("dorm3d_graphics_settings_new", 4)
	local var1_5 = var0_0.assetPath[var0_5]
	local var2_5 = LoadAny("three3dquaitysettings/defaultsettings", var1_5)

	if var0_5 ~= 4 then
		BLHX.Rendering.GlobalQualitySettings.SetOverrideQualitySettings(var2_5)
	else
		for iter0_5, iter1_5 in ipairs(var0_0.settings) do
			local var3_5 = PlayerPrefs.GetInt(iter1_5.playerPrefsname, -1)

			if var3_5 ~= -1 then
				if iter1_5.settingType == var0_0.SettingType.toggle then
					var3_5 = var3_5 == 1 and true or false
				end

				var2_5[iter1_5.Cname] = var3_5
			end
		end

		BLHX.Rendering.GlobalQualitySettings.SetOverrideQualitySettings(var2_5)
	end

	_.each(var0_0.volumeSettings, function(arg0_6)
		arg0_6.OnSetting()
	end)
end

function var0_0.ClearPlayerPrefs()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings_changeed", 0) == 1 then
		return
	end

	PlayerPrefs.SetInt("dorm3d_graphics_settings_changeed", 1)

	for iter0_7, iter1_7 in ipairs(var0_0.settings) do
		PlayerPrefs.DeleteKey(iter1_7.playerPrefsname)
	end
end

return var0_0

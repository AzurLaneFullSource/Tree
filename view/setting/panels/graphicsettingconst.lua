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
		playerPrefsname = "enableGPUDriver",
		settingType = 1,
		parameterId = 0,
		settingName = "grapihcs3d_setting_enable_gup_driver",
		isShow = 1,
		defaultValues = {
			0,
			0,
			1,
			0
		}
	},
	{
		parameterId = 3,
		settingType = 2,
		playerPrefsname = "gameOptions",
		settingName = "grapihcs3d_setting_global_illumination",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_global_illumination_optionname0",
			"grapihcs3d_setting_global_illumination_optionname1",
			"grapihcs3d_setting_global_illumination_optionname2",
			"grapihcs3d_setting_global_illumination_optionname3"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			2,
			2,
			2,
			2
		}
	},
	{
		parameterId = 12,
		settingType = 2,
		playerPrefsname = "bloomIntensity",
		settingName = "grapihcs3d_setting_bloom_intensity",
		isShow = 0,
		optionNames = {
			"grapihcs3d_setting_bloom_intensity_0",
			"grapihcs3d_setting_bloom_intensity_1",
			"grapihcs3d_setting_bloom_intensity_2",
			"grapihcs3d_setting_bloom_intensity_3"
		},
		options = {
			0,
			1,
			2,
			3
		},
		defaultValues = {
			3,
			3,
			3,
			3
		}
	},
	{
		parameterId = 2,
		settingType = 2,
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
		},
		defaultValues = {
			1280,
			1920,
			2560,
			1920
		}
	},
	{
		parameterId = 1,
		settingType = 2,
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
		},
		defaultValues = {
			0,
			0,
			0,
			0
		}
	},
	{
		parameterId = 4,
		settingType = 2,
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
		},
		defaultValues = {
			0,
			1,
			1,
			1
		}
	},
	{
		parameterId = 5,
		settingType = 1,
		playerPrefsname = "enableAdditionalLights",
		settingName = "grapihcs3d_setting_enable_additional_lights",
		isShow = 1,
		defaultValues = {
			0,
			1,
			1,
			1
		}
	},
	{
		parameterId = 6,
		settingType = 2,
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
		},
		defaultValues = {
			0,
			2,
			3,
			2
		}
	},
	{
		parameterId = 7,
		settingType = 2,
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
		},
		defaultValues = {
			0,
			2,
			2,
			2
		}
	},
	{
		parameterId = 21,
		settingType = 2,
		playerPrefsname = "lodQuality",
		settingName = "Lod",
		isShow = 0,
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
		},
		defaultValues = {
			3,
			3,
			3,
			3
		}
	},
	{
		parameterId = 18,
		settingType = 1,
		playerPrefsname = "enableAO",
		settingName = "AO",
		isShow = 0,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 9,
		settingType = 1,
		playerPrefsname = "enablePostProcess",
		settingName = "grapihcs3d_setting_enable_post_process",
		isShow = 1,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 8,
		settingType = 1,
		playerPrefsname = "enableReflection",
		settingName = "grapihcs3d_setting_enable_reflection",
		isShow = 1,
		defaultValues = {
			0,
			1,
			1,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 10,
		settingType = 1,
		playerPrefsname = "enablePostAntialiasing",
		settingName = "grapihcs3d_setting_enable_post_antialiasing",
		isShow = 1,
		defaultValues = {
			0,
			0,
			0,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 11,
		settingType = 1,
		playerPrefsname = "enableHDR",
		settingName = "grapihcs3d_setting_enable_hdr",
		isShow = 1,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 13,
		settingType = 1,
		playerPrefsname = "enableDOF",
		settingName = "grapihcs3d_setting_enable_dof",
		isShow = 1,
		defaultValues = {
			0,
			0,
			1,
			1
		}
	},
	{
		parentId = 12,
		parameterId = 14,
		settingType = 1,
		playerPrefsname = "enableDistort",
		settingName = "grapihcs3d_setting_enable_distort",
		isShow = 1,
		defaultValues = {
			0,
			0,
			1,
			1
		}
	},
	{
		parameterId = 15,
		settingType = 1,
		playerPrefsname = "enableFog",
		settingName = "雾",
		isShow = 0,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 16,
		settingType = 1,
		playerPrefsname = "enableFlare",
		settingName = "grapihcs3d_setting_flare",
		isShow = 1,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 17,
		settingType = 1,
		playerPrefsname = "enableLensFlare",
		settingName = "镜头炫光",
		isShow = 0,
		defaultValues = {
			1,
			1,
			1,
			1
		}
	},
	{
		parameterId = 19,
		settingType = 2,
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
		},
		defaultValues = {
			0,
			1,
			2,
			1
		}
	},
	{
		parameterId = 20,
		settingType = 2,
		playerPrefsname = "terrainLayerQuality",
		settingName = "grapihcs3d_setting_terrain_layer_quality",
		isShow = 1,
		optionNames = {
			"grapihcs3d_setting_terrain_layer_quality_optionname0",
			"grapihcs3d_setting_terrain_layer_quality_optionname1",
			"grapihcs3d_setting_terrain_layer_quality_optionname2"
		},
		options = {
			0,
			1,
			2
		},
		defaultValues = {
			0,
			1,
			2,
			1
		}
	}
}

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings_new", 0) == 0 then
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

		PlayerPrefs.SetInt("dorm3d_graphics_settings_new", var4_1)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_1
	end
end

function var0_0.SettingQuality()
	local var0_4 = PlayerPrefs.GetInt("dorm3d_graphics_settings_new", 4)

	if var0_4 ~= 4 then
		for iter0_4, iter1_4 in ipairs(var0_0.settings) do
			local var1_4 = iter1_4.parameterId
			local var2_4 = iter1_4.defaultValues[var0_4]

			GraphicsInterface.Instance:SetQualitySettings(var1_4, var2_4)
		end

		return
	end

	for iter2_4, iter3_4 in ipairs(var0_0.settings) do
		local var3_4 = iter3_4.parameterId
		local var4_4 = PlayerPrefs.GetInt(iter3_4.playerPrefsname, -1)
		local var5_4 = iter3_4.defaultValues[4]

		if var4_4 ~= -1 then
			var5_4 = var4_4
		end

		GraphicsInterface.Instance:SetQualitySettings(var3_4, var5_4)
	end
end

function var0_0.ClearPlayerPrefs()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings_changeed", 0) == 1 then
		return
	end

	PlayerPrefs.SetInt("dorm3d_graphics_settings_changeed", 1)

	for iter0_5, iter1_5 in ipairs(var0_0.settings) do
		PlayerPrefs.DeleteKey(iter1_5.playerPrefsname)
	end
end

return var0_0

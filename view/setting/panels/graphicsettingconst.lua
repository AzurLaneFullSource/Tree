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
	if PlayerPrefs.GetInt("dorm3d_graphics_settings_changeed", 0) == 1 then
		return
	end

	PlayerPrefs.SetInt("dorm3d_graphics_settings_changeed", 1)

	for iter0_5, iter1_5 in ipairs(var0_0.settings) do
		PlayerPrefs.DeleteKey(iter1_5.playerPrefsname)
	end
end

return var0_0

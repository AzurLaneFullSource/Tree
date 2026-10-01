local var0_0 = class("Dorm3dLightingSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.APPLY_DAY_NIGHT = "Dorm3dLightingSystem.APPLY_DAY_NIGHT"
var0_0.SET_CAMERA_SETTINGS = "Dorm3dLightingSystem.SET_CAMERA_SETTINGS"
var0_0.REVERT_CAMERA_SETTINGS = "Dorm3dLightingSystem.REVERT_CAMERA_SETTINGS"
var0_0.SET_VOLUME_PROFILE = "Dorm3dLightingSystem.SET_VOLUME_PROFILE"
var0_0.REVERT_VOLUME_PROFILE = "Dorm3dLightingSystem.REVERT_VOLUME_PROFILE"
var0_0.REVERT_CHARACTER_LIGHT = "Dorm3dLightingSystem.REVERT_CHARACTER_LIGHT"

function var0_0.OnInit(arg0_1)
	local var0_1 = GameObject.Find("[MainBlock]")

	assert(var0_1, "Dorm3dLightingSystem requires [MainBlock]")

	arg0_1.daynightCtrlComp = var0_1:GetComponent("DayNightCtrl")
	arg0_1.volumeRequest = nil
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.APPLY_DAY_NIGHT, function(arg0_3, arg1_3)
		arg0_2:ApplyDayNight(arg1_3)
	end)
	arg0_2:Bind(var0_0.SET_CAMERA_SETTINGS, function(arg0_4, arg1_4)
		arg0_2:SettingCamera(arg1_4)
	end)
	arg0_2:Bind(var0_0.REVERT_CAMERA_SETTINGS, function()
		arg0_2:RevertCameraSettings()
	end)
	arg0_2:Bind(var0_0.SET_VOLUME_PROFILE, function(arg0_6, arg1_6, arg2_6)
		arg0_2:SetVolumeProfile(arg1_6, arg2_6)
	end)
	arg0_2:Bind(var0_0.REVERT_VOLUME_PROFILE, function()
		arg0_2:RevertVolumeProfile()
	end)
	arg0_2:Bind(var0_0.REVERT_CHARACTER_LIGHT, function()
		arg0_2:RevertCharacterLight()
	end)
	arg0_2:Bind(Dorm3dRoomTemplateScene.ART_SCENE_WILL_CHANGE, function()
		arg0_2:RevertVolumeProfile()

		arg0_2.daynightCtrlComp = nil
	end)
	arg0_2:Bind(Dorm3dRoomTemplateScene.ART_SCENE_CHANGED, function()
		arg0_2:RefreshArtSceneRefs()
		arg0_2:ApplyDayNight(arg0_2:GetTimeIndex())
	end)
end

function var0_0.RefreshArtSceneRefs(arg0_11)
	local var0_11 = GameObject.Find("[MainBlock]")

	assert(var0_11, "Dorm3dLightingSystem requires [MainBlock]")

	arg0_11.daynightCtrlComp = var0_11:GetComponent("DayNightCtrl")
end

function var0_0.ApplyDayNight(arg0_12, arg1_12)
	if not IsNil(arg0_12.daynightCtrlComp) then
		arg0_12.daynightCtrlComp:SwitcherToIndex(arg1_12 - 1)
	end

	arg0_12:RefreshLightSettings()
end

function var0_0.FindGlobalVolume(arg0_13)
	local var0_13 = GameObject.Find("GlobalVolume")

	assert(var0_13, "Dorm3dLightingSystem requires GlobalVolume")

	return var0_13
end

function var0_0.FindCharacterLight(arg0_14)
	local var0_14 = GameObject.Find("CharacterLight")

	assert(var0_14, "Dorm3dLightingSystem requires CharacterLight")

	return var0_14
end

function var0_0.FindLightingRoot(arg0_15)
	local var0_15 = GameObject.Find("[Lighting]")

	assert(var0_15, "Dorm3dLightingSystem requires [Lighting]")

	return var0_15.transform
end

function var0_0.RefreshLightSettings(arg0_16)
	local var0_16 = arg0_16:FindGlobalVolume()

	arg0_16:RegisterGlobalVolume(var0_16)

	local var1_16 = arg0_16:FindCharacterLight()

	arg0_16:RecordCharacterLight(var1_16)

	local var2_16 = arg0_16:FindLightingRoot()

	table.IpairsCArray(var2_16:GetComponentsInChildren(typeof(Light), true), function(arg0_17, arg1_17)
		arg1_17.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.RegisterGlobalVolume(arg0_18, arg1_18)
	local var0_18 = GraphicsInterface.Instance.GetOrAddVolumeComponent(arg1_18, typeof(BLHX.Rendering.CustomDepthOfField))
	local var1_18 = GraphicsInterface.Instance.GetOrAddVolumeComponent(arg1_18, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	arg0_18.originalCameraSettings = {
		depthOfField = {
			enabled = var0_18.enabled.value,
			focusDistance = {
				length = 2,
				min = var0_18.gaussianStart.min,
				value = var0_18.gaussianStart.value
			},
			blurRadius = {
				min = var0_18.blurRadius.min,
				max = var0_18.blurRadius.max,
				value = var0_18.blurRadius.value
			}
		},
		postExposure = {
			value = var1_18.postExposure.value
		},
		contrast = {
			min = var1_18.contrast.min,
			max = var1_18.contrast.max,
			value = var1_18.contrast.value
		},
		saturate = {
			min = var1_18.saturation.min,
			max = var1_18.saturation.max,
			value = var1_18.saturation.value
		}
	}
	arg0_18.originalCameraSettings.depthOfField.enabled = true
end

function var0_0.GetCameraSettings(arg0_19)
	return arg0_19.originalCameraSettings
end

function var0_0.SettingCamera(arg0_20, arg1_20)
	arg0_20.activeCameraSettings = arg1_20

	local var0_20 = arg0_20:FindGlobalVolume()
	local var1_20 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_20, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_20 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_20, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	var1_20.enabled:Override(arg1_20.depthOfField.enabled)
	var1_20.gaussianStart:Override(arg1_20.depthOfField.focusDistance.value)
	var1_20.gaussianEnd:Override(arg1_20.depthOfField.focusDistance.value + arg1_20.depthOfField.focusDistance.length)
	var1_20.blurRadius:Override(arg1_20.depthOfField.blurRadius.value)
	var2_20.postExposure:Override(arg1_20.postExposure.value)
	var2_20.contrast:Override(arg1_20.contrast.value)
	var2_20.saturation:Override(arg1_20.saturate.value)
end

function var0_0.RevertCameraSettings(arg0_21)
	arg0_21:SettingCamera(arg0_21.originalCameraSettings)

	arg0_21.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_22, arg1_22, arg2_22)
	if arg0_22.cameraVolume then
		arg0_22:RevertVolumeProfile()
	end

	local var0_22 = {}

	arg0_22.volumeRequest = var0_22

	arg0_22:GetLoader():GetPrefab("dorm3d/effect/volume/" .. arg1_22, "", function(arg0_23)
		if arg0_22.volumeRequest ~= var0_22 then
			arg0_22:GetLoader():ReturnPrefab(arg0_23)

			return
		end

		arg0_22.cameraVolume = arg0_23
	end)
end

function var0_0.RevertVolumeProfile(arg0_24)
	arg0_24.volumeRequest = nil

	if arg0_24.cameraVolume then
		arg0_24:GetLoader():ReturnPrefab(arg0_24.cameraVolume)

		arg0_24.cameraVolume = nil
	end
end

function var0_0.OnDispose(arg0_25)
	arg0_25:RevertVolumeProfile()
end

function var0_0.RecordCharacterLight(arg0_26, arg1_26)
	tolua.loadassembly("Yongshi.BLRP.Runtime.AOT")

	local var0_26 = arg1_26:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	arg0_26.originalCharacterColor = {
		color = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var0_26),
		intensity = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var0_26)
	}
end

function var0_0.SetCharacterLight(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = Color.Lerp(arg0_27.originalCharacterColor.color, arg1_27, arg3_27)
	local var1_27 = math.lerp(arg0_27.originalCharacterColor.intensity, arg2_27, arg3_27)
	local var2_27 = arg0_27:FindCharacterLight():GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var2_27, var0_27)
	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var2_27, var1_27)
end

function var0_0.RevertCharacterLight(arg0_28)
	arg0_28:SetCharacterLight(arg0_28.originalCharacterColor.color, arg0_28.originalCharacterColor.intensity, 1)
end

return var0_0

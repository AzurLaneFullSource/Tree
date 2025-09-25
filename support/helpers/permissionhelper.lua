PermissionHelper = {}

local var0_0 = PermissionHelper

function var0_0.IsAndroid()
	return PLATFORM == PLATFORM_ANDROID and not IsUnityEditor
end

function var0_0.IsIOS()
	return PLATFORM == PLATFORM_IPHONEPLAYER and not IsUnityEditor
end

var0_0.Android10SDKLevel = 29
var0_0.StateGranted = 0

function var0_0.RequestCamera(arg0_3, arg1_3)
	if var0_0.IsAndroid() or var0_0.IsIOS() then
		local var0_3 = {
			YSNormalTool.PermissionTool.Camera,
			YSNormalTool.PermissionTool.MIC
		}

		if var0_0.IsAndroid() and YSNormalTool.OtherTool.GetAndroidBuildVersion() < var0_0.Android10SDKLevel then
			table.insert(var0_3, YSNormalTool.PermissionTool.Photo)
		end

		local function var1_3(arg0_4, arg1_4)
			if underscore.all(arg1_4:ToTable(), function(arg0_5)
				return arg0_5 == var0_0.StateGranted
			end) then
				if arg0_3 then
					arg0_3()
				end
			elseif arg1_3 then
				arg1_3()
			end
		end

		YSNormalTool.PermissionTool.RequestMultiPermission(var0_3, var1_3)
	elseif arg0_3 then
		arg0_3()
	end
end

function var0_0.Request3DDorm(arg0_6, arg1_6)
	if var0_0.IsAndroid() or var0_0.IsIOS() then
		local var0_6 = {
			YSNormalTool.PermissionTool.MIC
		}

		if var0_0.IsAndroid() and YSNormalTool.OtherTool.GetAndroidBuildVersion() < var0_0.Android10SDKLevel then
			table.insert(var0_6, YSNormalTool.PermissionTool.Photo)
		end

		local function var1_6(arg0_7, arg1_7)
			if underscore.all(arg1_7:ToTable(), function(arg0_8)
				return arg0_8 == var0_0.StateGranted
			end) then
				if arg0_6 then
					arg0_6()
				end
			elseif arg1_6 then
				arg1_6()
			end
		end

		YSNormalTool.PermissionTool.RequestMultiPermission(var0_6, var1_6)
	elseif arg0_6 then
		arg0_6()
	end
end

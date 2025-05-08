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
			local var0_4 = true
			local var1_4 = arg1_4.Length

			for iter0_4 = 0, var1_4 - 1 do
				if arg1_4[iter0_4] ~= var0_0.StateGranted then
					var0_4 = false

					break
				end
			end

			if var0_4 then
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

function var0_0.Request3DDorm(arg0_5, arg1_5)
	if var0_0.IsAndroid() or var0_0.IsIOS() then
		local var0_5 = {
			YSNormalTool.PermissionTool.MIC
		}

		if var0_0.IsAndroid() and YSNormalTool.OtherTool.GetAndroidBuildVersion() < var0_0.Android10SDKLevel then
			table.insert(var0_5, YSNormalTool.PermissionTool.Photo)
		end

		local function var1_5(arg0_6, arg1_6)
			local var0_6 = true
			local var1_6 = arg1_6.Length

			for iter0_6 = 0, var1_6 - 1 do
				if arg1_6[iter0_6] ~= var0_0.StateGranted then
					var0_6 = false

					break
				end
			end

			if var0_6 then
				if arg0_5 then
					arg0_5()
				end
			elseif arg1_5 then
				arg1_5()
			end
		end

		YSNormalTool.PermissionTool.RequestMultiPermission(var0_5, var1_5)
	elseif arg0_5 then
		arg0_5()
	end
end

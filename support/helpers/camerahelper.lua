CameraHelper = {}

local var0_0 = CameraHelper
local var1_0 = YSTool.YSPermissionTool.Inst

function var0_0.IsAndroid()
	return PLATFORM == PLATFORM_ANDROID
end

function var0_0.IsIOS()
	return PLATFORM == PLATFORM_IPHONEPLAYER
end

function var0_0.RequestCamera(arg0_3, arg1_3)
	if var0_0.IsAndroid() then
		local var0_3 = {
			"android.permission.CAMERA",
			"android.permission.RECORD_AUDIO"
		}

		if PathMgr.getOSVersionNum() < 10 then
			table.insert(var0_3, "android.permission.WRITE_EXTERNAL_STORAGE")
		end

		local function var1_3(arg0_4, arg1_4)
			local var0_4 = true
			local var1_4 = arg1_4.Length

			for iter0_4 = 0, var1_4 - 1 do
				if not arg1_4[iter0_4] then
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

		var1_0:RequestMulti(var0_3, var1_3)
	elseif var0_0.IsIOS() then
		local var2_3 = "camera"

		originalPrint("ios camera " .. tostring(var1_0:IsPermissionGranted(var2_3)) .. " " .. tostring(var1_0:GetPermissionStatusCode(var2_3)))

		if var1_0:IsPermissionGranted(var2_3) then
			arg0_3()

			return
		end

		local function var3_3(arg0_5, arg1_5)
			if arg1_5 then
				if arg0_3 then
					arg0_3()
				end
			elseif arg1_3 then
				arg1_3()
			end
		end

		var1_0:RequestSingle(var2_3, var3_3)
	elseif arg0_3 then
		arg0_3()
	end
end

function var0_0.Request3DDorm(arg0_6, arg1_6)
	if var0_0.IsAndroid() then
		local var0_6 = {
			"android.permission.RECORD_AUDIO"
		}

		if PathMgr.getOSVersionNum() < 10 then
			table.insert(var0_6, "android.permission.WRITE_EXTERNAL_STORAGE")
		end

		local function var1_6(arg0_7, arg1_7)
			local var0_7 = true
			local var1_7 = arg1_7.Length

			for iter0_7 = 0, var1_7 - 1 do
				if not arg1_7[iter0_7] then
					var0_7 = false

					break
				end
			end

			if var0_7 then
				if arg0_6 then
					arg0_6()
				end
			elseif arg1_6 then
				arg1_6()
			end
		end

		var1_0:RequestMulti(var0_6, var1_6)
	elseif var0_0.IsIOS() then
		local var2_6 = "camera"

		originalPrint("ios开始录像权限判断")
		originalPrint("ios camera " .. tostring(var1_0:IsPermissionGranted(var2_6)) .. " " .. tostring(var1_0:GetPermissionStatusCode(var2_6)))

		if var1_0:IsPermissionGranted(var2_6) then
			arg0_6()

			return
		end

		local function var3_6(arg0_8, arg1_8)
			originalPrint("ios返回的isGranted" .. tostring(arg1_8))

			if arg1_8 then
				if arg0_6 then
					arg0_6()
				end
			elseif arg1_6 then
				arg1_6()
			end
		end

		var1_0:RequestSingle(var2_6, var3_6)
	elseif arg0_6 then
		arg0_6()
	end
end

CameraHelper = {}

local var0_0 = CameraHelper
local var1_0 = YSTool.YSPermissionTool.Inst

function var0_0.IsAndroid()
	return getProxy(UserProxy):GetCacheGatewayInServerLogined() == PLATFORM_ANDROID
end

function var0_0.IsIOS()
	return getProxy(UserProxy):GetCacheGatewayInServerLogined() == PLATFORM_IPHONEPLAYER
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

CameraHelper = {}

local var0 = CameraHelper
local var1 = YSTool.YSPermissionTool.Inst

function var0.IsAndroid()
	return getProxy(UserProxy):GetCacheGatewayInServerLogined() == PLATFORM_ANDROID
end

function var0.IsIOS()
	return getProxy(UserProxy):GetCacheGatewayInServerLogined() == PLATFORM_IPHONEPLAYER
end

function var0.RequestCamera(arg0, arg1)
	if var0.IsAndroid() then
		local var0 = {
			"android.permission.CAMERA",
			"android.permission.RECORD_AUDIO"
		}

		if PathMgr.getOSVersionNum() < 10 then
			table.insert(var0, "android.permission.WRITE_EXTERNAL_STORAGE")
		end

		local function var1(arg0, arg1)
			local var0 = true
			local var1 = arg1.Length

			for iter0 = 0, var1 - 1 do
				if not arg1[iter0] then
					var0 = false

					break
				end
			end

			if var0 then
				if arg0 then
					arg0()
				end
			elseif arg1 then
				arg1()
			end
		end

		var1:RequestMulti(var0, var1)
	elseif var0.IsIOS() then
		local var2 = "camera"

		local function var3(arg0, arg1)
			if arg1 then
				if arg0 then
					arg0()
				end
			elseif arg1 then
				arg1()
			end
		end

		var1:RequestSingle(var2, var3)
	elseif arg0 then
		arg0()
	end
end

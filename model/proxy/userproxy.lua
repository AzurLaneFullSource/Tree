local var0 = class("UserProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.userIsLogined = false
	arg0.gateways = {}
	arg0.canSwitchGateway = false
end

function var0.setLastLogin(arg0, arg1)
	assert(isa(arg1, User), "should be an instance of User")

	if arg1.type == 1 then
		PlayerPrefs.SetString("user.type", "1")
		PlayerPrefs.SetString("user.arg1", arg1.arg1)
		PlayerPrefs.SetString("user.arg2", arg1.arg2)
		PlayerPrefs.SetString("user.arg3", arg1.arg3)
	elseif arg1.type == 2 then
		PlayerPrefs.SetString("user.type", "1")
		PlayerPrefs.SetString("user.arg1", "yongshi")
		PlayerPrefs.SetString("user.arg2", arg1.arg1)
		PlayerPrefs.SetString("user.arg3", arg1.token)
	elseif arg1.type == 3 then
		PlayerPrefs.SetString("user.type", "3")
		PlayerPrefs.SetString("user.arg1", arg1.arg1)
		PlayerPrefs.SetString("user.arg2", "")
		PlayerPrefs.SetString("user.arg3", "")
		PlayerPrefs.SetString("guest_uuid", arg1.arg1)
	end

	PlayerPrefs.Save()

	arg0.data = arg1:clone()

	arg0.data:display("logged in")

	if PLATFORM_CODE == PLATFORM_JP then
		arg0:clearTranscode()
	end
end

function var0.getLastLoginUser()
	local var0 = tonumber(PlayerPrefs.GetString("user.type"))
	local var1 = PlayerPrefs.GetString("user.arg1")
	local var2 = PlayerPrefs.GetString("user.arg2")
	local var3 = PlayerPrefs.GetString("user.arg3")

	print("last login:", var0, " arg1:", var1)

	if var0 ~= "" and var1 ~= "" and var2 ~= "" then
		return User.New({
			type = var0,
			arg1 = var1,
			arg2 = var2,
			arg3 = var3
		})
	end

	return nil
end

function var0.saveTranscode(arg0, arg1)
	PlayerPrefs.SetString("transcode", arg1)
	PlayerPrefs.Save()
end

function var0.getTranscode(arg0)
	local var0 = PlayerPrefs.GetString("transcode")

	if var0 then
		return var0
	end

	return ""
end

function var0.clearTranscode(arg0)
	PlayerPrefs.DeleteKey("transcode")
end

function var0.SetLoginedFlag(arg0, arg1)
	arg0.userIsLogined = arg1
end

function var0.GetLoginedFlag(arg0)
	return arg0.userIsLogined
end

local var1 = "#cacheGatewayFlag#"

function var0.SetDefaultGateway(arg0)
	if not arg0.gateways[PLATFORM] then
		arg0.gateways[PLATFORM] = GatewayInfo.New(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, NetConst.PROXY_GATEWAY_HOST, NetConst.PROXY_GATEWAY_PORT)
	end
end

function var0.ShouldSwitchGateway(arg0, arg1, arg2)
	return arg0:GetCacheGatewayFlag(arg2) ~= arg1
end

function var0.GetGateWayByPlatform(arg0, arg1)
	return arg0.gateways[arg1]
end

function var0.SetGatewayForPlatform(arg0, arg1, arg2)
	arg0.gateways[arg1] = arg2
end

function var0.GetCacheGatewayFlag(arg0, arg1)
	if not arg0.cachePlatform then
		arg0.cachePlatform = PlayerPrefs.GetInt(var1 .. arg1, PLATFORM)
	end

	return arg0.cachePlatform
end

function var0.GetCacheGatewayInServerLogined(arg0)
	return arg0.cachePlatform or PLATFORM
end

function var0.SetCacheGatewayFlag(arg0, arg1)
	if arg0.cachePlatform ~= arg1 then
		arg0.cachePlatform = arg1
	end
end

function var0.SaveCacheGatewayFlag(arg0, arg1)
	if not arg0.canSwitchGateway then
		return
	end

	if PlayerPrefs.GetInt(var1 .. arg1, PLATFORM) ~= arg0.cachePlatform then
		PlayerPrefs.SetInt(var1 .. arg1, arg0.cachePlatform)
		PlayerPrefs.Save()
	end
end

function var0.GetReversePlatform(arg0)
	return arg0.cachePlatform == PLATFORM_IPHONEPLAYER and PLATFORM_ANDROID or PLATFORM_IPHONEPLAYER
end

function var0.ActiveGatewaySwitcher(arg0)
	arg0.canSwitchGateway = true
end

function var0.ShowGatewaySwitcher(arg0)
	return arg0.canSwitchGateway
end

return var0

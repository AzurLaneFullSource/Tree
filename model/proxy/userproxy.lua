local var0_0 = class("UserProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.userIsLogined = false
	arg0_1.gateways = {}
	arg0_1.canSwitchGateway = false
end

function var0_0.setLastLogin(arg0_2, arg1_2)
	assert(isa(arg1_2, User), "should be an instance of User")

	if arg1_2.type == 1 then
		PlayerPrefs.SetString("user.type", "1")
		PlayerPrefs.SetString("user.arg1", arg1_2.arg1)
		PlayerPrefs.SetString("user.arg2", arg1_2.arg2)
		PlayerPrefs.SetString("user.arg3", arg1_2.arg3)
	elseif arg1_2.type == 2 then
		PlayerPrefs.SetString("user.type", "1")
		PlayerPrefs.SetString("user.arg1", "yongshi")
		PlayerPrefs.SetString("user.arg2", arg1_2.arg1)
		PlayerPrefs.SetString("user.arg3", arg1_2.token)
	elseif arg1_2.type == 3 then
		PlayerPrefs.SetString("user.type", "3")
		PlayerPrefs.SetString("user.arg1", arg1_2.arg1)
		PlayerPrefs.SetString("user.arg2", "")
		PlayerPrefs.SetString("user.arg3", "")
		PlayerPrefs.SetString("guest_uuid", arg1_2.arg1)
	end

	PlayerPrefs.Save()

	arg0_2.data = arg1_2:clone()

	arg0_2.data:display("logged in")

	if PLATFORM_CODE == PLATFORM_JP then
		arg0_2:clearTranscode()
	end
end

function var0_0.getLastLoginUser()
	local var0_3 = tonumber(PlayerPrefs.GetString("user.type"))
	local var1_3 = PlayerPrefs.GetString("user.arg1")
	local var2_3 = PlayerPrefs.GetString("user.arg2")
	local var3_3 = PlayerPrefs.GetString("user.arg3")

	print("last login:", var0_3, " arg1:", var1_3)

	if var0_3 ~= "" and var1_3 ~= "" and var2_3 ~= "" then
		return User.New({
			type = var0_3,
			arg1 = var1_3,
			arg2 = var2_3,
			arg3 = var3_3
		})
	end

	return nil
end

function var0_0.saveTranscode(arg0_4, arg1_4)
	PlayerPrefs.SetString("transcode", arg1_4)
	PlayerPrefs.Save()
end

function var0_0.getTranscode(arg0_5)
	local var0_5 = PlayerPrefs.GetString("transcode")

	if var0_5 then
		return var0_5
	end

	return ""
end

function var0_0.clearTranscode(arg0_6)
	PlayerPrefs.DeleteKey("transcode")
end

function var0_0.SetLoginedFlag(arg0_7, arg1_7)
	arg0_7.userIsLogined = arg1_7
end

function var0_0.GetLoginedFlag(arg0_8)
	return arg0_8.userIsLogined
end

local var1_0 = "#cacheGatewayFlag#"

function var0_0.SetDefaultGateway(arg0_9)
	if not arg0_9.gateways[PLATFORM] then
		arg0_9.gateways[PLATFORM] = GatewayInfo.New(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, NetConst.PROXY_GATEWAY_HOST, NetConst.PROXY_GATEWAY_PORT)
	end
end

function var0_0.ShouldSwitchGateway(arg0_10, arg1_10, arg2_10)
	return arg0_10:GetCacheGatewayFlag(arg2_10) ~= arg1_10
end

function var0_0.GetGateWayByPlatform(arg0_11, arg1_11)
	return arg0_11.gateways[arg1_11]
end

function var0_0.SetGatewayForPlatform(arg0_12, arg1_12, arg2_12)
	arg0_12.gateways[arg1_12] = arg2_12
end

function var0_0.GetCacheGatewayFlag(arg0_13, arg1_13)
	if not arg0_13.cachePlatform then
		arg0_13.cachePlatform = PlayerPrefs.GetInt(var1_0 .. arg1_13, PLATFORM)
	end

	return arg0_13.cachePlatform
end

function var0_0.GetCacheGatewayInServerLogined(arg0_14)
	return arg0_14.cachePlatform or PLATFORM
end

function var0_0.SetCacheGatewayFlag(arg0_15, arg1_15)
	if arg0_15.cachePlatform ~= arg1_15 then
		arg0_15.cachePlatform = arg1_15
	end
end

function var0_0.SaveCacheGatewayFlag(arg0_16, arg1_16)
	if not arg0_16.canSwitchGateway then
		return
	end

	if PlayerPrefs.GetInt(var1_0 .. arg1_16, PLATFORM) ~= arg0_16.cachePlatform then
		PlayerPrefs.SetInt(var1_0 .. arg1_16, arg0_16.cachePlatform)
		PlayerPrefs.Save()
	end
end

function var0_0.GetReversePlatform(arg0_17)
	return arg0_17.cachePlatform == PLATFORM_IPHONEPLAYER and PLATFORM_ANDROID or PLATFORM_IPHONEPLAYER
end

function var0_0.ActiveGatewaySwitcher(arg0_18)
	arg0_18.canSwitchGateway = true
end

function var0_0.ShowGatewaySwitcher(arg0_19)
	return arg0_19.canSwitchGateway
end

return var0_0

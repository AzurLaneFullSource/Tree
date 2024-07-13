local var0_0 = class("ServerInterconnectionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.user
	local var2_1 = var0_1.platform
	local var3_1 = getProxy(UserProxy)

	var3_1:SetDefaultGateway()
	var3_1:ActiveGatewaySwitcher()

	local function var4_1(arg0_2)
		NetConst.GATEWAY_HOST = arg0_2.host
		NetConst.GATEWAY_PORT = arg0_2.port
		NetConst.PROXY_GATEWAY_HOST = arg0_2.proxyHost
		NetConst.PROXY_GATEWAY_PORT = arg0_2.proxyPort

		originalPrint("switch to:", NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT)
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var1_1
		})
	end

	if var3_1:ShouldSwitchGateway(var2_1 or PLATFORM, var1_1.arg2) then
		local var5_1 = var2_1 or var3_1:GetCacheGatewayFlag(var1_1.arg2)
		local var6_1 = var3_1:GetGateWayByPlatform(var5_1)

		if not var6_1 then
			arg0_1:GetGateWayByServer(var5_1, function(arg0_3)
				var3_1:SetGatewayForPlatform(var5_1, arg0_3)
				var3_1:SetCacheGatewayFlag(var5_1)
				var4_1(arg0_3)
			end)
		else
			var3_1:SetCacheGatewayFlag(var5_1)
			var4_1(var6_1)
		end
	else
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var1_1
		})
	end
end

function var0_0.GetGateWayByServer(arg0_4, arg1_4, arg2_4)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10802, {
			platform = arg1_4,
			state = NetConst.GatewayState
		}, 10803, function(arg0_6)
			pg.ConnectionMgr.GetInstance():Disconnect()

			local var0_6 = arg0_6.gateway_ip
			local var1_6 = arg0_6.gateway_port
			local var2_6 = System.String.IsNullOrEmpty(arg0_6.proxy_ip)
			local var3_6 = var2_6 and var0_6 or arg0_6.proxy_ip
			local var4_6 = var2_6 and var1_6 or arg0_6.proxy_port
			local var5_6 = GatewayInfo.New(var0_6, var1_6, var3_6, var4_6)

			arg2_4(var5_6)
		end)
	end)
end

return var0_0

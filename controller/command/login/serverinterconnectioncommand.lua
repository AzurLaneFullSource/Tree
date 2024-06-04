local var0 = class("ServerInterconnectionCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.user
	local var2 = var0.platform
	local var3 = getProxy(UserProxy)

	var3:SetDefaultGateway()
	var3:ActiveGatewaySwitcher()

	local function var4(arg0)
		NetConst.GATEWAY_HOST = arg0.host
		NetConst.GATEWAY_PORT = arg0.port
		NetConst.PROXY_GATEWAY_HOST = arg0.proxyHost
		NetConst.PROXY_GATEWAY_PORT = arg0.proxyPort

		originalPrint("switch to:", NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT)
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var1
		})
	end

	if var3:ShouldSwitchGateway(var2 or PLATFORM, var1.arg2) then
		local var5 = var2 or var3:GetCacheGatewayFlag(var1.arg2)
		local var6 = var3:GetGateWayByPlatform(var5)

		if not var6 then
			arg0:GetGateWayByServer(var5, function(arg0)
				var3:SetGatewayForPlatform(var5, arg0)
				var3:SetCacheGatewayFlag(var5)
				var4(arg0)
			end)
		else
			var3:SetCacheGatewayFlag(var5)
			var4(var6)
		end
	else
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = var1
		})
	end
end

function var0.GetGateWayByServer(arg0, arg1, arg2)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10802, {
			platform = arg1,
			state = NetConst.GatewayState
		}, 10803, function(arg0)
			pg.ConnectionMgr.GetInstance():Disconnect()

			local var0 = arg0.gateway_ip
			local var1 = arg0.gateway_port
			local var2 = System.String.IsNullOrEmpty(arg0.proxy_ip)
			local var3 = var2 and var0 or arg0.proxy_ip
			local var4 = var2 and var1 or arg0.proxy_port
			local var5 = GatewayInfo.New(var0, var1, var3, var4)

			arg2(var5)
		end)
	end)
end

return var0

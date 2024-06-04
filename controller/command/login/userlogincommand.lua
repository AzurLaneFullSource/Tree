local var0 = class("UserLoginCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(isa(var0, User), "should be an instance of User")
	originalPrint("connect to gateway - " .. NetConst.GATEWAY_HOST .. ":" .. NetConst.GATEWAY_PORT)

	local var1 = pg.SdkMgr.GetInstance():GetChannelUID()

	if var1 == "" then
		var1 = PLATFORM_LOCAL
	end

	if not var0.arg4 then
		var0.arg4 = "0"
	end

	local var2 = var0.arg4 == "0" and var0.arg3 or var0.arg4

	originalPrint("login type -- : ", var0.type, ", arg3 -- : ", var2, ", sessionid -- : " .. var0.arg4)
	pg.ConnectionMgr.GetInstance():SetProxyHost(NetConst.PROXY_GATEWAY_HOST, NetConst.PROXY_GATEWAY_PORT)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10020, {
			login_type = var0.type,
			arg1 = var0.arg1,
			arg2 = var0.arg2,
			arg3 = var2,
			arg4 = var1,
			check_key = HashUtil.CalcMD5(var0.arg1 .. AABBUDUD),
			device = PLATFORM
		}, 10021, function(arg0)
			originalPrint("disconnect from gateway...")
			pg.ConnectionMgr.GetInstance():Disconnect()

			if arg0.result == 0 then
				var0.id = arg0.account_id
				var0.uid = arg0.account_id
				var0.token = arg0.server_ticket
				var0.limitServerIds = arg0.limit_server_ids

				local var0 = getProxy(UserProxy)

				var0:setLastLogin(var0)
				var0:SetLoginedFlag(true)

				local var1 = {}
				local var2 = {
					"*all gate info :"
				}

				for iter0, iter1 in ipairs(arg0.serverlist) do
					local var3 = Server.New({
						id = iter1.ids[1],
						host = iter1.ip,
						port = iter1.port,
						proxy_host = iter1.proxy_ip,
						proxy_port = iter1.proxy_port,
						status = iter1.state,
						name = iter1.name,
						tag_state = iter1.tag_state,
						sort = iter1.sort
					})

					var2[#var2 + 1] = iter1.proxy_ip .. ":" .. iter1.proxy_port
					var2[#var2 + 1] = iter1.ip .. ":" .. iter1.port

					var3:display()
					table.insert(var1, var3)
				end

				originalPrint(table.concat(var2, "\n"))

				local var4 = getProxy(ServerProxy)

				var4:setServers(var1, var0.uid)

				if arg0.limit_server_ids and #arg0.limit_server_ids > 0 then
					var4.firstServer = nil
				end

				getProxy(GatewayNoticeProxy):setGatewayNotices(arg0.notice_list)
				arg0.facade:sendNotification(GAME.USER_LOGIN_SUCCESS, var0)
				pg.PushNotificationMgr.GetInstance():cancelAll()
				originalPrint("user logined............", #var1)
				pg.SdkMgr.GetInstance():SdkGateWayLogined()
			else
				pg.SdkMgr.GetInstance():SdkLoginGetaWayFailed()
				originalPrint("user login failed ............")

				if arg0.result == 13 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_gate_not_ready"))
				elseif arg0.result == 15 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_rigister_full"))
				elseif arg0.result == 18 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("system_database_busy"))
				elseif arg0.result == 6 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_login_full"))
				else
					arg0.facade:sendNotification(GAME.USER_LOGIN_FAILED, arg0.result)
				end
			end
		end, false)
	end)
end

return var0

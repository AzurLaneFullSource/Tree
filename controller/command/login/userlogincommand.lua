local var0_0 = class("UserLoginCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(isa(var0_1, User), "should be an instance of User")
	originalPrint("connect to gateway - " .. NetConst.GATEWAY_HOST .. ":" .. NetConst.GATEWAY_PORT)

	local var1_1 = pg.SdkMgr.GetInstance():GetChannelUID()

	if var1_1 == "" then
		var1_1 = PLATFORM_LOCAL
	end

	if not var0_1.arg4 then
		var0_1.arg4 = "0"
	end

	local var2_1 = var0_1.arg4 == "0" and var0_1.arg3 or var0_1.arg4

	originalPrint("login type -- : ", var0_1.type, ", arg3 -- : ", var2_1, ", sessionid -- : " .. var0_1.arg4)
	pg.ConnectionMgr.GetInstance():SetProxyHost(NetConst.PROXY_GATEWAY_HOST, NetConst.PROXY_GATEWAY_PORT)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10020, {
			login_type = var0_1.type,
			arg1 = var0_1.arg1,
			arg2 = var0_1.arg2,
			arg3 = var2_1,
			arg4 = var1_1,
			check_key = HashUtil.CalcMD5(var0_1.arg1 .. AABBUDUD),
			device = PLATFORM
		}, 10021, function(arg0_3)
			originalPrint("disconnect from gateway...")
			pg.ConnectionMgr.GetInstance():Disconnect()

			if arg0_3.result == 0 then
				var0_1.id = arg0_3.account_id
				var0_1.uid = arg0_3.account_id
				var0_1.token = arg0_3.server_ticket
				var0_1.limitServerIds = arg0_3.limit_server_ids

				local var0_3 = getProxy(UserProxy)

				var0_3:setLastLogin(var0_1)
				var0_3:SetLoginedFlag(true)

				local var1_3 = {}
				local var2_3 = {
					"*all gate info :"
				}

				for iter0_3, iter1_3 in ipairs(arg0_3.serverlist) do
					local var3_3 = Server.New({
						id = iter1_3.ids[1],
						host = iter1_3.ip,
						port = iter1_3.port,
						proxy_host = iter1_3.proxy_ip,
						proxy_port = iter1_3.proxy_port,
						status = iter1_3.state,
						name = iter1_3.name,
						tag_state = iter1_3.tag_state,
						sort = iter1_3.sort
					})

					var2_3[#var2_3 + 1] = iter1_3.proxy_ip .. ":" .. iter1_3.proxy_port
					var2_3[#var2_3 + 1] = iter1_3.ip .. ":" .. iter1_3.port

					var3_3:display()
					table.insert(var1_3, var3_3)
				end

				originalPrint(table.concat(var2_3, "\n"))

				local var4_3 = getProxy(ServerProxy)

				var4_3:setServers(var1_3, var0_1.uid)

				if arg0_3.limit_server_ids and #arg0_3.limit_server_ids > 0 then
					var4_3.firstServer = nil
				end

				getProxy(GatewayNoticeProxy):setGatewayNotices(arg0_3.notice_list)
				arg0_1.facade:sendNotification(GAME.USER_LOGIN_SUCCESS, var0_1)
				pg.PushNotificationMgr.GetInstance():cancelAll()
				originalPrint("user logined.............", #var1_3)
				pg.SdkMgr.GetInstance():SdkGateWayLogined()
			else
				pg.SdkMgr.GetInstance():SdkLoginGetaWayFailed()
				originalPrint("user login failed ............")

				if arg0_3.result == 13 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_gate_not_ready"))
				elseif arg0_3.result == 15 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_rigister_full"))
				elseif arg0_3.result == 18 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("system_database_busy"))
				elseif arg0_3.result == 6 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_login_full"))
				else
					arg0_1.facade:sendNotification(GAME.USER_LOGIN_FAILED, arg0_3.result)
				end
			end
		end, false)
	end)
end

return var0_0

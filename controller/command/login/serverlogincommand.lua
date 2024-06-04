local var0 = class("ServerLoginCommand", pm.SimpleCommand)

var0.LoginLastTime = 0
var0.LoginSafeLock = 0

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(isa(var0, Server), "should be an instance of Server")

	local var1 = var0:getHost()
	local var2 = var0:getPort()

	originalPrint("connect to game server - " .. var1 .. ":" .. var2)

	local var3 = getProxy(UserProxy)
	local var4 = var3:getData()
	local var5 = pg.SdkMgr.GetInstance():GetChannelUID()

	if var5 == "" then
		var5 = PLATFORM_LOCAL
	end

	local function var6(arg0)
		pg.ConnectionMgr.GetInstance():Send(10022, {
			platform = var5,
			account_id = var4.uid,
			server_ticket = arg0 or var4.token,
			serverid = var0.id,
			check_key = HashUtil.CalcMD5(var4.token .. AABBUDUD),
			device_id = pg.SdkMgr.GetInstance():GetDeviceId()
		}, 10023, function(arg0)
			if arg0.result == 0 then
				originalPrint("connect success: " .. arg0.user_id)

				if var0.status == Server.STATUS.REGISTER_FULL and arg0.user_id == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_register_full"))
					pg.ConnectionMgr.GetInstance():onDisconnected(true)
				else
					var4.token = arg0.server_ticket
					var4.server = var0.id

					var3:setLastLogin(var4)
					var3:SaveCacheGatewayFlag(var4.arg2)
					getProxy(ServerProxy):setLastServer(var0.id, var4.uid)
					arg0:sendNotification(GAME.SERVER_LOGIN_SUCCESS, {
						uid = arg0.user_id
					})
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_ROLE_LOGIN, nil, arg0.user_id)

					if arg0.user_id == 0 then
						pg.SdkMgr.GetInstance():ChooseServer(tostring(var0.id), var0.name)
					end
				end
			elseif arg0.result == 13 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_not_ready"))
			elseif arg0.result == 15 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_rigister_full"))
			elseif arg0.result == 17 then
				arg0:sendNotification(GAME.SERVER_LOGIN_FAILED_USER_BANNED, arg0.user_id)
			elseif arg0.result == 6 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_login_full"))
			elseif arg0.result == 18 then
				local var0 = arg0.db_load
				local var1 = arg0.server_load
				local var2 = math.floor(var0 / 100 + var1 / 1000 + 1)

				arg0:sendNotification(GAME.SERVER_LOGIN_WAIT, var2)
			else
				arg0:sendNotification(GAME.SERVER_LOGIN_FAILED, arg0.result)
			end
		end, false)
	end

	local var7 = os.time()

	var0.LoginSafeLock = var0.LoginSafeLock + 1

	if math.abs(var7 - var0.LoginLastTime) > 1 or var0.LoginSafeLock >= 5 then
		var0.LoginLastTime = var7
		var0.LoginSafeLock = 0

		if pg.ConnectionMgr.GetInstance():getConnection() and pg.ConnectionMgr.GetInstance():isConnected() then
			var6()
		else
			pg.ConnectionMgr.GetInstance():SetProxyHost(var0.proxyHost, var0.proxyPort)
			pg.ConnectionMgr.GetInstance():Connect(var1, var2, function()
				originalPrint("server: " .. var0.id .. " uid: " .. var4.uid)
				var6()
			end, 6)
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_frequence"))
	end
end

return var0

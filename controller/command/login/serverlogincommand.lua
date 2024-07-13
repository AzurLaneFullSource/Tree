local var0_0 = class("ServerLoginCommand", pm.SimpleCommand)

var0_0.LoginLastTime = 0
var0_0.LoginSafeLock = 0

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(isa(var0_1, Server), "should be an instance of Server")

	local var1_1 = var0_1:getHost()
	local var2_1 = var0_1:getPort()

	originalPrint("connect to game server - " .. var1_1 .. ":" .. var2_1)

	local var3_1 = getProxy(UserProxy)
	local var4_1 = var3_1:getData()
	local var5_1 = pg.SdkMgr.GetInstance():GetChannelUID()

	if var5_1 == "" then
		var5_1 = PLATFORM_LOCAL
	end

	local function var6_1(arg0_2)
		pg.ConnectionMgr.GetInstance():Send(10022, {
			platform = var5_1,
			account_id = var4_1.uid,
			server_ticket = arg0_2 or var4_1.token,
			serverid = var0_1.id,
			check_key = HashUtil.CalcMD5(var4_1.token .. AABBUDUD),
			device_id = pg.SdkMgr.GetInstance():GetDeviceId()
		}, 10023, function(arg0_3)
			if arg0_3.result == 0 then
				originalPrint("connect success: " .. arg0_3.user_id)

				if var0_1.status == Server.STATUS.REGISTER_FULL and arg0_3.user_id == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("login_register_full"))
					pg.ConnectionMgr.GetInstance():onDisconnected(true)
				else
					var4_1.token = arg0_3.server_ticket
					var4_1.server = var0_1.id

					var3_1:setLastLogin(var4_1)
					var3_1:SaveCacheGatewayFlag(var4_1.arg2)
					getProxy(ServerProxy):setLastServer(var0_1.id, var4_1.uid)
					arg0_1:sendNotification(GAME.SERVER_LOGIN_SUCCESS, {
						uid = arg0_3.user_id
					})
					pg.TrackerMgr.GetInstance():Tracking(TRACKING_ROLE_LOGIN, nil, arg0_3.user_id)

					if arg0_3.user_id == 0 then
						pg.SdkMgr.GetInstance():ChooseServer(tostring(var0_1.id), var0_1.name)
					end
				end
			elseif arg0_3.result == 13 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_not_ready"))
			elseif arg0_3.result == 15 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_rigister_full"))
			elseif arg0_3.result == 17 then
				arg0_1:sendNotification(GAME.SERVER_LOGIN_FAILED_USER_BANNED, arg0_3.user_id)
			elseif arg0_3.result == 6 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_login_full"))
			elseif arg0_3.result == 18 then
				local var0_3 = arg0_3.db_load
				local var1_3 = arg0_3.server_load
				local var2_3 = math.floor(var0_3 / 100 + var1_3 / 1000 + 1)

				arg0_1:sendNotification(GAME.SERVER_LOGIN_WAIT, var2_3)
			else
				arg0_1:sendNotification(GAME.SERVER_LOGIN_FAILED, arg0_3.result)
			end
		end, false)
	end

	local var7_1 = os.time()

	var0_0.LoginSafeLock = var0_0.LoginSafeLock + 1

	if math.abs(var7_1 - var0_0.LoginLastTime) > 1 or var0_0.LoginSafeLock >= 5 then
		var0_0.LoginLastTime = var7_1
		var0_0.LoginSafeLock = 0

		if pg.ConnectionMgr.GetInstance():getConnection() and pg.ConnectionMgr.GetInstance():isConnected() then
			var6_1()
		else
			pg.ConnectionMgr.GetInstance():SetProxyHost(var0_1.proxyHost, var0_1.proxyPort)
			pg.ConnectionMgr.GetInstance():Connect(var1_1, var2_1, function()
				originalPrint("server: " .. var0_1.id .. " uid: " .. var4_1.uid)
				var6_1()
			end, 6)
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_game_frequence"))
	end
end

return var0_0

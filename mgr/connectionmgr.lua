pg = pg or {}

local var0 = pg

var0.ConnectionMgr = singletonClass("ConnectionMgr")

local var1 = var0.ConnectionMgr
local var2 = createLog("ConnectionMgr", LOG_CONNECTION)
local var3
local var4
local var5
local var6
local var7 = false
local var8 = {}
local var9
local var10
local var11
local var12

var1.needStartSend = false

local var13
local var14

function var1.Connect(arg0, arg1, arg2, arg3, arg4)
	var1.erroCode = arg4
	var14 = arg3
	var3 = Connection.New(arg1, arg2)

	var0.UIMgr.GetInstance():LoadingOn()
	var3.onConnected:AddListener(function()
		var0.UIMgr.GetInstance():LoadingOff()
		var2("Network Connected.")

		var5 = arg1
		var6 = arg2
		var4 = var4 or var0.SendWindow.New(arg0, 0)

		var3.onData:AddListener(var4.onData)

		if PLATFORM_CODE == PLATFORM_CHT then
			var13 = var0.IPAddress.New()
		end

		pingDelay = -1
		var7 = true
		var10 = false

		arg3()
		arg0:resetHBTimer()
	end)
	var3.onData:AddListener(arg0.onData)
	var3.onError:AddListener(arg0.onError)
	var3.onDisconnected:AddListener(arg0.onDisconnected)

	var10 = true

	var3:Connect()
	originalPrint("connect to - " .. arg1 .. ":" .. arg2)
end

function var1.ConnectByProxy(arg0)
	VersionMgr.Inst:SetUseProxy(true)

	if arg0:GetLastHost() ~= nil and arg0:GetLastPort() ~= "" then
		originalPrint("switch proxy! reason: first connect error")
		arg0:Connect(arg0:GetLastHost(), arg0:GetLastPort(), var14)
	else
		originalPrint("not proxy -> logout")
		var0.m02:sendNotification(GAME.LOGOUT, {
			code = var1.erroCode or 3
		})
	end
end

function var1.ConnectByDomain(arg0, arg1, arg2)
	local var0 = LuaHelper.getHostByDomain(arg1)
	local var1 = DEFAULT_PORT

	arg0:Connect(var0, var1, arg2)
end

function var1.Reconnect(arg0, arg1)
	if not var5 or not var6 then
		warning("Network is not connected.")

		return
	end

	if var10 then
		warning("connecting, please wait...")

		return
	end

	if var7 and var3 ~= nil then
		warning("Network is connected.")

		return
	end

	var11 = arg1

	arg0:stopHBTimer()
	var4:stopTimer()
	originalPrint("reconnect --> " .. arg0:GetLastHost() .. ":" .. arg0:GetLastPort())
	arg0:Connect(arg0:GetLastHost(), arg0:GetLastPort(), function()
		local var0 = getProxy(UserProxy)
		local var1 = var0:getData()
		local var2 = var0.SdkMgr.GetInstance():GetChannelUID()

		if var2 == "" then
			var2 = PLATFORM_LOCAL
		end

		if not var1 or not var1:isLogin() then
			if var4.currentCS == 10020 and var12 ~= DISCONNECT_TIME_OUT then
				arg0.needStartSend = false

				var4:StartSend()
			else
				var0.m02:sendNotification(GAME.LOGOUT, {
					code = 3
				})
			end

			return
		end

		var4:Send(10022, {
			platform = var2,
			account_id = var1.uid,
			server_ticket = var1.token,
			serverid = var1.server,
			check_key = HashUtil.CalcMD5(var1.token .. AABBUDUD),
			device_id = var0.SdkMgr.GetInstance():GetDeviceId()
		}, 10023, function(arg0)
			if arg0.result == 0 then
				originalPrint("reconnect success: " .. arg0.user_id, " - ", arg0.server_ticket)

				var1.token = arg0.server_ticket

				var0:setLastLogin(var1)
				arg1()

				if var12 ~= DISCONNECT_TIME_OUT and var4:getPacketIdx() > 0 then
					arg0.needStartSend = false

					var4:Send(11001, {
						timestamp = 1
					}, 11002, function(arg0)
						var0.TimeMgr.GetInstance():SetServerTime(arg0.timestamp, arg0.monday_0oclock_timestamp)
						var0.m02:sendNotification(GAME.CHANGE_CHAT_ROOM, 0)
					end)

					local var0 = nowWorld()

					if var0 and var0.type ~= World.TypeBase then
						WorldConst.ReqWorldForServer()
					end
				elseif arg0.needStartSend then
					arg0.needStartSend = false

					var4:StartSend()
				end

				var12 = nil

				local var1 = getProxy(PlayerProxy)

				if var1 and var1:getInited() then
					var0.SecondaryPWDMgr.GetInstance():FetchData()
				end

				var0.NewGuideMgr.GetInstance():Resume()
				var0.m02:sendNotification(GAME.ON_RECONNECTION)
			else
				originalPrint("reconnect failed: " .. arg0.result)
				var0.m02:sendNotification(GAME.LOGOUT, {
					code = 199,
					tip = arg0.result
				})
			end
		end, false, false)
	end)
end

function var1.onDisconnected(arg0, arg1)
	var2("Network onDisconnected: " .. tostring(arg0))

	var12 = arg1

	if var3 then
		if not arg0 then
			var3.onDisconnected:RemoveAllListeners()
		end

		var3:Dispose()

		var3 = nil
	end

	if arg0 then
		var7 = false
	end

	if var10 then
		var0.UIMgr.GetInstance():LoadingOff()
	end

	var10 = false
end

function var1.onData(arg0)
	if var8[arg0.cmd] then
		local var0 = var0.Packer.GetInstance():Unpack(arg0.cmd, arg0:getLuaStringBuffer())

		for iter0, iter1 in ipairs(var8[arg0.cmd]) do
			iter1(var0)
		end
	end
end

function var1.onError(arg0)
	var0.UIMgr.GetInstance():LoadingOff()

	arg0 = tostring(arg0)

	var2("Network Error: " .. arg0)

	if var3 then
		var3:Dispose()

		var3 = nil
	end

	local var0 = function()
		var0.m02:sendNotification(GAME.LOGOUT, {
			code = var1.erroCode or 3
		})
	end

	local function var1()
		return
	end

	if var10 then
		var10 = false
		var1 = var11
	end

	var0.ConnectionMgr.GetInstance():CheckProxyCounter()

	if var5 and var6 then
		var0.ConnectionMgr.GetInstance():stopHBTimer()

		if table.contains({
			"NotSocket"
		}, arg0) then
			var0.ConnectionMgr.GetInstance():Reconnect(var1)
		else
			var0.MsgboxMgr.GetInstance():CloseAndHide()
			var0.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				content = i18n("reconnect_tip", arg0),
				onYes = function()
					var0.ConnectionMgr.GetInstance():Reconnect(var1)
				end,
				onNo = var0,
				weight = LayerWeightConst.TOP_LAYER
			})
			var0.NewStoryMgr.GetInstance():Stop()
			var0.NewGuideMgr.GetInstance():Pause()
		end
	else
		var0.ConnectionMgr.GetInstance():ConnectByProxy()
	end
end

function var1.Send(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if not var7 then
		warning("Network is not connected. msgid " .. arg1)
		var0.m02:sendNotification(GAME.LOGOUT, {
			code = 5
		})

		return
	end

	local var0 = function(arg0)
		if arg0.result == 9998 then
			var0.m02:sendNotification(GAME.EXTRA_PROTO_RESULT, {
				result = arg0.result
			})
		else
			arg4(arg0)
		end
	end

	var4:Queue(arg1, arg2, arg3, var0, arg5, nil, arg6)
end

function var1.setPacketIdx(arg0, arg1)
	var4:setPacketIdx(arg1)
end

function var1.On(arg0, arg1, arg2)
	if var8[arg1] == nil then
		var8[arg1] = {}
	end

	table.insert(var8[arg1], arg2)
end

function var1.Off(arg0, arg1, arg2)
	if var8[arg1] == nil then
		return
	end

	if arg2 == nil then
		var8[arg1] = nil
	else
		for iter0, iter1 in ipairs(var8[arg1]) do
			if iter1 == arg2 then
				table.remove(var8[arg1], iter0)

				break
			end
		end
	end
end

function var1.Disconnect(arg0)
	arg0:stopHBTimer()

	var8 = {}

	var2("Manually Disconnect !!!")

	if var3 then
		var3:Dispose()

		var3 = nil
	end

	var5 = nil
	var6 = nil
	lastProxyHost = nil
	lastProxyPort = nil
	var4 = nil
	var7 = false
end

function var1.getConnection(arg0)
	return var3
end

function var1.isConnecting(arg0)
	return var10
end

function var1.isConnected(arg0)
	return var7
end

function var1.stopHBTimer(arg0)
	if var9 then
		var9:Stop()

		var9 = nil
	end
end

function var1.resetHBTimer(arg0)
	arg0:stopHBTimer()

	var9 = Timer.New(function()
		heartTime = TimeUtil.GetSystemTime()

		arg0:Send(10100, {
			need_request = 1
		}, 10101, function(arg0)
			local var0 = TimeUtil.GetSystemTime() - heartTime

			if pingDelay == -1 then
				pingDelay = var0
			else
				pingDelay = (var0 + pingDelay) / 2
			end
		end, false)
	end, HEART_BEAT_TIMEOUT, -1, true)

	var9:Start()
end

local var15 = 0
local var16 = 2
local var17
local var18

function var1.SetProxyHost(arg0, arg1, arg2)
	var17 = arg1
	var18 = arg2

	originalPrint("Proxy host --> " .. var17 .. ":" .. var18)
end

function var1.GetLastHost(arg0)
	if VersionMgr.Inst:OnProxyUsing() and var17 ~= nil and var17 ~= "" then
		return var17
	end

	return var5
end

function var1.GetLastPort(arg0)
	if VersionMgr.Inst:OnProxyUsing() and var18 ~= nil and var18 ~= 0 then
		return var18
	end

	return var6
end

function var1.CheckProxyCounter(arg0)
	var15 = var15 + 1

	originalPrint("proxyCounter: " .. var15)

	if not VersionMgr.Inst:OnProxyUsing() and var15 == var16 then
		originalPrint("switch proxy! reason: " .. var16 .. " error limit")
		VersionMgr.Inst:SetUseProxy(true)
	end
end

function var1.SwitchProxy(arg0)
	if var13 and var13:IsSpecialIP() then
		if not VersionMgr.Inst:OnProxyUsing() then
			originalPrint("switch proxy! reason: tw specialIP send timeout")
			VersionMgr.Inst:SetUseProxy(true)
		else
			VersionMgr.Inst:SetUseProxy(false)
		end

		var1.onDisconnected(false, DISCONNECT_TIME_OUT)
	end
end

pg = pg or {}

local var0_0 = pg

var0_0.ConnectionMgr = singletonClass("ConnectionMgr")

local var1_0 = var0_0.ConnectionMgr
local var2_0 = createLog("ConnectionMgr", LOG_CONNECTION)
local var3_0
local var4_0
local var5_0
local var6_0
local var7_0 = false
local var8_0 = {}
local var9_0
local var10_0
local var11_0
local var12_0

var1_0.needStartSend = false

local var13_0
local var14_0

function var1_0.Connect(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var1_0.erroCode = arg4_1
	var14_0 = arg3_1
	var3_0 = Connection.New(arg1_1, arg2_1)

	var0_0.UIMgr.GetInstance():LoadingOn()
	var3_0.onConnected:AddListener(function()
		var0_0.UIMgr.GetInstance():LoadingOff()
		var2_0("Network Connected.")

		var5_0 = arg1_1
		var6_0 = arg2_1
		var4_0 = var4_0 or var0_0.SendWindow.New(arg0_1, 0)

		var3_0.onData:AddListener(var4_0.onData)

		if PLATFORM_CODE == PLATFORM_CHT then
			var13_0 = var0_0.IPAddress.New()
		end

		pingDelay = -1
		var7_0 = true
		var10_0 = false

		arg3_1()
		arg0_1:resetHBTimer()
	end)
	var3_0.onData:AddListener(arg0_1.onData)
	var3_0.onError:AddListener(arg0_1.onError)
	var3_0.onDisconnected:AddListener(arg0_1.onDisconnected)

	var10_0 = true

	var3_0:Connect()
	originalPrint("connect to - " .. arg1_1 .. ":" .. arg2_1)
end

function var1_0.ConnectByProxy(arg0_3)
	VersionMgr.Inst:SetUseProxy(true)

	if arg0_3:GetLastHost() ~= nil and arg0_3:GetLastPort() ~= "" then
		originalPrint("switch proxy! reason: first connect error")
		arg0_3:Connect(arg0_3:GetLastHost(), arg0_3:GetLastPort(), var14_0)
	else
		originalPrint("not proxy -> logout")
		var0_0.m02:sendNotification(GAME.LOGOUT, {
			code = var1_0.erroCode or 3
		})
	end
end

function var1_0.ConnectByDomain(arg0_4, arg1_4, arg2_4)
	local var0_4 = LuaHelper.getHostByDomain(arg1_4)
	local var1_4 = DEFAULT_PORT

	arg0_4:Connect(var0_4, var1_4, arg2_4)
end

function var1_0.Reconnect(arg0_5, arg1_5)
	if not var5_0 or not var6_0 then
		warning("Network is not connected.")

		return
	end

	if var10_0 then
		warning("connecting, please wait...")

		return
	end

	if var7_0 and var3_0 ~= nil then
		warning("Network is connected.")

		return
	end

	var11_0 = arg1_5

	arg0_5:stopHBTimer()
	var4_0:stopTimer()
	originalPrint("reconnect --> " .. arg0_5:GetLastHost() .. ":" .. arg0_5:GetLastPort())
	arg0_5:Connect(arg0_5:GetLastHost(), arg0_5:GetLastPort(), function()
		local var0_6 = getProxy(UserProxy)
		local var1_6 = var0_6:getData()
		local var2_6 = var0_0.SdkMgr.GetInstance():GetChannelUID()

		if var2_6 == "" then
			var2_6 = PLATFORM_LOCAL
		end

		if not var1_6 or not var1_6:isLogin() then
			if var4_0.currentCS == 10020 and var12_0 ~= DISCONNECT_TIME_OUT then
				arg0_5.needStartSend = false

				var4_0:StartSend()
			else
				var0_0.m02:sendNotification(GAME.LOGOUT, {
					code = 3
				})
			end

			return
		end

		var4_0:Send(10022, {
			platform = var2_6,
			account_id = var1_6.uid,
			server_ticket = var1_6.token,
			serverid = var1_6.server,
			check_key = HashUtil.CalcMD5(var1_6.token .. AABBUDUD),
			device_id = var0_0.SdkMgr.GetInstance():GetDeviceId()
		}, 10023, function(arg0_7)
			if arg0_7.result == 0 then
				originalPrint("reconnect success: " .. arg0_7.user_id, " - ", arg0_7.server_ticket)

				var1_6.token = arg0_7.server_ticket

				var0_6:setLastLogin(var1_6)
				arg1_5()

				if var12_0 ~= DISCONNECT_TIME_OUT and var4_0:getPacketIdx() > 0 then
					arg0_5.needStartSend = false

					var4_0:Send(11001, {
						timestamp = 1
					}, 11002, function(arg0_8)
						var0_0.TimeMgr.GetInstance():SetServerTime(arg0_8.timestamp, arg0_8.monday_0oclock_timestamp)
						var0_0.m02:sendNotification(GAME.CHANGE_CHAT_ROOM, 0)
					end)

					local var0_7 = nowWorld()

					if var0_7 and var0_7.type ~= World.TypeBase then
						WorldConst.ReqWorldForServer()
					end
				elseif arg0_5.needStartSend then
					arg0_5.needStartSend = false

					var4_0:StartSend()
				end

				var12_0 = nil

				local var1_7 = getProxy(PlayerProxy)

				if var1_7 and var1_7:getInited() then
					var0_0.SecondaryPWDMgr.GetInstance():FetchData()
				end

				var0_0.NewGuideMgr.GetInstance():Resume()
				var0_0.m02:sendNotification(GAME.ON_RECONNECTION)
			else
				originalPrint("reconnect failed: " .. arg0_7.result)
				var0_0.m02:sendNotification(GAME.LOGOUT, {
					code = 199,
					tip = arg0_7.result
				})
			end
		end, false, false)
	end)
end

function var1_0.onDisconnected(arg0_9, arg1_9)
	var2_0("Network onDisconnected: " .. tostring(arg0_9))

	var12_0 = arg1_9

	if var3_0 then
		if not arg0_9 then
			var3_0.onDisconnected:RemoveAllListeners()
		end

		var3_0:Dispose()

		var3_0 = nil
	end

	if arg0_9 then
		var7_0 = false
	end

	if var10_0 then
		var0_0.UIMgr.GetInstance():LoadingOff()
	end

	var10_0 = false
end

function var1_0.onData(arg0_10)
	if var8_0[arg0_10.cmd] then
		local var0_10 = var0_0.Packer.GetInstance():Unpack(arg0_10.cmd, arg0_10:getLuaStringBuffer())

		for iter0_10, iter1_10 in ipairs(var8_0[arg0_10.cmd]) do
			iter1_10(var0_10)
		end
	end
end

function var1_0.onError(arg0_11)
	var0_0.UIMgr.GetInstance():LoadingOff()

	arg0_11 = tostring(arg0_11)

	var2_0("Network Error: " .. arg0_11)

	if var3_0 then
		var3_0:Dispose()

		var3_0 = nil
	end

	local function var0_11()
		var0_0.m02:sendNotification(GAME.LOGOUT, {
			code = var1_0.erroCode or 3
		})
	end

	local function var1_11()
		return
	end

	if var10_0 then
		var10_0 = false
		var1_11 = var11_0
	end

	var0_0.ConnectionMgr.GetInstance():CheckProxyCounter()

	if var5_0 and var6_0 then
		var0_0.ConnectionMgr.GetInstance():stopHBTimer()

		if table.contains({
			"NotSocket"
		}, arg0_11) then
			var0_0.ConnectionMgr.GetInstance():Reconnect(var1_11)
		else
			var0_0.MsgboxMgr.GetInstance():CloseAndHide()
			var0_0.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				content = i18n("reconnect_tip", arg0_11),
				onYes = function()
					var0_0.ConnectionMgr.GetInstance():Reconnect(var1_11)
				end,
				onNo = var0_11,
				weight = LayerWeightConst.TOP_LAYER
			})
			var0_0.NewStoryMgr.GetInstance():Stop()
			var0_0.NewGuideMgr.GetInstance():Pause()
		end
	else
		var0_0.ConnectionMgr.GetInstance():ConnectByProxy()
	end
end

function var1_0.Send(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15)
	if not var7_0 then
		warning("Network is not connected. msgid " .. arg1_15)
		var0_0.m02:sendNotification(GAME.LOGOUT, {
			code = 5
		})

		return
	end

	local function var0_15(arg0_16)
		if arg0_16.result == 9998 then
			var0_0.m02:sendNotification(GAME.EXTRA_PROTO_RESULT, {
				result = arg0_16.result
			})
		else
			arg4_15(arg0_16)
		end
	end

	var4_0:Queue(arg1_15, arg2_15, arg3_15, var0_15, arg5_15, nil, arg6_15)
end

function var1_0.setPacketIdx(arg0_17, arg1_17)
	var4_0:setPacketIdx(arg1_17)
end

function var1_0.On(arg0_18, arg1_18, arg2_18)
	if var8_0[arg1_18] == nil then
		var8_0[arg1_18] = {}
	end

	table.insert(var8_0[arg1_18], arg2_18)
end

function var1_0.Off(arg0_19, arg1_19, arg2_19)
	if var8_0[arg1_19] == nil then
		return
	end

	if arg2_19 == nil then
		var8_0[arg1_19] = nil
	else
		for iter0_19, iter1_19 in ipairs(var8_0[arg1_19]) do
			if iter1_19 == arg2_19 then
				table.remove(var8_0[arg1_19], iter0_19)

				break
			end
		end
	end
end

function var1_0.Disconnect(arg0_20)
	arg0_20:stopHBTimer()

	var8_0 = {}

	var2_0("Manually Disconnect !!!")

	if var3_0 then
		var3_0:Dispose()

		var3_0 = nil
	end

	var5_0 = nil
	var6_0 = nil
	lastProxyHost = nil
	lastProxyPort = nil
	var4_0 = nil
	var7_0 = false
end

function var1_0.getConnection(arg0_21)
	return var3_0
end

function var1_0.isConnecting(arg0_22)
	return var10_0
end

function var1_0.isConnected(arg0_23)
	return var7_0
end

function var1_0.stopHBTimer(arg0_24)
	if var9_0 then
		var9_0:Stop()

		var9_0 = nil
	end
end

function var1_0.resetHBTimer(arg0_25)
	arg0_25:stopHBTimer()

	var9_0 = Timer.New(function()
		heartTime = TimeUtil.GetSystemTime()

		arg0_25:Send(10100, {
			need_request = 1
		}, 10101, function(arg0_27)
			local var0_27 = TimeUtil.GetSystemTime() - heartTime

			if pingDelay == -1 then
				pingDelay = var0_27
			else
				pingDelay = (var0_27 + pingDelay) / 2
			end
		end, false)
	end, HEART_BEAT_TIMEOUT, -1, true)

	var9_0:Start()
end

local var15_0 = 0
local var16_0 = 2
local var17_0
local var18_0

function var1_0.SetProxyHost(arg0_28, arg1_28, arg2_28)
	var17_0 = arg1_28
	var18_0 = arg2_28

	originalPrint("Proxy host --> " .. var17_0 .. ":" .. var18_0)
end

function var1_0.GetLastHost(arg0_29)
	if VersionMgr.Inst:OnProxyUsing() and var17_0 ~= nil and var17_0 ~= "" then
		return var17_0
	end

	return var5_0
end

function var1_0.GetLastPort(arg0_30)
	if VersionMgr.Inst:OnProxyUsing() and var18_0 ~= nil and var18_0 ~= 0 then
		return var18_0
	end

	return var6_0
end

function var1_0.CheckProxyCounter(arg0_31)
	var15_0 = var15_0 + 1

	originalPrint("proxyCounter: " .. var15_0)

	if not VersionMgr.Inst:OnProxyUsing() and var15_0 == var16_0 then
		originalPrint("switch proxy! reason: " .. var16_0 .. " error limit")
		VersionMgr.Inst:SetUseProxy(true)
	end
end

function var1_0.SwitchProxy(arg0_32)
	if var13_0 and var13_0:IsSpecialIP() then
		if not VersionMgr.Inst:OnProxyUsing() then
			originalPrint("switch proxy! reason: tw specialIP send timeout")
			VersionMgr.Inst:SetUseProxy(true)
		else
			VersionMgr.Inst:SetUseProxy(false)
		end

		var1_0.onDisconnected(false, DISCONNECT_TIME_OUT)
	end
end

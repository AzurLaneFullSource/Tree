pg = pg or {}

local var0_0 = pg

var0_0.SimpleConnectionMgr = singletonClass("SimpleConnectionMgr")

local var1_0 = var0_0.SimpleConnectionMgr
local var2_0 = createLog("SimpleConnectionMgr", false)
local var3_0
local var4_0
local var5_0 = false
local var6_0 = {}
local var7_0

function var1_0.Connect(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var1_0.stopTimer()

	var3_0 = Connection.New(arg1_1, arg2_1)

	var0_0.UIMgr.GetInstance():LoadingOn()
	var3_0.onConnected:AddListener(function()
		var0_0.UIMgr.GetInstance():LoadingOff()
		var2_0("Simple Network Connected.")

		var4_0 = var4_0 or var0_0.SendWindow.New(arg0_1, 0)

		var3_0.onData:AddListener(var4_0.onData)

		var5_0 = true
		var7_0 = false

		arg3_1()
	end)
	var3_0.onData:AddListener(arg0_1.onData)
	var3_0.onError:AddListener(arg0_1.onError)
	var3_0.onDisconnected:AddListener(arg0_1.onDisconnected)

	var7_0 = true

	var3_0:Connect()

	arg4_1 = defaultValue(arg4_1, SEND_TIMEOUT)
	var1_0.timer = Timer.New(function()
		if not var5_0 then
			warning("connect timeout error (custom): " .. arg4_1)
			var1_0.stopTimer()
			arg0_1.onDisconnected(false, DISCONNECT_TIME_OUT)

			if var1_0.errorCB then
				var1_0.errorCB()
			end
		end
	end, arg4_1, 1)

	var1_0.timer:Start()
end

function var1_0.stopTimer()
	if var1_0.timer then
		var1_0.timer:Stop()

		var1_0.timer = nil
	end
end

function var1_0.onDisconnected(arg0_5, arg1_5)
	var2_0("Simple Network onDisconnected: " .. tostring(arg0_5))

	if var3_0 then
		if not arg0_5 then
			var3_0.onDisconnected:RemoveAllListeners()
		end

		var3_0:Dispose()

		var3_0 = nil
	end

	if arg0_5 then
		var5_0 = false
	end

	if var7_0 then
		var0_0.UIMgr.GetInstance():LoadingOff()
	end

	var7_0 = false
end

function var1_0.onData(arg0_6)
	if var6_0[arg0_6.cmd] then
		local var0_6 = var0_0.Packer.GetInstance():Unpack(arg0_6.cmd, arg0_6:getLuaStringBuffer())

		for iter0_6, iter1_6 in ipairs(var6_0[arg0_6.cmd]) do
			iter1_6(var0_6)
		end
	end
end

function var1_0.SetErrorCB(arg0_7, arg1_7)
	var1_0.errorCB = arg1_7
end

function var1_0.onError(arg0_8)
	var0_0.UIMgr.GetInstance():LoadingOff()
	var1_0.stopTimer()

	arg0_8 = tostring(arg0_8)

	var2_0("Simple Network Error: " .. arg0_8)

	if var3_0 then
		var3_0:Dispose()

		var3_0 = nil
	end

	if var7_0 then
		var7_0 = false
	end

	if var1_0.errorCB then
		var1_0.errorCB()
	end
end

function var1_0.Send(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
	if not var5_0 then
		warning("Simple Network is not connected. msgid " .. arg1_9)

		return
	end

	var4_0:Queue(arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, nil, arg6_9)
end

function var1_0.setPacketIdx(arg0_10, arg1_10)
	var4_0:setPacketIdx(arg1_10)
end

function var1_0.On(arg0_11, arg1_11, arg2_11)
	if var6_0[arg1_11] == nil then
		var6_0[arg1_11] = {}
	end

	table.insert(var6_0[arg1_11], arg2_11)
end

function var1_0.Off(arg0_12, arg1_12, arg2_12)
	if var6_0[arg1_12] == nil then
		return
	end

	if arg2_12 == nil then
		var6_0[arg1_12] = nil
	else
		for iter0_12, iter1_12 in ipairs(var6_0[arg1_12]) do
			if iter1_12 == arg2_12 then
				table.remove(var6_0[arg1_12], iter0_12)

				break
			end
		end
	end
end

function var1_0.Disconnect(arg0_13)
	var6_0 = {}

	var2_0("Simple Network Disconnect !!!")

	if var3_0 then
		var3_0:Dispose()

		var3_0 = nil
	end

	var4_0 = nil
	var5_0 = false
end

function var1_0.Reconnect(arg0_14, arg1_14)
	arg0_14:Disconnect()

	if var1_0.errorCB then
		var1_0.errorCB()
	end
end

function var1_0.resetHBTimer(arg0_15)
	return
end

function var1_0.getConnection(arg0_16)
	return var3_0
end

function var1_0.isConnecting(arg0_17)
	return var7_0
end

function var1_0.isConnected(arg0_18)
	return var5_0
end

function var1_0.SwitchProxy(arg0_19)
	return
end

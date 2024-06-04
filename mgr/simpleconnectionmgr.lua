pg = pg or {}

local var0 = pg

var0.SimpleConnectionMgr = singletonClass("SimpleConnectionMgr")

local var1 = var0.SimpleConnectionMgr
local var2 = createLog("SimpleConnectionMgr", false)
local var3
local var4
local var5 = false
local var6 = {}
local var7

function var1.Connect(arg0, arg1, arg2, arg3, arg4)
	var1.stopTimer()

	var3 = Connection.New(arg1, arg2)

	var0.UIMgr.GetInstance():LoadingOn()
	var3.onConnected:AddListener(function()
		var0.UIMgr.GetInstance():LoadingOff()
		var2("Simple Network Connected.")

		var4 = var4 or var0.SendWindow.New(arg0, 0)

		var3.onData:AddListener(var4.onData)

		var5 = true
		var7 = false

		arg3()
	end)
	var3.onData:AddListener(arg0.onData)
	var3.onError:AddListener(arg0.onError)
	var3.onDisconnected:AddListener(arg0.onDisconnected)

	var7 = true

	var3:Connect()

	arg4 = defaultValue(arg4, SEND_TIMEOUT)
	var1.timer = Timer.New(function()
		if not var5 then
			warning("connect timeout error (custom): " .. arg4)
			var1.stopTimer()
			arg0.onDisconnected(false, DISCONNECT_TIME_OUT)

			if var1.errorCB then
				var1.errorCB()
			end
		end
	end, arg4, 1)

	var1.timer:Start()
end

function var1.stopTimer()
	if var1.timer then
		var1.timer:Stop()

		var1.timer = nil
	end
end

function var1.onDisconnected(arg0, arg1)
	var2("Simple Network onDisconnected: " .. tostring(arg0))

	if var3 then
		if not arg0 then
			var3.onDisconnected:RemoveAllListeners()
		end

		var3:Dispose()

		var3 = nil
	end

	if arg0 then
		var5 = false
	end

	if var7 then
		var0.UIMgr.GetInstance():LoadingOff()
	end

	var7 = false
end

function var1.onData(arg0)
	if var6[arg0.cmd] then
		local var0 = var0.Packer.GetInstance():Unpack(arg0.cmd, arg0:getLuaStringBuffer())

		for iter0, iter1 in ipairs(var6[arg0.cmd]) do
			iter1(var0)
		end
	end
end

function var1.SetErrorCB(arg0, arg1)
	var1.errorCB = arg1
end

function var1.onError(arg0)
	var0.UIMgr.GetInstance():LoadingOff()
	var1.stopTimer()

	arg0 = tostring(arg0)

	var2("Simple Network Error: " .. arg0)

	if var3 then
		var3:Dispose()

		var3 = nil
	end

	if var7 then
		var7 = false
	end

	if var1.errorCB then
		var1.errorCB()
	end
end

function var1.Send(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if not var5 then
		warning("Simple Network is not connected. msgid " .. arg1)

		return
	end

	var4:Queue(arg1, arg2, arg3, arg4, arg5, nil, arg6)
end

function var1.setPacketIdx(arg0, arg1)
	var4:setPacketIdx(arg1)
end

function var1.On(arg0, arg1, arg2)
	if var6[arg1] == nil then
		var6[arg1] = {}
	end

	table.insert(var6[arg1], arg2)
end

function var1.Off(arg0, arg1, arg2)
	if var6[arg1] == nil then
		return
	end

	if arg2 == nil then
		var6[arg1] = nil
	else
		for iter0, iter1 in ipairs(var6[arg1]) do
			if iter1 == arg2 then
				table.remove(var6[arg1], iter0)

				break
			end
		end
	end
end

function var1.Disconnect(arg0)
	var6 = {}

	var2("Simple Network Disconnect !!!")

	if var3 then
		var3:Dispose()

		var3 = nil
	end

	var4 = nil
	var5 = false
end

function var1.Reconnect(arg0, arg1)
	arg0:Disconnect()

	if var1.errorCB then
		var1.errorCB()
	end
end

function var1.resetHBTimer(arg0)
	return
end

function var1.getConnection(arg0)
	return var3
end

function var1.isConnecting(arg0)
	return var7
end

function var1.isConnected(arg0)
	return var5
end

function var1.SwitchProxy(arg0)
	return
end

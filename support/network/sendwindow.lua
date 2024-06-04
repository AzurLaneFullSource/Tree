pg = pg or {}

local var0 = pg

var0.SendWindow = class("SendWindow")

local var1 = var0.SendWindow
local var2

function var1.Ctor(arg0, arg1, arg2)
	arg0.connectionMgr = arg1
	arg0.packetIdx = defaultValue(arg2, 0)
	arg0.isSending = false
	arg0.toSends = {}
	arg0.retryCount = 0
	var2 = {}
end

function var1.setPacketIdx(arg0, arg1)
	arg0.packetIdx = arg1
end

function var1.getPacketIdx(arg0)
	return arg0.packetIdx
end

function var1.incPacketIdx(arg0)
	arg0.packetIdx = arg0.packetIdx + 1
end

function var1.Queue(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	table.insert(arg0.toSends, {
		arg1,
		arg2,
		arg3,
		arg4 and function(arg0)
			table.remove(arg0.toSends, 1)
			arg4(arg0)

			if arg0 and arg0.result and arg0.result == 0 then
				var0.SeriesGuideMgr.GetInstance():receiceProtocol(arg3, arg2, arg0)
			end
		end,
		arg5,
		arg6,
		arg7
	})

	if arg0.isSending then
		return
	end

	arg0:StartSend()
end

function var1.StartSend(arg0)
	if #arg0.toSends > 0 then
		arg0:Send(unpack(arg0.toSends[1]))
	else
		warning("No more packets to send.")
	end
end

function var1.Send(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	arg0.isSending = true
	arg0.currentCS = arg1

	if arg0.connectionMgr:isConnecting() then
		arg0.connectionMgr.needStartSend = true

		return
	end

	local var0 = arg0.connectionMgr:getConnection()

	if not var0 then
		arg0.connectionMgr.needStartSend = true

		arg0.connectionMgr:Reconnect(function()
			return
		end)

		return
	end

	arg5 = defaultValue(arg5, true)
	arg6 = defaultValue(arg6, true)
	arg7 = defaultValue(arg7, SEND_TIMEOUT)

	local var1 = arg0:getPacketIdx()

	if arg3 ~= nil then
		var0.UIMgr.GetInstance():LoadingOn()

		local var2

		if arg5 then
			var2 = arg3 .. "_" .. var1
		else
			var2 = arg3
		end

		var2[var2] = function(arg0)
			arg0.isSending = false

			var0.UIMgr.GetInstance():LoadingOff()
			arg0.connectionMgr:resetHBTimer()

			if arg0.timer then
				arg0.timer:Stop()

				arg0.timer = nil
			end

			arg4(arg0)

			if arg6 and not arg0.isSending and #arg0.toSends > 0 then
				arg0:StartSend()
			end
		end
		arg0.timer = Timer.New(function()
			var0.UIMgr.GetInstance():LoadingOff()

			var2[var2] = nil

			arg0:setPacketIdx(var1)

			if arg0.retryCount > 3 then
				arg0.connectionMgr.onDisconnected(false, DISCONNECT_TIME_OUT)

				arg0.retryCount = 0
			end

			if PLATFORM_CODE == PLATFORM_CHT then
				arg0.connectionMgr.SwitchProxy()
			end

			warning("Network is timedOut, resend: " .. var1 .. ", protocal: " .. arg1)

			arg0.retryCount = arg0.retryCount + 1

			arg0:StartSend()
		end, arg7, 1)

		arg0.timer:Start()
	else
		arg5 = false
	end

	local var3 = var0.Packer.GetInstance():GetProtocolWithName("cs_" .. arg1)

	local function var4(arg0, arg1)
		for iter0, iter1 in pairs(arg1) do
			assert(arg0[iter0] ~= nil, "key does not exist: " .. iter0)

			if type(iter1) == "table" then
				for iter2, iter3 in ipairs(iter1) do
					if arg0[iter0].add then
						var4(arg0[iter0]:add(), iter3)
					else
						arg0[iter0]:append(iter3)
					end
				end
			else
				arg0[iter0] = iter1
			end
		end
	end

	local var5 = var3:GetMessage()

	var4(var5, arg2)

	if arg5 then
		var0:Send(var0.Packer.GetInstance():Pack(var1, var3:GetId(), var5))
		originalPrint("Network sent protocol: " .. arg1 .. " with idx: " .. var1)
		arg0:incPacketIdx()
	else
		var0:Send(var0.Packer.GetInstance():Pack(0, var3:GetId(), var5))
		originalPrint("Network sent protocol: " .. arg1 .. " without idx")
	end

	if not arg3 then
		table.remove(arg0.toSends, 1)

		if #arg0.toSends > 0 then
			arg0:StartSend()
		else
			arg0.isSending = false
		end
	end
end

function var1.stopTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var1.onData(arg0)
	originalPrint("Network Receive idx: " .. arg0.idx .. " cmd: " .. arg0.cmd)

	local var0 = var0.Packer.GetInstance():Unpack(arg0.cmd, arg0:getLuaStringBuffer())
	local var1 = arg0.cmd .. "_" .. arg0.idx

	if var2[var1] then
		local var2 = var2[var1]

		var2[var1] = nil

		var2(var0)
	elseif var2[arg0.cmd] then
		local var3 = var2[arg0.cmd]

		var2[arg0.cmd] = nil

		var3(var0)
	end
end

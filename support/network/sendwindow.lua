pg = pg or {}

local var0_0 = pg

var0_0.SendWindow = class("SendWindow")

local var1_0 = var0_0.SendWindow
local var2_0

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.connectionMgr = arg1_1
	arg0_1.packetIdx = defaultValue(arg2_1, 0)
	arg0_1.isSending = false
	arg0_1.toSends = {}
	arg0_1.retryCount = 0
	var2_0 = {}
end

function var1_0.setPacketIdx(arg0_2, arg1_2)
	arg0_2.packetIdx = arg1_2
end

function var1_0.getPacketIdx(arg0_3)
	return arg0_3.packetIdx
end

function var1_0.incPacketIdx(arg0_4)
	arg0_4.packetIdx = arg0_4.packetIdx + 1
end

function var1_0.Queue(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5, arg6_5, arg7_5)
	table.insert(arg0_5.toSends, {
		arg1_5,
		arg2_5,
		arg3_5,
		arg4_5 and function(arg0_6)
			table.remove(arg0_5.toSends, 1)
			arg4_5(arg0_6)

			if arg0_6 and arg0_6.result and arg0_6.result == 0 then
				var0_0.SeriesGuideMgr.GetInstance():receiceProtocol(arg3_5, arg2_5, arg0_6)
			end
		end,
		arg5_5,
		arg6_5,
		arg7_5
	})

	if arg0_5.isSending then
		return
	end

	arg0_5:StartSend()
end

function var1_0.RemoveLoginPacket(arg0_7)
	if #arg0_7.toSends > 0 and arg0_7.toSends[1][1] == 10022 then
		table.remove(arg0_7.toSends, 1)
	end
end

function var1_0.StartSend(arg0_8)
	if #arg0_8.toSends > 0 then
		arg0_8:Send(unpack(arg0_8.toSends[1]))
	else
		warning("No more packets to send.")
	end
end

function var1_0.Send(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9, arg7_9)
	arg0_9.isSending = true
	arg0_9.currentCS = arg1_9

	if arg0_9.connectionMgr:isConnecting() then
		arg0_9.connectionMgr.needStartSend = true

		return
	end

	local var0_9 = arg0_9.connectionMgr:getConnection()

	if not var0_9 then
		arg0_9.connectionMgr.needStartSend = true

		arg0_9.connectionMgr:Reconnect(function()
			return
		end)

		return
	end

	arg5_9 = defaultValue(arg5_9, true)
	arg6_9 = defaultValue(arg6_9, true)
	arg7_9 = defaultValue(arg7_9, SEND_TIMEOUT)

	local var1_9 = arg0_9:getPacketIdx()

	if arg3_9 ~= nil then
		var0_0.UIMgr.GetInstance():LoadingOn()

		local var2_9

		if arg5_9 then
			var2_9 = arg3_9 .. "_" .. var1_9
		else
			var2_9 = arg3_9
		end

		var2_0[var2_9] = function(arg0_11)
			arg0_9.isSending = false

			var0_0.UIMgr.GetInstance():LoadingOff()
			arg0_9.connectionMgr:resetHBTimer()

			if arg0_9.timer then
				arg0_9.timer:Stop()

				arg0_9.timer = nil
			end

			arg4_9(arg0_11)

			if arg6_9 and not arg0_9.isSending and #arg0_9.toSends > 0 then
				arg0_9:StartSend()
			end
		end
		arg0_9.timer = Timer.New(function()
			var0_0.UIMgr.GetInstance():LoadingOff()

			var2_0[var2_9] = nil

			arg0_9:setPacketIdx(var1_9)

			if arg0_9.retryCount > 3 then
				arg0_9.connectionMgr.onDisconnected(false, DISCONNECT_TIME_OUT)

				arg0_9.retryCount = 0
			end

			if PLATFORM_CODE == PLATFORM_CHT then
				arg0_9.connectionMgr.SwitchProxy()
			end

			warning("Network is timedOut, resend: " .. var1_9 .. ", protocal: " .. arg1_9)

			arg0_9.retryCount = arg0_9.retryCount + 1

			arg0_9:StartSend()
		end, arg7_9, 1)

		arg0_9.timer:Start()
	else
		arg5_9 = false
	end

	local var3_9 = var0_0.Packer.GetInstance():GetProtocolWithName("cs_" .. arg1_9)

	local function var4_9(arg0_13, arg1_13)
		for iter0_13, iter1_13 in pairs(arg1_13) do
			if type(iter1_13) == "table" then
				if arg0_13[iter0_13].add then
					for iter2_13, iter3_13 in ipairs(iter1_13) do
						var4_9(arg0_13[iter0_13]:add(), iter3_13)
					end
				elseif arg0_13[iter0_13].append then
					for iter4_13, iter5_13 in ipairs(iter1_13) do
						arg0_13[iter0_13]:append(iter5_13)
					end
				else
					var4_9(arg0_13[iter0_13], iter1_13)
				end
			else
				arg0_13[iter0_13] = iter1_13
			end
		end
	end

	local var5_9 = var3_9:GetMessage()

	var4_9(var5_9, arg2_9)

	if arg5_9 then
		var0_9:Send(var0_0.Packer.GetInstance():Pack(var1_9, var3_9:GetId(), var5_9))
		originalPrint("Network sent protocol: " .. arg1_9 .. " with idx: " .. var1_9)
		arg0_9:incPacketIdx()
	else
		var0_9:Send(var0_0.Packer.GetInstance():Pack(0, var3_9:GetId(), var5_9))
		originalPrint("Network sent protocol: " .. arg1_9 .. " without idx")
	end

	if not arg3_9 then
		table.remove(arg0_9.toSends, 1)

		if #arg0_9.toSends > 0 then
			arg0_9:StartSend()
		else
			arg0_9.isSending = false
		end
	end
end

function var1_0.stopTimer(arg0_14)
	if arg0_14.timer then
		arg0_14.timer:Stop()

		arg0_14.timer = nil
	end
end

function var1_0.onData(arg0_15)
	originalPrint("Network Receive idx: " .. arg0_15.idx .. " cmd: " .. arg0_15.cmd)

	local var0_15 = var0_0.Packer.GetInstance():Unpack(arg0_15.cmd, arg0_15:getLuaStringBuffer())
	local var1_15 = arg0_15.cmd .. "_" .. arg0_15.idx

	if var2_0[var1_15] then
		local var2_15 = var2_0[var1_15]

		var2_0[var1_15] = nil

		var2_15(var0_15)
	elseif var2_0[arg0_15.cmd] then
		local var3_15 = var2_0[arg0_15.cmd]

		var2_0[arg0_15.cmd] = nil

		var3_15(var0_15)
	end
end

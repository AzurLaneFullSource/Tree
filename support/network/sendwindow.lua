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

function var1_0.StartSend(arg0_7)
	if #arg0_7.toSends > 0 then
		arg0_7:Send(unpack(arg0_7.toSends[1]))
	else
		warning("No more packets to send.")
	end
end

function var1_0.Send(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8, arg6_8, arg7_8)
	arg0_8.isSending = true
	arg0_8.currentCS = arg1_8

	if arg0_8.connectionMgr:isConnecting() then
		arg0_8.connectionMgr.needStartSend = true

		return
	end

	local var0_8 = arg0_8.connectionMgr:getConnection()

	if not var0_8 then
		arg0_8.connectionMgr.needStartSend = true

		arg0_8.connectionMgr:Reconnect(function()
			return
		end)

		return
	end

	arg5_8 = defaultValue(arg5_8, true)
	arg6_8 = defaultValue(arg6_8, true)
	arg7_8 = defaultValue(arg7_8, SEND_TIMEOUT)

	local var1_8 = arg0_8:getPacketIdx()

	if arg3_8 ~= nil then
		var0_0.UIMgr.GetInstance():LoadingOn()

		local var2_8

		if arg5_8 then
			var2_8 = arg3_8 .. "_" .. var1_8
		else
			var2_8 = arg3_8
		end

		var2_0[var2_8] = function(arg0_10)
			arg0_8.isSending = false

			var0_0.UIMgr.GetInstance():LoadingOff()
			arg0_8.connectionMgr:resetHBTimer()

			if arg0_8.timer then
				arg0_8.timer:Stop()

				arg0_8.timer = nil
			end

			arg4_8(arg0_10)

			if arg6_8 and not arg0_8.isSending and #arg0_8.toSends > 0 then
				arg0_8:StartSend()
			end
		end
		arg0_8.timer = Timer.New(function()
			var0_0.UIMgr.GetInstance():LoadingOff()

			var2_0[var2_8] = nil

			arg0_8:setPacketIdx(var1_8)

			if arg0_8.retryCount > 3 then
				arg0_8.connectionMgr.onDisconnected(false, DISCONNECT_TIME_OUT)

				arg0_8.retryCount = 0
			end

			if PLATFORM_CODE == PLATFORM_CHT then
				arg0_8.connectionMgr.SwitchProxy()
			end

			warning("Network is timedOut, resend: " .. var1_8 .. ", protocal: " .. arg1_8)

			arg0_8.retryCount = arg0_8.retryCount + 1

			arg0_8:StartSend()
		end, arg7_8, 1)

		arg0_8.timer:Start()
	else
		arg5_8 = false
	end

	local var3_8 = var0_0.Packer.GetInstance():GetProtocolWithName("cs_" .. arg1_8)

	local function var4_8(arg0_12, arg1_12)
		for iter0_12, iter1_12 in pairs(arg1_12) do
			assert(arg0_12[iter0_12] ~= nil, "key does not exist: " .. iter0_12)

			if type(iter1_12) == "table" then
				for iter2_12, iter3_12 in ipairs(iter1_12) do
					if arg0_12[iter0_12].add then
						var4_8(arg0_12[iter0_12]:add(), iter3_12)
					else
						arg0_12[iter0_12]:append(iter3_12)
					end
				end
			else
				arg0_12[iter0_12] = iter1_12
			end
		end
	end

	local var5_8 = var3_8:GetMessage()

	var4_8(var5_8, arg2_8)

	if arg5_8 then
		var0_8:Send(var0_0.Packer.GetInstance():Pack(var1_8, var3_8:GetId(), var5_8))
		originalPrint("Network sent protocol: " .. arg1_8 .. " with idx: " .. var1_8)
		arg0_8:incPacketIdx()
	else
		var0_8:Send(var0_0.Packer.GetInstance():Pack(0, var3_8:GetId(), var5_8))
		originalPrint("Network sent protocol: " .. arg1_8 .. " without idx")
	end

	if not arg3_8 then
		table.remove(arg0_8.toSends, 1)

		if #arg0_8.toSends > 0 then
			arg0_8:StartSend()
		else
			arg0_8.isSending = false
		end
	end
end

function var1_0.stopTimer(arg0_13)
	if arg0_13.timer then
		arg0_13.timer:Stop()

		arg0_13.timer = nil
	end
end

function var1_0.onData(arg0_14)
	originalPrint("Network Receive idx: " .. arg0_14.idx .. " cmd: " .. arg0_14.cmd)

	local var0_14 = var0_0.Packer.GetInstance():Unpack(arg0_14.cmd, arg0_14:getLuaStringBuffer())
	local var1_14 = arg0_14.cmd .. "_" .. arg0_14.idx

	if var2_0[var1_14] then
		local var2_14 = var2_0[var1_14]

		var2_0[var1_14] = nil

		var2_14(var0_14)
	elseif var2_0[arg0_14.cmd] then
		local var3_14 = var2_0[arg0_14.cmd]

		var2_0[arg0_14.cmd] = nil

		var3_14(var0_14)
	end
end

local var0_0 = class("ServerStateChecker")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {
		true
	}

	seriesAsync({
		function(arg0_2)
			onNextTick(arg0_2)
		end,
		function(arg0_3)
			arg0_1:DoCheck(var0_1, arg0_3)
		end
	}, function()
		arg1_1(var0_1[1])
	end)
end

function var0_0.DoCheck(arg0_5, arg1_5, arg2_5)
	if IsUnityEditor then
		arg1_5[1] = false

		arg2_5()

		return
	end

	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10018, {
			arg = 0
		}, 10019, function(arg0_7)
			pg.ConnectionMgr.GetInstance():Disconnect()

			for iter0_7, iter1_7 in ipairs(arg0_7.serverlist or {}) do
				if iter1_7.state ~= Server.STATUS.VINDICATE then
					arg1_5[1] = false

					break
				end
			end

			arg2_5()
		end)
	end)
end

return var0_0

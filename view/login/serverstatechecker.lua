local var0 = class("ServerStateChecker")

function var0.Execute(arg0, arg1)
	local var0 = {
		true
	}

	seriesAsync({
		function(arg0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0:DoCheck(var0, arg0)
		end
	}, function()
		arg1(var0[1])
	end)
end

function var0.DoCheck(arg0, arg1, arg2)
	if IsUnityEditor then
		arg1[1] = false

		arg2()

		return
	end

	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function()
		pg.ConnectionMgr.GetInstance():Send(10018, {
			arg = 0
		}, 10019, function(arg0)
			pg.ConnectionMgr.GetInstance():Disconnect()

			for iter0, iter1 in ipairs(arg0.serverlist or {}) do
				if iter1.state ~= Server.STATUS.VINDICATE then
					arg1[1] = false

					break
				end
			end

			arg2()
		end)
	end)
end

return var0

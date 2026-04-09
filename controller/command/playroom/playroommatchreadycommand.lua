local var0_0 = class("PlayRoomMatchReadyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().arg

	getProxy(PlayRoomProxy):SetExitMatchFlag(var0_1)
	pg.ConnectionMgr.GetInstance():Send(23019, {
		ready = var0_1
	}, 23020, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end, false)
end

return var0_0

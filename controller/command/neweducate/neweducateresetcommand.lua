local var0_0 = class("NewEducateResetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(29007, {
		id = var2_1
	}, 29008, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):ResetChar(var2_1, arg0_2.tb)
			getProxy(NewEducateProxy):GetCurChar():GetFSM():SetStystemNo(NewEducateFSM.STYSTEM.INIT)
			existCall(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_Reset", arg0_2.result))
		end
	end)
end

return var0_0

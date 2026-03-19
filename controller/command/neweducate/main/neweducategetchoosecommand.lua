local var0_0 = class("NewEducateGetChooseCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(29126, {
		id = var1_1
	}, 29127, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():InitFSM(arg0_2.fsm)
			existCall(var2_1)
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_GetChoose: " .. arg0_2.result)
		end
	end)
end

return var0_0

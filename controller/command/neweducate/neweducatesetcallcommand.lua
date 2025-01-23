local var0_0 = class("NewEducateSetCallCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.name

	pg.ConnectionMgr.GetInstance():Send(29009, {
		id = var1_1,
		name = var2_1
	}, 29010, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():SetCallName(var2_1)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_SET_CALL_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_SetCall", arg0_2.result))
		end
	end)
end

return var0_0

local var0_0 = class("EducateSetCallCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27031, {
		name = var0_1.name
	}, 27032, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):GetCharData():SetCallName(var0_1.name)
			arg0_1:sendNotification(GAME.EDUCATE_SET_CALL_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate set call name error: ", arg0_2.result))
		end
	end)
end

return var0_0

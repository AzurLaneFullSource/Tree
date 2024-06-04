local var0 = class("EducateSetCallCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27031, {
		name = var0.name
	}, 27032, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):GetCharData():SetCallName(var0.name)
			arg0:sendNotification(GAME.EDUCATE_SET_CALL_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate set call name error: ", arg0.result))
		end
	end)
end

return var0

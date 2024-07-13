local var0_0 = class("EducateAddExtraAttrCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27039, {
		attr_id = var0_1.id
	}, 27040, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(EducateProxy):AddExtraAttr(var0_1.id)
			arg0_1:sendNotification(GAME.EDUCATE_ADD_EXTRA_ATTR_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate add extra attr error: ", arg0_2.result))
		end
	end)
end

return var0_0

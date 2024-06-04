local var0 = class("EducateAddExtraAttrCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27039, {
		attr_id = var0.id
	}, 27040, function(arg0)
		if arg0.result == 0 then
			getProxy(EducateProxy):AddExtraAttr(var0.id)
			arg0:sendNotification(GAME.EDUCATE_ADD_EXTRA_ATTR_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate add extra attr error: ", arg0.result))
		end
	end)
end

return var0

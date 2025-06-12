local var0_0 = class("Dorm3dInsPhoneOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(Dorm3dInsProxy):GetPhoneListByGroup(var0_1.groupId)
	local var2_1 = _.detect(var1_1, function(arg0_2)
		return arg0_2.id == var0_1.id
	end)

	if not var2_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28026, {
		type = 2,
		ship_id = var0_1.groupId,
		id_list = {
			var0_1.id
		}
	}, 28027, function(arg0_3)
		if arg0_3.result == 0 then
			var2_1:MarkRead()
			arg0_1:sendNotification(GAME.DORM3D_INS_PHONE_OP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0

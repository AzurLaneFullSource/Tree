local var0_0 = class("DormSetCallCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	local var2_1 = getProxy(ApartmentProxy)
	local var3_1 = var2_1:getApartment(var0_1.groupId)

	if var3_1:GetSetCallCd() > 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28021, {
		ship_group = var0_1.groupId,
		name = var0_1.callName
	}, 28022, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1 = var2_1:getApartment(var0_1.groupId)
			var3_1.callName = var0_1.callName
			var3_1.setCallCd = pg.TimeMgr.GetInstance():GetServerTime() + 172800

			var2_1:updateApartment(var3_1)
			arg0_1:sendNotification(GAME.DORM_SET_CALL_DONE, {
				apartment = var3_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("dorm3d set call name error: ", arg0_2.result))
		end
	end)
end

return var0_0

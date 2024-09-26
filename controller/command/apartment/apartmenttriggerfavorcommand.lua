local var0_0 = class("ApartmentTriggerFavorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.triggerId
	local var3_1 = getProxy(ApartmentProxy)
	local var4_1 = var3_1:getApartment(var1_1)
	local var5_1 = pg.dorm3d_favor_trigger[var2_1]

	if var5_1.is_repeat == 0 and var4_1.triggerCountDic[var2_1] > 0 or var3_1.stamina < var5_1.is_daily_max then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28003, {
		ship_group = var1_1,
		trigger_id = var2_1
	}, 28004, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2, var1_2 = var3_1:triggerFavor(var1_1, var2_1)

			arg0_1:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR_DONE, {
				triggerId = var2_1,
				cost = var1_2,
				delta = var0_2,
				apartment = var4_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0

local var0 = class("ApartmentTriggerFavorCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.triggerId
	local var3 = getProxy(ApartmentProxy)
	local var4 = var3:getApartment(var1)

	if pg.dorm3d_favor_trigger[var2].is_repeat > 0 then
		if var4.daily >= getDorm3dGameset("daily_exp_max")[1] then
			return
		end
	elseif var4.triggerCountDic[var2] > 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28003, {
		ship_group = var1,
		trigger_id = var2
	}, 28004, function(arg0)
		if arg0.result == 0 then
			var4 = var3:getApartment(var1)

			local var0 = var4:addFavor(var2)

			var3:updateApartment(var4)
			arg0:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR_DONE, {
				triggerId = var2,
				delta = var0,
				apartment = var4
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0

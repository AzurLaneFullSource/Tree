local var0 = class("ApartmentLevelUpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.triggerId
	local var3 = getProxy(ApartmentProxy)
	local var4 = var3:getApartment(var1)

	if var4.level >= getDorm3dGameset("favor_level")[1] or var4.favor < var4:getNextExp() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28005, {
		ship_group = var1
	}, 28006, function(arg0)
		if arg0.result == 0 then
			var4 = var3:getApartment(var1)

			var4:addLevel()
			var3:updateApartment(var4)
			arg0:sendNotification(GAME.APARTMENT_LEVEL_UP_DONE, var4)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0

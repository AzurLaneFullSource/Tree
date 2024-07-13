local var0_0 = class("ApartmentLevelUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.triggerId
	local var3_1 = getProxy(ApartmentProxy)
	local var4_1 = var3_1:getApartment(var1_1)

	if var4_1.level >= getDorm3dGameset("favor_level")[1] or var4_1.favor < var4_1:getNextExp() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28005, {
		ship_group = var1_1
	}, 28006, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1 = var3_1:getApartment(var1_1)

			var4_1:addLevel()
			var3_1:updateApartment(var4_1)
			arg0_1:sendNotification(GAME.APARTMENT_LEVEL_UP_DONE, var4_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0

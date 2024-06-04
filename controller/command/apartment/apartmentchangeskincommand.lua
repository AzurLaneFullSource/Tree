local var0 = class("ApartmentChangeSkinCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.skinId
	local var3 = getProxy(ApartmentProxy)
	local var4 = var3:getApartment(var1)

	if var2 == var4:getConfig("skin_model") then
		var2 = 0
	end

	if var4.skinId == var2 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(28013, {
		ship_group = var1,
		skin = var2
	}, 28014, function(arg0)
		if arg0.result == 0 then
			var4 = var3:getApartment(var1)
			var4.skinId = var2

			var3:updateApartment(var4)
			arg0:sendNotification(GAME.APARTMENT_CHANGE_SKIN_DONE, var4)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0

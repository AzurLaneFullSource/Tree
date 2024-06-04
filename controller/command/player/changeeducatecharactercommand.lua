local var0 = class("ChangeEducateCharacterCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(PlayerProxy):getRawData():GetEducateCharacter()

	pg.ConnectionMgr.GetInstance():Send(27041, {
		ending_id = var0
	}, 27042, function(arg0)
		if arg0.result == 0 then
			if var0 > 0 and var1 and pg.secretary_special_ship[var1] then
				local var0 = pg.secretary_special_ship[var1].group

				if var0 == pg.secretary_special_ship[var0].group and var0 == 1000 then
					getProxy(PlayerProxy):setFlag("change_tb", true)
				end
			end

			local var1 = getProxy(PlayerProxy)
			local var2 = var1:getData()

			var2:SetEducateCharacter(var0)
			var1:updatePlayer(var2)
			arg0:sendNotification(GAME.CHANGE_EDUCATE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0

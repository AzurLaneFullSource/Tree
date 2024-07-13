local var0_0 = class("ChangeEducateCharacterCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(PlayerProxy):getRawData():GetEducateCharacter()

	pg.ConnectionMgr.GetInstance():Send(27041, {
		ending_id = var0_1
	}, 27042, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1 > 0 and var1_1 and pg.secretary_special_ship[var1_1] then
				local var0_2 = pg.secretary_special_ship[var1_1].group

				if var0_2 == pg.secretary_special_ship[var0_1].group and var0_2 == 1000 then
					getProxy(PlayerProxy):setFlag("change_tb", true)
				end
			end

			local var1_2 = getProxy(PlayerProxy)
			local var2_2 = var1_2:getData()

			var2_2:SetEducateCharacter(var0_1)
			var1_2:updatePlayer(var2_2)
			arg0_1:sendNotification(GAME.CHANGE_EDUCATE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0

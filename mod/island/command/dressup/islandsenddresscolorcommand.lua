local var0_0 = class("IslandSendDressColorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.dress_id
	local var3_1 = var0_1.color_id
	local var4_1 = getProxy(IslandProxy):GetIsland()

	pg.ConnectionMgr.GetInstance():Send(21628, {
		id = var1_1,
		dress_id = var2_1,
		color_id = var3_1
	}, 21629, function(arg0_2)
		if arg0_2.result == 0 then
			if var1_1 == 0 then
				var4_1:GetDressUpAgency():AddDressColor(var2_1, var3_1)
			end

			arg0_1:sendNotification(GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0

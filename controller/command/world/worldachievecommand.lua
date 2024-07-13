local var0_0 = class("WorldAchieveCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33602, var0_1, 33603, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drops)
			local var1_2 = nowWorld()

			for iter0_2, iter1_2 in ipairs(var0_1.list) do
				local var2_2 = var1_2:GetMap(iter1_2.id)

				for iter2_2, iter3_2 in ipairs(iter1_2.star_list) do
					var1_2:SetAchieveSuccess(iter1_2.id, iter3_2)
				end
			end

			var1_2:DispatchEvent(World.EventAchieved)
			arg0_1:sendNotification(GAME.WORLD_ACHIEVE_DONE, {
				list = var0_1.list,
				drops = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_achieve_error_", arg0_2.result))
		end
	end)
end

return var0_0

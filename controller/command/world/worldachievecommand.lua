local var0 = class("WorldAchieveCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(33602, var0, 33603, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drops)
			local var1 = nowWorld()

			for iter0, iter1 in ipairs(var0.list) do
				local var2 = var1:GetMap(iter1.id)

				for iter2, iter3 in ipairs(iter1.star_list) do
					var1:SetAchieveSuccess(iter1.id, iter3)
				end
			end

			var1:DispatchEvent(World.EventAchieved)
			arg0:sendNotification(GAME.WORLD_ACHIEVE_DONE, {
				list = var0.list,
				drops = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_achieve_error_", arg0.result))
		end
	end)
end

return var0

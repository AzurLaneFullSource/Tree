local var0 = class("WorldBossOverTimeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = nowWorld().worldBossProxy
	local var2 = var1:GetSelfBoss()

	if var2 and var2:IsExpired() then
		if var2:isDeath() then
			arg0:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD, {
				bossId = var2.id
			})
		else
			pg.ConnectionMgr.GetInstance():Send(34513, {
				type = 0
			}, 34514, function(arg0)
				if arg0.result == 0 then
					-- block empty
				end
			end)
		end

		var1:ClearRank(var2.id)
		var1:RemoveSelfBoss()
		arg0:sendNotification(GAME.WORLD_SELF_BOSS_OVERTIME_DONE)
	end
end

return var0

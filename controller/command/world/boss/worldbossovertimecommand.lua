local var0_0 = class("WorldBossOverTimeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = nowWorld().worldBossProxy
	local var2_1 = var1_1:GetSelfBoss()

	if var2_1 and var2_1:IsExpired() then
		if var2_1:isDeath() then
			arg0_1:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD, {
				bossId = var2_1.id
			})
		else
			pg.ConnectionMgr.GetInstance():Send(34513, {
				type = 0
			}, 34514, function(arg0_2)
				if arg0_2.result == 0 then
					-- block empty
				end
			end)
		end

		var1_1:ClearRank(var2_1.id)
		var1_1:RemoveSelfBoss()
		arg0_1:sendNotification(GAME.WORLD_SELF_BOSS_OVERTIME_DONE)
	end
end

return var0_0

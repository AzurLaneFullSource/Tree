local var0_0 = class("GetWorldBossCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = (arg1_1:getBody() or {}).callback
	local var1_1 = nowWorld()

	if not var1_1.worldBossProxy then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(34501, {
		type = 0
	}, 34502, function(arg0_2)
		local var0_2 = var1_1.worldBossProxy

		var0_2:Setup(arg0_2)
		arg0_1:sendNotification(GAME.WORLD_GET_BOSS_DONE)

		if not var0_2:IsOpen() and var0_2:GetSelfBoss() ~= nil then
			originalPrint("Notification : boss is overtime")
			pg.ConnectionMgr.GetInstance():Send(34513, {
				type = 0
			}, 34514, function(arg0_3)
				return
			end)
		end

		if var0_1 then
			var0_1()
		end
	end)
end

return var0_0

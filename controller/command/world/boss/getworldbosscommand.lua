local var0 = class("GetWorldBossCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = (arg1:getBody() or {}).callback
	local var1 = nowWorld()

	if not var1.worldBossProxy then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(34501, {
		type = 0
	}, 34502, function(arg0)
		local var0 = var1.worldBossProxy

		var0:Setup(arg0)
		arg0:sendNotification(GAME.WORLD_GET_BOSS_DONE)

		if not var0:IsOpen() and var0:GetSelfBoss() ~= nil then
			originalPrint("Notification : boss is overtime")
			pg.ConnectionMgr.GetInstance():Send(34513, {
				type = 0
			}, 34514, function(arg0)
				return
			end)
		end

		if var0 then
			var0()
		end
	end)
end

return var0

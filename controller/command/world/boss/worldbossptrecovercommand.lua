local var0 = class("WorldBossPtRecoverCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = nowWorld():GetBossProxy()

	if var0:isMaxPt() then
		return
	end

	local var1 = var0:GetNextReconveTime()
	local var2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3 = var0:GetRecoverPtTime()

	if var1 <= var2 then
		local var4 = var2 - var1

		var0:increasePt()

		if not var0:isMaxPt() then
			while var3 <= var4 do
				var0:increasePt()

				var4 = var4 - var3
			end

			local var5 = var2 + (var3 - var4)

			var0:updatePtTime(var5)
		end
	end

	arg0:sendNotification(GAME.WORLD_BOSS_PT_RECOVER_DONE)
end

return var0

local var0_0 = class("WorldBossPtRecoverCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = nowWorld():GetBossProxy()

	if var0_1:isMaxPt() then
		return
	end

	local var1_1 = var0_1:GetNextReconveTime()
	local var2_1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_1 = var0_1:GetRecoverPtTime()

	if var1_1 <= var2_1 then
		local var4_1 = var2_1 - var1_1

		var0_1:increasePt()

		if not var0_1:isMaxPt() then
			while var3_1 <= var4_1 do
				var0_1:increasePt()

				var4_1 = var4_1 - var3_1
			end

			local var5_1 = var2_1 + (var3_1 - var4_1)

			var0_1:updatePtTime(var5_1)
		end
	end

	arg0_1:sendNotification(GAME.WORLD_BOSS_PT_RECOVER_DONE)
end

return var0_0

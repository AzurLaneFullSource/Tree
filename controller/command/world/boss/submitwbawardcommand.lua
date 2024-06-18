local var0_0 = class("SubmitWBAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().bossId
	local var1_1 = nowWorld():GetBossProxy()

	pg.ConnectionMgr.GetInstance():Send(34511, {
		boss_id = var0_1
	}, 34512, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drops)

			var1_1:RemoveSelfBoss()
			var1_1:ClearRank(var0_1)
			arg0_1:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD_DONE, {
				items = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n1("领取失败") .. arg0_2.result)
		end
	end)
end

return var0_0

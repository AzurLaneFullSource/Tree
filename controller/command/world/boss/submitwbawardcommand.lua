local var0 = class("SubmitWBAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().bossId
	local var1 = nowWorld():GetBossProxy()

	pg.ConnectionMgr.GetInstance():Send(34511, {
		boss_id = var0
	}, 34512, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drops)

			var1:RemoveSelfBoss()
			var1:ClearRank(var0)
			arg0:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD_DONE, {
				items = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n1("领取失败") .. arg0.result)
		end
	end)
end

return var0

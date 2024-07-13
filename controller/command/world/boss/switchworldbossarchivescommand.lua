local var0_0 = class("SwitchWorldBossArchivesCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(34527, {
		boss_id = var0_1
	}, 34528, function(arg0_2)
		if arg0_2.result == 0 then
			nowWorld():GetBossProxy():SetArchivesId(var0_1)
			arg0_1:sendNotification(GAME.SWITCH_WORLD_BOSS_ARCHIVES_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0

local var0 = class("SwitchWorldBossArchivesCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(34527, {
		boss_id = var0
	}, 34528, function(arg0)
		if arg0.result == 0 then
			nowWorld():GetBossProxy():SetArchivesId(var0)
			arg0:sendNotification(GAME.SWITCH_WORLD_BOSS_ARCHIVES_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0

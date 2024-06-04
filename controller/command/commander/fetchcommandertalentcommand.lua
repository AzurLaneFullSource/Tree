local var0 = class("FetchCommanderTalentCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(CommanderProxy)
	local var2 = var1:getCommanderById(var0)

	if not var2 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25010, {
		commanderid = var0
	}, 25011, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.abilityid) do
				table.insert(var0, CommanderTalent.New({
					origin = false,
					id = iter1
				}))
			end

			var2:updateNotLearnedList(var0)
			var1:updateCommander(var2)
			arg0:sendNotification(GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE, {
				commander = var2,
				list = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_get_skills_done") .. arg0.result .. "-" .. var0)
		end
	end)
end

return var0

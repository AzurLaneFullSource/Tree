local var0_0 = class("FetchCommanderTalentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(CommanderProxy)
	local var2_1 = var1_1:getCommanderById(var0_1)

	if not var2_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25010, {
		commanderid = var0_1
	}, 25011, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.abilityid) do
				table.insert(var0_2, CommanderTalent.New({
					origin = false,
					id = iter1_2
				}))
			end

			var2_1:updateNotLearnedList(var0_2)
			var1_1:updateCommander(var2_1)
			arg0_1:sendNotification(GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE, {
				commander = var2_1,
				list = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_get_skills_done") .. arg0_2.result .. "-" .. var0_1)
		end
	end)
end

return var0_0

local var0 = class("CommanderLearnTalentCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.talentId
	local var3 = var0.replaceid or 0
	local var4 = getProxy(CommanderProxy)
	local var5 = var4:getCommanderById(var1)

	if not var5 then
		return
	end

	local var6 = var5:getNotLearnedList()

	if not _.any(var6, function(arg0)
		return arg0.id == var2
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_talent_not_exist"))

		return
	end

	local var7 = var5:getTalents()

	if var3 ~= 0 and not _.any(var7, function(arg0)
		return arg0.id == var3
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_replace_talent_not_exist"))

		return
	end

	local var8 = CommanderTalent.New({
		id = var2
	})
	local var9 = var8:getConfig("cost")
	local var10 = getProxy(PlayerProxy)
	local var11 = var10:getData()

	if var9 > var11.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25012, {
		commanderid = var1,
		targetid = var2,
		replaceid = var3
	}, 25013, function(arg0)
		if arg0.result == 0 then
			var11:consume({
				gold = var9
			})
			var10:updatePlayer(var11)

			local var0 = var5:getSameGroupTalent(var8.groupId)

			if var0 then
				var5:deleteTablent(var0.id)
			end

			if var3 ~= 0 then
				var5:deleteTablent(var3)
			end

			var5:addTalent(var8)
			var5:updatePt(var5.pt + 1)
			var5:updateNotLearnedList({})
			var4:updateCommander(var5)
			arg0:sendNotification(GAME.COMMANDER_LEARN_TALENTS_DONE, {
				commander = var5
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_talent_learned", var8:getConfig("name")))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_talent_learn_erro", arg0.result))
		end
	end)
end

return var0

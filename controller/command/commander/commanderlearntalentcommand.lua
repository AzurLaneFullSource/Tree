local var0_0 = class("CommanderLearnTalentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.talentId
	local var3_1 = var0_1.replaceid or 0
	local var4_1 = getProxy(CommanderProxy)
	local var5_1 = var4_1:getCommanderById(var1_1)

	if not var5_1 then
		return
	end

	local var6_1 = var5_1:getNotLearnedList()

	if not _.any(var6_1, function(arg0_2)
		return arg0_2.id == var2_1
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_talent_not_exist"))

		return
	end

	local var7_1 = var5_1:getTalents()

	if var3_1 ~= 0 and not _.any(var7_1, function(arg0_3)
		return arg0_3.id == var3_1
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_replace_talent_not_exist"))

		return
	end

	local var8_1 = CommanderTalent.New({
		id = var2_1
	})
	local var9_1 = var8_1:getConfig("cost")
	local var10_1 = getProxy(PlayerProxy)
	local var11_1 = var10_1:getData()

	if var9_1 > var11_1.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25012, {
		commanderid = var1_1,
		targetid = var2_1,
		replaceid = var3_1
	}, 25013, function(arg0_4)
		if arg0_4.result == 0 then
			var11_1:consume({
				gold = var9_1
			})
			var10_1:updatePlayer(var11_1)

			local var0_4 = var5_1:getSameGroupTalent(var8_1.groupId)

			if var0_4 then
				var5_1:deleteTablent(var0_4.id)
			end

			if var3_1 ~= 0 then
				var5_1:deleteTablent(var3_1)
			end

			var5_1:addTalent(var8_1)
			var5_1:updatePt(var5_1.pt + 1)
			var5_1:updateNotLearnedList({})
			var4_1:updateCommander(var5_1)
			arg0_1:sendNotification(GAME.COMMANDER_LEARN_TALENTS_DONE, {
				commander = var5_1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_talent_learned", var8_1:getConfig("name")))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_talent_learn_erro", arg0_4.result))
		end
	end)
end

return var0_0

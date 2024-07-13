local var0_0 = class("ResetCommanderTalentsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(CommanderProxy)
	local var2_1 = var1_1:getCommanderById(var0_1)

	if not var2_1 then
		return
	end

	if pg.TimeMgr.GetInstance():GetServerTime() < var2_1:GetNextResetAbilityTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_time_no_rearch"))

		return
	end

	local var3_1 = var2_1:getTalentOrigins()
	local var4_1 = var2_1:getTalents()

	if #var3_1 == #var4_1 and _.all(var3_1, function(arg0_2)
		return _.any(var4_1, function(arg0_3)
			return arg0_3.id == arg0_2.id
		end)
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_is_not_need"))

		return
	end

	local var5_1 = getProxy(PlayerProxy)
	local var6_1 = var5_1:getData()
	local var7_1 = var2_1:getResetTalentConsume()

	if var7_1 > var6_1.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25014, {
		commanderid = var0_1
	}, 25015, function(arg0_4)
		if arg0_4.result == 0 then
			var6_1:consume({
				gold = var7_1
			})
			var5_1:updatePlayer(var6_1)
			var2_1:resetTalents()
			var2_1:updatePt(0)
			var2_1:updateNotLearnedList({})
			var1_1:updateCommander(var2_1)
			var2_1:updateAbilityTime(pg.TimeMgr.GetInstance():GetServerTime())
			arg0_1:sendNotification(GAME.COMMANDER_RESET_TALENTS_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_erro", arg0_4.result))
		end
	end)
end

return var0_0

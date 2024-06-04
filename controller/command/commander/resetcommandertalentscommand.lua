local var0 = class("ResetCommanderTalentsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(CommanderProxy)
	local var2 = var1:getCommanderById(var0)

	if not var2 then
		return
	end

	if pg.TimeMgr.GetInstance():GetServerTime() < var2:GetNextResetAbilityTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_time_no_rearch"))

		return
	end

	local var3 = var2:getTalentOrigins()
	local var4 = var2:getTalents()

	if #var3 == #var4 and _.all(var3, function(arg0)
		return _.any(var4, function(arg0)
			return arg0.id == arg0.id
		end)
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_is_not_need"))

		return
	end

	local var5 = getProxy(PlayerProxy)
	local var6 = var5:getData()
	local var7 = var2:getResetTalentConsume()

	if var7 > var6.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25014, {
		commanderid = var0
	}, 25015, function(arg0)
		if arg0.result == 0 then
			var6:consume({
				gold = var7
			})
			var5:updatePlayer(var6)
			var2:resetTalents()
			var2:updatePt(0)
			var2:updateNotLearnedList({})
			var1:updateCommander(var2)
			var2:updateAbilityTime(pg.TimeMgr.GetInstance():GetServerTime())
			arg0:sendNotification(GAME.COMMANDER_RESET_TALENTS_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_erro", arg0.result))
		end
	end)
end

return var0

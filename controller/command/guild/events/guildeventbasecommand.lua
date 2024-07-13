local var0_0 = class("GuildEventBaseCommand", pm.SimpleCommand)

function var0_0.ExistGuild(arg0_1)
	if not getProxy(GuildProxy):getRawData() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_not_exist"))

		return false
	end

	return true
end

function var0_0.ExistEvent(arg0_2, arg1_2)
	if not getProxy(GuildProxy):getRawData():GetEventById(arg1_2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_not_exist_battle"))

		return false
	end

	return true
end

function var0_0.ExistActiveEvent(arg0_3)
	if not arg0_3:ExistGuild() then
		return false
	end

	local var0_3 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	if not var0_3 or var0_3 and var0_3:IsExpired() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

		return false
	end

	return true
end

function var0_0.NotExistActiveEvent(arg0_4)
	if getProxy(GuildProxy):getRawData():GetActiveEvent() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_exist"))

		return false
	end

	return true
end

function var0_0.ExistMission(arg0_5, arg1_5)
	if not arg0_5:ExistActiveEvent() then
		return false
	end

	local var0_5 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	if arg1_5 and var0_5:GetMissionById(arg1_5) == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_not_exist"))

		return false
	end

	return true
end

function var0_0.GetMissionById(arg0_6, arg1_6)
	if arg0_6:ExistMission(arg1_6) then
		return getProxy(GuildProxy):getRawData():GetActiveEvent():GetMissionById(arg1_6)
	end
end

function var0_0.CanFormationMission(arg0_7, arg1_7)
	if not arg0_7:ExistMission(arg1_7) then
		return false
	end

	if getProxy(GuildProxy):getRawData():GetActiveEvent():GetMissionById(arg1_7):GetCanFormationIndex() == -1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fleet_can_not_edit"))

		return false
	end

	return true
end

function var0_0.ExistBoss(arg0_8)
	if not arg0_8:ExistActiveEvent() then
		return false
	end

	local var0_8 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()

	if not var0_8 or not var0_8:IsActive() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_not_exist_boss"))

		return false
	end

	return true
end

function var0_0.IsAnim(arg0_9)
	local var0_9 = getProxy(GuildProxy):getRawData()

	if not GuildMember.IsAdministrator(var0_9:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return false
	end

	return true
end

function var0_0.CheckCapital(arg0_10, arg1_10, arg2_10)
	if getProxy(GuildProxy):getRawData():getCapital() < arg1_10:GetConsume() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_guildgold_no_enough_for_battle"))

		return false
	end

	return true
end

return var0_0

local var0 = class("GuildEventBaseCommand", pm.SimpleCommand)

function var0.ExistGuild(arg0)
	if not getProxy(GuildProxy):getRawData() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_not_exist"))

		return false
	end

	return true
end

function var0.ExistEvent(arg0, arg1)
	if not getProxy(GuildProxy):getRawData():GetEventById(arg1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_not_exist_battle"))

		return false
	end

	return true
end

function var0.ExistActiveEvent(arg0)
	if not arg0:ExistGuild() then
		return false
	end

	local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	if not var0 or var0 and var0:IsExpired() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

		return false
	end

	return true
end

function var0.NotExistActiveEvent(arg0)
	if getProxy(GuildProxy):getRawData():GetActiveEvent() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_exist"))

		return false
	end

	return true
end

function var0.ExistMission(arg0, arg1)
	if not arg0:ExistActiveEvent() then
		return false
	end

	local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	if arg1 and var0:GetMissionById(arg1) == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_not_exist"))

		return false
	end

	return true
end

function var0.GetMissionById(arg0, arg1)
	if arg0:ExistMission(arg1) then
		return getProxy(GuildProxy):getRawData():GetActiveEvent():GetMissionById(arg1)
	end
end

function var0.CanFormationMission(arg0, arg1)
	if not arg0:ExistMission(arg1) then
		return false
	end

	if getProxy(GuildProxy):getRawData():GetActiveEvent():GetMissionById(arg1):GetCanFormationIndex() == -1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fleet_can_not_edit"))

		return false
	end

	return true
end

function var0.ExistBoss(arg0)
	if not arg0:ExistActiveEvent() then
		return false
	end

	local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()

	if not var0 or not var0:IsActive() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_not_exist_boss"))

		return false
	end

	return true
end

function var0.IsAnim(arg0)
	local var0 = getProxy(GuildProxy):getRawData()

	if not GuildMember.IsAdministrator(var0:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return false
	end

	return true
end

function var0.CheckCapital(arg0, arg1, arg2)
	if getProxy(GuildProxy):getRawData():getCapital() < arg1:GetConsume() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_guildgold_no_enough_for_battle"))

		return false
	end

	return true
end

return var0

local var0 = class("GuildMember", import("..Friend"))
local var1 = {
	i18n("guild_word_commder"),
	i18n("guild_word_deputy_commder"),
	i18n("guild_word_picked"),
	i18n("guild_word_ordinary")
}

function var0.IsAdministrator(arg0)
	return arg0 == GuildConst.DUTY_COMMANDER or arg0 == GuildConst.DUTY_DEPUTY_COMMANDER
end

function var0.isCommander(arg0)
	return arg0 == GuildConst.DUTY_COMMANDER
end

function var0.dutyId2Name(arg0)
	return var1[arg0]
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.liveness = arg1.liveness or 0
	arg0.duty = arg1.duty or GuildConst.DUTY_RECRUIT
	arg0.joinTime = arg1.join_time or 0
	arg0.assaultFleet = GuildAssaultFleet.New({
		user_id = arg0.id
	})
	arg0.externalAssaultFleet = GuildAssaultFleet.New({
		user_id = arg0.id
	})

	if arg0.icon == 1 then
		arg0.icon = 101171
	end
end

function var0.GetLiveness(arg0)
	return arg0.liveness
end

function var0.IsRecruit(arg0)
	return arg0.duty == GuildConst.DUTY_RECRUIT
end

function var0.AddLiveness(arg0, arg1)
	print("add member liveness", arg1)

	arg0.liveness = arg0.liveness + arg1

	if arg0:CanUpgradeDuty() then
		arg0.duty = arg0.duty - 1
	end
end

function var0.CanUpgradeDuty(arg0)
	return arg0.duty == GuildConst.DUTY_RECRUIT and arg0.liveness >= pg.guildset.guild_active_become_regular.key_value
end

function var0.UpdateExternalAssaultFleet(arg0, arg1)
	arg0.externalAssaultFleet = arg1
end

function var0.GetExternalAssaultFleet(arg0)
	return arg0.externalAssaultFleet
end

function var0.UpdateAssaultFleet(arg0, arg1)
	arg0.assaultFleet = arg1
end

function var0.GetAssaultFleet(arg0)
	return arg0.assaultFleet
end

function var0.UpdateAssaultFleetShips(arg0, arg1, arg2)
	arg0.assaultFleet:InitShips(arg1, arg2)
end

function var0.UpdateExternalAssaultFleetShips(arg0, arg1, arg2)
	arg0.externalAssaultFleet:InitShips(arg1, arg2)
end

function var0.isNewMember(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:GetServerTime()

	if arg0.joinTime ~= 0 and var0:IsSameDay(var1, arg0.joinTime) then
		return true
	end

	return false
end

function var0.setDuty(arg0, arg1)
	arg0.duty = arg1
end

function var0.GetDuty(arg0)
	return arg0.duty
end

function var0.IsCommander(arg0)
	return arg0.duty == GuildConst.DUTY_COMMANDER
end

function var0.isLongOffLine(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() - arg0.preOnLineTime > 864000
end

function var0.setDamage(arg0, arg1)
	arg0.damage = arg1
end

function var0.getDamage(arg0)
	if arg0.damage then
		return arg0.damage
	end

	return 0
end

function var0.GetShip(arg0)
	return Ship.New({
		configId = arg0.icon,
		skin_id = arg0.skinId,
		name = arg0.name
	})
end

function var0.GetJoinZeroTime(arg0)
	return pg.TimeMgr:GetInstance():GetNextTimeByTimeStamp(arg0.joinTime)
end

return var0

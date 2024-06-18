local var0_0 = class("GuildMember", import("..Friend"))
local var1_0 = {
	i18n("guild_word_commder"),
	i18n("guild_word_deputy_commder"),
	i18n("guild_word_picked"),
	i18n("guild_word_ordinary")
}

function var0_0.IsAdministrator(arg0_1)
	return arg0_1 == GuildConst.DUTY_COMMANDER or arg0_1 == GuildConst.DUTY_DEPUTY_COMMANDER
end

function var0_0.isCommander(arg0_2)
	return arg0_2 == GuildConst.DUTY_COMMANDER
end

function var0_0.dutyId2Name(arg0_3)
	return var1_0[arg0_3]
end

function var0_0.Ctor(arg0_4, arg1_4)
	var0_0.super.Ctor(arg0_4, arg1_4)

	arg0_4.liveness = arg1_4.liveness or 0
	arg0_4.duty = arg1_4.duty or GuildConst.DUTY_RECRUIT
	arg0_4.joinTime = arg1_4.join_time or 0
	arg0_4.assaultFleet = GuildAssaultFleet.New({
		user_id = arg0_4.id
	})
	arg0_4.externalAssaultFleet = GuildAssaultFleet.New({
		user_id = arg0_4.id
	})

	if arg0_4.icon == 1 then
		arg0_4.icon = 101171
	end
end

function var0_0.GetLiveness(arg0_5)
	return arg0_5.liveness
end

function var0_0.IsRecruit(arg0_6)
	return arg0_6.duty == GuildConst.DUTY_RECRUIT
end

function var0_0.AddLiveness(arg0_7, arg1_7)
	print("add member liveness", arg1_7)

	arg0_7.liveness = arg0_7.liveness + arg1_7

	if arg0_7:CanUpgradeDuty() then
		arg0_7.duty = arg0_7.duty - 1
	end
end

function var0_0.CanUpgradeDuty(arg0_8)
	return arg0_8.duty == GuildConst.DUTY_RECRUIT and arg0_8.liveness >= pg.guildset.guild_active_become_regular.key_value
end

function var0_0.UpdateExternalAssaultFleet(arg0_9, arg1_9)
	arg0_9.externalAssaultFleet = arg1_9
end

function var0_0.GetExternalAssaultFleet(arg0_10)
	return arg0_10.externalAssaultFleet
end

function var0_0.UpdateAssaultFleet(arg0_11, arg1_11)
	arg0_11.assaultFleet = arg1_11
end

function var0_0.GetAssaultFleet(arg0_12)
	return arg0_12.assaultFleet
end

function var0_0.UpdateAssaultFleetShips(arg0_13, arg1_13, arg2_13)
	arg0_13.assaultFleet:InitShips(arg1_13, arg2_13)
end

function var0_0.UpdateExternalAssaultFleetShips(arg0_14, arg1_14, arg2_14)
	arg0_14.externalAssaultFleet:InitShips(arg1_14, arg2_14)
end

function var0_0.isNewMember(arg0_15)
	local var0_15 = pg.TimeMgr.GetInstance()
	local var1_15 = var0_15:GetServerTime()

	if arg0_15.joinTime ~= 0 and var0_15:IsSameDay(var1_15, arg0_15.joinTime) then
		return true
	end

	return false
end

function var0_0.setDuty(arg0_16, arg1_16)
	arg0_16.duty = arg1_16
end

function var0_0.GetDuty(arg0_17)
	return arg0_17.duty
end

function var0_0.IsCommander(arg0_18)
	return arg0_18.duty == GuildConst.DUTY_COMMANDER
end

function var0_0.isLongOffLine(arg0_19)
	return pg.TimeMgr.GetInstance():GetServerTime() - arg0_19.preOnLineTime > 864000
end

function var0_0.setDamage(arg0_20, arg1_20)
	arg0_20.damage = arg1_20
end

function var0_0.getDamage(arg0_21)
	if arg0_21.damage then
		return arg0_21.damage
	end

	return 0
end

function var0_0.GetShip(arg0_22)
	return Ship.New({
		configId = arg0_22.icon,
		skin_id = arg0_22.skinId,
		name = arg0_22.name
	})
end

function var0_0.GetJoinZeroTime(arg0_23)
	return pg.TimeMgr:GetInstance():GetNextTimeByTimeStamp(arg0_23.joinTime)
end

return var0_0

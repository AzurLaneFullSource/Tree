local var0_0 = class("WorldBoss", import("....BaseEntity"))

var0_0.Fields = {
	config = "table",
	configId = "number",
	owner = "number",
	type = "number",
	lastTime = "number",
	fightCount = "number",
	rankCount = "number",
	player = "table",
	joinTime = "number",
	level = "number",
	hp = "number",
	id = "number",
	killTime = "number"
}
var0_0.SUPPORT_TYPE_FRIEND = 1
var0_0.SUPPORT_TYPE_GUILD = 2
var0_0.SUPPORT_TYPE_WORLD = 3
var0_0.BOSS_TYPE_FRIEND = 1
var0_0.BOSS_TYPE_GUILD = 2
var0_0.BOSS_TYPE_WORLD = 3
var0_0.BOSS_TYPE_SELF = 0

function var0_0.Setup(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.template_id
	arg0_1.hp = arg1_1.hp
	arg0_1.level = arg1_1.lv
	arg0_1.owner = arg1_1.owner
	arg0_1.lastTime = arg1_1.last_time
	arg0_1.killTime = arg1_1.kill_time or 0
	arg0_1.player = arg2_1
	arg0_1.joinTime = joinTime or 0

	local var0_1 = pg.world_joint_boss_template[arg0_1.configId]

	if var0_1 then
		local var1_1 = var0_1.boss_level_id + (arg0_1.level - 1)
		local var2_1 = pg.world_boss_level[var1_1]

		arg0_1.config = setmetatable({}, {
			__index = function(arg0_2, arg1_2)
				return var0_1[arg1_2] or var2_1[arg1_2]
			end
		})
	end

	arg0_1.fightCount = arg1_1.fight_count or 0
	arg0_1.rankCount = arg1_1.rank_count or 0
	arg0_1.type = arg0_1:SetBossType()
end

function var0_0.GetConfigID(arg0_3)
	return arg0_3.configId
end

function var0_0.SetJoinTime(arg0_4, arg1_4)
	arg0_4.joinTime = arg1_4
end

function var0_0.GetJoinTime(arg0_5)
	return arg0_5.joinTime
end

function var0_0.GetMetaId(arg0_6)
	return arg0_6.config.meta_id
end

function var0_0.IncreaseFightCnt(arg0_7)
	arg0_7.fightCount = arg0_7.fightCount + 1
end

function var0_0.GetSelfFightCnt(arg0_8)
	return arg0_8.fightCount
end

function var0_0.GetOilConsume(arg0_9)
	if not arg0_9:IsSelf() then
		return 0
	end

	local var0_9 = arg0_9.fightCount + 1

	return WorldBossConst.GetBossOilConsume(var0_9)
end

function var0_0.SetRankCnt(arg0_10, arg1_10)
	arg0_10.rankCount = arg1_10
end

function var0_0.GetRankCnt(arg0_11)
	return arg0_11.rankCount
end

function var0_0.GetPlayer(arg0_12)
	return arg0_12.player
end

function var0_0.IsFullPeople(arg0_13)
	return arg0_13:GetRankCnt() >= pg.gameset.joint_boss_fighter_max.key_value
end

function var0_0.UpdateBossType(arg0_14, arg1_14)
	if not arg0_14:IsSelf() then
		arg0_14.type = arg1_14
	end
end

function var0_0.GetWaitForResultTime(arg0_15)
	return arg0_15.killTime
end

function var0_0.ShouldWaitForResult(arg0_16)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_16.killTime
end

function var0_0.GetRoleName(arg0_17)
	if arg0_17.player then
		return arg0_17.player.name
	else
		return ""
	end
end

function var0_0.isSameLevel(arg0_18, arg1_18)
	return arg0_18.level == arg1_18.level
end

function var0_0.SetBossType(arg0_19)
	local var0_19 = getProxy(PlayerProxy):getRawData()
	local var1_19 = getProxy(FriendProxy)
	local var2_19 = getProxy(GuildProxy):getRawData()

	if arg0_19.owner == var0_19.id then
		return var0_0.BOSS_TYPE_SELF
	else
		if var2_19 and var2_19:getMemberById(arg0_19.owner) then
			return var0_0.BOSS_TYPE_GUILD
		end

		if var1_19:getFriend(arg0_19.owner) then
			return var0_0.BOSS_TYPE_FRIEND
		end
	end

	return var0_0.BOSS_TYPE_WORLD
end

function var0_0.IsSelf(arg0_20)
	return arg0_20.type == var0_0.BOSS_TYPE_SELF
end

function var0_0.GetType(arg0_21)
	return arg0_21.type
end

function var0_0.GetStageID(arg0_22)
	return arg0_22.config.expedition_id
end

function var0_0.UpdateHp(arg0_23, arg1_23)
	arg0_23.hp = arg1_23
end

function var0_0.GetHP(arg0_24)
	return arg0_24.hp
end

function var0_0.Active(arg0_25)
	return arg0_25.id > 0
end

function var0_0.isDeath(arg0_26)
	return arg0_26.hp <= 0
end

function var0_0.UpdateKillTime(arg0_27)
	local var0_27 = nowWorld():GetBossProxy():GetRank(arg0_27.id)

	if var0_27 and #var0_27 > 1 then
		local var1_27 = pg.gameset.world_boss_rank_wait_time.key_value

		arg0_27.killTime = pg.TimeMgr.GetInstance():GetServerTime() + var1_27
	end
end

function var0_0.GetAwards(arg0_28)
	if arg0_28:IsSelf() then
		return arg0_28.config.drop_show_self
	else
		return arg0_28.config.drop_show_other
	end
end

function var0_0.GetLeftTime(arg0_29)
	local var0_29 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_29.lastTime - var0_29
end

function var0_0.GetMaxHp(arg0_30)
	return arg0_30.config.hp
end

function var0_0.IsFullHp(arg0_31)
	return arg0_31.hp >= arg0_31:GetMaxHp()
end

function var0_0.GetName(arg0_32)
	return arg0_32.config.name
end

function var0_0.GetLevel(arg0_33)
	return arg0_33.level
end

function var0_0.GetExpiredTime(arg0_34)
	return arg0_34.lastTime
end

function var0_0.IsExpired(arg0_35)
	return arg0_35:GetLeftTime() <= 0
end

function var0_0.BuildTipText(arg0_36)
	local var0_36 = arg0_36:GetRoleName()
	local var1_36 = arg0_36.config.name
	local var2_36 = arg0_36.level

	if arg0_36.type == var0_0.BOSS_TYPE_FRIEND then
		return i18n("world_joint_call_friend_support_txt", var0_36, var1_36, var2_36)
	elseif arg0_36.type == var0_0.BOSS_TYPE_GUILD then
		return i18n("world_joint_call_guild_support_txt", var0_36, var1_36, var2_36)
	else
		return i18n("world_joint_call_world_support_txt", var0_36, var1_36, var2_36)
	end
end

return var0_0

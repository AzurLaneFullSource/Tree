local var0 = class("WorldBoss", import("....BaseEntity"))

var0.Fields = {
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
var0.SUPPORT_TYPE_FRIEND = 1
var0.SUPPORT_TYPE_GUILD = 2
var0.SUPPORT_TYPE_WORLD = 3
var0.BOSS_TYPE_FRIEND = 1
var0.BOSS_TYPE_GUILD = 2
var0.BOSS_TYPE_WORLD = 3
var0.BOSS_TYPE_SELF = 0

function var0.Setup(arg0, arg1, arg2)
	arg0.id = arg1.id
	arg0.configId = arg1.template_id
	arg0.hp = arg1.hp
	arg0.level = arg1.lv
	arg0.owner = arg1.owner
	arg0.lastTime = arg1.last_time
	arg0.killTime = arg1.kill_time or 0
	arg0.player = arg2
	arg0.joinTime = joinTime or 0

	local var0 = pg.world_joint_boss_template[arg0.configId]

	if var0 then
		local var1 = var0.boss_level_id + (arg0.level - 1)
		local var2 = pg.world_boss_level[var1]

		arg0.config = setmetatable({}, {
			__index = function(arg0, arg1)
				return var0[arg1] or var2[arg1]
			end
		})
	end

	arg0.fightCount = arg1.fight_count or 0
	arg0.rankCount = arg1.rank_count or 0
	arg0.type = arg0:SetBossType()
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.SetJoinTime(arg0, arg1)
	arg0.joinTime = arg1
end

function var0.GetJoinTime(arg0)
	return arg0.joinTime
end

function var0.GetMetaId(arg0)
	return arg0.config.meta_id
end

function var0.IncreaseFightCnt(arg0)
	arg0.fightCount = arg0.fightCount + 1
end

function var0.GetSelfFightCnt(arg0)
	return arg0.fightCount
end

function var0.GetOilConsume(arg0)
	if not arg0:IsSelf() then
		return 0
	end

	local var0 = arg0.fightCount + 1

	return WorldBossConst.GetBossOilConsume(var0)
end

function var0.SetRankCnt(arg0, arg1)
	arg0.rankCount = arg1
end

function var0.GetRankCnt(arg0)
	return arg0.rankCount
end

function var0.GetPlayer(arg0)
	return arg0.player
end

function var0.IsFullPeople(arg0)
	return arg0:GetRankCnt() >= pg.gameset.joint_boss_fighter_max.key_value
end

function var0.UpdateBossType(arg0, arg1)
	if not arg0:IsSelf() then
		arg0.type = arg1
	end
end

function var0.GetWaitForResultTime(arg0)
	return arg0.killTime
end

function var0.ShouldWaitForResult(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0.killTime
end

function var0.GetRoleName(arg0)
	if arg0.player then
		return arg0.player.name
	else
		return ""
	end
end

function var0.isSameLevel(arg0, arg1)
	return arg0.level == arg1.level
end

function var0.SetBossType(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = getProxy(FriendProxy)
	local var2 = getProxy(GuildProxy):getRawData()

	if arg0.owner == var0.id then
		return var0.BOSS_TYPE_SELF
	else
		if var2 and var2:getMemberById(arg0.owner) then
			return var0.BOSS_TYPE_GUILD
		end

		if var1:getFriend(arg0.owner) then
			return var0.BOSS_TYPE_FRIEND
		end
	end

	return var0.BOSS_TYPE_WORLD
end

function var0.IsSelf(arg0)
	return arg0.type == var0.BOSS_TYPE_SELF
end

function var0.GetType(arg0)
	return arg0.type
end

function var0.GetStageID(arg0)
	return arg0.config.expedition_id
end

function var0.UpdateHp(arg0, arg1)
	arg0.hp = arg1
end

function var0.GetHP(arg0)
	return arg0.hp
end

function var0.Active(arg0)
	return arg0.id > 0
end

function var0.isDeath(arg0)
	return arg0.hp <= 0
end

function var0.UpdateKillTime(arg0)
	local var0 = nowWorld():GetBossProxy():GetRank(arg0.id)

	if var0 and #var0 > 1 then
		local var1 = pg.gameset.world_boss_rank_wait_time.key_value

		arg0.killTime = pg.TimeMgr.GetInstance():GetServerTime() + var1
	end
end

function var0.GetAwards(arg0)
	if arg0:IsSelf() then
		return arg0.config.drop_show_self
	else
		return arg0.config.drop_show_other
	end
end

function var0.GetLeftTime(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.lastTime - var0
end

function var0.GetMaxHp(arg0)
	return arg0.config.hp
end

function var0.IsFullHp(arg0)
	return arg0.hp >= arg0:GetMaxHp()
end

function var0.GetName(arg0)
	return arg0.config.name
end

function var0.GetLevel(arg0)
	return arg0.level
end

function var0.GetExpiredTime(arg0)
	return arg0.lastTime
end

function var0.IsExpired(arg0)
	return arg0:GetLeftTime() <= 0
end

function var0.BuildTipText(arg0)
	local var0 = arg0:GetRoleName()
	local var1 = arg0.config.name
	local var2 = arg0.level

	if arg0.type == var0.BOSS_TYPE_FRIEND then
		return i18n("world_joint_call_friend_support_txt", var0, var1, var2)
	elseif arg0.type == var0.BOSS_TYPE_GUILD then
		return i18n("world_joint_call_guild_support_txt", var0, var1, var2)
	else
		return i18n("world_joint_call_world_support_txt", var0, var1, var2)
	end
end

return var0

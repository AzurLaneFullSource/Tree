local var0 = class("BossAward", import("....BaseEntity"))

var0.Fields = {
	bossId = "number",
	config = "table",
	rank = "number",
	level = "number",
	acceptTime = "number",
	duetime = "number"
}

function var0.Setup(arg0, arg1)
	arg0.bossId = arg1.bossId
	arg0.config = pg.world_joint_boss_template[arg0.bossId]
	arg0.level = arg1.level
	arg0.rank = arg1.rank
	arg0.duetime = arg1.duetime
	arg0.acceptTime = arg1.accept_time or 0
end

function var0.IsReceived(arg0)
	return arg0.acceptTime > 0
end

function var0.GetAwards(arg0)
	return arg0.config.drop_show
end

function var0.IsExpired(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.duetime
end

function var0.GetExpiredTime(arg0, ...)
	return arg0.duetime
end

function var0.GetBossName(arg0)
	return arg0.config.name
end

function var0.GetRank(arg0)
	return arg0.rank
end

return var0

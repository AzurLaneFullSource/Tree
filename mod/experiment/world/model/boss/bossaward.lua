local var0_0 = class("BossAward", import("....BaseEntity"))

var0_0.Fields = {
	bossId = "number",
	config = "table",
	rank = "number",
	level = "number",
	acceptTime = "number",
	duetime = "number"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.bossId = arg1_1.bossId
	arg0_1.config = pg.world_joint_boss_template[arg0_1.bossId]
	arg0_1.level = arg1_1.level
	arg0_1.rank = arg1_1.rank
	arg0_1.duetime = arg1_1.duetime
	arg0_1.acceptTime = arg1_1.accept_time or 0
end

function var0_0.IsReceived(arg0_2)
	return arg0_2.acceptTime > 0
end

function var0_0.GetAwards(arg0_3)
	return arg0_3.config.drop_show
end

function var0_0.IsExpired(arg0_4)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_4.duetime
end

function var0_0.GetExpiredTime(arg0_5, ...)
	return arg0_5.duetime
end

function var0_0.GetBossName(arg0_6)
	return arg0_6.config.name
end

function var0_0.GetRank(arg0_7)
	return arg0_7.rank
end

return var0_0

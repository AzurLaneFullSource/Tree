local var0_0 = class("ActivityBossConfig", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_event_worldboss
end

function var0_0.GetConfigID(arg0_2)
	return arg0_2.configId
end

function var0_0.Ctor(arg0_3, arg1_3)
	var0_0.super.Ctor(arg0_3, arg1_3)

	local var0_3 = arg0_3:getConfig("extrachallenge_id")

	if var0_3 > 0 then
		arg0_3.spEnemy = ActivityBossSPEnemy.New({
			configId = var0_3
		})
	end
end

function var0_0.GetTicketID(arg0_4)
	return arg0_4:getConfig("ticket")
end

function var0_0.GetBattleTime(arg0_5)
	return arg0_5:getConfig("time")
end

function var0_0.GetNormalStageIDs(arg0_6)
	return arg0_6:getConfig("normal_expedition")
end

function var0_0.GetEXStageID(arg0_7)
	return arg0_7:getConfig("ex_expedition")
end

function var0_0.GetOilLimits(arg0_8)
	return arg0_8:getConfig("use_oil_limit")
end

function var0_0.GetBossID(arg0_9)
	return arg0_9:getConfig("boss_id")[1]
end

function var0_0.GetMilestoneRewards(arg0_10)
	local var0_10 = arg0_10:GetBossID()

	return AcessWithinNull(pg.extraenemy_template[var0_10], "reward_display") or {}
end

function var0_0.GetInitTicketPools(arg0_11)
	return arg0_11:getConfig("normal_expedition_drop_num")
end

function var0_0.GetSPEnemy(arg0_12)
	return arg0_12.spEnemy
end

function var0_0.GetSPStageID(arg0_13)
	if not arg0_13.spEnemy then
		return
	end

	return arg0_13.spEnemy:GetExtraStageId()
end

return var0_0

local var0 = class("ActivityBossConfig", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.activity_event_worldboss
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg0:getConfig("extrachallenge_id")

	if var0 > 0 then
		arg0.spEnemy = ActivityBossSPEnemy.New({
			configId = var0
		})
	end
end

function var0.GetTicketID(arg0)
	return arg0:getConfig("ticket")
end

function var0.GetBattleTime(arg0)
	return arg0:getConfig("time")
end

function var0.GetNormalStageIDs(arg0)
	return arg0:getConfig("normal_expedition")
end

function var0.GetEXStageID(arg0)
	return arg0:getConfig("ex_expedition")
end

function var0.GetOilLimits(arg0)
	return arg0:getConfig("use_oil_limit")
end

function var0.GetBossID(arg0)
	return arg0:getConfig("boss_id")[1]
end

function var0.GetMilestoneRewards(arg0)
	local var0 = arg0:GetBossID()

	return AcessWithinNull(pg.extraenemy_template[var0], "reward_display") or {}
end

function var0.GetInitTicketPools(arg0)
	return arg0:getConfig("normal_expedition_drop_num")
end

function var0.GetSPEnemy(arg0)
	return arg0.spEnemy
end

function var0.GetSPStageID(arg0)
	if not arg0.spEnemy then
		return
	end

	return arg0.spEnemy:GetExtraStageId()
end

return var0

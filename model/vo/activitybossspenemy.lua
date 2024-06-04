local var0 = class("ActivityBossSPEnemy", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.extraenemy_challenge_template
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.GetScoreTargets(arg0)
	return arg0:getConfig("ex_challenge_target")
end

function var0.GetRewards(arg0)
	return arg0:getConfig("ex_challenge_reward")
end

function var0.GetSelectableBuffs(arg0)
	return arg0:getConfig("ex_challenge_buff")
end

function var0.GetExtraStageId(arg0)
	return arg0:getConfig("ex_challenge_enemy")
end

return var0

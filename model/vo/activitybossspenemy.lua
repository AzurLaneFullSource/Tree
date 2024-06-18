local var0_0 = class("ActivityBossSPEnemy", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.extraenemy_challenge_template
end

function var0_0.GetConfigID(arg0_2)
	return arg0_2.configId
end

function var0_0.GetScoreTargets(arg0_3)
	return arg0_3:getConfig("ex_challenge_target")
end

function var0_0.GetRewards(arg0_4)
	return arg0_4:getConfig("ex_challenge_reward")
end

function var0_0.GetSelectableBuffs(arg0_5)
	return arg0_5:getConfig("ex_challenge_buff")
end

function var0_0.GetExtraStageId(arg0_6)
	return arg0_6:getConfig("ex_challenge_enemy")
end

return var0_0

local var0_0 = class("BossSingleVariableEnemyData", import(".BossSingleEnemyData"))

var0_0.TYPE = {
	EAST = 1,
	HARD = 3,
	NORMAL = 2,
	SP = 4
}

function var0_0.IsContinuousType(arg0_1)
	return true
end

return var0_0

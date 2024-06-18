ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = math
local var3_0 = class("BattleShotgunEmitter", var0_0.Battle.BattleBulletEmitter)

var0_0.Battle.BattleShotgunEmitter = var3_0
var3_0.__name = "BattleShotgunEmitter"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.Battle.BattleShotgunEmitter.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.PrimalIteration = arg0_1._nonDelayPrimalIteration
end

function var3_0.Fire(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2._angleRange = arg3_2

	var0_0.Battle.BattleShotgunEmitter.super.Fire(arg0_2, arg1_2, arg2_2)
end

function var3_0.GenerateBullet(arg0_3)
	local var0_3 = arg0_3._convertedDirBarrage[arg0_3._primalCounter]
	local var1_3 = var0_3.OffsetX

	arg0_3._delay = var0_3.Delay

	local var2_3

	if arg0_3._isRandomAngle then
		var2_3 = (var2_0.random() - 0.5) * var2_0.random(arg0_3._angleRange) - arg0_3._angleRange / 2
	else
		var2_3 = var2_0.random(arg0_3._angleRange) - arg0_3._angleRange / 2
	end

	arg0_3._spawnFunc(var1_3, var0_3.OffsetZ, var2_3, arg0_3._offsetPriority, arg0_3._target, arg0_3._primalCounter)
	arg0_3:Interation()
end

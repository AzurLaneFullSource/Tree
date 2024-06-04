ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = math
local var3 = class("BattleShotgunEmitter", var0.Battle.BattleBulletEmitter)

var0.Battle.BattleShotgunEmitter = var3
var3.__name = "BattleShotgunEmitter"

function var3.Ctor(arg0, arg1, arg2, arg3)
	var0.Battle.BattleShotgunEmitter.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.PrimalIteration = arg0._nonDelayPrimalIteration
end

function var3.Fire(arg0, arg1, arg2, arg3)
	arg0._angleRange = arg3

	var0.Battle.BattleShotgunEmitter.super.Fire(arg0, arg1, arg2)
end

function var3.GenerateBullet(arg0)
	local var0 = arg0._convertedDirBarrage[arg0._primalCounter]
	local var1 = var0.OffsetX

	arg0._delay = var0.Delay

	local var2

	if arg0._isRandomAngle then
		var2 = (var2.random() - 0.5) * var2.random(arg0._angleRange) - arg0._angleRange / 2
	else
		var2 = var2.random(arg0._angleRange) - arg0._angleRange / 2
	end

	arg0._spawnFunc(var1, var0.OffsetZ, var2, arg0._offsetPriority, arg0._target, arg0._primalCounter)
	arg0:Interation()
end

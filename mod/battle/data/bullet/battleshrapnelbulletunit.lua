ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleBulletEvent
local var3 = var0.Battle.BattleFormulas

var0.Battle.BattleShrapnelBulletUnit = class("BattleShrapnelBulletUnit", var0.Battle.BattleBulletUnit)
var0.Battle.BattleShrapnelBulletUnit.__name = "BattleShrapnelBulletUnit"

local var4 = var0.Battle.BattleShrapnelBulletUnit

var4.STATE_NORMAL = "normal"
var4.STATE_SPLIT = "split"
var4.STATE_SPIN = "spin"
var4.STATE_FINAL_SPLIT = "final_split"
var4.STATE_EXPIRE = "expire"
var4.STATE_PRIORITY = {
	[var4.STATE_EXPIRE] = 5,
	[var4.STATE_FINAL_SPLIT] = 4,
	[var4.STATE_SPLIT] = 3,
	[var4.STATE_SPIN] = 2,
	[var4.STATE_NORMAL] = 1
}

function var4.Ctor(arg0, arg1, arg2)
	var4.super.Ctor(arg0, arg1, arg2)

	arg0._splitCount = 0
	arg0._cacheEmitter = {}

	arg0:ChangeShrapnelState(arg0.STATE_NORMAL)
end

function var4.Hit(arg0, arg1, arg2)
	if arg0:GetTemplate().extra_param.rangeAA then
		return
	end

	var4.super.Hit(arg0, arg1, arg2)

	arg0._pierceCount = arg0._pierceCount - 1
end

function var4.SplitFinishCount(arg0)
	arg0._splitCount = arg0._splitCount + 1
end

function var4.IsAllSplitFinish(arg0)
	return arg0._splitCount >= #arg0._tempData.extra_param.shrapnel
end

function var4.Update(arg0, arg1)
	if arg0._currentState == var4.STATE_NORMAL then
		local var0 = arg0._verticalSpeed

		var4.super.Update(arg0, arg1)

		if var0 ~= 0 and var0 * arg0._verticalSpeed < 0 then
			arg0:ChangeShrapnelState(var4.STATE_SPLIT)
		end
	elseif arg0._currentState == var4.STATE_SPIN and (not arg0._tempData.extra_param.lastTime or arg1 - arg0._spinStartTime > arg0._tempData.extra_param.lastTime) then
		arg0:ChangeShrapnelState(var4.STATE_SPLIT)
	end
end

function var4.ChangeShrapnelState(arg0, arg1)
	local var0 = var4.STATE_PRIORITY[arg0._currentState]

	if var0 and var0 >= var4.STATE_PRIORITY[arg1] then
		return
	end

	arg0._currentState = arg1

	if arg0._currentState == var4.STATE_SPIN then
		arg0._spinStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	elseif arg0._currentState == var4.STATE_SPLIT then
		arg0:DispatchEvent(var0.Event.New(var2.SPLIT, {}))
	end
end

function var4.IsOutRange(arg0, arg1)
	if arg0._currentState == var4.STATE_NORMAL then
		return var4.super.IsOutRange(arg0, arg1)
	else
		return false
	end
end

function var4.SetSrcHost(arg0, arg1)
	arg0._srcHost = arg1
end

function var4.GetSrcHost(arg0)
	return arg0._srcHost
end

function var4.GetShrapnelParam(arg0)
	return arg0._tempData.extra_param
end

function var4.GetCurrentState(arg0)
	return arg0._currentState
end

function var4.SetSpawnPosition(arg0, arg1)
	var4.super.SetSpawnPosition(arg0, arg1)

	local var0 = arg0:GetTemplate().extra_param
	local var1 = pg.Tool.FilterY(arg0._spawnPos)
	local var2 = Vector3.Distance(var1, pg.Tool.FilterY(arg0._explodePos))

	if var0.flare then
		local var3 = var0.shrapnel[1].bullet_ID
		local var4 = var0.Battle.BattleDataFunction.GetBulletTmpDataFromID(var3)
		local var5 = var4.hit_type.time
		local var6 = 0.5 * math.abs(var4.extra_param.gravity or -0.0005) * (var5 * var1.calcFPS)^2 - arg0._spawnPos.y

		arg0._convertedVelocity = math.sqrt(-0.5 * arg0._gravity * var2 * var2 / var6)

		local var7 = var2 / arg0._convertedVelocity

		arg0._verticalSpeed = var6 / var7 - 0.5 * arg0._gravity * var7
	elseif var0.rangeAA then
		local var8 = var1.AircraftHeight - arg0._spawnPos.y
		local var9 = 0.5 * arg0._gravity

		arg0._velocity = math.sqrt(-var9 * var2 * var2 / var8)

		local var10 = var2 / arg0._velocity

		arg0._verticalSpeed = var8 / var10 - var9 * var10
		arg0._velocity = var3.ConvertBulletDataSpeed(arg0._velocity)
	elseif arg0._convertedVelocity ~= 0 then
		local var11 = var2 / arg0._convertedVelocity
		local var12 = arg0._explodePos.y - arg0._spawnPos.y

		arg0._verticalSpeed = var0.launchVrtSpeed or var12 / var11 - 0.5 * arg0._gravity * var11
	end
end

function var4.GetExplodePostion(arg0)
	return arg0._explodePos
end

function var4.SetExplodePosition(arg0, arg1)
	arg0._explodePos = Clone(arg1)
	arg0._explodePos.y = var1.BombDetonateHeight
end

function var4.CacheChildEimtter(arg0, arg1)
	table.insert(arg0._cacheEmitter, arg1)
end

function var4.interruptChildEmitter(arg0)
	for iter0, iter1 in ipairs(arg0._cacheEmitter) do
		iter1:Destroy()
	end
end

function var4.Dispose(arg0)
	arg0:interruptChildEmitter()

	arg0._cacheEmitter = nil

	var4.super.Dispose(arg0)
end

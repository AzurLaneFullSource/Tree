ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleBulletEvent
local var3_0 = var0_0.Battle.BattleFormulas

var0_0.Battle.BattleShrapnelBulletUnit = class("BattleShrapnelBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleShrapnelBulletUnit.__name = "BattleShrapnelBulletUnit"

local var4_0 = var0_0.Battle.BattleShrapnelBulletUnit

var4_0.STATE_NORMAL = "normal"
var4_0.STATE_SPLIT = "split"
var4_0.STATE_SPIN = "spin"
var4_0.STATE_FINAL_SPLIT = "final_split"
var4_0.STATE_EXPIRE = "expire"
var4_0.STATE_PRIORITY = {
	[var4_0.STATE_EXPIRE] = 5,
	[var4_0.STATE_FINAL_SPLIT] = 4,
	[var4_0.STATE_SPLIT] = 3,
	[var4_0.STATE_SPIN] = 2,
	[var4_0.STATE_NORMAL] = 1
}

function var4_0.Ctor(arg0_1, arg1_1, arg2_1)
	var4_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._splitCount = 0
	arg0_1._cacheEmitter = {}

	arg0_1:ChangeShrapnelState(arg0_1.STATE_NORMAL)
end

function var4_0.Hit(arg0_2, arg1_2, arg2_2)
	if arg0_2:GetTemplate().extra_param.rangeAA then
		return
	end

	var4_0.super.Hit(arg0_2, arg1_2, arg2_2)

	arg0_2._pierceCount = arg0_2._pierceCount - 1
end

function var4_0.SplitFinishCount(arg0_3)
	arg0_3._splitCount = arg0_3._splitCount + 1
end

function var4_0.IsAllSplitFinish(arg0_4)
	return arg0_4._splitCount >= #arg0_4._tempData.extra_param.shrapnel
end

function var4_0.Update(arg0_5, arg1_5)
	if arg0_5._currentState == var4_0.STATE_NORMAL then
		local var0_5 = arg0_5._verticalSpeed

		var4_0.super.Update(arg0_5, arg1_5)

		if var0_5 ~= 0 and var0_5 * arg0_5._verticalSpeed < 0 then
			arg0_5:ChangeShrapnelState(var4_0.STATE_SPLIT)
		end
	elseif arg0_5._currentState == var4_0.STATE_SPIN and (not arg0_5._tempData.extra_param.lastTime or arg1_5 - arg0_5._spinStartTime > arg0_5._tempData.extra_param.lastTime) then
		arg0_5:ChangeShrapnelState(var4_0.STATE_SPLIT)
	end
end

function var4_0.ChangeShrapnelState(arg0_6, arg1_6)
	local var0_6 = var4_0.STATE_PRIORITY[arg0_6._currentState]

	if var0_6 and var0_6 >= var4_0.STATE_PRIORITY[arg1_6] then
		return
	end

	arg0_6._currentState = arg1_6

	if arg0_6._currentState == var4_0.STATE_SPIN then
		arg0_6._spinStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	elseif arg0_6._currentState == var4_0.STATE_SPLIT then
		arg0_6:DispatchEvent(var0_0.Event.New(var2_0.SPLIT, {}))
	end
end

function var4_0.IsOutRange(arg0_7, arg1_7)
	if arg0_7._currentState == var4_0.STATE_NORMAL then
		return var4_0.super.IsOutRange(arg0_7, arg1_7)
	else
		return false
	end
end

function var4_0.SetSrcHost(arg0_8, arg1_8)
	arg0_8._srcHost = arg1_8
end

function var4_0.GetSrcHost(arg0_9)
	return arg0_9._srcHost
end

function var4_0.GetShrapnelParam(arg0_10)
	return arg0_10._tempData.extra_param
end

function var4_0.GetCurrentState(arg0_11)
	return arg0_11._currentState
end

function var4_0.SetSpawnPosition(arg0_12, arg1_12)
	var4_0.super.SetSpawnPosition(arg0_12, arg1_12)

	local var0_12 = arg0_12:GetTemplate().extra_param
	local var1_12 = pg.Tool.FilterY(arg0_12._spawnPos)
	local var2_12 = Vector3.Distance(var1_12, pg.Tool.FilterY(arg0_12._explodePos))

	if var0_12.flare then
		local var3_12 = var0_12.shrapnel[1].bullet_ID
		local var4_12 = var0_0.Battle.BattleDataFunction.GetBulletTmpDataFromID(var3_12)
		local var5_12 = var4_12.hit_type.time
		local var6_12 = 0.5 * math.abs(var4_12.extra_param.gravity or -0.0005) * (var5_12 * var1_0.calcFPS)^2 - arg0_12._spawnPos.y

		arg0_12._convertedVelocity = math.sqrt(-0.5 * arg0_12._gravity * var2_12 * var2_12 / var6_12)

		local var7_12 = var2_12 / arg0_12._convertedVelocity

		arg0_12._verticalSpeed = var6_12 / var7_12 - 0.5 * arg0_12._gravity * var7_12
	elseif var0_12.rangeAA then
		local var8_12 = var1_0.AircraftHeight - arg0_12._spawnPos.y
		local var9_12 = 0.5 * arg0_12._gravity

		arg0_12._velocity = math.sqrt(-var9_12 * var2_12 * var2_12 / var8_12)

		local var10_12 = var2_12 / arg0_12._velocity

		arg0_12._verticalSpeed = var8_12 / var10_12 - var9_12 * var10_12
		arg0_12._velocity = var3_0.ConvertBulletDataSpeed(arg0_12._velocity)
	elseif arg0_12._convertedVelocity ~= 0 then
		local var11_12 = var2_12 / arg0_12._convertedVelocity
		local var12_12 = arg0_12._explodePos.y - arg0_12._spawnPos.y

		arg0_12._verticalSpeed = var0_12.launchVrtSpeed or var12_12 / var11_12 - 0.5 * arg0_12._gravity * var11_12
	end
end

function var4_0.GetExplodePostion(arg0_13)
	return arg0_13._explodePos
end

function var4_0.SetExplodePosition(arg0_14, arg1_14)
	arg0_14._explodePos = Clone(arg1_14)
	arg0_14._explodePos.y = var1_0.BombDetonateHeight
end

function var4_0.CacheChildEimtter(arg0_15, arg1_15)
	table.insert(arg0_15._cacheEmitter, arg1_15)
end

function var4_0.interruptChildEmitter(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16._cacheEmitter) do
		iter1_16:Destroy()
	end
end

function var4_0.Dispose(arg0_17)
	arg0_17:interruptChildEmitter()

	arg0_17._cacheEmitter = nil

	var4_0.super.Dispose(arg0_17)
end

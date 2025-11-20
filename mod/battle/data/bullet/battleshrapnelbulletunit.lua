ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleBulletEvent
local var4_0 = var0_0.Battle.BattleFormulas

var0_0.Battle.BattleShrapnelBulletUnit = class("BattleShrapnelBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleShrapnelBulletUnit.__name = "BattleShrapnelBulletUnit"

local var5_0 = var0_0.Battle.BattleShrapnelBulletUnit

var5_0.STATE_NORMAL = "normal"
var5_0.STATE_SPLIT = "split"
var5_0.STATE_SPIN = "spin"
var5_0.STATE_FINAL_SPLIT = "final_split"
var5_0.STATE_EXPIRE = "expire"
var5_0.STATE_PRIORITY = {
	[var5_0.STATE_EXPIRE] = 5,
	[var5_0.STATE_FINAL_SPLIT] = 4,
	[var5_0.STATE_SPLIT] = 3,
	[var5_0.STATE_SPIN] = 2,
	[var5_0.STATE_NORMAL] = 1
}

function var5_0.Ctor(arg0_1, arg1_1, arg2_1)
	var5_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._splitCount = 0
	arg0_1._cacheEmitter = {}

	arg0_1:ChangeShrapnelState(arg0_1.STATE_NORMAL)
end

function var5_0.Hit(arg0_2, arg1_2, arg2_2)
	if arg0_2:GetTemplate().extra_param.rangeAA then
		return
	end

	var5_0.super.Hit(arg0_2, arg1_2, arg2_2)

	arg0_2._pierceCount = arg0_2._pierceCount - 1
end

function var5_0.SplitFinishCount(arg0_3)
	arg0_3._splitCount = arg0_3._splitCount + 1
end

function var5_0.IsAllSplitFinish(arg0_4)
	return arg0_4._splitCount >= #arg0_4._tempData.extra_param.shrapnel
end

function var5_0.SetTemplateData(arg0_5, arg1_5)
	var5_0.super.SetTemplateData(arg0_5, arg1_5)

	arg0_5._outbound = arg0_5._tempData.out_bound
end

function var5_0.GetOutBound(arg0_6)
	return arg0_6._outbound
end

function var5_0.Update(arg0_7, arg1_7)
	if arg0_7._startCount == nil and arg0_7._outbound == var2_0.BulletOutBound.SHIFT_SPLIT then
		arg0_7._startCount = arg1_7
	end

	if arg0_7._outbound == var2_0.BulletOutBound.SHIFT_SPLIT then
		if arg0_7._startCount == nil then
			arg0_7._startCount = arg1_7
		elseif arg1_7 - arg0_7._startCount > var1_0.BULLET_SPLIT_SHIFT_DELAY then
			arg0_7._outbound = var2_0.BulletOutBound.SPLIT
		end
	end

	if arg0_7._currentState == var5_0.STATE_NORMAL then
		local var0_7 = arg0_7._verticalSpeed

		var5_0.super.Update(arg0_7, arg1_7)

		if var0_7 ~= 0 and var0_7 * arg0_7._verticalSpeed < 0 then
			arg0_7:ChangeShrapnelState(var5_0.STATE_SPLIT)
		end
	elseif arg0_7._currentState == var5_0.STATE_SPIN and (not arg0_7._tempData.extra_param.lastTime or arg1_7 - arg0_7._spinStartTime > arg0_7._tempData.extra_param.lastTime) then
		arg0_7:ChangeShrapnelState(var5_0.STATE_SPLIT)
	end
end

function var5_0.ChangeShrapnelState(arg0_8, arg1_8)
	local var0_8 = var5_0.STATE_PRIORITY[arg0_8._currentState]

	if var0_8 and var0_8 >= var5_0.STATE_PRIORITY[arg1_8] then
		return
	end

	arg0_8._currentState = arg1_8

	if arg0_8._currentState == var5_0.STATE_SPIN then
		arg0_8._spinStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	elseif arg0_8._currentState == var5_0.STATE_SPLIT then
		arg0_8:DispatchEvent(var0_0.Event.New(var3_0.SPLIT, {}))
	end
end

function var5_0.IsOutRange(arg0_9, arg1_9)
	if arg0_9._currentState == var5_0.STATE_NORMAL then
		return var5_0.super.IsOutRange(arg0_9, arg1_9)
	else
		return false
	end
end

function var5_0.SetSrcHost(arg0_10, arg1_10)
	arg0_10._srcHost = arg1_10
end

function var5_0.GetSrcHost(arg0_11)
	return arg0_11._srcHost
end

function var5_0.GetShrapnelParam(arg0_12)
	return arg0_12._tempData.extra_param
end

function var5_0.GetCurrentState(arg0_13)
	return arg0_13._currentState
end

function var5_0.SetSpawnPosition(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetTemplate().extra_param
	local var1_14 = arg1_14

	if var0_14.directHit then
		var1_14 = Clone(arg0_14._explodePos)
	end

	var5_0.super.SetSpawnPosition(arg0_14, var1_14)

	local var2_14 = pg.Tool.FilterY(arg0_14._spawnPos)
	local var3_14 = Vector3.Distance(var2_14, pg.Tool.FilterY(arg0_14._explodePos))

	if var0_14.flare then
		local var4_14 = var0_14.shrapnel[1].bullet_ID
		local var5_14 = var0_0.Battle.BattleDataFunction.GetBulletTmpDataFromID(var4_14)
		local var6_14 = var5_14.hit_type.time
		local var7_14 = 0.5 * math.abs(var5_14.extra_param.gravity or -0.0005) * (var6_14 * var1_0.calcFPS)^2 - arg0_14._spawnPos.y

		arg0_14._convertedVelocity = math.sqrt(-0.5 * arg0_14._gravity * var3_14 * var3_14 / var7_14)

		local var8_14 = var3_14 / arg0_14._convertedVelocity

		arg0_14._verticalSpeed = var7_14 / var8_14 - 0.5 * arg0_14._gravity * var8_14
	elseif var0_14.rangeAA then
		local var9_14 = var1_0.AircraftHeight - arg0_14._spawnPos.y
		local var10_14 = 0.5 * arg0_14._gravity

		arg0_14._velocity = math.sqrt(-var10_14 * var3_14 * var3_14 / var9_14)

		local var11_14 = var3_14 / arg0_14._velocity

		arg0_14._verticalSpeed = var9_14 / var11_14 - var10_14 * var11_14
		arg0_14._velocity = var4_0.ConvertBulletDataSpeed(arg0_14._velocity)
	elseif arg0_14._convertedVelocity ~= 0 and arg0_14._explodePos.y ~= arg0_14._spawnPos.y then
		local var12_14 = var3_14 / arg0_14._convertedVelocity
		local var13_14 = arg0_14._explodePos.y - arg0_14._spawnPos.y

		arg0_14._verticalSpeed = var0_14.launchVrtSpeed or var13_14 / var12_14 - 0.5 * arg0_14._gravity * var12_14
	end
end

function var5_0.GetExplodePostion(arg0_15)
	return arg0_15._explodePos
end

function var5_0.SetExplodePosition(arg0_16, arg1_16)
	arg0_16._explodePos = Clone(arg1_16)
	arg0_16._explodePos.y = var1_0.BombDetonateHeight
end

function var5_0.CacheChildEimtter(arg0_17, arg1_17)
	table.insert(arg0_17._cacheEmitter, arg1_17)
end

function var5_0.interruptChildEmitter(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18._cacheEmitter) do
		iter1_18:Destroy()
	end
end

function var5_0.Dispose(arg0_19)
	arg0_19:interruptChildEmitter()

	arg0_19._cacheEmitter = nil

	var5_0.super.Dispose(arg0_19)
end

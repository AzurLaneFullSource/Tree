ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleAttr
local var3 = class("BattleBuffCount", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffCount = var3
var3.__name = "BattleBuffCount"

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)
end

function var3.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._countTarget = var0.countTarget or 1
	arg0._countType = var0.countType
	arg0._weaponType = var0.weaponType
	arg0._index = var0.index
	arg0._maxHPRatio = var0.maxHPRatio or 0
	arg0._casterMaxHPRatio = var0.casterMaxHPRatio or 0
	arg0._clock = arg0._tempData.arg_list.clock
	arg0._interrupt = arg0._tempData.arg_list.interrupt
	arg0._iconType = arg0._tempData.arg_list.iconType or 1
	arg0._gunnerBonus = var0.gunnerBonus

	arg0:ResetCount()

	if arg0._clock then
		arg1:DispatchCastClock(true, arg0, arg0._iconType, arg0._interrupt)
	end
end

function var3.onRemove(arg0, arg1, arg2)
	if arg0._clock then
		local var0 = arg0._interrupt and arg0._count < arg0._countTarget

		arg1:DispatchCastClock(false, arg0, nil, var0)
	end
end

function var3.onTrigger(arg0, arg1, arg2)
	var3.super.onTrigger(arg0, arg1, arg2)

	arg0._count = arg0._count + 1

	arg0:checkCount(arg1)
end

function var3.onFire(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0._count = arg0._count + 1

	arg0:checkModCount(arg1)
end

function var3.onUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg3.timeStamp

	arg0._count = var0 - (arg0._lastTriggerTime or arg2:GetBuffStartTime())

	if arg0._count >= arg0._countTarget then
		arg0._lastTriggerTime = var0

		arg0:ResetCount()
		arg1:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0
		})
	end
end

function var3.onTakeDamage(arg0, arg1, arg2, arg3)
	if arg0:damageCheck(arg3) then
		local var0 = arg3.damage

		arg0._count = arg0._count + var0

		arg0:checkHPCount(arg1)
	end
end

function var3.onTakeHealing(arg0, arg1, arg2, arg3)
	local var0 = arg3.damage

	arg0._count = arg0._count + var0

	arg0:checkHPCount(arg1)
end

function var3.onHPRatioUpdate(arg0, arg1, arg2, arg3)
	local var0 = math.abs(arg3.validDHP)

	arg0._count = arg0._count + var0

	arg0:checkHPCount(arg1)
end

function var3.onStack(arg0, arg1, arg2, arg3)
	arg0._count = arg2:GetStack()

	arg0:checkCount(arg1)
end

function var3.onBulletHit(arg0, arg1, arg2, arg3)
	if not arg0:equipIndexRequire(arg3.equipIndex) then
		return
	end

	arg0._count = arg0._count + arg3.damage

	arg0:checkCount(arg1)
end

function var3.checkCount(arg0, arg1)
	if arg0._count >= arg0._countTarget then
		arg1:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0
		})
	end
end

function var3.checkModCount(arg0, arg1)
	if arg0._count >= arg0:getCount(arg1) then
		arg1:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0
		})
	end
end

function var3.getCount(arg0, arg1)
	local var0 = arg0._countTarget
	local var1 = var2.GetCurrent(arg1, "barrageCounterMod")

	if arg0._gunnerBonus then
		var0 = math.ceil(var0 / var1)
	end

	return var0
end

function var3.checkHPCount(arg0, arg1)
	if not arg0._hpCountTarget then
		arg0:calcHPCount(arg1)
	end

	if arg0._count >= arg0._hpCountTarget then
		arg1:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0
		})
	end
end

function var3.calcHPCount(arg0, arg1)
	local var0, var1 = arg1:GetHP()
	local var2, var3 = arg0._caster:GetHP()

	arg0._hpCountTarget = math.floor(arg0._casterMaxHPRatio * var3 + arg0._maxHPRatio * var1 + arg0._countTarget)
end

function var3.GetCountType(arg0)
	return arg0._countType
end

function var3.GetCountProgress(arg0)
	return arg0._count / arg0._countTarget
end

function var3.ResetCount(arg0)
	arg0._count = 0
end

ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleAttr
local var3_0 = class("BattleBuffCount", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffCount = var3_0
var3_0.__name = "BattleBuffCount"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
end

function var3_0.Repeater(arg0_2)
	return arg0_2._keepRestCount
end

function var3_0.SetArgs(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3._tempData.arg_list

	arg0_3._countTarget = var0_3.countTarget or 1
	arg0_3._countType = var0_3.countType
	arg0_3._weaponType = var0_3.weaponType
	arg0_3._index = var0_3.index
	arg0_3._maxHPRatio = var0_3.maxHPRatio or 0
	arg0_3._casterMaxHPRatio = var0_3.casterMaxHPRatio or 0
	arg0_3._clock = arg0_3._tempData.arg_list.clock
	arg0_3._interrupt = arg0_3._tempData.arg_list.interrupt
	arg0_3._iconType = arg0_3._tempData.arg_list.iconType or 1
	arg0_3._gunnerBonus = var0_3.gunnerBonus
	arg0_3._keepRestCount = var0_3.keep

	arg0_3:ResetCount()

	if arg0_3._clock then
		arg1_3:DispatchCastClock(true, arg0_3, arg0_3._iconType, arg0_3._interrupt)
	end
end

function var3_0.onRemove(arg0_4, arg1_4, arg2_4)
	if arg0_4._clock then
		local var0_4 = arg0_4._interrupt and arg0_4._count < arg0_4._countTarget

		arg1_4:DispatchCastClock(false, arg0_4, nil, var0_4)
	end
end

function var3_0.onTrigger(arg0_5, arg1_5, arg2_5)
	var3_0.super.onTrigger(arg0_5, arg1_5, arg2_5)

	arg0_5._count = arg0_5._count + 1

	arg0_5:checkCount(arg1_5)
end

function var3_0.onFire(arg0_6, arg1_6, arg2_6, arg3_6)
	if not arg0_6:equipIndexRequire(arg3_6.equipIndex) then
		return
	end

	arg0_6._count = arg0_6._count + 1

	arg0_6:checkModCount(arg1_6)
end

function var3_0.onUpdate(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg3_7.timeStamp

	arg0_7._count = var0_7 - (arg0_7._lastTriggerTime or arg2_7:GetBuffStartTime())

	if arg0_7._count >= arg0_7._countTarget then
		arg0_7._lastTriggerTime = var0_7

		arg0_7:ResetCount()
		arg1_7:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_7
		})
	end
end

function var3_0.onTakeDamage(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg0_8:damageCheck(arg3_8) then
		local var0_8 = arg3_8.damage

		arg0_8._count = arg0_8._count + var0_8

		arg0_8:checkHPCount(arg1_8)
	end
end

function var3_0.onTakeHealing(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg3_9.damage

	arg0_9._count = arg0_9._count + var0_9

	arg0_9:checkHPCount(arg1_9)
end

function var3_0.onHPRatioUpdate(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = math.abs(arg3_10.validDHP)

	arg0_10._count = arg0_10._count + var0_10

	arg0_10:checkHPCount(arg1_10)
end

function var3_0.onStack(arg0_11, arg1_11, arg2_11, arg3_11)
	arg0_11._count = arg2_11:GetStack()

	arg0_11:checkCount(arg1_11)
end

function var3_0.onBulletHit(arg0_12, arg1_12, arg2_12, arg3_12)
	if not arg0_12:equipIndexRequire(arg3_12.equipIndex) then
		return
	end

	arg0_12._count = arg0_12._count + arg3_12.damage

	arg0_12:checkCount(arg1_12)
end

function var3_0.checkCount(arg0_13, arg1_13)
	if arg0_13._count >= arg0_13._countTarget then
		arg1_13:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_13
		})
	end
end

function var3_0.checkModCount(arg0_14, arg1_14)
	if arg0_14._count >= arg0_14:getCount(arg1_14) then
		arg1_14:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_14
		})
	end
end

function var3_0.getCount(arg0_15, arg1_15)
	local var0_15 = arg0_15._countTarget
	local var1_15 = var2_0.GetCurrent(arg1_15, "barrageCounterMod")

	if arg0_15._gunnerBonus then
		var0_15 = math.ceil(var0_15 / var1_15)
	end

	return var0_15
end

function var3_0.checkHPCount(arg0_16, arg1_16)
	if not arg0_16._hpCountTarget then
		arg0_16:calcHPCount(arg1_16)
	end

	if arg0_16._count >= arg0_16._hpCountTarget then
		arg1_16:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_16
		})
	end
end

function var3_0.calcHPCount(arg0_17, arg1_17)
	local var0_17, var1_17 = arg1_17:GetHP()
	local var2_17, var3_17 = arg0_17._caster:GetHP()

	arg0_17._hpCountTarget = math.floor(arg0_17._casterMaxHPRatio * var3_17 + arg0_17._maxHPRatio * var1_17 + arg0_17._countTarget)
end

function var3_0.GetCountType(arg0_18)
	return arg0_18._countType
end

function var3_0.GetCountProgress(arg0_19)
	local var0_19 = arg0_19._hpCountTarget or arg0_19._countTarget

	return arg0_19._count / var0_19
end

function var3_0.ResetCount(arg0_20)
	arg0_20._count = 0
end

function var3_0.ConsumeCount(arg0_21)
	local var0_21 = arg0_21._hpCountTarget or arg0_21._countTarget

	arg0_21._count = math.max(arg0_21._count - var0_21)
end

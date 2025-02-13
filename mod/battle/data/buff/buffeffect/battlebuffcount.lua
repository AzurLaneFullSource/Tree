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

function var3_0.GetEffectType(arg0_2)
	return var0_0.Battle.BattleBuffEffect.FX_TYPE_COUNTER
end

function var3_0.Repeater(arg0_3)
	return arg0_3._keepRestCount
end

function var3_0.SetArgs(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4._tempData.arg_list

	arg0_4._countTarget = var0_4.countTarget or 1
	arg0_4._countType = var0_4.countType
	arg0_4._weaponType = var0_4.weaponType
	arg0_4._index = var0_4.index
	arg0_4._maxHPRatio = var0_4.maxHPRatio or 0
	arg0_4._casterMaxHPRatio = var0_4.casterMaxHPRatio or 0
	arg0_4._clock = arg0_4._tempData.arg_list.clock
	arg0_4._interrupt = arg0_4._tempData.arg_list.interrupt
	arg0_4._iconType = arg0_4._tempData.arg_list.iconType or 1
	arg0_4._gunnerBonus = var0_4.gunnerBonus
	arg0_4._keepRestCount = var0_4.keep

	arg0_4:ResetCount()

	if arg0_4._clock then
		arg1_4:DispatchCastClock(true, arg0_4, arg0_4._iconType, arg0_4._interrupt)
	end
end

function var3_0.onRemove(arg0_5, arg1_5, arg2_5)
	if arg0_5._clock then
		local var0_5 = arg0_5._interrupt and arg0_5._count < arg0_5._countTarget

		arg1_5:DispatchCastClock(false, arg0_5, nil, var0_5)
	end
end

function var3_0.onTrigger(arg0_6, arg1_6, arg2_6)
	var3_0.super.onTrigger(arg0_6, arg1_6, arg2_6)

	arg0_6._count = arg0_6._count + 1

	arg0_6:checkCount(arg1_6)
end

function var3_0.onFire(arg0_7, arg1_7, arg2_7, arg3_7)
	if not arg0_7:equipIndexRequire(arg3_7.equipIndex) then
		return
	end

	arg0_7._count = arg0_7._count + 1

	arg0_7:checkModCount(arg1_7)
end

function var3_0.onUpdate(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg3_8.timeStamp

	arg0_8._count = var0_8 - (arg0_8._lastTriggerTime or arg2_8:GetBuffStartTime())

	if arg0_8._count >= arg0_8._countTarget then
		arg0_8._lastTriggerTime = var0_8

		arg0_8:ResetCount()
		arg1_8:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_8
		})
	end
end

function var3_0.onTakeDamage(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg0_9:damageCheck(arg3_9) then
		local var0_9 = arg3_9.damage

		arg0_9._count = arg0_9._count + var0_9

		arg0_9:checkHPCount(arg1_9)
	end
end

function var3_0.onTakeHealing(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg3_10.damage

	arg0_10._count = arg0_10._count + var0_10

	arg0_10:checkHPCount(arg1_10)
end

function var3_0.onHPRatioUpdate(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = math.abs(arg3_11.validDHP)

	arg0_11._count = arg0_11._count + var0_11

	arg0_11:checkHPCount(arg1_11)
end

function var3_0.onStack(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12._count = arg2_12:GetStack()

	arg0_12:checkCount(arg1_12)
end

function var3_0.onBulletHit(arg0_13, arg1_13, arg2_13, arg3_13)
	if not arg0_13:equipIndexRequire(arg3_13.equipIndex) then
		return
	end

	arg0_13._count = arg0_13._count + arg3_13.damage

	arg0_13:checkCount(arg1_13)
end

function var3_0.checkCount(arg0_14, arg1_14)
	if arg0_14._count >= arg0_14._countTarget then
		arg1_14:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_14
		})
	end
end

function var3_0.checkModCount(arg0_15, arg1_15)
	if arg0_15._count >= arg0_15:getCount(arg1_15) then
		arg1_15:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_15
		})
	end
end

function var3_0.getCount(arg0_16, arg1_16)
	local var0_16 = arg0_16._countTarget
	local var1_16 = var2_0.GetCurrent(arg1_16, "barrageCounterMod")

	if arg0_16._gunnerBonus then
		var0_16 = math.ceil(var0_16 / var1_16)
	end

	return var0_16
end

function var3_0.checkHPCount(arg0_17, arg1_17)
	if not arg0_17._hpCountTarget then
		arg0_17:calcHPCount(arg1_17)
	end

	if arg0_17._count >= arg0_17._hpCountTarget then
		arg1_17:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = arg0_17
		})
	end
end

function var3_0.calcHPCount(arg0_18, arg1_18)
	local var0_18, var1_18 = arg1_18:GetHP()
	local var2_18, var3_18 = arg0_18._caster:GetHP()

	arg0_18._hpCountTarget = math.floor(arg0_18._casterMaxHPRatio * var3_18 + arg0_18._maxHPRatio * var1_18 + arg0_18._countTarget)
end

function var3_0.GetCountType(arg0_19)
	return arg0_19._countType
end

function var3_0.GetCountProgress(arg0_20)
	local var0_20 = arg0_20._hpCountTarget or arg0_20._countTarget

	return arg0_20._count / var0_20
end

function var3_0.SetCount(arg0_21, arg1_21)
	arg0_21._count = arg1_21
end

function var3_0.ResetCount(arg0_22)
	arg0_22._count = 0
end

function var3_0.ConsumeCount(arg0_23)
	local var0_23 = arg0_23._hpCountTarget or arg0_23._countTarget

	arg0_23._count = math.max(arg0_23._count - var0_23)
end

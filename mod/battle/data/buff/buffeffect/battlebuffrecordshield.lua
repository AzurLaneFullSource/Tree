ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffRecordShield = class("BattleBuffRecordShield", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffRecordShield.__name = "BattleBuffRecordShield"

local var1_0 = var0_0.Battle.BattleBuffRecordShield

var1_0.MODE_RECORD = "record"
var1_0.MODE_SHIELD = "shield"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectAttachData(arg0_2)
	return arg0_2._shieldValue
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3._tempData.arg_list

	arg0_3._damageAttrRequire = var0_3.damageAttr
	arg0_3._damageSrcTagRequire = var0_3.srcTag
	arg0_3._convertRate = var0_3.convertRate
	arg0_3._shieldDuration = var0_3.shield_duration
	arg0_3._recordDuration = var0_3.record_duration
	arg0_3._exhaustRemove = var0_3.exhaust_remove
	arg0_3._shieldValue = 0
	arg0_3._recordDamage = 0
	arg0_3._shieldStartTimeStamp = 0
	arg0_3._recordStartTimeStamp = 0
	arg0_3._unit = arg1_3
	arg0_3._fxName = var0_3.effect
	arg0_3._effectIndex = "BattleBuffRecordShield" .. arg2_3:GetID()

	arg0_3:switchMode(var1_0.MODE_RECORD)
end

function var1_0.onUpdate(arg0_4, arg1_4, arg2_4)
	local var0_4 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0_4._buffMode == var1_0.MODE_SHIELD then
		if arg0_4._shieldDuration and var0_4 - arg0_4._shieldStartTimeStamp > arg0_4._shieldDuration or arg0_4._shieldValue <= 0 then
			arg0_4:handleShieldExhaust(arg2_4)
		end
	elseif arg0_4._buffMode == var1_0.MODE_RECORD and arg0_4._recordDuration and var0_4 - arg0_4._recordStartTimeStamp > arg0_4._recordDuration then
		arg0_4:switchMode(var1_0.MODE_SHIELD)
	end
end

function var1_0.handleShieldExhaust(arg0_5, arg1_5)
	if arg0_5._exhaustRemove then
		arg1_5:SetToCancel()
	else
		arg0_5:switchMode(var1_0.MODE_RECORD)
	end
end

function var1_0.switchMode(arg0_6, arg1_6)
	arg0_6._buffMode = arg1_6

	local var0_6 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg1_6 == var1_0.MODE_SHIELD then
		arg0_6._shieldStartTimeStamp = var0_6
		arg0_6._shieldValue = arg0_6:calcNumber()
		arg0_6.onTakeDamage = var1_0.__shieldTakeDamage

		local var1_6 = {
			index = arg0_6._effectIndex,
			effect = arg0_6._fxName
		}

		arg0_6._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, var1_6))
	elseif arg1_6 == var1_0.MODE_RECORD then
		arg0_6._recordStartTimeStamp = var0_6
		arg0_6._recordDamage = 0
		arg0_6._shieldValue = 0
		arg0_6.onTakeDamage = var1_0.__recordDamage

		arg0_6._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
			index = arg0_6._effectIndex
		}))
	end
end

function var1_0.__shieldTakeDamage(arg0_7, arg1_7, arg2_7, arg3_7)
	if arg0_7:damageCheck(arg3_7) then
		local var0_7 = arg3_7.damage

		arg0_7._shieldValue = arg0_7._shieldValue - var0_7

		if arg0_7._shieldValue > 0 then
			arg3_7.damage = 0
		else
			arg3_7.damage = -arg0_7._shieldValue

			arg0_7:handleShieldExhaust(arg2_7)
		end
	end
end

function var1_0.__recordDamage(arg0_8, arg1_8, arg2_8, arg3_8)
	if not arg0_8:damageCheck(arg3_8) then
		return
	end

	if not arg0_8:DamageSourceRequire(arg3_8.damageSrc) then
		return
	end

	arg0_8._recordDamage = arg0_8._recordDamage + arg3_8.damage

	if not arg0_8._recordDuration and arg0_8:calcNumber() >= 1 then
		arg0_8:switchMode(var1_0.MODE_SHIELD)
	end
end

function var1_0.calcNumber(arg0_9)
	return (math.max(0, math.floor(arg0_9._recordDamage * arg0_9._convertRate)))
end

function var1_0.Clear(arg0_10)
	arg0_10._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
		index = arg0_10._effectIndex
	}))
	var1_0.super.Clear(arg0_10)
end

ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffRecordShield = class("BattleBuffRecordShield", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffRecordShield.__name = "BattleBuffRecordShield"

local var1 = var0.Battle.BattleBuffRecordShield

var1.MODE_RECORD = "record"
var1.MODE_SHIELD = "shield"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectAttachData(arg0)
	return arg0._shieldValue
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._damageAttrRequire = var0.damageAttr
	arg0._damageSrcTagRequire = var0.srcTag
	arg0._convertRate = var0.convertRate
	arg0._shieldDuration = var0.shield_duration
	arg0._recordDuration = var0.record_duration
	arg0._exhaustRemove = var0.exhaust_remove
	arg0._shieldValue = 0
	arg0._recordDamage = 0
	arg0._shieldStartTimeStamp = 0
	arg0._recordStartTimeStamp = 0
	arg0._unit = arg1
	arg0._fxName = var0.effect
	arg0._effectIndex = "BattleBuffRecordShield" .. arg2:GetID()

	arg0:switchMode(var1.MODE_RECORD)
end

function var1.onUpdate(arg0, arg1, arg2)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0._buffMode == var1.MODE_SHIELD then
		if arg0._shieldDuration and var0 - arg0._shieldStartTimeStamp > arg0._shieldDuration or arg0._shieldValue <= 0 then
			arg0:handleShieldExhaust(arg2)
		end
	elseif arg0._buffMode == var1.MODE_RECORD and arg0._recordDuration and var0 - arg0._recordStartTimeStamp > arg0._recordDuration then
		arg0:switchMode(var1.MODE_SHIELD)
	end
end

function var1.handleShieldExhaust(arg0, arg1)
	if arg0._exhaustRemove then
		arg1:SetToCancel()
	else
		arg0:switchMode(var1.MODE_RECORD)
	end
end

function var1.switchMode(arg0, arg1)
	arg0._buffMode = arg1

	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg1 == var1.MODE_SHIELD then
		arg0._shieldStartTimeStamp = var0
		arg0._shieldValue = arg0:calcNumber()
		arg0.onTakeDamage = var1.__shieldTakeDamage

		local var1 = {
			index = arg0._effectIndex,
			effect = arg0._fxName
		}

		arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.ADD_EFFECT, var1))
	elseif arg1 == var1.MODE_RECORD then
		arg0._recordStartTimeStamp = var0
		arg0._recordDamage = 0
		arg0._shieldValue = 0
		arg0.onTakeDamage = var1.__recordDamage

		arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
			index = arg0._effectIndex
		}))
	end
end

function var1.__shieldTakeDamage(arg0, arg1, arg2, arg3)
	if arg0:damageCheck(arg3) then
		local var0 = arg3.damage

		arg0._shieldValue = arg0._shieldValue - var0

		if arg0._shieldValue > 0 then
			arg3.damage = 0
		else
			arg3.damage = -arg0._shieldValue

			arg0:handleShieldExhaust(arg2)
		end
	end
end

function var1.__recordDamage(arg0, arg1, arg2, arg3)
	if not arg0:damageCheck(arg3) then
		return
	end

	if not arg0:DamageSourceRequire(arg3.damageSrc) then
		return
	end

	arg0._recordDamage = arg0._recordDamage + arg3.damage

	if not arg0._recordDuration and arg0:calcNumber() >= 1 then
		arg0:switchMode(var1.MODE_SHIELD)
	end
end

function var1.calcNumber(arg0)
	return (math.max(0, math.floor(arg0._recordDamage * arg0._convertRate)))
end

function var1.Clear(arg0)
	arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
		index = arg0._effectIndex
	}))
	var1.super.Clear(arg0)
end

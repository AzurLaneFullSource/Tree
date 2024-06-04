ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = class("BattleGravitationBulletUnit", var0.Battle.BattleBulletUnit)

var0.Battle.BattleGravitationBulletUnit = var2
var2.__name = "BattleGravitationBulletUnit"

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)
end

function var2.Update(arg0, arg1)
	if arg0._pierceCount > 0 then
		var2.super.Update(arg0, arg1)
	end
end

function var2.SetTemplateData(arg0, arg1)
	var2.super.SetTemplateData(arg0, arg1)

	arg0._hitInterval = arg1.hit_type.interval or 0.2
end

function var2.GetExplodePostion(arg0)
	return arg0._explodePos
end

function var2.SetExplodePosition(arg0, arg1)
	arg0._explodePos = arg1
end

function var2.DealDamage(arg0)
	arg0._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._hitInterval
end

function var2.CanDealDamage(arg0)
	if not arg0._nextDamageTime then
		arg0._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._tempData.extra_param.alert_duration

		return false
	else
		return arg0._nextDamageTime < pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var2.Hit(arg0, arg1, arg2)
	var2.super.Hit(arg0, arg1, arg2)

	arg0._pierceCount = arg0._pierceCount - 1
	arg0._position.y = 100
end

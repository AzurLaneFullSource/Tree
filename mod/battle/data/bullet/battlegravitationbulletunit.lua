ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = class("BattleGravitationBulletUnit", var0_0.Battle.BattleBulletUnit)

var0_0.Battle.BattleGravitationBulletUnit = var2_0
var2_0.__name = "BattleGravitationBulletUnit"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var2_0.Update(arg0_2, arg1_2)
	if arg0_2._pierceCount > 0 then
		var2_0.super.Update(arg0_2, arg1_2)
	end
end

function var2_0.SetTemplateData(arg0_3, arg1_3)
	var2_0.super.SetTemplateData(arg0_3, arg1_3)

	arg0_3._hitInterval = arg1_3.hit_type.interval or 0.2
end

function var2_0.GetExplodePostion(arg0_4)
	return arg0_4._explodePos
end

function var2_0.SetExplodePosition(arg0_5, arg1_5)
	arg0_5._explodePos = arg1_5
end

function var2_0.DealDamage(arg0_6)
	arg0_6._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_6._hitInterval
end

function var2_0.CanDealDamage(arg0_7)
	if not arg0_7._nextDamageTime then
		arg0_7._nextDamageTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_7._tempData.extra_param.alert_duration

		return false
	else
		return arg0_7._nextDamageTime < pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var2_0.Hit(arg0_8, arg1_8, arg2_8)
	var2_0.super.Hit(arg0_8, arg1_8, arg2_8)

	arg0_8._pierceCount = arg0_8._pierceCount - 1
	arg0_8._position.y = 100
end

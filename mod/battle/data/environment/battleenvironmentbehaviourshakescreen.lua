ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourShakeScreen", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourShakeScreen = var3
var3.__name = "BattleEnvironmentBehaviourShakeScreen"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._shakeID = arg0._tmpData.shake_ID
end

function var3.doBehaviour(arg0)
	var0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[arg0._shakeID])

	arg0._state = var3.STATE_OVERHEAT

	if arg0._tmpData.reload_time then
		arg0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

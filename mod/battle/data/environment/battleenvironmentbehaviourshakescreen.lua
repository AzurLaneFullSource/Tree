ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourShakeScreen", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourShakeScreen = var3_0
var3_0.__name = "BattleEnvironmentBehaviourShakeScreen"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._shakeID = arg0_2._tmpData.shake_ID
end

function var3_0.doBehaviour(arg0_3)
	var0_0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[arg0_3._shakeID])

	arg0_3._state = var3_0.STATE_OVERHEAT

	if arg0_3._tmpData.reload_time then
		arg0_3._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

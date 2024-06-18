ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourPlaySFX", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourPlaySFX = var3_0
var3_0.__name = "BattleEnvironmentBehaviourPlaySFX"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._sfx = arg0_2._tmpData.SFX_ID
end

function var3_0.doBehaviour(arg0_3)
	var0_0.Battle.PlayBattleSFX(arg0_3._sfx)
	var3_0.super.doBehaviour(arg0_3)
end

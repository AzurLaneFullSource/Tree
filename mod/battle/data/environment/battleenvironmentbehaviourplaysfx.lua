ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourPlaySFX", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourPlaySFX = var3
var3.__name = "BattleEnvironmentBehaviourPlaySFX"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._sfx = arg0._tmpData.SFX_ID
end

function var3.doBehaviour(arg0)
	var0.Battle.PlayBattleSFX(arg0._sfx)
	var3.super.doBehaviour(arg0)
end

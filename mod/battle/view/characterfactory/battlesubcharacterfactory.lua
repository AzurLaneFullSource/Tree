ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleSubCharacterFactory", var0_0.Battle.BattlePlayerCharacterFactory)

var0_0.Battle.BattleSubCharacterFactory = var1_0
var1_0.__name = "BattleSubCharacterFactory"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.ARROW_BAR_NAME = "EnemyArrowContainer/SubArrow"
end

function var1_0.MakeCharacter(arg0_2)
	return var0_0.Battle.BattleSubCharacter.New()
end

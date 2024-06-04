ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleSubCharacterFactory", var0.Battle.BattlePlayerCharacterFactory)

var0.Battle.BattleSubCharacterFactory = var1
var1.__name = "BattleSubCharacterFactory"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0.ARROW_BAR_NAME = "EnemyArrowContainer/SubArrow"
end

function var1.MakeCharacter(arg0)
	return var0.Battle.BattleSubCharacter.New()
end

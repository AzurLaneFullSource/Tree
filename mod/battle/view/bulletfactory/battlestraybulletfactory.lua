ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.UnitType

var0_0.Battle.BattleStrayBulletFactory = singletonClass("BattleStrayBulletFactory", var0_0.Battle.BattleCannonBulletFactory)
var0_0.Battle.BattleStrayBulletFactory.__name = "BattleStrayBulletFactory"

local var2_0 = var0_0.Battle.BattleStrayBulletFactory

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.MakeBullet(arg0_2)
	return var0_0.Battle.BattleStrayBullet.New()
end

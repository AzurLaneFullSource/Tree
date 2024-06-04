ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.UnitType

var0.Battle.BattleStrayBulletFactory = singletonClass("BattleStrayBulletFactory", var0.Battle.BattleCannonBulletFactory)
var0.Battle.BattleStrayBulletFactory.__name = "BattleStrayBulletFactory"

local var2 = var0.Battle.BattleStrayBulletFactory

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.MakeBullet(arg0)
	return var0.Battle.BattleStrayBullet.New()
end

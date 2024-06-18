ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleResourceManager
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = class("BattleLaserArea", var0_0.Battle.BattleBullet)

var0_0.Battle.BattleLaserArea = var4_0
var4_0.__name = "BattleLaserArea"

function var4_0.Update(arg0_1, arg1_1)
	local var0_1 = arg0_1._bulletData:GetSpeed()

	if var0_1.x ~= 0 or var0_1.z ~= 0 or var0_1.y ~= 0 then
		arg0_1:UpdatePosition()
	end
end

ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleResourceManager
local var3 = var0.Battle.BattleConfig
local var4 = class("BattleLaserArea", var0.Battle.BattleBullet)

var0.Battle.BattleLaserArea = var4
var4.__name = "BattleLaserArea"

function var4.Update(arg0, arg1)
	local var0 = arg0._bulletData:GetSpeed()

	if var0.x ~= 0 or var0.z ~= 0 or var0.y ~= 0 then
		arg0:UpdatePosition()
	end
end

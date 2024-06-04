ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleLaserEffect", var0.Battle.BattleEffectArea)

var0.Battle.BattleLaserEffect = var2
var2.__name = "BattleLaserEffect"

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)
end

function var2.SetStatic(arg0)
	return
end

function var2.Init(arg0)
	arg0._tf = arg0._go.transform
	arg0._laserScript = GetComponent(arg0._go, "LaserScript")
	arg0._waveCount = 0

	arg0:Update()
end

function var2.Update(arg0)
	arg0:updateLineRenderer()
	arg0:UpdatePosition()
end

function var2.updateLineRenderer(arg0)
	local var0 = arg0._aoeData:GetHeight()

	arg0._laserScript.width = var0 + math.cos(arg0._waveCount * math.deg2Rad * 3)
	arg0._waveCount = arg0._waveCount + 1
	arg0._laserScript.length = arg0._aoeData:GetWidth()

	local var1 = arg0._aoeData:GetAngle() * math.deg2Rad

	if arg0._aoeData:GetIFF() == -1 then
		var1 = var1 + math.pi
	end

	arg0._laserScript.angle = var1
end

ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleLaserEffect", var0_0.Battle.BattleEffectArea)

var0_0.Battle.BattleLaserEffect = var2_0
var2_0.__name = "BattleLaserEffect"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var2_0.SetStatic(arg0_2)
	return
end

function var2_0.Init(arg0_3)
	arg0_3._tf = arg0_3._go.transform
	arg0_3._laserScript = GetComponent(arg0_3._go, "LaserScript")
	arg0_3._waveCount = 0

	arg0_3:Update()
end

function var2_0.Update(arg0_4)
	arg0_4:updateLineRenderer()
	arg0_4:UpdatePosition()
end

function var2_0.updateLineRenderer(arg0_5)
	local var0_5 = arg0_5._aoeData:GetHeight()

	arg0_5._laserScript.width = var0_5 + math.cos(arg0_5._waveCount * math.deg2Rad * 3)
	arg0_5._waveCount = arg0_5._waveCount + 1
	arg0_5._laserScript.length = arg0_5._aoeData:GetWidth()

	local var1_5 = arg0_5._aoeData:GetAngle() * math.deg2Rad

	if arg0_5._aoeData:GetIFF() == -1 then
		var1_5 = var1_5 + math.pi
	end

	arg0_5._laserScript.angle = var1_5
end

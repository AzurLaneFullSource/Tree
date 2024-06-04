ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleFormulas
local var3 = Vector3.up
local var4 = var0.Battle.BattleVariable
local var5 = var0.Battle.BattleConfig

var0.Battle.BattleScaleBulletUnit = class("BattleScaleBulletUnit", var0.Battle.BattleBulletUnit)
var0.Battle.BattleScaleBulletUnit.__name = "BattleScaleBulletUnit"

local var6 = var0.Battle.BattleScaleBulletUnit

function var6.Ctor(arg0, arg1, arg2)
	var6.super.Ctor(arg0, arg1, arg2)

	arg0._scaleX = 0
end

function var6.Update(arg0, arg1)
	local var0 = arg0._tempData.cld_box

	if arg0._scaleX + var0[1] > arg0._scaleLimit then
		arg0:calcSpeed()
	else
		arg0:UpdateCLDBox()
	end

	var6.super.Update(arg0, arg1)
end

function var6.SetTemplateData(arg0, arg1)
	var6.super.SetTemplateData(arg0, arg1)

	arg0._scaleSpeed = arg0._tempData.extra_param.scaleSpeed
	arg0._scaleLimit = arg0._tempData.extra_param.cldMax
end

function var6.InitSpeed(arg0, arg1)
	var6.super.InitSpeed(arg0, arg1)
	arg0:calcScaleSpeed()
end

function var6.calcScaleSpeed(arg0)
	local var0 = arg0._scaleSpeed * 0.5
	local var1 = math.deg2Rad * arg0._yAngle

	arg0._speed = Vector3(var0 * math.cos(var1), 0, var0 * math.sin(var1))
end

function var6.UpdateCLDBox(arg0)
	local var0 = arg0._tempData.cld_box

	arg0._scaleX = arg0._scaleX + arg0._scaleSpeed

	arg0._cldComponent:ResetSize(var0[1] + arg0._scaleX, var0[2], var0[3])
end

function var6.GetRadian(arg0)
	local var0 = arg0._radCache or arg0:GetYAngle() * math.deg2Rad
	local var1 = arg0._cosCache or math.cos(var0)
	local var2 = arg0._sinCache or math.sin(var0)

	return var0, var1, var2
end

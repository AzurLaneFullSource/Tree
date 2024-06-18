ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = Vector3.up
local var4_0 = var0_0.Battle.BattleVariable
local var5_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleScaleBulletUnit = class("BattleScaleBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleScaleBulletUnit.__name = "BattleScaleBulletUnit"

local var6_0 = var0_0.Battle.BattleScaleBulletUnit

function var6_0.Ctor(arg0_1, arg1_1, arg2_1)
	var6_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._scaleX = 0
end

function var6_0.Update(arg0_2, arg1_2)
	local var0_2 = arg0_2._tempData.cld_box

	if arg0_2._scaleX + var0_2[1] > arg0_2._scaleLimit then
		arg0_2:calcSpeed()
	else
		arg0_2:UpdateCLDBox()
	end

	var6_0.super.Update(arg0_2, arg1_2)
end

function var6_0.SetTemplateData(arg0_3, arg1_3)
	var6_0.super.SetTemplateData(arg0_3, arg1_3)

	arg0_3._scaleSpeed = arg0_3._tempData.extra_param.scaleSpeed
	arg0_3._scaleLimit = arg0_3._tempData.extra_param.cldMax
end

function var6_0.InitSpeed(arg0_4, arg1_4)
	var6_0.super.InitSpeed(arg0_4, arg1_4)
	arg0_4:calcScaleSpeed()
end

function var6_0.calcScaleSpeed(arg0_5)
	local var0_5 = arg0_5._scaleSpeed * 0.5
	local var1_5 = math.deg2Rad * arg0_5._yAngle

	arg0_5._speed = Vector3(var0_5 * math.cos(var1_5), 0, var0_5 * math.sin(var1_5))
end

function var6_0.UpdateCLDBox(arg0_6)
	local var0_6 = arg0_6._tempData.cld_box

	arg0_6._scaleX = arg0_6._scaleX + arg0_6._scaleSpeed

	arg0_6._cldComponent:ResetSize(var0_6[1] + arg0_6._scaleX, var0_6[2], var0_6[3])
end

function var6_0.GetRadian(arg0_7)
	local var0_7 = arg0_7._radCache or arg0_7:GetYAngle() * math.deg2Rad
	local var1_7 = arg0_7._cosCache or math.cos(var0_7)
	local var2_7 = arg0_7._sinCache or math.sin(var0_7)

	return var0_7, var1_7, var2_7
end

ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEffectArea")

var0_0.Battle.BattleEffectArea = var3_0
var3_0.__name = "BattleEffectArea"

local var4_0 = Vector3(0, 3.5, -5)

function var3_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1
	arg0_1._aoeData = arg2_1
	arg0_1._topCover = arg3_1

	arg0_1:Init()
end

function var3_0.Init(arg0_2)
	arg0_2._tf = arg0_2._go.transform
	arg0_2._areaType = arg0_2._aoeData:GetAreaType()

	if arg0_2._areaType == var1_0.AreaType.CUBE then
		arg0_2.UpdateScale = arg0_2.updateCubeScale
	elseif arg0_2._areaType == var1_0.AreaType.COLUMN then
		arg0_2.UpdateScale = arg0_2.updateColumnScale
	end

	if arg0_2._aoeData:GetIFF() == var2_0.FOE_CODE then
		function arg0_2.GetAngle()
			return arg0_2._aoeData:GetAngle() * -1 + 180
		end
	else
		function arg0_2.GetAngle()
			return arg0_2._aoeData:GetAngle() * -1
		end
	end

	arg0_2:Update()
end

function var3_0.Update(arg0_5)
	arg0_5:UpdateScale()
	arg0_5:UpdatePosition()
	arg0_5:UpdateRotation()
end

function var3_0.updateCubeScale(arg0_6)
	local var0_6 = 1
	local var1_6 = 1

	if not arg0_6._aoeData:GetFXStatic() then
		var0_6 = arg0_6._aoeData:GetWidth() * arg0_6._aoeData:GetIFF()
		var1_6 = arg0_6._aoeData:GetHeight()
	end

	if var0_6 == arg0_6._preWidth and var1_6 == arg0_6._preHeight then
		return
	end

	arg0_6._tf.localScale = Vector3(var0_6, 1, var1_6)
	arg0_6._preWidth = var0_6
	arg0_6._preHeight = var1_6
end

function var3_0.updateColumnScale(arg0_7)
	local var0_7 = arg0_7._aoeData:GetRange()

	if var0_7 == arg0_7._preRange then
		return
	end

	arg0_7._tf.localScale = Vector3(var0_7, 1, var0_7)
	arg0_7._preRange = var0_7
end

function var3_0.UpdatePosition(arg0_8)
	if arg0_8._topCover then
		arg0_8._tf.position = arg0_8._aoeData:GetPosition() + var4_0
	else
		arg0_8._tf.position = arg0_8._aoeData:GetPosition()
	end
end

function var3_0.UpdateRotation(arg0_9)
	local var0_9 = arg0_9:GetAngle()

	if arg0_9._preAngle == var0_9 then
		return
	end

	arg0_9._tf.localEulerAngles = Vector3(0, var0_9, 0)
	arg0_9._preAngle = var0_9
end

function var3_0.Dispose(arg0_10)
	var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0_10._go)

	arg0_10._go = nil
end

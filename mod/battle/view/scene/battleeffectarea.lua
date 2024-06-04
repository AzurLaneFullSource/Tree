ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEffectArea")

var0.Battle.BattleEffectArea = var3
var3.__name = "BattleEffectArea"

local var4 = Vector3(0, 3.5, -5)

function var3.Ctor(arg0, arg1, arg2, arg3)
	arg0._go = arg1
	arg0._aoeData = arg2
	arg0._topCover = arg3

	arg0:Init()
end

function var3.Init(arg0)
	arg0._tf = arg0._go.transform
	arg0._areaType = arg0._aoeData:GetAreaType()

	if arg0._areaType == var1.AreaType.CUBE then
		arg0.UpdateScale = arg0.updateCubeScale
	elseif arg0._areaType == var1.AreaType.COLUMN then
		arg0.UpdateScale = arg0.updateColumnScale
	end

	if arg0._aoeData:GetIFF() == var2.FOE_CODE then
		function arg0.GetAngle()
			return arg0._aoeData:GetAngle() * -1 + 180
		end
	else
		function arg0.GetAngle()
			return arg0._aoeData:GetAngle() * -1
		end
	end

	arg0:Update()
end

function var3.Update(arg0)
	arg0:UpdateScale()
	arg0:UpdatePosition()
	arg0:UpdateRotation()
end

function var3.updateCubeScale(arg0)
	local var0 = 1
	local var1 = 1

	if not arg0._aoeData:GetFXStatic() then
		var0 = arg0._aoeData:GetWidth() * arg0._aoeData:GetIFF()
		var1 = arg0._aoeData:GetHeight()
	end

	if var0 == arg0._preWidth and var1 == arg0._preHeight then
		return
	end

	arg0._tf.localScale = Vector3(var0, 1, var1)
	arg0._preWidth = var0
	arg0._preHeight = var1
end

function var3.updateColumnScale(arg0)
	local var0 = arg0._aoeData:GetRange()

	if var0 == arg0._preRange then
		return
	end

	arg0._tf.localScale = Vector3(var0, 1, var0)
	arg0._preRange = var0
end

function var3.UpdatePosition(arg0)
	if arg0._topCover then
		arg0._tf.position = arg0._aoeData:GetPosition() + var4
	else
		arg0._tf.position = arg0._aoeData:GetPosition()
	end
end

function var3.UpdateRotation(arg0)
	local var0 = arg0:GetAngle()

	if arg0._preAngle == var0 then
		return
	end

	arg0._tf.localEulerAngles = Vector3(0, var0, 0)
	arg0._preAngle = var0
end

function var3.Dispose(arg0)
	var0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0._go)

	arg0._go = nil
end

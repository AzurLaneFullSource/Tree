ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleArcEffect")

var0.Battle.BattleArcEffect = var3
var3.__name = "BattleArcEffect"

function var3.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._go = arg1
	arg0._characterA = arg2
	arg0._unitA = arg2:GetUnitData()
	arg0._unitB = arg3
	arg0._boundBone = arg4
	arg0._material = arg0._go.transform:GetComponent(typeof(Renderer)).material

	local var0 = arg0._characterA:GetBonePos(arg0._boundBone)
	local var1 = arg0._unitB:GetPosition()

	arg0._vectorA = Vector4.New(var0.x, 5, var0.z, 1)
	arg0._vectorB = Vector4.New(var1.x, 5, var1.z, 1)

	arg0._material:SetVector("_PosBegin", arg0._vectorA)
	arg0._material:SetVector("_PosEnd", arg0._vectorB)
end

function var3.Update(arg0)
	if arg0._unitA:IsAlive() and arg0._unitB:IsAlive() then
		local var0 = arg0._characterA:GetBonePos(arg0._boundBone)
		local var1 = arg0._unitB:GetPosition()

		arg0._vectorA.x = var0.x
		arg0._vectorA.z = var0.z
		arg0._vectorB.x = var1.x
		arg0._vectorB.z = var1.z

		arg0._material:SetVector("_PosBegin", arg0._vectorA)
		arg0._material:SetVector("_PosEnd", arg0._vectorB)

		arg0._go.transform.position = arg0._vectorA
	else
		arg0._callback()
	end
end

function var3.ConfigCallback(arg0, arg1)
	arg0._callback = arg1

	pg.EffectMgr.GetInstance():PlayBattleEffect(arg0._go, Vector3.zero, true, arg0._callback)
end

function var3.Dispose(arg0)
	arg0._callback = nil
	arg0._material = nil
	arg0._go = nil
	arg0._unitA = nil
	arg0._unitB = nil
	arg0._vectorA = nil
	arg0._vectorB = nil
end

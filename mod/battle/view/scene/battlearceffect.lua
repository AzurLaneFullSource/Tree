ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleArcEffect")

var0_0.Battle.BattleArcEffect = var3_0
var3_0.__name = "BattleArcEffect"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._go = arg1_1
	arg0_1._characterA = arg2_1
	arg0_1._unitA = arg2_1:GetUnitData()
	arg0_1._unitB = arg3_1
	arg0_1._boundBone = arg4_1
	arg0_1._material = arg0_1._go.transform:GetComponent(typeof(Renderer)).material

	local var0_1 = arg0_1._characterA:GetBonePos(arg0_1._boundBone)
	local var1_1 = arg0_1._unitB:GetPosition()

	arg0_1._vectorA = Vector4.New(var0_1.x, 5, var0_1.z, 1)
	arg0_1._vectorB = Vector4.New(var1_1.x, 5, var1_1.z, 1)

	arg0_1._material:SetVector("_PosBegin", arg0_1._vectorA)
	arg0_1._material:SetVector("_PosEnd", arg0_1._vectorB)
end

function var3_0.Update(arg0_2)
	if arg0_2._unitA:IsAlive() and arg0_2._unitB:IsAlive() then
		local var0_2 = arg0_2._characterA:GetBonePos(arg0_2._boundBone)
		local var1_2 = arg0_2._unitB:GetPosition()

		arg0_2._vectorA.x = var0_2.x
		arg0_2._vectorA.z = var0_2.z
		arg0_2._vectorB.x = var1_2.x
		arg0_2._vectorB.z = var1_2.z

		arg0_2._material:SetVector("_PosBegin", arg0_2._vectorA)
		arg0_2._material:SetVector("_PosEnd", arg0_2._vectorB)

		arg0_2._go.transform.position = arg0_2._vectorA
	else
		arg0_2._callback()
	end
end

function var3_0.ConfigCallback(arg0_3, arg1_3)
	arg0_3._callback = arg1_3

	pg.EffectMgr.GetInstance():PlayBattleEffect(arg0_3._go, Vector3.zero, true, arg0_3._callback)
end

function var3_0.Dispose(arg0_4)
	arg0_4._callback = nil
	arg0_4._material = nil
	arg0_4._go = nil
	arg0_4._unitA = nil
	arg0_4._unitB = nil
	arg0_4._vectorA = nil
	arg0_4._vectorB = nil
end

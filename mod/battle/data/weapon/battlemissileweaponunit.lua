ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleDataFunction
local var3_0 = class("BattleMissileWeaponUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleMissileWeaponUnit = var3_0
var3_0.__name = "BattleMissileWeaponUnit"

function var3_0.CalculateFixedExplodePosition(arg0_1, arg1_1)
	local var0_1 = arg1_1._range
	local var1_1 = (arg0_1._host:GetDirection() == var1_0.UnitDir.RIGHT and 1 or -1) * var0_1
	local var2_1 = arg0_1._host:GetPosition()

	return Vector3(var2_1.x + var1_1, 0, 0)
end

function var3_0.CalculateRandTargetPosition(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg2_2:GetCLDZCenterPosition()
	local var1_2 = arg1_2:GetTemplate().extra_param
	local var2_2 = var1_2.accuracy
	local var3_2 = 0

	if var2_2 then
		var3_2 = arg1_2:GetAttrByName(var2_2)
	end

	local var4_2 = var1_2.randomOffsetX or 0
	local var5_2 = var1_2.randomOffsetZ or 0
	local var6_2 = math.max(0, var4_2 - var3_2)
	local var7_2 = math.max(0, var5_2 - var3_2)
	local var8_2 = var1_2.offsetX or 0
	local var9_2 = var1_2.offsetZ or 0

	if var6_2 ~= 0 then
		var6_2 = var6_2 * (math.random() - 0.5) + var8_2
	end

	if var7_2 ~= 0 then
		var7_2 = var7_2 * (math.random() - 0.5) + var9_2
	end

	local var10_2 = var1_2.targetOffsetX or 0
	local var11_2 = var1_2.targetOffsetZ or 0

	return Vector3(var0_2.x + var6_2 + var10_2, 0, var0_2.z + var7_2 + var11_2)
end

function var3_0.createMajorEmitter(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	local function var0_3(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
		local var0_4 = arg0_3._emitBulletIDList[arg2_3]
		local var1_4 = arg0_3:Spawn(var0_4, arg4_4, var3_0.INTERNAL)

		var1_4:SetOffsetPriority(arg3_4)
		var1_4:SetShiftInfo(arg0_4, arg1_4)
		var1_4:SetRotateInfo(nil, arg0_3:GetBaseAngle(), arg2_4)
		var1_4:RegisterOnTheAir(arg0_3:ChoiceOntheAir(var1_4))
		arg0_3:DispatchBulletEvent(var1_4)
	end

	return var3_0.super.createMajorEmitter(arg0_3, arg1_3, arg2_3, arg3_3, var0_3, nil)
end

function var3_0.ChoiceOntheAir(arg0_5, arg1_5)
	return function()
		local var0_6 = arg1_5:GetMissileTargetPosition()
		local var1_6, var2_6, var3_6 = arg1_5:GetRotateInfo()
		local var4_6, var5_6 = arg1_5:GetOffset()

		var0_6:Add(Vector3(var4_6, 0, var5_6))

		local var6_6 = Quaternion.Euler(0, var3_6, 0)
		local var7_6 = pg.Tool.FilterY(var0_6 - arg1_5:GetSpawnPosition())
		local var8_6 = arg1_5:GetSpawnPosition() + var6_6 * var7_6

		arg1_5:SetExplodePosition(var8_6)
		var0_0.Battle.BattleMissileFactory.CreateBulletAlert(arg1_5)
	end
end

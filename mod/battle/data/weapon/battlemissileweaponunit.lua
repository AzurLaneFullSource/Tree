ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleDataFunction
local var3 = class("BattleMissileWeaponUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleMissileWeaponUnit = var3
var3.__name = "BattleMissileWeaponUnit"

function var3.CalculateFixedExplodePosition(arg0, arg1)
	local var0 = arg1._range
	local var1 = (arg0._host:GetDirection() == var1.UnitDir.RIGHT and 1 or -1) * var0
	local var2 = arg0._host:GetPosition()

	return Vector3(var2.x + var1, 0, 0)
end

function var3.CalculateRandTargetPosition(arg0, arg1, arg2)
	local var0 = arg2:GetCLDZCenterPosition()
	local var1 = arg1:GetTemplate().extra_param
	local var2 = var1.accuracy
	local var3 = 0

	if var2 then
		var3 = arg1:GetAttrByName(var2)
	end

	local var4 = var1.randomOffsetX or 0
	local var5 = var1.randomOffsetZ or 0
	local var6 = math.max(0, var4 - var3)
	local var7 = math.max(0, var5 - var3)
	local var8 = var1.offsetX or 0
	local var9 = var1.offsetZ or 0

	if var6 ~= 0 then
		var6 = var6 * (math.random() - 0.5) + var8
	end

	if var7 ~= 0 then
		var7 = var7 * (math.random() - 0.5) + var9
	end

	local var10 = var1.targetOffsetX or 0
	local var11 = var1.targetOffsetZ or 0

	return Vector3(var0.x + var6 + var10, 0, var0.z + var7 + var11)
end

function var3.createMajorEmitter(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg0._emitBulletIDList[arg2]
		local var1 = arg0:Spawn(var0, arg4, var3.INTERNAL)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)
		var1:SetRotateInfo(nil, arg0:GetBaseAngle(), arg2)
		var1:RegisterOnTheAir(arg0:ChoiceOntheAir(var1))
		arg0:DispatchBulletEvent(var1)
	end

	return var3.super.createMajorEmitter(arg0, arg1, arg2, arg3, var0, nil)
end

function var3.ChoiceOntheAir(arg0, arg1)
	return function()
		local var0 = arg1:GetMissileTargetPosition()
		local var1, var2, var3 = arg1:GetRotateInfo()
		local var4, var5 = arg1:GetOffset()

		var0:Add(Vector3(var4, 0, var5))

		local var6 = Quaternion.Euler(0, var3, 0)
		local var7 = pg.Tool.FilterY(var0 - arg1:GetSpawnPosition())
		local var8 = arg1:GetSpawnPosition() + var6 * var7

		arg1:SetExplodePosition(var8)
		var0.Battle.BattleMissileFactory.CreateBulletAlert(arg1)
	end
end

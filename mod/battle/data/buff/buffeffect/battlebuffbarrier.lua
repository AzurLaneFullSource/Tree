ys = ys or {}

local var0 = ys
local var1 = pg.effect_offset

var0.Battle.BattleBuffBarrier = class("BattleBuffBarrier", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffBarrier.__name = "BattleBuffBarrier"

local var2 = var0.Battle.BattleBuffBarrier

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
end

function var2.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._durability = var0.durability
	arg0._dir = arg1:GetDirection()
	arg0._unit = arg1
	arg0._dataProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._centerPos = arg1:GetPosition()

	local function var1(arg0)
		arg0._dataProxy:HandleDamage(arg0, arg0._unit)
		arg0:Intercepted()
		arg0._dataProxy:RemoveBulletUnit(arg0:GetUniqueID())
	end

	local var2 = var0.cld_data
	local var3 = var2.box
	local var4 = Clone(var2.offset)

	if arg1:GetDirection() == var0.Battle.BattleConst.UnitDir.LEFT then
		var4[1] = -var4[1]
	end

	arg0._wall = arg0._dataProxy:SpawnWall(arg0, var1, var3, var4)
end

function var2.onUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg3.timeStamp

	arg0._centerPos = arg1:GetPosition()
end

function var2.onTakeDamage(arg0, arg1, arg2, arg3)
	if arg0:damageCheck(arg3) then
		local var0 = arg3.damage

		arg0._durability = arg0._durability - var0

		if arg0._durability > 0 then
			arg3.damage = 0
		else
			arg3.damage = -arg0._durability

			arg2:SetToCancel()
		end
	end
end

function var2.onAttach(arg0, arg1, arg2, arg3)
	if arg0._unit:IsBoss() then
		arg0._unit:BarrierStateChange(arg0._durability, arg2:GetDuration())
	end
end

function var2.onRemove(arg0, arg1, arg2, arg3)
	if arg0._unit:IsBoss() then
		arg0._unit:BarrierStateChange(0)
	end
end

function var2.GetIFF(arg0)
	return arg0._unit:GetIFF()
end

function var2.GetPosition(arg0)
	return arg0._centerPos
end

function var2.IsWallActive(arg0)
	return arg0._durability > 0
end

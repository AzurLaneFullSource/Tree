ys = ys or {}

local var0_0 = ys
local var1_0 = pg.effect_offset

var0_0.Battle.BattleBuffBarrier = class("BattleBuffBarrier", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffBarrier.__name = "BattleBuffBarrier"

local var2_0 = var0_0.Battle.BattleBuffBarrier

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._durability = var0_2.durability
	arg0_2._dir = arg1_2:GetDirection()
	arg0_2._unit = arg1_2
	arg0_2._dataProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_2._centerPos = arg1_2:GetPosition()

	local function var1_2(arg0_3)
		arg0_2._dataProxy:HandleDamage(arg0_3, arg0_2._unit)
		arg0_3:Intercepted()
		arg0_2._dataProxy:RemoveBulletUnit(arg0_3:GetUniqueID())
	end

	local var2_2 = var0_2.cld_data
	local var3_2 = var2_2.box
	local var4_2 = Clone(var2_2.offset)

	if arg1_2:GetDirection() == var0_0.Battle.BattleConst.UnitDir.LEFT then
		var4_2[1] = -var4_2[1]
	end

	arg0_2._wall = arg0_2._dataProxy:SpawnWall(arg0_2, var1_2, var3_2, var4_2)
end

function var2_0.onUpdate(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg3_4.timeStamp

	arg0_4._centerPos = arg1_4:GetPosition()
end

function var2_0.onTakeDamage(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg0_5:damageCheck(arg3_5) then
		local var0_5 = arg3_5.damage

		arg0_5._durability = arg0_5._durability - var0_5

		if arg0_5._durability > 0 then
			arg3_5.damage = 0
		else
			arg3_5.damage = -arg0_5._durability

			arg2_5:SetToCancel()
		end
	end
end

function var2_0.onAttach(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg0_6._unit:IsBoss() then
		arg0_6._unit:BarrierStateChange(arg0_6._durability, arg2_6:GetDuration())
	end
end

function var2_0.onRemove(arg0_7, arg1_7, arg2_7, arg3_7)
	if arg0_7._unit:IsBoss() then
		arg0_7._unit:BarrierStateChange(0)
	end
end

function var2_0.GetIFF(arg0_8)
	return arg0_8._unit:GetIFF()
end

function var2_0.GetPosition(arg0_9)
	return arg0_9._centerPos
end

function var2_0.IsWallActive(arg0_10)
	return arg0_10._durability > 0
end

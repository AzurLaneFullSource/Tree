ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffField", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffField = var1_0
var1_0.__name = "BattleBuffField"

local var2_0 = var0_0.Battle.BattleConst

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._level = arg2_2:GetLv()
	arg0_2._caster = arg2_2:GetCaster()

	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._auraBuffID = var0_2.buff_id
	arg0_2._target = var0_2.target
	arg0_2._check_target = var0_2.check_target or "TargetNull"
	arg0_2._isUpdateAura = var0_2.FAura

	local var1_2 = true
	local var2_2 = type(arg0_2._target)

	if var2_2 == "string" and arg0_2._target == "TargetAllHarm" or var2_2 == "table" and table.contains(arg0_2._target, "TargetAllHarm") or var2_2 == "string" and arg0_2._target == "TargetAllFoe" or var2_2 == "table" and table.contains(arg0_2._target, "TargetAllFoe") then
		var1_2 = false
	end

	local function var3_2(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3) do
			if iter1_3.Active then
				local var0_3 = arg0_2:getTargetList(arg1_2, arg0_2._target, arg0_2._tempData.arg_list)

				for iter2_3, iter3_3 in ipairs(var0_3) do
					if iter3_3:GetUniqueID() == iter1_3.UID then
						local var1_3 = var0_0.Battle.BattleBuffUnit.New(arg0_2._auraBuffID, arg0_2._level, arg0_2._caster)

						iter3_3:AddBuff(var1_3)

						break
					end
				end
			end
		end
	end

	local function var4_2(arg0_4)
		if arg0_4.Active then
			local var0_4 = arg0_2:getTargetList(arg1_2, arg0_2._target, arg0_2._tempData.arg_list)

			for iter0_4, iter1_4 in ipairs(var0_4) do
				if iter1_4:GetUniqueID() == arg0_4.UID then
					iter1_4:RemoveBuff(arg0_2._auraBuffID)

					break
				end
			end
		end
	end

	local var5_2 = arg0_2._isUpdateAura and var4_2 or nil
	local var6_2 = arg0_2._isUpdateAura and true or false
	local var7_2 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var8_2, var9_2, var10_2, var11_2 = var7_2:GetFieldBound()
	local var12_2 = Vector3((var10_2 + var11_2) * 0.5, 0, (var8_2 + var9_2) * 0.5)
	local var13_2 = math.abs(var11_2 - var10_2)
	local var14_2 = math.abs(var8_2 - var9_2)

	arg0_2._aura = var7_2:SpawnLastingCubeArea(var2_0.AOEField.SURFACE, arg1_2:GetIFF(), var12_2, var13_2, var14_2, 0, var3_2, var4_2, var1_2, nil, var5_2, var6_2)
end

function var1_0.Clear(arg0_5)
	arg0_5._aura:SetActiveFlag(false)

	arg0_5._aura = nil

	var1_0.super.Clear(arg0_5)
end

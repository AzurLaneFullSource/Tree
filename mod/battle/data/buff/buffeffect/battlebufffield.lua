ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffField", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffField = var1
var1.__name = "BattleBuffField"

local var2 = var0.Battle.BattleConst

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._level = arg2:GetLv()
	arg0._caster = arg2:GetCaster()

	local var0 = arg0._tempData.arg_list

	arg0._auraBuffID = var0.buff_id
	arg0._target = var0.target
	arg0._check_target = var0.check_target or "TargetNull"
	arg0._isUpdateAura = var0.FAura

	local var1 = true
	local var2 = type(arg0._target)

	if var2 == "string" and arg0._target == "TargetAllHarm" or var2 == "table" and table.contains(arg0._target, "TargetAllHarm") or var2 == "string" and arg0._target == "TargetAllFoe" or var2 == "table" and table.contains(arg0._target, "TargetAllFoe") then
		var1 = false
	end

	local function var3(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var0 = arg0:getTargetList(arg1, arg0._target, arg0._tempData.arg_list)

				for iter2, iter3 in ipairs(var0) do
					if iter3:GetUniqueID() == iter1.UID then
						local var1 = var0.Battle.BattleBuffUnit.New(arg0._auraBuffID, arg0._level, arg0._caster)

						iter3:AddBuff(var1)

						break
					end
				end
			end
		end
	end

	local function var4(arg0)
		if arg0.Active then
			local var0 = arg0:getTargetList(arg1, arg0._target, arg0._tempData.arg_list)

			for iter0, iter1 in ipairs(var0) do
				if iter1:GetUniqueID() == arg0.UID then
					iter1:RemoveBuff(arg0._auraBuffID)

					break
				end
			end
		end
	end

	local var5 = arg0._isUpdateAura and var4 or nil
	local var6 = arg0._isUpdateAura and true or false
	local var7 = var0.Battle.BattleDataProxy.GetInstance()
	local var8, var9, var10, var11 = var7:GetFieldBound()
	local var12 = Vector3((var10 + var11) * 0.5, 0, (var8 + var9) * 0.5)
	local var13 = math.abs(var11 - var10)
	local var14 = math.abs(var8 - var9)

	arg0._aura = var7:SpawnLastingCubeArea(var2.AOEField.SURFACE, arg1:GetIFF(), var12, var13, var14, 0, var3, var4, var1, nil, var5, var6)
end

function var1.Clear(arg0)
	arg0._aura:SetActiveFlag(false)

	arg0._aura = nil

	var1.super.Clear(arg0)
end

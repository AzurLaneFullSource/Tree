ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.BattleFleetBuffBlindAura = class("BattleFleetBuffBlindAura", var0.Battle.BattleFleetBuffEffect)
var0.Battle.BattleFleetBuffBlindAura.__name = "BattleFleetBuffBlindAura"

local var2 = var0.Battle.BattleFleetBuffBlindAura

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
end

function var2.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list.target
	local var1 = arg1:GetIFF()

	local function var2(arg0)
		local var0 = arg0:getTargetList(arg1, var0, arg0._tempData.arg_list)

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				for iter2, iter3 in ipairs(var0) do
					if iter3:GetUniqueID() == iter1.UID then
						iter3:SetBlindInvisible(true)

						break
					end
				end
			end
		end
	end

	local function var3(arg0)
		if arg0.Active then
			local var0 = arg0:getTargetList(arg1, var0, arg0._tempData.arg_list)

			for iter0, iter1 in ipairs(var0) do
				if iter1:GetUniqueID() == arg0.UID then
					iter1:SetBlindInvisible(false)

					break
				end
			end
		end
	end

	arg0._aura = var0.Battle.BattleDataProxy.GetInstance():SpawnLastingCubeArea(var1.AOEField.SURFACE, var1, Vector3(-55, 0, 55), 180, 70, 0, var2, var3, false)
end

function var2.Clear(arg0)
	arg0._aura:SetActiveFlag(false)

	arg0._aura = nil

	var2.super.Clear(arg0)
end

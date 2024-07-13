ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleFleetBuffBlindAura = class("BattleFleetBuffBlindAura", var0_0.Battle.BattleFleetBuffEffect)
var0_0.Battle.BattleFleetBuffBlindAura.__name = "BattleFleetBuffBlindAura"

local var2_0 = var0_0.Battle.BattleFleetBuffBlindAura

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list.target
	local var1_2 = arg1_2:GetIFF()

	local function var2_2(arg0_3)
		local var0_3 = arg0_2:getTargetList(arg1_2, var0_2, arg0_2._tempData.arg_list)

		for iter0_3, iter1_3 in ipairs(arg0_3) do
			if iter1_3.Active then
				for iter2_3, iter3_3 in ipairs(var0_3) do
					if iter3_3:GetUniqueID() == iter1_3.UID then
						iter3_3:SetBlindInvisible(true)

						break
					end
				end
			end
		end
	end

	local function var3_2(arg0_4)
		if arg0_4.Active then
			local var0_4 = arg0_2:getTargetList(arg1_2, var0_2, arg0_2._tempData.arg_list)

			for iter0_4, iter1_4 in ipairs(var0_4) do
				if iter1_4:GetUniqueID() == arg0_4.UID then
					iter1_4:SetBlindInvisible(false)

					break
				end
			end
		end
	end

	arg0_2._aura = var0_0.Battle.BattleDataProxy.GetInstance():SpawnLastingCubeArea(var1_0.AOEField.SURFACE, var1_2, Vector3(-55, 0, 55), 180, 70, 0, var2_2, var3_2, false)
end

function var2_0.Clear(arg0_5)
	arg0_5._aura:SetActiveFlag(false)

	arg0_5._aura = nil

	var2_0.super.Clear(arg0_5)
end

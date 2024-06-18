ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffBlindedHorizon", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffBlindedHorizon = var1_0
var1_0.__name = "BattleBuffBlindedHorizon"

local var2_0 = var0_0.Battle.BattleConst

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._horizonRange = arg0_2._tempData.arg_list.range

	local var0_2 = arg1_2:GetUniqueID()

	local function var1_2(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3) do
			if iter1_3.Active then
				local var0_3 = arg0_2:getTargetList(arg1_2, {
					"TargetAllHarm"
				})

				for iter2_3, iter3_3 in ipairs(var0_3) do
					if iter3_3:GetUniqueID() == iter1_3.UID then
						iter3_3:AppendExposed(var0_2)

						break
					end
				end
			end
		end
	end

	local function var2_2(arg0_4)
		if arg0_4.Active then
			local var0_4 = arg0_2:getTargetList(arg1_2, {
				"TargetAllHarm"
			})

			for iter0_4, iter1_4 in ipairs(var0_4) do
				if iter1_4:GetUniqueID() == arg0_4.UID then
					iter1_4:RemoveExposed(var0_2)

					break
				end
			end
		end
	end

	local function var3_2(arg0_5)
		if arg0_5.Active then
			local var0_5 = arg0_2:getTargetList(arg1_2, {
				"TargetAllHarm"
			})

			for iter0_5, iter1_5 in ipairs(var0_5) do
				if iter1_5:GetUniqueID() == arg0_5.UID then
					iter1_5:RemoveExposed(var0_2)

					break
				end
			end
		end
	end

	arg0_2._aura = var0_0.Battle.BattleDataProxy.GetInstance():SpawnLastingColumnArea(var2_0.AOEField.SURFACE, arg1_2:GetIFF(), arg1_2:GetPosition(), arg0_2._horizonRange, 0, var1_2, var2_2, false, nil, var3_2, true)

	local var4_2 = var0_0.Battle.BattleAOEMobilizedComponent.New(arg0_2._aura)

	var4_2:SetReferenceUnit(arg1_2)
	var4_2:ConfigData(var4_2.FOLLOW)
end

function var1_0.onAttach(arg0_6, arg1_6, arg2_6)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_6, "blindedHorizon", arg0_6._horizonRange)

	local var0_6 = arg1_6:GetFleetVO()

	if var0_6 then
		var0_6:UpdateHorizon()
	end
end

function var1_0.onRemove(arg0_7, arg1_7, arg2_7)
	var0_0.Battle.BattleAttr.FlashByBuff(arg1_7, "blindedHorizon", 0)
end

function var1_0.Clear(arg0_8)
	arg0_8._aura:SetActiveFlag(false)

	arg0_8._aura = nil

	var1_0.super.Clear(arg0_8)
end

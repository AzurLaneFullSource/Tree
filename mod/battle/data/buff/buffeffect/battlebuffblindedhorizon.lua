ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffBlindedHorizon", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffBlindedHorizon = var1
var1.__name = "BattleBuffBlindedHorizon"

local var2 = var0.Battle.BattleConst

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._horizonRange = arg0._tempData.arg_list.range

	local var0 = arg1:GetUniqueID()

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var0 = arg0:getTargetList(arg1, {
					"TargetAllHarm"
				})

				for iter2, iter3 in ipairs(var0) do
					if iter3:GetUniqueID() == iter1.UID then
						iter3:AppendExposed(var0)

						break
					end
				end
			end
		end
	end

	local function var2(arg0)
		if arg0.Active then
			local var0 = arg0:getTargetList(arg1, {
				"TargetAllHarm"
			})

			for iter0, iter1 in ipairs(var0) do
				if iter1:GetUniqueID() == arg0.UID then
					iter1:RemoveExposed(var0)

					break
				end
			end
		end
	end

	local function var3(arg0)
		if arg0.Active then
			local var0 = arg0:getTargetList(arg1, {
				"TargetAllHarm"
			})

			for iter0, iter1 in ipairs(var0) do
				if iter1:GetUniqueID() == arg0.UID then
					iter1:RemoveExposed(var0)

					break
				end
			end
		end
	end

	arg0._aura = var0.Battle.BattleDataProxy.GetInstance():SpawnLastingColumnArea(var2.AOEField.SURFACE, arg1:GetIFF(), arg1:GetPosition(), arg0._horizonRange, 0, var1, var2, false, nil, var3, true)

	local var4 = var0.Battle.BattleAOEMobilizedComponent.New(arg0._aura)

	var4:SetReferenceUnit(arg1)
	var4:ConfigData(var4.FOLLOW)
end

function var1.onAttach(arg0, arg1, arg2)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "blindedHorizon", arg0._horizonRange)

	local var0 = arg1:GetFleetVO()

	if var0 then
		var0:UpdateHorizon()
	end
end

function var1.onRemove(arg0, arg1, arg2)
	var0.Battle.BattleAttr.FlashByBuff(arg1, "blindedHorizon", 0)
end

function var1.Clear(arg0)
	arg0._aura:SetActiveFlag(false)

	arg0._aura = nil

	var1.super.Clear(arg0)
end

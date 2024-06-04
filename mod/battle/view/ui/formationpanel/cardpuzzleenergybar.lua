ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.CardPuzzleEnergyBar = class("CardPuzzleEnergyBar")

local var2 = var0.Battle.CardPuzzleEnergyBar

var2.__name = "CardPuzzleEnergyBar"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg0._go.transform
	arg0._currentLabel = arg0._tf:Find("count_label/count/current")
	arg0._shadeLabel = arg0._tf:Find("count_label/count/current")
	arg0._maxLabel = arg0._tf:Find("count_label/max")
	arg0._recoverBlockList = arg0._tf:Find("block_list")
end

function var2.SetCardPuzzleComponent(arg0, arg1)
	arg0._info = arg1
	arg0._energyInfo = arg0._info:GetEnergy()
	arg0._blockTFList = {}
	arg0._max = arg0._energyInfo:GetMaxEnergy()

	for iter0 = 1, arg0._max do
		local var0 = arg0._recoverBlockList:Find("block_" .. iter0)
		local var1 = var0:Find("full")
		local var2 = var0:Find("recover")
		local var3 = {
			full = var1,
			recover = var2
		}

		table.insert(arg0._blockTFList, var3)
	end

	arg0._lastPoint = 0

	local var4 = arg0._blockTFList[arg0._lastPoint + 1]

	arg0:activeRecoverBlock(var4)
end

function var2.Update(arg0)
	arg0:updateEnergyPoint()
	arg0:updateEnergyProgress()
end

function var2.updateEnergyProgress(arg0)
	local var0 = arg0._energyInfo:GetCurrentEnergy()

	if arg0._lastPoint == var0 then
		if var0 >= arg0._max then
			-- block empty
		else
			local var1 = arg0._blockTFList[var0 + 1]

			arg0:updateRecoverBlock(var1)
		end
	else
		local var2 = arg0._max
		local var3 = arg0._blockTFList

		for iter0, iter1 in ipairs(var3) do
			local var4 = arg0._blockTFList[iter0]
			local var5 = iter0 - 1

			if var5 < var0 then
				arg0:updateSingleBlock(var4, true)
			elseif var5 == var0 then
				arg0:activeRecoverBlock(var4)
				arg0:updateRecoverBlock(var4)
			elseif var0 < var5 then
				arg0:updateSingleBlock(var4, false)
			end
		end
	end

	arg0._lastPoint = var0
end

function var2.updateEnergyPoint(arg0)
	setText(arg0._currentLabel, arg0._energyInfo:GetCurrentEnergy())
	setText(arg0._shadeLabel, arg0._energyInfo:GetCurrentEnergy())
	setText(arg0._maxLabel, arg0._energyInfo:GetMaxEnergy())
end

function var2.activeRecoverBlock(arg0, arg1)
	setActive(arg1.full, false)
	setActive(arg1.recover, true)
end

function var2.updateRecoverBlock(arg0, arg1)
	local var0 = arg1.full

	arg1.recover:GetComponent(typeof(Image)).fillAmount = arg0._energyInfo:GetGeneratingProcess()
end

function var2.updateSingleBlock(arg0, arg1, arg2)
	local var0 = arg1.full
	local var1 = arg1.recover

	setActive(var0, arg2)
	setActive(var1, false)
end

function var2.Dispose(arg0)
	arg0._currentLabel = nil
	arg0._maxLabel = nil
	arg0._recoverBlockList = nil
end

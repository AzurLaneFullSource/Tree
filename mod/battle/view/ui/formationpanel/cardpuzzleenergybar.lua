ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CardPuzzleEnergyBar = class("CardPuzzleEnergyBar")

local var2_0 = var0_0.Battle.CardPuzzleEnergyBar

var2_0.__name = "CardPuzzleEnergyBar"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
	arg0_1._currentLabel = arg0_1._tf:Find("count_label/count/current")
	arg0_1._shadeLabel = arg0_1._tf:Find("count_label/count/current")
	arg0_1._maxLabel = arg0_1._tf:Find("count_label/max")
	arg0_1._recoverBlockList = arg0_1._tf:Find("block_list")
end

function var2_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	arg0_2._info = arg1_2
	arg0_2._energyInfo = arg0_2._info:GetEnergy()
	arg0_2._blockTFList = {}
	arg0_2._max = arg0_2._energyInfo:GetMaxEnergy()

	for iter0_2 = 1, arg0_2._max do
		local var0_2 = arg0_2._recoverBlockList:Find("block_" .. iter0_2)
		local var1_2 = var0_2:Find("full")
		local var2_2 = var0_2:Find("recover")
		local var3_2 = {
			full = var1_2,
			recover = var2_2
		}

		table.insert(arg0_2._blockTFList, var3_2)
	end

	arg0_2._lastPoint = 0

	local var4_2 = arg0_2._blockTFList[arg0_2._lastPoint + 1]

	arg0_2:activeRecoverBlock(var4_2)
end

function var2_0.Update(arg0_3)
	arg0_3:updateEnergyPoint()
	arg0_3:updateEnergyProgress()
end

function var2_0.updateEnergyProgress(arg0_4)
	local var0_4 = arg0_4._energyInfo:GetCurrentEnergy()

	if arg0_4._lastPoint == var0_4 then
		if var0_4 >= arg0_4._max then
			-- block empty
		else
			local var1_4 = arg0_4._blockTFList[var0_4 + 1]

			arg0_4:updateRecoverBlock(var1_4)
		end
	else
		local var2_4 = arg0_4._max
		local var3_4 = arg0_4._blockTFList

		for iter0_4, iter1_4 in ipairs(var3_4) do
			local var4_4 = arg0_4._blockTFList[iter0_4]
			local var5_4 = iter0_4 - 1

			if var5_4 < var0_4 then
				arg0_4:updateSingleBlock(var4_4, true)
			elseif var5_4 == var0_4 then
				arg0_4:activeRecoverBlock(var4_4)
				arg0_4:updateRecoverBlock(var4_4)
			elseif var0_4 < var5_4 then
				arg0_4:updateSingleBlock(var4_4, false)
			end
		end
	end

	arg0_4._lastPoint = var0_4
end

function var2_0.updateEnergyPoint(arg0_5)
	setText(arg0_5._currentLabel, arg0_5._energyInfo:GetCurrentEnergy())
	setText(arg0_5._shadeLabel, arg0_5._energyInfo:GetCurrentEnergy())
	setText(arg0_5._maxLabel, arg0_5._energyInfo:GetMaxEnergy())
end

function var2_0.activeRecoverBlock(arg0_6, arg1_6)
	setActive(arg1_6.full, false)
	setActive(arg1_6.recover, true)
end

function var2_0.updateRecoverBlock(arg0_7, arg1_7)
	local var0_7 = arg1_7.full

	arg1_7.recover:GetComponent(typeof(Image)).fillAmount = arg0_7._energyInfo:GetGeneratingProcess()
end

function var2_0.updateSingleBlock(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8.full
	local var1_8 = arg1_8.recover

	setActive(var0_8, arg2_8)
	setActive(var1_8, false)
end

function var2_0.Dispose(arg0_9)
	arg0_9._currentLabel = nil
	arg0_9._maxLabel = nil
	arg0_9._recoverBlockList = nil
end

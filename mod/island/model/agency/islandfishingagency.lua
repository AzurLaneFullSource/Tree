local var0_0 = class("IslandFishingAgency", import(".IslandBaseAgency"))

var0_0.BAIT_UPDATE = "IslandFishingAgency:BAIT_UPDATE"

local var1_0 = 1501

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.severBaitId = arg1_1.fish_sys.old_bait

	if arg0_1.severBaitId == 0 then
		arg0_1.baitId = var1_0
	else
		arg0_1.baitId = arg0_1.severBaitId
	end

	arg0_1.fishRodId = arg1_1.fish_sys.fish_rod
	arg0_1.fishList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.fish_sys.fish_weight) do
		table.insert(arg0_1.fishList, IslandFish.New(iter1_1))
	end
end

function var0_0.UpdateFishRodId(arg0_2, arg1_2)
	arg0_2.fishRodId = arg1_2
end

function var0_0.NeedUpdateServerBait(arg0_3)
	return arg0_3.severBaitId ~= arg0_3.baitId
end

function var0_0.UpdateBaitId(arg0_4, arg1_4)
	arg0_4.baitId = arg1_4
	arg0_4.severBaitId = arg1_4

	arg0_4:DispatchEvent(var0_0.BAIT_UPDATE, arg1_4)
end

function var0_0.GetBaitId(arg0_5)
	return arg0_5.baitId
end

function var0_0.GetFishRodId(arg0_6)
	return arg0_6.fishRodId
end

function var0_0.GetFishList(arg0_7)
	return arg0_7.fishList
end

function var0_0.GetFish(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.fishList) do
		if iter1_8.id == arg1_8 then
			return iter1_8
		end
	end

	return nil
end

function var0_0.IsNewFish(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.fishList) do
		if iter1_9.id == arg1_9 then
			return false
		end
	end

	return true
end

function var0_0.AddFish(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg0_10:IsNewFish(arg1_10) then
		local var0_10 = IslandFish.New({
			fish_id = arg1_10,
			max_weight = arg2_10,
			min_weight = arg2_10
		})

		var0_10:SetCupState(arg3_10)
		table.insert(arg0_10.fishList, var0_10)
	else
		for iter0_10, iter1_10 in ipairs(arg0_10.fishList) do
			if iter1_10.id == arg1_10 then
				iter1_10:SetWeight(arg2_10)
				iter1_10:SetCupState(arg3_10)
			end
		end
	end
end

function var0_0.IsNewRecord(arg0_11, arg1_11, arg2_11)
	if arg0_11:IsNewFish(arg1_11) then
		return false
	end

	for iter0_11, iter1_11 in ipairs(arg0_11.fishList) do
		if iter1_11.id == arg1_11 then
			return arg2_11 > iter1_11:GetMaxWeight()
		end
	end

	return false
end

return var0_0

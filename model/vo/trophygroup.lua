local var0_0 = class("TrophyGroup")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._trophyGroupID = arg1_1
	arg0_1._trophyList = {}
end

function var0_0.getGroupID(arg0_2)
	return arg0_2._trophyGroupID
end

function var0_0.getTrophyList(arg0_3)
	return arg0_3._trophyList
end

function var0_0.getDisplayTrophy(arg0_4)
	local var0_4 = #arg0_4._trophyList
	local var1_4

	while var0_4 > 0 do
		var1_4 = arg0_4._trophyList[var0_4]

		if var1_4:isClaimed() then
			break
		end

		var0_4 = var0_4 - 1
	end

	return var1_4
end

function var0_0.getProgressTrophy(arg0_5)
	local var0_5 = 1
	local var1_5 = #arg0_5._trophyList
	local var2_5

	while var0_5 <= var1_5 do
		var2_5 = arg0_5._trophyList[var0_5]

		if not var2_5:isClaimed() then
			break
		end

		var0_5 = var0_5 + 1
	end

	return var2_5
end

function var0_0.getTrophyIndex(arg0_6, arg1_6)
	local var0_6

	for iter0_6, iter1_6 in ipairs(arg0_6._trophyList) do
		if iter1_6.id == arg1_6.id then
			var0_6 = iter0_6

			break
		end
	end

	return var0_6
end

function var0_0.getMaxClaimedTrophy(arg0_7)
	local var0_7 = #arg0_7._trophyList

	while var0_7 > 0 do
		local var1_7 = arg0_7._trophyList[var0_7]

		if var1_7:isClaimed() then
			return var1_7
		end

		var0_7 = var0_7 - 1
	end
end

function var0_0.getTrophyCount(arg0_8)
	return #arg0_8._trophyList
end

function var0_0.getPostTrophy(arg0_9, arg1_9)
	local var0_9 = arg0_9:getTrophyIndex(arg1_9)

	if not var0_9 then
		return nil
	end

	local var1_9 = var0_9 + 1

	if var1_9 > #arg0_9._trophyList then
		return nil
	end

	return arg0_9._trophyList[var1_9]
end

function var0_0.getPreTrophy(arg0_10, arg1_10)
	local var0_10 = arg0_10:getTrophyIndex(arg1_10)

	if not var0_10 then
		return nil
	end

	local var1_10 = var0_10 - 1

	if var1_10 < 1 then
		return nil
	end

	return arg0_10._trophyList[var1_10]
end

function var0_0.addTrophy(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11._trophyList) do
		if iter1_11.id == arg1_11.id then
			arg0_11._trophyList[iter0_11] = arg1_11

			return
		end
	end

	arg0_11._trophyList[#arg0_11._trophyList + 1] = arg1_11
end

function var0_0.addDummyTrophy(arg0_12, arg1_12)
	local var0_12 = Trophy.generateDummyTrophy(arg1_12)

	arg0_12:addTrophy(var0_12)
end

function var0_0.sortGroup(arg0_13)
	table.sort(arg0_13._trophyList, function(arg0_14, arg1_14)
		return arg0_14.id < arg1_14.id
	end)
end

return var0_0

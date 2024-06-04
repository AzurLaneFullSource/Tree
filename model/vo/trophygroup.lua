local var0 = class("TrophyGroup")

function var0.Ctor(arg0, arg1)
	arg0._trophyGroupID = arg1
	arg0._trophyList = {}
end

function var0.getGroupID(arg0)
	return arg0._trophyGroupID
end

function var0.getTrophyList(arg0)
	return arg0._trophyList
end

function var0.getDisplayTrophy(arg0)
	local var0 = #arg0._trophyList
	local var1

	while var0 > 0 do
		var1 = arg0._trophyList[var0]

		if var1:isClaimed() then
			break
		end

		var0 = var0 - 1
	end

	return var1
end

function var0.getProgressTrophy(arg0)
	local var0 = 1
	local var1 = #arg0._trophyList
	local var2

	while var0 <= var1 do
		var2 = arg0._trophyList[var0]

		if not var2:isClaimed() then
			break
		end

		var0 = var0 + 1
	end

	return var2
end

function var0.getTrophyIndex(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0._trophyList) do
		if iter1.id == arg1.id then
			var0 = iter0

			break
		end
	end

	return var0
end

function var0.getMaxClaimedTrophy(arg0)
	local var0 = #arg0._trophyList

	while var0 > 0 do
		local var1 = arg0._trophyList[var0]

		if var1:isClaimed() then
			return var1
		end

		var0 = var0 - 1
	end
end

function var0.getTrophyCount(arg0)
	return #arg0._trophyList
end

function var0.getPostTrophy(arg0, arg1)
	local var0 = arg0:getTrophyIndex(arg1)

	if not var0 then
		return nil
	end

	local var1 = var0 + 1

	if var1 > #arg0._trophyList then
		return nil
	end

	return arg0._trophyList[var1]
end

function var0.getPreTrophy(arg0, arg1)
	local var0 = arg0:getTrophyIndex(arg1)

	if not var0 then
		return nil
	end

	local var1 = var0 - 1

	if var1 < 1 then
		return nil
	end

	return arg0._trophyList[var1]
end

function var0.addTrophy(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._trophyList) do
		if iter1.id == arg1.id then
			arg0._trophyList[iter0] = arg1

			return
		end
	end

	arg0._trophyList[#arg0._trophyList + 1] = arg1
end

function var0.addDummyTrophy(arg0, arg1)
	local var0 = Trophy.generateDummyTrophy(arg1)

	arg0:addTrophy(var0)
end

function var0.sortGroup(arg0)
	table.sort(arg0._trophyList, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
end

return var0

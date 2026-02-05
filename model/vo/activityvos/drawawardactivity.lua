local var0_0 = class("DrawAwardActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.countDic = arg0_1.data1KeyValueList[1]
	arg0_1.storeDic = {}
	arg0_1.rarityDic = {}

	for iter0_1, iter1_1 in ipairs(arg0_1:GetDrawConfig("reward_list")) do
		local var0_1, var1_1 = unpack(iter1_1)

		arg0_1.storeDic[var0_1] = var1_1

		local var2_1 = pg.island_draw_reward[var0_1].rarity

		arg0_1.rarityDic[var2_1] = arg0_1.rarityDic[var2_1] or {}

		table.insert(arg0_1.rarityDic[var2_1], var0_1)
	end
end

function var0_0.GetDrawConfig(arg0_2, arg1_2)
	local var0_2 = pg.island_draw[arg0_2.configId]

	assert(var0_2, "without config in pg.island_draw:" .. arg0_2.configId)

	return var0_2[arg1_2]
end

function var0_0.GetDrawTimes(arg0_3)
	return arg0_3.data1
end

function var0_0.GetDrawCount(arg0_4)
	return arg0_4.data2
end

function var0_0.SetList(arg0_5, arg1_5)
	arg0_5.data1_list = underscore.to_array(arg1_5)
end

function var0_0.GetList(arg0_6)
	local var0_6 = {}
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.data1_list) do
		var1_6[iter1_6] = defaultValue(var1_6[iter1_6], 0) + 1

		table.insert(var0_6, {
			iter1_6,
			true
		})
	end

	for iter2_6, iter3_6 in ipairs(arg0_6.rarityDic[4] or {}) do
		for iter4_6 = defaultValue(arg0_6.storeDic[iter3_6], 0), defaultValue(var1_6[iter3_6], 0) + 1, -1 do
			table.insert(var0_6, {
				iter3_6,
				iter4_6 > defaultValue(var1_6[iter3_6], 0) + defaultValue(arg0_6.countDic[iter3_6], 0)
			})
		end
	end

	return var0_6
end

function var0_0.CheckList(arg0_7, arg1_7)
	local var0_7 = {}
	local var1_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7.rarityDic[4]) do
		var0_7[iter1_7] = defaultValue(arg0_7.storeDic[iter1_7], 0) - defaultValue(arg0_7.countDic[iter1_7], 0)
		var1_7 = var1_7 + var0_7[iter1_7]
	end

	if #arg1_7 ~= var1_7 then
		return false
	end

	for iter2_7, iter3_7 in ipairs(arg1_7) do
		var0_7[iter3_7] = defaultValue(var0_7[iter3_7], 0) - 1

		if var0_7[iter3_7] < 0 then
			return false
		end
	end

	return true
end

function var0_0.GetCountAwardsRecord(arg0_8)
	return arg0_8.data2_list
end

function var0_0.GetRarityIds(arg0_9, arg1_9)
	local var0_9 = switch(arg1_9, {
		S = function()
			return 4
		end,
		A = function()
			return 3
		end,
		B = function()
			return 2
		end,
		C = function()
			return 1
		end
	})

	return arg0_9.rarityDic[var0_9]
end

function var0_0.GetRankList(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14:GetRarityIds(arg1_14)) do
		for iter2_14 = defaultValue(arg0_14.storeDic[iter1_14], 0), 1, -1 do
			table.insert(var0_14, {
				iter1_14,
				iter2_14 > defaultValue(arg0_14.countDic[iter1_14], 0)
			})
		end
	end

	return var0_14
end

function var0_0.GetTimesLeft(arg0_15, arg1_15)
	local var0_15 = arg1_15 and arg0_15:GetRarityIds(arg1_15) or underscore.map(arg0_15:GetDrawConfig("reward_list"), function(arg0_16)
		return arg0_16[1]
	end)
	local var1_15 = 0

	for iter0_15, iter1_15 in ipairs(var0_15) do
		var1_15 = var1_15 + defaultValue(arg0_15.storeDic[iter1_15], 0) - defaultValue(arg0_15.countDic[iter1_15], 0)
	end

	return var1_15
end

function var0_0.ResultDraw(arg0_17, arg1_17)
	arg0_17.data1 = arg0_17.data1 - #arg1_17
	arg0_17.data2 = arg0_17.data2 + #arg1_17

	for iter0_17, iter1_17 in ipairs(arg1_17) do
		arg0_17.countDic[iter1_17] = defaultValue(arg0_17.countDic[iter1_17], 0) + 1

		if pg.island_draw_reward[iter1_17].rarity == 4 then
			if #arg0_17.data1_list == 0 or arg0_17.data1_list[1] == iter1_17 then
				table.remove(arg0_17.data1_list, 1)
			else
				assert(false, string.format("error SList drop %d in %s", iter1_17, PrintTable(arg0_17.data1_list)))
			end
		end
	end
end

function var0_0.CountAward(arg0_18, arg1_18)
	table.insert(arg0_18.data2_list, arg1_18)
end

function var0_0.GetCountAwards(arg0_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in ipairs(arg0_19.data2_list) do
		var0_19[iter1_19] = defaultValue(var0_19[iter1_19], 0) + 1
	end

	local var1_19 = {}

	for iter2_19, iter3_19 in ipairs(arg0_19:GetDrawConfig("reward_acc")) do
		local var2_19, var3_19 = unpack(iter3_19)

		for iter4_19 = 1, var3_19 do
			table.insert(var1_19, {
				var2_19,
				iter4_19 > defaultValue(var0_19[var2_19], 0)
			})
		end
	end

	return var1_19
end

function var0_0.GetNextCountAwardTimes(arg0_20)
	return arg0_20:GetDrawConfig("acc_count_list")[#arg0_20.data2_list + 1]
end

function var0_0.CanCountAward(arg0_21, arg1_21)
	if not arg1_21 then
		return true
	end

	local var0_21 = arg0_21:GetNextCountAwardTimes()

	if not var0_21 or var0_21 > arg0_21.data2 then
		return false
	end

	local var1_21 = 0

	for iter0_21, iter1_21 in ipairs(arg0_21.data2_list) do
		if iter1_21 == arg1_21 then
			var1_21 = var1_21 - 1
		end
	end

	for iter2_21, iter3_21 in ipairs(arg0_21:GetDrawConfig("reward_acc")) do
		local var2_21, var3_21 = unpack(iter3_21)

		if arg1_21 == var2_21 then
			var1_21 = var1_21 + var3_21

			if var1_21 > 0 then
				return true
			end
		end
	end

	return false
end

function var0_0.GetShowRankList(arg0_22, arg1_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(arg0_22:GetRankList(arg1_22)) do
		local var1_22, var2_22 = unpack(iter1_22)
		local var3_22 = pg.island_draw_reward[var1_22]

		if noEmptyStr(var3_22.show) then
			table.insert(var0_22, var1_22)
		end
	end

	return var0_22
end

function var0_0.GetLastItemCount(arg0_23, arg1_23)
	return defaultValue(arg0_23.storeDic[arg1_23], 0) - defaultValue(arg0_23.countDic[arg1_23], 0)
end

return var0_0

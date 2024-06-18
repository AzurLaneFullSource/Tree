local var0_0 = class("DecodeGameModel")

function var0_0.SetData(arg0_1, arg1_1)
	arg0_1.data = arg1_1
	arg0_1.mapId = arg1_1.mapId
	arg0_1.unlocks = arg1_1.unlocks
	arg0_1.canUseCnt = arg1_1.canUseCnt
	arg0_1.passwords = arg1_1.passwords
	arg0_1.isFinished = arg1_1.isFinished
	arg0_1.mapIndexs = {}

	if arg0_1.isFinished then
		arg0_1:BuildMapIndexs()
	else
		for iter0_1 = 1, #DecodeGameConst.PASSWORD do
			table.insert(arg0_1.mapIndexs, false)
		end
	end

	arg0_1.maps = {}

	for iter1_1 = 1, DecodeGameConst.MAX_MAP_COUNT do
		table.insert(arg0_1.maps, arg0_1:InitMap(iter1_1))
	end

	arg0_1:SwitchMap(arg1_1.mapId)
end

function var0_0.BuildMapIndexs(arg0_2)
	local var0_2 = DecodeGameConst.PASSWORD

	local function var1_2(arg0_3)
		for iter0_3, iter1_3 in ipairs(DecodeGameConst.MAPS_PASSWORD) do
			if _.any(iter1_3, function(arg0_4)
				return arg0_4[1] == arg0_3[1] and arg0_4[2] == arg0_3[2]
			end) then
				return iter0_3
			end
		end
	end

	for iter0_2 = 1, #var0_2 do
		local var2_2 = var0_2[iter0_2]
		local var3_2 = var1_2(var2_2)
		local var4_2 = DecodeGameConst.Vect2Index(var2_2[1], var2_2[2]) + (var3_2 - 1) * (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)

		table.insert(arg0_2.mapIndexs, var4_2)
	end
end

function var0_0.InitMap(arg0_5, arg1_5)
	local function var0_5(arg0_6, arg1_6, arg2_6)
		local var0_6 = DecodeGameConst.START_POS[1] + (arg1_6 - 1) * DecodeGameConst.BLOCK_SIZE[1]
		local var1_6 = DecodeGameConst.START_POS[2] - (arg0_6 - 1) * DecodeGameConst.BLOCK_SIZE[2]
		local var2_6 = table.contains(arg0_5.unlocks, arg2_6)

		return {
			isUsed = false,
			index = arg2_6,
			i = arg0_6,
			j = arg1_6,
			position = Vector3(var0_6, var1_6, 0),
			isUnlock = var2_6
		}
	end

	local var1_5 = {}
	local var2_5 = (arg1_5 - 1) * (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)
	local var3_5 = var2_5

	for iter0_5 = 1, DecodeGameConst.MAP_ROW do
		for iter1_5 = 1, DecodeGameConst.MAP_COLUMN do
			var2_5 = var2_5 + 1

			local var4_5 = var0_5(iter0_5, iter1_5, var2_5)

			table.insert(var1_5, var4_5)
		end
	end

	local var5_5 = arg0_5:IsUnlockMap(arg1_5)
	local var6_5 = arg0_5.passwords[arg1_5]
	local var7_5 = {}

	for iter2_5 = 1, #var6_5 do
		local var8_5 = var6_5[iter2_5]
		local var9_5 = var3_5 + DecodeGameConst.Vect2Index(var8_5[1], var8_5[2])

		table.insert(var7_5, var9_5)
	end

	return {
		id = arg1_5,
		items = var1_5,
		isUnlock = var5_5,
		password = var6_5,
		passwordIndexs = var7_5
	}
end

function var0_0.SwitchMap(arg0_7, arg1_7)
	arg0_7.map = arg0_7.maps[arg1_7]

	for iter0_7, iter1_7 in ipairs(arg0_7.map.items) do
		iter1_7.isUsed = arg0_7:IsUsedMapKey(iter1_7.index)
	end
end

function var0_0.ExitMap(arg0_8)
	arg0_8.map = nil
end

function var0_0.UnlockMapItem(arg0_9, arg1_9)
	local var0_9 = arg0_9.map

	for iter0_9, iter1_9 in ipairs(var0_9.items) do
		if iter1_9.index == arg1_9 then
			iter1_9.isUnlock = true

			break
		end
	end

	if not table.contains(arg0_9.unlocks, arg1_9) then
		table.insert(arg0_9.unlocks, arg1_9)
	end

	arg0_9.canUseCnt = arg0_9.canUseCnt - 1
end

function var0_0.OnRepairMap(arg0_10)
	arg0_10.map.isUnlock = true
end

function var0_0.IsUnlock(arg0_11, arg1_11)
	return _.any(arg0_11.map.items, function(arg0_12)
		return arg0_12.index == arg1_11 and arg0_12.isUnlock
	end)
end

function var0_0.GetUnlockedCnt(arg0_13)
	return #arg0_13.unlocks
end

function var0_0.IsUnlockMap(arg0_14, arg1_14)
	local var0_14 = DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN
	local var1_14 = (arg1_14 - 1) * var0_14 + 1
	local var2_14 = var1_14 + var0_14 - 1

	return _.all(_.range(var1_14, var2_14), function(arg0_15)
		return table.contains(arg0_14.unlocks, arg0_15)
	end)
end

function var0_0.GetUnlockMapCnt(arg0_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in ipairs(arg0_16.maps) do
		if iter1_16.isUnlock then
			var0_16 = var0_16 + 1
		end
	end

	return var0_16
end

function var0_0.CheckIndex(arg0_17, arg1_17)
	local var0_17 = #DecodeGameConst.MAPS_PASSWORD[1]
	local var1_17 = arg0_17:GetCurrMapKeyIndex(arg1_17)
	local var2_17 = (math.ceil(var1_17 / var0_17) - 1) * var0_17 + 1
	local var3_17 = var2_17 + (var0_17 - 1)

	if var1_17 == var2_17 then
		return true
	end

	if var2_17 < var1_17 then
		local var4_17 = var1_17 - 1

		if arg0_17.mapIndexs[var4_17] ~= false then
			return true
		end
	end

	return false
end

function var0_0.IsUsedMapKey(arg0_18, arg1_18)
	return table.contains(arg0_18.mapIndexs, arg1_18)
end

function var0_0.IsMapKey(arg0_19, arg1_19)
	return _.any(arg0_19.map.passwordIndexs, function(arg0_20)
		return arg0_20 == arg1_19
	end)
end

function var0_0.InsertMapKey(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetCurrMapKeyIndex(arg1_21)

	arg0_21.mapIndexs[var0_21] = arg1_21
end

function var0_0.GetMapKeyStr(arg0_22, arg1_22)
	arg1_22 = arg1_22 - (arg0_22.map.id - 1) * (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)

	return DecodeGameConst.PASSWORDS[arg1_22]
end

function var0_0.ClearMapKeys(arg0_23)
	if arg0_23.isFinished then
		return
	end

	arg0_23.mapIndexs = _.map(arg0_23.mapIndexs, function(arg0_24)
		return false
	end)
end

function var0_0.GetCurrMapKeyIndex(arg0_25, arg1_25)
	local var0_25 = arg1_25 % (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)
	local var1_25, var2_25 = DecodeGameConst.Index2Vect(var0_25)
	local var3_25

	for iter0_25, iter1_25 in ipairs(DecodeGameConst.PASSWORD) do
		if iter1_25[1] == var1_25 and iter1_25[2] == var2_25 then
			var3_25 = iter0_25

			break
		end
	end

	assert(var3_25)

	return var3_25
end

function var0_0.IsSuccess(arg0_26)
	return _.all(arg0_26.mapIndexs, function(arg0_27)
		return arg0_27 ~= false
	end)
end

function var0_0.GetMapKeyStrs(arg0_28)
	return _.map(arg0_28.mapIndexs, function(arg0_29)
		if arg0_29 == false then
			return false
		end

		local var0_29 = arg0_29 % (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)

		return DecodeGameConst.PASSWORDS[var0_29]
	end)
end

function var0_0.GetPassWordProgress(arg0_30)
	local var0_30 = 1
	local var1_30 = {}
	local var2_30 = 0

	for iter0_30 = 1, #DecodeGameConst.PASSWORD, DecodeGameConst.MAX_MAP_COUNT do
		local var3_30 = _.all(_.slice(arg0_30.mapIndexs, iter0_30, 3), function(arg0_31)
			return arg0_31 ~= false
		end)

		if var3_30 == true then
			var2_30 = var2_30 + 1
		end

		table.insert(var1_30, var3_30)
	end

	return var1_30, var2_30
end

function var0_0.Finish(arg0_32)
	arg0_32.isFinished = true
end

function var0_0.CanUnlockAward(arg0_33)
	local var0_33 = DecodeGameConst.MAX_MAP_COUNT * DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN

	return not arg0_33.isFinished and var0_33 <= arg0_33:GetUnlockedCnt()
end

function var0_0.Dispose(arg0_34)
	return
end

return var0_0

local var0 = class("DecodeGameModel")

function var0.SetData(arg0, arg1)
	arg0.data = arg1
	arg0.mapId = arg1.mapId
	arg0.unlocks = arg1.unlocks
	arg0.canUseCnt = arg1.canUseCnt
	arg0.passwords = arg1.passwords
	arg0.isFinished = arg1.isFinished
	arg0.mapIndexs = {}

	if arg0.isFinished then
		arg0:BuildMapIndexs()
	else
		for iter0 = 1, #DecodeGameConst.PASSWORD do
			table.insert(arg0.mapIndexs, false)
		end
	end

	arg0.maps = {}

	for iter1 = 1, DecodeGameConst.MAX_MAP_COUNT do
		table.insert(arg0.maps, arg0:InitMap(iter1))
	end

	arg0:SwitchMap(arg1.mapId)
end

function var0.BuildMapIndexs(arg0)
	local var0 = DecodeGameConst.PASSWORD

	local function var1(arg0)
		for iter0, iter1 in ipairs(DecodeGameConst.MAPS_PASSWORD) do
			if _.any(iter1, function(arg0)
				return arg0[1] == arg0[1] and arg0[2] == arg0[2]
			end) then
				return iter0
			end
		end
	end

	for iter0 = 1, #var0 do
		local var2 = var0[iter0]
		local var3 = var1(var2)
		local var4 = DecodeGameConst.Vect2Index(var2[1], var2[2]) + (var3 - 1) * (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)

		table.insert(arg0.mapIndexs, var4)
	end
end

function var0.InitMap(arg0, arg1)
	local function var0(arg0, arg1, arg2)
		local var0 = DecodeGameConst.START_POS[1] + (arg1 - 1) * DecodeGameConst.BLOCK_SIZE[1]
		local var1 = DecodeGameConst.START_POS[2] - (arg0 - 1) * DecodeGameConst.BLOCK_SIZE[2]
		local var2 = table.contains(arg0.unlocks, arg2)

		return {
			isUsed = false,
			index = arg2,
			i = arg0,
			j = arg1,
			position = Vector3(var0, var1, 0),
			isUnlock = var2
		}
	end

	local var1 = {}
	local var2 = (arg1 - 1) * (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)
	local var3 = var2

	for iter0 = 1, DecodeGameConst.MAP_ROW do
		for iter1 = 1, DecodeGameConst.MAP_COLUMN do
			var2 = var2 + 1

			local var4 = var0(iter0, iter1, var2)

			table.insert(var1, var4)
		end
	end

	local var5 = arg0:IsUnlockMap(arg1)
	local var6 = arg0.passwords[arg1]
	local var7 = {}

	for iter2 = 1, #var6 do
		local var8 = var6[iter2]
		local var9 = var3 + DecodeGameConst.Vect2Index(var8[1], var8[2])

		table.insert(var7, var9)
	end

	return {
		id = arg1,
		items = var1,
		isUnlock = var5,
		password = var6,
		passwordIndexs = var7
	}
end

function var0.SwitchMap(arg0, arg1)
	arg0.map = arg0.maps[arg1]

	for iter0, iter1 in ipairs(arg0.map.items) do
		iter1.isUsed = arg0:IsUsedMapKey(iter1.index)
	end
end

function var0.ExitMap(arg0)
	arg0.map = nil
end

function var0.UnlockMapItem(arg0, arg1)
	local var0 = arg0.map

	for iter0, iter1 in ipairs(var0.items) do
		if iter1.index == arg1 then
			iter1.isUnlock = true

			break
		end
	end

	if not table.contains(arg0.unlocks, arg1) then
		table.insert(arg0.unlocks, arg1)
	end

	arg0.canUseCnt = arg0.canUseCnt - 1
end

function var0.OnRepairMap(arg0)
	arg0.map.isUnlock = true
end

function var0.IsUnlock(arg0, arg1)
	return _.any(arg0.map.items, function(arg0)
		return arg0.index == arg1 and arg0.isUnlock
	end)
end

function var0.GetUnlockedCnt(arg0)
	return #arg0.unlocks
end

function var0.IsUnlockMap(arg0, arg1)
	local var0 = DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN
	local var1 = (arg1 - 1) * var0 + 1
	local var2 = var1 + var0 - 1

	return _.all(_.range(var1, var2), function(arg0)
		return table.contains(arg0.unlocks, arg0)
	end)
end

function var0.GetUnlockMapCnt(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.maps) do
		if iter1.isUnlock then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.CheckIndex(arg0, arg1)
	local var0 = #DecodeGameConst.MAPS_PASSWORD[1]
	local var1 = arg0:GetCurrMapKeyIndex(arg1)
	local var2 = (math.ceil(var1 / var0) - 1) * var0 + 1
	local var3 = var2 + (var0 - 1)

	if var1 == var2 then
		return true
	end

	if var2 < var1 then
		local var4 = var1 - 1

		if arg0.mapIndexs[var4] ~= false then
			return true
		end
	end

	return false
end

function var0.IsUsedMapKey(arg0, arg1)
	return table.contains(arg0.mapIndexs, arg1)
end

function var0.IsMapKey(arg0, arg1)
	return _.any(arg0.map.passwordIndexs, function(arg0)
		return arg0 == arg1
	end)
end

function var0.InsertMapKey(arg0, arg1)
	local var0 = arg0:GetCurrMapKeyIndex(arg1)

	arg0.mapIndexs[var0] = arg1
end

function var0.GetMapKeyStr(arg0, arg1)
	arg1 = arg1 - (arg0.map.id - 1) * (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)

	return DecodeGameConst.PASSWORDS[arg1]
end

function var0.ClearMapKeys(arg0)
	if arg0.isFinished then
		return
	end

	arg0.mapIndexs = _.map(arg0.mapIndexs, function(arg0)
		return false
	end)
end

function var0.GetCurrMapKeyIndex(arg0, arg1)
	local var0 = arg1 % (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)
	local var1, var2 = DecodeGameConst.Index2Vect(var0)
	local var3

	for iter0, iter1 in ipairs(DecodeGameConst.PASSWORD) do
		if iter1[1] == var1 and iter1[2] == var2 then
			var3 = iter0

			break
		end
	end

	assert(var3)

	return var3
end

function var0.IsSuccess(arg0)
	return _.all(arg0.mapIndexs, function(arg0)
		return arg0 ~= false
	end)
end

function var0.GetMapKeyStrs(arg0)
	return _.map(arg0.mapIndexs, function(arg0)
		if arg0 == false then
			return false
		end

		local var0 = arg0 % (DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN)

		return DecodeGameConst.PASSWORDS[var0]
	end)
end

function var0.GetPassWordProgress(arg0)
	local var0 = 1
	local var1 = {}
	local var2 = 0

	for iter0 = 1, #DecodeGameConst.PASSWORD, DecodeGameConst.MAX_MAP_COUNT do
		local var3 = _.all(_.slice(arg0.mapIndexs, iter0, 3), function(arg0)
			return arg0 ~= false
		end)

		if var3 == true then
			var2 = var2 + 1
		end

		table.insert(var1, var3)
	end

	return var1, var2
end

function var0.Finish(arg0)
	arg0.isFinished = true
end

function var0.CanUnlockAward(arg0)
	local var0 = DecodeGameConst.MAX_MAP_COUNT * DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN

	return not arg0.isFinished and var0 <= arg0:GetUnlockedCnt()
end

function var0.Dispose(arg0)
	return
end

return var0

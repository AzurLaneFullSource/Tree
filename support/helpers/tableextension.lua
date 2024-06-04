function table.indexof(arg0, arg1, arg2)
	for iter0 = arg2 or 1, #arg0 do
		if arg0[iter0] == arg1 then
			return iter0
		end
	end

	return false
end

function table.keyof(arg0, arg1)
	for iter0, iter1 in pairs(arg0) do
		if iter1 == arg1 then
			return iter0
		end
	end

	return nil
end

function table.removebyvalue(arg0, arg1, arg2)
	local var0 = 0
	local var1 = 1
	local var2 = #arg0

	while var1 <= var2 do
		if arg0[var1] == arg1 then
			table.remove(arg0, var1)

			var0 = var0 + 1
			var1 = var1 - 1
			var2 = var2 - 1

			if not arg2 then
				break
			end
		end

		var1 = var1 + 1
	end

	return var0
end

function table.removebykey(arg0, arg1)
	local var0 = arg0[arg1]

	arg0[arg1] = nil

	return var0
end

function table.insertto(arg0, arg1, arg2)
	arg2 = checkint(arg2)

	if arg2 <= 0 then
		arg2 = #arg0 + 1
	end

	local var0 = #arg1

	for iter0 = 0, var0 - 1 do
		arg0[iter0 + arg2] = arg1[iter0 + 1]
	end
end

function table.isEmpty(arg0)
	if type(arg0) == "table" then
		return next(arg0) == nil
	end

	return true
end

function table.clear(arg0)
	if arg0 then
		for iter0, iter1 in pairs(arg0) do
			arg0[iter0] = nil
		end
	end
end

function table.contains(arg0, arg1)
	if arg0 == nil then
		return false
	end

	for iter0, iter1 in pairs(arg0) do
		if iter1 == arg1 then
			return true
		end
	end

	return false
end

function table.equal(arg0, arg1)
	if type(arg0) ~= type(arg1) then
		return false
	end

	if type(arg0) ~= "table" then
		return arg0 == arg1
	end

	if arg0 == arg1 then
		return true
	end

	for iter0, iter1 in pairs(arg0) do
		if not table.equal(iter1, arg1[iter0]) then
			return false
		end
	end

	for iter2, iter3 in pairs(arg1) do
		if arg0[iter2] == nil then
			return false
		end
	end

	return true
end

function table.containsData(arg0, arg1)
	if arg0 == nil then
		return false
	end

	for iter0, iter1 in pairs(arg0) do
		if table.equal(iter1, arg1) then
			return true
		end
	end

	return false
end

function table.Foreach(arg0, arg1)
	for iter0, iter1 in pairs(arg0) do
		arg1(iter0, iter1)
	end
end

function table.Ipairs(arg0, arg1)
	for iter0, iter1 in ipairs(arg0) do
		arg1(iter0, iter1)
	end
end

function table.IpairsCArray(arg0, arg1)
	for iter0 = 0, arg0.Length - 1 do
		v = arg0[iter0]

		arg1(iter0, v)
	end
end

function table.SerialIpairsAsync(arg0, arg1, arg2)
	if type(arg0) ~= "table" then
		return
	end

	local var0
	local var1
	local var2
	local var3, var4

	var3, arg0, var4 = ipairs(arg0)

	local var5

	local function var6()
		var4, var1 = var3(arg0, var4)

		if var4 == nil then
			if arg2 then
				arg2()
			end
		else
			arg1(var4, var1, var6)
		end
	end

	var6()
end

function table.ParallelIpairsAsync(arg0, arg1, arg2)
	if type(arg0) ~= "table" then
		return
	end

	local var0
	local var1
	local var2
	local var3, var4

	var3, arg0, var4 = ipairs(arg0)

	local var5 = 0
	local var6 = 1

	local function var7()
		var5 = var5 + 1

		if var5 == var6 then
			existCall(arg2)
		end
	end

	while true do
		local var8

		var4, var8 = var3(arg0, var4)

		if var4 == nil then
			break
		end

		var6 = var6 + 1

		arg1(var4, var8, var7)
	end

	var7()
end

function table.Find(arg0, arg1)
	for iter0, iter1 in pairs(arg0) do
		if arg1(iter0, iter1) then
			return iter1, iter0
		end
	end
end

function table.Checkout(arg0, arg1)
	for iter0, iter1 in pairs(arg0) do
		local var0 = arg1(iter0, iter1)

		if var0 ~= nil then
			return var0
		end
	end
end

function table.getCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0) do
		var0 = var0 + 1
	end

	return var0
end

function table.merge(arg0, arg1)
	if not arg1 or not arg0 then
		return
	end

	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end

	return arg0
end

function table.mergeArray(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if arg2 and var0[iter1] then
				-- block empty
			else
				table.insert(var1, iter1)

				var0[iter1] = true
			end
		end
	end

	var2(arg0)
	var2(arg1)

	return var1
end

function table.clean(arg0)
	for iter0 = #arg0, 1, -1 do
		table.remove(arg0, iter0)
	end
end

function table.shallowCopy(arg0)
	if type(arg0) ~= "table" then
		return arg0
	end

	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		var0[iter0] = iter1
	end

	return var0
end

function table.getIndex(arg0, arg1)
	for iter0, iter1 in ipairs(arg0) do
		if arg1(iter1) then
			return iter0
		end
	end
end

function table.map(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		var0[iter0] = arg1(iter1)
	end

	return var0
end

function table.lastof(arg0)
	return arg0[#arg0]
end

function table.dichotomyInsert(arg0, arg1, arg2)
	arg2 = defaultValue(arg2, function(arg0)
		return arg0
	end)

	assert(type(arg2) == "function")

	local var0 = {}
	local var1 = 1
	local var2 = #arg0
	local var3

	local function var4(arg0)
		var0[arg0] = var0[arg0] or arg2(arg0)

		return var0[arg0]
	end

	while var1 < var2 do
		local var5 = math.floor((var1 + var2) / 2)

		if var4(arg0[var5]) < var4(arg1) then
			var1 = var5 + 1
		else
			var2 = var5
		end
	end

	table.insert(arg0, var1, arg1)
end

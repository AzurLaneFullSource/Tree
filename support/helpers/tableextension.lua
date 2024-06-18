function table.indexof(arg0_1, arg1_1, arg2_1)
	for iter0_1 = arg2_1 or 1, #arg0_1 do
		if arg0_1[iter0_1] == arg1_1 then
			return iter0_1
		end
	end

	return false
end

function table.keyof(arg0_2, arg1_2)
	for iter0_2, iter1_2 in pairs(arg0_2) do
		if iter1_2 == arg1_2 then
			return iter0_2
		end
	end

	return nil
end

function table.removebyvalue(arg0_3, arg1_3, arg2_3)
	local var0_3 = 0
	local var1_3 = 1
	local var2_3 = #arg0_3

	while var1_3 <= var2_3 do
		if arg0_3[var1_3] == arg1_3 then
			table.remove(arg0_3, var1_3)

			var0_3 = var0_3 + 1
			var1_3 = var1_3 - 1
			var2_3 = var2_3 - 1

			if not arg2_3 then
				break
			end
		end

		var1_3 = var1_3 + 1
	end

	return var0_3
end

function table.removebykey(arg0_4, arg1_4)
	local var0_4 = arg0_4[arg1_4]

	arg0_4[arg1_4] = nil

	return var0_4
end

function table.insertto(arg0_5, arg1_5, arg2_5)
	arg2_5 = checkint(arg2_5)

	if arg2_5 <= 0 then
		arg2_5 = #arg0_5 + 1
	end

	local var0_5 = #arg1_5

	for iter0_5 = 0, var0_5 - 1 do
		arg0_5[iter0_5 + arg2_5] = arg1_5[iter0_5 + 1]
	end
end

function table.isEmpty(arg0_6)
	if type(arg0_6) == "table" then
		return next(arg0_6) == nil
	end

	return true
end

function table.clear(arg0_7)
	if arg0_7 then
		for iter0_7, iter1_7 in pairs(arg0_7) do
			arg0_7[iter0_7] = nil
		end
	end
end

function table.contains(arg0_8, arg1_8)
	if arg0_8 == nil then
		return false
	end

	for iter0_8, iter1_8 in pairs(arg0_8) do
		if iter1_8 == arg1_8 then
			return true
		end
	end

	return false
end

function table.equal(arg0_9, arg1_9)
	if type(arg0_9) ~= type(arg1_9) then
		return false
	end

	if type(arg0_9) ~= "table" then
		return arg0_9 == arg1_9
	end

	if arg0_9 == arg1_9 then
		return true
	end

	for iter0_9, iter1_9 in pairs(arg0_9) do
		if not table.equal(iter1_9, arg1_9[iter0_9]) then
			return false
		end
	end

	for iter2_9, iter3_9 in pairs(arg1_9) do
		if arg0_9[iter2_9] == nil then
			return false
		end
	end

	return true
end

function table.containsData(arg0_10, arg1_10)
	if arg0_10 == nil then
		return false
	end

	for iter0_10, iter1_10 in pairs(arg0_10) do
		if table.equal(iter1_10, arg1_10) then
			return true
		end
	end

	return false
end

function table.Foreach(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11) do
		arg1_11(iter0_11, iter1_11)
	end
end

function table.Ipairs(arg0_12, arg1_12)
	for iter0_12, iter1_12 in ipairs(arg0_12) do
		arg1_12(iter0_12, iter1_12)
	end
end

function table.IpairsCArray(arg0_13, arg1_13)
	for iter0_13 = 0, arg0_13.Length - 1 do
		v = arg0_13[iter0_13]

		arg1_13(iter0_13, v)
	end
end

function table.SerialIpairsAsync(arg0_14, arg1_14, arg2_14)
	if type(arg0_14) ~= "table" then
		return
	end

	local var0_14
	local var1_14
	local var2_14
	local var3_14, var4_14

	var3_14, arg0_14, var4_14 = ipairs(arg0_14)

	local var5_14

	local function var6_14()
		var4_14, var1_14 = var3_14(arg0_14, var4_14)

		if var4_14 == nil then
			if arg2_14 then
				arg2_14()
			end
		else
			arg1_14(var4_14, var1_14, var6_14)
		end
	end

	var6_14()
end

function table.ParallelIpairsAsync(arg0_16, arg1_16, arg2_16)
	if type(arg0_16) ~= "table" then
		return
	end

	local var0_16
	local var1_16
	local var2_16
	local var3_16, var4_16

	var3_16, arg0_16, var4_16 = ipairs(arg0_16)

	local var5_16 = 0
	local var6_16 = 1

	local function var7_16()
		var5_16 = var5_16 + 1

		if var5_16 == var6_16 then
			existCall(arg2_16)
		end
	end

	while true do
		local var8_16

		var4_16, var8_16 = var3_16(arg0_16, var4_16)

		if var4_16 == nil then
			break
		end

		var6_16 = var6_16 + 1

		arg1_16(var4_16, var8_16, var7_16)
	end

	var7_16()
end

function table.Find(arg0_18, arg1_18)
	for iter0_18, iter1_18 in pairs(arg0_18) do
		if arg1_18(iter0_18, iter1_18) then
			return iter1_18, iter0_18
		end
	end
end

function table.Checkout(arg0_19, arg1_19)
	for iter0_19, iter1_19 in pairs(arg0_19) do
		local var0_19 = arg1_19(iter0_19, iter1_19)

		if var0_19 ~= nil then
			return var0_19
		end
	end
end

function table.getCount(arg0_20)
	local var0_20 = 0

	for iter0_20, iter1_20 in pairs(arg0_20) do
		var0_20 = var0_20 + 1
	end

	return var0_20
end

function table.merge(arg0_21, arg1_21)
	if not arg1_21 or not arg0_21 then
		return
	end

	for iter0_21, iter1_21 in pairs(arg1_21) do
		arg0_21[iter0_21] = iter1_21
	end

	return arg0_21
end

function table.mergeArray(arg0_22, arg1_22, arg2_22)
	local var0_22 = {}
	local var1_22 = {}

	local function var2_22(arg0_23)
		for iter0_23, iter1_23 in ipairs(arg0_23) do
			if arg2_22 and var0_22[iter1_23] then
				-- block empty
			else
				table.insert(var1_22, iter1_23)

				var0_22[iter1_23] = true
			end
		end
	end

	var2_22(arg0_22)
	var2_22(arg1_22)

	return var1_22
end

function table.clean(arg0_24)
	for iter0_24 = #arg0_24, 1, -1 do
		table.remove(arg0_24, iter0_24)
	end
end

function table.shallowCopy(arg0_25)
	if type(arg0_25) ~= "table" then
		return arg0_25
	end

	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25) do
		var0_25[iter0_25] = iter1_25
	end

	return var0_25
end

function table.getIndex(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26) do
		if arg1_26(iter1_26) then
			return iter0_26
		end
	end
end

function table.map(arg0_27, arg1_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27) do
		var0_27[iter0_27] = arg1_27(iter1_27)
	end

	return var0_27
end

function table.lastof(arg0_28)
	return arg0_28[#arg0_28]
end

function table.dichotomyInsert(arg0_29, arg1_29, arg2_29)
	arg2_29 = defaultValue(arg2_29, function(arg0_30)
		return arg0_30
	end)

	assert(type(arg2_29) == "function")

	local var0_29 = {}
	local var1_29 = 1
	local var2_29 = #arg0_29
	local var3_29

	local function var4_29(arg0_31)
		var0_29[arg0_31] = var0_29[arg0_31] or arg2_29(arg0_31)

		return var0_29[arg0_31]
	end

	while var1_29 < var2_29 do
		local var5_29 = math.floor((var1_29 + var2_29) / 2)

		if var4_29(arg0_29[var5_29]) < var4_29(arg1_29) then
			var1_29 = var5_29 + 1
		else
			var2_29 = var5_29
		end
	end

	table.insert(arg0_29, var1_29, arg1_29)
end

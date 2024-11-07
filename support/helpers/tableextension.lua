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
	local var0_13

	for iter0_13 = 0, arg0_13.Length - 1 do
		local var1_13 = arg0_13[iter0_13]

		arg1_13(iter0_13, var1_13)
	end
end

function table.CArrayToArray(arg0_14)
	local var0_14 = {}

	for iter0_14 = 0, arg0_14.Length - 1 do
		table.insert(var0_14, arg0_14[iter0_14])
	end

	return var0_14
end

function table.SerialIpairsAsync(arg0_15, arg1_15, arg2_15)
	if type(arg0_15) ~= "table" then
		return
	end

	local var0_15
	local var1_15
	local var2_15
	local var3_15, var4_15

	var3_15, arg0_15, var4_15 = ipairs(arg0_15)

	local var5_15

	local function var6_15()
		var4_15, var1_15 = var3_15(arg0_15, var4_15)

		if var4_15 == nil then
			if arg2_15 then
				arg2_15()
			end
		else
			arg1_15(var4_15, var1_15, var6_15)
		end
	end

	var6_15()
end

function table.ParallelIpairsAsync(arg0_17, arg1_17, arg2_17)
	if type(arg0_17) ~= "table" then
		return
	end

	local var0_17
	local var1_17
	local var2_17
	local var3_17, var4_17

	var3_17, arg0_17, var4_17 = ipairs(arg0_17)

	local var5_17 = 0
	local var6_17 = 1

	local function var7_17()
		var5_17 = var5_17 + 1

		if var5_17 == var6_17 then
			existCall(arg2_17)
		end
	end

	while true do
		local var8_17

		var4_17, var8_17 = var3_17(arg0_17, var4_17)

		if var4_17 == nil then
			break
		end

		var6_17 = var6_17 + 1

		arg1_17(var4_17, var8_17, var7_17)
	end

	var7_17()
end

function table.Find(arg0_19, arg1_19)
	for iter0_19, iter1_19 in pairs(arg0_19) do
		if arg1_19(iter0_19, iter1_19) then
			return iter1_19, iter0_19
		end
	end
end

function table.Checkout(arg0_20, arg1_20)
	for iter0_20, iter1_20 in pairs(arg0_20) do
		local var0_20 = arg1_20(iter0_20, iter1_20)

		if var0_20 ~= nil then
			return var0_20
		end
	end
end

function table.getCount(arg0_21)
	local var0_21 = 0

	for iter0_21, iter1_21 in pairs(arg0_21) do
		var0_21 = var0_21 + 1
	end

	return var0_21
end

function table.merge(arg0_22, arg1_22)
	if not arg1_22 or not arg0_22 then
		return
	end

	for iter0_22, iter1_22 in pairs(arg1_22) do
		arg0_22[iter0_22] = iter1_22
	end

	return arg0_22
end

function table.mergeArray(arg0_23, arg1_23, arg2_23)
	local var0_23 = {}
	local var1_23 = {}

	local function var2_23(arg0_24)
		for iter0_24, iter1_24 in ipairs(arg0_24) do
			if arg2_23 and var0_23[iter1_24] then
				-- block empty
			else
				table.insert(var1_23, iter1_24)

				var0_23[iter1_24] = true
			end
		end
	end

	var2_23(arg0_23)
	var2_23(arg1_23)

	return var1_23
end

function table.clean(arg0_25)
	for iter0_25 = #arg0_25, 1, -1 do
		table.remove(arg0_25, iter0_25)
	end
end

function table.shallowCopy(arg0_26)
	if type(arg0_26) ~= "table" then
		return arg0_26
	end

	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26) do
		var0_26[iter0_26] = iter1_26
	end

	return var0_26
end

function table.getIndex(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27) do
		if arg1_27(iter1_27) then
			return iter0_27
		end
	end
end

function table.map(arg0_28, arg1_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28) do
		var0_28[iter0_28] = arg1_28(iter1_28)
	end

	return var0_28
end

function table.lastof(arg0_29)
	return arg0_29[#arg0_29]
end

function table.dichotomyInsert(arg0_30, arg1_30, arg2_30)
	arg2_30 = defaultValue(arg2_30, function(arg0_31)
		return arg0_31
	end)

	assert(type(arg2_30) == "function")

	local var0_30 = {}
	local var1_30 = 1
	local var2_30 = #arg0_30
	local var3_30

	local function var4_30(arg0_32)
		var0_30[arg0_32] = var0_30[arg0_32] or arg2_30(arg0_32)

		return var0_30[arg0_32]
	end

	while var1_30 < var2_30 do
		local var5_30 = math.floor((var1_30 + var2_30) / 2)

		if var4_30(arg0_30[var5_30]) < var4_30(arg1_30) then
			var1_30 = var5_30 + 1
		else
			var2_30 = var5_30
		end
	end

	table.insert(arg0_30, var1_30, arg1_30)
end

function table.CastToString(arg0_33)
	if arg0_33 == nil then
		return "nil"
	end

	if type(arg0_33) == "string" then
		return "'" .. tostring(arg0_33) .. "'"
	end

	if type(arg0_33) ~= "table" then
		return tostring(arg0_33)
	end

	local var0_33 = "{"
	local var1_33 = #arg0_33
	local var2_33 = false

	for iter0_33, iter1_33 in ipairs(arg0_33) do
		if var2_33 then
			var0_33 = var0_33 .. ","
		end

		var2_33 = true
		var0_33 = var0_33 .. table.CastToString(iter1_33)
	end

	for iter2_33, iter3_33 in pairs(arg0_33) do
		if type(iter2_33) == "number" then
			if var1_33 < iter2_33 then
				if var2_33 then
					var0_33 = var0_33 .. ","
				end

				var2_33 = true
				var0_33 = var0_33 .. string.format("[%s]=%s", iter2_33, table.CastToString(iter3_33))
			end
		else
			if var2_33 then
				var0_33 = var0_33 .. ","
			end

			var2_33 = true
			var0_33 = var0_33 .. string.format("%s=%s", iter2_33, table.CastToString(iter3_33))
		end
	end

	return var0_33 .. "}"
end

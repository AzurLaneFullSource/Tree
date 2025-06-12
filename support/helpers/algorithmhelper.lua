AlgorithmHelper = {}

local var0_0 = AlgorithmHelper
local var1_0 = 1e+18

local function var2_0()
	return {
		first = 1,
		last = 0,
		data = {},
		push = function(arg0_2, arg1_2)
			arg0_2.last = arg0_2.last + 1
			arg0_2.data[arg0_2.last] = arg1_2
		end,
		pop = function(arg0_3)
			if arg0_3:isEmpty() then
				return nil
			end

			local var0_3 = arg0_3.data[arg0_3.first]

			arg0_3.data[arg0_3.first] = nil
			arg0_3.first = arg0_3.first + 1

			return var0_3
		end,
		isEmpty = function(arg0_4)
			return arg0_4.first > arg0_4.last
		end
	}
end

function var0_0.KM(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = {}
	local var2_5 = {}
	local var3_5 = {}
	local var4_5 = {}
	local var5_5 = {}
	local var6_5 = {}
	local var7_5 = {}
	local var8_5 = {}

	for iter0_5 = 1, arg0_5 do
		var0_5[iter0_5] = {}
		var1_5[iter0_5] = -var1_0
		var2_5[iter0_5] = 0
		var3_5[iter0_5] = 0
		var4_5[iter0_5] = 0

		for iter1_5 = 1, arg0_5 do
			var0_5[iter0_5][iter1_5] = -var1_0
		end
	end

	for iter2_5, iter3_5 in ipairs(arg1_5) do
		local var9_5, var10_5, var11_5 = unpack(iter3_5)

		if var11_5 > var0_5[var9_5][var10_5] then
			var0_5[var9_5][var10_5] = var11_5
		end

		if var1_5[var9_5] < var0_5[var9_5][var10_5] then
			var1_5[var9_5] = var0_5[var9_5][var10_5]
		end
	end

	local function var12_5(arg0_6)
		while arg0_6 ~= 0 do
			local var0_6 = var3_5[var7_5[arg0_6]]

			var3_5[var7_5[arg0_6]] = arg0_6
			var4_5[arg0_6] = var7_5[arg0_6]
			arg0_6 = var0_6
		end
	end

	local function var13_5(arg0_7)
		for iter0_7 = 1, arg0_5 do
			var5_5[iter0_7] = false
			var6_5[iter0_7] = false
			var8_5[iter0_7] = var1_0
		end

		local var0_7 = var2_0()

		var0_7:push(arg0_7)

		while true do
			while not var0_7:isEmpty() do
				local var1_7 = var0_7:pop()

				var5_5[var1_7] = true

				for iter1_7 = 1, arg0_5 do
					if not var6_5[iter1_7] then
						local var2_7 = var1_5[var1_7] + var2_5[iter1_7] - var0_5[var1_7][iter1_7]

						if var2_7 < var8_5[iter1_7] then
							var8_5[iter1_7] = var2_7
							var7_5[iter1_7] = var1_7

							if var2_7 == 0 then
								var6_5[iter1_7] = true

								if var4_5[iter1_7] == 0 then
									var12_5(iter1_7)

									return
								else
									var0_7:push(var4_5[iter1_7])
								end
							end
						end
					end
				end
			end

			local var3_7 = var1_0

			for iter2_7 = 1, arg0_5 do
				if not var6_5[iter2_7] and var3_7 > var8_5[iter2_7] then
					var3_7 = var8_5[iter2_7]
				end
			end

			for iter3_7 = 1, arg0_5 do
				if var5_5[iter3_7] then
					var1_5[iter3_7] = var1_5[iter3_7] - var3_7
				end

				if var6_5[iter3_7] then
					var2_5[iter3_7] = var2_5[iter3_7] + var3_7
				else
					var8_5[iter3_7] = var8_5[iter3_7] - var3_7
				end
			end

			for iter4_7 = 1, arg0_5 do
				if not var6_5[iter4_7] and var8_5[iter4_7] == 0 then
					var6_5[iter4_7] = true

					if var4_5[iter4_7] == 0 then
						var12_5(iter4_7)

						return
					else
						var0_7:push(var4_5[iter4_7])
					end
				end
			end
		end
	end

	for iter4_5 = 1, arg0_5 do
		var13_5(iter4_5)
	end

	local var14_5 = 0

	for iter5_5 = 1, arg0_5 do
		var14_5 = var14_5 + var1_5[iter5_5] + var2_5[iter5_5]
	end

	return var14_5, var3_5
end

return var0_0

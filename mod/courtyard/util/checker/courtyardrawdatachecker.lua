local var0_0 = class("CourtYardRawDataChecker")

function var0_0.Check(arg0_1, arg1_1)
	local var0_1 = {}
	local var1_1 = {}

	for iter0_1, iter1_1 in pairs(arg0_1) do
		local var2_1 = RawFurnitureData.New(iter1_1)

		if not var0_0.FillMap(var1_1, var2_1) then
			return false, i18n1("Incorrect position")
		end

		var0_1[iter1_1.id] = var2_1
	end

	for iter2_1, iter3_1 in pairs(var0_1) do
		local var3_1, var4_1 = var0_0._CheckFurnitrue(iter3_1, var0_1, arg1_1)

		if not var3_1 then
			return var3_1, i18n1("[" .. iter3_1.name .. "] erro:" .. var4_1 .. "-" .. iter3_1.id)
		end
	end

	return true
end

function var0_0.FillMap(arg0_2, arg1_2)
	if not arg1_2:MatOrPaper() and not arg1_2:ExistParnet() and arg1_2.config.belong == 1 and arg1_2.x and arg1_2.y then
		assert(arg1_2.x, arg1_2.id)

		for iter0_2 = arg1_2.x, arg1_2.x + arg1_2.sizeX - 1 do
			for iter1_2 = arg1_2.y, arg1_2.y + arg1_2.sizeY - 1 do
				if not arg0_2[iter0_2] then
					arg0_2[iter0_2] = {}
				end

				if arg0_2[iter0_2][iter1_2] then
					return false
				end

				arg0_2[iter0_2][iter1_2] = true
			end
		end
	end

	return true
end

function var0_0.CheckFurnitrue(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}
	local var1_3 = {}

	for iter0_3, iter1_3 in pairs(arg1_3) do
		local var2_3 = RawFurnitureData.New(iter1_3)

		if not var0_0.FillMap(var1_3, var2_3) then
			return false, i18n1("Incorrect position")
		end

		var0_3[iter1_3.id] = var2_3
	end

	local var3_3 = var0_3[arg0_3.id]

	return var0_0._CheckFurnitrue(var3_3, var0_3, arg2_3)
end

function var0_0._CheckFurnitrue(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg2_4.x
	local var1_4 = arg2_4.y
	local var2_4 = arg2_4.z
	local var3_4 = arg2_4.w

	if not arg0_4:IsCompletion() then
		return false, "Incomplete data"
	end

	if arg0_4:ExistParnet() and not arg0_4:LegalParent(arg1_4[arg0_4.parent]) then
		return false, "Incorrect [parent -> child] relation"
	end

	for iter0_4, iter1_4 in pairs(arg0_4.child or {}) do
		if not arg0_4:LegalChild(arg1_4[iter0_4]) then
			return false, "Incorrect [child -> parent] relation"
		end
	end

	if not arg0_4:InSide(var0_4, var1_4, var2_4, var3_4) then
		return false, "out side"
	end

	return true
end

return var0_0

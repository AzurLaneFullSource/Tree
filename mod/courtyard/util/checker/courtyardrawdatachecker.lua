local var0 = class("CourtYardRawDataChecker")

function var0.Check(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in pairs(arg0) do
		local var2 = RawFurnitureData.New(iter1)

		if not var0.FillMap(var1, var2) then
			return false, i18n1("Incorrect position")
		end

		var0[iter1.id] = var2
	end

	for iter2, iter3 in pairs(var0) do
		local var3, var4 = var0._CheckFurnitrue(iter3, var0, arg1)

		if not var3 then
			return var3, i18n1("[" .. iter3.name .. "] erro:" .. var4 .. "-" .. iter3.id)
		end
	end

	return true
end

function var0.FillMap(arg0, arg1)
	if not arg1:MatOrPaper() and not arg1:ExistParnet() and arg1.config.belong == 1 and arg1.x and arg1.y then
		assert(arg1.x, arg1.id)

		for iter0 = arg1.x, arg1.x + arg1.sizeX - 1 do
			for iter1 = arg1.y, arg1.y + arg1.sizeY - 1 do
				if not arg0[iter0] then
					arg0[iter0] = {}
				end

				if arg0[iter0][iter1] then
					return false
				end

				arg0[iter0][iter1] = true
			end
		end
	end

	return true
end

function var0.CheckFurnitrue(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in pairs(arg1) do
		local var2 = RawFurnitureData.New(iter1)

		if not var0.FillMap(var1, var2) then
			return false, i18n1("Incorrect position")
		end

		var0[iter1.id] = var2
	end

	local var3 = var0[arg0.id]

	return var0._CheckFurnitrue(var3, var0, arg2)
end

function var0._CheckFurnitrue(arg0, arg1, arg2)
	local var0 = arg2.x
	local var1 = arg2.y
	local var2 = arg2.z
	local var3 = arg2.w

	if not arg0:IsCompletion() then
		return false, "Incomplete data"
	end

	if arg0:ExistParnet() and not arg0:LegalParent(arg1[arg0.parent]) then
		return false, "Incorrect [parent -> child] relation"
	end

	for iter0, iter1 in pairs(arg0.child or {}) do
		if not arg0:LegalChild(arg1[iter0]) then
			return false, "Incorrect [child -> parent] relation"
		end
	end

	if not arg0:InSide(var0, var1, var2, var3) then
		return false, "out side"
	end

	return true
end

return var0

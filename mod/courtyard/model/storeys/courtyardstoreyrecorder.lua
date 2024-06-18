local var0_0 = class("CourtYardStoreyRecorder")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.storey = arg1_1
	arg0_1.setup = false
end

function var0_0.BeginCheckChange(arg0_2)
	arg0_2:Reset()

	arg0_2.setup = true
	arg0_2.headSample = arg0_2.storey:ToTable()
end

function var0_0.TakeSample(arg0_3)
	if not arg0_3.setup then
		return
	end

	local var0_3 = {}
	local var1_3 = {}
	local var2_3 = arg0_3.storey:GetAllFurniture()

	for iter0_3, iter1_3 in pairs(arg0_3.furnitures) do
		if not var2_3[iter1_3.id] then
			table.insert(var1_3, iter1_3.id)
		end
	end

	for iter2_3, iter3_3 in pairs(var2_3) do
		if iter3_3:IsDirty() then
			table.insert(var0_3, iter3_3:ToTable())
		end
	end

	arg0_3:Reset()

	return var0_3, var1_3
end

function var0_0.Reset(arg0_4)
	arg0_4.furnitures = arg0_4.storey:GetAllFurniture()

	for iter0_4, iter1_4 in pairs(arg0_4.furnitures) do
		if iter1_4:IsDirty() then
			iter1_4:UnDirty()
		end
	end
end

function var0_0.EndCheckChange(arg0_5)
	arg0_5:Clear()
end

function var0_0.Clear(arg0_6)
	arg0_6.furnitures = nil
	arg0_6.setup = false
	arg0_6.headSample = nil
end

function var0_0.HasChange(arg0_7)
	local var0_7 = arg0_7.storey:ToTable()
	local var1_7 = arg0_7.headSample

	if table.getCount(var0_7) ~= table.getCount(var1_7) then
		return true
	end

	local function var2_7(arg0_8, arg1_8)
		if not arg1_8 then
			return false
		end

		return arg0_8.id == arg1_8.id and arg0_8.dir == arg1_8.dir and arg0_8.parent == arg1_8.parent and arg0_8.position == arg1_8.position
	end

	for iter0_7, iter1_7 in pairs(var0_7) do
		if not var2_7(iter1_7, var1_7[iter1_7.id]) then
			return true
		end
	end

	return false
end

function var0_0.GetHeadSample(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.headSample) do
		table.insert(var0_9, iter1_9)
	end

	table.sort(var0_9, BackyardThemeFurniture._LoadWeight)

	return var0_9
end

function var0_0.Dispose(arg0_10)
	arg0_10:Clear()
end

return var0_0

local var0 = class("CourtYardStoreyRecorder")

function var0.Ctor(arg0, arg1)
	arg0.storey = arg1
	arg0.setup = false
end

function var0.BeginCheckChange(arg0)
	arg0:Reset()

	arg0.setup = true
	arg0.headSample = arg0.storey:ToTable()
end

function var0.TakeSample(arg0)
	if not arg0.setup then
		return
	end

	local var0 = {}
	local var1 = {}
	local var2 = arg0.storey:GetAllFurniture()

	for iter0, iter1 in pairs(arg0.furnitures) do
		if not var2[iter1.id] then
			table.insert(var1, iter1.id)
		end
	end

	for iter2, iter3 in pairs(var2) do
		if iter3:IsDirty() then
			table.insert(var0, iter3:ToTable())
		end
	end

	arg0:Reset()

	return var0, var1
end

function var0.Reset(arg0)
	arg0.furnitures = arg0.storey:GetAllFurniture()

	for iter0, iter1 in pairs(arg0.furnitures) do
		if iter1:IsDirty() then
			iter1:UnDirty()
		end
	end
end

function var0.EndCheckChange(arg0)
	arg0:Clear()
end

function var0.Clear(arg0)
	arg0.furnitures = nil
	arg0.setup = false
	arg0.headSample = nil
end

function var0.HasChange(arg0)
	local var0 = arg0.storey:ToTable()
	local var1 = arg0.headSample

	if table.getCount(var0) ~= table.getCount(var1) then
		return true
	end

	local function var2(arg0, arg1)
		if not arg1 then
			return false
		end

		return arg0.id == arg1.id and arg0.dir == arg1.dir and arg0.parent == arg1.parent and arg0.position == arg1.position
	end

	for iter0, iter1 in pairs(var0) do
		if not var2(iter1, var1[iter1.id]) then
			return true
		end
	end

	return false
end

function var0.GetHeadSample(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.headSample) do
		table.insert(var0, iter1)
	end

	table.sort(var0, BackyardThemeFurniture._LoadWeight)

	return var0
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0

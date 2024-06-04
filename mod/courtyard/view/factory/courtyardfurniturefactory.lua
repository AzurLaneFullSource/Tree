local var0 = class("CourtYardFurnitureFactory")

function var0.Ctor(arg0, arg1)
	arg0.poolMgr = arg1
	arg0.caches = {}
	arg0.jobs = {}

	local function var0()
		arg0:OnJobFinish()
	end

	local var1 = CourtYardFurnitureJob.New(arg0.poolMgr, var0)

	table.insert(arg0.jobs, var1)
end

function var0.Make(arg0, arg1)
	local var0 = arg0.poolMgr:GetFurniturePool():Dequeue()
	local var1

	if isa(arg1, CourtYardCanPutFurniture) then
		var1 = CourtYardCanPutFurnitureModule.New(arg1, var0)
	else
		var1 = CourtYardFurnitureModule.New(arg1, var0)
	end

	table.insert(arg0.caches, {
		arg1,
		var1
	})

	if #arg0.caches == 1 then
		local var2 = arg0:GetIdleJob()

		if var2 then
			var2:Work(var1, arg1)
		end
	end

	return var1
end

function var0.GetIdleJob(arg0)
	for iter0, iter1 in ipairs(arg0.jobs) do
		if not iter1:IsWorking() then
			return iter1
		end
	end
end

function var0.OnJobFinish(arg0)
	table.remove(arg0.caches, 1)

	if #arg0.caches > 0 then
		local var0 = arg0:GetIdleJob()

		assert(var0)

		local var1 = arg0.caches[1]
		local var2 = var1[1]
		local var3 = var1[2]

		var0:Work(var3, var2)
	end
end

function var0.Dispose(arg0)
	arg0.caches = nil

	for iter0, iter1 in pairs(arg0.jobs) do
		iter1:Stop()
	end

	arg0.jobs = nil
end

return var0

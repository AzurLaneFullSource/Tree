local var0_0 = class("CourtYardFurnitureFactory")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.poolMgr = arg1_1
	arg0_1.caches = {}
	arg0_1.jobs = {}

	local function var0_1()
		arg0_1:OnJobFinish()
	end

	local var1_1 = CourtYardFurnitureJob.New(arg0_1.poolMgr, var0_1)

	table.insert(arg0_1.jobs, var1_1)
end

function var0_0.Make(arg0_3, arg1_3)
	local var0_3 = arg0_3.poolMgr:GetFurniturePool():Dequeue()
	local var1_3

	if isa(arg1_3, CourtYardCanPutFurniture) then
		var1_3 = CourtYardCanPutFurnitureModule.New(arg1_3, var0_3)
	else
		var1_3 = CourtYardFurnitureModule.New(arg1_3, var0_3)
	end

	table.insert(arg0_3.caches, {
		arg1_3,
		var1_3
	})

	if #arg0_3.caches == 1 then
		local var2_3 = arg0_3:GetIdleJob()

		if var2_3 then
			var2_3:Work(var1_3, arg1_3)
		end
	end

	return var1_3
end

function var0_0.GetIdleJob(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.jobs) do
		if not iter1_4:IsWorking() then
			return iter1_4
		end
	end
end

function var0_0.OnJobFinish(arg0_5)
	table.remove(arg0_5.caches, 1)

	if #arg0_5.caches > 0 then
		local var0_5 = arg0_5:GetIdleJob()

		assert(var0_5)

		local var1_5 = arg0_5.caches[1]
		local var2_5 = var1_5[1]
		local var3_5 = var1_5[2]

		var0_5:Work(var3_5, var2_5)
	end
end

function var0_0.Dispose(arg0_6)
	arg0_6.caches = nil

	for iter0_6, iter1_6 in pairs(arg0_6.jobs) do
		iter1_6:Stop()
	end

	arg0_6.jobs = nil
end

return var0_0

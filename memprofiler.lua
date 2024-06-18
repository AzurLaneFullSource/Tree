local var0_0 = {}
local var1_0 = 0
local var2_0 = true

local function var3_0(arg0_1, arg1_1)
	local var0_1 = collectgarbage("count") - var1_0

	if var0_1 <= 1e-06 then
		var1_0 = collectgarbage("count")

		return
	end

	local var1_1 = debug.getinfo(2, "S").source

	if var2_0 then
		var1_1 = string.format("%s__%d", var1_1, arg1_1 - 1)
	end

	local var2_1 = var0_0[var1_1]

	if not var2_1 then
		var0_0[var1_1] = {
			var1_1,
			1,
			var0_1
		}
	else
		var2_1[2] = var2_1[2] + 1
		var2_1[3] = var2_1[3] + var0_1
	end

	var1_0 = collectgarbage("count")
end

local function var4_0(arg0_2)
	if debug.gethook() then
		SC_MemLeakDetector.SC_StopRecordAllocAndDumpStat()

		return
	end

	var0_0 = {}
	var1_0 = collectgarbage("count")
	var2_0 = not arg0_2

	debug.sethook(var3_0, "l")
end

local function var5_0(arg0_3)
	debug.sethook()

	if not var0_0 then
		return
	end

	local var0_3 = {}

	for iter0_3, iter1_3 in pairs(var0_0) do
		table.insert(var0_3, iter1_3)
	end

	table.sort(var0_3, function(arg0_4, arg1_4)
		return arg0_4[3] > arg1_4[3]
	end)

	arg0_3 = arg0_3 or "memAlloc.csv"

	local var1_3 = io.open(arg0_3, "w")

	if not var1_3 then
		logw.error("can't open file:", arg0_3)

		return
	end

	var1_3:write("fileLine, count, mem K, avg K\n")

	for iter2_3, iter3_3 in ipairs(var0_3) do
		var1_3:write(string.format("%s, %d, %f, %f\n", iter3_3[1], iter3_3[2], iter3_3[3], iter3_3[3] / iter3_3[2]))
	end

	var1_3:close()

	var0_0 = nil
end

return {
	StartRecordAlloc = var4_0,
	StopRecordAllocAndDumpStat = var5_0
}

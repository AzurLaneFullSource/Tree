local var0 = {}
local var1 = 0
local var2 = true

local function var3(arg0, arg1)
	local var0 = collectgarbage("count") - var1

	if var0 <= 1e-06 then
		var1 = collectgarbage("count")

		return
	end

	local var1 = debug.getinfo(2, "S").source

	if var2 then
		var1 = string.format("%s__%d", var1, arg1 - 1)
	end

	local var2 = var0[var1]

	if not var2 then
		var0[var1] = {
			var1,
			1,
			var0
		}
	else
		var2[2] = var2[2] + 1
		var2[3] = var2[3] + var0
	end

	var1 = collectgarbage("count")
end

local function var4(arg0)
	if debug.gethook() then
		SC_MemLeakDetector.SC_StopRecordAllocAndDumpStat()

		return
	end

	var0 = {}
	var1 = collectgarbage("count")
	var2 = not arg0

	debug.sethook(var3, "l")
end

local function var5(arg0)
	debug.sethook()

	if not var0 then
		return
	end

	local var0 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		return arg0[3] > arg1[3]
	end)

	arg0 = arg0 or "memAlloc.csv"

	local var1 = io.open(arg0, "w")

	if not var1 then
		logw.error("can't open file:", arg0)

		return
	end

	var1:write("fileLine, count, mem K, avg K\n")

	for iter2, iter3 in ipairs(var0) do
		var1:write(string.format("%s, %d, %f, %f\n", iter3[1], iter3[2], iter3[3], iter3[3] / iter3[2]))
	end

	var1:close()

	var0 = nil
end

return {
	StartRecordAlloc = var4,
	StopRecordAllocAndDumpStat = var5
}

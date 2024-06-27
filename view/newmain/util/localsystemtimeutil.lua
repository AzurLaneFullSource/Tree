local var0_0 = class("LocalSystemTimeUtil", import(".SystemTimeUtil"))

function var0_0.Flush(arg0_1)
	local var0_1 = os.date("%H:%M:%S")
	local var1_1 = string.split(var0_1, ":")
	local var2_1 = var1_1[2]
	local var3_1 = tonumber(var1_1[1])
	local var4_1 = var3_1 < 12 and "AM" or "PM"

	if arg0_1.callback then
		arg0_1.callback(var3_1, var2_1, var4_1)
	end

	local var5_1 = os.time()
	local var6_1 = arg0_1:GetSecondsToNextMinute(var5_1)

	arg0_1:AddTimer(var6_1)
end

return var0_0

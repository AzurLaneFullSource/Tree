local var0_0 = class("OpenOrCloseCatteryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().open
	local var1_1 = var0_1 and 0 or 1

	pg.ConnectionMgr.GetInstance():Send(25036, {
		is_open = var1_1
	})

	local var2_1 = getProxy(CommanderProxy)

	var2_1:UpdateOpenCommanderScene(var0_1)

	if var0_1 then
		local var3_1 = var2_1:GetCommanderHome()

		if var3_1 then
			local var4_1 = var3_1:GetCatteries()

			for iter0_1, iter1_1 in pairs(var4_1) do
				iter1_1:ClearCacheExp()
			end
		end
	end
end

return var0_0

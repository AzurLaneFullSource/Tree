local var0 = class("OpenOrCloseCatteryCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().open
	local var1 = var0 and 0 or 1

	pg.ConnectionMgr.GetInstance():Send(25036, {
		is_open = var1
	})

	local var2 = getProxy(CommanderProxy)

	var2:UpdateOpenCommanderScene(var0)

	if var0 then
		local var3 = var2:GetCommanderHome()

		if var3 then
			local var4 = var3:GetCatteries()

			for iter0, iter1 in pairs(var4) do
				iter1:ClearCacheExp()
			end
		end
	end
end

return var0

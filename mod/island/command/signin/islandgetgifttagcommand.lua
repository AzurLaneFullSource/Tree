local var0_0 = class("IslandGetGiftTagCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.list
	local var2_1 = var0_1.callback
	local var3_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		if getProxy(IslandProxy):GetGiftTagInfoCache(iter1_1) then
			-- block empty
		else
			table.insert(var3_1, iter1_1)
		end
	end

	pg.ConnectionMgr.GetInstance():Send(21315, {
		user_id_list = var3_1
	}, 21316, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.gift_list) do
			local var0_2 = IslandGiftTagInfo.New(iter1_2)

			getProxy(IslandProxy):AddGiftTagInfoCache(var0_2)
		end

		if var2_1 then
			var2_1()
		end
	end)
end

return var0_0

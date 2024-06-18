local var0_0 = class("MetaCharacterTacticsInfoRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().idList
	local var1_1 = ""

	for iter0_1, iter1_1 in ipairs(var0_1) do
		var1_1 = var1_1 .. iter1_1 .. ", "
	end

	print("63317 request tactics exp detail info:", var1_1)
	pg.ConnectionMgr.GetInstance():Send(63317, {
		ship_id_list = var0_1
	}, 63318, function(arg0_2)
		print("63318 requset success")

		local var0_2 = getProxy(MetaCharacterProxy)
		local var1_2 = arg0_2.info_list

		if var1_2 then
			for iter0_2, iter1_2 in ipairs(var1_2) do
				var0_2:setMetaTacticsInfo(iter1_2)
			end
		else
			errorMsg("63318 error, data.info_list is null!")
		end
	end)
end

return var0_0

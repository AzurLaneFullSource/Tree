local var0 = class("MetaCharacterTacticsInfoRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().idList
	local var1 = ""

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 .. iter1 .. ", "
	end

	print("63317 request tactics exp detail info:", var1)
	pg.ConnectionMgr.GetInstance():Send(63317, {
		ship_id_list = var0
	}, 63318, function(arg0)
		print("63318 requset success")

		local var0 = getProxy(MetaCharacterProxy)
		local var1 = arg0.info_list

		if var1 then
			for iter0, iter1 in ipairs(var1) do
				var0:setMetaTacticsInfo(iter1)
			end
		else
			errorMsg("63318 error, data.info_list is null!")
		end
	end)
end

return var0

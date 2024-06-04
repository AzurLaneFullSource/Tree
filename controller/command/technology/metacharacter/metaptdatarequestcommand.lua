local var0 = class("MetaPTDataRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(MetaCharacterProxy)
	local var1 = arg1:getBody()
	local var2 = {}

	if var1.isAll then
		local var3 = var0:getMetaProgressVOList()

		for iter0, iter1 in ipairs(var3) do
			if iter1:isPtType() and (iter1:isInAct() or iter1:isInArchive()) then
				table.insert(var2, iter1.id)
			end
		end
	end

	print("34001 meta pt request:", table.concat(var2, ","))
	pg.ConnectionMgr.GetInstance():Send(34001, {
		group_id = var2
	}, 34002, function(arg0)
		print("34002 meta pt request done:", #var2)
		var0:setAllProgressPTData(arg0.meta_ship_list)
	end)
end

return var0

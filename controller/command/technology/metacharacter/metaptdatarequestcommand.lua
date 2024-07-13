local var0_0 = class("MetaPTDataRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(MetaCharacterProxy)
	local var1_1 = arg1_1:getBody()
	local var2_1 = {}

	if var1_1.isAll then
		local var3_1 = var0_1:getMetaProgressVOList()

		for iter0_1, iter1_1 in ipairs(var3_1) do
			if iter1_1:isPtType() and (iter1_1:isInAct() or iter1_1:isInArchive()) then
				table.insert(var2_1, iter1_1.id)
			end
		end
	end

	print("34001 meta pt request:", table.concat(var2_1, ","))
	pg.ConnectionMgr.GetInstance():Send(34001, {
		group_id = var2_1
	}, 34002, function(arg0_2)
		print("34002 meta pt request done:", #var2_1)
		var0_1:setAllProgressPTData(arg0_2.meta_ship_list)
	end)
end

return var0_0

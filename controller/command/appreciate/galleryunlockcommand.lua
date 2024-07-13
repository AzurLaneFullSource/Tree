local var0_0 = class("GalleryUnlockCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.picID
	local var2_1 = var0_1.unlockCBFunc
	local var3_1 = getProxy(AppreciateProxy)
	local var4_1 = getProxy(BagProxy)
	local var5_1 = getProxy(PlayerProxy)
	local var6_1 = var5_1:getData()
	local var7_1 = var3_1:getPicUnlockMaterialByID(var1_1)

	for iter0_1, iter1_1 in pairs(var7_1) do
		if iter1_1.type == DROP_TYPE_RESOURCE then
			if var6_1:getResById(iter1_1.id) < iter1_1.count then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end
		elseif iter1_1.type == DROP_TYPE_ITEM and var4_1:getItemCountById(iter1_1.id) < iter1_1.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(17501, {
		id = var1_1
	}, 17502, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:addPicIDToUnlockList(var1_1)

			local var0_2 = var3_1:getPicUnlockMaterialByID(var1_1)

			for iter0_2, iter1_2 in pairs(var0_2) do
				if iter1_2.type == DROP_TYPE_RESOURCE then
					var6_1:consume({
						[id2res(iter1_2.id)] = iter1_2.count
					})
					var5_1:updatePlayer(var6_1)
				elseif iter1_2.type == DROP_TYPE_ITEM then
					var4_1:removeItemById(iter1_2.id, iter1_2.count)
				end
			end

			if var2_1 then
				var2_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("UnLock Fail, Code:" .. tostring(arg0_2.result))
		end
	end)
end

return var0_0

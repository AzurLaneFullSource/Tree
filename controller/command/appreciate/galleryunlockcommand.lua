local var0 = class("GalleryUnlockCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.picID
	local var2 = var0.unlockCBFunc
	local var3 = getProxy(AppreciateProxy)
	local var4 = getProxy(BagProxy)
	local var5 = getProxy(PlayerProxy)
	local var6 = var5:getData()
	local var7 = var3:getPicUnlockMaterialByID(var1)

	for iter0, iter1 in pairs(var7) do
		if iter1.type == DROP_TYPE_RESOURCE then
			if var6:getResById(iter1.id) < iter1.count then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end
		elseif iter1.type == DROP_TYPE_ITEM and var4:getItemCountById(iter1.id) < iter1.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(17501, {
		id = var1
	}, 17502, function(arg0)
		if arg0.result == 0 then
			var3:addPicIDToUnlockList(var1)

			local var0 = var3:getPicUnlockMaterialByID(var1)

			for iter0, iter1 in pairs(var0) do
				if iter1.type == DROP_TYPE_RESOURCE then
					var6:consume({
						[id2res(iter1.id)] = iter1.count
					})
					var5:updatePlayer(var6)
				elseif iter1.type == DROP_TYPE_ITEM then
					var4:removeItemById(iter1.id, iter1.count)
				end
			end

			if var2 then
				var2()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("UnLock Fail, Code:" .. tostring(arg0.result))
		end
	end)
end

return var0

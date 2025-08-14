local var0_0 = class("ChargePickShopView", import(".ChargeGiftShopView"))

function var0_0.getUIName(arg0_1)
	return "ChargePickShopUI"
end

function var0_0.GetViewSkinWrap(arg0_2)
	return ChargeScene.TYPE_PICK
end

function var0_0.updateGiftGoodsVOList(arg0_3)
	arg0_3.giftGoodsVOList = {}
	arg0_3.packageSortList = {
		0
	}

	local var0_3 = RefluxShopView.getAllRefluxPackID()
	local var1_3 = pg.pay_data_display

	for iter0_3, iter1_3 in pairs(var1_3.all) do
		if not table.contains(var0_3, iter1_3) then
			local var2_3 = var1_3[iter1_3]
			local var3_3 = var2_3.extra_service

			if var2_3.akashi_pick == 1 and (var3_3 == Goods.ITEM_BOX or var3_3 == Goods.PASS_ITEM) then
				local var4_3 = Goods.Create({
					shop_id = iter1_3
				}, Goods.TYPE_CHARGE)

				if arg0_3:filterLimitTypeGoods(var4_3) then
					local var5_3 = var2_3.package_sort_id

					if not table.contains(arg0_3.packageSortList, var5_3) then
						table.insert(arg0_3.packageSortList, var5_3)
					end

					table.insert(arg0_3.giftGoodsVOList, var4_3)
				end
			end
		end
	end

	for iter2_3, iter3_3 in pairs(pg.shop_template.get_id_list_by_genre.gift_package) do
		local var6_3 = pg.shop_template[iter3_3]

		if var6_3.akashi_pick == 1 and not table.contains(var0_3, iter3_3) then
			local var7_3 = Goods.Create({
				shop_id = iter3_3
			}, Goods.TYPE_GIFT_PACKAGE)
			local var8_3 = var6_3.package_sort_id

			if not table.contains(arg0_3.packageSortList, var8_3) then
				table.insert(arg0_3.packageSortList, var8_3)
			end

			table.insert(arg0_3.giftGoodsVOList, var7_3)
		end
	end
end

return var0_0

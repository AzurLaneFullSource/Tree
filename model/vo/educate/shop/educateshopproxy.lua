local var0_0 = class("EducateShopProxy")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.binder = arg1_1
	arg0_1.data = {}
end

function var0_0.SetUp(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.shops or {}) do
		var0_2[iter1_2.shop_id] = iter1_2.goods
	end

	arg0_2.data = {}

	for iter2_2, iter3_2 in ipairs(pg.child_shop.all) do
		arg0_2.data[iter3_2] = EducateShop.New(iter3_2, var0_2[iter3_2] or {})
	end

	arg0_2.discountData = {}

	for iter4_2, iter5_2 in ipairs(arg1_2.discountEventIds or {}) do
		arg0_2:AddDiscountEventById(iter5_2)
	end
end

function var0_0.GetShopWithId(arg0_3, arg1_3)
	return arg0_3.data[arg1_3]
end

function var0_0.UpdateShop(arg0_4, arg1_4)
	arg0_4.data[arg1_4.id] = arg1_4
end

function var0_0.GetDiscountData(arg0_5)
	return arg0_5.discountData
end

function var0_0.IsDiscountById(arg0_6, arg1_6)
	return arg0_6.discountData[arg1_6]
end

function var0_0.GetDiscountById(arg0_7, arg1_7)
	local var0_7 = arg0_7.discountData[arg1_7]

	return var0_7 and var0_7:GetDiscountRatio() or 0
end

function var0_0.AddDiscountEventById(arg0_8, arg1_8)
	local var0_8 = EducateSpecialEvent.New(arg1_8)

	arg0_8.discountData[var0_8:GetDiscountShopId()] = var0_8
end

function var0_0.OnNewWeek(arg0_9, arg1_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.data) do
		if iter1_9:IsRefreshShop(arg1_9) then
			table.insert(var0_9, function(arg0_10)
				arg0_9.binder:sendNotification(GAME.EDUCATE_REQUEST_SHOP_DATA, {
					shopId = iter1_9.id,
					callback = arg0_10
				})
			end)
		end
	end

	seriesAsync(var0_9, function()
		return
	end)

	for iter2_9, iter3_9 in pairs(arg0_9.discountData) do
		if not iter3_9:InDiscountTime(arg1_9) then
			arg0_9.discountData[iter2_9] = nil
		end
	end
end

return var0_0

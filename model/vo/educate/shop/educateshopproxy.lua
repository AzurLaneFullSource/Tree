local var0 = class("EducateShopProxy")

function var0.Ctor(arg0, arg1)
	arg0.binder = arg1
	arg0.data = {}
end

function var0.SetUp(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1.shops or {}) do
		var0[iter1.shop_id] = iter1.goods
	end

	arg0.data = {}

	for iter2, iter3 in ipairs(pg.child_shop.all) do
		arg0.data[iter3] = EducateShop.New(iter3, var0[iter3] or {})
	end

	arg0.discountData = {}

	for iter4, iter5 in ipairs(arg1.discountEventIds or {}) do
		arg0:AddDiscountEventById(iter5)
	end
end

function var0.GetShopWithId(arg0, arg1)
	return arg0.data[arg1]
end

function var0.UpdateShop(arg0, arg1)
	arg0.data[arg1.id] = arg1
end

function var0.GetDiscountData(arg0)
	return arg0.discountData
end

function var0.IsDiscountById(arg0, arg1)
	return arg0.discountData[arg1]
end

function var0.GetDiscountById(arg0, arg1)
	local var0 = arg0.discountData[arg1]

	return var0 and var0:GetDiscountRatio() or 0
end

function var0.AddDiscountEventById(arg0, arg1)
	local var0 = EducateSpecialEvent.New(arg1)

	arg0.discountData[var0:GetDiscountShopId()] = var0
end

function var0.OnNewWeek(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:IsRefreshShop(arg1) then
			table.insert(var0, function(arg0)
				arg0.binder:sendNotification(GAME.EDUCATE_REQUEST_SHOP_DATA, {
					shopId = iter1.id,
					callback = arg0
				})
			end)
		end
	end

	seriesAsync(var0, function()
		return
	end)

	for iter2, iter3 in pairs(arg0.discountData) do
		if not iter3:InDiscountTime(arg1) then
			arg0.discountData[iter2] = nil
		end
	end
end

return var0

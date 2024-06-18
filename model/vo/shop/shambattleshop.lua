local var0_0 = class("ShamBattleShop", import(".MonthlyShop"))

var0_0.GoodsType = Goods.TYPE_SHAM_BATTLE
var0_0.type = ShopArgs.ShopShamBattle

function var0_0.update(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg1_1

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg2_1) do
		var0_1[iter1_1.shop_id] = iter1_1.pay_count
	end

	table.clear(arg0_1.goods)

	if arg0_1.id and arg0_1.id > 0 and arg0_1:getConfigTable() then
		for iter2_1, iter3_1 in ipairs(arg0_1:getConfig("core_shop_goods")) do
			local var1_1 = var0_1[iter3_1] or 0

			arg0_1.goods[iter3_1] = Goods.Create({
				shop_id = iter3_1,
				buy_count = var1_1
			}, arg0_1.GoodsType)
		end
	end
end

return var0_0

local var0 = class("ShamBattleShop", import(".MonthlyShop"))

var0.GoodsType = Goods.TYPE_SHAM_BATTLE
var0.type = ShopArgs.ShopShamBattle

function var0.update(arg0, arg1, arg2)
	arg0.id = arg1
	arg0.configId = arg1

	local var0 = {}

	for iter0, iter1 in ipairs(arg2) do
		var0[iter1.shop_id] = iter1.pay_count
	end

	table.clear(arg0.goods)

	if arg0.id and arg0.id > 0 and arg0:getConfigTable() then
		for iter2, iter3 in ipairs(arg0:getConfig("core_shop_goods")) do
			local var1 = var0[iter3] or 0

			arg0.goods[iter3] = Goods.Create({
				shop_id = iter3,
				buy_count = var1
			}, arg0.GoodsType)
		end
	end
end

return var0

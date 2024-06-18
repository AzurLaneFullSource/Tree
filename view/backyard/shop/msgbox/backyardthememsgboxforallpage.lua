local var0_0 = class("BackYardThemeMsgBoxForAllPage", import(".BackYardThemeMsgBoxPage"))

function var0_0.SetUp(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.SetUp(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.purchase.text = i18n("purchase_backyard_theme_desc_for_all")

	setActive(arg0_1.purchaseTr, true)
	setText(arg0_1.gemPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setText(arg0_1.goldPurchaseBtn:Find("content/Text"), i18n("word_buy"))
end

function var0_0.GetAddList(arg0_2)
	local var0_2 = {}
	local var1_2 = arg0_2.themeVO:GetFurnitures()
	local var2_2 = arg0_2.dorm:GetPurchasedFurnitures()

	for iter0_2, iter1_2 in ipairs(var1_2) do
		local var3_2 = pg.furniture_data_template[iter1_2].count

		if var3_2 > 1 then
			local var4_2 = arg0_2.dorm:GetOwnFurnitureCount(iter1_2)

			for iter2_2 = 1, var3_2 - var4_2 do
				table.insert(var0_2, Furniture.New({
					id = iter1_2
				}))
			end
		elseif not var2_2[iter1_2] then
			table.insert(var0_2, Furniture.New({
				id = iter1_2
			}))
		end
	end

	return var0_2
end

return var0_0

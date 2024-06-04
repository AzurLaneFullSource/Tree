local var0 = class("BackYardThemeMsgBoxForAllPage", import(".BackYardThemeMsgBoxPage"))

function var0.SetUp(arg0, arg1, arg2, arg3)
	var0.super.SetUp(arg0, arg1, arg2, arg3)

	arg0.purchase.text = i18n("purchase_backyard_theme_desc_for_all")

	setActive(arg0.purchaseTr, true)
	setText(arg0.gemPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setText(arg0.goldPurchaseBtn:Find("content/Text"), i18n("word_buy"))
end

function var0.GetAddList(arg0)
	local var0 = {}
	local var1 = arg0.themeVO:GetFurnitures()
	local var2 = arg0.dorm:GetPurchasedFurnitures()

	for iter0, iter1 in ipairs(var1) do
		local var3 = pg.furniture_data_template[iter1].count

		if var3 > 1 then
			local var4 = arg0.dorm:GetOwnFurnitureCount(iter1)

			for iter2 = 1, var3 - var4 do
				table.insert(var0, Furniture.New({
					id = iter1
				}))
			end
		elseif not var2[iter1] then
			table.insert(var0, Furniture.New({
				id = iter1
			}))
		end
	end

	return var0
end

return var0

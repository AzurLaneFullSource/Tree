local var0_0 = class("ActivityShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0_0.Show(arg0_1, arg1_1)
	var0_0.super.Show(arg0_1, arg1_1)

	if arg1_1.icon then
		GetImageSpriteFromAtlasAsync(arg1_1.icon, "", arg0_1.resIcon)
	end
end

function var0_0.SetConfirmCb(arg0_2, arg1_2)
	arg0_2.confirmCallback = arg1_2
end

function var0_0.OnConfirm(arg0_3)
	if arg0_3.confirmCallback then
		local var0_3 = {}
		local var1_3 = {}

		for iter0_3, iter1_3 in ipairs(arg0_3.selectedList) do
			if not var1_3[iter1_3] then
				var1_3[iter1_3] = 0
			end

			var1_3[iter1_3] = var1_3[iter1_3] + 1
		end

		for iter2_3, iter3_3 in pairs(var1_3) do
			table.insert(var0_3, {
				key = iter2_3,
				value = iter3_3
			})
		end

		arg0_3.confirmCallback(arg0_3.data.id, var0_3, #arg0_3.selectedList)
	end
end

return var0_0

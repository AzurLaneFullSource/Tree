local var0_0 = class("BackYardThemeTemplatePurchaseMsgbox", import("...Shop.msgbox.BackYardThemeMsgBoxPage"))

function var0_0.SetUp(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.dorm = arg2_1
	arg0_1.template = arg1_1
	arg0_1.player = arg3_1
	arg0_1.count = 1
	arg0_1.maxCount = 1

	arg0_1:UpdateMainInfo()
	arg0_1:UpdateBtns()
	arg0_1:UpdatePrice()
	arg0_1:Show()

	arg0_1.purchase.text = i18n("purchase_backyard_theme_desc_for_onekey")

	setText(arg0_1.goldPurchaseBtn:Find("content/Text"), i18n("fur_onekey_buy"))
end

function var0_0.UpdateMainInfo(arg0_2)
	arg0_2.nameTxt.text = arg0_2.template:GetName()
	arg0_2.descTxt.text = arg0_2.template:GetDesc()

	setActive(arg0_2.icon.gameObject, false)
	setActive(arg0_2.rawIcon.gameObject, false)

	local var0_2 = arg0_2.template:GetIconMd5()

	BackYardThemeTempalteUtil.GetTexture(arg0_2.template:GetTextureIconName(), var0_2, function(arg0_3)
		if not IsNil(arg0_2.rawIcon) and arg0_3 then
			setActive(arg0_2.rawIcon.gameObject, true)

			arg0_2.rawIcon.texture = arg0_3
		end
	end)
end

function var0_0.GetAddList(arg0_4)
	local var0_4 = {}
	local var1_4 = arg0_4.template:GetFurnitureCnt()
	local var2_4 = arg0_4.dorm:GetPurchasedFurnitures()

	for iter0_4, iter1_4 in pairs(var1_4) do
		if pg.furniture_data_template[iter0_4] then
			local var3_4 = var2_4[iter0_4]
			local var4_4 = 0

			if not var3_4 then
				var3_4 = Furniture.New({
					id = iter0_4
				})
			else
				var4_4 = var3_4.count
			end

			if var3_4:canPurchase() and var3_4:inTime() and var3_4:canPurchaseByDormMoeny() then
				for iter2_4 = 1, iter1_4 - var4_4 do
					table.insert(var0_4, var3_4)
				end
			end
		end
	end

	return var0_4
end

function var0_0.OnDestroy(arg0_5)
	var0_0.super.OnDestroy(arg0_5)

	if not IsNil(arg0_5.rawIcon.texture) then
		Object.Destroy(arg0_5.rawIcon.texture)

		arg0_5.rawIcon.texture = nil
	end
end

return var0_0

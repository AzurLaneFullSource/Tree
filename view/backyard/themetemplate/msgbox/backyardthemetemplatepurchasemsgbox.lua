local var0 = class("BackYardThemeTemplatePurchaseMsgbox", import("...Shop.msgbox.BackYardThemeMsgBoxPage"))

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0.dorm = arg2
	arg0.template = arg1
	arg0.player = arg3
	arg0.count = 1
	arg0.maxCount = 1

	arg0:UpdateMainInfo()
	arg0:UpdateBtns()
	arg0:UpdatePrice()
	arg0:Show()

	arg0.purchase.text = i18n("purchase_backyard_theme_desc_for_onekey")

	setText(arg0.goldPurchaseBtn:Find("content/Text"), i18n("fur_onekey_buy"))
end

function var0.UpdateMainInfo(arg0)
	arg0.nameTxt.text = arg0.template:GetName()
	arg0.descTxt.text = arg0.template:GetDesc()

	setActive(arg0.icon.gameObject, false)
	setActive(arg0.rawIcon.gameObject, false)

	local var0 = arg0.template:GetIconMd5()

	BackYardThemeTempalteUtil.GetTexture(arg0.template:GetTextureIconName(), var0, function(arg0)
		if not IsNil(arg0.rawIcon) and arg0 then
			setActive(arg0.rawIcon.gameObject, true)

			arg0.rawIcon.texture = arg0
		end
	end)
end

function var0.GetAddList(arg0)
	local var0 = {}
	local var1 = arg0.template:GetFurnitureCnt()
	local var2 = arg0.dorm:GetPurchasedFurnitures()

	for iter0, iter1 in pairs(var1) do
		if pg.furniture_data_template[iter0] then
			local var3 = var2[iter0]
			local var4 = 0

			if not var3 then
				var3 = Furniture.New({
					id = iter0
				})
			else
				var4 = var3.count
			end

			if var3:canPurchase() and var3:inTime() and var3:canPurchaseByDormMoeny() then
				for iter2 = 1, iter1 - var4 do
					table.insert(var0, var3)
				end
			end
		end
	end

	return var0
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if not IsNil(arg0.rawIcon.texture) then
		Object.Destroy(arg0.rawIcon.texture)

		arg0.rawIcon.texture = nil
	end
end

return var0

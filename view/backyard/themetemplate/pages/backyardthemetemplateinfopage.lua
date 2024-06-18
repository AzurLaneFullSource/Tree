local var0_0 = class("BackYardThemeTemplateInfoPage", import("...Shop.pages.BackYardThemeInfoPage"))

function var0_0.getUIName(arg0_1)
	return "BackYardTemplateInfoPage"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	onButton(arg0_2, arg0_2.purchaseBtn, function()
		arg0_2.contextData.themeMsgBox:ExecuteAction("SetUp", arg0_2.template, arg0_2.dorm, arg0_2.player)
	end, SFX_PANEL)
	setActive(arg0_2.icon, false)

	arg0_2.iconRaw = arg0_2:findTF("frame/icon/Image_raw"):GetComponent(typeof(RawImage))

	setActive(arg0_2.leftArrBtn, false)
	setActive(arg0_2.rightArrBtn, false)
end

function var0_0.OnInitCard(arg0_4, arg1_4)
	local var0_4 = BackYardThemTemplateFurnitureCard.New(arg1_4)

	onButton(arg0_4, var0_4._go, function()
		if var0_4.furniture:canPurchase() and var0_4.furniture:inTime() and (var0_4.furniture:canPurchaseByGem() or var0_4.furniture:canPurchaseByDormMoeny()) then
			arg0_4.contextData.furnitureMsgBox:ExecuteAction("SetUp", var0_4.furniture, arg0_4.dorm, arg0_4.target)
		end
	end, SFX_PANEL)

	arg0_4.cards[arg1_4] = var0_4
end

function var0_0.SetUp(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6:Show()

	arg0_6.template = arg1_6
	arg0_6.dorm = arg2_6
	arg0_6.target = arg3_6
	arg0_6.player = getProxy(PlayerProxy):getData()

	arg0_6:InitFurnitureList()
	arg0_6:UpdateThemeInfo()
	arg0_6:UpdateRes()
end

function var0_0.InitFurnitureList(arg0_7)
	arg0_7.displays = {}

	local var0_7 = arg0_7.template:GetFurnitureCnt()
	local var1_7 = arg0_7.dorm:GetPurchasedFurnitures()

	for iter0_7, iter1_7 in pairs(var0_7) do
		if pg.furniture_data_template[iter0_7] then
			local var2_7 = var1_7[iter0_7] or Furniture.New({
				id = iter0_7
			})

			table.insert(arg0_7.displays, var2_7)
		end
	end

	local function var3_7(arg0_8)
		if arg0_8:inTime() then
			if arg0_8:canPurchaseByGem() and not arg0_8:canPurchaseByDormMoeny() then
				return 1
			elseif arg0_8:canPurchaseByGem() and arg0_8:canPurchaseByDormMoeny() then
				return 2
			else
				return 3
			end
		else
			return 4
		end
	end

	table.sort(arg0_7.displays, function(arg0_9, arg1_9)
		local var0_9 = arg0_9:canPurchase() and 1 or 0
		local var1_9 = arg1_9:canPurchase() and 1 or 0

		if var0_9 == var1_9 then
			return var3_7(arg0_9) < var3_7(arg1_9)
		else
			return var1_9 < var0_9
		end
	end)
	arg0_7.scrollRect:SetTotalCount(#arg0_7.displays)
end

function var0_0.UpdateThemeInfo(arg0_10)
	local var0_10 = arg0_10.template

	arg0_10.nameTxt.text = var0_10:GetName()

	setActive(arg0_10.iconRaw.gameObject, false)

	local var1_10 = var0_10:GetImageMd5()

	BackYardThemeTempalteUtil.GetTexture(var0_10:GetTextureName(), var1_10, function(arg0_11)
		if not IsNil(arg0_10.iconRaw) and arg0_11 then
			arg0_10.iconRaw.texture = arg0_11

			setActive(arg0_10.iconRaw.gameObject, true)
		end
	end)

	arg0_10.desc.text = var0_10:GetDesc()

	arg0_10:UpdatePurchaseBtn()
end

function var0_0.UpdatePurchaseBtn(arg0_12)
	local var0_12 = arg0_12.template:OwnThemeTemplateFurniture()
	local var1_12 = arg0_12.template:GetFurnitureCnt()
	local var2_12 = false

	for iter0_12, iter1_12 in pairs(var1_12) do
		local var3_12 = Furniture.New({
			id = iter0_12
		})
		local var4_12 = arg0_12.dorm:GetOwnFurnitureCount(iter0_12)

		if var3_12:inTime() and var3_12:canPurchaseByDormMoeny() and var4_12 < iter1_12 then
			var2_12 = true

			break
		end
	end

	setActive(arg0_12.purchaseBtn, not var0_12 and var2_12)
	setActive(arg0_12.purchaseAllBtn, false)
end

function var0_0.OnDestroy(arg0_13)
	var0_0.super.OnDestroy(arg0_13)

	if not IsNil(arg0_13.iconRaw.texture) then
		Object.Destroy(arg0_13.iconRaw.texture)

		arg0_13.iconRaw.texture = nil
	end
end

return var0_0

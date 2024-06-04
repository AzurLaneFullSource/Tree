local var0 = class("BackYardThemeTemplateInfoPage", import("...Shop.pages.BackYardThemeInfoPage"))

function var0.getUIName(arg0)
	return "BackYardTemplateInfoPage"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.purchaseBtn, function()
		arg0.contextData.themeMsgBox:ExecuteAction("SetUp", arg0.template, arg0.dorm, arg0.player)
	end, SFX_PANEL)
	setActive(arg0.icon, false)

	arg0.iconRaw = arg0:findTF("frame/icon/Image_raw"):GetComponent(typeof(RawImage))

	setActive(arg0.leftArrBtn, false)
	setActive(arg0.rightArrBtn, false)
end

function var0.OnInitCard(arg0, arg1)
	local var0 = BackYardThemTemplateFurnitureCard.New(arg1)

	onButton(arg0, var0._go, function()
		if var0.furniture:canPurchase() and var0.furniture:inTime() and (var0.furniture:canPurchaseByGem() or var0.furniture:canPurchaseByDormMoeny()) then
			arg0.contextData.furnitureMsgBox:ExecuteAction("SetUp", var0.furniture, arg0.dorm, arg0.target)
		end
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0:Show()

	arg0.template = arg1
	arg0.dorm = arg2
	arg0.target = arg3
	arg0.player = getProxy(PlayerProxy):getData()

	arg0:InitFurnitureList()
	arg0:UpdateThemeInfo()
	arg0:UpdateRes()
end

function var0.InitFurnitureList(arg0)
	arg0.displays = {}

	local var0 = arg0.template:GetFurnitureCnt()
	local var1 = arg0.dorm:GetPurchasedFurnitures()

	for iter0, iter1 in pairs(var0) do
		if pg.furniture_data_template[iter0] then
			local var2 = var1[iter0] or Furniture.New({
				id = iter0
			})

			table.insert(arg0.displays, var2)
		end
	end

	local function var3(arg0)
		if arg0:inTime() then
			if arg0:canPurchaseByGem() and not arg0:canPurchaseByDormMoeny() then
				return 1
			elseif arg0:canPurchaseByGem() and arg0:canPurchaseByDormMoeny() then
				return 2
			else
				return 3
			end
		else
			return 4
		end
	end

	table.sort(arg0.displays, function(arg0, arg1)
		local var0 = arg0:canPurchase() and 1 or 0
		local var1 = arg1:canPurchase() and 1 or 0

		if var0 == var1 then
			return var3(arg0) < var3(arg1)
		else
			return var1 < var0
		end
	end)
	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.UpdateThemeInfo(arg0)
	local var0 = arg0.template

	arg0.nameTxt.text = var0:GetName()

	setActive(arg0.iconRaw.gameObject, false)

	local var1 = var0:GetImageMd5()

	BackYardThemeTempalteUtil.GetTexture(var0:GetTextureName(), var1, function(arg0)
		if not IsNil(arg0.iconRaw) and arg0 then
			arg0.iconRaw.texture = arg0

			setActive(arg0.iconRaw.gameObject, true)
		end
	end)

	arg0.desc.text = var0:GetDesc()

	arg0:UpdatePurchaseBtn()
end

function var0.UpdatePurchaseBtn(arg0)
	local var0 = arg0.template:OwnThemeTemplateFurniture()
	local var1 = arg0.template:GetFurnitureCnt()
	local var2 = false

	for iter0, iter1 in pairs(var1) do
		local var3 = Furniture.New({
			id = iter0
		})
		local var4 = arg0.dorm:GetOwnFurnitureCount(iter0)

		if var3:inTime() and var3:canPurchaseByDormMoeny() and var4 < iter1 then
			var2 = true

			break
		end
	end

	setActive(arg0.purchaseBtn, not var0 and var2)
	setActive(arg0.purchaseAllBtn, false)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if not IsNil(arg0.iconRaw.texture) then
		Object.Destroy(arg0.iconRaw.texture)

		arg0.iconRaw.texture = nil
	end
end

return var0

local var0 = class("BackYardFurnitureMsgBoxPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "FurnitureMsgboxPage"
end

function var0.OnLoaded(arg0)
	arg0.nameTxt = arg0:findTF("frame/name"):GetComponent(typeof(Text))
	arg0.themeTxt = arg0:findTF("frame/theme/Text"):GetComponent(typeof(Text))
	arg0.descTxt = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.iconContainer = arg0:findTF("frame/icon")
	arg0.icon = arg0:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0.playBtn = arg0:findTF("frame/icon/play")
	arg0.rawIcon = arg0:findTF("frame/icon/rawImage"):GetComponent(typeof(RawImage))
	arg0.shipTr = arg0:findTF("frame/ship")
	arg0.shipIcon = arg0:findTF("frame/ship/icon"):GetComponent(typeof(Image))
	arg0.shipTxt = arg0:findTF("frame/ship/Text"):GetComponent(typeof(Text))
	arg0.countPanel = arg0:findTF("frame/count")
	arg0.leftArr = arg0:findTF("frame/count/left_arr")
	arg0.rightArr = arg0:findTF("frame/count/right_arr")
	arg0.countTxt = arg0:findTF("frame/count/Text"):GetComponent(typeof(Text))
	arg0.gemIcon = arg0:findTF("frame/price/gem")
	arg0.gemCount = arg0:findTF("frame/price/gem_text"):GetComponent(typeof(Text))
	arg0.goldIcon = arg0:findTF("frame/price/gold")
	arg0.goldCount = arg0:findTF("frame/price/gold_text"):GetComponent(typeof(Text))
	arg0.line = arg0:findTF("frame/price/line")
	arg0.energyIcon = arg0:findTF("frame/energy"):GetComponent(typeof(Image))
	arg0.energyTxt = arg0:findTF("frame/energy/Text"):GetComponent(typeof(Text))
	arg0.energyAddition = arg0:findTF("frame/energy/Text/addition"):GetComponent(typeof(Image))
	arg0.energyAdditionTxt = arg0:findTF("frame/energy/Text/addition/Text"):GetComponent(typeof(Text))
	arg0.closeBtn = arg0:findTF("frame/close_btn")
	arg0.btns = arg0:findTF("frame/btns")
	arg0.goldPurchaseBtn = arg0:findTF("frame/btns/gold_purchase_btn")
	arg0.gemPurchaseBtn = arg0:findTF("frame/btns/gem_purchase_btn")
	arg0.goldPurchaseIcon = arg0:findTF("frame/btns/gold_purchase_btn/content/icon")
	arg0.gemPurchaseIcon = arg0:findTF("frame/btns/gem_purchase_btn/content/icon")
	arg0.maxCnt = arg0:findTF("frame/max_cnt"):GetComponent(typeof(Text))
	arg0.maxBtn = arg0:findTF("frame/count/max")
	arg0.maxBtnTxt = arg0.maxBtn:Find("Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/price/label"), i18n("backyard_theme_total_print"))
	setActive(arg0.rawIcon, false)
end

function var0.OnInit(arg0)
	local function var0()
		local var0 = {}

		for iter0 = 1, arg0.count do
			table.insert(var0, arg0.furniture.id)
		end

		return var0
	end

	onButton(arg0, arg0.goldPurchaseBtn, function()
		local var0 = var0()

		arg0:emit(NewBackYardShopMediator.ON_SHOPPING, var0, PlayerConst.ResDormMoney)
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.gemPurchaseBtn, function()
		local var0 = var0()

		arg0:emit(NewBackYardShopMediator.ON_SHOPPING, var0, PlayerConst.ResDiamond)
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.leftArr, function()
		if arg0.count <= 1 then
			return
		end

		arg0.count = arg0.count - 1

		arg0:UpdatePrice()
	end, SFX_PANEL)
	onButton(arg0, arg0.rightArr, function()
		if arg0.count == arg0.maxCount then
			return
		end

		arg0.count = arg0.count + 1

		arg0:UpdatePrice()
	end, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		arg0.count = arg0.maxCount

		arg0:UpdatePrice()
	end, SFX_PANEL)
end

function var0.PlayerUpdated(arg0, arg1)
	arg0.player = arg1
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0.dorm = arg2
	arg0.furniture = arg1
	arg0.count = 1
	arg0.player = arg3
	arg0.maxCount = arg1:getConfig("count") - arg1.count

	local var0 = arg0.maxCount > 1

	setActive(arg0.maxBtn, var0)
	setAnchoredPosition(arg0.countPanel, {
		x = var0 and 200 or 258
	})

	arg0.maxBtnTxt.text = "MAX"

	arg0:UpdateMainInfo()
	arg0:UpdateSkinType()
	arg0:Show()
	setText(arg0.gemPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setText(arg0.goldPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setActive(arg0.goldPurchaseIcon, true)
	setActive(arg0.gemPurchaseIcon, true)
end

function var0.UpdateSkinType(arg0)
	local var0 = Goods.FurnitureId2Id(arg0.furniture.id)
	local var1 = Goods.ExistFurniture(var0)

	setActive(arg0.shipTr, var1)

	if var1 then
		local var2 = Goods.GetFurnitureConfig(var0)
		local var3 = Goods.Id2ShipSkinId(var2.id)
		local var4 = pg.ship_skin_template[var3]

		GetImageSpriteFromAtlasAsync("QIcon/" .. var4.prefab, "", arg0.shipIcon.gameObject)

		local var5 = ShipGroup.getDefaultShipConfig(var4.ship_group)

		arg0.shipTxt.text = shortenString(var5.name .. "-" .. var4.name, 15)
	end
end

function var0.UpdateMainInfo(arg0)
	local var0 = arg0.furniture
	local var1 = HXSet.hxLan(var0:getConfig("name"))

	arg0.nameTxt.text = var1
	arg0.themeTxt.text = var0:GetThemeName()
	arg0.descTxt.text = HXSet.hxLan(var0:getConfig("describe"))

	arg0:UpdateIcon()
	arg0:UpdatePrice()

	local var2 = var0:canPurchaseByDormMoeny()
	local var3 = var0:canPurchaseByGem()

	setActive(arg0.goldPurchaseBtn, var2)
	setActive(arg0.gemPurchaseBtn, var3)
	setActive(arg0.gemIcon, var3)
	setActive(arg0.gemCount, var3)
	setActive(arg0.goldIcon, var2)
	setActive(arg0.goldCount, var2)
	setActive(arg0.line, var2 and var3)

	local var4 = arg0.goldPurchaseBtn:GetComponent(typeof(LayoutElement))
	local var5 = arg0.gemPurchaseBtn:GetComponent(typeof(LayoutElement))

	if var3 and var2 then
		var4.preferredWidth = 239
		var5.preferredWidth = 239
	elseif var3 and not var2 then
		var4.preferredWidth = 0
		var5.preferredWidth = 510
	elseif not var3 and var2 then
		var4.preferredWidth = 510
		var5.preferredWidth = 0
	end

	arg0.maxCnt.text = ""

	if var0:getConfig("count") > 1 then
		arg0.maxCnt.text = var0.count .. "/" .. var0:getConfig("count")
	end
end

function var0.UpdateEnergy(arg0, arg1)
	local var0 = arg0.dorm:getComfortable()
	local var1 = arg0.dorm:getComfortable(arg1) - var0
	local var2 = var1 > 0
	local var3 = arg0.dorm:_GetComfortableLevel()

	LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "express_" .. var3, function(arg0)
		if arg0.exited then
			return
		end

		arg0.energyIcon.sprite = arg0

		arg0.energyIcon:SetNativeSize()
	end)

	local var4 = Color.New(0.5921569, 0.8470588, 0.4235294, 1)
	local var5 = Color.New(0.945098, 0.7960784, 0.3019608, 1)

	arg0.energyAddition.color = var2 and var4 or var5
	arg0.energyTxt.text = var0
	arg0.energyAdditionTxt.text = " +" .. var1
end

function var0.UpdatePrice(arg0)
	local var0 = arg0.furniture
	local var1 = var0:getPrice(PlayerConst.ResDormMoney)
	local var2 = var0:getPrice(PlayerConst.ResDiamond)

	arg0.gemCount.text = var2 * arg0.count
	arg0.goldCount.text = var1 * arg0.count
	arg0.countTxt.text = arg0.count

	local var3 = {}

	for iter0 = 1, arg0.count do
		table.insert(var3, Furniture.New({
			id = arg0.furniture.id
		}))
	end

	arg0:UpdateEnergy(var3)
end

function var0.UpdateIcon(arg0)
	arg0.icon.sprite = GetSpriteFromAtlas("furnitureicon/" .. arg0.furniture:getConfig("icon"), "")

	arg0.icon:SetNativeSize()
	setActive(arg0.icon.gameObject, true)

	local var0 = pg.furniture_data_template[arg0.furniture.configId]
	local var1

	var1 = var0.interAction ~= nil or var0.spine ~= nil and var0.spine[2] ~= nil

	setActive(arg0.playBtn, false)
	onButton(arg0, arg0.playBtn, function()
		local var0 = Goods.FurnitureId2Id(arg0.furniture.id)
		local var1 = Goods.ExistFurniture(var0)
		local var2 = 312011

		if var1 then
			var2 = Goods.Id2ShipSkinId(var0)
		end

		arg0.interactionPreview = CourtyardInteractionPreview.New(pg.UIMgr.GetInstance().OverlayMain, arg0._event)

		arg0.interactionPreview:ExecuteAction("Show", var0.id, var2)
	end, SFX_PANEL)
end

function var0.Show(arg0)
	arg0.isShowing = true

	var0.super.Show(arg0)
	SetParent(arg0._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0.Hide(arg0)
	arg0.isShowing = false

	var0.super.Hide(arg0)
	SetParent(arg0._tf, arg0._parentTf)

	if arg0.interactionPreview then
		arg0.interactionPreview:Destroy()

		arg0.interactionPreview = nil
	end
end

function var0.OnDestroy(arg0)
	if arg0.isShowing then
		arg0:Hide()
	end
end

return var0

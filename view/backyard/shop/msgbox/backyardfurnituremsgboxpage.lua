local var0_0 = class("BackYardFurnitureMsgBoxPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FurnitureMsgboxPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTxt = arg0_2:findTF("frame/name"):GetComponent(typeof(Text))
	arg0_2.themeTxt = arg0_2:findTF("frame/theme/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.iconContainer = arg0_2:findTF("frame/icon")
	arg0_2.icon = arg0_2:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0_2.playBtn = arg0_2:findTF("frame/icon/play")
	arg0_2.rawIcon = arg0_2:findTF("frame/icon/rawImage"):GetComponent(typeof(RawImage))
	arg0_2.shipTr = arg0_2:findTF("frame/ship")
	arg0_2.shipIcon = arg0_2:findTF("frame/ship/icon"):GetComponent(typeof(Image))
	arg0_2.shipTxt = arg0_2:findTF("frame/ship/Text"):GetComponent(typeof(Text))
	arg0_2.countPanel = arg0_2:findTF("frame/count")
	arg0_2.leftArr = arg0_2:findTF("frame/count/left_arr")
	arg0_2.rightArr = arg0_2:findTF("frame/count/right_arr")
	arg0_2.countTxt = arg0_2:findTF("frame/count/Text"):GetComponent(typeof(Text))
	arg0_2.gemIcon = arg0_2:findTF("frame/price/gem")
	arg0_2.gemCount = arg0_2:findTF("frame/price/gem_text"):GetComponent(typeof(Text))
	arg0_2.goldIcon = arg0_2:findTF("frame/price/gold")
	arg0_2.goldCount = arg0_2:findTF("frame/price/gold_text"):GetComponent(typeof(Text))
	arg0_2.line = arg0_2:findTF("frame/price/line")
	arg0_2.energyIcon = arg0_2:findTF("frame/energy"):GetComponent(typeof(Image))
	arg0_2.energyTxt = arg0_2:findTF("frame/energy/Text"):GetComponent(typeof(Text))
	arg0_2.energyAddition = arg0_2:findTF("frame/energy/Text/addition"):GetComponent(typeof(Image))
	arg0_2.energyAdditionTxt = arg0_2:findTF("frame/energy/Text/addition/Text"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("frame/close_btn")
	arg0_2.btns = arg0_2:findTF("frame/btns")
	arg0_2.goldPurchaseBtn = arg0_2:findTF("frame/btns/gold_purchase_btn")
	arg0_2.gemPurchaseBtn = arg0_2:findTF("frame/btns/gem_purchase_btn")
	arg0_2.goldPurchaseIcon = arg0_2:findTF("frame/btns/gold_purchase_btn/content/icon")
	arg0_2.gemPurchaseIcon = arg0_2:findTF("frame/btns/gem_purchase_btn/content/icon")
	arg0_2.maxCnt = arg0_2:findTF("frame/max_cnt"):GetComponent(typeof(Text))
	arg0_2.maxBtn = arg0_2:findTF("frame/count/max")
	arg0_2.maxBtnTxt = arg0_2.maxBtn:Find("Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/price/label"), i18n("backyard_theme_total_print"))
	setActive(arg0_2.rawIcon, false)
end

function var0_0.OnInit(arg0_3)
	local function var0_3()
		local var0_4 = {}

		for iter0_4 = 1, arg0_3.count do
			table.insert(var0_4, arg0_3.furniture.id)
		end

		return var0_4
	end

	onButton(arg0_3, arg0_3.goldPurchaseBtn, function()
		local var0_5 = var0_3()

		arg0_3:emit(NewBackYardShopMediator.ON_SHOPPING, var0_5, PlayerConst.ResDormMoney)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.gemPurchaseBtn, function()
		local var0_6 = var0_3()

		arg0_3:emit(NewBackYardShopMediator.ON_SHOPPING, var0_6, PlayerConst.ResDiamond)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.leftArr, function()
		if arg0_3.count <= 1 then
			return
		end

		arg0_3.count = arg0_3.count - 1

		arg0_3:UpdatePrice()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rightArr, function()
		if arg0_3.count == arg0_3.maxCount then
			return
		end

		arg0_3.count = arg0_3.count + 1

		arg0_3:UpdatePrice()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.maxBtn, function()
		arg0_3.count = arg0_3.maxCount

		arg0_3:UpdatePrice()
	end, SFX_PANEL)
end

function var0_0.PlayerUpdated(arg0_12, arg1_12)
	arg0_12.player = arg1_12
end

function var0_0.SetUp(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.dorm = arg2_13
	arg0_13.furniture = arg1_13
	arg0_13.count = 1
	arg0_13.player = arg3_13
	arg0_13.maxCount = arg1_13:getConfig("count") - arg1_13.count

	local var0_13 = arg0_13.maxCount > 1

	setActive(arg0_13.maxBtn, var0_13)
	setAnchoredPosition(arg0_13.countPanel, {
		x = var0_13 and 200 or 258
	})

	arg0_13.maxBtnTxt.text = "MAX"

	arg0_13:UpdateMainInfo()
	arg0_13:UpdateSkinType()
	arg0_13:Show()
	setText(arg0_13.gemPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setText(arg0_13.goldPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setActive(arg0_13.goldPurchaseIcon, true)
	setActive(arg0_13.gemPurchaseIcon, true)
end

function var0_0.UpdateSkinType(arg0_14)
	local var0_14 = Goods.FurnitureId2Id(arg0_14.furniture.id)
	local var1_14 = Goods.ExistFurniture(var0_14)

	setActive(arg0_14.shipTr, var1_14)

	if var1_14 then
		local var2_14 = Goods.GetFurnitureConfig(var0_14)
		local var3_14 = Goods.Id2ShipSkinId(var2_14.id)
		local var4_14 = pg.ship_skin_template[var3_14]

		GetImageSpriteFromAtlasAsync("QIcon/" .. var4_14.prefab, "", arg0_14.shipIcon.gameObject)

		local var5_14 = ShipGroup.getDefaultShipConfig(var4_14.ship_group)

		arg0_14.shipTxt.text = shortenString(var5_14.name .. "-" .. var4_14.name, 15)
	end
end

function var0_0.UpdateMainInfo(arg0_15)
	local var0_15 = arg0_15.furniture
	local var1_15 = HXSet.hxLan(var0_15:getConfig("name"))

	arg0_15.nameTxt.text = var1_15
	arg0_15.themeTxt.text = var0_15:GetThemeName()
	arg0_15.descTxt.text = HXSet.hxLan(var0_15:getConfig("describe"))

	arg0_15:UpdateIcon()
	arg0_15:UpdatePrice()

	local var2_15 = var0_15:canPurchaseByDormMoeny()
	local var3_15 = var0_15:canPurchaseByGem()

	setActive(arg0_15.goldPurchaseBtn, var2_15)
	setActive(arg0_15.gemPurchaseBtn, var3_15)
	setActive(arg0_15.gemIcon, var3_15)
	setActive(arg0_15.gemCount, var3_15)
	setActive(arg0_15.goldIcon, var2_15)
	setActive(arg0_15.goldCount, var2_15)
	setActive(arg0_15.line, var2_15 and var3_15)

	local var4_15 = arg0_15.goldPurchaseBtn:GetComponent(typeof(LayoutElement))
	local var5_15 = arg0_15.gemPurchaseBtn:GetComponent(typeof(LayoutElement))

	if var3_15 and var2_15 then
		var4_15.preferredWidth = 239
		var5_15.preferredWidth = 239
	elseif var3_15 and not var2_15 then
		var4_15.preferredWidth = 0
		var5_15.preferredWidth = 510
	elseif not var3_15 and var2_15 then
		var4_15.preferredWidth = 510
		var5_15.preferredWidth = 0
	end

	arg0_15.maxCnt.text = ""

	if var0_15:getConfig("count") > 1 then
		arg0_15.maxCnt.text = var0_15.count .. "/" .. var0_15:getConfig("count")
	end
end

function var0_0.UpdateEnergy(arg0_16, arg1_16)
	local var0_16 = arg0_16.dorm:getComfortable()
	local var1_16 = arg0_16.dorm:getComfortable(arg1_16) - var0_16
	local var2_16 = var1_16 > 0
	local var3_16 = arg0_16.dorm:_GetComfortableLevel()

	LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "express_" .. var3_16, function(arg0_17)
		if arg0_16.exited then
			return
		end

		arg0_16.energyIcon.sprite = arg0_17

		arg0_16.energyIcon:SetNativeSize()
	end)

	local var4_16 = Color.New(0.5921569, 0.8470588, 0.4235294, 1)
	local var5_16 = Color.New(0.945098, 0.7960784, 0.3019608, 1)

	arg0_16.energyAddition.color = var2_16 and var4_16 or var5_16
	arg0_16.energyTxt.text = var0_16
	arg0_16.energyAdditionTxt.text = " +" .. var1_16
end

function var0_0.UpdatePrice(arg0_18)
	local var0_18 = arg0_18.furniture
	local var1_18 = var0_18:getPrice(PlayerConst.ResDormMoney)
	local var2_18 = var0_18:getPrice(PlayerConst.ResDiamond)

	arg0_18.gemCount.text = var2_18 * arg0_18.count
	arg0_18.goldCount.text = var1_18 * arg0_18.count
	arg0_18.countTxt.text = arg0_18.count

	local var3_18 = {}

	for iter0_18 = 1, arg0_18.count do
		table.insert(var3_18, Furniture.New({
			id = arg0_18.furniture.id
		}))
	end

	arg0_18:UpdateEnergy(var3_18)
end

function var0_0.UpdateIcon(arg0_19)
	arg0_19.icon.sprite = GetSpriteFromAtlas("furnitureicon/" .. arg0_19.furniture:getConfig("icon"), "")

	arg0_19.icon:SetNativeSize()
	setActive(arg0_19.icon.gameObject, true)

	local var0_19 = pg.furniture_data_template[arg0_19.furniture.configId]
	local var1_19

	var1_19 = var0_19.interAction ~= nil or var0_19.spine ~= nil and var0_19.spine[2] ~= nil

	setActive(arg0_19.playBtn, false)
	onButton(arg0_19, arg0_19.playBtn, function()
		local var0_20 = Goods.FurnitureId2Id(arg0_19.furniture.id)
		local var1_20 = Goods.ExistFurniture(var0_20)
		local var2_20 = 312011

		if var1_20 then
			var2_20 = Goods.Id2ShipSkinId(var0_20)
		end

		arg0_19.interactionPreview = CourtyardInteractionPreview.New(pg.UIMgr.GetInstance().OverlayMain, arg0_19._event)

		arg0_19.interactionPreview:ExecuteAction("Show", var0_19.id, var2_20)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_21)
	arg0_21.isShowing = true

	var0_0.super.Show(arg0_21)
	SetParent(arg0_21._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0_0.Hide(arg0_22)
	arg0_22.isShowing = false

	var0_0.super.Hide(arg0_22)
	SetParent(arg0_22._tf, arg0_22._parentTf)

	if arg0_22.interactionPreview then
		arg0_22.interactionPreview:Destroy()

		arg0_22.interactionPreview = nil
	end
end

function var0_0.OnDestroy(arg0_23)
	if arg0_23.isShowing then
		arg0_23:Hide()
	end
end

return var0_0

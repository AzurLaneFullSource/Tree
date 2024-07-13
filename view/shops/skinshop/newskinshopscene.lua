local var0_0 = class("NewSkinShopScene", import("view.base.BaseUI"))

var0_0.MODE_OVERVIEW = 1
var0_0.MODE_EXPERIENCE = 2

local var1_0 = -1
local var2_0 = -2
local var3_0 = -3
local var4_0 = 9999
local var5_0 = 9997
local var6_0 = 9998

var0_0.PAGE_ALL = var1_0
var0_0.optionsPath = {
	"overlay/blur_panel/adapt/top/option"
}

function var0_0.getUIName(arg0_1)
	return "NewSkinShopUI"
end

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.ResUISettings(arg0_3)
	return {
		anim = true,
		showType = PlayerResUI.TYPE_GEM
	}
end

function var0_0.GetAllCommodity(arg0_4)
	return (getProxy(ShipSkinProxy):GetAllSkins())
end

function var0_0.GetPlayer(arg0_5)
	return (getProxy(PlayerProxy):getRawData())
end

function var0_0.GetShopTypeIdBySkinId(arg0_6, arg1_6)
	local var0_6 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not var0_0.shopTypeIdList then
		var0_0.shopTypeIdList = {}
	end

	if var0_0.shopTypeIdList[arg1_6] then
		return var0_0.shopTypeIdList[arg1_6]
	end

	for iter0_6, iter1_6 in pairs(var0_6) do
		for iter2_6, iter3_6 in ipairs(iter1_6) do
			var0_0.shopTypeIdList[iter3_6] = iter0_6

			if iter3_6 == arg1_6 then
				return iter0_6
			end
		end
	end
end

function var0_0.GetSkinClassify(arg0_7, arg1_7, arg2_7)
	local var0_7 = {}
	local var1_7 = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		local var2_7 = arg0_7:GetShopTypeIdBySkinId(iter1_7:getSkinId())
		local var3_7 = var2_7 == 0 and var4_0 or var2_7

		var1_7[var3_7] = (var1_7[var3_7] or 0) + 1
	end

	if #arg0_7:GetReturnSkins() > 0 then
		table.insert(var0_7, var3_0)
	end

	for iter2_7, iter3_7 in ipairs(pg.skin_page_template.all) do
		if iter3_7 ~= var5_0 and iter3_7 ~= var6_0 and (var1_7[iter3_7] or 0) > 0 then
			table.insert(var0_7, iter3_7)
		end
	end

	if arg2_7 == var0_0.MODE_EXPERIENCE then
		table.insert(var0_7, 1, var2_0)
	end

	table.insert(var0_7, 1, var1_0)

	return var0_7
end

function var0_0.GetReturnSkins(arg0_8)
	if not arg0_8.returnSkins then
		arg0_8.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()
	end

	return arg0_8.returnSkins
end

function var0_0.GetReturnSkinMap(arg0_9)
	if not arg0_9.encoreSkinMap then
		arg0_9.encoreSkinMap = {}

		local var0_9 = arg0_9:GetReturnSkins()

		for iter0_9, iter1_9 in ipairs(var0_9) do
			arg0_9.encoreSkinMap[iter1_9] = true
		end
	end

	return arg0_9.encoreSkinMap
end

function var0_0.OnFurnitureUpdate(arg0_10, arg1_10)
	if not arg0_10.mainView.commodity then
		return
	end

	local var0_10 = arg0_10.mainView.commodity.id

	if Goods.ExistFurniture(var0_10) and Goods.Id2FurnitureId(var0_10) == arg1_10 then
		arg0_10.mainView:Flush(arg0_10.mainView.commodity)
	end
end

function var0_0.OnShopping(arg0_11, arg1_11)
	if not arg0_11.mainView.commodity then
		return
	end

	arg0_11.mainView:ClosePurchaseView()

	if arg0_11.mainView.commodity.id == arg1_11 then
		local var0_11 = arg0_11:GetAllCommodity()
		local var1_11 = _.detect(var0_11, function(arg0_12)
			return arg0_12.id == arg1_11
		end)

		if var1_11 then
			arg0_11.mainView:Flush(var1_11)
		end

		arg0_11:UpdateCouponBtn()
		arg0_11:UpdateVoucherBtn()
		arg0_11:UpdateCommodities(var0_11, false)

		arg0_11.commodities = var0_11
	end
end

function var0_0.init(arg0_13)
	arg0_13.cgGroup = arg0_13._tf:GetComponent(typeof(CanvasGroup))
	arg0_13.backBtn = arg0_13:findTF("overlay/blur_panel/adapt/top/back_btn")
	arg0_13.atlasBtn = arg0_13:findTF("overlay/bottom/bg/atlas")
	arg0_13.prevBtn = arg0_13:findTF("overlay/bottom/bg/left_arr")
	arg0_13.nextBtn = arg0_13:findTF("overlay/bottom/bg/right_arr")
	arg0_13.live2dFilter = arg0_13:findTF("overlay/blur_panel/adapt/top/live2d")
	arg0_13.live2dFilterSel = arg0_13.live2dFilter:Find("selected")
	arg0_13.indexBtn = arg0_13:findTF("overlay/blur_panel/adapt/top/index_btn")
	arg0_13.indexBtnSel = arg0_13.indexBtn:Find("sel")
	arg0_13.inptuTr = arg0_13:findTF("overlay/blur_panel/adapt/top/search")
	arg0_13.changeBtn = arg0_13:findTF("overlay/blur_panel/adapt/top/change_btn")

	setText(arg0_13.inptuTr:Find("holder"), i18n("skinatlas_search_holder"))

	arg0_13.couponTr = arg0_13:findTF("overlay/blur_panel/adapt/top/discount/coupon")
	arg0_13.couponSelTr = arg0_13.couponTr:Find("selected")
	arg0_13.voucherTr = arg0_13:findTF("overlay/blur_panel/adapt/top/discount/voucher")
	arg0_13.voucherSelTr = arg0_13.voucherTr:Find("selected")
	arg0_13.rollingCircleRect = RollingCircleRect.New(arg0_13:findTF("overlay/left/mask/content/0"), arg0_13:findTF("overlay/left"))

	arg0_13.rollingCircleRect:SetCallback(arg0_13, var0_0.OnSelectSkinPage, var0_0.OnConfirmSkinPage)

	arg0_13.rollingCircleMaskTr = arg0_13:findTF("overlay/left")
	arg0_13.mainView = NewSkinShopMainView.New(arg0_13._tf, arg0_13.event)
	arg0_13.title = arg0_13:findTF("overlay/blur_panel/adapt/top/title"):GetComponent(typeof(Image))
	arg0_13.titleEn = arg0_13:findTF("overlay/blur_panel/adapt/top/title_en"):GetComponent(typeof(Image))
	arg0_13.scrollrect = arg0_13:findTF("overlay/bottom/scroll"):GetComponent("LScrollRect")
	arg0_13.scrollrect.isNewLoadingMethod = true

	function arg0_13.scrollrect.onInitItem(arg0_14)
		arg0_13:OnInitItem(arg0_14)
	end

	function arg0_13.scrollrect.onUpdateItem(arg0_15, arg1_15)
		arg0_13:OnUpdateItem(arg0_15, arg1_15)
	end

	arg0_13.emptyTr = arg0_13:findTF("bgs/empty")
	arg0_13.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinIndexLayer.ExtraALL
	}
	Input.multiTouchEnabled = false
end

function var0_0.didEnter(arg0_16)
	onButton(arg0_16, arg0_16.backBtn, function()
		arg0_16:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.atlasBtn, function()
		arg0_16:emit(NewSkinShopMediator.ON_ATLAS)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.prevBtn, function()
		arg0_16:OnPrevCommodity()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.nextBtn, function()
		arg0_16:OnNextCommodity()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.indexBtn, function()
		arg0_16:emit(NewSkinShopMediator.ON_INDEX, {
			OnFilter = function(arg0_22)
				arg0_16:OnFilter(arg0_22)
			end,
			defaultIndex = arg0_16.defaultIndex
		})
	end, SFX_PANEL)
	onInputChanged(arg0_16, arg0_16.inptuTr, function()
		arg0_16:OnSearch()
	end)
	onToggle(arg0_16, arg0_16.changeBtn, function(arg0_24)
		if arg0_24 and getInputText(arg0_16.inptuTr) ~= "" then
			setInputText(arg0_16.inptuTr, "")
		end
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.live2dFilter, function()
		arg0_16.defaultIndex.extraIndex = arg0_16.defaultIndex.extraIndex == SkinIndexLayer.ExtraL2D and SkinIndexLayer.ExtraALL or SkinIndexLayer.ExtraL2D

		arg0_16:OnFilter(arg0_16.defaultIndex)
	end, SFX_PANEL)

	arg0_16.isFilterCoupon = false

	onButton(arg0_16, arg0_16.couponTr, function()
		if not SkinCouponActivity.StaticExistActivityAndCoupon() then
			arg0_16.isFilterCoupon = false

			arg0_16:UpdateCouponBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_16.isFilterCoupon = not arg0_16.isFilterCoupon

		setActive(arg0_16.couponSelTr, arg0_16.isFilterCoupon)
		arg0_16:OnFilter(arg0_16.defaultIndex)
	end, SFX_PANEL)

	arg0_16.isFilterVoucher = false

	onButton(arg0_16, arg0_16.voucherTr, function()
		arg0_16.isFilterVoucher = not arg0_16.isFilterVoucher

		setActive(arg0_16.voucherSelTr, arg0_16.isFilterVoucher)
		arg0_16:OnFilter(arg0_16.defaultIndex)
	end, SFX_PANEL)
	arg0_16:SetUp()
end

function var0_0.UpdateCouponBtn(arg0_28)
	local var0_28 = SkinCouponActivity.StaticExistActivityAndCoupon() and (not arg0_28.contextData.mode or arg0_28.contextData.mode == var0_0.MODE_OVERVIEW)

	if arg0_28.isFilterCoupon and not var0_28 then
		arg0_28.isFilterCoupon = false
	end

	arg0_28.couponTr.localScale = var0_28 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0_0.UpdateVoucherBtn(arg0_29)
	local var0_29 = #getProxy(BagProxy):GetSkinShopDiscountItemList() > 0 and (not arg0_29.contextData.mode or arg0_29.contextData.mode == var0_0.MODE_OVERVIEW)

	if arg0_29.isFilterVoucher and not var0_29 then
		arg0_29.isFilterVoucher = false
	end

	arg0_29.voucherTr.localScale = var0_29 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0_0.OnSelectSkinPage(arg0_30, arg1_30)
	if arg0_30.selectedSkinPageItem then
		setActive(arg0_30.selectedSkinPageItem._tr:Find("selected"), false)
		setActive(arg0_30.selectedSkinPageItem._tr:Find("name"), true)
	end

	setActive(arg1_30._tr:Find("selected"), true)
	setActive(arg1_30._tr:Find("name"), false)

	arg0_30.selectedSkinPageItem = arg1_30
end

function var0_0.OnConfirmSkinPage(arg0_31, arg1_31)
	local var0_31 = arg1_31:GetID()

	if arg0_31.skinPageID ~= var0_31 then
		arg0_31.skinPageID = var0_31

		if arg0_31.commodities then
			arg0_31:UpdateCommodities(arg0_31.commodities, true)
		end
	end
end

function var0_0.OnFilter(arg0_32, arg1_32)
	arg0_32.defaultIndex = {
		typeIndex = arg1_32.typeIndex,
		campIndex = arg1_32.campIndex,
		rarityIndex = arg1_32.rarityIndex,
		extraIndex = arg1_32.extraIndex
	}

	setActive(arg0_32.live2dFilterSel, arg1_32.extraIndex == SkinIndexLayer.ExtraL2D)

	if arg0_32.commodities then
		arg0_32:UpdateCommodities(arg0_32.commodities, true)
	end

	setActive(arg0_32.indexBtnSel, arg1_32.typeIndex ~= ShipIndexConst.TypeAll or arg1_32.campIndex ~= ShipIndexConst.CampAll or arg1_32.rarityIndex ~= ShipIndexConst.RarityAll or arg1_32.extraIndex ~= SkinIndexLayer.ExtraALL)
end

function var0_0.OnSearch(arg0_33)
	if arg0_33.commodities then
		arg0_33:UpdateCommodities(arg0_33.commodities, true)
	end
end

function var0_0.SetUp(arg0_34)
	local var0_34 = arg0_34.contextData.mode or var0_0.MODE_OVERVIEW
	local var1_34 = arg0_34:GetAllCommodity()

	arg0_34.cgGroup.blocksRaycasts = false

	arg0_34:UpdateTitle(var0_34)
	arg0_34:UpdateCouponBtn()
	arg0_34:UpdateVoucherBtn()
	setActive(arg0_34.rollingCircleMaskTr, var0_34 == var0_0.MODE_OVERVIEW)

	if var0_34 == var0_0.MODE_EXPERIENCE then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	arg0_34.skinPageID = var0_34 == var0_0.MODE_EXPERIENCE and var2_0 or var1_0

	parallelAsync({
		function(arg0_35)
			arg0_34:InitSkinClassify(var1_34, var0_34, arg0_35)
		end,
		function(arg0_36)
			seriesAsync({
				function(arg0_37)
					onNextTick(arg0_37)
				end,
				function(arg0_38)
					if arg0_34.exited then
						return
					end

					arg0_34:UpdateCommodities(var1_34, true, arg0_38)
				end
			}, arg0_36)
		end
	}, function()
		arg0_34.commodities = var1_34
		arg0_34.cgGroup.blocksRaycasts = true
	end)
end

function var0_0.UpdateTitle(arg0_40, arg1_40)
	local var0_40 = {
		"huanzhuangshagndian",
		"title_01"
	}

	arg0_40.title.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var0_40[arg1_40])

	arg0_40.title:SetNativeSize()

	local var1_40 = {
		"huanzhuangshagndian_en",
		"title_en_01"
	}

	arg0_40.titleEn.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var1_40[arg1_40])

	arg0_40.titleEn:SetNativeSize()
end

local function var7_0(arg0_41, arg1_41)
	local var0_41 = pg.skin_page_template
	local var1_41 = arg1_41:GetID()
	local var2_41
	local var3_41

	if var1_41 == var1_0 or var1_41 == var2_0 then
		var2_41, var3_41 = "text_all", "ALL"
	elseif var1_41 == var3_0 then
		var2_41, var3_41 = "text_fanchang", "RETURN"
	else
		var2_41, var3_41 = "text_" .. var0_41[var1_41].res, var0_41[var1_41].english_name
	end

	LoadSpriteAtlasAsync("SkinClassified", var2_41 .. "01", function(arg0_42)
		if arg0_41.exited then
			return
		end

		local var0_42 = arg1_41._tr:Find("name"):GetComponent(typeof(Image))

		var0_42.sprite = arg0_42

		var0_42:SetNativeSize()
	end)
	LoadSpriteAtlasAsync("SkinClassified", var2_41, function(arg0_43)
		if arg0_41.exited then
			return
		end

		local var0_43 = arg1_41._tr:Find("selected/Image"):GetComponent(typeof(Image))

		var0_43.sprite = arg0_43

		var0_43:SetNativeSize()
	end)
	setText(arg1_41._tr:Find("eng"), var3_41)
end

function var0_0.InitSkinClassify(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = arg0_44:GetSkinClassify(arg1_44, arg2_44)
	local var1_44 = {}

	for iter0_44, iter1_44 in ipairs(var0_44) do
		table.insert(var1_44, function(arg0_45)
			if arg0_44.exited then
				return
			end

			local var0_45 = arg0_44.rollingCircleRect:AddItem(iter1_44)

			var7_0(arg0_44, var0_45)

			if (iter0_44 - 1) % 5 == 0 or iter0_44 == #var0_44 then
				onNextTick(arg0_45)
			else
				arg0_45()
			end
		end)
	end

	seriesAsync(var1_44, function()
		if arg0_44.exited then
			return
		end

		arg0_44.rollingCircleRect:ScrollTo(arg0_44.skinPageID)
		arg3_44()
	end)
end

function var0_0.IsType(arg0_47, arg1_47, arg2_47)
	if arg2_47:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return arg1_47 == var2_0
	elseif arg1_47 == var1_0 then
		return true
	elseif arg1_47 == var3_0 and arg0_47:GetReturnSkinMap()[arg2_47.id] then
		return true
	else
		local var0_47 = arg0_47:GetShopTypeIdBySkinId(arg2_47:getSkinId())

		return (var0_47 == 0 and var4_0 or var0_47) == arg1_47
	end

	return false
end

function var0_0.ToVShip(arg0_48, arg1_48)
	if not arg0_48.vship then
		arg0_48.vship = {}

		function arg0_48.vship.getNation()
			return arg0_48.vship.config.nationality
		end

		function arg0_48.vship.getShipType()
			return arg0_48.vship.config.type
		end

		function arg0_48.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_48.vship.config.type)
		end

		function arg0_48.vship.getRarity()
			return arg0_48.vship.config.rarity
		end
	end

	arg0_48.vship.config = arg1_48

	return arg0_48.vship
end

function var0_0.IsAllFilter(arg0_53, arg1_53)
	return arg1_53.typeIndex == ShipIndexConst.TypeAll and arg1_53.campIndex == ShipIndexConst.CampAll and arg1_53.rarityIndex == ShipIndexConst.RarityAll and arg1_53.extraIndex == SkinIndexLayer.ExtraALL
end

function var0_0.IsFilterType(arg0_54, arg1_54, arg2_54)
	if arg0_54:IsAllFilter(arg1_54) then
		return true
	end

	local var0_54 = arg2_54:getSkinId()
	local var1_54 = ShipSkin.New({
		id = var0_54
	})
	local var2_54 = var1_54:GetDefaultShipConfig()

	if not var2_54 then
		return false
	end

	local var3_54 = arg0_54:ToVShip(var2_54)
	local var4_54 = ShipIndexConst.filterByType(var3_54, arg1_54.typeIndex)
	local var5_54 = ShipIndexConst.filterByCamp(var3_54, arg1_54.campIndex)
	local var6_54 = ShipIndexConst.filterByRarity(var3_54, arg1_54.rarityIndex)
	local var7_54 = SkinIndexLayer.filterByExtra(var1_54, arg1_54.extraIndex)

	return var4_54 and var5_54 and var6_54 and var7_54
end

function var0_0.IsSearchType(arg0_55, arg1_55, arg2_55)
	if not arg1_55 or arg1_55 == "" then
		return true
	end

	local var0_55 = arg2_55:getSkinId()

	return ShipSkin.New({
		id = var0_55
	}):IsMatchKey(arg1_55)
end

local function var8_0(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg2_56[arg0_56.id]
	local var1_56 = arg2_56[arg1_56.id]

	if var0_56 == var1_56 then
		return arg0_56.id < arg1_56.id
	else
		return var1_56 < var0_56
	end
end

function var0_0.Sort(arg0_57, arg1_57, arg2_57, arg3_57)
	local var0_57 = arg1_57.buyCount == 0 and 1 or 0
	local var1_57 = arg2_57.buyCount == 0 and 1 or 0

	if var0_57 == var1_57 then
		local var2_57 = arg1_57:getConfig("order")
		local var3_57 = arg2_57:getConfig("order")

		if var2_57 == var3_57 then
			return var8_0(arg1_57, arg2_57, arg3_57)
		else
			return var2_57 < var3_57
		end
	else
		return var1_57 < var0_57
	end
end

function var0_0.IsCouponType(arg0_58, arg1_58, arg2_58)
	if arg1_58 and not SkinCouponActivity.StaticIsShop(arg2_58.id) then
		return false
	end

	return true
end

function var0_0.IsVoucherType(arg0_59, arg1_59, arg2_59)
	if arg1_59 and not arg2_59 then
		return false
	end

	return true
end

function var0_0.UpdateCommodities(arg0_60, arg1_60, arg2_60, arg3_60)
	arg0_60:ClearCards()

	arg0_60.cards = {}
	arg0_60.displays = {}
	arg0_60.canUseVoucherCache = {}

	local var0_60 = getInputText(arg0_60.inptuTr)
	local var1_60 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0_60, iter1_60 in ipairs(arg1_60) do
		local var2_60 = iter1_60:StaticCanUseVoucherType(var1_60)

		if arg0_60:IsType(arg0_60.skinPageID, iter1_60) and arg0_60:IsFilterType(arg0_60.defaultIndex, iter1_60) and arg0_60:IsSearchType(var0_60, iter1_60) and arg0_60:IsCouponType(arg0_60.isFilterCoupon, iter1_60) and arg0_60:IsVoucherType(arg0_60.isFilterVoucher, var2_60) then
			table.insert(arg0_60.displays, iter1_60)
		end

		arg0_60.canUseVoucherCache[iter1_60.id] = var2_60
	end

	local var3_60 = {}

	for iter2_60, iter3_60 in ipairs(arg0_60.displays) do
		local var4_60 = iter3_60.type == Goods.TYPE_ACTIVITY or iter3_60.type == Goods.TYPE_ACTIVITY_EXTRA
		local var5_60 = 0

		if not var4_60 then
			var5_60 = iter3_60:GetPrice()
		end

		var3_60[iter3_60.id] = var5_60
	end

	table.sort(arg0_60.displays, function(arg0_61, arg1_61)
		return arg0_60:Sort(arg0_61, arg1_61, var3_60)
	end)

	if arg2_60 then
		arg0_60.triggerFirstCard = true

		arg0_60.scrollrect:SetTotalCount(#arg0_60.displays, 0)
	else
		arg0_60.scrollrect:SetTotalCount(#arg0_60.displays)
	end

	local var6_60 = #arg0_60.displays <= 0

	setActive(arg0_60.emptyTr, var6_60)

	if var6_60 then
		arg0_60.mainView:Flush(nil)
	end

	if arg3_60 then
		arg3_60()
	end
end

function var0_0.OnInitItem(arg0_62, arg1_62)
	local var0_62 = NewShopSkinCard.New(arg1_62)

	onButton(arg0_62, var0_62._go, function()
		if not var0_62.commodity then
			return
		end

		for iter0_63, iter1_63 in pairs(arg0_62.cards) do
			iter1_63:UpdateSelected(false)
		end

		arg0_62.selectedId = var0_62.commodity.id

		var0_62:UpdateSelected(true)
		arg0_62:UpdateMainView(var0_62.commodity)
		arg0_62:GCHandle()
	end, SFX_PANEL)

	arg0_62.cards[arg1_62] = var0_62
end

function var0_0.OnUpdateItem(arg0_64, arg1_64, arg2_64)
	local var0_64 = arg0_64.cards[arg2_64]

	if not var0_64 then
		arg0_64:OnInitItem(arg2_64)

		var0_64 = arg0_64.cards[arg2_64]
	end

	local var1_64 = arg0_64.displays[arg1_64 + 1]

	if not var1_64 then
		return
	end

	local var2_64 = arg0_64.selectedId == var1_64.id
	local var3_64 = arg0_64:GetReturnSkinMap()[var1_64.id]

	var0_64:Update(var1_64, var2_64, var3_64)

	if arg0_64.triggerFirstCard and arg1_64 == 0 then
		arg0_64.triggerFirstCard = nil

		triggerButton(var0_64._go)
	end
end

function var0_0.GCHandle(arg0_65)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.UpdateMainView(arg0_66, arg1_66)
	arg0_66.mainView:Flush(arg1_66)
end

function var0_0.GetCommodityIndex(arg0_67, arg1_67)
	for iter0_67, iter1_67 in ipairs(arg0_67.displays) do
		if iter1_67.id == arg1_67 then
			return iter0_67
		end
	end
end

function var0_0.OnPrevCommodity(arg0_68)
	if not arg0_68.selectedId then
		return
	end

	local var0_68 = arg0_68:GetCommodityIndex(arg0_68.selectedId)

	if var0_68 - 1 > 0 then
		arg0_68:TriggerCommodity(var0_68, -1)
	end
end

function var0_0.OnNextCommodity(arg0_69)
	if not arg0_69.selectedId then
		return
	end

	local var0_69 = arg0_69:GetCommodityIndex(arg0_69.selectedId)

	if var0_69 + 1 <= #arg0_69.displays then
		arg0_69:TriggerCommodity(var0_69, 1)
	end
end

function var0_0.CheckCardBound(arg0_70, arg1_70, arg2_70, arg3_70, arg4_70)
	local var0_70 = getBounds(arg0_70.scrollrect.gameObject.transform)

	if arg3_70 then
		local var1_70 = getBounds(arg2_70._tf)
		local var2_70 = getBounds(arg1_70._tf)

		if math.ceil(var2_70:GetMax().x - var0_70:GetMax().x) > var1_70.size.x then
			local var3_70 = arg0_70.scrollrect:HeadIndexToValue(arg4_70 - 1) - arg0_70.scrollrect:HeadIndexToValue(arg4_70)
			local var4_70 = arg0_70.scrollrect.value - var3_70

			arg0_70.scrollrect:SetNormalizedPosition(var4_70, 0)
		end
	else
		local var5_70 = getBounds(arg1_70._tf)

		if getBounds(arg1_70._tf.parent):GetMin().x < var0_70:GetMin().x and var5_70:GetMin().x < var0_70:GetMin().x then
			local var6_70 = arg0_70.scrollrect:HeadIndexToValue(arg4_70 - 1)

			arg0_70.scrollrect:SetNormalizedPosition(var6_70, 0)
		end
	end
end

function var0_0.TriggerCommodity(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71.displays[arg1_71]
	local var1_71 = arg0_71.displays[arg1_71 + arg2_71]
	local var2_71
	local var3_71

	for iter0_71, iter1_71 in pairs(arg0_71.cards) do
		if iter1_71._tf.gameObject.name ~= "-1" then
			if iter1_71.commodity.id == var1_71.id then
				var2_71 = iter1_71
			elseif iter1_71.commodity.id == var0_71.id then
				var3_71 = iter1_71
			end
		end
	end

	if var2_71 then
		triggerButton(var2_71._tf)
	end

	if var2_71 and var3_71 then
		arg0_71:CheckCardBound(var2_71, var3_71, arg2_71 > 0, arg1_71 + arg2_71)
	end
end

function var0_0.ClearCards(arg0_72)
	if not arg0_72.cards then
		return
	end

	for iter0_72, iter1_72 in pairs(arg0_72.cards) do
		iter1_72:Dispose()
	end

	arg0_72.cards = nil
end

function var0_0.willExit(arg0_73)
	arg0_73:ClearCards()
	ClearLScrollrect(arg0_73.scrollrect)

	if arg0_73.rollingCircleRect then
		arg0_73.rollingCircleRect:Dispose()

		arg0_73.rollingCircleRect = nil
	end

	Input.multiTouchEnabled = true

	if arg0_73.mainView then
		arg0_73.mainView:Dispose()

		arg0_73.mainView = nil
	end

	var0_0.shopTypeIdList = nil
end

return var0_0

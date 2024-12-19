local var0_0 = class("NewSkinShopScene", import("view.base.BaseUI"))

var0_0.MODE_OVERVIEW = 1
var0_0.MODE_EXPERIENCE = 2
var0_0.MODE_EXPERIENCE_FOR_ITEM = 3

local var1_0 = -1
local var2_0 = -2
local var3_0 = -3
local var4_0 = -4
local var5_0 = 9999
local var6_0 = 9997
local var7_0 = 9998

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
		local var3_7 = var2_7 == 0 and var5_0 or var2_7

		var1_7[var3_7] = (var1_7[var3_7] or 0) + 1
	end

	local var4_7 = {}

	for iter2_7, iter3_7 in ipairs(arg0_7:GetReturnSkins()) do
		var4_7[iter3_7] = true
	end

	if underscore.any(arg1_7, function(arg0_8)
		return var4_7[arg0_8]
	end) then
		table.insert(var0_7, var3_0)
	end

	for iter4_7, iter5_7 in ipairs(pg.skin_page_template.all) do
		if iter5_7 ~= var6_0 and iter5_7 ~= var7_0 and (var1_7[iter5_7] or 0) > 0 then
			table.insert(var0_7, iter5_7)
		end
	end

	if arg2_7 == var0_0.MODE_EXPERIENCE then
		table.insert(var0_7, 1, var2_0)
	end

	if arg2_7 == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_7, 1, var4_0)
	end

	table.insert(var0_7, 1, var1_0)

	return var0_7
end

function var0_0.GetReturnSkins(arg0_9)
	if not arg0_9.returnSkins then
		arg0_9.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()
	end

	return arg0_9.returnSkins
end

function var0_0.GetReturnSkinMap(arg0_10)
	if not arg0_10.encoreSkinMap then
		arg0_10.encoreSkinMap = {}

		local var0_10 = arg0_10:GetReturnSkins()

		for iter0_10, iter1_10 in ipairs(var0_10) do
			arg0_10.encoreSkinMap[iter1_10] = true
		end
	end

	return arg0_10.encoreSkinMap
end

function var0_0.OnFurnitureUpdate(arg0_11, arg1_11)
	if not arg0_11.mainView.commodity then
		return
	end

	local var0_11 = arg0_11.mainView.commodity.id

	if Goods.ExistFurniture(var0_11) and Goods.Id2FurnitureId(var0_11) == arg1_11 then
		arg0_11.mainView:Flush(arg0_11.mainView.commodity)
	end
end

function var0_0.OnShopping(arg0_12, arg1_12)
	if not arg0_12.mainView.commodity then
		return
	end

	arg0_12.mainView:ClosePurchaseView()

	if arg0_12.mainView.commodity.id == arg1_12 then
		local var0_12 = arg0_12:GetAllCommodity()
		local var1_12 = _.detect(var0_12, function(arg0_13)
			return arg0_13.id == arg1_12
		end)

		if var1_12 then
			arg0_12.mainView:Flush(var1_12)
		end

		arg0_12:UpdateCouponBtn()
		arg0_12:UpdateVoucherBtn()
		arg0_12:UpdateCommodities(var0_12, false)

		arg0_12.commodities = var0_12
	end
end

function var0_0.init(arg0_14)
	arg0_14.cgGroup = arg0_14._tf:GetComponent(typeof(CanvasGroup))
	arg0_14.backBtn = arg0_14:findTF("overlay/blur_panel/adapt/top/back_btn")
	arg0_14.atlasBtn = arg0_14:findTF("overlay/bottom/bg/atlas")
	arg0_14.prevBtn = arg0_14:findTF("overlay/bottom/bg/left_arr")
	arg0_14.nextBtn = arg0_14:findTF("overlay/bottom/bg/right_arr")
	arg0_14.live2dFilter = arg0_14:findTF("overlay/blur_panel/adapt/top/live2d")
	arg0_14.live2dFilterSel = arg0_14.live2dFilter:Find("selected")
	arg0_14.indexBtn = arg0_14:findTF("overlay/blur_panel/adapt/top/index_btn")
	arg0_14.indexBtnSel = arg0_14.indexBtn:Find("sel")
	arg0_14.inptuTr = arg0_14:findTF("overlay/blur_panel/adapt/top/search")
	arg0_14.changeBtn = arg0_14:findTF("overlay/blur_panel/adapt/top/change_btn")

	setText(arg0_14.inptuTr:Find("holder"), i18n("skinatlas_search_holder"))

	arg0_14.couponTr = arg0_14:findTF("overlay/blur_panel/adapt/top/discount/coupon")
	arg0_14.couponSelTr = arg0_14.couponTr:Find("selected")
	arg0_14.voucherTr = arg0_14:findTF("overlay/blur_panel/adapt/top/discount/voucher")
	arg0_14.voucherSelTr = arg0_14.voucherTr:Find("selected")
	arg0_14.rollingCircleRect = RollingCircleRect.New(arg0_14:findTF("overlay/left/mask/content/0"), arg0_14:findTF("overlay/left"))

	arg0_14.rollingCircleRect:SetCallback(arg0_14, var0_0.OnSelectSkinPage, var0_0.OnConfirmSkinPage)

	arg0_14.rollingCircleMaskTr = arg0_14:findTF("overlay/left")
	arg0_14.mainView = NewSkinShopMainView.New(arg0_14._tf, arg0_14.event, arg0_14.contextData)
	arg0_14.title = arg0_14:findTF("overlay/blur_panel/adapt/top/title"):GetComponent(typeof(Image))
	arg0_14.titleEn = arg0_14:findTF("overlay/blur_panel/adapt/top/title_en"):GetComponent(typeof(Image))
	arg0_14.scrollrect = arg0_14:findTF("overlay/bottom/scroll"):GetComponent("LScrollRect")
	arg0_14.scrollrect.isNewLoadingMethod = true

	function arg0_14.scrollrect.onInitItem(arg0_15)
		arg0_14:OnInitItem(arg0_15)
	end

	function arg0_14.scrollrect.onUpdateItem(arg0_16, arg1_16)
		arg0_14:OnUpdateItem(arg0_16, arg1_16)
	end

	arg0_14.emptyTr = arg0_14:findTF("bgs/empty")
	arg0_14.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinIndexLayer.ExtraALL
	}
	Input.multiTouchEnabled = false
end

function var0_0.didEnter(arg0_17)
	onButton(arg0_17, arg0_17.backBtn, function()
		arg0_17:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17.atlasBtn, function()
		arg0_17:emit(NewSkinShopMediator.ON_ATLAS)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.prevBtn, function()
		arg0_17:OnPrevCommodity()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.nextBtn, function()
		arg0_17:OnNextCommodity()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.indexBtn, function()
		arg0_17:emit(NewSkinShopMediator.ON_INDEX, {
			OnFilter = function(arg0_23)
				arg0_17:OnFilter(arg0_23)
			end,
			defaultIndex = arg0_17.defaultIndex
		})
	end, SFX_PANEL)
	onInputChanged(arg0_17, arg0_17.inptuTr, function()
		arg0_17:OnSearch()
	end)
	onToggle(arg0_17, arg0_17.changeBtn, function(arg0_25)
		if arg0_25 and getInputText(arg0_17.inptuTr) ~= "" then
			setInputText(arg0_17.inptuTr, "")
		end
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.live2dFilter, function()
		arg0_17.defaultIndex.extraIndex = arg0_17.defaultIndex.extraIndex == SkinIndexLayer.ExtraL2D and SkinIndexLayer.ExtraALL or SkinIndexLayer.ExtraL2D

		arg0_17:OnFilter(arg0_17.defaultIndex)
	end, SFX_PANEL)

	arg0_17.isFilterCoupon = false

	onButton(arg0_17, arg0_17.couponTr, function()
		if not SkinCouponActivity.StaticExistActivityAndCoupon() then
			arg0_17.isFilterCoupon = false

			arg0_17:UpdateCouponBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_17.isFilterCoupon = not arg0_17.isFilterCoupon

		setActive(arg0_17.couponSelTr, arg0_17.isFilterCoupon)
		arg0_17:OnFilter(arg0_17.defaultIndex)
	end, SFX_PANEL)

	arg0_17.isFilterVoucher = false

	onButton(arg0_17, arg0_17.voucherTr, function()
		arg0_17.isFilterVoucher = not arg0_17.isFilterVoucher

		setActive(arg0_17.voucherSelTr, arg0_17.isFilterVoucher)
		arg0_17:OnFilter(arg0_17.defaultIndex)
	end, SFX_PANEL)
	arg0_17:SetUp()
end

function var0_0.UpdateCouponBtn(arg0_29)
	local var0_29 = SkinCouponActivity.StaticExistActivityAndCoupon() and (not arg0_29.contextData.mode or arg0_29.contextData.mode == var0_0.MODE_OVERVIEW)

	if arg0_29.isFilterCoupon and not var0_29 then
		arg0_29.isFilterCoupon = false
	end

	arg0_29.couponTr.localScale = var0_29 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0_0.UpdateVoucherBtn(arg0_30)
	local var0_30 = #getProxy(BagProxy):GetSkinShopDiscountItemList() > 0 and (not arg0_30.contextData.mode or arg0_30.contextData.mode == var0_0.MODE_OVERVIEW)

	if arg0_30.isFilterVoucher and not var0_30 then
		arg0_30.isFilterVoucher = false
	end

	arg0_30.voucherTr.localScale = var0_30 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0_0.OnSelectSkinPage(arg0_31, arg1_31)
	if arg0_31.selectedSkinPageItem then
		setActive(arg0_31.selectedSkinPageItem._tr:Find("selected"), false)
		setActive(arg0_31.selectedSkinPageItem._tr:Find("name"), true)
	end

	setActive(arg1_31._tr:Find("selected"), true)
	setActive(arg1_31._tr:Find("name"), false)

	arg0_31.selectedSkinPageItem = arg1_31
end

function var0_0.OnConfirmSkinPage(arg0_32, arg1_32)
	local var0_32 = arg1_32:GetID()

	if arg0_32.skinPageID ~= var0_32 then
		arg0_32.skinPageID = var0_32

		if arg0_32.commodities then
			arg0_32:UpdateCommodities(arg0_32.commodities, true)
		end
	end
end

function var0_0.OnFilter(arg0_33, arg1_33)
	arg0_33.defaultIndex = {
		typeIndex = arg1_33.typeIndex,
		campIndex = arg1_33.campIndex,
		rarityIndex = arg1_33.rarityIndex,
		extraIndex = arg1_33.extraIndex
	}

	setActive(arg0_33.live2dFilterSel, arg1_33.extraIndex == SkinIndexLayer.ExtraL2D)

	if arg0_33.commodities then
		arg0_33:UpdateCommodities(arg0_33.commodities, true)
	end

	setActive(arg0_33.indexBtnSel, arg1_33.typeIndex ~= ShipIndexConst.TypeAll or arg1_33.campIndex ~= ShipIndexConst.CampAll or arg1_33.rarityIndex ~= ShipIndexConst.RarityAll or arg1_33.extraIndex ~= SkinIndexLayer.ExtraALL)
end

function var0_0.OnSearch(arg0_34)
	if arg0_34.commodities then
		arg0_34:UpdateCommodities(arg0_34.commodities, true)
	end
end

local function var8_0(arg0_35)
	if arg0_35 == var0_0.MODE_EXPERIENCE then
		return var2_0
	elseif arg0_35 == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		return var4_0
	else
		return var1_0
	end
end

function var0_0.SetUp(arg0_36)
	local var0_36 = arg0_36.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_36.mode = var0_36

	local var1_36 = arg0_36:GetAllCommodity()

	arg0_36.cgGroup.blocksRaycasts = false

	arg0_36:UpdateTitle(var0_36)
	arg0_36:UpdateCouponBtn()
	arg0_36:UpdateVoucherBtn()
	setActive(arg0_36.rollingCircleMaskTr, var0_36 == var0_0.MODE_OVERVIEW)

	if var0_36 == var0_0.MODE_EXPERIENCE or var0_36 == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	arg0_36.skinPageID = var8_0(var0_36)

	parallelAsync({
		function(arg0_37)
			arg0_36:InitSkinClassify(var1_36, var0_36, arg0_37)
		end,
		function(arg0_38)
			seriesAsync({
				function(arg0_39)
					onNextTick(arg0_39)
				end,
				function(arg0_40)
					if arg0_36.exited then
						return
					end

					arg0_36:UpdateCommodities(var1_36, true, arg0_40)
				end
			}, arg0_38)
		end
	}, function()
		arg0_36.commodities = var1_36
		arg0_36.cgGroup.blocksRaycasts = true
	end)
end

function var0_0.UpdateTitle(arg0_42, arg1_42)
	local var0_42 = {
		"huanzhuangshagndian",
		"title_01",
		"title_01"
	}

	arg0_42.title.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var0_42[arg1_42])

	arg0_42.title:SetNativeSize()

	local var1_42 = {
		"huanzhuangshagndian_en",
		"title_en_01",
		"title_en_01"
	}

	arg0_42.titleEn.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var1_42[arg1_42])

	arg0_42.titleEn:SetNativeSize()
end

local function var9_0(arg0_43, arg1_43)
	local var0_43 = pg.skin_page_template
	local var1_43 = arg1_43:GetID()
	local var2_43
	local var3_43

	if var1_43 == var1_0 or var1_43 == var2_0 or var1_43 == var4_0 then
		var2_43, var3_43 = "text_all", "ALL"
	elseif var1_43 == var3_0 then
		var2_43, var3_43 = "text_fanchang", "RETURN"
	else
		var2_43, var3_43 = "text_" .. var0_43[var1_43].res, var0_43[var1_43].english_name
	end

	LoadSpriteAtlasAsync("SkinClassified", var2_43 .. "01", function(arg0_44)
		if arg0_43.exited then
			return
		end

		local var0_44 = arg1_43._tr:Find("name"):GetComponent(typeof(Image))

		var0_44.sprite = arg0_44

		var0_44:SetNativeSize()
	end)
	LoadSpriteAtlasAsync("SkinClassified", var2_43, function(arg0_45)
		if arg0_43.exited then
			return
		end

		local var0_45 = arg1_43._tr:Find("selected/Image"):GetComponent(typeof(Image))

		var0_45.sprite = arg0_45

		var0_45:SetNativeSize()
	end)
	setText(arg1_43._tr:Find("eng"), var3_43)
end

function var0_0.InitSkinClassify(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = arg0_46:GetSkinClassify(arg1_46, arg2_46)
	local var1_46 = {}

	for iter0_46, iter1_46 in ipairs(var0_46) do
		table.insert(var1_46, function(arg0_47)
			if arg0_46.exited then
				return
			end

			local var0_47 = arg0_46.rollingCircleRect:AddItem(iter1_46)

			var9_0(arg0_46, var0_47)

			if (iter0_46 - 1) % 5 == 0 or iter0_46 == #var0_46 then
				onNextTick(arg0_47)
			else
				arg0_47()
			end
		end)
	end

	seriesAsync(var1_46, function()
		if arg0_46.exited then
			return
		end

		arg0_46.rollingCircleRect:ScrollTo(arg0_46.skinPageID)
		arg3_46()
	end)
end

local function var10_0(arg0_49)
	if not var0_0.cacheSkinExperienceItems then
		var0_0.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(var0_0.cacheSkinExperienceItems, function(arg0_50)
		return arg0_50:CanUseForShop(arg0_49)
	end)
end

function var0_0.IsType(arg0_51, arg1_51, arg2_51)
	if arg2_51:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		if arg0_51.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
			return arg1_51 == var4_0 and var10_0(arg2_51.id)
		else
			return arg1_51 == var2_0
		end
	elseif arg1_51 == var1_0 then
		return true
	elseif arg1_51 == var3_0 and arg0_51:GetReturnSkinMap()[arg2_51.id] then
		return true
	else
		local var0_51 = arg0_51:GetShopTypeIdBySkinId(arg2_51:getSkinId())

		return (var0_51 == 0 and var5_0 or var0_51) == arg1_51
	end

	return false
end

function var0_0.ToVShip(arg0_52, arg1_52)
	if not arg0_52.vship then
		arg0_52.vship = {}

		function arg0_52.vship.getNation()
			return arg0_52.vship.config.nationality
		end

		function arg0_52.vship.getShipType()
			return arg0_52.vship.config.type
		end

		function arg0_52.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_52.vship.config.type)
		end

		function arg0_52.vship.getRarity()
			return arg0_52.vship.config.rarity
		end
	end

	arg0_52.vship.config = arg1_52

	return arg0_52.vship
end

function var0_0.IsAllFilter(arg0_57, arg1_57)
	return arg1_57.typeIndex == ShipIndexConst.TypeAll and arg1_57.campIndex == ShipIndexConst.CampAll and arg1_57.rarityIndex == ShipIndexConst.RarityAll and arg1_57.extraIndex == SkinIndexLayer.ExtraALL
end

function var0_0.IsFilterType(arg0_58, arg1_58, arg2_58)
	if arg0_58:IsAllFilter(arg1_58) then
		return true
	end

	local var0_58 = arg2_58:getSkinId()
	local var1_58 = ShipSkin.New({
		id = var0_58
	})
	local var2_58 = var1_58:GetDefaultShipConfig()

	if not var2_58 then
		return false
	end

	local var3_58 = arg0_58:ToVShip(var2_58)
	local var4_58 = ShipIndexConst.filterByType(var3_58, arg1_58.typeIndex)
	local var5_58 = ShipIndexConst.filterByCamp(var3_58, arg1_58.campIndex)
	local var6_58 = ShipIndexConst.filterByRarity(var3_58, arg1_58.rarityIndex)
	local var7_58 = SkinIndexLayer.filterByExtra(var1_58, arg1_58.extraIndex)

	return var4_58 and var5_58 and var6_58 and var7_58
end

function var0_0.IsSearchType(arg0_59, arg1_59, arg2_59)
	if not arg1_59 or arg1_59 == "" then
		return true
	end

	local var0_59 = arg2_59:getSkinId()

	return ShipSkin.New({
		id = var0_59
	}):IsMatchKey(arg1_59)
end

local function var11_0(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg2_60[arg0_60.id]
	local var1_60 = arg2_60[arg1_60.id]

	if var0_60 == var1_60 then
		return arg0_60.id < arg1_60.id
	else
		return var1_60 < var0_60
	end
end

function var0_0.Sort(arg0_61, arg1_61, arg2_61, arg3_61)
	local var0_61 = arg1_61.buyCount == 0 and 1 or 0
	local var1_61 = arg2_61.buyCount == 0 and 1 or 0

	if var0_61 == var1_61 then
		local var2_61 = arg1_61:getConfig("order")
		local var3_61 = arg2_61:getConfig("order")

		if var2_61 == var3_61 then
			return var11_0(arg1_61, arg2_61, arg3_61)
		else
			return var2_61 < var3_61
		end
	else
		return var1_61 < var0_61
	end
end

function var0_0.IsCouponType(arg0_62, arg1_62, arg2_62)
	if arg1_62 and not SkinCouponActivity.StaticIsShop(arg2_62.id) then
		return false
	end

	return true
end

function var0_0.IsVoucherType(arg0_63, arg1_63, arg2_63)
	if arg1_63 and not arg2_63 then
		return false
	end

	return true
end

function var0_0.UpdateCommodities(arg0_64, arg1_64, arg2_64, arg3_64)
	arg0_64:ClearCards()

	arg0_64.cards = {}
	arg0_64.displays = {}
	arg0_64.canUseVoucherCache = {}

	local var0_64 = getInputText(arg0_64.inptuTr)
	local var1_64 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0_64, iter1_64 in ipairs(arg1_64) do
		local var2_64 = iter1_64:StaticCanUseVoucherType(var1_64)

		if arg0_64:IsType(arg0_64.skinPageID, iter1_64) and arg0_64:IsFilterType(arg0_64.defaultIndex, iter1_64) and arg0_64:IsSearchType(var0_64, iter1_64) and arg0_64:IsCouponType(arg0_64.isFilterCoupon, iter1_64) and arg0_64:IsVoucherType(arg0_64.isFilterVoucher, var2_64) then
			table.insert(arg0_64.displays, iter1_64)
		end

		arg0_64.canUseVoucherCache[iter1_64.id] = var2_64
	end

	local var3_64 = {}

	for iter2_64, iter3_64 in ipairs(arg0_64.displays) do
		local var4_64 = iter3_64.type == Goods.TYPE_ACTIVITY or iter3_64.type == Goods.TYPE_ACTIVITY_EXTRA
		local var5_64 = 0

		if not var4_64 then
			var5_64 = iter3_64:GetPrice()
		end

		var3_64[iter3_64.id] = var5_64
	end

	table.sort(arg0_64.displays, function(arg0_65, arg1_65)
		return arg0_64:Sort(arg0_65, arg1_65, var3_64)
	end)

	if arg2_64 then
		arg0_64.triggerFirstCard = true

		arg0_64.scrollrect:SetTotalCount(#arg0_64.displays, 0)
	else
		arg0_64.scrollrect:SetTotalCount(#arg0_64.displays)
	end

	local var6_64 = #arg0_64.displays <= 0

	setActive(arg0_64.emptyTr, var6_64)

	if var6_64 then
		arg0_64.mainView:Flush(nil)
	end

	if arg3_64 then
		arg3_64()
	end
end

function var0_0.OnInitItem(arg0_66, arg1_66)
	local var0_66 = NewShopSkinCard.New(arg1_66)

	onButton(arg0_66, var0_66._go, function()
		if not var0_66.commodity then
			return
		end

		for iter0_67, iter1_67 in pairs(arg0_66.cards) do
			iter1_67:UpdateSelected(false)
		end

		arg0_66.selectedId = var0_66.commodity.id

		var0_66:UpdateSelected(true)
		arg0_66:UpdateMainView(var0_66.commodity)
		arg0_66:GCHandle()
	end, SFX_PANEL)

	arg0_66.cards[arg1_66] = var0_66
end

function var0_0.OnUpdateItem(arg0_68, arg1_68, arg2_68)
	local var0_68 = arg0_68.cards[arg2_68]

	if not var0_68 then
		arg0_68:OnInitItem(arg2_68)

		var0_68 = arg0_68.cards[arg2_68]
	end

	local var1_68 = arg0_68.displays[arg1_68 + 1]

	if not var1_68 then
		return
	end

	local var2_68 = arg0_68.selectedId == var1_68.id
	local var3_68 = arg0_68:GetReturnSkinMap()[var1_68.id]

	var0_68:Update(var1_68, var2_68, var3_68)

	if arg0_68.triggerFirstCard and arg1_68 == 0 then
		arg0_68.triggerFirstCard = nil

		triggerButton(var0_68._go)
	end
end

function var0_0.GCHandle(arg0_69)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.UpdateMainView(arg0_70, arg1_70)
	arg0_70.mainView:Flush(arg1_70)
end

function var0_0.GetCommodityIndex(arg0_71, arg1_71)
	for iter0_71, iter1_71 in ipairs(arg0_71.displays) do
		if iter1_71.id == arg1_71 then
			return iter0_71
		end
	end
end

function var0_0.OnPrevCommodity(arg0_72)
	if not arg0_72.selectedId then
		return
	end

	local var0_72 = arg0_72:GetCommodityIndex(arg0_72.selectedId)

	if var0_72 - 1 > 0 then
		arg0_72:TriggerCommodity(var0_72, -1)
	end
end

function var0_0.OnNextCommodity(arg0_73)
	if not arg0_73.selectedId then
		return
	end

	local var0_73 = arg0_73:GetCommodityIndex(arg0_73.selectedId)

	if var0_73 + 1 <= #arg0_73.displays then
		arg0_73:TriggerCommodity(var0_73, 1)
	end
end

function var0_0.CheckCardBound(arg0_74, arg1_74, arg2_74, arg3_74, arg4_74)
	local var0_74 = getBounds(arg0_74.scrollrect.gameObject.transform)

	if arg3_74 then
		local var1_74 = getBounds(arg2_74._tf)
		local var2_74 = getBounds(arg1_74._tf)

		if math.ceil(var2_74:GetMax().x - var0_74:GetMax().x) > var1_74.size.x then
			local var3_74 = arg0_74.scrollrect:HeadIndexToValue(arg4_74 - 1) - arg0_74.scrollrect:HeadIndexToValue(arg4_74)
			local var4_74 = arg0_74.scrollrect.value - var3_74

			arg0_74.scrollrect:SetNormalizedPosition(var4_74, 0)
		end
	else
		local var5_74 = getBounds(arg1_74._tf)

		if getBounds(arg1_74._tf.parent):GetMin().x < var0_74:GetMin().x and var5_74:GetMin().x < var0_74:GetMin().x then
			local var6_74 = arg0_74.scrollrect:HeadIndexToValue(arg4_74 - 1)

			arg0_74.scrollrect:SetNormalizedPosition(var6_74, 0)
		end
	end
end

function var0_0.TriggerCommodity(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75.displays[arg1_75]
	local var1_75 = arg0_75.displays[arg1_75 + arg2_75]
	local var2_75
	local var3_75

	for iter0_75, iter1_75 in pairs(arg0_75.cards) do
		if iter1_75._tf.gameObject.name ~= "-1" then
			if iter1_75.commodity.id == var1_75.id then
				var2_75 = iter1_75
			elseif iter1_75.commodity.id == var0_75.id then
				var3_75 = iter1_75
			end
		end
	end

	if var2_75 then
		triggerButton(var2_75._tf)
	end

	if var2_75 and var3_75 then
		arg0_75:CheckCardBound(var2_75, var3_75, arg2_75 > 0, arg1_75 + arg2_75)
	end
end

function var0_0.ClearCards(arg0_76)
	if not arg0_76.cards then
		return
	end

	for iter0_76, iter1_76 in pairs(arg0_76.cards) do
		iter1_76:Dispose()
	end

	arg0_76.cards = nil
end

function var0_0.willExit(arg0_77)
	arg0_77:ClearCards()
	ClearLScrollrect(arg0_77.scrollrect)

	if arg0_77.rollingCircleRect then
		arg0_77.rollingCircleRect:Dispose()

		arg0_77.rollingCircleRect = nil
	end

	Input.multiTouchEnabled = true

	if arg0_77.mainView then
		arg0_77.mainView:Dispose()

		arg0_77.mainView = nil
	end

	var0_0.shopTypeIdList = nil
	var0_0.cacheSkinExperienceItems = nil
end

return var0_0

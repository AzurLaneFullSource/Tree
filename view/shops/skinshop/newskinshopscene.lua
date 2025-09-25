local var0_0 = class("NewSkinShopScene", import("view.base.BaseUI"))

var0_0.MODE_OVERVIEW = 1
var0_0.MODE_EXPERIENCE = 2
var0_0.MODE_EXPERIENCE_FOR_ITEM = 3

local var1_0 = -1
local var2_0 = -2
local var3_0 = -3
local var4_0 = -4

var0_0.PAGE_RETURN = var3_0

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
	local var0_4 = getProxy(ShipSkinProxy):GetAllSkins()

	if LOCK_SKIN_US then
		local var1_4 = pg.gameset.levellimit_skintype.key_value
		local var2_4 = pg.gameset.levellimit_skintype.description

		if var1_4 >= getProxy(PlayerProxy):getData().level then
			var0_4 = _.filter(var0_4, function(arg0_5)
				local var0_5 = pg.ship_skin_template[arg0_5:getSkinId()].shop_type_id

				return table.contains(var2_4, var0_5)
			end)
		end
	end

	return var0_4
end

function var0_0.GetPlayer(arg0_6)
	return (getProxy(PlayerProxy):getRawData())
end

function var0_0.GetShopTypeIdBySkinId(arg0_7, arg1_7)
	local var0_7 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not var0_0.shopTypeIdList then
		var0_0.shopTypeIdList = {}
	end

	if var0_0.shopTypeIdList[arg1_7] then
		return var0_0.shopTypeIdList[arg1_7]
	end

	for iter0_7, iter1_7 in pairs(var0_7) do
		for iter2_7, iter3_7 in ipairs(iter1_7) do
			var0_0.shopTypeIdList[iter3_7] = iter0_7

			if iter3_7 == arg1_7 then
				return iter0_7
			end
		end
	end
end

function var0_0.GetSkinClassify(arg0_8, arg1_8, arg2_8)
	local var0_8 = {}
	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var2_8 = arg0_8:GetShopTypeIdBySkinId(iter1_8:getSkinId())
		local var3_8 = var2_8 == 0 and var5_0 or var2_8

		var1_8[var3_8] = (var1_8[var3_8] or 0) + 1
	end

	local var4_8 = {}

	for iter2_8, iter3_8 in ipairs(arg0_8:GetReturnSkins()) do
		var4_8[iter3_8] = true
	end

	if underscore.any(arg1_8, function(arg0_9)
		return var4_8[arg0_9.id]
	end) then
		table.insert(var0_8, var3_0)
	end

	for iter4_8, iter5_8 in ipairs(pg.skin_page_template.all) do
		if iter5_8 ~= var6_0 and iter5_8 ~= var7_0 and (var1_8[iter5_8] or 0) > 0 then
			table.insert(var0_8, iter5_8)
		end
	end

	if arg2_8 == var0_0.MODE_EXPERIENCE then
		table.insert(var0_8, 1, var2_0)
	end

	if arg2_8 == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		table.insert(var0_8, 1, var4_0)
	end

	table.insert(var0_8, 1, var1_0)

	return var0_8
end

function var0_0.GetReturnSkins(arg0_10)
	if not arg0_10.returnSkins then
		arg0_10.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()
	end

	return arg0_10.returnSkins
end

function var0_0.GetReturnSkinMap(arg0_11)
	if not arg0_11.encoreSkinMap then
		arg0_11.encoreSkinMap = {}

		local var0_11 = arg0_11:GetReturnSkins()

		for iter0_11, iter1_11 in ipairs(var0_11) do
			arg0_11.encoreSkinMap[iter1_11] = true
		end
	end

	return arg0_11.encoreSkinMap
end

function var0_0.OnFurnitureUpdate(arg0_12, arg1_12)
	if not arg0_12.mainView.commodity then
		return
	end

	local var0_12 = arg0_12.mainView.commodity.id

	if Goods.ExistFurniture(var0_12) and Goods.Id2FurnitureId(var0_12) == arg1_12 then
		arg0_12.mainView:Flush(arg0_12.mainView.commodity)
	end
end

function var0_0.OnShopping(arg0_13, arg1_13)
	if not arg0_13.mainView.commodity then
		return
	end

	arg0_13.mainView:ClosePurchaseView()

	if arg0_13.mainView.commodity.id == arg1_13 then
		local var0_13 = arg0_13:GetAllCommodity()
		local var1_13 = _.detect(var0_13, function(arg0_14)
			return arg0_14.id == arg1_13
		end)

		if var1_13 then
			arg0_13.mainView:Flush(var1_13)
		end

		arg0_13:UpdateCouponBtn()
		arg0_13:UpdateVoucherBtn()
		arg0_13:UpdateCommodities(var0_13, false)

		arg0_13.commodities = var0_13
	end
end

function var0_0.init(arg0_15)
	arg0_15.cgGroup = arg0_15._tf:GetComponent(typeof(CanvasGroup))
	arg0_15.backBtn = arg0_15:findTF("overlay/blur_panel/adapt/top/back_btn")
	arg0_15.atlasBtn = arg0_15:findTF("overlay/bottom/bg/atlas")
	arg0_15.prevBtn = arg0_15:findTF("overlay/bottom/bg/left_arr")
	arg0_15.nextBtn = arg0_15:findTF("overlay/bottom/bg/right_arr")
	arg0_15.live2dFilter = arg0_15:findTF("overlay/blur_panel/adapt/top/live2d")
	arg0_15.live2dFilterSel = arg0_15.live2dFilter:Find("selected")
	arg0_15.indexBtn = arg0_15:findTF("overlay/blur_panel/adapt/top/index_btn")
	arg0_15.indexBtnSel = arg0_15.indexBtn:Find("sel")
	arg0_15.inptuTr = arg0_15:findTF("overlay/blur_panel/adapt/top/search")
	arg0_15.changeBtn = arg0_15:findTF("overlay/blur_panel/adapt/top/change_btn")

	setText(arg0_15.inptuTr:Find("holder"), i18n("skinatlas_search_holder"))

	arg0_15.couponTr = arg0_15:findTF("overlay/blur_panel/adapt/top/discount/coupon")
	arg0_15.couponSelTr = arg0_15.couponTr:Find("selected")
	arg0_15.voucherTr = arg0_15:findTF("overlay/blur_panel/adapt/top/discount/voucher")
	arg0_15.voucherSelTr = arg0_15.voucherTr:Find("selected")
	arg0_15.rollingCircleRect = RollingCircleRect.New(arg0_15:findTF("overlay/left/mask/content/0"), arg0_15:findTF("overlay/left"))

	arg0_15.rollingCircleRect:SetCallback(arg0_15, var0_0.OnSelectSkinPage, var0_0.OnConfirmSkinPage)

	arg0_15.rollingCircleMaskTr = arg0_15:findTF("overlay/left")
	arg0_15.mainView = NewSkinShopMainView.New(arg0_15._tf, arg0_15.event, arg0_15.contextData)
	arg0_15.title = arg0_15:findTF("overlay/blur_panel/adapt/top/title"):GetComponent(typeof(Image))
	arg0_15.titleEn = arg0_15:findTF("overlay/blur_panel/adapt/top/title_en"):GetComponent(typeof(Image))
	arg0_15.scrollrect = arg0_15:findTF("overlay/bottom/scroll"):GetComponent("LScrollRect")
	arg0_15.scrollrect.isNewLoadingMethod = true

	function arg0_15.scrollrect.onInitItem(arg0_16)
		arg0_15:OnInitItem(arg0_16)
	end

	function arg0_15.scrollrect.onUpdateItem(arg0_17, arg1_17)
		arg0_15:OnUpdateItem(arg0_17, arg1_17)
	end

	arg0_15.emptyTr = arg0_15:findTF("bgs/empty")
	arg0_15.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinIndexLayer.ExtraALL
	}
	Input.multiTouchEnabled = false
end

function var0_0.didEnter(arg0_18)
	onButton(arg0_18, arg0_18.backBtn, function()
		arg0_18:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.atlasBtn, function()
		arg0_18:emit(NewSkinShopMediator.ON_ATLAS)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.prevBtn, function()
		arg0_18:OnPrevCommodity()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.nextBtn, function()
		arg0_18:OnNextCommodity()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.indexBtn, function()
		arg0_18:emit(NewSkinShopMediator.ON_INDEX, {
			OnFilter = function(arg0_24)
				arg0_18:OnFilter(arg0_24)
			end,
			defaultIndex = arg0_18.defaultIndex
		})
	end, SFX_PANEL)
	onInputChanged(arg0_18, arg0_18.inptuTr, function()
		arg0_18:OnSearch()
	end)
	onToggle(arg0_18, arg0_18.changeBtn, function(arg0_26)
		if arg0_26 and getInputText(arg0_18.inptuTr) ~= "" then
			setInputText(arg0_18.inptuTr, "")
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.live2dFilter, function()
		arg0_18.defaultIndex.extraIndex = arg0_18.defaultIndex.extraIndex == SkinIndexLayer.ExtraL2D and SkinIndexLayer.ExtraALL or SkinIndexLayer.ExtraL2D

		arg0_18:OnFilter(arg0_18.defaultIndex)
	end, SFX_PANEL)

	arg0_18.isFilterCoupon = false

	onButton(arg0_18, arg0_18.couponTr, function()
		if not SkinCouponActivity.StaticExistActivityAndCoupon() then
			arg0_18.isFilterCoupon = false

			arg0_18:UpdateCouponBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_18.isFilterCoupon = not arg0_18.isFilterCoupon

		setActive(arg0_18.couponSelTr, arg0_18.isFilterCoupon)
		arg0_18:OnFilter(arg0_18.defaultIndex)
	end, SFX_PANEL)

	arg0_18.isFilterVoucher = false

	onButton(arg0_18, arg0_18.voucherTr, function()
		arg0_18.isFilterVoucher = not arg0_18.isFilterVoucher

		setActive(arg0_18.voucherSelTr, arg0_18.isFilterVoucher)
		arg0_18:OnFilter(arg0_18.defaultIndex)
	end, SFX_PANEL)
	arg0_18:SetUp()
	getProxy(CommanderManualProxy):TaskProgressAdd(2021, 1)
end

function var0_0.UpdateCouponBtn(arg0_30)
	local var0_30 = SkinCouponActivity.StaticExistActivityAndCoupon() and (not arg0_30.contextData.mode or arg0_30.contextData.mode == var0_0.MODE_OVERVIEW)

	arg0_30.isFilterCoupon = tobool(arg0_30.isFilterCoupon) and var0_30
	arg0_30.couponTr.localScale = var0_30 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0_0.UpdateVoucherBtn(arg0_31)
	local var0_31 = #getProxy(BagProxy):GetSkinShopDiscountItemList() > 0 and (not arg0_31.contextData.mode or arg0_31.contextData.mode == var0_0.MODE_OVERVIEW)

	arg0_31.isFilterVoucher = tobool(arg0_31.isFilterVoucher) and var0_31
	arg0_31.voucherTr.localScale = var0_31 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0_0.OnSelectSkinPage(arg0_32, arg1_32)
	if arg0_32.selectedSkinPageItem then
		setActive(arg0_32.selectedSkinPageItem._tr:Find("selected"), false)
		setActive(arg0_32.selectedSkinPageItem._tr:Find("name"), true)
	end

	setActive(arg1_32._tr:Find("selected"), true)
	setActive(arg1_32._tr:Find("name"), false)

	arg0_32.selectedSkinPageItem = arg1_32
end

function var0_0.OnConfirmSkinPage(arg0_33, arg1_33)
	local var0_33 = arg1_33:GetID()

	if arg0_33.skinPageID ~= var0_33 then
		arg0_33.skinPageID = var0_33

		if arg0_33.commodities then
			arg0_33:UpdateCommodities(arg0_33.commodities, true)
		end
	end
end

function var0_0.OnFilter(arg0_34, arg1_34)
	arg0_34.defaultIndex = {
		typeIndex = arg1_34.typeIndex,
		campIndex = arg1_34.campIndex,
		rarityIndex = arg1_34.rarityIndex,
		extraIndex = arg1_34.extraIndex
	}

	setActive(arg0_34.live2dFilterSel, arg1_34.extraIndex == SkinIndexLayer.ExtraL2D)

	if arg0_34.commodities then
		arg0_34:UpdateCommodities(arg0_34.commodities, true)
	end

	setActive(arg0_34.indexBtnSel, arg1_34.typeIndex ~= ShipIndexConst.TypeAll or arg1_34.campIndex ~= ShipIndexConst.CampAll or arg1_34.rarityIndex ~= ShipIndexConst.RarityAll or arg1_34.extraIndex ~= SkinIndexLayer.ExtraALL)
end

function var0_0.OnSearch(arg0_35)
	if arg0_35.commodities then
		arg0_35:UpdateCommodities(arg0_35.commodities, true)
	end
end

function var0_0.GetDefaultPage(arg0_36, arg1_36)
	if arg1_36 == var0_0.MODE_EXPERIENCE then
		return var2_0
	elseif arg1_36 == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		return var4_0
	else
		return arg0_36.contextData.page and arg0_36.contextData.page or var1_0
	end
end

function var0_0.SetUp(arg0_37)
	local var0_37 = arg0_37.contextData.mode or var0_0.MODE_OVERVIEW

	arg0_37.mode = var0_37

	local var1_37 = arg0_37:GetAllCommodity()

	arg0_37.cgGroup.blocksRaycasts = false

	arg0_37:UpdateTitle(var0_37)
	arg0_37:UpdateCouponBtn()
	arg0_37:UpdateVoucherBtn()
	setActive(arg0_37.rollingCircleMaskTr, var0_37 == var0_0.MODE_OVERVIEW)

	if var0_37 == var0_0.MODE_EXPERIENCE or var0_37 == var0_0.MODE_EXPERIENCE_FOR_ITEM then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	arg0_37.skinPageID = arg0_37:GetDefaultPage(var0_37)

	parallelAsync({
		function(arg0_38)
			arg0_37:InitSkinClassify(var1_37, var0_37, arg0_38)
		end,
		function(arg0_39)
			seriesAsync({
				function(arg0_40)
					onNextTick(arg0_40)
				end,
				function(arg0_41)
					if arg0_37.exited then
						return
					end

					arg0_37:UpdateCommodities(var1_37, true, arg0_41)
				end
			}, arg0_39)
		end
	}, function()
		arg0_37.commodities = var1_37
		arg0_37.cgGroup.blocksRaycasts = true
	end)
end

function var0_0.UpdateTitle(arg0_43, arg1_43)
	local var0_43 = {
		"huanzhuangshagndian",
		"title_01",
		"title_01"
	}

	arg0_43.title.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var0_43[arg1_43])

	arg0_43.title:SetNativeSize()

	local var1_43 = {
		"huanzhuangshagndian_en",
		"title_en_01",
		"title_en_01"
	}

	arg0_43.titleEn.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var1_43[arg1_43])

	arg0_43.titleEn:SetNativeSize()
end

local function var8_0(arg0_44, arg1_44)
	local var0_44 = pg.skin_page_template
	local var1_44 = arg1_44:GetID()
	local var2_44
	local var3_44

	if var1_44 == var1_0 or var1_44 == var2_0 or var1_44 == var4_0 then
		var2_44, var3_44 = "text_all", "ALL"
	elseif var1_44 == var3_0 then
		var2_44, var3_44 = "text_fanchang", "RETURN"
	else
		var2_44, var3_44 = "text_" .. var0_44[var1_44].res, var0_44[var1_44].english_name
	end

	LoadSpriteAtlasAsync("SkinClassified", var2_44 .. "01", function(arg0_45)
		if arg0_44.exited then
			return
		end

		local var0_45 = arg1_44._tr:Find("name"):GetComponent(typeof(Image))

		var0_45.sprite = arg0_45

		var0_45:SetNativeSize()
	end)
	LoadSpriteAtlasAsync("SkinClassified", var2_44, function(arg0_46)
		if arg0_44.exited then
			return
		end

		local var0_46 = arg1_44._tr:Find("selected/Image"):GetComponent(typeof(Image))

		var0_46.sprite = arg0_46

		var0_46:SetNativeSize()
	end)
	setText(arg1_44._tr:Find("eng"), var3_44)
end

function var0_0.InitSkinClassify(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = arg0_47:GetSkinClassify(arg1_47, arg2_47)
	local var1_47 = {}

	for iter0_47, iter1_47 in ipairs(var0_47) do
		table.insert(var1_47, function(arg0_48)
			if arg0_47.exited then
				return
			end

			local var0_48 = arg0_47.rollingCircleRect:AddItem(iter1_47)

			var8_0(arg0_47, var0_48)

			if (iter0_47 - 1) % 5 == 0 or iter0_47 == #var0_47 then
				onNextTick(arg0_48)
			else
				arg0_48()
			end
		end)
	end

	seriesAsync(var1_47, function()
		if arg0_47.exited then
			return
		end

		arg0_47.rollingCircleRect:ScrollTo(arg0_47.skinPageID)
		arg3_47()
	end)
end

local function var9_0(arg0_50)
	if not var0_0.cacheSkinExperienceItems then
		var0_0.cacheSkinExperienceItems = getProxy(BagProxy):GetSkinExperienceItems()
	end

	return _.any(var0_0.cacheSkinExperienceItems, function(arg0_51)
		return arg0_51:CanUseForShop(arg0_50)
	end)
end

function var0_0.IsType(arg0_52, arg1_52, arg2_52)
	if arg2_52:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		if arg0_52.mode == var0_0.MODE_EXPERIENCE_FOR_ITEM then
			return arg1_52 == var4_0 and var9_0(arg2_52.id)
		else
			return arg1_52 == var2_0
		end
	elseif arg1_52 == var1_0 then
		return true
	elseif arg1_52 == var3_0 and arg0_52:GetReturnSkinMap()[arg2_52.id] then
		return true
	else
		local var0_52 = arg0_52:GetShopTypeIdBySkinId(arg2_52:getSkinId())

		return (var0_52 == 0 and var5_0 or var0_52) == arg1_52
	end

	return false
end

function var0_0.ToVShip(arg0_53, arg1_53)
	if not arg0_53.vship then
		arg0_53.vship = {}

		function arg0_53.vship.getNation()
			return arg0_53.vship.config.nationality
		end

		function arg0_53.vship.getShipType()
			return arg0_53.vship.config.type
		end

		function arg0_53.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_53.vship.config.type)
		end

		function arg0_53.vship.getRarity()
			return arg0_53.vship.config.rarity
		end
	end

	arg0_53.vship.config = arg1_53

	return arg0_53.vship
end

function var0_0.IsAllFilter(arg0_58, arg1_58)
	return arg1_58.typeIndex == ShipIndexConst.TypeAll and arg1_58.campIndex == ShipIndexConst.CampAll and arg1_58.rarityIndex == ShipIndexConst.RarityAll and arg1_58.extraIndex == SkinIndexLayer.ExtraALL
end

function var0_0.IsFilterType(arg0_59, arg1_59, arg2_59)
	if arg0_59:IsAllFilter(arg1_59) then
		return true
	end

	local var0_59 = arg2_59:getSkinId()
	local var1_59 = ShipSkin.New({
		id = var0_59
	})
	local var2_59 = var1_59:GetDefaultShipConfig()

	if not var2_59 then
		return false
	end

	local var3_59 = arg0_59:ToVShip(var2_59)
	local var4_59 = ShipIndexConst.filterByType(var3_59, arg1_59.typeIndex)
	local var5_59 = ShipIndexConst.filterByCamp(var3_59, arg1_59.campIndex)
	local var6_59 = ShipIndexConst.filterByRarity(var3_59, arg1_59.rarityIndex)
	local var7_59 = SkinIndexLayer.filterByExtra(var1_59, arg1_59.extraIndex)

	return var4_59 and var5_59 and var6_59 and var7_59
end

function var0_0.IsSearchType(arg0_60, arg1_60, arg2_60)
	if not arg1_60 or arg1_60 == "" then
		return true
	end

	local var0_60 = arg2_60:getSkinId()

	return ShipSkin.New({
		id = var0_60
	}):IsMatchKey(arg1_60)
end

local function var10_0(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg2_61[arg0_61.id]
	local var1_61 = arg2_61[arg1_61.id]

	if var0_61 == var1_61 then
		return arg0_61.id < arg1_61.id
	else
		return var1_61 < var0_61
	end
end

function var0_0.Sort(arg0_62, arg1_62, arg2_62, arg3_62)
	local var0_62 = arg1_62.buyCount == 0 and 1 or 0
	local var1_62 = arg2_62.buyCount == 0 and 1 or 0

	if var0_62 == var1_62 then
		local var2_62 = arg1_62:getConfig("order")
		local var3_62 = arg2_62:getConfig("order")

		if var2_62 == var3_62 then
			return var10_0(arg1_62, arg2_62, arg3_62)
		else
			return var2_62 < var3_62
		end
	else
		return var1_62 < var0_62
	end
end

function var0_0.IsCouponType(arg0_63, arg1_63, arg2_63)
	if arg1_63 and not SkinCouponActivity.GetSkinCouponAct(arg2_63.id) then
		return false
	end

	return true
end

function var0_0.IsVoucherType(arg0_64, arg1_64, arg2_64)
	if arg1_64 and not arg2_64 then
		return false
	end

	return true
end

function var0_0.UpdateCommodities(arg0_65, arg1_65, arg2_65, arg3_65)
	arg0_65:ClearCards()

	arg0_65.cards = {}
	arg0_65.displays = {}
	arg0_65.canUseVoucherCache = {}

	local var0_65 = getInputText(arg0_65.inptuTr)
	local var1_65 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0_65, iter1_65 in ipairs(arg1_65) do
		local var2_65 = iter1_65:StaticCanUseVoucherType(var1_65)

		if arg0_65:IsType(arg0_65.skinPageID, iter1_65) and arg0_65:IsFilterType(arg0_65.defaultIndex, iter1_65) and arg0_65:IsSearchType(var0_65, iter1_65) and arg0_65:IsCouponType(arg0_65.isFilterCoupon, iter1_65) and arg0_65:IsVoucherType(arg0_65.isFilterVoucher, var2_65) then
			table.insert(arg0_65.displays, iter1_65)
		end

		arg0_65.canUseVoucherCache[iter1_65.id] = var2_65
	end

	local var3_65 = {}

	for iter2_65, iter3_65 in ipairs(arg0_65.displays) do
		local var4_65 = iter3_65.type == Goods.TYPE_ACTIVITY or iter3_65.type == Goods.TYPE_ACTIVITY_EXTRA
		local var5_65 = 0

		if not var4_65 then
			var5_65 = iter3_65:GetPrice()
		end

		var3_65[iter3_65.id] = var5_65
	end

	table.sort(arg0_65.displays, function(arg0_66, arg1_66)
		return arg0_65:Sort(arg0_66, arg1_66, var3_65)
	end)

	if arg2_65 then
		arg0_65.triggerFirstCard = true

		arg0_65.scrollrect:SetTotalCount(#arg0_65.displays, 0)
	else
		arg0_65.scrollrect:SetTotalCount(#arg0_65.displays)
	end

	local var6_65 = #arg0_65.displays <= 0

	setActive(arg0_65.emptyTr, var6_65)

	if var6_65 then
		arg0_65.mainView:Flush(nil)
	end

	if arg3_65 then
		arg3_65()
	end
end

function var0_0.OnInitItem(arg0_67, arg1_67)
	local var0_67 = NewShopSkinCard.New(arg1_67)

	onButton(arg0_67, var0_67._go, function()
		if not var0_67.commodity then
			return
		end

		for iter0_68, iter1_68 in pairs(arg0_67.cards) do
			iter1_68:UpdateSelected(false)
		end

		arg0_67.selectedId = var0_67.commodity.id

		var0_67:UpdateSelected(true)
		arg0_67:UpdateMainView(var0_67.commodity)
		arg0_67:GCHandle()
	end, SFX_PANEL)

	arg0_67.cards[arg1_67] = var0_67
end

function var0_0.OnUpdateItem(arg0_69, arg1_69, arg2_69)
	local var0_69 = arg0_69.cards[arg2_69]

	if not var0_69 then
		arg0_69:OnInitItem(arg2_69)

		var0_69 = arg0_69.cards[arg2_69]
	end

	local var1_69 = arg0_69.displays[arg1_69 + 1]

	if not var1_69 then
		return
	end

	local var2_69 = arg0_69.selectedId == var1_69.id
	local var3_69 = arg0_69:GetReturnSkinMap()[var1_69.id]

	var0_69:Update(var1_69, var2_69, var3_69)

	if arg0_69.triggerFirstCard and arg1_69 == 0 then
		arg0_69.triggerFirstCard = nil

		triggerButton(var0_69._go)
	end
end

function var0_0.GCHandle(arg0_70)
	var0_0.GCCNT = (var0_0.GCCNT or 0) + 1

	if var0_0.GCCNT == 3 then
		gcAll()

		var0_0.GCCNT = 0
	end
end

function var0_0.UpdateMainView(arg0_71, arg1_71)
	arg0_71.mainView:Flush(arg1_71)
end

function var0_0.GetCommodityIndex(arg0_72, arg1_72)
	for iter0_72, iter1_72 in ipairs(arg0_72.displays) do
		if iter1_72.id == arg1_72 then
			return iter0_72
		end
	end
end

function var0_0.OnPrevCommodity(arg0_73)
	if not arg0_73.selectedId then
		return
	end

	local var0_73 = arg0_73:GetCommodityIndex(arg0_73.selectedId)

	if var0_73 - 1 > 0 then
		arg0_73:TriggerCommodity(var0_73, -1)
	end
end

function var0_0.OnNextCommodity(arg0_74)
	if not arg0_74.selectedId then
		return
	end

	local var0_74 = arg0_74:GetCommodityIndex(arg0_74.selectedId)

	if var0_74 + 1 <= #arg0_74.displays then
		arg0_74:TriggerCommodity(var0_74, 1)
	end
end

function var0_0.CheckCardBound(arg0_75, arg1_75, arg2_75, arg3_75, arg4_75)
	local var0_75 = getBounds(arg0_75.scrollrect.gameObject.transform)

	if arg3_75 then
		local var1_75 = getBounds(arg2_75._tf)
		local var2_75 = getBounds(arg1_75._tf)

		if math.ceil(var2_75:GetMax().x - var0_75:GetMax().x) > var1_75.size.x then
			local var3_75 = arg0_75.scrollrect:HeadIndexToValue(arg4_75 - 1) - arg0_75.scrollrect:HeadIndexToValue(arg4_75)
			local var4_75 = arg0_75.scrollrect.value - var3_75

			arg0_75.scrollrect:SetNormalizedPosition(var4_75, 0)
		end
	else
		local var5_75 = getBounds(arg1_75._tf)

		if getBounds(arg1_75._tf.parent):GetMin().x < var0_75:GetMin().x and var5_75:GetMin().x < var0_75:GetMin().x then
			local var6_75 = arg0_75.scrollrect:HeadIndexToValue(arg4_75 - 1)

			arg0_75.scrollrect:SetNormalizedPosition(var6_75, 0)
		end
	end
end

function var0_0.TriggerCommodity(arg0_76, arg1_76, arg2_76)
	local var0_76 = arg0_76.displays[arg1_76]
	local var1_76 = arg0_76.displays[arg1_76 + arg2_76]
	local var2_76
	local var3_76

	for iter0_76, iter1_76 in pairs(arg0_76.cards) do
		if iter1_76._tf.gameObject.name ~= "-1" then
			if iter1_76.commodity.id == var1_76.id then
				var2_76 = iter1_76
			elseif iter1_76.commodity.id == var0_76.id then
				var3_76 = iter1_76
			end
		end
	end

	if var2_76 then
		triggerButton(var2_76._tf)
	end

	if var2_76 and var3_76 then
		arg0_76:CheckCardBound(var2_76, var3_76, arg2_76 > 0, arg1_76 + arg2_76)
	end
end

function var0_0.ClearCards(arg0_77)
	if not arg0_77.cards then
		return
	end

	for iter0_77, iter1_77 in pairs(arg0_77.cards) do
		iter1_77:Dispose()
	end

	arg0_77.cards = nil
end

function var0_0.willExit(arg0_78)
	arg0_78:ClearCards()
	ClearLScrollrect(arg0_78.scrollrect)

	if arg0_78.rollingCircleRect then
		arg0_78.rollingCircleRect:Dispose()

		arg0_78.rollingCircleRect = nil
	end

	Input.multiTouchEnabled = true

	if arg0_78.mainView then
		arg0_78.mainView:Dispose()

		arg0_78.mainView = nil
	end

	var0_0.shopTypeIdList = nil
	var0_0.cacheSkinExperienceItems = nil
end

return var0_0

local var0 = class("NewSkinShopScene", import("view.base.BaseUI"))

var0.MODE_OVERVIEW = 1
var0.MODE_EXPERIENCE = 2

local var1 = -1
local var2 = -2
local var3 = -3
local var4 = 9999
local var5 = 9997
local var6 = 9998

var0.PAGE_ALL = var1
var0.optionsPath = {
	"overlay/blur_panel/adapt/top/option"
}

function var0.getUIName(arg0)
	return "NewSkinShopUI"
end

function var0.forceGC(arg0)
	return true
end

function var0.ResUISettings(arg0)
	return {
		anim = true,
		showType = PlayerResUI.TYPE_GEM
	}
end

function var0.GetAllCommodity(arg0)
	return (getProxy(ShipSkinProxy):GetAllSkins())
end

function var0.GetPlayer(arg0)
	return (getProxy(PlayerProxy):getRawData())
end

function var0.GetShopTypeIdBySkinId(arg0, arg1)
	local var0 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not var0.shopTypeIdList then
		var0.shopTypeIdList = {}
	end

	if var0.shopTypeIdList[arg1] then
		return var0.shopTypeIdList[arg1]
	end

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in ipairs(iter1) do
			var0.shopTypeIdList[iter3] = iter0

			if iter3 == arg1 then
				return iter0
			end
		end
	end
end

function var0.GetSkinClassify(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var2 = arg0:GetShopTypeIdBySkinId(iter1:getSkinId())
		local var3 = var2 == 0 and var4 or var2

		var1[var3] = (var1[var3] or 0) + 1
	end

	if #arg0:GetReturnSkins() > 0 then
		table.insert(var0, var3)
	end

	for iter2, iter3 in ipairs(pg.skin_page_template.all) do
		if iter3 ~= var5 and iter3 ~= var6 and (var1[iter3] or 0) > 0 then
			table.insert(var0, iter3)
		end
	end

	if arg2 == var0.MODE_EXPERIENCE then
		table.insert(var0, 1, var2)
	end

	table.insert(var0, 1, var1)

	return var0
end

function var0.GetReturnSkins(arg0)
	if not arg0.returnSkins then
		arg0.returnSkins = getProxy(ShipSkinProxy):GetEncoreSkins()
	end

	return arg0.returnSkins
end

function var0.GetReturnSkinMap(arg0)
	if not arg0.encoreSkinMap then
		arg0.encoreSkinMap = {}

		local var0 = arg0:GetReturnSkins()

		for iter0, iter1 in ipairs(var0) do
			arg0.encoreSkinMap[iter1] = true
		end
	end

	return arg0.encoreSkinMap
end

function var0.OnFurnitureUpdate(arg0, arg1)
	if not arg0.mainView.commodity then
		return
	end

	local var0 = arg0.mainView.commodity.id

	if Goods.ExistFurniture(var0) and Goods.Id2FurnitureId(var0) == arg1 then
		arg0.mainView:Flush(arg0.mainView.commodity)
	end
end

function var0.OnShopping(arg0, arg1)
	if not arg0.mainView.commodity then
		return
	end

	arg0.mainView:ClosePurchaseView()

	if arg0.mainView.commodity.id == arg1 then
		local var0 = arg0:GetAllCommodity()
		local var1 = _.detect(var0, function(arg0)
			return arg0.id == arg1
		end)

		if var1 then
			arg0.mainView:Flush(var1)
		end

		arg0:UpdateCouponBtn()
		arg0:UpdateVoucherBtn()
		arg0:UpdateCommodities(var0, false)

		arg0.commodities = var0
	end
end

function var0.init(arg0)
	arg0.cgGroup = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.backBtn = arg0:findTF("overlay/blur_panel/adapt/top/back_btn")
	arg0.atlasBtn = arg0:findTF("overlay/bottom/bg/atlas")
	arg0.prevBtn = arg0:findTF("overlay/bottom/bg/left_arr")
	arg0.nextBtn = arg0:findTF("overlay/bottom/bg/right_arr")
	arg0.live2dFilter = arg0:findTF("overlay/blur_panel/adapt/top/live2d")
	arg0.live2dFilterSel = arg0.live2dFilter:Find("selected")
	arg0.indexBtn = arg0:findTF("overlay/blur_panel/adapt/top/index_btn")
	arg0.indexBtnSel = arg0.indexBtn:Find("sel")
	arg0.inptuTr = arg0:findTF("overlay/blur_panel/adapt/top/search")
	arg0.changeBtn = arg0:findTF("overlay/blur_panel/adapt/top/change_btn")

	setText(arg0.inptuTr:Find("holder"), i18n("skinatlas_search_holder"))

	arg0.couponTr = arg0:findTF("overlay/blur_panel/adapt/top/discount/coupon")
	arg0.couponSelTr = arg0.couponTr:Find("selected")
	arg0.voucherTr = arg0:findTF("overlay/blur_panel/adapt/top/discount/voucher")
	arg0.voucherSelTr = arg0.voucherTr:Find("selected")
	arg0.rollingCircleRect = RollingCircleRect.New(arg0:findTF("overlay/left/mask/content/0"), arg0:findTF("overlay/left"))

	arg0.rollingCircleRect:SetCallback(arg0, var0.OnSelectSkinPage, var0.OnConfirmSkinPage)

	arg0.rollingCircleMaskTr = arg0:findTF("overlay/left")
	arg0.mainView = NewSkinShopMainView.New(arg0._tf, arg0.event)
	arg0.title = arg0:findTF("overlay/blur_panel/adapt/top/title"):GetComponent(typeof(Image))
	arg0.titleEn = arg0:findTF("overlay/blur_panel/adapt/top/title_en"):GetComponent(typeof(Image))
	arg0.scrollrect = arg0:findTF("overlay/bottom/scroll"):GetComponent("LScrollRect")
	arg0.scrollrect.isNewLoadingMethod = true

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0.emptyTr = arg0:findTF("bgs/empty")
	arg0.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinIndexLayer.ExtraALL
	}
	Input.multiTouchEnabled = false
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.atlasBtn, function()
		arg0:emit(NewSkinShopMediator.ON_ATLAS)
	end, SFX_PANEL)
	onButton(arg0, arg0.prevBtn, function()
		arg0:OnPrevCommodity()
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		arg0:OnNextCommodity()
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		arg0:emit(NewSkinShopMediator.ON_INDEX, {
			OnFilter = function(arg0)
				arg0:OnFilter(arg0)
			end,
			defaultIndex = arg0.defaultIndex
		})
	end, SFX_PANEL)
	onInputChanged(arg0, arg0.inptuTr, function()
		arg0:OnSearch()
	end)
	onToggle(arg0, arg0.changeBtn, function(arg0)
		if arg0 and getInputText(arg0.inptuTr) ~= "" then
			setInputText(arg0.inptuTr, "")
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.live2dFilter, function()
		arg0.defaultIndex.extraIndex = arg0.defaultIndex.extraIndex == SkinIndexLayer.ExtraL2D and SkinIndexLayer.ExtraALL or SkinIndexLayer.ExtraL2D

		arg0:OnFilter(arg0.defaultIndex)
	end, SFX_PANEL)

	arg0.isFilterCoupon = false

	onButton(arg0, arg0.couponTr, function()
		if not SkinCouponActivity.StaticExistActivityAndCoupon() then
			arg0.isFilterCoupon = false

			arg0:UpdateCouponBtn()
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0.isFilterCoupon = not arg0.isFilterCoupon

		setActive(arg0.couponSelTr, arg0.isFilterCoupon)
		arg0:OnFilter(arg0.defaultIndex)
	end, SFX_PANEL)

	arg0.isFilterVoucher = false

	onButton(arg0, arg0.voucherTr, function()
		arg0.isFilterVoucher = not arg0.isFilterVoucher

		setActive(arg0.voucherSelTr, arg0.isFilterVoucher)
		arg0:OnFilter(arg0.defaultIndex)
	end, SFX_PANEL)
	arg0:SetUp()
end

function var0.UpdateCouponBtn(arg0)
	local var0 = SkinCouponActivity.StaticExistActivityAndCoupon() and (not arg0.contextData.mode or arg0.contextData.mode == var0.MODE_OVERVIEW)

	if arg0.isFilterCoupon and not var0 then
		arg0.isFilterCoupon = false
	end

	arg0.couponTr.localScale = var0 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0.UpdateVoucherBtn(arg0)
	local var0 = #getProxy(BagProxy):GetSkinShopDiscountItemList() > 0 and (not arg0.contextData.mode or arg0.contextData.mode == var0.MODE_OVERVIEW)

	if arg0.isFilterVoucher and not var0 then
		arg0.isFilterVoucher = false
	end

	arg0.voucherTr.localScale = var0 and Vector3(1, 1, 1) or Vector3(0, 0, 0)
end

function var0.OnSelectSkinPage(arg0, arg1)
	if arg0.selectedSkinPageItem then
		setActive(arg0.selectedSkinPageItem._tr:Find("selected"), false)
		setActive(arg0.selectedSkinPageItem._tr:Find("name"), true)
	end

	setActive(arg1._tr:Find("selected"), true)
	setActive(arg1._tr:Find("name"), false)

	arg0.selectedSkinPageItem = arg1
end

function var0.OnConfirmSkinPage(arg0, arg1)
	local var0 = arg1:GetID()

	if arg0.skinPageID ~= var0 then
		arg0.skinPageID = var0

		if arg0.commodities then
			arg0:UpdateCommodities(arg0.commodities, true)
		end
	end
end

function var0.OnFilter(arg0, arg1)
	arg0.defaultIndex = {
		typeIndex = arg1.typeIndex,
		campIndex = arg1.campIndex,
		rarityIndex = arg1.rarityIndex,
		extraIndex = arg1.extraIndex
	}

	setActive(arg0.live2dFilterSel, arg1.extraIndex == SkinIndexLayer.ExtraL2D)

	if arg0.commodities then
		arg0:UpdateCommodities(arg0.commodities, true)
	end

	setActive(arg0.indexBtnSel, arg1.typeIndex ~= ShipIndexConst.TypeAll or arg1.campIndex ~= ShipIndexConst.CampAll or arg1.rarityIndex ~= ShipIndexConst.RarityAll or arg1.extraIndex ~= SkinIndexLayer.ExtraALL)
end

function var0.OnSearch(arg0)
	if arg0.commodities then
		arg0:UpdateCommodities(arg0.commodities, true)
	end
end

function var0.SetUp(arg0)
	local var0 = arg0.contextData.mode or var0.MODE_OVERVIEW
	local var1 = arg0:GetAllCommodity()

	arg0.cgGroup.blocksRaycasts = false

	arg0:UpdateTitle(var0)
	arg0:UpdateCouponBtn()
	arg0:UpdateVoucherBtn()
	setActive(arg0.rollingCircleMaskTr, var0 == var0.MODE_OVERVIEW)

	if var0 == var0.MODE_EXPERIENCE then
		getProxy(SettingsProxy):SetNextTipTimeLimitSkinShop()
	end

	arg0.skinPageID = var0 == var0.MODE_EXPERIENCE and var2 or var1

	parallelAsync({
		function(arg0)
			arg0:InitSkinClassify(var1, var0, arg0)
		end,
		function(arg0)
			seriesAsync({
				function(arg0)
					onNextTick(arg0)
				end,
				function(arg0)
					if arg0.exited then
						return
					end

					arg0:UpdateCommodities(var1, true, arg0)
				end
			}, arg0)
		end
	}, function()
		arg0.commodities = var1
		arg0.cgGroup.blocksRaycasts = true
	end)
end

function var0.UpdateTitle(arg0, arg1)
	local var0 = {
		"huanzhuangshagndian",
		"title_01"
	}

	arg0.title.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var0[arg1])

	arg0.title:SetNativeSize()

	local var1 = {
		"huanzhuangshagndian_en",
		"title_en_01"
	}

	arg0.titleEn.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", var1[arg1])

	arg0.titleEn:SetNativeSize()
end

local function var7(arg0, arg1)
	local var0 = pg.skin_page_template
	local var1 = arg1:GetID()
	local var2
	local var3

	if var1 == var1 or var1 == var2 then
		var2, var3 = "text_all", "ALL"
	elseif var1 == var3 then
		var2, var3 = "text_fanchang", "RETURN"
	else
		var2, var3 = "text_" .. var0[var1].res, var0[var1].english_name
	end

	LoadSpriteAtlasAsync("SkinClassified", var2 .. "01", function(arg0)
		if arg0.exited then
			return
		end

		local var0 = arg1._tr:Find("name"):GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()
	end)
	LoadSpriteAtlasAsync("SkinClassified", var2, function(arg0)
		if arg0.exited then
			return
		end

		local var0 = arg1._tr:Find("selected/Image"):GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()
	end)
	setText(arg1._tr:Find("eng"), var3)
end

function var0.InitSkinClassify(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetSkinClassify(arg1, arg2)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = arg0.rollingCircleRect:AddItem(iter1)

			var7(arg0, var0)

			if (iter0 - 1) % 5 == 0 or iter0 == #var0 then
				onNextTick(arg0)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var1, function()
		if arg0.exited then
			return
		end

		arg0.rollingCircleRect:ScrollTo(arg0.skinPageID)
		arg3()
	end)
end

function var0.IsType(arg0, arg1, arg2)
	if arg2:getConfig("genre") == ShopArgs.SkinShopTimeLimit then
		return arg1 == var2
	elseif arg1 == var1 then
		return true
	elseif arg1 == var3 and arg0:GetReturnSkinMap()[arg2.id] then
		return true
	else
		local var0 = arg0:GetShopTypeIdBySkinId(arg2:getSkinId())

		return (var0 == 0 and var4 or var0) == arg1
	end

	return false
end

function var0.ToVShip(arg0, arg1)
	if not arg0.vship then
		arg0.vship = {}

		function arg0.vship.getNation()
			return arg0.vship.config.nationality
		end

		function arg0.vship.getShipType()
			return arg0.vship.config.type
		end

		function arg0.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0.vship.config.type)
		end

		function arg0.vship.getRarity()
			return arg0.vship.config.rarity
		end
	end

	arg0.vship.config = arg1

	return arg0.vship
end

function var0.IsAllFilter(arg0, arg1)
	return arg1.typeIndex == ShipIndexConst.TypeAll and arg1.campIndex == ShipIndexConst.CampAll and arg1.rarityIndex == ShipIndexConst.RarityAll and arg1.extraIndex == SkinIndexLayer.ExtraALL
end

function var0.IsFilterType(arg0, arg1, arg2)
	if arg0:IsAllFilter(arg1) then
		return true
	end

	local var0 = arg2:getSkinId()
	local var1 = ShipSkin.New({
		id = var0
	})
	local var2 = var1:GetDefaultShipConfig()

	if not var2 then
		return false
	end

	local var3 = arg0:ToVShip(var2)
	local var4 = ShipIndexConst.filterByType(var3, arg1.typeIndex)
	local var5 = ShipIndexConst.filterByCamp(var3, arg1.campIndex)
	local var6 = ShipIndexConst.filterByRarity(var3, arg1.rarityIndex)
	local var7 = SkinIndexLayer.filterByExtra(var1, arg1.extraIndex)

	return var4 and var5 and var6 and var7
end

function var0.IsSearchType(arg0, arg1, arg2)
	if not arg1 or arg1 == "" then
		return true
	end

	local var0 = arg2:getSkinId()

	return ShipSkin.New({
		id = var0
	}):IsMatchKey(arg1)
end

local function var8(arg0, arg1, arg2)
	local var0 = arg2[arg0.id]
	local var1 = arg2[arg1.id]

	if var0 == var1 then
		return arg0.id < arg1.id
	else
		return var1 < var0
	end
end

function var0.Sort(arg0, arg1, arg2, arg3)
	local var0 = arg1.buyCount == 0 and 1 or 0
	local var1 = arg2.buyCount == 0 and 1 or 0

	if var0 == var1 then
		local var2 = arg1:getConfig("order")
		local var3 = arg2:getConfig("order")

		if var2 == var3 then
			return var8(arg1, arg2, arg3)
		else
			return var2 < var3
		end
	else
		return var1 < var0
	end
end

function var0.IsCouponType(arg0, arg1, arg2)
	if arg1 and not SkinCouponActivity.StaticIsShop(arg2.id) then
		return false
	end

	return true
end

function var0.IsVoucherType(arg0, arg1, arg2)
	if arg1 and not arg2 then
		return false
	end

	return true
end

function var0.UpdateCommodities(arg0, arg1, arg2, arg3)
	arg0:ClearCards()

	arg0.cards = {}
	arg0.displays = {}
	arg0.canUseVoucherCache = {}

	local var0 = getInputText(arg0.inptuTr)
	local var1 = getProxy(BagProxy):GetSkinShopDiscountItemList()

	for iter0, iter1 in ipairs(arg1) do
		local var2 = iter1:StaticCanUseVoucherType(var1)

		if arg0:IsType(arg0.skinPageID, iter1) and arg0:IsFilterType(arg0.defaultIndex, iter1) and arg0:IsSearchType(var0, iter1) and arg0:IsCouponType(arg0.isFilterCoupon, iter1) and arg0:IsVoucherType(arg0.isFilterVoucher, var2) then
			table.insert(arg0.displays, iter1)
		end

		arg0.canUseVoucherCache[iter1.id] = var2
	end

	local var3 = {}

	for iter2, iter3 in ipairs(arg0.displays) do
		local var4 = iter3.type == Goods.TYPE_ACTIVITY or iter3.type == Goods.TYPE_ACTIVITY_EXTRA
		local var5 = 0

		if not var4 then
			var5 = iter3:GetPrice()
		end

		var3[iter3.id] = var5
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return arg0:Sort(arg0, arg1, var3)
	end)

	if arg2 then
		arg0.triggerFirstCard = true

		arg0.scrollrect:SetTotalCount(#arg0.displays, 0)
	else
		arg0.scrollrect:SetTotalCount(#arg0.displays)
	end

	local var6 = #arg0.displays <= 0

	setActive(arg0.emptyTr, var6)

	if var6 then
		arg0.mainView:Flush(nil)
	end

	if arg3 then
		arg3()
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = NewShopSkinCard.New(arg1)

	onButton(arg0, var0._go, function()
		if not var0.commodity then
			return
		end

		for iter0, iter1 in pairs(arg0.cards) do
			iter1:UpdateSelected(false)
		end

		arg0.selectedId = var0.commodity.id

		var0:UpdateSelected(true)
		arg0:UpdateMainView(var0.commodity)
		arg0:GCHandle()
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	if not var1 then
		return
	end

	local var2 = arg0.selectedId == var1.id
	local var3 = arg0:GetReturnSkinMap()[var1.id]

	var0:Update(var1, var2, var3)

	if arg0.triggerFirstCard and arg1 == 0 then
		arg0.triggerFirstCard = nil

		triggerButton(var0._go)
	end
end

function var0.GCHandle(arg0)
	var0.GCCNT = (var0.GCCNT or 0) + 1

	if var0.GCCNT == 3 then
		gcAll()

		var0.GCCNT = 0
	end
end

function var0.UpdateMainView(arg0, arg1)
	arg0.mainView:Flush(arg1)
end

function var0.GetCommodityIndex(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1.id == arg1 then
			return iter0
		end
	end
end

function var0.OnPrevCommodity(arg0)
	if not arg0.selectedId then
		return
	end

	local var0 = arg0:GetCommodityIndex(arg0.selectedId)

	if var0 - 1 > 0 then
		arg0:TriggerCommodity(var0, -1)
	end
end

function var0.OnNextCommodity(arg0)
	if not arg0.selectedId then
		return
	end

	local var0 = arg0:GetCommodityIndex(arg0.selectedId)

	if var0 + 1 <= #arg0.displays then
		arg0:TriggerCommodity(var0, 1)
	end
end

function var0.CheckCardBound(arg0, arg1, arg2, arg3, arg4)
	local var0 = getBounds(arg0.scrollrect.gameObject.transform)

	if arg3 then
		local var1 = getBounds(arg2._tf)
		local var2 = getBounds(arg1._tf)

		if math.ceil(var2:GetMax().x - var0:GetMax().x) > var1.size.x then
			local var3 = arg0.scrollrect:HeadIndexToValue(arg4 - 1) - arg0.scrollrect:HeadIndexToValue(arg4)
			local var4 = arg0.scrollrect.value - var3

			arg0.scrollrect:SetNormalizedPosition(var4, 0)
		end
	else
		local var5 = getBounds(arg1._tf)

		if getBounds(arg1._tf.parent):GetMin().x < var0:GetMin().x and var5:GetMin().x < var0:GetMin().x then
			local var6 = arg0.scrollrect:HeadIndexToValue(arg4 - 1)

			arg0.scrollrect:SetNormalizedPosition(var6, 0)
		end
	end
end

function var0.TriggerCommodity(arg0, arg1, arg2)
	local var0 = arg0.displays[arg1]
	local var1 = arg0.displays[arg1 + arg2]
	local var2
	local var3

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1._tf.gameObject.name ~= "-1" then
			if iter1.commodity.id == var1.id then
				var2 = iter1
			elseif iter1.commodity.id == var0.id then
				var3 = iter1
			end
		end
	end

	if var2 then
		triggerButton(var2._tf)
	end

	if var2 and var3 then
		arg0:CheckCardBound(var2, var3, arg2 > 0, arg1 + arg2)
	end
end

function var0.ClearCards(arg0)
	if not arg0.cards then
		return
	end

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil
end

function var0.willExit(arg0)
	arg0:ClearCards()
	ClearLScrollrect(arg0.scrollrect)

	if arg0.rollingCircleRect then
		arg0.rollingCircleRect:Dispose()

		arg0.rollingCircleRect = nil
	end

	Input.multiTouchEnabled = true

	if arg0.mainView then
		arg0.mainView:Dispose()

		arg0.mainView = nil
	end

	var0.shopTypeIdList = nil
end

return var0

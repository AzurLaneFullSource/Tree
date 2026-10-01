local var0_0 = class("NewBackYardThemeTemplateLayer", import("...base.BaseUI"))

local function var1_0(arg0_1, arg1_1, arg2_1)
	local function var0_1(arg0_2, arg1_2)
		setActive(arg0_2:Find("sel"), arg1_2)
		setActive(arg0_2:Find("unsel"), not arg1_2)
	end

	onButton(arg0_1, arg1_1, function()
		if not arg2_1() then
			return
		end

		if arg0_1.btn then
			var0_1(arg0_1.btn, false)
		end

		var0_1(arg1_1, true)

		arg0_1.btn = arg1_1
	end, SFX_PANEL)
	var0_1(arg1_1, false)
end

function var0_0.forceGC(arg0_4)
	return true
end

function var0_0.getUIName(arg0_5)
	return "NewBackYardTemplateUI"
end

function var0_0.getResource(arg0_6)
	local var0_6 = var0_0.super.getResource(arg0_6)

	table.insert(var0_6, "ui/BackYardMsgBox")

	return var0_6
end

function var0_0.preload(arg0_7, arg1_7)
	_backYardThemeTemplateMsgbox = BackyardMsgBoxMgr.New()

	_backYardThemeTemplateMsgbox:Init(arg0_7, arg1_7)
end

function var0_0.init(arg0_8)
	arg0_8.tpl = arg0_8._tf:Find("adpter/tag/list/tpl")
	arg0_8.container = arg0_8._tf:Find("adpter/tag/list")
	arg0_8.pageContainer = arg0_8._tf:Find("pages")
	arg0_8.backBtn = arg0_8._tf:Find("adpter/top/fanhui")
	arg0_8.homeBtn = arg0_8._tf:Find("adpter/top/help")
	arg0_8.goldTxt = arg0_8._tf:Find("adpter/top/res_gold/Text"):GetComponent(typeof(Text))
	arg0_8.gemTxt = arg0_8._tf:Find("adpter/top/res_gem/Text"):GetComponent(typeof(Text))
	arg0_8.gemAddBtn = arg0_8._tf:Find("adpter/top/res_gem/jiahao")
	arg0_8.goldAddBtn = arg0_8._tf:Find("adpter/top/res_gold/jiahao")
	arg0_8.tags = {
		[BackYardConst.THEME_TEMPLATE_TYPE_SHOP] = i18n("backyard_theme_shop_title"),
		[BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM] = i18n("backyard_theme_mine_title"),
		[BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION] = i18n("backyard_theme_collection_title")
	}
	arg0_8.listPage = BackYardThemeTemplateListPage.New(arg0_8.pageContainer, arg0_8.event, arg0_8.contextData)
	arg0_8.contextData.msgBox = BackYardThemeTemplateMsgBox.New(arg0_8._tf, arg0_8.event, arg0_8.contextData)
end

function var0_0.SetShopThemeTemplate(arg0_9, arg1_9)
	arg0_9.shopThemeTemplate = arg1_9
end

function var0_0.ShopThemeTemplateUpdate(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.shopThemeTemplate) do
		if iter1_10.id == arg1_10.id then
			arg0_10.shopThemeTemplate[iter0_10] = arg1_10

			break
		end
	end

	if arg0_10.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_10.listPage:ExecuteAction("ThemeTemplateUpdate", arg1_10)
	end
end

function var0_0.OnShopTemplatesUpdated(arg0_11, arg1_11)
	arg0_11:SetShopThemeTemplate(arg1_11)

	if arg0_11.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_11 = arg0_11:GetDataForType(arg0_11.pageType)

		arg0_11.listPage:ExecuteAction("ThemeTemplatesUpdate", var0_11)
	end
end

function var0_0.OnShopTemplatesErro(arg0_12)
	if arg0_12.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_12 = arg0_12:GetDataForType(arg0_12.pageType)

		arg0_12.listPage:ExecuteAction("ThemeTemplatesErro", var0_12)
	end
end

function var0_0.SetCustomThemeTemplate(arg0_13, arg1_13)
	arg0_13.customThemeTemplate = arg1_13
end

function var0_0.CustomThemeTemplateUpdate(arg0_14, arg1_14)
	for iter0_14, iter1_14 in pairs(arg0_14.customThemeTemplate) do
		if iter1_14.id == arg1_14.id then
			arg0_14.customThemeTemplate[iter0_14] = arg1_14

			break
		end
	end

	if arg0_14.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		arg0_14.listPage:ExecuteAction("ThemeTemplateUpdate", arg1_14)
	end
end

function var0_0.SetCollectionThemeTemplate(arg0_15, arg1_15)
	arg0_15.collectionThemeTemplate = arg1_15
end

function var0_0.CollectionThemeTemplateUpdate(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.collectionThemeTemplate) do
		if iter1_16.id == arg1_16.id then
			arg0_16.collectionThemeTemplate[iter0_16] = arg1_16

			break
		end
	end

	if arg0_16.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_16.listPage:ExecuteAction("ThemeTemplateUpdate", arg1_16)
	end
end

function var0_0.SetDorm(arg0_17, arg1_17)
	arg0_17.dorm = arg1_17
end

function var0_0.UpdateDorm(arg0_18, arg1_18)
	arg0_18:SetDorm(arg1_18)

	if arg0_18.pageType then
		arg0_18.listPage:ExecuteAction("UpdateDorm", arg1_18)
	end
end

function var0_0.SetPlayer(arg0_19, arg1_19)
	arg0_19.player = arg1_19
end

function var0_0.PlayerUpdated(arg0_20, arg1_20)
	arg0_20:SetPlayer(arg1_20)
	arg0_20:UpdateRes()

	if arg0_20.pageType then
		arg0_20.listPage:ExecuteAction("PlayerUpdated", arg1_20)
	end
end

function var0_0.FurnituresUpdated(arg0_21, arg1_21)
	if arg0_21.pageType then
		arg0_21.listPage:ExecuteAction("FurnituresUpdated", arg1_21)
	end
end

function var0_0.SearchKeyChange(arg0_22, arg1_22)
	if arg0_22.pageType and (arg0_22.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM or arg0_22.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION) then
		arg0_22.listPage:ExecuteAction("SearchKeyChange", arg1_22)
	end
end

function var0_0.ShopSearchKeyChange(arg0_23, arg1_23)
	if arg0_23.pageType and arg0_23.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_23.listPage:ExecuteAction("ShopSearchKeyChange", arg1_23)
	end
end

function var0_0.ClearShopSearchKey(arg0_24)
	if arg0_24.pageType and arg0_24.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_24.listPage:ExecuteAction("ClearShopSearchKey")
	end
end

function var0_0.DeleteCustomThemeTemplate(arg0_25, arg1_25)
	if not arg0_25.customThemeTemplate then
		return
	end

	for iter0_25, iter1_25 in pairs(arg0_25.customThemeTemplate) do
		if iter1_25.id == arg1_25 then
			arg0_25.customThemeTemplate[iter0_25] = nil

			break
		end
	end

	if arg0_25.pageType and arg0_25.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		arg0_25.listPage:ExecuteAction("DeleteCustomThemeTemplate", arg1_25)
	end
end

function var0_0.DeleteCollectionThemeTemplate(arg0_26, arg1_26)
	if not arg0_26.collectionThemeTemplate then
		return
	end

	for iter0_26, iter1_26 in pairs(arg0_26.collectionThemeTemplate) do
		if iter1_26.id == arg1_26 then
			arg0_26.collectionThemeTemplate[iter0_26] = nil

			break
		end
	end

	if arg0_26.pageType and arg0_26.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_26.listPage:ExecuteAction("DeleteCollectionThemeTemplate", arg1_26)
	end
end

function var0_0.DeleteShopThemeTemplate(arg0_27, arg1_27)
	if not arg0_27.shopThemeTemplate then
		return
	end

	for iter0_27, iter1_27 in pairs(arg0_27.shopThemeTemplate) do
		if iter1_27.id == arg1_27 then
			arg0_27.shopThemeTemplate[iter0_27] = nil

			break
		end
	end

	if arg0_27.pageType and arg0_27.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_27.listPage:ExecuteAction("DeleteShopThemeTemplate", arg1_27)
	end
end

function var0_0.AddCollectionThemeTemplate(arg0_28, arg1_28)
	arg0_28.collectionThemeTemplate[arg1_28.id] = arg1_28

	if arg0_28.pageType and arg0_28.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_28.listPage:ExecuteAction("AddCollectionThemeTemplate", arg1_28.id)
	end
end

function var0_0.didEnter(arg0_29)
	onButton(arg0_29, arg0_29.backBtn, function()
		arg0_29:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_29, arg0_29.homeBtn, function()
		arg0_29:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.gemAddBtn, function()
		arg0_29:emit(NewBackYardThemeTemplateMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.goldAddBtn, function()
		arg0_29:emit(NewBackYardThemeTemplateMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	seriesAsync({
		function(arg0_34)
			arg0_29:emit(NewBackYardThemeTemplateMediator.FETCH_ALL_THEME, arg0_34)
		end
	}, function()
		arg0_29:InitPages()
		arg0_29:UpdateRes()
		arg0_29:ActiveDefaultPage()
	end)
end

function var0_0.InitPages(arg0_36)
	arg0_36.btns = {}

	for iter0_36, iter1_36 in pairs(arg0_36.tags) do
		local var0_36 = cloneTplTo(arg0_36.tpl, arg0_36.container)
		local var1_36 = var0_36:Find("unsel"):GetComponent(typeof(Image))

		var1_36.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tp_" .. iter0_36)

		var1_36:SetNativeSize()

		local var2_36 = var0_36:Find("sel/Text"):GetComponent(typeof(Image))

		var2_36.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tp_" .. iter0_36)

		var2_36:SetNativeSize()
		setActive(var0_36:Find("line"), iter0_36 ~= BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION)
		var1_0(arg0_36, var0_36, function()
			local var0_37 = arg0_36:GetDataForType(iter0_36)

			arg0_36.listPage:ExecuteAction("SetUp", iter0_36, var0_37, arg0_36.dorm, arg0_36.player)

			arg0_36.pageType = iter0_36

			return true
		end)

		arg0_36.btns[iter0_36] = var0_36
	end

	setActive(arg0_36.tpl, false)
end

function var0_0.ActiveDefaultPage(arg0_38)
	local var0_38 = arg0_38.contextData.page or BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM

	triggerButton(arg0_38.btns[var0_38])
end

function var0_0.GetDataForType(arg0_39, arg1_39)
	if arg1_39 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_39 = {}

		for iter0_39, iter1_39 in pairs(arg0_39.shopThemeTemplate) do
			table.insert(var0_39, iter1_39)
		end

		return var0_39 or {}
	elseif arg1_39 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var1_39 = {}

		for iter2_39, iter3_39 in pairs(arg0_39.customThemeTemplate) do
			if iter3_39:CanDispaly() then
				table.insert(var1_39, iter3_39)
			end
		end

		return var1_39
	elseif arg1_39 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		local var2_39 = {}

		for iter4_39, iter5_39 in pairs(arg0_39.collectionThemeTemplate) do
			table.insert(var2_39, iter5_39)
		end

		return var2_39 or {}
	end

	assert(false)
end

function var0_0.UpdateRes(arg0_40)
	arg0_40.goldTxt.text = arg0_40.player:getResource(PlayerConst.ResDormMoney)
	arg0_40.gemTxt.text = arg0_40.player:getTotalGem()
end

function var0_0.willExit(arg0_41)
	_backYardThemeTemplateMsgbox:Destroy()

	_backYardThemeTemplateMsgbox = nil

	arg0_41.listPage:Destroy()
	arg0_41.contextData.msgBox:Destroy()
	BackYardThemeTempalteUtil.ClearAllCache()
end

return var0_0

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

function var0_0.preload(arg0_6, arg1_6)
	_backYardThemeTemplateMsgbox = BackyardMsgBoxMgr.New()

	_backYardThemeTemplateMsgbox:Init(arg0_6, arg1_6)
end

function var0_0.init(arg0_7)
	arg0_7.tpl = arg0_7:findTF("adpter/tag/list/tpl")
	arg0_7.container = arg0_7:findTF("adpter/tag/list")
	arg0_7.pageContainer = arg0_7:findTF("pages")
	arg0_7.backBtn = arg0_7:findTF("adpter/top/fanhui")
	arg0_7.homeBtn = arg0_7:findTF("adpter/top/help")
	arg0_7.goldTxt = arg0_7:findTF("adpter/top/res_gold/Text"):GetComponent(typeof(Text))
	arg0_7.gemTxt = arg0_7:findTF("adpter/top/res_gem/Text"):GetComponent(typeof(Text))
	arg0_7.gemAddBtn = arg0_7:findTF("adpter/top/res_gem/jiahao")
	arg0_7.goldAddBtn = arg0_7:findTF("adpter/top/res_gold/jiahao")
	arg0_7.tags = {
		[BackYardConst.THEME_TEMPLATE_TYPE_SHOP] = i18n("backyard_theme_shop_title"),
		[BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM] = i18n("backyard_theme_mine_title"),
		[BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION] = i18n("backyard_theme_collection_title")
	}
	arg0_7.listPage = BackYardThemeTemplateListPage.New(arg0_7.pageContainer, arg0_7.event, arg0_7.contextData)
	arg0_7.contextData.msgBox = BackYardThemeTemplateMsgBox.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)
end

function var0_0.SetShopThemeTemplate(arg0_8, arg1_8)
	arg0_8.shopThemeTemplate = arg1_8
end

function var0_0.ShopThemeTemplateUpdate(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.shopThemeTemplate) do
		if iter1_9.id == arg1_9.id then
			arg0_9.shopThemeTemplate[iter0_9] = arg1_9

			break
		end
	end

	if arg0_9.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_9.listPage:ExecuteAction("ThemeTemplateUpdate", arg1_9)
	end
end

function var0_0.OnShopTemplatesUpdated(arg0_10, arg1_10)
	arg0_10:SetShopThemeTemplate(arg1_10)

	if arg0_10.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_10 = arg0_10:GetDataForType(arg0_10.pageType)

		arg0_10.listPage:ExecuteAction("ThemeTemplatesUpdate", var0_10)
	end
end

function var0_0.OnShopTemplatesErro(arg0_11)
	if arg0_11.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_11 = arg0_11:GetDataForType(arg0_11.pageType)

		arg0_11.listPage:ExecuteAction("ThemeTemplatesErro", var0_11)
	end
end

function var0_0.SetCustomThemeTemplate(arg0_12, arg1_12)
	arg0_12.customThemeTemplate = arg1_12
end

function var0_0.CustomThemeTemplateUpdate(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.customThemeTemplate) do
		if iter1_13.id == arg1_13.id then
			arg0_13.customThemeTemplate[iter0_13] = arg1_13

			break
		end
	end

	if arg0_13.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		arg0_13.listPage:ExecuteAction("ThemeTemplateUpdate", arg1_13)
	end
end

function var0_0.SetCollectionThemeTemplate(arg0_14, arg1_14)
	arg0_14.collectionThemeTemplate = arg1_14
end

function var0_0.CollectionThemeTemplateUpdate(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.collectionThemeTemplate) do
		if iter1_15.id == arg1_15.id then
			arg0_15.collectionThemeTemplate[iter0_15] = arg1_15

			break
		end
	end

	if arg0_15.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_15.listPage:ExecuteAction("ThemeTemplateUpdate", arg1_15)
	end
end

function var0_0.SetDorm(arg0_16, arg1_16)
	arg0_16.dorm = arg1_16
end

function var0_0.UpdateDorm(arg0_17, arg1_17)
	arg0_17:SetDorm(arg1_17)

	if arg0_17.pageType then
		arg0_17.listPage:ExecuteAction("UpdateDorm", arg1_17)
	end
end

function var0_0.SetPlayer(arg0_18, arg1_18)
	arg0_18.player = arg1_18
end

function var0_0.PlayerUpdated(arg0_19, arg1_19)
	arg0_19:SetPlayer(arg1_19)
	arg0_19:UpdateRes()

	if arg0_19.pageType then
		arg0_19.listPage:ExecuteAction("PlayerUpdated", arg1_19)
	end
end

function var0_0.FurnituresUpdated(arg0_20, arg1_20)
	if arg0_20.pageType then
		arg0_20.listPage:ExecuteAction("FurnituresUpdated", arg1_20)
	end
end

function var0_0.SearchKeyChange(arg0_21, arg1_21)
	if arg0_21.pageType and (arg0_21.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM or arg0_21.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION) then
		arg0_21.listPage:ExecuteAction("SearchKeyChange", arg1_21)
	end
end

function var0_0.ShopSearchKeyChange(arg0_22, arg1_22)
	if arg0_22.pageType and arg0_22.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_22.listPage:ExecuteAction("ShopSearchKeyChange", arg1_22)
	end
end

function var0_0.ClearShopSearchKey(arg0_23)
	if arg0_23.pageType and arg0_23.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_23.listPage:ExecuteAction("ClearShopSearchKey")
	end
end

function var0_0.DeleteCustomThemeTemplate(arg0_24, arg1_24)
	if not arg0_24.customThemeTemplate then
		return
	end

	for iter0_24, iter1_24 in pairs(arg0_24.customThemeTemplate) do
		if iter1_24.id == arg1_24 then
			arg0_24.customThemeTemplate[iter0_24] = nil

			break
		end
	end

	if arg0_24.pageType and arg0_24.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		arg0_24.listPage:ExecuteAction("DeleteCustomThemeTemplate", arg1_24)
	end
end

function var0_0.DeleteCollectionThemeTemplate(arg0_25, arg1_25)
	if not arg0_25.collectionThemeTemplate then
		return
	end

	for iter0_25, iter1_25 in pairs(arg0_25.collectionThemeTemplate) do
		if iter1_25.id == arg1_25 then
			arg0_25.collectionThemeTemplate[iter0_25] = nil

			break
		end
	end

	if arg0_25.pageType and arg0_25.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_25.listPage:ExecuteAction("DeleteCollectionThemeTemplate", arg1_25)
	end
end

function var0_0.DeleteShopThemeTemplate(arg0_26, arg1_26)
	if not arg0_26.shopThemeTemplate then
		return
	end

	for iter0_26, iter1_26 in pairs(arg0_26.shopThemeTemplate) do
		if iter1_26.id == arg1_26 then
			arg0_26.shopThemeTemplate[iter0_26] = nil

			break
		end
	end

	if arg0_26.pageType and arg0_26.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0_26.listPage:ExecuteAction("DeleteShopThemeTemplate", arg1_26)
	end
end

function var0_0.AddCollectionThemeTemplate(arg0_27, arg1_27)
	arg0_27.collectionThemeTemplate[arg1_27.id] = arg1_27

	if arg0_27.pageType and arg0_27.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0_27.listPage:ExecuteAction("AddCollectionThemeTemplate", arg1_27.id)
	end
end

function var0_0.didEnter(arg0_28)
	onButton(arg0_28, arg0_28.backBtn, function()
		arg0_28:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_28, arg0_28.homeBtn, function()
		arg0_28:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.gemAddBtn, function()
		arg0_28:emit(NewBackYardThemeTemplateMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.goldAddBtn, function()
		arg0_28:emit(NewBackYardThemeTemplateMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	seriesAsync({
		function(arg0_33)
			arg0_28:emit(NewBackYardThemeTemplateMediator.FETCH_ALL_THEME, arg0_33)
		end
	}, function()
		arg0_28:InitPages()
		arg0_28:UpdateRes()
		arg0_28:ActiveDefaultPage()
	end)
end

function var0_0.InitPages(arg0_35)
	arg0_35.btns = {}

	for iter0_35, iter1_35 in pairs(arg0_35.tags) do
		local var0_35 = cloneTplTo(arg0_35.tpl, arg0_35.container)
		local var1_35 = var0_35:Find("unsel"):GetComponent(typeof(Image))

		var1_35.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tp_" .. iter0_35)

		var1_35:SetNativeSize()

		local var2_35 = var0_35:Find("sel/Text"):GetComponent(typeof(Image))

		var2_35.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tp_" .. iter0_35)

		var2_35:SetNativeSize()
		setActive(var0_35:Find("line"), iter0_35 ~= BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION)
		var1_0(arg0_35, var0_35, function()
			local var0_36 = arg0_35:GetDataForType(iter0_35)

			arg0_35.listPage:ExecuteAction("SetUp", iter0_35, var0_36, arg0_35.dorm, arg0_35.player)

			arg0_35.pageType = iter0_35

			return true
		end)

		arg0_35.btns[iter0_35] = var0_35
	end

	setActive(arg0_35.tpl, false)
end

function var0_0.ActiveDefaultPage(arg0_37)
	local var0_37 = arg0_37.contextData.page or BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM

	triggerButton(arg0_37.btns[var0_37])
end

function var0_0.GetDataForType(arg0_38, arg1_38)
	if arg1_38 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_38 = {}

		for iter0_38, iter1_38 in pairs(arg0_38.shopThemeTemplate) do
			table.insert(var0_38, iter1_38)
		end

		return var0_38 or {}
	elseif arg1_38 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var1_38 = {}

		for iter2_38, iter3_38 in pairs(arg0_38.customThemeTemplate) do
			if iter3_38:CanDispaly() then
				table.insert(var1_38, iter3_38)
			end
		end

		return var1_38
	elseif arg1_38 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		local var2_38 = {}

		for iter4_38, iter5_38 in pairs(arg0_38.collectionThemeTemplate) do
			table.insert(var2_38, iter5_38)
		end

		return var2_38 or {}
	end

	assert(false)
end

function var0_0.UpdateRes(arg0_39)
	arg0_39.goldTxt.text = arg0_39.player:getResource(PlayerConst.ResDormMoney)
	arg0_39.gemTxt.text = arg0_39.player:getTotalGem()
end

function var0_0.willExit(arg0_40)
	_backYardThemeTemplateMsgbox:Destroy()

	_backYardThemeTemplateMsgbox = nil

	arg0_40.listPage:Destroy()
	arg0_40.contextData.msgBox:Destroy()
	BackYardThemeTempalteUtil.ClearAllCache()
end

return var0_0

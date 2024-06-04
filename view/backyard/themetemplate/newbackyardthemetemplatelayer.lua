local var0 = class("NewBackYardThemeTemplateLayer", import("...base.BaseUI"))

local function var1(arg0, arg1, arg2)
	local function var0(arg0, arg1)
		setActive(arg0:Find("sel"), arg1)
		setActive(arg0:Find("unsel"), not arg1)
	end

	onButton(arg0, arg1, function()
		if not arg2() then
			return
		end

		if arg0.btn then
			var0(arg0.btn, false)
		end

		var0(arg1, true)

		arg0.btn = arg1
	end, SFX_PANEL)
	var0(arg1, false)
end

function var0.forceGC(arg0)
	return true
end

function var0.getUIName(arg0)
	return "NewBackYardTemplateUI"
end

function var0.preload(arg0, arg1)
	_backYardThemeTemplateMsgbox = BackyardMsgBoxMgr.New()

	_backYardThemeTemplateMsgbox:Init(arg0, arg1)
end

function var0.init(arg0)
	arg0.tpl = arg0:findTF("adpter/tag/list/tpl")
	arg0.container = arg0:findTF("adpter/tag/list")
	arg0.pageContainer = arg0:findTF("pages")
	arg0.backBtn = arg0:findTF("adpter/top/fanhui")
	arg0.homeBtn = arg0:findTF("adpter/top/help")
	arg0.goldTxt = arg0:findTF("adpter/top/res_gold/Text"):GetComponent(typeof(Text))
	arg0.gemTxt = arg0:findTF("adpter/top/res_gem/Text"):GetComponent(typeof(Text))
	arg0.gemAddBtn = arg0:findTF("adpter/top/res_gem/jiahao")
	arg0.goldAddBtn = arg0:findTF("adpter/top/res_gold/jiahao")
	arg0.tags = {
		[BackYardConst.THEME_TEMPLATE_TYPE_SHOP] = i18n("backyard_theme_shop_title"),
		[BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM] = i18n("backyard_theme_mine_title"),
		[BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION] = i18n("backyard_theme_collection_title")
	}
	arg0.listPage = BackYardThemeTemplateListPage.New(arg0.pageContainer, arg0.event, arg0.contextData)
	arg0.contextData.msgBox = BackYardThemeTemplateMsgBox.New(arg0._tf, arg0.event, arg0.contextData)
end

function var0.SetShopThemeTemplate(arg0, arg1)
	arg0.shopThemeTemplate = arg1
end

function var0.ShopThemeTemplateUpdate(arg0, arg1)
	for iter0, iter1 in pairs(arg0.shopThemeTemplate) do
		if iter1.id == arg1.id then
			arg0.shopThemeTemplate[iter0] = arg1

			break
		end
	end

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0.listPage:ExecuteAction("ThemeTemplateUpdate", arg1)
	end
end

function var0.OnShopTemplatesUpdated(arg0, arg1)
	arg0:SetShopThemeTemplate(arg1)

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0 = arg0:GetDataForType(arg0.pageType)

		arg0.listPage:ExecuteAction("ThemeTemplatesUpdate", var0)
	end
end

function var0.OnShopTemplatesErro(arg0)
	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0 = arg0:GetDataForType(arg0.pageType)

		arg0.listPage:ExecuteAction("ThemeTemplatesErro", var0)
	end
end

function var0.SetCustomThemeTemplate(arg0, arg1)
	arg0.customThemeTemplate = arg1
end

function var0.CustomThemeTemplateUpdate(arg0, arg1)
	for iter0, iter1 in pairs(arg0.customThemeTemplate) do
		if iter1.id == arg1.id then
			arg0.customThemeTemplate[iter0] = arg1

			break
		end
	end

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		arg0.listPage:ExecuteAction("ThemeTemplateUpdate", arg1)
	end
end

function var0.SetCollectionThemeTemplate(arg0, arg1)
	arg0.collectionThemeTemplate = arg1
end

function var0.CollectionThemeTemplateUpdate(arg0, arg1)
	for iter0, iter1 in pairs(arg0.collectionThemeTemplate) do
		if iter1.id == arg1.id then
			arg0.collectionThemeTemplate[iter0] = arg1

			break
		end
	end

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0.listPage:ExecuteAction("ThemeTemplateUpdate", arg1)
	end
end

function var0.SetDorm(arg0, arg1)
	arg0.dorm = arg1
end

function var0.UpdateDorm(arg0, arg1)
	arg0:SetDorm(arg1)

	if arg0.pageType then
		arg0.listPage:ExecuteAction("UpdateDorm", arg1)
	end
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.PlayerUpdated(arg0, arg1)
	arg0:SetPlayer(arg1)
	arg0:UpdateRes()

	if arg0.pageType then
		arg0.listPage:ExecuteAction("PlayerUpdated", arg1)
	end
end

function var0.FurnituresUpdated(arg0, arg1)
	if arg0.pageType then
		arg0.listPage:ExecuteAction("FurnituresUpdated", arg1)
	end
end

function var0.SearchKeyChange(arg0, arg1)
	if arg0.pageType and (arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM or arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION) then
		arg0.listPage:ExecuteAction("SearchKeyChange", arg1)
	end
end

function var0.ShopSearchKeyChange(arg0, arg1)
	if arg0.pageType and arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0.listPage:ExecuteAction("ShopSearchKeyChange", arg1)
	end
end

function var0.ClearShopSearchKey(arg0)
	if arg0.pageType and arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0.listPage:ExecuteAction("ClearShopSearchKey")
	end
end

function var0.DeleteCustomThemeTemplate(arg0, arg1)
	if not arg0.customThemeTemplate then
		return
	end

	for iter0, iter1 in pairs(arg0.customThemeTemplate) do
		if iter1.id == arg1 then
			arg0.customThemeTemplate[iter0] = nil

			break
		end
	end

	if arg0.pageType and arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		arg0.listPage:ExecuteAction("DeleteCustomThemeTemplate", arg1)
	end
end

function var0.DeleteCollectionThemeTemplate(arg0, arg1)
	if not arg0.collectionThemeTemplate then
		return
	end

	for iter0, iter1 in pairs(arg0.collectionThemeTemplate) do
		if iter1.id == arg1 then
			arg0.collectionThemeTemplate[iter0] = nil

			break
		end
	end

	if arg0.pageType and arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0.listPage:ExecuteAction("DeleteCollectionThemeTemplate", arg1)
	end
end

function var0.DeleteShopThemeTemplate(arg0, arg1)
	if not arg0.shopThemeTemplate then
		return
	end

	for iter0, iter1 in pairs(arg0.shopThemeTemplate) do
		if iter1.id == arg1 then
			arg0.shopThemeTemplate[iter0] = nil

			break
		end
	end

	if arg0.pageType and arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		arg0.listPage:ExecuteAction("DeleteShopThemeTemplate", arg1)
	end
end

function var0.AddCollectionThemeTemplate(arg0, arg1)
	arg0.collectionThemeTemplate[arg1.id] = arg1

	if arg0.pageType and arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		arg0.listPage:ExecuteAction("AddCollectionThemeTemplate", arg1.id)
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.gemAddBtn, function()
		arg0:emit(NewBackYardThemeTemplateMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
	onButton(arg0, arg0.goldAddBtn, function()
		arg0:emit(NewBackYardThemeTemplateMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	seriesAsync({
		function(arg0)
			arg0:emit(NewBackYardThemeTemplateMediator.FETCH_ALL_THEME, arg0)
		end
	}, function()
		arg0:InitPages()
		arg0:UpdateRes()
		arg0:ActiveDefaultPage()
	end)
end

function var0.InitPages(arg0)
	arg0.btns = {}

	for iter0, iter1 in pairs(arg0.tags) do
		local var0 = cloneTplTo(arg0.tpl, arg0.container)
		local var1 = var0:Find("unsel"):GetComponent(typeof(Image))

		var1.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tp_" .. iter0)

		var1:SetNativeSize()

		local var2 = var0:Find("sel/Text"):GetComponent(typeof(Image))

		var2.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tp_" .. iter0)

		var2:SetNativeSize()
		setActive(var0:Find("line"), iter0 ~= BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION)
		var1(arg0, var0, function()
			local var0 = arg0:GetDataForType(iter0)

			arg0.listPage:ExecuteAction("SetUp", iter0, var0, arg0.dorm, arg0.player)

			arg0.pageType = iter0

			return true
		end)

		arg0.btns[iter0] = var0
	end

	setActive(arg0.tpl, false)
end

function var0.ActiveDefaultPage(arg0)
	local var0 = arg0.contextData.page or BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM

	triggerButton(arg0.btns[var0])
end

function var0.GetDataForType(arg0, arg1)
	if arg1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0 = {}

		for iter0, iter1 in pairs(arg0.shopThemeTemplate) do
			table.insert(var0, iter1)
		end

		return var0 or {}
	elseif arg1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var1 = {}

		for iter2, iter3 in pairs(arg0.customThemeTemplate) do
			if iter3:CanDispaly() then
				table.insert(var1, iter3)
			end
		end

		return var1
	elseif arg1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		local var2 = {}

		for iter4, iter5 in pairs(arg0.collectionThemeTemplate) do
			table.insert(var2, iter5)
		end

		return var2 or {}
	end

	assert(false)
end

function var0.UpdateRes(arg0)
	arg0.goldTxt.text = arg0.player:getResource(PlayerConst.ResDormMoney)
	arg0.gemTxt.text = arg0.player:getTotalGem()
end

function var0.willExit(arg0)
	_backYardThemeTemplateMsgbox:Destroy()

	_backYardThemeTemplateMsgbox = nil

	arg0.listPage:Destroy()
	arg0.contextData.msgBox:Destroy()
	BackYardThemeTempalteUtil.ClearAllCache()
end

return var0

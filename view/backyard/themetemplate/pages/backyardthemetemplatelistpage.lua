local var0 = class("BackYardThemeTemplateListPage", import("...Shop.pages.BackYardThemePage"))

var0.nextClickRefreshTime = 0

function var0.getUIName(arg0)
	return "BackYardThemeTemplateThemePage"
end

function var0.LoadDetail(arg0)
	setActive(arg0:findTF("adpter/descript"), false)
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.tipBg = arg0:findTF("tip")
	arg0.tips = {
		arg0:findTF("tip1"),
		arg0:findTF("tip2"),
		arg0:findTF("tip3")
	}
	arg0.goBtn = arg0:findTF("go_btn")
	arg0.helpBtn = arg0:findTF("adpter/help")
	arg0.rawImage = arg0:findTF("preview_raw"):GetComponent(typeof(RawImage))
	arg0.listRect = arg0:findTF("list/frame")
	arg0.refreshBtns = arg0:findTF("adpter/refresh_btns")
	arg0.btns = {
		[5] = arg0.refreshBtns:Find("random"),
		[3] = arg0.refreshBtns:Find("hot"),
		[2] = arg0.refreshBtns:Find("new")
	}

	setText(arg0.refreshBtns:Find("random/Text"), i18n("word_random"))
	setText(arg0.refreshBtns:Find("random/sel/Text"), i18n("word_random"))
	setText(arg0.refreshBtns:Find("hot/Text"), i18n("word_hot"))
	setText(arg0.refreshBtns:Find("hot/sel/Text"), i18n("word_hot"))
	setText(arg0.refreshBtns:Find("new/Text"), i18n("word_new"))
	setText(arg0.refreshBtns:Find("new/sel/Text"), i18n("word_new"))

	for iter0, iter1 in pairs(arg0.btns) do
		onButton(arg0, iter1, function()
			if arg0:CanClickRefBtn(iter0) then
				if arg0.selectedRefBtn then
					setActive(arg0.selectedRefBtn:Find("sel"), false)
					setActive(arg0.selectedRefBtn:Find("Text"), true)
				end

				setActive(iter1:Find("sel"), true)
				setActive(iter1:Find("Text"), false)
				arg0:SwitchPage(iter0, 1)

				arg0.selectedRefBtn = iter1
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.helpBtn, function()
		_backYardThemeTemplateMsgbox:ShowHelp({
			helps = pg.gametip.backyard_theme_template_shop_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(NewBackYardThemeTemplateMediator.GO_DECORATION)
	end, SFX_PANEL)
	arg0.scrollRect.onValueChanged:RemoveAllListeners()

	arg0.arrLeftBtnShop = arg0:findTF("list/frame/zuobian_shop")
	arg0.arrRightBtnShop = arg0:findTF("list/frame/youbian_shop")

	onButton(arg0, arg0.arrLeftBtnShop, function()
		if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			local var0 = getProxy(DormProxy).PAGE
			local var1 = getProxy(DormProxy).TYPE

			if var0 > 1 then
				arg0:SwitchPage(var1, var0 - 1, true)
			end
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.arrRightBtnShop, function()
		if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			getProxy(DormProxy).ClickPage = true

			local var0 = getProxy(DormProxy).PAGE
			local var1 = getProxy(DormProxy).TYPE

			arg0:SwitchPage(var1, var0 + 1, true)
		end
	end, SFX_PANEL)

	local function var0()
		if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			local var0 = BackYardConst.ThemeSortIndex2ServerIndex(arg0.sortIndex, arg0.asc)

			arg0:emit(NewBackYardThemeTemplateMediator.ON_GET_SPCAIL_TYPE_TEMPLATE, var0)
		else
			arg0:SetTotalCount()
		end
	end

	arg0.descPages = BackYardThemeTemplateDescPage.New(arg0._tf, arg0.event, arg0.contextData)

	function arg0.descPages.OnSortChange(arg0)
		arg0.asc = arg0

		var0()
	end

	arg0.contextData.infoPage = BackYardThemeTemplateInfoPage.New(arg0._parentTf, arg0.event, arg0.contextData)
	arg0.contextData.furnitureMsgBox = BackYardFurnitureMsgBoxPage.New(arg0._parentTf, arg0.event, arg0.contextData)
	arg0.contextData.themeMsgBox = BackYardThemeTemplatePurchaseMsgbox.New(arg0._parentTf, arg0.event, arg0.contextData)

	setText(arg0.goBtn:Find("Text"), i18n("courtyard_label_go"))
	setText(arg0:findTF("tip1"), i18n("courtyard_label_empty_template_list"))
	setText(arg0:findTF("tip2"), i18n("courtyard_label_empty_custom_template_list"))
	setText(arg0:findTF("tip3"), i18n("courtyard_label_empty_collection_list"))
end

function var0.InitInput(arg0)
	onInputChanged(arg0, arg0.searchInput, function()
		local var0 = getInputText(arg0.searchInput)

		setActive(arg0.searchClear, var0 ~= "")
	end)
	onInputEndEdit(arg0, arg0.searchInput, function()
		arg0:OnSearchKeyChange()
	end)
end

function var0.UpdateArr(arg0)
	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0 = getProxy(DormProxy).PAGE
		local var1 = getProxy(DormProxy).TYPE
		local var2 = getProxy(DormProxy).lastPages[var1]
		local var3 = getProxy(DormProxy).ClickPage

		setActive(arg0.arrLeftBtnShop, var0 > 1)
		setActive(arg0.arrRightBtnShop, var0 < var2 or not var3)
	elseif arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		setActive(arg0.arrLeftBtnShop, false)
		setActive(arg0.arrRightBtnShop, false)
	else
		setActive(arg0.arrLeftBtnShop, false)
		setActive(arg0.arrRightBtnShop, false)
	end
end

function var0.CanClickRefBtn(arg0, arg1)
	local var0 = getProxy(DormProxy).TYPE
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	if var1 < var0.nextClickRefreshTime then
		local var2 = math.ceil(var0.nextClickRefreshTime - var1)

		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shop_refresh_frequently", var2))

		return false
	end

	if var0 == arg1 and arg1 ~= 5 then
		return false
	end

	return true
end

function var0.SwitchPage(arg0, arg1, arg2, arg3)
	local var0 = getProxy(DormProxy).TYPE
	local var1 = arg0.timeType

	if var0 ~= arg1 or arg3 then
		arg0:emit(NewBackYardThemeTemplateMediator.ON_REFRESH, arg1, arg2, var1, arg3)

		if not arg3 then
			local var2 = pg.TimeMgr.GetInstance():GetServerTime()

			var0.nextClickRefreshTime = BackYardConst.MANUAL_REFRESH_THEME_TEMPLATE_TIME + var2
		end
	end
end

function var0.UpdateDorm(arg0, arg1)
	arg0.dorm = arg1

	if arg0.contextData.infoPage:GetLoaded() and arg0.contextData.infoPage:isShowing() then
		arg0.contextData.infoPage:ExecuteAction("DormUpdated", arg1)
	end

	if arg0.descPages:GetLoaded() then
		arg0.descPages:ExecuteAction("UpdateDorm", arg1)
	end
end

function var0.PlayerUpdated(arg0, arg1)
	arg0.player = arg1

	if arg0.contextData.infoPage:GetLoaded() and arg0.contextData.infoPage:isShowing() then
		arg0.contextData.infoPage:ExecuteAction("OnPlayerUpdated", arg1)
	end

	if arg0.descPages:GetLoaded() then
		arg0.descPages:ExecuteAction("PlayerUpdated", arg1)
	end
end

function var0.FurnituresUpdated(arg0, arg1)
	if arg0.contextData.infoPage:GetLoaded() and arg0.contextData.infoPage:isShowing() then
		arg0.contextData.infoPage:ExecuteAction("FurnituresUpdated", arg1)
	end
end

function var0.ThemeTemplateUpdate(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.list) do
		if iter1.id == arg1.id then
			arg0.list[iter0] = arg1

			break
		end
	end

	for iter2, iter3 in pairs(arg0.cards) do
		if iter3.template.id == arg1.id then
			iter3:Update(arg1)
		end
	end

	if arg0.descPages:GetLoaded() then
		arg0.descPages:ThemeTemplateUpdate(arg1)
	end
end

function var0.ThemeTemplatesUpdate(arg0, arg1)
	arg0:Flush(arg1)
end

function var0.OnSearchKeyChange(arg0)
	local var0 = getInputText(arg0.searchInput)

	arg0:emit(NewBackYardThemeTemplateMediator.ON_SEARCH, arg0.pageType, var0)
end

function var0.ShopSearchKeyChange(arg0, arg1)
	arg0.searchTemplate = arg1

	arg0:InitThemeList()

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.themeVO.id == arg1.id then
			triggerButton(iter1._tf)

			break
		end
	end
end

function var0.OnSearchKeyEditEnd(arg0)
	local var0 = getInputText(arg0.searchInput)

	if not var0 or var0 == "" then
		arg0:emit(NewBackYardThemeTemplateMediator.ON_SEARCH, arg0.pageType, var0)
	end
end

function var0.ClearShopSearchKey(arg0)
	arg0.searchTemplate = nil

	arg0:InitThemeList()
	arg0:ForceActiveFirstCard()
end

function var0.DeleteCustomThemeTemplate(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.list) do
		if iter1.id == arg1 then
			table.remove(arg0.list, iter0)

			break
		end
	end

	arg0:InitThemeList()
	arg0:ForceActiveFirstCard()
end

function var0.DeleteCollectionThemeTemplate(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.list) do
		if iter1.id == arg1 then
			table.remove(arg0.list, iter0)

			break
		end
	end

	arg0:InitThemeList()
	arg0:ForceActiveFirstCard()
end

function var0.AddCollectionThemeTemplate(arg0, arg1)
	table.insert(arg0.list, arg1)
	arg0:InitThemeList()
end

function var0.DeleteShopThemeTemplate(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.list) do
		if iter1.id == arg1 then
			table.remove(arg0.list, iter0)

			break
		end
	end

	arg0:InitThemeList()
	arg0:ForceActiveFirstCard()
end

function var0.ThemeTemplatesErro(arg0)
	arg0:UpdateArr()
end

function var0.GetData(arg0)
	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		table.sort(arg0.list, function(arg0, arg1)
			return arg0.sortIndex < arg1.sortIndex
		end)
	else
		local var0
		local var1

		if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			local var2, var3 = BackYardConst.ServerIndex2ThemeSortIndex(getProxy(DormProxy).TYPE)
		else
			local var4 = defaultValue(arg0.sortIndex, 1)
			local var5 = defaultValue(arg0.asc, true)
		end
	end

	return arg0.list
end

function var0.OnDormUpdated(arg0)
	return
end

function var0.OnPlayerUpdated(arg0)
	return
end

function var0.BlurView(arg0)
	return
end

function var0.UnBlurView(arg0)
	return
end

function var0.SetUp(arg0, arg1, arg2, arg3, arg4)
	arg0.searchTemplate = nil
	arg0.searchKey = ""
	arg0.pageType = arg1
	arg0.dorm = arg3
	arg0.player = arg4

	arg0:Flush(arg2)

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0 = getProxy(DormProxy).TYPE
		local var1 = getProxy(DormProxy).PAGE

		setActive(arg0.btns[var0]:Find("sel"), true)

		arg0.selectedRefBtn = arg0.btns[var0]

		if getProxy(DormProxy):NeedRefreshThemeTemplateShop() then
			arg0:SwitchPage(var0, var1, true)
		end
	end

	setActive(arg0.refreshBtns, arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP)
	setActive(arg0.searchInput.gameObject, arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP)

	if arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION and getProxy(DormProxy):NeedCollectionTip() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("BackYard_collection_be_delete_tip"))
	end

	if getProxy(DormProxy):NeedShopShowHelp() then
		-- block empty
	end

	if arg0.pageType ~= BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		for iter0, iter1 in pairs(arg0.btns) do
			setActive(iter1:Find("sel"), false)
			setActive(iter1:Find("Text"), true)
		end
	end
end

function var0.Flush(arg0, arg1)
	arg0:Show()

	arg0.list = arg1 or {}

	arg0:InitThemeList()
	arg0:UpdateArr()

	arg0.card = nil

	onNextTick(function()
		arg0:ForceActiveFirstCard()
	end)
end

function var0.InitThemeList(arg0)
	setActive(arg0.rawImage.gameObject, false)
	arg0:SetTotalCount()
end

function var0.SetTotalCount(arg0)
	arg0.disPlays = {}

	local var0 = arg0:GetData()

	if arg0.searchTemplate then
		table.insert(arg0.disPlays, arg0.searchTemplate)
	else
		for iter0, iter1 in ipairs(var0) do
			if iter1:MatchSearchKey(arg0.searchKey) then
				table.insert(arg0.disPlays, iter1)
			end
		end
	end

	arg0.scrollRect:SetTotalCount(#arg0.disPlays)
end

function var0.ForceActiveFirstCard(arg0)
	local var0 = #arg0.disPlays == 0

	setActive(arg0.tipBg, var0)

	local var1 = GetOrAddComponent(arg0.listRect, typeof(CanvasGroup))

	var1.alpha = var0 and 0 or 1
	var1.blocksRaycasts = not var0

	_.each(arg0.tips, function(arg0)
		setActive(arg0, arg0.gameObject.name == "tip" .. tostring(arg0.pageType) and #arg0.disPlays == 0)
	end)
	setActive(arg0.goBtn, arg0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM and #arg0.disPlays == 0)

	if #arg0.disPlays == 0 then
		arg0.descPages:ExecuteAction("Hide")

		return
	end

	local var2 = arg0.disPlays[1]

	for iter0, iter1 in pairs(arg0.cards) do
		if var2.id == iter1.template.id then
			triggerButton(iter1._tf)

			break
		end
	end
end

function var0.NoSelected(arg0)
	return false
end

function var0.CreateCard(arg0, arg1)
	return (BackYardThemeTemplateCard.New(arg1))
end

function var0.OnUpdateCard(arg0, arg1, arg2)
	var0.super.OnUpdateCard(arg0, arg1, arg2)

	local var0 = arg0.cards[arg2]

	if var0.template:ShouldFetch() then
		arg0:emit(NewBackYardThemeTemplateMediator.ON_GET_THEMPLATE_DATA, var0.template.id, function(arg0)
			var0:FlushData(arg0)
		end)
	end
end

function var0.OnCardClick(arg0, arg1)
	if arg1.template == arg0.card then
		return
	end

	if arg0.descPages:GetLoaded() then
		arg0.descPages:Hide()
	end

	setActive(arg0.rawImage.gameObject, false)

	local function var0(arg0)
		local var0 = arg0:GetImageMd5()

		BackYardThemeTempalteUtil.GetTexture(arg0:GetTextureName(), var0, function(arg0)
			if not IsNil(arg0.rawImage) and arg0 then
				arg0.rawImage.texture = arg0

				setActive(arg0.rawImage.gameObject, true)
				arg0.rawImage:SetNativeSize()
			end
		end)
		arg0.descPages:ExecuteAction("SetUp", arg0.pageType, arg1.template, arg0.dorm, arg0.player)
	end

	if arg1.template:ShouldFetch() then
		arg0:emit(NewBackYardThemeTemplateMediator.ON_GET_THEMPLATE_DATA, arg1.template.id, function(arg0)
			var0(arg1.template)
		end)
	else
		var0(arg1.template)
	end

	arg0.card = arg1.template
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	arg0.descPages.OnSortChange = nil

	arg0.descPages:Destroy()
	arg0.contextData.infoPage:Destroy()
	arg0.contextData.furnitureMsgBox:Destroy()
	arg0.contextData.themeMsgBox:Destroy()

	if not IsNil(arg0.rawImage.texture) then
		Object.Destroy(arg0.rawImage.texture)

		arg0.rawImage.texture = nil
	end
end

return var0

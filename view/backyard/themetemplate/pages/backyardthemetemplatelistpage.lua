local var0_0 = class("BackYardThemeTemplateListPage", import("...Shop.pages.BackYardThemePage"))

var0_0.nextClickRefreshTime = 0

function var0_0.getUIName(arg0_1)
	return "BackYardThemeTemplateThemePage"
end

function var0_0.LoadDetail(arg0_2)
	setActive(arg0_2:findTF("adpter/descript"), false)
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)

	arg0_3.tipBg = arg0_3:findTF("tip")
	arg0_3.tips = {
		arg0_3:findTF("tip1"),
		arg0_3:findTF("tip2"),
		arg0_3:findTF("tip3")
	}
	arg0_3.goBtn = arg0_3:findTF("go_btn")
	arg0_3.helpBtn = arg0_3:findTF("adpter/help")
	arg0_3.rawImage = arg0_3:findTF("preview_raw"):GetComponent(typeof(RawImage))
	arg0_3.listRect = arg0_3:findTF("list/frame")
	arg0_3.refreshBtns = arg0_3:findTF("adpter/refresh_btns")
	arg0_3.btns = {
		[5] = arg0_3.refreshBtns:Find("random"),
		[3] = arg0_3.refreshBtns:Find("hot"),
		[2] = arg0_3.refreshBtns:Find("new")
	}

	setText(arg0_3.refreshBtns:Find("random/Text"), i18n("word_random"))
	setText(arg0_3.refreshBtns:Find("random/sel/Text"), i18n("word_random"))
	setText(arg0_3.refreshBtns:Find("hot/Text"), i18n("word_hot"))
	setText(arg0_3.refreshBtns:Find("hot/sel/Text"), i18n("word_hot"))
	setText(arg0_3.refreshBtns:Find("new/Text"), i18n("word_new"))
	setText(arg0_3.refreshBtns:Find("new/sel/Text"), i18n("word_new"))

	for iter0_3, iter1_3 in pairs(arg0_3.btns) do
		onButton(arg0_3, iter1_3, function()
			if arg0_3:CanClickRefBtn(iter0_3) then
				if arg0_3.selectedRefBtn then
					setActive(arg0_3.selectedRefBtn:Find("sel"), false)
					setActive(arg0_3.selectedRefBtn:Find("Text"), true)
				end

				setActive(iter1_3:Find("sel"), true)
				setActive(iter1_3:Find("Text"), false)
				arg0_3:SwitchPage(iter0_3, 1)

				arg0_3.selectedRefBtn = iter1_3
			end
		end, SFX_PANEL)
	end

	onButton(arg0_3, arg0_3.helpBtn, function()
		_backYardThemeTemplateMsgbox:ShowHelp({
			helps = pg.gametip.backyard_theme_template_shop_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(NewBackYardThemeTemplateMediator.GO_DECORATION)
	end, SFX_PANEL)
	arg0_3.scrollRect.onValueChanged:RemoveAllListeners()

	arg0_3.arrLeftBtnShop = arg0_3:findTF("list/frame/zuobian_shop")
	arg0_3.arrRightBtnShop = arg0_3:findTF("list/frame/youbian_shop")

	onButton(arg0_3, arg0_3.arrLeftBtnShop, function()
		if arg0_3.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			local var0_7 = getProxy(DormProxy).PAGE
			local var1_7 = getProxy(DormProxy).TYPE

			if var0_7 > 1 then
				arg0_3:SwitchPage(var1_7, var0_7 - 1, true)
			end
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.arrRightBtnShop, function()
		if arg0_3.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			getProxy(DormProxy).ClickPage = true

			local var0_8 = getProxy(DormProxy).PAGE
			local var1_8 = getProxy(DormProxy).TYPE

			arg0_3:SwitchPage(var1_8, var0_8 + 1, true)
		end
	end, SFX_PANEL)

	local function var0_3()
		if arg0_3.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			local var0_9 = BackYardConst.ThemeSortIndex2ServerIndex(arg0_3.sortIndex, arg0_3.asc)

			arg0_3:emit(NewBackYardThemeTemplateMediator.ON_GET_SPCAIL_TYPE_TEMPLATE, var0_9)
		else
			arg0_3:SetTotalCount()
		end
	end

	arg0_3.descPages = BackYardThemeTemplateDescPage.New(arg0_3._tf, arg0_3.event, arg0_3.contextData)

	function arg0_3.descPages.OnSortChange(arg0_10)
		arg0_3.asc = arg0_10

		var0_3()
	end

	arg0_3.contextData.infoPage = BackYardThemeTemplateInfoPage.New(arg0_3._parentTf, arg0_3.event, arg0_3.contextData)
	arg0_3.contextData.furnitureMsgBox = BackYardFurnitureMsgBoxPage.New(arg0_3._parentTf, arg0_3.event, arg0_3.contextData)
	arg0_3.contextData.themeMsgBox = BackYardThemeTemplatePurchaseMsgbox.New(arg0_3._parentTf, arg0_3.event, arg0_3.contextData)

	setText(arg0_3.goBtn:Find("Text"), i18n("courtyard_label_go"))
	setText(arg0_3:findTF("tip1"), i18n("courtyard_label_empty_template_list"))
	setText(arg0_3:findTF("tip2"), i18n("courtyard_label_empty_custom_template_list"))
	setText(arg0_3:findTF("tip3"), i18n("courtyard_label_empty_collection_list"))
end

function var0_0.InitInput(arg0_11)
	onInputChanged(arg0_11, arg0_11.searchInput, function()
		local var0_12 = getInputText(arg0_11.searchInput)

		setActive(arg0_11.searchClear, var0_12 ~= "")
	end)
	onInputEndEdit(arg0_11, arg0_11.searchInput, function()
		arg0_11:OnSearchKeyChange()
	end)
end

function var0_0.UpdateArr(arg0_14)
	if arg0_14.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_14 = getProxy(DormProxy).PAGE
		local var1_14 = getProxy(DormProxy).TYPE
		local var2_14 = getProxy(DormProxy).lastPages[var1_14]
		local var3_14 = getProxy(DormProxy).ClickPage

		setActive(arg0_14.arrLeftBtnShop, var0_14 > 1)
		setActive(arg0_14.arrRightBtnShop, var0_14 < var2_14 or not var3_14)
	elseif arg0_14.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		setActive(arg0_14.arrLeftBtnShop, false)
		setActive(arg0_14.arrRightBtnShop, false)
	else
		setActive(arg0_14.arrLeftBtnShop, false)
		setActive(arg0_14.arrRightBtnShop, false)
	end
end

function var0_0.CanClickRefBtn(arg0_15, arg1_15)
	local var0_15 = getProxy(DormProxy).TYPE
	local var1_15 = pg.TimeMgr.GetInstance():GetServerTime()

	if var1_15 < var0_0.nextClickRefreshTime then
		local var2_15 = math.ceil(var0_0.nextClickRefreshTime - var1_15)

		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shop_refresh_frequently", var2_15))

		return false
	end

	if var0_15 == arg1_15 and arg1_15 ~= 5 then
		return false
	end

	return true
end

function var0_0.SwitchPage(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = getProxy(DormProxy).TYPE
	local var1_16 = arg0_16.timeType

	if var0_16 ~= arg1_16 or arg3_16 then
		arg0_16:emit(NewBackYardThemeTemplateMediator.ON_REFRESH, arg1_16, arg2_16, var1_16, arg3_16)

		if not arg3_16 then
			local var2_16 = pg.TimeMgr.GetInstance():GetServerTime()

			var0_0.nextClickRefreshTime = BackYardConst.MANUAL_REFRESH_THEME_TEMPLATE_TIME + var2_16
		end
	end
end

function var0_0.UpdateDorm(arg0_17, arg1_17)
	arg0_17.dorm = arg1_17

	if arg0_17.contextData.infoPage:GetLoaded() and arg0_17.contextData.infoPage:isShowing() then
		arg0_17.contextData.infoPage:ExecuteAction("DormUpdated", arg1_17)
	end

	if arg0_17.descPages:GetLoaded() then
		arg0_17.descPages:ExecuteAction("UpdateDorm", arg1_17)
	end
end

function var0_0.PlayerUpdated(arg0_18, arg1_18)
	arg0_18.player = arg1_18

	if arg0_18.contextData.infoPage:GetLoaded() and arg0_18.contextData.infoPage:isShowing() then
		arg0_18.contextData.infoPage:ExecuteAction("OnPlayerUpdated", arg1_18)
	end

	if arg0_18.descPages:GetLoaded() then
		arg0_18.descPages:ExecuteAction("PlayerUpdated", arg1_18)
	end
end

function var0_0.FurnituresUpdated(arg0_19, arg1_19)
	if arg0_19.contextData.infoPage:GetLoaded() and arg0_19.contextData.infoPage:isShowing() then
		arg0_19.contextData.infoPage:ExecuteAction("FurnituresUpdated", arg1_19)
	end
end

function var0_0.ThemeTemplateUpdate(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.list) do
		if iter1_20.id == arg1_20.id then
			arg0_20.list[iter0_20] = arg1_20

			break
		end
	end

	for iter2_20, iter3_20 in pairs(arg0_20.cards) do
		if iter3_20.template.id == arg1_20.id then
			iter3_20:Update(arg1_20)
		end
	end

	if arg0_20.descPages:GetLoaded() then
		arg0_20.descPages:ThemeTemplateUpdate(arg1_20)
	end
end

function var0_0.ThemeTemplatesUpdate(arg0_21, arg1_21)
	arg0_21:Flush(arg1_21)
end

function var0_0.OnSearchKeyChange(arg0_22)
	local var0_22 = getInputText(arg0_22.searchInput)

	arg0_22:emit(NewBackYardThemeTemplateMediator.ON_SEARCH, arg0_22.pageType, var0_22)
end

function var0_0.ShopSearchKeyChange(arg0_23, arg1_23)
	arg0_23.searchTemplate = arg1_23

	arg0_23:InitThemeList()

	for iter0_23, iter1_23 in pairs(arg0_23.cards) do
		if iter1_23.themeVO.id == arg1_23.id then
			triggerButton(iter1_23._tf)

			break
		end
	end
end

function var0_0.OnSearchKeyEditEnd(arg0_24)
	local var0_24 = getInputText(arg0_24.searchInput)

	if not var0_24 or var0_24 == "" then
		arg0_24:emit(NewBackYardThemeTemplateMediator.ON_SEARCH, arg0_24.pageType, var0_24)
	end
end

function var0_0.ClearShopSearchKey(arg0_25)
	arg0_25.searchTemplate = nil

	arg0_25:InitThemeList()
	arg0_25:ForceActiveFirstCard()
end

function var0_0.DeleteCustomThemeTemplate(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.list) do
		if iter1_26.id == arg1_26 then
			table.remove(arg0_26.list, iter0_26)

			break
		end
	end

	arg0_26:InitThemeList()
	arg0_26:ForceActiveFirstCard()
end

function var0_0.DeleteCollectionThemeTemplate(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.list) do
		if iter1_27.id == arg1_27 then
			table.remove(arg0_27.list, iter0_27)

			break
		end
	end

	arg0_27:InitThemeList()
	arg0_27:ForceActiveFirstCard()
end

function var0_0.AddCollectionThemeTemplate(arg0_28, arg1_28)
	table.insert(arg0_28.list, arg1_28)
	arg0_28:InitThemeList()
end

function var0_0.DeleteShopThemeTemplate(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.list) do
		if iter1_29.id == arg1_29 then
			table.remove(arg0_29.list, iter0_29)

			break
		end
	end

	arg0_29:InitThemeList()
	arg0_29:ForceActiveFirstCard()
end

function var0_0.ThemeTemplatesErro(arg0_30)
	arg0_30:UpdateArr()
end

function var0_0.GetData(arg0_31)
	if arg0_31.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		table.sort(arg0_31.list, function(arg0_32, arg1_32)
			return arg0_32.sortIndex < arg1_32.sortIndex
		end)
	else
		local var0_31
		local var1_31

		if arg0_31.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			local var2_31, var3_31 = BackYardConst.ServerIndex2ThemeSortIndex(getProxy(DormProxy).TYPE)
		else
			local var4_31 = defaultValue(arg0_31.sortIndex, 1)
			local var5_31 = defaultValue(arg0_31.asc, true)
		end
	end

	return arg0_31.list
end

function var0_0.OnDormUpdated(arg0_33)
	return
end

function var0_0.OnPlayerUpdated(arg0_34)
	return
end

function var0_0.BlurView(arg0_35)
	return
end

function var0_0.UnBlurView(arg0_36)
	return
end

function var0_0.SetUp(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	arg0_37.searchTemplate = nil
	arg0_37.searchKey = ""
	arg0_37.pageType = arg1_37
	arg0_37.dorm = arg3_37
	arg0_37.player = arg4_37

	arg0_37:Flush(arg2_37)

	if arg0_37.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		local var0_37 = getProxy(DormProxy).TYPE
		local var1_37 = getProxy(DormProxy).PAGE

		setActive(arg0_37.btns[var0_37]:Find("sel"), true)

		arg0_37.selectedRefBtn = arg0_37.btns[var0_37]

		if getProxy(DormProxy):NeedRefreshThemeTemplateShop() then
			arg0_37:SwitchPage(var0_37, var1_37, true)
		end
	end

	setActive(arg0_37.refreshBtns, arg0_37.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP)
	setActive(arg0_37.searchInput.gameObject, arg0_37.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP)

	if arg0_37.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION and getProxy(DormProxy):NeedCollectionTip() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("BackYard_collection_be_delete_tip"))
	end

	if getProxy(DormProxy):NeedShopShowHelp() then
		-- block empty
	end

	if arg0_37.pageType ~= BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		for iter0_37, iter1_37 in pairs(arg0_37.btns) do
			setActive(iter1_37:Find("sel"), false)
			setActive(iter1_37:Find("Text"), true)
		end
	end
end

function var0_0.Flush(arg0_38, arg1_38)
	arg0_38:Show()

	arg0_38.list = arg1_38 or {}

	arg0_38:InitThemeList()
	arg0_38:UpdateArr()

	arg0_38.card = nil

	onNextTick(function()
		arg0_38:ForceActiveFirstCard()
	end)
end

function var0_0.InitThemeList(arg0_40)
	setActive(arg0_40.rawImage.gameObject, false)
	arg0_40:SetTotalCount()
end

function var0_0.SetTotalCount(arg0_41)
	arg0_41.disPlays = {}

	local var0_41 = arg0_41:GetData()

	if arg0_41.searchTemplate then
		table.insert(arg0_41.disPlays, arg0_41.searchTemplate)
	else
		for iter0_41, iter1_41 in ipairs(var0_41) do
			if iter1_41:MatchSearchKey(arg0_41.searchKey) then
				table.insert(arg0_41.disPlays, iter1_41)
			end
		end
	end

	arg0_41.scrollRect:SetTotalCount(#arg0_41.disPlays)
end

function var0_0.ForceActiveFirstCard(arg0_42)
	local var0_42 = #arg0_42.disPlays == 0

	setActive(arg0_42.tipBg, var0_42)

	local var1_42 = GetOrAddComponent(arg0_42.listRect, typeof(CanvasGroup))

	var1_42.alpha = var0_42 and 0 or 1
	var1_42.blocksRaycasts = not var0_42

	_.each(arg0_42.tips, function(arg0_43)
		setActive(arg0_43, arg0_43.gameObject.name == "tip" .. tostring(arg0_42.pageType) and #arg0_42.disPlays == 0)
	end)
	setActive(arg0_42.goBtn, arg0_42.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM and #arg0_42.disPlays == 0)

	if #arg0_42.disPlays == 0 then
		arg0_42.descPages:ExecuteAction("Hide")

		return
	end

	local var2_42 = arg0_42.disPlays[1]

	for iter0_42, iter1_42 in pairs(arg0_42.cards) do
		if var2_42.id == iter1_42.template.id then
			triggerButton(iter1_42._tf)

			break
		end
	end
end

function var0_0.NoSelected(arg0_44)
	return false
end

function var0_0.CreateCard(arg0_45, arg1_45)
	return (BackYardThemeTemplateCard.New(arg1_45))
end

function var0_0.OnUpdateCard(arg0_46, arg1_46, arg2_46)
	var0_0.super.OnUpdateCard(arg0_46, arg1_46, arg2_46)

	local var0_46 = arg0_46.cards[arg2_46]

	if var0_46.template:ShouldFetch() then
		arg0_46:emit(NewBackYardThemeTemplateMediator.ON_GET_THEMPLATE_DATA, var0_46.template.id, function(arg0_47)
			var0_46:FlushData(arg0_47)
		end)
	end
end

function var0_0.OnCardClick(arg0_48, arg1_48)
	if arg1_48.template == arg0_48.card then
		return
	end

	if arg0_48.descPages:GetLoaded() then
		arg0_48.descPages:Hide()
	end

	setActive(arg0_48.rawImage.gameObject, false)

	local function var0_48(arg0_49)
		local var0_49 = arg0_49:GetImageMd5()

		BackYardThemeTempalteUtil.GetTexture(arg0_49:GetTextureName(), var0_49, function(arg0_50)
			if not IsNil(arg0_48.rawImage) and arg0_50 then
				arg0_48.rawImage.texture = arg0_50

				setActive(arg0_48.rawImage.gameObject, true)
				arg0_48.rawImage:SetNativeSize()
			end
		end)
		arg0_48.descPages:ExecuteAction("SetUp", arg0_48.pageType, arg1_48.template, arg0_48.dorm, arg0_48.player)
	end

	if arg1_48.template:ShouldFetch() then
		arg0_48:emit(NewBackYardThemeTemplateMediator.ON_GET_THEMPLATE_DATA, arg1_48.template.id, function(arg0_51)
			var0_48(arg1_48.template)
		end)
	else
		var0_48(arg1_48.template)
	end

	arg0_48.card = arg1_48.template
end

function var0_0.OnDestroy(arg0_52)
	var0_0.super.OnDestroy(arg0_52)

	arg0_52.descPages.OnSortChange = nil

	arg0_52.descPages:Destroy()
	arg0_52.contextData.infoPage:Destroy()
	arg0_52.contextData.furnitureMsgBox:Destroy()
	arg0_52.contextData.themeMsgBox:Destroy()

	if not IsNil(arg0_52.rawImage.texture) then
		Object.Destroy(arg0_52.rawImage.texture)

		arg0_52.rawImage.texture = nil
	end
end

return var0_0

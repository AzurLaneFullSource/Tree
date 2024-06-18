local var0_0 = class("BackYardDecrationLayer", import("...base.BaseUI"))

var0_0.INNER_SELECTED_FURNITRUE = "BackYardDecrationLayer:INNER_SELECTED_FURNITRUE"

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = 8
local var9_0 = 9

function var0_0.getUIName(arg0_1)
	return "BackYardDecorationUI"
end

function var0_0.init(arg0_2)
	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.adpter = arg0_2:findTF("adpter")
	arg0_2.pageConainer = arg0_2:findTF("adpter/bottom/animroot/root/pages")
	arg0_2.bAnimtion = arg0_2:findTF("adpter/bottom"):GetComponent(typeof(Animation))
	arg0_2.shopBtn = arg0_2:findTF("adpter/shop_btn")
	arg0_2.saveBtn = arg0_2:findTF("adpter/bottom/animroot/save_btn")
	arg0_2.clearBtn = arg0_2:findTF("adpter/bottom/animroot/clear_btn")
	arg0_2.bottomTr = arg0_2:findTF("adpter/bottom")
	arg0_2.orderBtn = arg0_2:findTF("adpter/bottom/animroot/root/fliter_container/order")
	arg0_2.orderBtnTxt = arg0_2.orderBtn:Find("Text"):GetComponent(typeof(Image))
	arg0_2.orderBtnIcon = arg0_2.orderBtn:Find("icon")
	arg0_2.filterBtn = arg0_2:findTF("adpter/bottom/animroot/root/fliter_container/filter")
	arg0_2.filterBtnTxt = arg0_2.filterBtn:Find("Text"):GetComponent(typeof(Image))
	arg0_2.filterBtnTxt.sprite = GetSpriteFromAtlas("ui/NewBackYardDecorateUI_atlas", "text_default")

	arg0_2.filterBtnTxt:SetNativeSize()

	arg0_2.searchInput = arg0_2:findTF("adpter/bottom/animroot/root/fliter_container/search/search")

	setText(arg0_2.searchInput:Find("holder"), i18n("courtyard_label_search_holder"))

	arg0_2.searchClear = arg0_2:findTF("adpter/bottom/animroot/root/fliter_container/search/search/clear")
	arg0_2.hideBtn = arg0_2:findTF("adpter/bottom/animroot/root/fliter_container/hide")
	arg0_2.showBtn = arg0_2:findTF("adpter/bottom/animroot/show_btn")
	arg0_2.showPutListBtn = arg0_2:findTF("adpter/putlist_btn")
	arg0_2.themePage = BackYardDecorationThemePage.New(arg0_2.pageConainer, arg0_2.event, arg0_2.contextData)
	arg0_2.furniturePage = BackYardDecorationFurniturePage.New(arg0_2.pageConainer, arg0_2.event, arg0_2.contextData)
	arg0_2.putListPage = BackYardDecorationPutlistPage.New(arg0_2.adpter, arg0_2.event, arg0_2.contextData)

	function arg0_2.putListPage.OnShow(arg0_3)
		setActive(arg0_2.showPutListBtn, not arg0_3)
	end

	function arg0_2.putListPage.OnShowImmediately()
		setActive(arg0_2.showPutListBtn, false)
	end

	arg0_2.contextData.furnitureDescMsgBox = BackYardDecorationDecBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.contextData.filterPanel = BackYardDecorationFilterPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.pages = {
		[var1_0] = arg0_2.themePage,
		[var2_0] = arg0_2.furniturePage,
		[var3_0] = arg0_2.furniturePage,
		[var4_0] = arg0_2.furniturePage,
		[var5_0] = arg0_2.furniturePage,
		[var6_0] = arg0_2.furniturePage,
		[var7_0] = arg0_2.furniturePage,
		[var8_0] = arg0_2.furniturePage,
		[var9_0] = arg0_2.furniturePage
	}
	arg0_2.themeTag = arg0_2:findTF("adpter/bottom/animroot/root/theme")

	setText(arg0_2.shopBtn:Find("Text"), i18n("courtyard_label_shop_1"))
	setText(arg0_2.showPutListBtn:Find("Text"), i18n("courtyard_label_placed_furniture"))
	setText(arg0_2.saveBtn:Find("Text"), i18n("courtyard_label_save"))
	setText(arg0_2.clearBtn:Find("Text"), i18n("courtyard_label_clear"))
end

function var0_0.didEnter(arg0_5)
	arg0_5.orderMode = BackYardDecorationFilterPanel.ORDER_MODE_DASC

	local function var0_5(arg0_6)
		local var0_6 = ""

		if arg0_6 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			var0_6 = "text_asc"
			arg0_5.orderBtnIcon.localEulerAngles = Vector3(0, 0, 0)
		elseif arg0_6 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
			var0_6 = "text_dasc"
			arg0_5.orderBtnIcon.localEulerAngles = Vector3(0, 0, 180)
		end

		arg0_5.orderBtnTxt.sprite = GetSpriteFromAtlas("ui/NewBackYardDecorateUI_atlas", var0_6)

		arg0_5.orderBtnTxt:SetNativeSize()
	end

	onToggle(arg0_5, arg0_5.orderBtn, function(arg0_7)
		arg0_5.orderMode = arg0_7 and BackYardDecorationFilterPanel.ORDER_MODE_ASC or BackYardDecorationFilterPanel.ORDER_MODE_DASC

		if arg0_5.pageType then
			arg0_5.pages[arg0_5.pageType]:ExecuteAction("OrderModeUpdated", arg0_5.orderMode)
		end

		var0_5(arg0_5.orderMode)
	end, SFX_PANEL)
	var0_5(arg0_5.orderMode)
	onButton(arg0_5, arg0_5.shopBtn, function()
		arg0_5:emit(BackYardDecorationMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.searchClear, function()
		setInputText(arg0_5.searchInput, "")
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.saveBtn, function()
		arg0_5.dftAniEvent:SetEndEvent(function()
			arg0_5.dftAniEvent:SetEndEvent(nil)
			arg0_5:emit(BackYardDecorationMediator.SAVE_ALL)
		end)
		arg0_5.animation:Play("anim_courtyard_decoration_out")
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.clearBtn, function()
		arg0_5:emit(BackYardDecorationMediator.ClEAR_ALL, true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.filterBtn, function()
		if not arg0_5.pageType then
			return
		end

		arg0_5.pages[arg0_5.pageType]:ShowFilterPanel(function(arg0_14)
			local var0_14
			local var1_14 = i18n("backyard_sort_tag_price") == arg0_14 and "text_price" or i18n("backyard_sort_tag_comfortable") == arg0_14 and "text_comfortable" or i18n("backyard_sort_tag_size") == arg0_14 and "text_area" or "text_default"

			arg0_5.filterBtnTxt.sprite = GetSpriteFromAtlas("ui/NewBackYardDecorateUI_atlas", var1_14)

			arg0_5.filterBtnTxt:SetNativeSize()
		end)
	end, SFX_PANEL)
	onInputChanged(arg0_5, arg0_5.searchInput, function(arg0_15)
		if not arg0_5.pageType then
			return
		end

		setActive(arg0_5.searchClear, arg0_15 ~= "")
		arg0_5.pages[arg0_5.pageType]:ExecuteAction("SearchKeyUpdated", arg0_15)
	end)
	onButton(arg0_5, arg0_5.showPutListBtn, function()
		arg0_5.putListPage:ExecuteAction("SetUp", 0, arg0_5.dorm, arg0_5.themes, arg0_5.orderMode)
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.themeTag, function(arg0_17)
		if arg0_17 then
			arg0_5:SwitchToPage(var1_0)
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.hideBtn, function()
		arg0_5.bAnimtion:Play("anim_courtyard_decoration_bottomout")
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.showBtn, function()
		arg0_5.bAnimtion:Play("anim_courtyard_decoration_bottomin")
	end, SFX_PANEL)

	arg0_5.tags = {
		arg0_5:findTF("adpter/bottom/animroot/root/tags/1"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/2"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/3"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/4"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/5"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/6"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/7"),
		arg0_5:findTF("adpter/bottom/animroot/root/tags/8")
	}

	onNextTick(function()
		arg0_5:emit(BackYardDecorationMediator.ON_SET_UP)
	end)
end

function var0_0.SetDorm(arg0_21, arg1_21)
	arg0_21.dorm = arg1_21
end

function var0_0.UpdateDorm(arg0_22, arg1_22)
	arg0_22.dorm = arg1_22

	if arg0_22.pageType then
		arg0_22.pages[arg0_22.pageType]:ExecuteAction("DormUpdated", arg0_22.dorm)
	end

	if arg0_22.putListPage:GetLoaded() and arg0_22.putListPage:isShowing() then
		arg0_22.putListPage:ExecuteAction("DormUpdated", arg0_22.dorm)
	end
end

function var0_0.OnApplyThemeBefore(arg0_23)
	if arg0_23.pageType then
		arg0_23.pages[arg0_23.pageType]:ExecuteAction("OnApplyThemeBefore")
	end
end

function var0_0.OnApplyThemeAfter(arg0_24, arg1_24)
	if arg0_24.pageType then
		arg0_24.pages[arg0_24.pageType]:ExecuteAction("OnApplyThemeAfter", arg1_24)
	end
end

function var0_0.UpdateFurnitrue(arg0_25, arg1_25)
	if arg0_25.pageType then
		arg0_25.pages[arg0_25.pageType]:ExecuteAction("FurnitureUpdated", arg1_25)
	end
end

function var0_0.SetThemes(arg0_26, arg1_26)
	arg0_26.themes = arg1_26
end

function var0_0.CustomThemeAdded(arg0_27, arg1_27)
	arg0_27.themes[arg1_27.id] = arg1_27

	if arg0_27.pageType then
		arg0_27.pages[arg0_27.pageType]:ExecuteAction("CustomThemeAdded", arg1_27)
	end
end

function var0_0.CustomThemeDeleted(arg0_28, arg1_28)
	arg0_28.themes[arg1_28] = nil

	if arg0_28.pageType then
		arg0_28.pages[arg0_28.pageType]:ExecuteAction("CustomThemeDeleted", arg1_28)
	end
end

function var0_0.ThemeUpdated(arg0_29)
	if arg0_29.pageType then
		arg0_29.pages[arg0_29.pageType]:ExecuteAction("ThemeUpdated")
	end
end

function var0_0.UpdateTagTF(arg0_30, arg1_30, arg2_30)
	onToggle(arg0_30, arg2_30, function(arg0_31)
		if arg0_31 then
			arg0_30:SwitchToPage(arg1_30)
		end
	end, SFX_PANEL)
end

function var0_0.InitPages(arg0_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.tags) do
		arg0_32:UpdateTagTF(iter0_32 + 1, iter1_32)
	end

	triggerToggle(arg0_32.themeTag, true)
end

function var0_0.SwitchToPage(arg0_33, arg1_33)
	if arg0_33.pageType == arg1_33 then
		return
	end

	if arg0_33.page and not arg0_33.page:GetLoaded() then
		return
	end

	local var0_33 = arg0_33.pages[arg1_33]

	if arg0_33.page and arg0_33.page ~= var0_33 then
		arg0_33.page:ExecuteAction("Hide")
	end

	var0_33:ExecuteAction("SetUp", arg1_33, arg0_33.dorm, arg0_33.themes, arg0_33.orderMode)

	arg0_33.page = var0_33
	arg0_33.pageType = arg1_33

	setActive(arg0_33.filterBtn, arg0_33.pageType ~= var1_0)
end

function var0_0.willExit(arg0_34)
	arg0_34.dftAniEvent:SetEndEvent(nil)
	arg0_34.themePage:Destroy()
	arg0_34.furniturePage:Destroy()
	arg0_34.putListPage:Destroy()
	arg0_34.contextData.furnitureDescMsgBox:Destroy()
	arg0_34.contextData.filterPanel:Destroy()
	BackYardThemeTempalteUtil.ClearAllCache()
end

function var0_0.onBackPressed(arg0_35)
	if arg0_35.themePage:OnBackPressed() then
		return
	end

	if arg0_35.furniturePage:OnBackPressed() then
		return
	end

	if arg0_35.putListPage:OnBackPressed() then
		return
	end

	if arg0_35.contextData.furnitureDescMsgBox:GetLoaded() and arg0_35.contextData.furnitureDescMsgBox:isShowing() then
		arg0_35.contextData.furnitureDescMsgBox:Hide()

		return
	end

	if arg0_35.contextData.filterPanel:GetLoaded() and arg0_35.contextData.filterPanel:isShowing() then
		arg0_35.contextData.filterPanel:Hide()

		return
	end

	triggerButton(arg0_35.saveBtn)
end

return var0_0

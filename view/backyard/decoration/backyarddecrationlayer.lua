local var0 = class("BackYardDecrationLayer", import("...base.BaseUI"))

var0.INNER_SELECTED_FURNITRUE = "BackYardDecrationLayer:INNER_SELECTED_FURNITRUE"

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6
local var7 = 7
local var8 = 8
local var9 = 9

function var0.getUIName(arg0)
	return "BackYardDecorationUI"
end

function var0.init(arg0)
	arg0.animation = arg0._tf:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))
	arg0.adpter = arg0:findTF("adpter")
	arg0.pageConainer = arg0:findTF("adpter/bottom/animroot/root/pages")
	arg0.bAnimtion = arg0:findTF("adpter/bottom"):GetComponent(typeof(Animation))
	arg0.shopBtn = arg0:findTF("adpter/shop_btn")
	arg0.saveBtn = arg0:findTF("adpter/bottom/animroot/save_btn")
	arg0.clearBtn = arg0:findTF("adpter/bottom/animroot/clear_btn")
	arg0.bottomTr = arg0:findTF("adpter/bottom")
	arg0.orderBtn = arg0:findTF("adpter/bottom/animroot/root/fliter_container/order")
	arg0.orderBtnTxt = arg0.orderBtn:Find("Text"):GetComponent(typeof(Image))
	arg0.orderBtnIcon = arg0.orderBtn:Find("icon")
	arg0.filterBtn = arg0:findTF("adpter/bottom/animroot/root/fliter_container/filter")
	arg0.filterBtnTxt = arg0.filterBtn:Find("Text"):GetComponent(typeof(Image))
	arg0.filterBtnTxt.sprite = GetSpriteFromAtlas("ui/NewBackYardDecorateUI_atlas", "text_default")

	arg0.filterBtnTxt:SetNativeSize()

	arg0.searchInput = arg0:findTF("adpter/bottom/animroot/root/fliter_container/search/search")

	setText(arg0.searchInput:Find("holder"), i18n("courtyard_label_search_holder"))

	arg0.searchClear = arg0:findTF("adpter/bottom/animroot/root/fliter_container/search/search/clear")
	arg0.hideBtn = arg0:findTF("adpter/bottom/animroot/root/fliter_container/hide")
	arg0.showBtn = arg0:findTF("adpter/bottom/animroot/show_btn")
	arg0.showPutListBtn = arg0:findTF("adpter/putlist_btn")
	arg0.themePage = BackYardDecorationThemePage.New(arg0.pageConainer, arg0.event, arg0.contextData)
	arg0.furniturePage = BackYardDecorationFurniturePage.New(arg0.pageConainer, arg0.event, arg0.contextData)
	arg0.putListPage = BackYardDecorationPutlistPage.New(arg0.adpter, arg0.event, arg0.contextData)

	function arg0.putListPage.OnShow(arg0)
		setActive(arg0.showPutListBtn, not arg0)
	end

	function arg0.putListPage.OnShowImmediately()
		setActive(arg0.showPutListBtn, false)
	end

	arg0.contextData.furnitureDescMsgBox = BackYardDecorationDecBox.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.contextData.filterPanel = BackYardDecorationFilterPanel.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.pages = {
		[var1] = arg0.themePage,
		[var2] = arg0.furniturePage,
		[var3] = arg0.furniturePage,
		[var4] = arg0.furniturePage,
		[var5] = arg0.furniturePage,
		[var6] = arg0.furniturePage,
		[var7] = arg0.furniturePage,
		[var8] = arg0.furniturePage,
		[var9] = arg0.furniturePage
	}
	arg0.themeTag = arg0:findTF("adpter/bottom/animroot/root/theme")

	setText(arg0.shopBtn:Find("Text"), i18n("courtyard_label_shop_1"))
	setText(arg0.showPutListBtn:Find("Text"), i18n("courtyard_label_placed_furniture"))
	setText(arg0.saveBtn:Find("Text"), i18n("courtyard_label_save"))
	setText(arg0.clearBtn:Find("Text"), i18n("courtyard_label_clear"))
end

function var0.didEnter(arg0)
	arg0.orderMode = BackYardDecorationFilterPanel.ORDER_MODE_DASC

	local function var0(arg0)
		local var0 = ""

		if arg0 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			var0 = "text_asc"
			arg0.orderBtnIcon.localEulerAngles = Vector3(0, 0, 0)
		elseif arg0 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
			var0 = "text_dasc"
			arg0.orderBtnIcon.localEulerAngles = Vector3(0, 0, 180)
		end

		arg0.orderBtnTxt.sprite = GetSpriteFromAtlas("ui/NewBackYardDecorateUI_atlas", var0)

		arg0.orderBtnTxt:SetNativeSize()
	end

	onToggle(arg0, arg0.orderBtn, function(arg0)
		arg0.orderMode = arg0 and BackYardDecorationFilterPanel.ORDER_MODE_ASC or BackYardDecorationFilterPanel.ORDER_MODE_DASC

		if arg0.pageType then
			arg0.pages[arg0.pageType]:ExecuteAction("OrderModeUpdated", arg0.orderMode)
		end

		var0(arg0.orderMode)
	end, SFX_PANEL)
	var0(arg0.orderMode)
	onButton(arg0, arg0.shopBtn, function()
		arg0:emit(BackYardDecorationMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.searchClear, function()
		setInputText(arg0.searchInput, "")
	end, SFX_PANEL)
	onButton(arg0, arg0.saveBtn, function()
		arg0.dftAniEvent:SetEndEvent(function()
			arg0.dftAniEvent:SetEndEvent(nil)
			arg0:emit(BackYardDecorationMediator.SAVE_ALL)
		end)
		arg0.animation:Play("anim_courtyard_decoration_out")
	end, SFX_PANEL)
	onButton(arg0, arg0.clearBtn, function()
		arg0:emit(BackYardDecorationMediator.ClEAR_ALL, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.filterBtn, function()
		if not arg0.pageType then
			return
		end

		arg0.pages[arg0.pageType]:ShowFilterPanel(function(arg0)
			local var0
			local var1 = i18n("backyard_sort_tag_price") == arg0 and "text_price" or i18n("backyard_sort_tag_comfortable") == arg0 and "text_comfortable" or i18n("backyard_sort_tag_size") == arg0 and "text_area" or "text_default"

			arg0.filterBtnTxt.sprite = GetSpriteFromAtlas("ui/NewBackYardDecorateUI_atlas", var1)

			arg0.filterBtnTxt:SetNativeSize()
		end)
	end, SFX_PANEL)
	onInputChanged(arg0, arg0.searchInput, function(arg0)
		if not arg0.pageType then
			return
		end

		setActive(arg0.searchClear, arg0 ~= "")
		arg0.pages[arg0.pageType]:ExecuteAction("SearchKeyUpdated", arg0)
	end)
	onButton(arg0, arg0.showPutListBtn, function()
		arg0.putListPage:ExecuteAction("SetUp", 0, arg0.dorm, arg0.themes, arg0.orderMode)
	end, SFX_PANEL)
	onToggle(arg0, arg0.themeTag, function(arg0)
		if arg0 then
			arg0:SwitchToPage(var1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.hideBtn, function()
		arg0.bAnimtion:Play("anim_courtyard_decoration_bottomout")
	end, SFX_PANEL)
	onButton(arg0, arg0.showBtn, function()
		arg0.bAnimtion:Play("anim_courtyard_decoration_bottomin")
	end, SFX_PANEL)

	arg0.tags = {
		arg0:findTF("adpter/bottom/animroot/root/tags/1"),
		arg0:findTF("adpter/bottom/animroot/root/tags/2"),
		arg0:findTF("adpter/bottom/animroot/root/tags/3"),
		arg0:findTF("adpter/bottom/animroot/root/tags/4"),
		arg0:findTF("adpter/bottom/animroot/root/tags/5"),
		arg0:findTF("adpter/bottom/animroot/root/tags/6"),
		arg0:findTF("adpter/bottom/animroot/root/tags/7"),
		arg0:findTF("adpter/bottom/animroot/root/tags/8")
	}

	onNextTick(function()
		arg0:emit(BackYardDecorationMediator.ON_SET_UP)
	end)
end

function var0.SetDorm(arg0, arg1)
	arg0.dorm = arg1
end

function var0.UpdateDorm(arg0, arg1)
	arg0.dorm = arg1

	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("DormUpdated", arg0.dorm)
	end

	if arg0.putListPage:GetLoaded() and arg0.putListPage:isShowing() then
		arg0.putListPage:ExecuteAction("DormUpdated", arg0.dorm)
	end
end

function var0.OnApplyThemeBefore(arg0)
	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("OnApplyThemeBefore")
	end
end

function var0.OnApplyThemeAfter(arg0, arg1)
	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("OnApplyThemeAfter", arg1)
	end
end

function var0.UpdateFurnitrue(arg0, arg1)
	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("FurnitureUpdated", arg1)
	end
end

function var0.SetThemes(arg0, arg1)
	arg0.themes = arg1
end

function var0.CustomThemeAdded(arg0, arg1)
	arg0.themes[arg1.id] = arg1

	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("CustomThemeAdded", arg1)
	end
end

function var0.CustomThemeDeleted(arg0, arg1)
	arg0.themes[arg1] = nil

	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("CustomThemeDeleted", arg1)
	end
end

function var0.ThemeUpdated(arg0)
	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("ThemeUpdated")
	end
end

function var0.UpdateTagTF(arg0, arg1, arg2)
	onToggle(arg0, arg2, function(arg0)
		if arg0 then
			arg0:SwitchToPage(arg1)
		end
	end, SFX_PANEL)
end

function var0.InitPages(arg0)
	for iter0, iter1 in ipairs(arg0.tags) do
		arg0:UpdateTagTF(iter0 + 1, iter1)
	end

	triggerToggle(arg0.themeTag, true)
end

function var0.SwitchToPage(arg0, arg1)
	if arg0.pageType == arg1 then
		return
	end

	if arg0.page and not arg0.page:GetLoaded() then
		return
	end

	local var0 = arg0.pages[arg1]

	if arg0.page and arg0.page ~= var0 then
		arg0.page:ExecuteAction("Hide")
	end

	var0:ExecuteAction("SetUp", arg1, arg0.dorm, arg0.themes, arg0.orderMode)

	arg0.page = var0
	arg0.pageType = arg1

	setActive(arg0.filterBtn, arg0.pageType ~= var1)
end

function var0.willExit(arg0)
	arg0.dftAniEvent:SetEndEvent(nil)
	arg0.themePage:Destroy()
	arg0.furniturePage:Destroy()
	arg0.putListPage:Destroy()
	arg0.contextData.furnitureDescMsgBox:Destroy()
	arg0.contextData.filterPanel:Destroy()
	BackYardThemeTempalteUtil.ClearAllCache()
end

function var0.onBackPressed(arg0)
	if arg0.themePage:OnBackPressed() then
		return
	end

	if arg0.furniturePage:OnBackPressed() then
		return
	end

	if arg0.putListPage:OnBackPressed() then
		return
	end

	if arg0.contextData.furnitureDescMsgBox:GetLoaded() and arg0.contextData.furnitureDescMsgBox:isShowing() then
		arg0.contextData.furnitureDescMsgBox:Hide()

		return
	end

	if arg0.contextData.filterPanel:GetLoaded() and arg0.contextData.filterPanel:isShowing() then
		arg0.contextData.filterPanel:Hide()

		return
	end

	triggerButton(arg0.saveBtn)
end

return var0

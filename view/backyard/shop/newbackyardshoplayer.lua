local var0 = class("NewBackYardShopLayer", import("...base.BaseUI"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6
local var7 = 7
local var8 = {
	"word_theme",
	"word_wallpaper",
	"word_floorpaper",
	"word_furniture",
	"word_shipskin",
	"word_decorate",
	"word_wall"
}

local function var9(arg0)
	return i18n(var8[arg0])
end

local function var10(arg0, arg1, arg2)
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
	return "NewBackYardShopUI"
end

function var0.SetDorm(arg0, arg1)
	arg0.dorm = arg1
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.PlayerUpdated(arg0, arg1)
	arg0:SetPlayer(arg1)
	arg0:UpdateRes()

	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("PlayerUpdated", arg1)
	end
end

function var0.DormUpdated(arg0, arg1)
	arg0:SetDorm(arg1)

	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("DormUpdated", arg1)
	end
end

function var0.FurnituresUpdated(arg0, arg1)
	if arg0.pageType then
		arg0.pages[arg0.pageType]:ExecuteAction("FurnituresUpdated", arg1)
	end
end

function var0.init(arg0)
	arg0.pageContainer = arg0:findTF("pages")
	arg0.adpter = arg0:findTF("adpter")
	arg0.btnTpl = arg0:findTF("adpter/tag/list/tpl")
	arg0.btnContainer = arg0:findTF("adpter/tag/list")
	arg0.backBtn = arg0:findTF("adpter/top/fanhui")
	arg0.goldTxt = arg0:findTF("adpter/top/res_gold/Text"):GetComponent(typeof(Text))
	arg0.gemTxt = arg0:findTF("adpter/top/res_gem/Text"):GetComponent(typeof(Text))
	arg0.goldAddBtn = arg0:findTF("adpter/top/res_gold/jiahao")
	arg0.gemAddBtn = arg0:findTF("adpter/top/res_gem/jiahao")
	arg0.help = arg0:findTF("adpter/top/help")
	arg0.themePage = BackYardThemePage.New(arg0.pageContainer, arg0.event, arg0.contextData)
	arg0.furniturePage = BackYardFurniturePage.New(arg0.pageContainer, arg0.event, arg0.contextData)
	arg0.contextData.filterPanel = BackYardShopFilterPanel.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.pages = {
		[var1] = arg0.themePage,
		[var2] = arg0.furniturePage,
		[var3] = arg0.furniturePage,
		[var4] = arg0.furniturePage,
		[var5] = arg0.furniturePage,
		[var6] = arg0.furniturePage,
		[var7] = arg0.furniturePage
	}
	arg0.contextData.furnitureMsgBox = BackYardFurnitureMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.contextData.themeMsgBox = BackYardThemeMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.contextData.themeAllMsgBox = BackYardThemeMsgBoxForAllPage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.contextData.onDeattch then
			arg0.contextData.onDeattch()
		end

		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.help, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.goldAddBtn, function()
		arg0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(arg0, arg0.gemAddBtn, function()
		arg0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
	arg0:InitPageFooter()
	arg0:UpdateRes()

	local var0 = arg0.contextData.page or var1

	triggerButton(arg0.btns[var0])

	if arg0.contextData.topLayer then
		local var1 = GetOrAddComponent(arg0._tf, typeof(Canvas))

		var1.overrideSorting = true
		var1.sortingOrder = 900

		GetOrAddComponent(arg0._tf, typeof(GraphicRaycaster))
	end

	getProxy(SettingsProxy):UpdateNewThemeValue()
end

function var0.UpdateRes(arg0)
	arg0.goldTxt.text = arg0.player:getResource(PlayerConst.ResDormMoney)
	arg0.gemTxt.text = arg0.player:getTotalGem()
end

local var11 = {
	"0",
	"1",
	"4",
	"2",
	"8",
	"3",
	"6",
	"7"
}

function var0.InitPageFooter(arg0)
	arg0.btns = {}

	for iter0, iter1 in ipairs(arg0.pages) do
		local var0 = cloneTplTo(arg0.btnTpl, arg0.btnContainer)
		local var1 = var0:Find("unsel"):GetComponent(typeof(Image))

		var1.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tag" .. iter0 - 1)

		var1:SetNativeSize()

		local var2 = var0:Find("sel/Text"):GetComponent(typeof(Image))

		var2.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tag" .. iter0 - 1)

		var2:SetNativeSize()

		local var3 = var11[iter0]
		local var4 = var0:Find("sel/icon"):GetComponent(typeof(Image))

		LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "icon_" .. var3, function(arg0)
			if arg0.exited then
				return
			end

			var4.sprite = arg0
		end)
		var10(arg0, var0, function()
			if arg0.pageType == iter0 then
				return
			end

			if arg0.pageType and not arg0.pages[arg0.pageType]:GetLoaded() then
				return
			end

			if arg0.pageType and arg0.pages[arg0.pageType] ~= iter1 then
				arg0.pages[arg0.pageType]:Hide()
			end

			iter1:ExecuteAction("SetUp", iter0, arg0.dorm, arg0.player, function()
				return
			end)

			arg0.pageType = iter0

			if iter0 == 5 then
				getProxy(SettingsProxy):UpdateNewGemFurnitureValue()
				arg0:UpdateSpecialPageFooter()
			end

			return true
		end)

		arg0.btns[iter0] = var0
	end

	arg0:UpdateSpecialPageFooter()
	setActive(arg0.btnTpl, false)
end

function var0.UpdateSpecialPageFooter(arg0)
	local var0 = arg0.btns[5]

	setActive(var0:Find("new"), getProxy(SettingsProxy):IsTipNewGemFurniture())
end

function var0.willExit(arg0)
	arg0.isOverlay = false

	arg0.contextData.filterPanel:Destroy()
	arg0.themePage:Destroy()
	arg0.furniturePage:Destroy()
	arg0.contextData.furnitureMsgBox:Destroy()

	arg0.contextData.furnitureMsgBox = nil

	arg0.contextData.themeMsgBox:Destroy()

	arg0.contextData.themeMsgBox = nil
end

return var0

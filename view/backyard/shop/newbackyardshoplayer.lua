local var0_0 = class("NewBackYardShopLayer", import("...base.BaseUI"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = {
	"word_theme",
	"word_wallpaper",
	"word_floorpaper",
	"word_furniture",
	"word_shipskin",
	"word_decorate",
	"word_wall"
}

local function var9_0(arg0_1)
	return i18n(var8_0[arg0_1])
end

local function var10_0(arg0_2, arg1_2, arg2_2)
	local function var0_2(arg0_3, arg1_3)
		setActive(arg0_3:Find("sel"), arg1_3)
		setActive(arg0_3:Find("unsel"), not arg1_3)
	end

	onButton(arg0_2, arg1_2, function()
		if not arg2_2() then
			return
		end

		if arg0_2.btn then
			var0_2(arg0_2.btn, false)
		end

		var0_2(arg1_2, true)

		arg0_2.btn = arg1_2
	end, SFX_PANEL)
	var0_2(arg1_2, false)
end

function var0_0.forceGC(arg0_5)
	return true
end

function var0_0.getUIName(arg0_6)
	return "NewBackYardShopUI"
end

function var0_0.SetDorm(arg0_7, arg1_7)
	arg0_7.dorm = arg1_7
end

function var0_0.SetPlayer(arg0_8, arg1_8)
	arg0_8.player = arg1_8
end

function var0_0.PlayerUpdated(arg0_9, arg1_9)
	arg0_9:SetPlayer(arg1_9)
	arg0_9:UpdateRes()

	if arg0_9.pageType then
		arg0_9.pages[arg0_9.pageType]:ExecuteAction("PlayerUpdated", arg1_9)
	end
end

function var0_0.DormUpdated(arg0_10, arg1_10)
	arg0_10:SetDorm(arg1_10)

	if arg0_10.pageType then
		arg0_10.pages[arg0_10.pageType]:ExecuteAction("DormUpdated", arg1_10)
	end
end

function var0_0.FurnituresUpdated(arg0_11, arg1_11)
	if arg0_11.pageType then
		arg0_11.pages[arg0_11.pageType]:ExecuteAction("FurnituresUpdated", arg1_11)
	end
end

function var0_0.init(arg0_12)
	arg0_12.pageContainer = arg0_12._tf:Find("pages")
	arg0_12.adpter = arg0_12._tf:Find("adpter")
	arg0_12.btnTpl = arg0_12._tf:Find("adpter/tag/list/tpl")
	arg0_12.btnContainer = arg0_12._tf:Find("adpter/tag/list")
	arg0_12.backBtn = arg0_12._tf:Find("adpter/top/fanhui")
	arg0_12.goldTxt = arg0_12._tf:Find("adpter/top/res_gold/Text"):GetComponent(typeof(Text))
	arg0_12.gemTxt = arg0_12._tf:Find("adpter/top/res_gem/Text"):GetComponent(typeof(Text))
	arg0_12.goldAddBtn = arg0_12._tf:Find("adpter/top/res_gold/jiahao")
	arg0_12.gemAddBtn = arg0_12._tf:Find("adpter/top/res_gem/jiahao")
	arg0_12.help = arg0_12._tf:Find("adpter/top/help")
	arg0_12.themePage = BackYardThemePage.New(arg0_12.pageContainer, arg0_12.event, arg0_12.contextData)
	arg0_12.furniturePage = BackYardFurniturePage.New(arg0_12.pageContainer, arg0_12.event, arg0_12.contextData)
	arg0_12.contextData.filterPanel = BackYardShopFilterPanel.New(arg0_12._tf, arg0_12.event, arg0_12.contextData)
	arg0_12.pages = {
		[var1_0] = arg0_12.themePage,
		[var2_0] = arg0_12.furniturePage,
		[var3_0] = arg0_12.furniturePage,
		[var4_0] = arg0_12.furniturePage,
		[var5_0] = arg0_12.furniturePage,
		[var6_0] = arg0_12.furniturePage,
		[var7_0] = arg0_12.furniturePage
	}
	arg0_12.contextData.furnitureMsgBox = BackYardFurnitureMsgBoxPage.New(arg0_12._tf, arg0_12.event)
	arg0_12.contextData.themeMsgBox = BackYardThemeMsgBoxPage.New(arg0_12._tf, arg0_12.event)
	arg0_12.contextData.themeAllMsgBox = BackYardThemeMsgBoxForAllPage.New(arg0_12._tf, arg0_12.event)
end

function var0_0.didEnter(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		if arg0_13.contextData.onDeattch then
			arg0_13.contextData.onDeattch()
		end

		arg0_13:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.help, function()
		arg0_13:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.goldAddBtn, function()
		arg0_13:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.gemAddBtn, function()
		arg0_13:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
	arg0_13:InitPageFooter()
	arg0_13:UpdateRes()

	local var0_13 = arg0_13.contextData.page or var1_0

	triggerButton(arg0_13.btns[var0_13])

	if arg0_13.contextData.topLayer then
		local var1_13 = GetOrAddComponent(arg0_13._tf, typeof(Canvas))

		var1_13.overrideSorting = true
		var1_13.sortingOrder = 900

		GetOrAddComponent(arg0_13._tf, typeof(GraphicRaycaster))
	end

	getProxy(SettingsProxy):UpdateNewThemeValue()
end

function var0_0.UpdateRes(arg0_18)
	arg0_18.goldTxt.text = arg0_18.player:getResource(PlayerConst.ResDormMoney)
	arg0_18.gemTxt.text = arg0_18.player:getTotalGem()
end

local var11_0 = {
	"0",
	"1",
	"4",
	"2",
	"8",
	"3",
	"6",
	"7"
}

function var0_0.InitPageFooter(arg0_19)
	arg0_19.btns = {}

	for iter0_19, iter1_19 in ipairs(arg0_19.pages) do
		local var0_19 = cloneTplTo(arg0_19.btnTpl, arg0_19.btnContainer)
		local var1_19 = var0_19:Find("unsel"):GetComponent(typeof(Image))

		var1_19.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tag" .. iter0_19 - 1)

		var1_19:SetNativeSize()

		local var2_19 = var0_19:Find("sel/Text"):GetComponent(typeof(Image))

		var2_19.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "text_tag" .. iter0_19 - 1)

		var2_19:SetNativeSize()

		local var3_19 = var11_0[iter0_19]
		local var4_19 = var0_19:Find("sel/icon"):GetComponent(typeof(Image))

		LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "icon_" .. var3_19, function(arg0_20)
			if arg0_19.exited then
				return
			end

			var4_19.sprite = arg0_20
		end)
		var10_0(arg0_19, var0_19, function()
			if arg0_19.pageType == iter0_19 then
				return
			end

			if arg0_19.pageType and not arg0_19.pages[arg0_19.pageType]:GetLoaded() then
				return
			end

			if arg0_19.pageType and arg0_19.pages[arg0_19.pageType] ~= iter1_19 then
				arg0_19.pages[arg0_19.pageType]:Hide()
			end

			iter1_19:ExecuteAction("SetUp", iter0_19, arg0_19.dorm, arg0_19.player, function()
				return
			end)

			arg0_19.pageType = iter0_19

			if iter0_19 == 5 then
				getProxy(SettingsProxy):UpdateNewGemFurnitureValue()
				arg0_19:UpdateSpecialPageFooter()
			end

			return true
		end)

		arg0_19.btns[iter0_19] = var0_19
	end

	arg0_19:UpdateSpecialPageFooter()
	setActive(arg0_19.btnTpl, false)
end

function var0_0.getResource(arg0_23, arg1_23)
	local var0_23 = var0_0.super.getResource(arg0_23, arg1_23)
	local var1_23 = {}

	for iter0_23, iter1_23 in ipairs(var0_23) do
		var1_23[iter1_23] = true
	end

	local var2_23 = pg.furniture_shop_template.all

	for iter2_23, iter3_23 in ipairs(var2_23) do
		local var3_23 = pg.furniture_shop_template[iter3_23]

		if pg.TimeMgr.GetInstance():inTime(var3_23.time) then
			local var4_23 = pg.furniture_data_template[iter3_23].icon
			local var5_23 = pg.furniture_data_template[iter3_23].picture
			local var6_23 = "furnitrues/" .. var5_23
			local var7_23 = "furnitureicon/" .. var4_23

			if var7_23 ~= "furnitureicon/" and not var1_23[var7_23] then
				var1_23[var7_23] = true

				table.insert(var0_23, var7_23)
			end

			local var8_23 = pg.furniture_data_template[iter3_23].type
			local var9_23 = pg.furniture_data_template[iter3_23].tag
			local var10_23 = pg.furniture_data_template[iter3_23].spine

			if var6_23 == "furnitrues/" then
				-- block empty
			elseif var8_23 == 1 and var9_23 == 3 then
				for iter4_23 = 1, 4 do
					if not var1_23[var6_23 .. iter4_23] then
						var1_23[var6_23 .. iter4_23] = true

						table.insert(var0_23, var6_23 .. iter4_23)
					end
				end
			elseif var10_23 and var10_23 ~= "" then
				local var11_23
				local var12_23

				if var10_23[1] and #var10_23[1] > 0 and type(var10_23[1][1]) == "string" then
					var11_23 = "sfurniture/" .. var10_23[1][1]
				end

				if var10_23[2] and #var10_23[2] > 0 and type(var10_23[2][1]) == "string" then
					var12_23 = "sfurniture/" .. var10_23[2][1]
				end

				if var11_23 and not var1_23[var11_23] then
					var1_23[var11_23] = true

					table.insert(var0_23, var11_23)
				end

				if var12_23 and not var1_23[var12_23] then
					var1_23[var12_23] = true

					table.insert(var0_23, var12_23)
				end
			elseif not var1_23[var6_23] then
				var1_23[var6_23] = true

				table.insert(var0_23, var6_23)
			end
		end
	end

	local var13_23 = getProxy(DormProxy):GetSystemThemes()

	for iter5_23, iter6_23 in ipairs(var13_23) do
		if iter6_23:getConfig("is_view") == 1 and not iter6_23:IsOverTime() then
			local var14_23 = iter6_23.id
			local var15_23 = pg.backyard_theme_template[var14_23].icon
			local var16_23 = "furnitureicon/" .. var15_23

			if not var1_23[var16_23] then
				var1_23[var16_23] = true

				table.insert(var0_23, var16_23)
			end

			local var17_23 = "backyardtheme/theme_" .. var14_23

			if not var1_23[var17_23] then
				var1_23[var17_23] = true

				table.insert(var0_23, var17_23)
			end

			local var18_23 = "backyardtheme/" .. var14_23

			if not var1_23[var18_23] then
				var1_23[var18_23] = true

				table.insert(var0_23, var18_23)
			end
		end
	end

	return var0_23
end

function var0_0.UpdateSpecialPageFooter(arg0_24)
	local var0_24 = arg0_24.btns[5]

	setActive(var0_24:Find("new"), getProxy(SettingsProxy):IsTipNewGemFurniture())
end

function var0_0.willExit(arg0_25)
	arg0_25.isOverlay = false

	arg0_25.contextData.filterPanel:Destroy()
	arg0_25.themePage:Destroy()
	arg0_25.furniturePage:Destroy()
	arg0_25.contextData.furnitureMsgBox:Destroy()

	arg0_25.contextData.furnitureMsgBox = nil

	arg0_25.contextData.themeMsgBox:Destroy()

	arg0_25.contextData.themeMsgBox = nil
end

return var0_0

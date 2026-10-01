local var0_0 = class("WorldCruiseScene", import("view.base.BaseUI"))

var0_0.optionsPath = {
	"top/home"
}
var0_0.PAGE_AWARD = "award"
var0_0.PAGE_TASK = "task"
var0_0.PAGE_SHOP = "shop"

local var1_0 = var0_0.PAGE_AWARD

function var0_0.getUIName(arg0_1)
	return "WorldCruiseUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/WorldCruiseUI",
		"ui/WorldCruiseAwardPage",
		"ui/WorldCruiseTaskPage",
		"ui/WorldCruiseShopPage",
		"ui/iconcolorful",
		"ui/worldcruiseui_atlas",
		"ui/item_duang5",
		"weaponframes"
	}
	local var1_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	local function var2_2()
		local var0_3 = {}
		local var1_3 = pg.battlepass_event_pt[var1_2.id]

		if var1_3 then
			if noEmptyStr(var1_3.bg) then
				table.insert(var0_3, ResPathSupport.CombinePath(ResPathSupport.ConstPath.BG.Base, var1_3.bg))
			end

			if noEmptyStr(var1_3.bg_tips) then
				table.insert(var0_3, ResPathSupport.CombinePath(ResPathSupport.ConstPath.BG.Base, var1_3.bg_tips))
			end
		end

		return var0_3
	end

	local function var3_2(arg0_4)
		if not arg0_4 or arg0_4.type ~= DROP_TYPE_SKIN then
			return {}
		end

		local var0_4 = pg.ship_skin_template[arg0_4.id]

		return ResPathSupport.GetPaintingSquareIconListByPaintingName(var0_4.painting)
	end

	local function var4_2(arg0_5)
		if not arg0_5 or arg0_5.type ~= DROP_TYPE_SKIN then
			return {}
		end

		local var0_5 = pg.ship_skin_template[arg0_5.id]
		local var1_5 = ResPathSupport.GetPaintingListByPaintingName(var0_5.painting)
		local var2_5 = ResPathSupport.GetPaintingFaceListByPaintingName(var0_5.painting)

		return ResPathSupport.MergeLuaArr(var1_5, var2_5)
	end

	local function var5_2()
		local var0_6 = {}
		local var1_6 = var1_2:GetCrusingInfo()

		for iter0_6, iter1_6 in ipairs(var1_6.awardList or {}) do
			local var2_6 = {
				iter1_6.award,
				iter1_6.award_pay
			}

			for iter2_6, iter3_6 in ipairs(var2_6) do
				if iter3_6 then
					local var3_6 = Drop.Create(iter3_6)

					if var3_6.type == DROP_TYPE_SKIN then
						table.insertto(var0_6, var3_2(var3_6))
					end
				end
			end
		end

		return var0_6
	end

	local function var6_2()
		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(var1_2:getConfig("config_data") or {}) do
			local var1_7 = pg.battlepass_task_group[iter1_7]

			if var1_7 then
				for iter2_7, iter3_7 in ipairs(var1_7.task_group or {}) do
					for iter4_7, iter5_7 in ipairs(iter3_7 or {}) do
						local var2_7 = pg.task_data_template[iter5_7]
						local var3_7 = var2_7 and var2_7.award_display and var2_7.award_display[1]
						local var4_7 = Drop.Create(var3_7)

						if var4_7.type == DROP_TYPE_SKIN then
							table.insertto(var0_7, var3_2(var4_7))
						end
					end
				end
			end
		end

		return var0_7
	end

	local function var7_2()
		local var0_8 = {}
		local var1_8 = {
			ShopArgs.CruiseSkin
		}
		local var2_8 = pg.TimeMgr.GetInstance()

		for iter0_8, iter1_8 in ipairs(var1_8) do
			for iter2_8, iter3_8 in ipairs(pg.shop_template.get_id_list_by_genre[iter1_8] or {}) do
				local var3_8 = pg.shop_template[iter3_8]

				if var3_8 and var2_8:inTime(var3_8.time) then
					local var4_8 = Goods.Create({
						groupCount = 0,
						buy_count = 0,
						shop_id = iter3_8
					}, Goods.TYPE_CRUISE):getDropInfo()

					if var4_8 and var4_8.type == DROP_TYPE_SKIN then
						table.insertto(var0_8, var4_2(var4_8))
					end
				end
			end
		end

		return var0_8
	end

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var2_2(), var5_2(), var6_2(), var7_2())
end

function var0_0.preload(arg0_9, arg1_9)
	local var0_9 = getProxy(ShopsProxy)

	local function var1_9()
		local var0_10 = var0_9:GetNormalList()
		local var1_10 = var0_9:GetNormalGroupList()

		arg0_9.shop = CruiseShop.New(var0_10, var1_10)

		var0_9:SetCruiseShop(arg0_9.shop)
		arg1_9()
	end

	if var0_9:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1_9
		})
	else
		var1_9()
	end
end

function var0_0.setShop(arg0_11, arg1_11)
	arg0_11.shop = arg1_11
end

function var0_0.setPlayer(arg0_12, arg1_12)
	arg0_12.player = arg1_12
end

function var0_0.setActivity(arg0_13, arg1_13)
	arg0_13.activity = arg1_13

	for iter0_13, iter1_13 in pairs(arg1_13:GetCrusingInfo()) do
		arg0_13[iter0_13] = iter1_13
	end

	arg0_13.contextData.phase = arg0_13.phase
end

function var0_0.init(arg0_14)
	arg0_14.topUI = arg0_14._tf:Find("top")
	arg0_14.titleTF = arg0_14.topUI:Find("title/Text")
	arg0_14.helpBtn = arg0_14.topUI:Find("help")
	arg0_14.gemResBtn = arg0_14.topUI:Find("res/gem")
	arg0_14.gemValue = arg0_14.gemResBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_14.ticketResBtn = arg0_14.topUI:Find("res/ticket")
	arg0_14.ticketValue = arg0_14.ticketResBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_14.dayTxt = arg0_14.topUI:Find("day/Text"):GetComponent(typeof(Text))
	arg0_14.phaseTF = arg0_14._tf:Find("frame/phase")

	setText(arg0_14.phaseTF:Find("progress"), i18n("cruise_phase_title"))

	arg0_14.pages = {
		[var0_0.PAGE_AWARD] = WorldCruiseAwardPage.New(arg0_14._tf:Find("frame/award_container"), arg0_14.event, arg0_14.contextData),
		[var0_0.PAGE_TASK] = WorldCruiseTaskPage.New(arg0_14._tf:Find("frame/task_container"), arg0_14.event, arg0_14.contextData),
		[var0_0.PAGE_SHOP] = WorldCruiseShopPage.New(arg0_14._tf:Find("frame/shop_container"), arg0_14.event, arg0_14.contextData)
	}
	arg0_14.togglesTF = arg0_14._tf:Find("frame/toggles")

	eachChild(arg0_14.togglesTF, function(arg0_15)
		onButton(arg0_14, arg0_15, function()
			arg0_14.contextData.page = arg0_15.name

			arg0_14:SwitchPage()
		end, SFX_PANEL)
	end)

	local var0_14 = #arg0_14.shop:GetCommodities() == 0
	local var1_14 = arg0_14.togglesTF:Find("shop")

	if var0_14 then
		onButton(arg0_14, var1_14, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("cruise_shop_no_open"))
		end, SFX_PANEL)
	end

	setActive(var1_14:Find("lock"), var0_14)
	setText(var1_14:Find("lock/Text"), i18n("cruise_shop_no_open"))

	arg0_14.contextData.windowForCharge = WorldCruiseChargePage.New(arg0_14._tf, arg0_14.event)
	arg0_14.contextData.prevChargePage = WorldCruiseChargePage4PrevPeriod.New(arg0_14._tf, arg0_14.event)

	arg0_14:Hx4Channel()
end

function var0_0.didEnter(arg0_18)
	local var0_18 = pg.battlepass_event_pt[arg0_18.activity.id]

	LoadImageSpriteAtlasAsync("bg/" .. var0_18.bg, "", arg0_18._tf:Find("bg/bg_1"), true)

	local var1_18 = arg0_18._tf:Find("bg/bg_2")

	if var0_18.bg_tips ~= "" then
		LoadImageSpriteAtlasAsync("bg/" .. var0_18.bg_tips, "", var1_18, true)
		setActive(var1_18, true)
	else
		setActive(var1_18, false)
	end

	onButton(arg0_18, arg0_18.topUI:Find("back"), function()
		arg0_18:closeView()
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.helpBtn, function()
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_HELP, {
			helps = i18n("battlepass_main_help_" .. pg.battlepass_event_pt[arg0_18.activity.id].map_name)
		})
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.gemResBtn, function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.ticketResBtn, function()
		shoppingBatchNewStyle(Goods.CRUISE_QUICK_TASK_TICKET_ID, {
			id = Item.QUICK_TASK_PASS_TICKET_ID
		}, 20, "build_ship_quickly_buy_stone")
	end, SFX_PANEL)

	local var2_18 = arg0_18.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	arg0_18.dayTxt.text = i18n("battlepass_main_time_title") .. i18n("battlepass_main_time", math.floor(var2_18 / 86400), math.floor(var2_18 % 86400 / 3600))

	arg0_18:UpdateRes()
	arg0_18:UpdatePhase()
	arg0_18:UpdateAwardTip()
	triggerButton(arg0_18.togglesTF:Find(arg0_18.contextData.page or var1_0))
end

function var0_0.UpdateRes(arg0_23)
	arg0_23.gemValue.text = arg0_23.player:getTotalGem()
	arg0_23.ticketValue.text = getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID)
end

function var0_0.UpdatePhase(arg0_24)
	setText(arg0_24.phaseTF:Find("Text"), "<size=27>lv.</size>" .. arg0_24.phase)

	if arg0_24.phase < #arg0_24.awardList then
		local var0_24 = arg0_24.phase == 0 and 0 or arg0_24.awardList[arg0_24.phase].pt
		local var1_24 = arg0_24.pt - var0_24
		local var2_24 = arg0_24.awardList[arg0_24.phase + 1].pt - var0_24

		setSlider(arg0_24.phaseTF:Find("slider"), 0, var2_24, var1_24)
		setText(arg0_24.phaseTF:Find("progress/Text"), var1_24 .. "/" .. var2_24)
	else
		setSlider(arg0_24.phaseTF:Find("slider"), 0, 1, 1)
		setText(arg0_24.phaseTF:Find("progress/Text"), "MAX")
	end

	arg0_24.contextData.phase = arg0_24.phase
end

function var0_0.OnChargeSuccess(arg0_25, arg1_25, arg2_25)
	if arg0_25.contextData.prevChargePage:GetLoaded() then
		arg0_25.contextData.prevChargePage:ExecuteAction("ShowUnlockWindow", arg1_25, arg2_25)
	else
		arg0_25.contextData.windowForCharge:ExecuteAction("ShowUnlockWindow", arg1_25, arg2_25)
	end
end

function var0_0.UpdateAwardTip(arg0_26)
	setActive(arg0_26.togglesTF:Find("award/tip"), #arg0_26.activity:GetCrusingUnreceiveAward() > 0)
end

function var0_0.SwitchPage(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.pages) do
		if iter0_27 == arg0_27.contextData.page then
			iter1_27:ExecuteAction("Flush")
		else
			iter1_27:ExecuteAction("Hide")
		end
	end

	eachChild(arg0_27.togglesTF, function(arg0_28)
		setActive(arg0_28:Find("unselected"), arg0_28.name ~= arg0_27.contextData.page)
		setActive(arg0_28:Find("selected"), arg0_28.name == arg0_27.contextData.page)
	end)

	local var0_27 = arg0_27.contextData.page == var0_0.PAGE_SHOP

	setActive(arg0_27._tf:Find("shop_bg"), var0_27)
	setActive(arg0_27.phaseTF, not var0_27)

	local var1_27 = pg.battlepass_event_pt[arg0_27.activity.id].map_name

	setText(arg0_27.titleTF, var0_27 and i18n("cruise_shop_title") or i18n("cruise_title_" .. var1_27))
end

function var0_0.UpdateView(arg0_29)
	arg0_29.pages[arg0_29.contextData.page]:ExecuteAction("Flush")
end

function var0_0.UpdateAwardPage(arg0_30)
	arg0_30:UpdateAwardTip()
	arg0_30.pages[var0_0.PAGE_AWARD]:ExecuteAction("UpdateActivity", arg0_30.activity)
end

function var0_0.UpdateTaskPage(arg0_31)
	arg0_31.pages[var0_0.PAGE_TASK]:ExecuteAction("UpdateActivity", arg0_31.activity)
end

function var0_0.UpdateShopPage(arg0_32)
	arg0_32.pages[var0_0.PAGE_SHOP]:ExecuteAction("UpdateShop", arg0_32.shop)
	arg0_32:UpdateView()
end

function var0_0.onBackPressed(arg0_33)
	if arg0_33.contextData.windowForCharge and arg0_33.contextData.windowForCharge:GetLoaded() and arg0_33.contextData.windowForCharge:isShowing() then
		arg0_33.contextData.windowForCharge:Hide()

		return
	end

	if arg0_33.contextData.prevChargePage and arg0_33.contextData.prevChargePage:GetLoaded() and arg0_33.contextData.prevChargePage:isShowing() then
		arg0_33.contextData.prevChargePage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_33)
end

function var0_0.willExit(arg0_34)
	if arg0_34.contextData.windowForCharge then
		arg0_34.contextData.windowForCharge:Destroy()

		arg0_34.contextData.windowForCharge = nil
	end

	if arg0_34.contextData.prevChargePage then
		arg0_34.contextData.prevChargePage:Destroy()

		arg0_34.contextData.prevChargePage = nil
	end

	for iter0_34, iter1_34 in pairs(arg0_34.pages) do
		iter1_34:Destroy()

		iter1_34 = nil
	end
end

local function var2_0(arg0_35)
	local var0_35 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()

	return (arg0_35._tf:Find("bg/bg_1/hx_ch" .. var0_35))
end

function var0_0.Hx4Channel(arg0_36)
	local var0_36 = var2_0(arg0_36)

	if not IsNil(var0_36) then
		setActive(var0_36, HXSet.isHx())
	end
end

return var0_0

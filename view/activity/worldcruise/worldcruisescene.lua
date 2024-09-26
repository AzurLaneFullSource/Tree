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

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ShopsProxy)

	local function var1_2()
		local var0_3 = var0_2:GetNormalList()
		local var1_3 = var0_2:GetNormalGroupList()

		arg0_2.shop = CruiseShop.New(var0_3, var1_3)

		var0_2:SetCruiseShop(arg0_2.shop)
		arg1_2()
	end

	if var0_2:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1_2
		})
	else
		var1_2()
	end
end

function var0_0.setShop(arg0_4, arg1_4)
	arg0_4.shop = arg1_4
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5
end

function var0_0.setActivity(arg0_6, arg1_6)
	arg0_6.activity = arg1_6

	for iter0_6, iter1_6 in pairs(arg1_6:GetCrusingInfo()) do
		arg0_6[iter0_6] = iter1_6
	end

	arg0_6.contextData.phase = arg0_6.phase
end

function var0_0.init(arg0_7)
	arg0_7.topUI = arg0_7._tf:Find("top")
	arg0_7.titleTF = arg0_7.topUI:Find("title/Text")
	arg0_7.helpBtn = arg0_7.topUI:Find("help")
	arg0_7.gemResBtn = arg0_7.topUI:Find("res/gem")
	arg0_7.gemValue = arg0_7.gemResBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_7.ticketResBtn = arg0_7.topUI:Find("res/ticket")
	arg0_7.ticketValue = arg0_7.ticketResBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_7.dayTxt = arg0_7.topUI:Find("day/Text"):GetComponent(typeof(Text))
	arg0_7.phaseTF = arg0_7._tf:Find("frame/phase")

	setText(arg0_7.phaseTF:Find("progress"), i18n("cruise_phase_title"))

	arg0_7.pages = {
		[var0_0.PAGE_AWARD] = WorldCruiseAwardPage.New(arg0_7._tf:Find("frame/award_container"), arg0_7.event),
		[var0_0.PAGE_TASK] = WorldCruiseTaskPage.New(arg0_7._tf:Find("frame/task_container"), arg0_7.event, arg0_7.contextData),
		[var0_0.PAGE_SHOP] = WorldCruiseShopPage.New(arg0_7._tf:Find("frame/shop_container"), arg0_7.event, arg0_7.contextData)
	}
	arg0_7.togglesTF = arg0_7._tf:Find("frame/toggles")

	eachChild(arg0_7.togglesTF, function(arg0_8)
		onButton(arg0_7, arg0_8, function()
			arg0_7.contextData.page = arg0_8.name

			arg0_7:SwitchPage()
		end, SFX_PANEL)
	end)

	local var0_7 = #arg0_7.shop:GetCommodities() == 0
	local var1_7 = arg0_7.togglesTF:Find("shop")

	if var0_7 then
		onButton(arg0_7, var1_7, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("cruise_shop_no_open"))
		end, SFX_PANEL)
	end

	setActive(var1_7:Find("lock"), var0_7)
	setText(var1_7:Find("lock/Text"), i18n("cruise_shop_no_open"))

	arg0_7.chargeTipWindow = ChargeTipWindow.New(arg0_7._tf, arg0_7.event)
	arg0_7.contextData.windowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_7._tf, arg0_7.event)
end

function var0_0.didEnter(arg0_11)
	LoadImageSpriteAtlasAsync("bg/" .. pg.battlepass_event_pt[arg0_11.activity.id].bg, "", arg0_11._tf:Find("bg"), true)
	onButton(arg0_11, arg0_11.topUI:Find("title/back"), function()
		arg0_11:closeView()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("battlepass_main_help_" .. pg.battlepass_event_pt[arg0_11.activity.id].map_name)
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.gemResBtn, function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.ticketResBtn, function()
		shoppingBatch(61017, {
			id = Item.QUICK_TASK_PASS_TICKET_ID
		}, 20, "build_ship_quickly_buy_stone")
	end, SFX_PANEL)

	local var0_11 = arg0_11.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	arg0_11.dayTxt.text = i18n("battlepass_main_time_title") .. i18n("battlepass_main_time", math.floor(var0_11 / 86400), math.floor(var0_11 % 86400 / 3600))

	arg0_11:UpdateRes()
	arg0_11:UpdatePhase()
	arg0_11:UpdateAwardTip()
	triggerButton(arg0_11.togglesTF:Find(arg0_11.contextData.page or var1_0))
end

function var0_0.UpdateRes(arg0_16)
	arg0_16.gemValue.text = arg0_16.player:getTotalGem()
	arg0_16.ticketValue.text = getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID)
end

function var0_0.UpdatePhase(arg0_17)
	setText(arg0_17.phaseTF:Find("Text"), "<size=27>lv.</size>" .. arg0_17.phase)

	if arg0_17.phase < #arg0_17.awardList then
		local var0_17 = arg0_17.phase == 0 and 0 or arg0_17.awardList[arg0_17.phase].pt
		local var1_17 = arg0_17.pt - var0_17
		local var2_17 = arg0_17.awardList[arg0_17.phase + 1].pt - var0_17

		setSlider(arg0_17.phaseTF:Find("slider"), 0, var2_17, var1_17)
		setText(arg0_17.phaseTF:Find("progress/Text"), var1_17 .. "/" .. var2_17)
	else
		setSlider(arg0_17.phaseTF:Find("slider"), 0, 1, 1)
		setText(arg0_17.phaseTF:Find("progress/Text"), "MAX")
	end

	arg0_17.contextData.phase = arg0_17.phase
end

function var0_0.OnChargeSuccess(arg0_18, arg1_18)
	arg0_18.chargeTipWindow:ExecuteAction("Show", arg1_18)
end

function var0_0.UpdateAwardTip(arg0_19)
	setActive(arg0_19.togglesTF:Find("award/tip"), #arg0_19.activity:GetCrusingUnreceiveAward() > 0)
end

function var0_0.SwitchPage(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.pages) do
		if iter0_20 == arg0_20.contextData.page then
			iter1_20:ExecuteAction("Flush")
		else
			iter1_20:ExecuteAction("Hide")
		end
	end

	eachChild(arg0_20.togglesTF, function(arg0_21)
		setActive(arg0_21:Find("unselected"), arg0_21.name ~= arg0_20.contextData.page)
		setActive(arg0_21:Find("selected"), arg0_21.name == arg0_20.contextData.page)
	end)

	local var0_20 = arg0_20.contextData.page == var0_0.PAGE_SHOP

	setActive(arg0_20._tf:Find("shop_bg"), var0_20)
	setActive(arg0_20.phaseTF, not var0_20)

	local var1_20 = pg.battlepass_event_pt[arg0_20.activity.id].map_name

	setText(arg0_20.titleTF, var0_20 and i18n("cruise_shop_title") or i18n("cruise_title_" .. var1_20))
end

function var0_0.UpdateView(arg0_22)
	arg0_22.pages[arg0_22.contextData.page]:ExecuteAction("Flush")
end

function var0_0.UpdateAwardPage(arg0_23)
	arg0_23:UpdateAwardTip()
	arg0_23.pages[var0_0.PAGE_AWARD]:ExecuteAction("UpdateActivity", arg0_23.activity)
	arg0_23:UpdateView()
end

function var0_0.UpdateTaskPage(arg0_24)
	arg0_24.pages[var0_0.PAGE_TASK]:ExecuteAction("UpdateActivity", arg0_24.activity)
	arg0_24:UpdateView()
end

function var0_0.UpdateShopPage(arg0_25)
	arg0_25.pages[var0_0.PAGE_SHOP]:ExecuteAction("UpdateShop", arg0_25.shop)
	arg0_25:UpdateView()
end

function var0_0.willExit(arg0_26)
	if arg0_26.chargeTipWindow then
		arg0_26.chargeTipWindow:Destroy()

		arg0_26.chargeTipWindow = nil
	end

	if arg0_26.contextData.windowForESkin then
		arg0_26.contextData.windowForESkin:Destroy()

		arg0_26.contextData.windowForESkin = nil
	end

	for iter0_26, iter1_26 in pairs(arg0_26.pages) do
		iter1_26:Destroy()

		iter1_26 = nil
	end
end

return var0_0

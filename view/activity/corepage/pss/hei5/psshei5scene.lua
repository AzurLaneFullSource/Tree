local var0_0 = class("PSSHei5Scene", import("view.base.BaseUI"))

var0_0.optionsPath = {
	"top/home"
}
var0_0.PAGE_AWARD = "award"
var0_0.PAGE_TASK = "task"

local var1_0 = var0_0.PAGE_AWARD

function var0_0.getUIName(arg0_1)
	return "PSSHei5UI"
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2

	for iter0_2, iter1_2 in pairs(arg1_2:GetHei5Info()) do
		arg0_2[iter0_2] = iter1_2
	end

	arg0_2.contextData.phase = arg0_2.phase
end

function var0_0.init(arg0_3)
	arg0_3.topUI = arg0_3._tf:Find("top")
	arg0_3.titleTF = arg0_3.topUI:Find("title/Text")
	arg0_3.helpBtn = arg0_3.topUI:Find("help")
	arg0_3.dayTxt = arg0_3.topUI:Find("day/Text"):GetComponent(typeof(Text))
	arg0_3.phaseTF = arg0_3._tf:Find("frame/phase")
	arg0_3.frame = arg0_3._tf:Find("frame")
	arg0_3.btnPay = arg0_3._tf:Find("frame/phase/btn_pay")
	arg0_3.item = arg0_3.frame:Find("phase/award/tpl")
	arg0_3.items = arg0_3.frame:Find("phase/award")
	arg0_3.itemList = UIItemList.New(arg0_3.items, arg0_3.item)

	setActive(arg0_3.item, false)
	setText(arg0_3.frame:Find("toggles/award/selected/Text"), i18n("blackfriday_battlepass_rewards"))
	setText(arg0_3.frame:Find("toggles/award/unselected/Text"), i18n("blackfriday_battlepass_rewards"))
	setText(arg0_3.frame:Find("toggles/task/selected/Text"), i18n("blackfriday_battlepass_mission"))
	setText(arg0_3.frame:Find("toggles/task/unselected/Text"), i18n("blackfriday_battlepass_mission"))

	arg0_3.pages = {
		[var0_0.PAGE_AWARD] = PSSHei5AwardPage.New(arg0_3._tf:Find("frame/award_container"), arg0_3.event, arg0_3.contextData),
		[var0_0.PAGE_TASK] = PSSHei5TaskPage.New(arg0_3._tf:Find("frame/task_container"), arg0_3.event, arg0_3.contextData)
	}
	arg0_3.togglesTF = arg0_3._tf:Find("frame/toggles")

	eachChild(arg0_3.togglesTF, function(arg0_4)
		onButton(arg0_3, arg0_4, function()
			arg0_3.contextData.page = arg0_4.name

			arg0_3:SwitchPage()
		end, SFX_PANEL)
	end)

	arg0_3.contextData.windowForCharge = PSSCruiseChargePage.New(arg0_3._tf, arg0_3.event)
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.topUI:Find("title/back"), function()
		arg0_6:closeView()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_HELP, {
			helps = i18n("blackfriday_battlepass_main_help_" .. pg.black_friday_battlepass_event_pt[arg0_6.activity.id].map_name)
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnPay, function()
		arg0_6.contextData.windowForCharge:ExecuteAction("ShowBuyWindow")
	end, SFX_CONFIRM)

	local var0_6 = arg0_6.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	arg0_6.dayTxt.text = i18n("blackfriday_battlepass_main_time_title") .. i18n("battlepass_main_time", math.floor(var0_6 / 86400), math.floor(var0_6 % 86400 / 3600))

	arg0_6:UpdatePhase()
	arg0_6:UpdateAwardTip()
	triggerButton(arg0_6.togglesTF:Find(arg0_6.contextData.page or var1_0))
	arg0_6:SetAward()
end

function var0_0.SetAward(arg0_10)
	arg0_10.config_client = arg0_10.activity:getConfig("config_client")[2]
	arg0_10.taskProxy = getProxy(TaskProxy)

	arg0_10.itemList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			local var0_11 = arg2_11:Find("item")
			local var1_11 = Drop.Create({
				arg0_10.config_client[arg1_11 + 1][1],
				arg0_10.config_client[arg1_11 + 1][2],
				arg0_10.config_client[arg1_11 + 1][3]
			})

			updateDrop(var0_11, var1_11)
			onButton(arg0_10, arg2_11, function()
				arg0_10:emit(BaseUI.ON_DROP, var1_11)
			end, SFX_PANEL)
		end
	end)
	arg0_10.itemList:align(#arg0_10.config_client)
end

function var0_0.UpdatePhase(arg0_13)
	setText(arg0_13.phaseTF:Find("Text"), arg0_13.phase)

	if arg0_13.phase < #arg0_13.awardList then
		local var0_13 = arg0_13.phase == 0 and 0 or arg0_13.awardList[arg0_13.phase].pt
		local var1_13 = arg0_13.pt - var0_13
		local var2_13 = arg0_13.awardList[arg0_13.phase + 1].pt - var0_13

		arg0_13.phaseTF:Find("slider"):GetComponent(typeof(Image)).fillAmount = var1_13 / var2_13

		setText(arg0_13.phaseTF:Find("progress/progress1"), var1_13)
		setText(arg0_13.phaseTF:Find("progress/progress2"), "/" .. var2_13)
	else
		arg0_13.phaseTF:Find("slider"):GetComponent(typeof(Image)).fillAmount = 1

		setText(arg0_13.phaseTF:Find("progress/progress1"), "MAX")
		setActive(arg0_13.phaseTF:Find("progress/progress2"), false)
	end

	arg0_13.contextData.phase = arg0_13.phase

	setActive(arg0_13.btnPay, not arg0_13.isPay)

	if not arg0_13.isPay then
		local var3_13 = PSSCruiseChargePage.GetPassID()

		if not pg.TimeMgr.GetInstance():inTime(pg.pay_data_display[var3_13].time) then
			setActive(arg0_13.btnPay, false)
		end
	end

	setText(arg0_13.titleTF, i18n("activity_ninjia_main_title"))
end

function var0_0.OnChargeSuccess(arg0_14, arg1_14)
	arg0_14.contextData.windowForCharge:ExecuteAction("ShowUnlockWindow", arg1_14)
end

function var0_0.UpdateAwardTip(arg0_15)
	setActive(arg0_15.togglesTF:Find("award/tip"), #arg0_15.activity:GetHei5UnreceiveAward() > 0)
end

function var0_0.SwitchPage(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.pages) do
		if iter0_16 == arg0_16.contextData.page then
			iter1_16:ExecuteAction("Flush")
		else
			iter1_16:ExecuteAction("Hide")
		end
	end

	eachChild(arg0_16.togglesTF, function(arg0_17)
		setActive(arg0_17:Find("unselected"), arg0_17.name ~= arg0_16.contextData.page)
		setActive(arg0_17:Find("selected"), arg0_17.name == arg0_16.contextData.page)
	end)

	local var0_16

	var0_16 = arg0_16.contextData.page == var0_0.PAGE_SHOP
end

function var0_0.UpdateView(arg0_18)
	arg0_18.pages[arg0_18.contextData.page]:ExecuteAction("Flush")
end

function var0_0.UpdateAwardPage(arg0_19)
	arg0_19:UpdateAwardTip()
	arg0_19.pages[var0_0.PAGE_AWARD]:ExecuteAction("UpdateActivity", arg0_19.activity)
end

function var0_0.UpdateTaskPage(arg0_20)
	arg0_20.pages[var0_0.PAGE_TASK]:ExecuteAction("UpdateActivity", arg0_20.activity)
end

function var0_0.onBackPressed(arg0_21)
	if arg0_21.contextData.windowForCharge and arg0_21.contextData.windowForCharge:GetLoaded() and arg0_21.contextData.windowForCharge:isShowing() then
		arg0_21.contextData.windowForCharge:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_21)
end

function var0_0.willExit(arg0_22)
	return
end

return var0_0

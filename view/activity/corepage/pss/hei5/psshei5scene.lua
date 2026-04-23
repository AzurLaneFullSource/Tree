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

function var0_0.initTplVar(arg0_3)
	arg0_3.helpBtnTip = "blackfriday_battlepass_main_help_" .. pg.black_friday_battlepass_event_pt[arg0_3.activity.id].map_name
	arg0_3.awardPageCls = PSSHei5AwardPage
	arg0_3.taskPageCls = PSSHei5TaskPage
	arg0_3.chargePageCls = PSSCruiseChargePage
	arg0_3.dayTextTip = "blackfriday_battlepass_main_time_title"
	arg0_3.titleTextTip = "activity_ninjia_main_title"
	arg0_3.rewardTip = "blackfriday_battlepass_rewards"
	arg0_3.missionTip = "blackfriday_battlepass_mission"
end

function var0_0.init(arg0_4)
	arg0_4:initTplVar()

	arg0_4.topUI = arg0_4._tf:Find("top")
	arg0_4.titleTF = arg0_4.topUI:Find("title/Text")
	arg0_4.helpBtn = arg0_4.topUI:Find("help")
	arg0_4.dayTxt = arg0_4.topUI:Find("day/Text"):GetComponent(typeof(Text))
	arg0_4.phaseTF = arg0_4._tf:Find("frame/phase")
	arg0_4.frame = arg0_4._tf:Find("frame")
	arg0_4.btnPay = arg0_4._tf:Find("frame/phase/btn_pay")
	arg0_4.item = arg0_4.frame:Find("phase/award/tpl")
	arg0_4.items = arg0_4.frame:Find("phase/award")
	arg0_4.itemList = UIItemList.New(arg0_4.items, arg0_4.item)

	setActive(arg0_4.item, false)
	setText(arg0_4.frame:Find("toggles/award/selected/Text"), i18n(arg0_4.rewardTip))
	setText(arg0_4.frame:Find("toggles/award/unselected/Text"), i18n(arg0_4.rewardTip))
	setText(arg0_4.frame:Find("toggles/task/selected/Text"), i18n(arg0_4.missionTip))
	setText(arg0_4.frame:Find("toggles/task/unselected/Text"), i18n(arg0_4.missionTip))

	arg0_4.pages = {
		[var0_0.PAGE_AWARD] = arg0_4.awardPageCls.New(arg0_4._tf:Find("frame/award_container"), arg0_4.event, arg0_4.contextData),
		[var0_0.PAGE_TASK] = arg0_4.taskPageCls.New(arg0_4._tf:Find("frame/task_container"), arg0_4.event, arg0_4.contextData)
	}
	arg0_4.togglesTF = arg0_4._tf:Find("frame/toggles")

	eachChild(arg0_4.togglesTF, function(arg0_5)
		onButton(arg0_4, arg0_5, function()
			arg0_4.contextData.page = arg0_5.name

			arg0_4:SwitchPage()
		end, SFX_PANEL)
	end)

	arg0_4.contextData.windowForCharge = arg0_4.chargePageCls.New(arg0_4._tf, arg0_4.event)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.topUI:Find("title/back"), function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_HELP, {
			helps = i18n(arg0_7.helpBtnTip)
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.btnPay, function()
		arg0_7.contextData.windowForCharge:ExecuteAction("ShowBuyWindow")
	end, SFX_CONFIRM)

	local var0_7 = arg0_7.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	arg0_7.dayTxt.text = i18n(arg0_7.dayTextTip) .. i18n("battlepass_main_time", math.floor(var0_7 / 86400), math.floor(var0_7 % 86400 / 3600))

	arg0_7:UpdatePhase()
	arg0_7:UpdateAwardTip()
	triggerButton(arg0_7.togglesTF:Find(arg0_7.contextData.page or var1_0))
	arg0_7:SetAward()
end

function var0_0.SetAward(arg0_11)
	arg0_11.config_client = arg0_11.activity:getConfig("config_client")[2]
	arg0_11.taskProxy = getProxy(TaskProxy)

	arg0_11.itemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventInit then
			local var0_12 = arg2_12:Find("item")
			local var1_12 = Drop.Create({
				arg0_11.config_client[arg1_12 + 1][1],
				arg0_11.config_client[arg1_12 + 1][2],
				arg0_11.config_client[arg1_12 + 1][3]
			})

			updateDrop(var0_12, var1_12)
			onButton(arg0_11, arg2_12, function()
				arg0_11:emit(BaseUI.ON_NEW_STYLE_DROP, {
					drop = var1_12
				})
			end, SFX_PANEL)
		end
	end)
	arg0_11.itemList:align(#arg0_11.config_client)
end

function var0_0.UpdatePhase(arg0_14)
	setText(arg0_14.phaseTF:Find("Text"), arg0_14.phase)

	if arg0_14.phase < #arg0_14.awardList then
		local var0_14 = arg0_14.phase == 0 and 0 or arg0_14.awardList[arg0_14.phase].pt
		local var1_14 = arg0_14.pt - var0_14
		local var2_14 = arg0_14.awardList[arg0_14.phase + 1].pt - var0_14

		arg0_14.phaseTF:Find("slider"):GetComponent(typeof(Image)).fillAmount = var1_14 / var2_14

		setText(arg0_14.phaseTF:Find("progress/progress1"), var1_14)
		setText(arg0_14.phaseTF:Find("progress/progress2"), "/" .. var2_14)
	else
		arg0_14.phaseTF:Find("slider"):GetComponent(typeof(Image)).fillAmount = 1

		setText(arg0_14.phaseTF:Find("progress/progress1"), "MAX")
		setActive(arg0_14.phaseTF:Find("progress/progress2"), false)
	end

	arg0_14.contextData.phase = arg0_14.phase

	setActive(arg0_14.btnPay, not arg0_14.isPay)

	if not arg0_14.isPay then
		local var3_14 = arg0_14.chargePageCls.GetPassID()

		if not pg.TimeMgr.GetInstance():inTime(pg.pay_data_display[var3_14].time) then
			setActive(arg0_14.btnPay, false)
		end
	end

	setText(arg0_14.titleTF, i18n(arg0_14.titleTextTip))
end

function var0_0.OnChargeSuccess(arg0_15, arg1_15)
	arg0_15.contextData.windowForCharge:ExecuteAction("ShowUnlockWindow", arg1_15)
end

function var0_0.UpdateAwardTip(arg0_16)
	setActive(arg0_16.togglesTF:Find("award/tip"), #arg0_16.activity:GetHei5UnreceiveAward() > 0)
end

function var0_0.SwitchPage(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pages) do
		if iter0_17 == arg0_17.contextData.page then
			iter1_17:ExecuteAction("Flush")
		else
			iter1_17:ExecuteAction("Hide")
		end
	end

	eachChild(arg0_17.togglesTF, function(arg0_18)
		setActive(arg0_18:Find("unselected"), arg0_18.name ~= arg0_17.contextData.page)
		setActive(arg0_18:Find("selected"), arg0_18.name == arg0_17.contextData.page)
	end)

	local var0_17

	var0_17 = arg0_17.contextData.page == var0_0.PAGE_SHOP
end

function var0_0.UpdateView(arg0_19)
	arg0_19.pages[arg0_19.contextData.page]:ExecuteAction("Flush")
end

function var0_0.UpdateAwardPage(arg0_20)
	arg0_20:UpdateAwardTip()
	arg0_20.pages[var0_0.PAGE_AWARD]:ExecuteAction("UpdateActivity", arg0_20.activity)
end

function var0_0.UpdateTaskPage(arg0_21)
	arg0_21.pages[var0_0.PAGE_TASK]:ExecuteAction("UpdateActivity", arg0_21.activity)
end

function var0_0.onBackPressed(arg0_22)
	if arg0_22.contextData.windowForCharge and arg0_22.contextData.windowForCharge:GetLoaded() and arg0_22.contextData.windowForCharge:isShowing() then
		arg0_22.contextData.windowForCharge:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_22)
end

function var0_0.willExit(arg0_23)
	return
end

return var0_0

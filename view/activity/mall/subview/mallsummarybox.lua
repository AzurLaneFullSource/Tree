local var0_0 = class("MallSummaryBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MallSummaryBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiTitleText, i18n("mall_summary_title"))
	setText(arg0_2.uiTipText, i18n("word_click_to_close"))
	setText(arg0_2.uiIncomeHeaderText, i18n("mall_total_income_header"))
	setText(arg0_2.uiBalanceHeaderText, i18n("mall_balance_header"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.uiCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.floorUIList = UIItemList.New(arg0_3.uiFloorsTF, arg0_3.uiFloorsTF:Find("tpl"))

	arg0_3.floorUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_5 + 1

			setText(arg2_5:Find("header"), i18n("mall_floor_income_header", var0_5))
			setText(arg2_5:Find("value"), arg0_3.incomeList[var0_5])
		end
	end)
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)

	arg0_6.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	arg0_6.balance = arg0_6.activity:GetLastBalance()
	arg0_6.totalIncome = 0
	arg0_6.incomeList = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.activity:GetFloorListAsc()) do
		if iter1_6:IsUnlock() then
			local var0_6 = iter1_6:GetLastIncome()

			arg0_6.totalIncome = arg0_6.totalIncome + var0_6

			table.insert(arg0_6.incomeList, var0_6)
		end
	end

	setText(arg0_6.uiIncomeValText, arg0_6.totalIncome)
	setText(arg0_6.uiBalanceValText, arg0_6.balance)
	arg0_6.floorUIList:align(#arg0_6.incomeList)
end

function var0_0.Hide(arg0_7)
	var0_0.super.Hide(arg0_7)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0

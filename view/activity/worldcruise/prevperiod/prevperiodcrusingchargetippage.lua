local var0_0 = class("PrevPeriodCrusingChargeTipPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PrevPeriodCrusingChargeTipPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("close")
	arg0_2.shopBtn = arg0_2._tf:Find("shop")
	arg0_2.awardPage = WorldCruiseAwardPage4PrevPeriod.New(arg0_2._tf)
	arg0_2.chargePage = WorldCruiseChargePage4PrevPeriod.New(arg0_2._tf)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Destroy()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.shopBtn, function()
		arg0_3.onClose = nil

		arg0_3.chargePage:ExecuteAction("ShowBuyWindow")
	end, SFX_CONFIRM)
end

function var0_0.Show(arg0_6, arg1_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)

	arg0_6.onClose = arg1_6

	arg0_6.awardPage:ExecuteAction("Flush")
end

function var0_0.OnChargeScene(arg0_7, arg1_7, arg2_7)
	arg0_7.chargePage:ExecuteAction("ShowUnlockWindow", arg1_7, arg2_7)
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf)

	if arg0_8.awardPage and arg0_8.awardPage:GetLoaded() then
		arg0_8.awardPage:OnDestroy()
	end

	arg0_8.awardPage = nil

	if arg0_8.chargePage and arg0_8.chargePage:GetLoaded() then
		arg0_8.chargePage:OnDestroy()
	end

	arg0_8.chargePage = nil

	if arg0_8.onClose then
		arg0_8.onClose()

		arg0_8.onClose = nil
	end
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9:isShowing() then
		arg0_9:Hide()
	end
end

return var0_0

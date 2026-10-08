local var0_0 = class("TianYuTianYuanCoreActivityReUI", import("view.activity.CorePage.TianYuTianYuan.TianYuTianYuanCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "TianYuTianYuanCoreActivityReUI"
end

function var0_0.init(arg0_2, ...)
	arg0_2:AddLoginTab()
	var0_0.super.init(arg0_2, ...)
	arg0_2:bind(ActivityRemasterInfoAwardPage.ON_SKIP_ACT, function(arg0_3, arg1_3)
		if arg0_2.infoDisplayPage and arg0_2.infoDisplayPage:GetLoaded() then
			arg0_2.infoDisplayPage:Hide()
		end

		arg0_2:verifyTabs(arg1_3)
	end)
end

function var0_0.AddLoginTab(arg0_4)
	local var0_4 = arg0_4._tf:Find("adapt/tabs")
	local var1_4 = var0_4.childCount

	cloneTplTo(var0_4:GetChild(0), var0_4).name = var1_4 + 1 .. ""
end

function var0_0.OnPageSwitchDone(arg0_5, arg1_5, arg2_5)
	if not arg0_5.awardPreviewBtn then
		arg0_5:InitAwardPreviewBtn()
	end

	setActive(arg0_5.awardPreviewBtn, arg2_5 == 1)

	local var0_5 = arg1_5:GetAwardPreviewPos()

	if var0_5 then
		setAnchoredPosition3D(arg0_5.awardPreviewBtn, BuildVector3(var0_5))
	else
		setAnchoredPosition3D(arg0_5.awardPreviewBtn, arg0_5.initAwardPreviewBtnPos)
	end
end

function var0_0.InitAwardPreviewBtn(arg0_6)
	arg0_6.awardPreviewBtn = arg0_6._tf:Find("adapt/award_preview")

	setText(arg0_6.awardPreviewBtn:Find("Text"), i18n("ActivityRemasterCore_award_preview_btn"))

	arg0_6.initAwardPreviewBtnPos = getAnchoredPosition(arg0_6.awardPreviewBtn)

	onButton(arg0_6, arg0_6.awardPreviewBtn, function()
		arg0_6.infoDisplayPage = arg0_6.infoDisplayPage or ActivityRemasterInfoWithoutTextDisplayPage.New(arg0_6._tf, arg0_6.event)

		local var0_7 = getProxy(ActivityRemasterProxy):GetActiveActID()

		arg0_6.infoDisplayPage:ExecuteAction("Show", var0_7, "")
	end, SFX_PANEL)
end

function var0_0.willExit(arg0_8)
	var0_0.super.willExit(arg0_8)

	if arg0_8.infoDisplayPage and arg0_8.infoDisplayPage:GetLoaded() then
		arg0_8.infoDisplayPage:Destroy()
	end

	arg0_8.infoDisplayPage = nil
end

return var0_0

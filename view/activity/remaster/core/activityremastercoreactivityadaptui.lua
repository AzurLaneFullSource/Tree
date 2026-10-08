local var0_0 = class("ActivityRemasterCoreActivityAdaptUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "ActivityRemasterCoreActivityAdaptUI"
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("adapt/TopPage/top/btn_home"), function()
		arg0_2:emit(BaseUI.ON_HOME)
	end, SOUND_BACK)
	arg0_2:bind(ActivityRemasterInfoAwardPage.ON_SKIP_ACT, function(arg0_4, arg1_4)
		if arg0_2.infoDisplayPage and arg0_2.infoDisplayPage:GetLoaded() then
			arg0_2.infoDisplayPage:Hide()
		end

		arg0_2:verifyTabs(arg1_4)
	end)
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("ActivityRemasterCoreActivityAdaptUI_TITLE"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("ActivityRemasterCoreActivityAdaptUI_TITLE_EN"))
end

function var0_0.flushTabs(arg0_5)
	var0_0.super.flushTabs(arg0_5)

	for iter0_5, iter1_5 in ipairs(arg0_5.activities) do
		if iter1_5 then
			local var0_5 = iter1_5:getConfig("is_show")
			local var1_5 = arg0_5.tabsList.container:Find(var0_5)
			local var2_5 = iter1_5:getConfig("title_res_tag")
			local var3_5 = i18n(var2_5)

			setText(var1_5:Find("name"), var3_5)
			setText(var1_5:Find("on/name"), var3_5)
		end
	end
end

function var0_0.init(arg0_6, ...)
	arg0_6:AddLoginTab()
	var0_0.super.init(arg0_6, ...)

	arg0_6.btnBack = arg0_6._tf:Find("adapt/TopPage/top/btn_back")
end

function var0_0.AddLoginTab(arg0_7)
	local var0_7 = arg0_7._tf:Find("adapt/tabs")
	local var1_7 = var0_7.childCount

	cloneTplTo(var0_7:GetChild(0), var0_7).name = var1_7 + 1 .. ""
end

function var0_0.OnPageSwitchDone(arg0_8, arg1_8, arg2_8)
	if not arg0_8.awardPreviewBtn then
		arg0_8:InitAwardPreviewBtn()
	end

	setActive(arg0_8.awardPreviewBtn, arg2_8 == 1)

	local var0_8 = arg1_8:GetAwardPreviewPos()

	if var0_8 then
		setAnchoredPosition3D(arg0_8.awardPreviewBtn, BuildVector3(var0_8))
	else
		setAnchoredPosition3D(arg0_8.awardPreviewBtn, arg0_8.initAwardPreviewBtnPos)
	end
end

function var0_0.InitAwardPreviewBtn(arg0_9)
	arg0_9.awardPreviewBtn = arg0_9._tf:Find("adapt/award_preview")

	setText(arg0_9.awardPreviewBtn:Find("Text"), i18n("ActivityRemasterCore_award_preview_btn"))

	arg0_9.initAwardPreviewBtnPos = getAnchoredPosition(arg0_9.awardPreviewBtn)

	onButton(arg0_9, arg0_9.awardPreviewBtn, function()
		arg0_9.infoDisplayPage = arg0_9.infoDisplayPage or ActivityRemasterInfoWithoutTextDisplayPage.New(arg0_9._tf, arg0_9.event)

		local var0_10 = getProxy(ActivityRemasterProxy):GetActiveActID()

		arg0_9.infoDisplayPage:ExecuteAction("Show", var0_10, "")
	end, SFX_PANEL)
end

function var0_0.willExit(arg0_11)
	var0_0.super.willExit(arg0_11)

	if arg0_11.infoDisplayPage and arg0_11.infoDisplayPage:GetLoaded() then
		arg0_11.infoDisplayPage:Destroy()
	end

	arg0_11.infoDisplayPage = nil
end

return var0_0

local var0_0 = class("TrophyGalleryLayer", import("..base.BaseUI"))

var0_0.Filter = {
	"all",
	"claimed",
	"unclaim"
}

function var0_0.getUIName(arg0_1)
	return "TrophyGalleryUI"
end

function var0_0.setTrophyGroups(arg0_2, arg1_2)
	arg0_2.trophyGroups = arg1_2
end

function var0_0.setTrophyList(arg0_3, arg1_3)
	arg0_3.trophyList = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4._bg = arg0_4:findTF("bg")
	arg0_4._blurPanel = arg0_4:findTF("blur_panel")
	arg0_4._topPanel = arg0_4:findTF("adapt/top", arg0_4._blurPanel)
	arg0_4._backBtn = arg0_4._topPanel:Find("back_btn")
	arg0_4._helpBtn = arg0_4._topPanel:Find("help_btn")
	arg0_4._center = arg0_4:findTF("bg/taskBGCenter")
	arg0_4._trophyUpperTpl = arg0_4:getTpl("trophy_upper", arg0_4._center)
	arg0_4._trophyLowerTpl = arg0_4:getTpl("trophy_lower", arg0_4._center)
	arg0_4._trophyContainer = arg0_4:findTF("bg/taskBGCenter/right_panel/Grid")
	arg0_4._scrllPanel = arg0_4:findTF("bg/taskBGCenter/right_panel")
	arg0_4._scrollView = arg0_4._scrllPanel:GetComponent("LScrollRect")
	arg0_4._trophyDetailPanel = TrophyDetailPanel.New(arg0_4:findTF("trophyPanel"), arg0_4._tf)
	arg0_4._filterBtn = arg0_4:findTF("filter/toggle", arg0_4._topPanel)
	arg0_4._trophyCounter = arg0_4:findTF("filter/counter/Text", arg0_4._topPanel)
	arg0_4._reminderRes = arg0_4:findTF("bg/resource")
	arg0_4._trophyTFList = {}
end

function var0_0.didEnter(arg0_5)
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg0_5._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	onButton(arg0_5, arg0_5._backBtn, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._filterBtn, function()
		arg0_5:onFilter()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.medal_help_tip.tip
		})
	end, SFX_PANEL)

	arg0_5._filterIndex = 0

	triggerButton(arg0_5._filterBtn)
	arg0_5:updateTrophyCounter()
end

function var0_0.updateTrophyList(arg0_9)
	arg0_9._trophyTFList = {}

	removeAllChildren(arg0_9._trophyContainer)

	local var0_9 = var0_0.Filter[arg0_9._filterIndex]
	local var1_9 = 0

	for iter0_9, iter1_9 in pairs(arg0_9.trophyGroups) do
		local var2_9

		if var0_9 == "all" then
			var2_9 = true
		elseif var0_9 == "claimed" then
			var2_9 = iter1_9:getMaxClaimedTrophy() ~= nil
		elseif var0_9 == "unclaim" then
			var2_9 = not iter1_9:getProgressTrophy():isClaimed()
		end

		if var2_9 then
			local var3_9

			if math.fmod(var1_9, 2) == 0 then
				var3_9 = arg0_9._trophyUpperTpl
			else
				var3_9 = arg0_9._trophyLowerTpl
			end

			local var4_9 = cloneTplTo(var3_9, arg0_9._trophyContainer)
			local var5_9 = TrophyView.New(var4_9)

			if var0_9 == "all" then
				var5_9:UpdateTrophyGroup(iter1_9)
			elseif var0_9 == "claimed" then
				var5_9:ClaimForm(iter1_9)
			elseif var0_9 == "unclaim" then
				var5_9:ProgressingForm(iter1_9)
			end

			local var6_9 = var5_9:GetTrophyClaimTipsID()

			var5_9:SetTrophyReminder(Instantiate(arg0_9._reminderRes:Find(var6_9)))

			arg0_9._trophyTFList[iter0_9] = var5_9
			var1_9 = var1_9 + 1

			onButton(arg0_9, var4_9.transform:Find("frame"), function()
				local var0_10 = arg0_9.trophyGroups[iter0_9]
				local var1_10 = var0_10:getProgressTrophy()

				if var1_10:canClaimed() and not var1_10:isClaimed() then
					if not var5_9:IsPlaying() then
						arg0_9:emit(TrophyGalleryMediator.ON_TROPHY_CLAIM, var1_10.id)
					end
				elseif not var5_9:IsPlaying() then
					arg0_9:openTrophyDetail(var0_10, var1_10)
				end
			end)
		end
	end
end

function var0_0.PlayTrophyClaim(arg0_11, arg1_11)
	local var0_11 = arg0_11.trophyGroups[arg1_11]
	local var1_11 = arg0_11._trophyTFList[arg1_11]
	local var2_11 = Instantiate(arg0_11._reminderRes:Find("claim_fx"))

	var1_11:PlayClaimAnima(var0_11, var2_11, function()
		arg0_11:updateTrophyByGroup(arg1_11)
		arg0_11:updateTrophyCounter()
	end)
end

function var0_0.updateTrophyByGroup(arg0_13, arg1_13)
	local var0_13 = arg0_13.trophyGroups[arg1_13]

	arg0_13._trophyTFList[arg1_13]:UpdateTrophyGroup(var0_13)
end

function var0_0.openTrophyDetail(arg0_14, arg1_14, arg2_14)
	arg0_14._trophyDetailPanel:SetTrophyGroup(arg1_14)
	arg0_14._trophyDetailPanel:UpdateTrophy(arg2_14)
	arg0_14._trophyDetailPanel:SetActive(true)
end

function var0_0.updateTrophyCounter(arg0_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in pairs(arg0_15.trophyList) do
		if iter1_15:isClaimed() and not iter1_15:isHide() then
			var0_15 = var0_15 + 1
		end
	end

	setText(arg0_15._trophyCounter, var0_15)
end

function var0_0.onFilter(arg0_16)
	arg0_16._filterIndex = arg0_16._filterIndex + 1

	if arg0_16._filterIndex > #var0_0.Filter then
		arg0_16._filterIndex = 1
	end

	for iter0_16 = 1, #var0_0.Filter do
		setActive(arg0_16._filterBtn:GetChild(iter0_16 - 1), iter0_16 == arg0_16._filterIndex)
	end

	arg0_16:updateTrophyList()
end

function var0_0.onBackPressed(arg0_17)
	if arg0_17._trophyDetailPanel:IsActive() then
		arg0_17._trophyDetailPanel:SetActive(false)
	else
		var0_0.super.onBackPressed(arg0_17)
	end
end

function var0_0.willExit(arg0_18)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18._blurPanel, arg0_18._tf)
	arg0_18._trophyDetailPanel:Dispose()
end

return var0_0

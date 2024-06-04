local var0 = class("TrophyGalleryLayer", import("..base.BaseUI"))

var0.Filter = {
	"all",
	"claimed",
	"unclaim"
}

function var0.getUIName(arg0)
	return "TrophyGalleryUI"
end

function var0.setTrophyGroups(arg0, arg1)
	arg0.trophyGroups = arg1
end

function var0.setTrophyList(arg0, arg1)
	arg0.trophyList = arg1
end

function var0.init(arg0)
	arg0._bg = arg0:findTF("bg")
	arg0._blurPanel = arg0:findTF("blur_panel")
	arg0._topPanel = arg0:findTF("adapt/top", arg0._blurPanel)
	arg0._backBtn = arg0._topPanel:Find("back_btn")
	arg0._helpBtn = arg0._topPanel:Find("help_btn")
	arg0._center = arg0:findTF("bg/taskBGCenter")
	arg0._trophyUpperTpl = arg0:getTpl("trophy_upper", arg0._center)
	arg0._trophyLowerTpl = arg0:getTpl("trophy_lower", arg0._center)
	arg0._trophyContainer = arg0:findTF("bg/taskBGCenter/right_panel/Grid")
	arg0._scrllPanel = arg0:findTF("bg/taskBGCenter/right_panel")
	arg0._scrollView = arg0._scrllPanel:GetComponent("LScrollRect")
	arg0._trophyDetailPanel = TrophyDetailPanel.New(arg0:findTF("trophyPanel"), arg0._tf)
	arg0._filterBtn = arg0:findTF("filter/toggle", arg0._topPanel)
	arg0._trophyCounter = arg0:findTF("filter/counter/Text", arg0._topPanel)
	arg0._reminderRes = arg0:findTF("bg/resource")
	arg0._trophyTFList = {}
end

function var0.didEnter(arg0)
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg0._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})
	onButton(arg0, arg0._backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0._filterBtn, function()
		arg0:onFilter()
	end, SFX_PANEL)
	onButton(arg0, arg0._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.medal_help_tip.tip
		})
	end, SFX_PANEL)

	arg0._filterIndex = 0

	triggerButton(arg0._filterBtn)
	arg0:updateTrophyCounter()
end

function var0.updateTrophyList(arg0)
	arg0._trophyTFList = {}

	removeAllChildren(arg0._trophyContainer)

	local var0 = var0.Filter[arg0._filterIndex]
	local var1 = 0

	for iter0, iter1 in pairs(arg0.trophyGroups) do
		local var2

		if var0 == "all" then
			var2 = true
		elseif var0 == "claimed" then
			var2 = iter1:getMaxClaimedTrophy() ~= nil
		elseif var0 == "unclaim" then
			var2 = not iter1:getProgressTrophy():isClaimed()
		end

		if var2 then
			local var3

			if math.fmod(var1, 2) == 0 then
				var3 = arg0._trophyUpperTpl
			else
				var3 = arg0._trophyLowerTpl
			end

			local var4 = cloneTplTo(var3, arg0._trophyContainer)
			local var5 = TrophyView.New(var4)

			if var0 == "all" then
				var5:UpdateTrophyGroup(iter1)
			elseif var0 == "claimed" then
				var5:ClaimForm(iter1)
			elseif var0 == "unclaim" then
				var5:ProgressingForm(iter1)
			end

			local var6 = var5:GetTrophyClaimTipsID()

			var5:SetTrophyReminder(Instantiate(arg0._reminderRes:Find(var6)))

			arg0._trophyTFList[iter0] = var5
			var1 = var1 + 1

			onButton(arg0, var4.transform:Find("frame"), function()
				local var0 = arg0.trophyGroups[iter0]
				local var1 = var0:getProgressTrophy()

				if var1:canClaimed() and not var1:isClaimed() then
					if not var5:IsPlaying() then
						arg0:emit(TrophyGalleryMediator.ON_TROPHY_CLAIM, var1.id)
					end
				else
					arg0:openTrophyDetail(var0, var1)
				end
			end)
		end
	end
end

function var0.PlayTrophyClaim(arg0, arg1)
	local var0 = arg0.trophyGroups[arg1]
	local var1 = arg0._trophyTFList[arg1]
	local var2 = Instantiate(arg0._reminderRes:Find("claim_fx"))

	var1:PlayClaimAnima(var0, var2, function()
		arg0:updateTrophyByGroup(arg1)
		arg0:updateTrophyCounter()
	end)
end

function var0.updateTrophyByGroup(arg0, arg1)
	local var0 = arg0.trophyGroups[arg1]

	arg0._trophyTFList[arg1]:UpdateTrophyGroup(var0)
end

function var0.openTrophyDetail(arg0, arg1, arg2)
	arg0._trophyDetailPanel:SetTrophyGroup(arg1)
	arg0._trophyDetailPanel:UpdateTrophy(arg2)
	arg0._trophyDetailPanel:SetActive(true)
end

function var0.updateTrophyCounter(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.trophyList) do
		if iter1:isClaimed() and not iter1:isHide() then
			var0 = var0 + 1
		end
	end

	setText(arg0._trophyCounter, var0)
end

function var0.onFilter(arg0)
	arg0._filterIndex = arg0._filterIndex + 1

	if arg0._filterIndex > #var0.Filter then
		arg0._filterIndex = 1
	end

	for iter0 = 1, #var0.Filter do
		setActive(arg0._filterBtn:GetChild(iter0 - 1), iter0 == arg0._filterIndex)
	end

	arg0:updateTrophyList()
end

function var0.onBackPressed(arg0)
	if arg0._trophyDetailPanel:IsActive() then
		arg0._trophyDetailPanel:SetActive(false)
	else
		var0.super.onBackPressed(arg0)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._blurPanel, arg0._tf)
	arg0._trophyDetailPanel:Dispose()
end

return var0

local var0_0 = class("TrophyGalleryLayer", import("..base.BaseUI"))

var0_0.Filter = {
	"all",
	"claimed"
}
var0_0.PAGE_COMMON = 1
var0_0.PAGE_LIMITED = 2

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
	arg0_4._pageToggle = {
		arg0_4:findTF("blur_panel/adapt/left_length/frame/root/common_toggle"),
		arg0_4:findTF("blur_panel/adapt/left_length/frame/root/limited_toggle")
	}
	arg0_4._hideExpireBtn = arg0_4:findTF("blur_panel/adapt/top/expireCheckBox")
	arg0_4._hideExpireCheck = arg0_4._hideExpireBtn:Find("check")
	arg0_4._pageIndex = 1
	arg0_4._hideExpire = false
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
	onButton(arg0_5, arg0_5._hideExpireBtn, function()
		arg0_5._hideExpire = not arg0_5._hideExpire

		setActive(arg0_5._hideExpireCheck, not arg0_5._hideExpire)
		arg0_5:updateTrophyList()
	end, SFX_PANEL)
	triggerButton(arg0_5._hideExpireBtn)

	for iter0_5 = 1, 2 do
		local var0_5 = arg0_5._pageToggle[iter0_5]

		onButton(arg0_5, var0_5, function()
			arg0_5:updatePage(iter0_5)
		end, SFX_PANEL)
	end

	arg0_5._filterIndex = 0

	triggerButton(arg0_5._filterBtn)
	triggerButton(arg0_5._pageToggle[arg0_5._pageIndex])
	arg0_5:updateTrophyCounter()
end

function var0_0.updatePage(arg0_11, arg1_11)
	for iter0_11 = 1, #arg0_11._pageToggle do
		local var0_11 = arg0_11._pageToggle[iter0_11]

		setActive(var0_11:Find("selected"), iter0_11 == arg1_11)
		setActive(var0_11:Find("Image"), iter0_11 ~= arg1_11)
	end

	arg0_11._pageIndex = arg1_11

	arg0_11:updateTrophyList()
	setActive(arg0_11._hideExpireBtn, arg1_11 == var0_0.PAGE_LIMITED)
end

function var0_0.updateTrophyList(arg0_12)
	arg0_12._trophyTFList = {}

	removeAllChildren(arg0_12._trophyContainer)

	local var0_12 = var0_0.Filter[arg0_12._filterIndex]
	local var1_12 = arg0_12._pageIndex
	local var2_12 = 0

	for iter0_12, iter1_12 in pairs(arg0_12.trophyGroups) do
		if iter1_12:GetTrophyPage() == var1_12 then
			local var3_12

			if var0_12 == "all" then
				var3_12 = true
			elseif var0_12 == "claimed" then
				var3_12 = iter1_12:getMaxClaimedTrophy() ~= nil
			end

			if var1_12 == var0_0.PAGE_LIMITED and arg0_12._hideExpire and iter1_12:IsExpire() == 1 and not iter1_12:getProgressTrophy():isClaimed() then
				var3_12 = false
			end

			if var3_12 then
				local var4_12

				if math.fmod(var2_12, 2) == 0 then
					var4_12 = arg0_12._trophyUpperTpl
				else
					var4_12 = arg0_12._trophyLowerTpl
				end

				local var5_12 = cloneTplTo(var4_12, arg0_12._trophyContainer)
				local var6_12 = TrophyView.New(var5_12)

				if var0_12 == "all" then
					var6_12:UpdateTrophyGroup(iter1_12)
				elseif var0_12 == "claimed" then
					var6_12:ClaimForm(iter1_12)
				elseif var0_12 == "unclaim" then
					var6_12:ProgressingForm(iter1_12)
				end

				local var7_12 = var6_12:GetTrophyClaimTipsID()

				var6_12:SetTrophyReminder(Instantiate(arg0_12._reminderRes:Find(var7_12)))

				arg0_12._trophyTFList[iter0_12] = var6_12
				var2_12 = var2_12 + 1

				onButton(arg0_12, var5_12.transform:Find("frame"), function()
					local var0_13 = arg0_12.trophyGroups[iter0_12]
					local var1_13 = var0_13:getProgressTrophy()

					if var1_13:canClaimed() and not var1_13:isClaimed() then
						if not var6_12:IsPlaying() then
							arg0_12:emit(TrophyGalleryMediator.ON_TROPHY_CLAIM, var1_13.id)
						end
					elseif not var6_12:IsPlaying() then
						arg0_12:openTrophyDetail(var0_13, var1_13)
					end
				end)
			end
		end
	end
end

function var0_0.PlayTrophyClaim(arg0_14, arg1_14)
	local var0_14 = arg0_14.trophyGroups[arg1_14]
	local var1_14 = arg0_14._trophyTFList[arg1_14]
	local var2_14 = Instantiate(arg0_14._reminderRes:Find("claim_fx"))

	var1_14:PlayClaimAnima(var0_14, var2_14, function()
		arg0_14:updateTrophyByGroup(arg1_14)
		arg0_14:updateTrophyCounter()
	end)
end

function var0_0.updateTrophyByGroup(arg0_16, arg1_16)
	local var0_16 = arg0_16.trophyGroups[arg1_16]

	arg0_16._trophyTFList[arg1_16]:UpdateTrophyGroup(var0_16)
end

function var0_0.openTrophyDetail(arg0_17, arg1_17, arg2_17)
	arg0_17._trophyDetailPanel:SetTrophyGroup(arg1_17)
	arg0_17._trophyDetailPanel:UpdateTrophy(arg2_17)
	arg0_17._trophyDetailPanel:SetActive(true)
end

function var0_0.updateTrophyCounter(arg0_18)
	local var0_18 = 0

	for iter0_18, iter1_18 in pairs(arg0_18.trophyList) do
		if iter1_18:isClaimed() and not iter1_18:isHide() then
			var0_18 = var0_18 + 1
		end
	end

	setText(arg0_18._trophyCounter, var0_18)
end

function var0_0.onFilter(arg0_19)
	arg0_19._filterIndex = arg0_19._filterIndex + 1

	if arg0_19._filterIndex > #var0_0.Filter then
		arg0_19._filterIndex = 1
	end

	for iter0_19 = 1, #var0_0.Filter do
		setActive(arg0_19._filterBtn:GetChild(iter0_19 - 1), iter0_19 == arg0_19._filterIndex)
	end

	arg0_19:updateTrophyList()
end

function var0_0.onBackPressed(arg0_20)
	if arg0_20._trophyDetailPanel:IsActive() then
		arg0_20._trophyDetailPanel:SetActive(false)
	else
		var0_0.super.onBackPressed(arg0_20)
	end
end

function var0_0.willExit(arg0_21)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21._blurPanel, arg0_21._tf)
	arg0_21._trophyDetailPanel:Dispose()
end

return var0_0

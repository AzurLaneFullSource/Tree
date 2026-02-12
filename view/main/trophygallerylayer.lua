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
	arg0_4._bg = arg0_4._tf:Find("bg")
	arg0_4._blurPanel = arg0_4._tf:Find("blur_panel")
	arg0_4._topPanel = arg0_4._blurPanel:Find("adapt/top")
	arg0_4._backBtn = arg0_4._topPanel:Find("back_btn")
	arg0_4._helpBtn = arg0_4._topPanel:Find("help_btn")
	arg0_4._center = arg0_4._tf:Find("bg/taskBGCenter")
	arg0_4._trophyUpperTpl = arg0_4:getTpl("trophy_upper", arg0_4._center)
	arg0_4._trophyLowerTpl = arg0_4:getTpl("trophy_lower", arg0_4._center)
	arg0_4._trophyContainer = arg0_4._tf:Find("bg/taskBGCenter/right_panel/Grid")
	arg0_4._scrllPanel = arg0_4._tf:Find("bg/taskBGCenter/right_panel")
	arg0_4._scrollView = arg0_4._scrllPanel:GetComponent("LScrollRect")
	arg0_4._trophyDetailPanel = TrophyDetailPanel.New(arg0_4._tf:Find("trophyPanel"), arg0_4._tf)
	arg0_4._filterBtn = arg0_4._topPanel:Find("filter/toggle")
	arg0_4._trophyCounter = arg0_4._topPanel:Find("filter/counter/Text")
	arg0_4._reminderRes = arg0_4._tf:Find("bg/resource")
	arg0_4._pageToggle = {
		arg0_4._tf:Find("blur_panel/adapt/left_length/frame/root/common_toggle"),
		arg0_4._tf:Find("blur_panel/adapt/left_length/frame/root/limited_toggle"),
		arg0_4.toggleLoveLetter
	}
	arg0_4._hideExpireBtn = arg0_4._tf:Find("blur_panel/adapt/top/expireCheckBox")
	arg0_4._hideExpireCheck = arg0_4._hideExpireBtn:Find("check")
	arg0_4._pageIndex = arg0_4.contextData.index or 1
	arg0_4._hideExpire = false
	arg0_4._trophyTFList = {}
	arg0_4.cardItems = {}
	arg0_4.cardList = arg0_4.rtScrollContent:GetComponent("LScrollRect")

	function arg0_4.cardList.onInitItem(arg0_5)
		arg0_4:onInitCard(arg0_5)
	end

	function arg0_4.cardList.onUpdateItem(arg0_6, arg1_6)
		arg0_4:onUpdateCard(arg0_6, arg1_6)
	end

	function arg0_4.cardList.onReturnItem(arg0_7, arg1_7)
		arg0_4:onReturnCard(arg0_7, arg1_7)
	end
end

function var0_0.didEnter(arg0_8)
	arg0_8:OverlayPanel(arg0_8._tf)
	onButton(arg0_8, arg0_8._backBtn, function()
		arg0_8:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8._filterBtn, function()
		arg0_8:onFilter()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.medal_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._hideExpireBtn, function()
		arg0_8._hideExpire = not arg0_8._hideExpire

		setActive(arg0_8._hideExpireCheck, not arg0_8._hideExpire)
		arg0_8:updateTrophyList()
	end, SFX_PANEL)
	triggerButton(arg0_8._hideExpireBtn)

	for iter0_8, iter1_8 in ipairs(arg0_8._pageToggle) do
		onButton(arg0_8, iter1_8, function()
			arg0_8:updatePage(iter0_8)
		end, SFX_PANEL)
	end

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_8.toggleLoveLetter:Find("tip"), {
		"love_letter_level_up",
		"love_letter_level_reward"
	}, function(arg0_14)
		local var0_14 = getProxy(LoveLetterProxy)

		setActive(arg0_14, var0_14:IsTipLevelUp() or var0_14:IsTipAllLevelReward())
	end)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_8.rtCountLevelPanel:Find("info/icon/tip"), {
		"love_letter_level_reward"
	}, function(arg0_15)
		setActive(arg0_15, getProxy(LoveLetterProxy):IsTipAllLevelReward())
	end)

	arg0_8._filterIndex = 0

	triggerButton(arg0_8._filterBtn)
	triggerButton(arg0_8._pageToggle[arg0_8._pageIndex])
	arg0_8:updateTrophyCounter()
end

function var0_0.updatePage(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg0_16._pageToggle) do
		setActive(iter1_16:Find("selected"), iter0_16 == arg1_16)
		setActive(iter1_16:Find("Image"), iter0_16 ~= arg1_16)
	end

	arg0_16._pageIndex = arg1_16

	local var0_16 = arg1_16 == 3

	setActive(arg0_16._center, not var0_16)
	setActive(arg0_16._topPanel:Find("filter"), not var0_16)
	setActive(arg0_16.rtLoveLetterPanel, var0_16)
	setActive(arg0_16.rtCountLevelPanel, var0_16)
	setActive(arg0_16.rtCountLevelBg, var0_16)

	if var0_16 then
		arg0_16:updateLoveLetterPage()
	else
		arg0_16:updateTrophyList()
	end

	setActive(arg0_16._hideExpireBtn, arg1_16 == var0_0.PAGE_LIMITED)
end

function var0_0.updateTrophyList(arg0_17)
	arg0_17._trophyTFList = {}

	removeAllChildren(arg0_17._trophyContainer)

	local var0_17 = var0_0.Filter[arg0_17._filterIndex]
	local var1_17 = arg0_17._pageIndex
	local var2_17 = 0

	for iter0_17, iter1_17 in pairs(arg0_17.trophyGroups) do
		if iter1_17:GetTrophyPage() == var1_17 then
			local var3_17

			if var0_17 == "all" then
				var3_17 = true
			elseif var0_17 == "claimed" then
				var3_17 = iter1_17:getMaxClaimedTrophy() ~= nil
			end

			if var1_17 == var0_0.PAGE_LIMITED and arg0_17._hideExpire and iter1_17:IsExpire() == 1 and not iter1_17:getProgressTrophy():isClaimed() then
				var3_17 = false
			end

			if var3_17 then
				local var4_17

				if math.fmod(var2_17, 2) == 0 then
					var4_17 = arg0_17._trophyUpperTpl
				else
					var4_17 = arg0_17._trophyLowerTpl
				end

				local var5_17 = cloneTplTo(var4_17, arg0_17._trophyContainer)
				local var6_17 = TrophyView.New(var5_17)

				if var0_17 == "all" then
					var6_17:UpdateTrophyGroup(iter1_17)
				elseif var0_17 == "claimed" then
					var6_17:ClaimForm(iter1_17)
				elseif var0_17 == "unclaim" then
					var6_17:ProgressingForm(iter1_17)
				end

				local var7_17 = var6_17:GetTrophyClaimTipsID()

				var6_17:SetTrophyReminder(Instantiate(arg0_17._reminderRes:Find(var7_17)))

				arg0_17._trophyTFList[iter0_17] = var6_17
				var2_17 = var2_17 + 1

				onButton(arg0_17, var5_17.transform:Find("frame"), function()
					local var0_18 = arg0_17.trophyGroups[iter0_17]
					local var1_18 = var0_18:getProgressTrophy()

					if var1_18:canClaimed() and not var1_18:isClaimed() then
						if not var6_17:IsPlaying() then
							arg0_17:emit(TrophyGalleryMediator.ON_TROPHY_CLAIM, var1_18.id)
						end
					elseif not var6_17:IsPlaying() then
						arg0_17:openTrophyDetail(var0_18, var1_18)
					end
				end)
			end
		end
	end
end

function var0_0.PlayTrophyClaim(arg0_19, arg1_19)
	local var0_19 = arg0_19.trophyGroups[arg1_19]
	local var1_19 = arg0_19._trophyTFList[arg1_19]
	local var2_19 = Instantiate(arg0_19._reminderRes:Find("claim_fx"))

	var1_19:PlayClaimAnima(var0_19, var2_19, function()
		arg0_19:updateTrophyByGroup(arg1_19)
		arg0_19:updateTrophyCounter()
	end)
end

function var0_0.updateTrophyByGroup(arg0_21, arg1_21)
	local var0_21 = arg0_21.trophyGroups[arg1_21]

	arg0_21._trophyTFList[arg1_21]:UpdateTrophyGroup(var0_21)
end

function var0_0.openTrophyDetail(arg0_22, arg1_22, arg2_22)
	arg0_22._trophyDetailPanel:SetTrophyGroup(arg1_22)
	arg0_22._trophyDetailPanel:UpdateTrophy(arg2_22)
	arg0_22._trophyDetailPanel:SetActive(true)
end

function var0_0.updateTrophyCounter(arg0_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in pairs(arg0_23.trophyList) do
		if iter1_23:isClaimed() and not iter1_23:isHide() then
			var0_23 = var0_23 + 1
		end
	end

	setText(arg0_23._trophyCounter, var0_23)
end

function var0_0.onFilter(arg0_24)
	arg0_24._filterIndex = arg0_24._filterIndex + 1

	if arg0_24._filterIndex > #var0_0.Filter then
		arg0_24._filterIndex = 1
	end

	for iter0_24 = 1, #var0_0.Filter do
		setActive(arg0_24._filterBtn:GetChild(iter0_24 - 1), iter0_24 == arg0_24._filterIndex)
	end

	arg0_24:updateTrophyList()
end

function var0_0.updateLoveLetterPage(arg0_25)
	if not arg0_25.contextData.checkRalizeGift then
		arg0_25.contextData.checkRalizeGift = true

		if getProxy(LoveLetterProxy):IsTipRealizeGift() then
			arg0_25:emit(TrophyGalleryMediator.OPEN_REALIZE_GIFT_LAYER)
		end
	end

	arg0_25.cardInfos = getProxy(LoveLetterProxy):GetDisplayGroupList()

	arg0_25.cardList:SetTotalCount(#arg0_25.cardInfos, -1)

	local var0_25 = getProxy(LoveLetterProxy)
	local var1_25 = arg0_25.rtCountLevelPanel:Find("info")

	setText(var1_25:Find("word"), i18n("loveactivity_ui_10"))

	local var2_25 = var0_25:GetAllLevel()

	setText(var1_25:Find("count"), var2_25)

	local var3_25, var4_25 = var0_25:GetAllLevelProgress()

	if var4_25 == 0 then
		setSlider(var1_25:Find("Slider"), 0, 1, 1)
	else
		setSlider(var1_25:Find("Slider"), 0, var4_25, var3_25)
	end

	setText(var1_25:Find("Slider/Text"), var3_25 .. "/" .. var4_25)

	local var5_25 = var0_25:GetAllLevelNextAward()

	updateDrop(var1_25:Find("icon/mask/IconTpl"), var5_25[1])
	onButton(arg0_25, var1_25:Find("icon/mask/IconTpl"), function()
		arg0_25:emit(BaseUI.ON_DROP, drop[1])
	end, SFX_PANEL)
	setActive(var1_25:Find("icon/got"), var4_25 == 0)
	onButton(arg0_25, var1_25:Find("click"), function()
		local var0_27 = getProxy(LoveLetterProxy):GetAllLevelReadyReward()

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_LOVE_LETTER_LEVEL_REWARD, {
			btnList = #var0_27 > 0 and {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.cancel,
					name = i18n("msgbox_text_cancel"),
					sound = SFX_CANCEL
				},
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
					name = i18n("mail_get_oneclick"),
					func = function()
						arg0_25:emit(TrophyGalleryMediator.ON_GET_ALL_LOVE_LETTER_REWARD, var0_27)
					end,
					sound = SFX_CONFIRM
				}
			} or nil
		})
	end, SFX_PANEL)
end

function var0_0.onInitCard(arg0_29, arg1_29)
	local var0_29 = LoveLetterShipCard.New(arg1_29)

	onButton(arg0_29, var0_29.go, function()
		if var0_29.shipGroup then
			arg0_29:emit(TrophyGalleryMediator.OPEN_DISPLAY_WINDOW, var0_29.shipGroup.id)
		end
	end)

	arg0_29.cardItems[arg1_29] = var0_29
end

function var0_0.onUpdateCard(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.cardItems[arg2_31]

	if not var0_31 then
		arg0_31:onInitCard(arg2_31)

		var0_31 = arg0_31.cardItems[arg2_31]
	end

	local var1_31 = arg1_31 + 1
	local var2_31 = arg0_31.cardInfos[var1_31]

	var0_31:update(var2_31)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg2_31.transform:Find("content/pick_up"), {
		"love_letter_level_up"
	}, function(arg0_32)
		local var0_32 = getProxy(LoveLetterProxy):GetGroupData(var2_31.id)

		setActive(arg0_32, var0_32:GetDisplayLevel() < var0_32:GetMaxLevel() and var0_32:CanLevelUp())
	end)
end

function var0_0.onReturnCard(arg0_33, arg1_33, arg2_33)
	if arg0_33.exited then
		return
	end

	local var0_33 = arg0_33.cardItems[arg2_33]

	if var0_33 then
		var0_33:clear()
	end

	arg0_33.cardItems[arg2_33] = nil
end

function var0_0.onBackPressed(arg0_34)
	if arg0_34._trophyDetailPanel:IsActive() then
		arg0_34._trophyDetailPanel:SetActive(false)
	else
		var0_0.super.onBackPressed(arg0_34)
	end
end

function var0_0.willExit(arg0_35)
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_35.toggleLoveLetter:Find("tip"))
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_35.rtCountLevelPanel:Find("info/icon/tip"))

	for iter0_35, iter1_35 in pairs(arg0_35.cardItems) do
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(iter0_35.transform:Find("content/pick_up"))
	end

	arg0_35:UnOverlayPanel(arg0_35._blurPanel, arg0_35._tf)
	arg0_35._trophyDetailPanel:Dispose()
end

return var0_0

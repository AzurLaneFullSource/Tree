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
	arg0_4._trophyViewCache = {}
	arg0_4._trophyMatCache = {}
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

	arg0_4._loader = AutoLoader.New()
end

function var0_0.checkTrophyVisible(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg1_8:GetTrophyPage() ~= arg2_8 then
		return false
	end

	local var0_8 = false

	if arg3_8 == "all" then
		var0_8 = true
	elseif arg3_8 == "claimed" then
		var0_8 = arg1_8:getMaxClaimedTrophy() ~= nil
	end

	if arg2_8 == var0_0.PAGE_LIMITED and arg0_8._hideExpire and arg1_8:IsExpire() == 1 and not arg1_8:getProgressTrophy():isClaimed() then
		var0_8 = false
	end

	return var0_8
end

function var0_0.ensureTrophyViewCache(arg0_9, arg1_9)
	local var0_9 = arg0_9._trophyViewCache[arg1_9]

	if var0_9 then
		return var0_9
	end

	local var1_9 = cloneTplTo(arg0_9._trophyUpperTpl, arg0_9._trophyContainer)
	local var2_9 = cloneTplTo(arg0_9._trophyLowerTpl, arg0_9._trophyContainer)
	local var3_9 = TrophyView.New(var1_9)
	local var4_9 = TrophyView.New(var2_9)

	local function var5_9()
		local var0_10 = arg0_9.trophyGroups[arg1_9]
		local var1_10 = var0_10:getProgressTrophy()
		local var2_10 = arg0_9._trophyTFList[arg1_9]

		if not var2_10 then
			return
		end

		if var1_10:canClaimed() and not var1_10:isClaimed() then
			if not var2_10:IsPlaying() then
				arg0_9:emit(TrophyGalleryMediator.ON_TROPHY_CLAIM, var1_10.id)
			end
		elseif not var2_10:IsPlaying() then
			arg0_9:openTrophyDetail(var0_10, var1_10)
		end
	end

	onButton(arg0_9, var1_9.transform:Find("frame"), var5_9)
	onButton(arg0_9, var2_9.transform:Find("frame"), var5_9)
	setActive(var1_9, false)
	setActive(var2_9, false)

	local var6_9 = {
		upperGO = var1_9,
		lowerGO = var2_9,
		upperView = var3_9,
		lowerView = var4_9
	}

	arg0_9._trophyViewCache[arg1_9] = var6_9

	return var6_9
end

function var0_0.updateTrophyViewByFilter(arg0_11, arg1_11, arg2_11, arg3_11)
	if arg3_11 == "all" then
		arg1_11:UpdateTrophyGroup(arg2_11)
	elseif arg3_11 == "claimed" then
		arg1_11:ClaimForm(arg2_11)
	elseif arg3_11 == "unclaim" then
		arg1_11:ProgressingForm(arg2_11)
	end
end

function var0_0.updateTrophyReminderMaterial(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetTrophyClaimTipsID()
	local var1_12 = arg0_12._trophyMatCache[var0_12]

	if var1_12 then
		arg1_12:SetTrophyReminderMaterial(var1_12)

		return
	end

	local var2_12 = "artresource/effect/xunzhang/materials/" .. var0_12

	if checkABExist(var2_12) then
		arg0_12._loader:LoadBundle(var2_12, function(arg0_13)
			local var0_13 = arg0_13:LoadAssetSync(var0_12, typeof(Material), false, false)

			arg0_12._trophyMatCache[var0_12] = var0_13

			arg1_12:SetTrophyReminderMaterial(var0_13)
		end)
	end
end

function var0_0.didEnter(arg0_14)
	arg0_14:OverlayPanel(arg0_14._tf)
	onButton(arg0_14, arg0_14._backBtn, function()
		arg0_14:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_14, arg0_14._filterBtn, function()
		arg0_14:onFilter()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.medal_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14._hideExpireBtn, function()
		arg0_14._hideExpire = not arg0_14._hideExpire

		setActive(arg0_14._hideExpireCheck, not arg0_14._hideExpire)
		arg0_14:updateTrophyList()
	end, SFX_PANEL)
	triggerButton(arg0_14._hideExpireBtn)

	for iter0_14, iter1_14 in ipairs(arg0_14._pageToggle) do
		onButton(arg0_14, iter1_14, function()
			arg0_14:updatePage(iter0_14)
		end, SFX_PANEL)
	end

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_14.toggleLoveLetter:Find("tip"), {
		"love_letter_level_up",
		"love_letter_level_reward"
	}, function(arg0_20)
		local var0_20 = getProxy(LoveLetterProxy)

		setActive(arg0_20, var0_20:IsTipLevelUp() or var0_20:IsTipAllLevelReward())
	end)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_14.rtCountLevelPanel:Find("info/icon/tip"), {
		"love_letter_level_up",
		"love_letter_level_reward"
	}, function(arg0_21)
		setActive(arg0_21, getProxy(LoveLetterProxy):IsTipAllLevelReward())
	end)

	arg0_14._filterIndex = 0

	triggerButton(arg0_14._filterBtn)
	triggerButton(arg0_14._pageToggle[arg0_14._pageIndex])
	arg0_14:updateTrophyCounter()
end

function var0_0.updatePage(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22._pageToggle) do
		setActive(iter1_22:Find("selected"), iter0_22 == arg1_22)
		setActive(iter1_22:Find("Image"), iter0_22 ~= arg1_22)
	end

	arg0_22._pageIndex = arg1_22

	local var0_22 = arg1_22 == 3

	setActive(arg0_22._center, not var0_22)
	setActive(arg0_22._topPanel:Find("filter"), not var0_22)
	setActive(arg0_22.rtLoveLetterPanel, var0_22)
	setActive(arg0_22.rtCountLevelPanel, var0_22)
	setActive(arg0_22.rtCountLevelBg, var0_22)

	if var0_22 then
		arg0_22:updateLoveLetterPage()
	else
		arg0_22:updateTrophyList()
	end

	setActive(arg0_22._hideExpireBtn, arg1_22 == var0_0.PAGE_LIMITED)
end

function var0_0.updateTrophyList(arg0_23)
	arg0_23._trophyTFList = {}

	for iter0_23, iter1_23 in pairs(arg0_23._trophyViewCache) do
		setActive(iter1_23.upperGO, false)
		setActive(iter1_23.lowerGO, false)
	end

	local var0_23 = var0_0.Filter[arg0_23._filterIndex]
	local var1_23 = arg0_23._pageIndex
	local var2_23 = 1

	for iter2_23, iter3_23 in pairs(arg0_23.trophyGroups) do
		if arg0_23:checkTrophyVisible(iter3_23, var1_23, var0_23) then
			local var3_23 = arg0_23:ensureTrophyViewCache(iter2_23)
			local var4_23 = math.fmod(var2_23, 2) == 1
			local var5_23 = var4_23 and var3_23.upperGO or var3_23.lowerGO
			local var6_23 = var4_23 and var3_23.lowerGO or var3_23.upperGO
			local var7_23 = var4_23 and var3_23.upperView or var3_23.lowerView

			setActive(var5_23, true)
			setActive(var6_23, false)
			var5_23.transform:SetSiblingIndex(var2_23 - 1)
			arg0_23:updateTrophyViewByFilter(var7_23, iter3_23, var0_23)
			arg0_23:updateTrophyReminderMaterial(var7_23)

			arg0_23._trophyTFList[iter2_23] = var7_23
			var2_23 = var2_23 + 1
		end
	end
end

function var0_0.PlayTrophyClaim(arg0_24, arg1_24)
	local var0_24 = arg0_24.trophyGroups[arg1_24]
	local var1_24 = arg0_24._trophyTFList[arg1_24]
	local var2_24 = Instantiate(arg0_24._reminderRes:Find("claim_fx"))

	var1_24:PlayClaimAnima(var0_24, var2_24, function()
		arg0_24:updateTrophyByGroup(arg1_24)
		arg0_24:updateTrophyCounter()
	end)
end

function var0_0.updateTrophyByGroup(arg0_26, arg1_26)
	local var0_26 = arg0_26.trophyGroups[arg1_26]

	arg0_26._trophyTFList[arg1_26]:UpdateTrophyGroup(var0_26)
end

function var0_0.openTrophyDetail(arg0_27, arg1_27, arg2_27)
	arg0_27._trophyDetailPanel:SetTrophyGroup(arg1_27)
	arg0_27._trophyDetailPanel:UpdateTrophy(arg2_27)
	arg0_27._trophyDetailPanel:SetActive(true)
end

function var0_0.updateTrophyCounter(arg0_28)
	local var0_28 = 0

	for iter0_28, iter1_28 in pairs(arg0_28.trophyList) do
		if iter1_28:isClaimed() and not iter1_28:isHide() then
			var0_28 = var0_28 + 1
		end
	end

	setText(arg0_28._trophyCounter, var0_28)
end

function var0_0.onFilter(arg0_29)
	arg0_29._filterIndex = arg0_29._filterIndex + 1

	if arg0_29._filterIndex > #var0_0.Filter then
		arg0_29._filterIndex = 1
	end

	for iter0_29 = 1, #var0_0.Filter do
		setActive(arg0_29._filterBtn:GetChild(iter0_29 - 1), iter0_29 == arg0_29._filterIndex)
	end

	arg0_29:updateTrophyList()
end

function var0_0.updateLoveLetterPage(arg0_30)
	if not arg0_30.contextData.checkRalizeGift then
		arg0_30.contextData.checkRalizeGift = true

		if getProxy(LoveLetterProxy):IsTipRealizeGift() then
			arg0_30:emit(TrophyGalleryMediator.OPEN_REALIZE_GIFT_LAYER)
		end
	end

	arg0_30.cardInfos = getProxy(LoveLetterProxy):GetDisplayGroupList()

	arg0_30.cardList:SetTotalCount(#arg0_30.cardInfos, -1)

	local var0_30 = getProxy(LoveLetterProxy)
	local var1_30 = arg0_30.rtCountLevelPanel:Find("info")

	setText(var1_30:Find("word"), i18n("loveactivity_ui_10"))

	local var2_30 = var0_30:GetAllLevel()

	setText(var1_30:Find("count"), var2_30)

	local var3_30, var4_30 = var0_30:GetAllLevelProgress()

	if var4_30 == 0 then
		setSlider(var1_30:Find("Slider"), 0, 1, 1)
	else
		setSlider(var1_30:Find("Slider"), 0, var4_30, var3_30)
	end

	setText(var1_30:Find("Slider/Text"), var3_30 .. "/" .. var4_30)

	local var5_30 = var0_30:GetAllLevelNextAward()

	updateDrop(var1_30:Find("icon/mask/IconTpl"), var5_30[1])
	onButton(arg0_30, var1_30:Find("icon/mask/IconTpl"), function()
		arg0_30:emit(BaseUI.ON_DROP, drop[1])
	end, SFX_PANEL)
	setActive(var1_30:Find("icon/got"), var4_30 == 0)
	onButton(arg0_30, var1_30:Find("click"), function()
		local var0_32 = getProxy(LoveLetterProxy):GetAllLevelReadyReward()

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_LOVE_LETTER_LEVEL_REWARD, {
			btnList = #var0_32 > 0 and {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.cancel,
					name = i18n("msgbox_text_cancel"),
					sound = SFX_CANCEL
				},
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
					name = i18n("mail_get_oneclick"),
					func = function()
						arg0_30:emit(TrophyGalleryMediator.ON_GET_ALL_LOVE_LETTER_REWARD, var0_32)
					end,
					sound = SFX_CONFIRM
				}
			} or nil
		})
	end, SFX_PANEL)
end

function var0_0.onInitCard(arg0_34, arg1_34)
	local var0_34 = LoveLetterShipCard.New(arg1_34)

	onButton(arg0_34, var0_34.go, function()
		if var0_34.shipGroup then
			arg0_34:emit(TrophyGalleryMediator.OPEN_DISPLAY_WINDOW, var0_34.shipGroup.id)
		end
	end)

	arg0_34.cardItems[arg1_34] = var0_34
end

function var0_0.onUpdateCard(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.cardItems[arg2_36]

	if not var0_36 then
		arg0_36:onInitCard(arg2_36)

		var0_36 = arg0_36.cardItems[arg2_36]
	end

	local var1_36 = arg1_36 + 1
	local var2_36 = arg0_36.cardInfos[var1_36]

	var0_36:update(var2_36)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg2_36.transform:Find("content/pick_up"), {
		"love_letter_level_up"
	}, function(arg0_37)
		local var0_37 = getProxy(LoveLetterProxy):GetGroupData(var2_36.id)

		setActive(arg0_37, var0_37:GetDisplayLevel() < var0_37:GetMaxLevel() and var0_37:CanLevelUp())
	end)
end

function var0_0.onReturnCard(arg0_38, arg1_38, arg2_38)
	if arg0_38.exited then
		return
	end

	local var0_38 = arg0_38.cardItems[arg2_38]

	if var0_38 then
		var0_38:clear()
	end

	arg0_38.cardItems[arg2_38] = nil
end

function var0_0.onBackPressed(arg0_39)
	if arg0_39._trophyDetailPanel:IsActive() then
		arg0_39._trophyDetailPanel:SetActive(false)
	else
		var0_0.super.onBackPressed(arg0_39)
	end
end

function var0_0.willExit(arg0_40)
	arg0_40._loader:Clear()
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_40.toggleLoveLetter:Find("tip"))
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_40.rtCountLevelPanel:Find("info/icon/tip"))

	for iter0_40, iter1_40 in pairs(arg0_40.cardItems) do
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(iter0_40.transform:Find("content/pick_up"))
	end

	arg0_40:UnOverlayPanel(arg0_40._blurPanel, arg0_40._tf)
	arg0_40._trophyDetailPanel:Dispose()
end

return var0_0

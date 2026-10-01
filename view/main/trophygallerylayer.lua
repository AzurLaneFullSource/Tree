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

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/trophygalleryui",
		"ui/iconcolorful",
		"ui/newstyleloveletterrewardmsgboxui"
	}

	local function var1_2()
		local var0_3 = {}

		for iter0_3, iter1_3 in ipairs(pg.medal_template.all) do
			local var1_3 = pg.medal_template[iter1_3]
			local var2_3 = var1_3.icon
			local var3_3 = var1_3.label

			if var2_3 and var2_3 ~= "" then
				table.insert(var0_3, ResPathSupport.CombinePath("medal", var2_3))
				table.insert(var0_3, ResPathSupport.CombinePath("medal", "s_" .. var2_3))

				local var4_3 = tonumber(var2_3)

				if var4_3 < 9000 then
					var4_3 = var4_3 - var4_3 % 10

					table.insert(var0_3, ResPathSupport.CombinePath("artresource/effect/xunzhang/materials", "xunzhang" .. var4_3))
				else
					local var5_3 = var4_3 - var4_3 % 10 + 1

					table.insert(var0_3, ResPathSupport.CombinePath("artresource/effect/xunzhang/materials", "xunzhang" .. var5_3))
				end
			end

			if var3_3 and var3_3 ~= "" then
				table.insert(var0_3, ResPathSupport.CombinePath("medal", var3_3))
			end
		end

		return ResPathSupport.UniqueLuaArr(var0_3)
	end

	local function var2_2()
		local var0_4 = {}
		local var1_4 = {}
		local var2_4 = {}

		for iter0_4, iter1_4 in ipairs(pg.lover_character_template.all) do
			local var3_4 = pg.lover_character_template[iter1_4]
			local var4_4 = var3_4.exp_up
			local var5_4 = var3_4.exp_upper_limit

			if var4_4 and var4_4 > 0 and var5_4 and var5_4 > 0 then
				local var6_4 = math.floor(var5_4 / var4_4)
				local var7_4 = math.floor((var6_4 - 1) / 10) + 1

				for iter2_4 = 1, var7_4 do
					table.insert(var0_4, "lovelettermedal/default_" .. iter2_4)
				end
			end
		end

		for iter3_4, iter4_4 in ipairs(getProxy(LoveLetterProxy):GetDisplayGroupList()) do
			table.insertto(var1_4, ResPathSupport.GetPaintingShipYardIconListByPaintingName(iter4_4:getPainting()))
			table.insert(var2_4, string.format(ResPathSupport.ConstPath.BG.ShipCard, iter4_4:rarity2bgPrint()))
		end

		return ResPathSupport.MergeLuaArr(var1_4, var0_4, var2_4)
	end

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var1_2(), var2_2())
end

function var0_0.setTrophyGroups(arg0_5, arg1_5)
	arg0_5.trophyGroups = arg1_5
end

function var0_0.setTrophyList(arg0_6, arg1_6)
	arg0_6.trophyList = arg1_6
end

function var0_0.init(arg0_7)
	arg0_7._bg = arg0_7._tf:Find("bg")
	arg0_7._blurPanel = arg0_7._tf:Find("blur_panel")
	arg0_7._topPanel = arg0_7._blurPanel:Find("adapt/top")
	arg0_7._backBtn = arg0_7._topPanel:Find("back_btn")
	arg0_7._helpBtn = arg0_7._topPanel:Find("help_btn")
	arg0_7._center = arg0_7._tf:Find("bg/taskBGCenter")
	arg0_7._trophyUpperTpl = arg0_7:getTpl("trophy_upper", arg0_7._center)
	arg0_7._trophyLowerTpl = arg0_7:getTpl("trophy_lower", arg0_7._center)
	arg0_7._trophyContainer = arg0_7._tf:Find("bg/taskBGCenter/right_panel/Grid")
	arg0_7._scrllPanel = arg0_7._tf:Find("bg/taskBGCenter/right_panel")
	arg0_7._scrollView = arg0_7._scrllPanel:GetComponent("LScrollRect")
	arg0_7._trophyDetailPanel = TrophyDetailPanel.New(arg0_7._tf:Find("trophyPanel"), arg0_7._tf)
	arg0_7._filterBtn = arg0_7._topPanel:Find("filter/toggle")
	arg0_7._trophyCounter = arg0_7._topPanel:Find("filter/counter/Text")
	arg0_7._reminderRes = arg0_7._tf:Find("bg/resource")
	arg0_7._pageToggle = {
		arg0_7._tf:Find("blur_panel/adapt/left_length/frame/root/common_toggle"),
		arg0_7._tf:Find("blur_panel/adapt/left_length/frame/root/limited_toggle"),
		arg0_7.toggleLoveLetter
	}
	arg0_7._hideExpireBtn = arg0_7._tf:Find("blur_panel/adapt/top/expireCheckBox")
	arg0_7._hideExpireCheck = arg0_7._hideExpireBtn:Find("check")
	arg0_7._pageIndex = arg0_7.contextData.index or 1
	arg0_7._hideExpire = false
	arg0_7._trophyTFList = {}
	arg0_7._trophyViewCache = {}
	arg0_7._trophyMatCache = {}
	arg0_7.cardItems = {}
	arg0_7.cardList = arg0_7.rtScrollContent:GetComponent("LScrollRect")

	function arg0_7.cardList.onInitItem(arg0_8)
		arg0_7:onInitCard(arg0_8)
	end

	function arg0_7.cardList.onUpdateItem(arg0_9, arg1_9)
		arg0_7:onUpdateCard(arg0_9, arg1_9)
	end

	function arg0_7.cardList.onReturnItem(arg0_10, arg1_10)
		arg0_7:onReturnCard(arg0_10, arg1_10)
	end

	arg0_7._loader = AutoLoader.New()
end

function var0_0.checkTrophyVisible(arg0_11, arg1_11, arg2_11, arg3_11)
	if arg1_11:GetTrophyPage() ~= arg2_11 then
		return false
	end

	local var0_11 = false

	if arg3_11 == "all" then
		var0_11 = true
	elseif arg3_11 == "claimed" then
		var0_11 = arg1_11:getMaxClaimedTrophy() ~= nil
	end

	if arg2_11 == var0_0.PAGE_LIMITED and arg0_11._hideExpire and arg1_11:IsExpire() == 1 and not arg1_11:getProgressTrophy():isClaimed() then
		var0_11 = false
	end

	return var0_11
end

function var0_0.ensureTrophyViewCache(arg0_12, arg1_12)
	local var0_12 = arg0_12._trophyViewCache[arg1_12]

	if var0_12 then
		return var0_12
	end

	local var1_12 = cloneTplTo(arg0_12._trophyUpperTpl, arg0_12._trophyContainer)
	local var2_12 = cloneTplTo(arg0_12._trophyLowerTpl, arg0_12._trophyContainer)
	local var3_12 = TrophyView.New(var1_12)
	local var4_12 = TrophyView.New(var2_12)

	local function var5_12()
		local var0_13 = arg0_12.trophyGroups[arg1_12]
		local var1_13 = var0_13:getProgressTrophy()
		local var2_13 = arg0_12._trophyTFList[arg1_12]

		if not var2_13 then
			return
		end

		if var1_13:canClaimed() and not var1_13:isClaimed() then
			if not var2_13:IsPlaying() then
				arg0_12:emit(TrophyGalleryMediator.ON_TROPHY_CLAIM, var1_13.id)
			end
		elseif not var2_13:IsPlaying() then
			arg0_12:openTrophyDetail(var0_13, var1_13)
		end
	end

	onButton(arg0_12, var1_12.transform:Find("frame"), var5_12)
	onButton(arg0_12, var2_12.transform:Find("frame"), var5_12)
	setActive(var1_12, false)
	setActive(var2_12, false)

	local var6_12 = {
		upperGO = var1_12,
		lowerGO = var2_12,
		upperView = var3_12,
		lowerView = var4_12
	}

	arg0_12._trophyViewCache[arg1_12] = var6_12

	return var6_12
end

function var0_0.updateTrophyViewByFilter(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg3_14 == "all" then
		arg1_14:UpdateTrophyGroup(arg2_14)
	elseif arg3_14 == "claimed" then
		arg1_14:ClaimForm(arg2_14)
	elseif arg3_14 == "unclaim" then
		arg1_14:ProgressingForm(arg2_14)
	end
end

function var0_0.updateTrophyReminderMaterial(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetTrophyClaimTipsID()
	local var1_15 = arg0_15._trophyMatCache[var0_15]

	if var1_15 then
		arg1_15:SetTrophyReminderMaterial(var1_15)

		return
	end

	local var2_15 = "artresource/effect/xunzhang/materials/" .. var0_15

	if checkABExist(var2_15) then
		arg0_15._loader:LoadBundle(var2_15, function(arg0_16)
			local var0_16 = arg0_16:LoadAssetSync(var0_15, typeof(Material), false, false)

			arg0_15._trophyMatCache[var0_15] = var0_16

			arg1_15:SetTrophyReminderMaterial(var0_16)
		end)
	end
end

function var0_0.didEnter(arg0_17)
	arg0_17:OverlayPanel(arg0_17._tf)
	onButton(arg0_17, arg0_17._backBtn, function()
		arg0_17:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17._filterBtn, function()
		arg0_17:onFilter()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.medal_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17._hideExpireBtn, function()
		arg0_17._hideExpire = not arg0_17._hideExpire

		setActive(arg0_17._hideExpireCheck, not arg0_17._hideExpire)
		arg0_17:updateTrophyList()
	end, SFX_PANEL)
	triggerButton(arg0_17._hideExpireBtn)

	for iter0_17, iter1_17 in ipairs(arg0_17._pageToggle) do
		onButton(arg0_17, iter1_17, function()
			arg0_17:updatePage(iter0_17)
		end, SFX_PANEL)
	end

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_17.toggleLoveLetter:Find("tip"), {
		"love_letter_level_up",
		"love_letter_level_reward"
	}, function(arg0_23)
		local var0_23 = getProxy(LoveLetterProxy)

		setActive(arg0_23, var0_23:IsTipLevelUp() or var0_23:IsTipAllLevelReward())
	end)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_17.rtCountLevelPanel:Find("info/icon/tip"), {
		"love_letter_level_up",
		"love_letter_level_reward"
	}, function(arg0_24)
		setActive(arg0_24, getProxy(LoveLetterProxy):IsTipAllLevelReward())
	end)

	arg0_17._filterIndex = 0

	triggerButton(arg0_17._filterBtn)
	triggerButton(arg0_17._pageToggle[arg0_17._pageIndex])
	arg0_17:updateTrophyCounter()
end

function var0_0.updatePage(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25._pageToggle) do
		setActive(iter1_25:Find("selected"), iter0_25 == arg1_25)
		setActive(iter1_25:Find("Image"), iter0_25 ~= arg1_25)
	end

	arg0_25._pageIndex = arg1_25

	local var0_25 = arg1_25 == 3

	setActive(arg0_25._center, not var0_25)
	setActive(arg0_25._topPanel:Find("filter"), not var0_25)
	setActive(arg0_25.rtLoveLetterPanel, var0_25)
	setActive(arg0_25.rtCountLevelPanel, var0_25)
	setActive(arg0_25.rtCountLevelBg, var0_25)

	if var0_25 then
		arg0_25:updateLoveLetterPage()
	else
		arg0_25:updateTrophyList()
	end

	setActive(arg0_25._hideExpireBtn, arg1_25 == var0_0.PAGE_LIMITED)
end

function var0_0.updateTrophyList(arg0_26)
	arg0_26._trophyTFList = {}

	for iter0_26, iter1_26 in pairs(arg0_26._trophyViewCache) do
		setActive(iter1_26.upperGO, false)
		setActive(iter1_26.lowerGO, false)
	end

	local var0_26 = var0_0.Filter[arg0_26._filterIndex]
	local var1_26 = arg0_26._pageIndex
	local var2_26 = 1

	for iter2_26, iter3_26 in pairs(arg0_26.trophyGroups) do
		if arg0_26:checkTrophyVisible(iter3_26, var1_26, var0_26) then
			local var3_26 = arg0_26:ensureTrophyViewCache(iter2_26)
			local var4_26 = math.fmod(var2_26, 2) == 1
			local var5_26 = var4_26 and var3_26.upperGO or var3_26.lowerGO
			local var6_26 = var4_26 and var3_26.lowerGO or var3_26.upperGO
			local var7_26 = var4_26 and var3_26.upperView or var3_26.lowerView

			setActive(var5_26, true)
			setActive(var6_26, false)
			var5_26.transform:SetSiblingIndex(var2_26 - 1)
			arg0_26:updateTrophyViewByFilter(var7_26, iter3_26, var0_26)
			arg0_26:updateTrophyReminderMaterial(var7_26)

			arg0_26._trophyTFList[iter2_26] = var7_26
			var2_26 = var2_26 + 1
		end
	end
end

function var0_0.PlayTrophyClaim(arg0_27, arg1_27)
	local var0_27 = arg0_27.trophyGroups[arg1_27]
	local var1_27 = arg0_27._trophyTFList[arg1_27]
	local var2_27 = Instantiate(arg0_27._reminderRes:Find("claim_fx"))

	var1_27:PlayClaimAnima(var0_27, var2_27, function()
		arg0_27:updateTrophyByGroup(arg1_27)
		arg0_27:updateTrophyCounter()
	end)
end

function var0_0.updateTrophyByGroup(arg0_29, arg1_29)
	local var0_29 = arg0_29.trophyGroups[arg1_29]

	arg0_29._trophyTFList[arg1_29]:UpdateTrophyGroup(var0_29)
end

function var0_0.openTrophyDetail(arg0_30, arg1_30, arg2_30)
	arg0_30._trophyDetailPanel:SetTrophyGroup(arg1_30)
	arg0_30._trophyDetailPanel:UpdateTrophy(arg2_30)
	arg0_30._trophyDetailPanel:SetActive(true)
end

function var0_0.updateTrophyCounter(arg0_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in pairs(arg0_31.trophyList) do
		if iter1_31:isClaimed() and not iter1_31:isHide() then
			var0_31 = var0_31 + 1
		end
	end

	setText(arg0_31._trophyCounter, var0_31)
end

function var0_0.onFilter(arg0_32)
	arg0_32._filterIndex = arg0_32._filterIndex + 1

	if arg0_32._filterIndex > #var0_0.Filter then
		arg0_32._filterIndex = 1
	end

	for iter0_32 = 1, #var0_0.Filter do
		setActive(arg0_32._filterBtn:GetChild(iter0_32 - 1), iter0_32 == arg0_32._filterIndex)
	end

	arg0_32:updateTrophyList()
end

function var0_0.updateLoveLetterPage(arg0_33)
	if not arg0_33.contextData.checkRalizeGift then
		arg0_33.contextData.checkRalizeGift = true

		if getProxy(LoveLetterProxy):IsTipRealizeGift() then
			arg0_33:emit(TrophyGalleryMediator.OPEN_REALIZE_GIFT_LAYER)
		end
	end

	arg0_33.cardInfos = getProxy(LoveLetterProxy):GetDisplayGroupList()

	arg0_33.cardList:SetTotalCount(#arg0_33.cardInfos, -1)

	local var0_33 = getProxy(LoveLetterProxy)
	local var1_33 = arg0_33.rtCountLevelPanel:Find("info")

	setText(var1_33:Find("word"), i18n("loveactivity_ui_10"))

	local var2_33 = var0_33:GetAllLevel()

	setText(var1_33:Find("count"), var2_33)

	local var3_33, var4_33 = var0_33:GetAllLevelProgress()

	if var4_33 == 0 then
		setSlider(var1_33:Find("Slider"), 0, 1, 1)
	else
		setSlider(var1_33:Find("Slider"), 0, var4_33, var3_33)
	end

	setText(var1_33:Find("Slider/Text"), var3_33 .. "/" .. var4_33)

	local var5_33 = var0_33:GetAllLevelNextAward()

	updateDrop(var1_33:Find("icon/mask/IconTpl"), var5_33[1])
	onButton(arg0_33, var1_33:Find("icon/mask/IconTpl"), function()
		arg0_33:emit(BaseUI.ON_DROP, drop[1])
	end, SFX_PANEL)
	setActive(var1_33:Find("icon/got"), var4_33 == 0)
	onButton(arg0_33, var1_33:Find("click"), function()
		local var0_35 = getProxy(LoveLetterProxy):GetAllLevelReadyReward()

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_LOVE_LETTER_LEVEL_REWARD, {
			btnList = #var0_35 > 0 and {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.cancel,
					name = i18n("msgbox_text_cancel"),
					sound = SFX_CANCEL
				},
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
					name = i18n("mail_get_oneclick"),
					func = function()
						arg0_33:emit(TrophyGalleryMediator.ON_GET_ALL_LOVE_LETTER_REWARD, var0_35)
					end,
					sound = SFX_CONFIRM
				}
			} or nil
		})
	end, SFX_PANEL)
end

function var0_0.onInitCard(arg0_37, arg1_37)
	local var0_37 = LoveLetterShipCard.New(arg1_37)

	onButton(arg0_37, var0_37.go, function()
		if var0_37.shipGroup then
			arg0_37:emit(TrophyGalleryMediator.OPEN_DISPLAY_WINDOW, var0_37.shipGroup.id)
		end
	end)

	arg0_37.cardItems[arg1_37] = var0_37
end

function var0_0.onUpdateCard(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.cardItems[arg2_39]

	if not var0_39 then
		arg0_39:onInitCard(arg2_39)

		var0_39 = arg0_39.cardItems[arg2_39]
	end

	local var1_39 = arg1_39 + 1
	local var2_39 = arg0_39.cardInfos[var1_39]

	var0_39:update(var2_39)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg2_39.transform:Find("content/pick_up"), {
		"love_letter_level_up"
	}, function(arg0_40)
		local var0_40 = getProxy(LoveLetterProxy):GetGroupData(var2_39.id)

		setActive(arg0_40, var0_40:GetDisplayLevel() < var0_40:GetMaxLevel() and var0_40:CanLevelUp())
	end)
end

function var0_0.onReturnCard(arg0_41, arg1_41, arg2_41)
	if arg0_41.exited then
		return
	end

	local var0_41 = arg0_41.cardItems[arg2_41]

	if var0_41 then
		var0_41:clear()
	end

	arg0_41.cardItems[arg2_41] = nil
end

function var0_0.onBackPressed(arg0_42)
	if arg0_42._trophyDetailPanel:IsActive() then
		arg0_42._trophyDetailPanel:SetActive(false)
	else
		var0_0.super.onBackPressed(arg0_42)
	end
end

function var0_0.willExit(arg0_43)
	arg0_43._loader:Clear()
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_43.toggleLoveLetter:Find("tip"))
	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_43.rtCountLevelPanel:Find("info/icon/tip"))

	for iter0_43, iter1_43 in pairs(arg0_43.cardItems) do
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(iter0_43.transform:Find("content/pick_up"))
	end

	arg0_43:UnOverlayPanel(arg0_43._blurPanel, arg0_43._tf)
	arg0_43._trophyDetailPanel:Dispose()
end

return var0_0

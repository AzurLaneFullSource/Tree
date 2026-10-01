local var0_0 = class("MetaCharacterScene", import("...base.BaseUI"))

var0_0.PAGES = {
	REPAIR = 3,
	ENERGY = 1,
	TACTICS = 2,
	SYN = 4
}
var0_0.PAGES_EVENTS = {
	MetaCharacterMediator.ON_ENERGY,
	MetaCharacterMediator.ON_TACTICS,
	MetaCharacterMediator.ON_REPAIR,
	MetaCharacterMediator.ON_SYN
}
var0_0.SCALE_ON_PITCH = {
	x = 1.7,
	y = 1.7
}
var0_0.ON_SKILL = "MetaCharacterScene:ON_SKILL"

function var0_0.getUIName(arg0_1)
	return "MetaCharacterUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/metacharacterui",
		"ui/metacharactertacticsui",
		"ui/metacharacterenergyui",
		"ui/metacharacterrepairui",
		"ui/metacharactersynui"
	}
	local var1_2 = {}
	local var2_2 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0_2, iter1_2 in ipairs(var2_2) do
		if iter1_2 and iter1_2:isShow() then
			local var3_2, var4_2 = iter1_2:getBannerPathAndName()

			table.insert(var1_2, var3_2)

			local var5_2, var6_2 = iter1_2:getPaintPathAndName()

			table.insert(var1_2, var5_2)

			local var7_2, var8_2 = iter1_2:getBGNamePathAndName()

			table.insert(var1_2, var7_2)
		end
	end

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var1_2)
end

function var0_0.init(arg0_3)
	Input.multiTouchEnabled = false

	arg0_3:initUITextTips()
	arg0_3:initData()
	arg0_3:findUI()
	arg0_3:addListener()
	arg0_3:initMetaProgressList()
	arg0_3:initBannerList()
end

function var0_0.didEnter(arg0_4)
	arg0_4:overLayPanel(true)
	arg0_4:updateStart()
	arg0_4:autoOpenFunc()
end

function var0_0.willExit(arg0_5)
	Input.multiTouchEnabled = true

	arg0_5:overLayPanel(false)
end

function var0_0.initUITextTips(arg0_6)
	local var0_6 = arg0_6._tf:Find("HidePanel/ScrollPanel/ListPanel/BannerTpl/ForScale")
	local var1_6 = var0_6:Find("Empty/ActType/TipText")
	local var2_6 = var0_6:Find("Empty/BuildType/TipText")
	local var3_6 = var0_6:Find("Active/ActType/Text")
	local var4_6 = var0_6:Find("Active/BuildType/Text")

	setText(var1_6, i18n("meta_syn_rate"))
	setText(var2_6, i18n("meta_build"))
	setText(var3_6, i18n("meta_repair_rate"))
	setText(var4_6, i18n("meta_build"))

	local var5_6 = arg0_6._tf:Find("HidePanel/PTPanel/Progress/Story/TipText1")
	local var6_6 = arg0_6._tf:Find("HidePanel/PTPanel/Progress/Story/TipText2")

	setText(var5_6, i18n("meta_story_tip_1"))
	setText(var6_6, i18n("meta_story_tip_2"))

	local var7_6 = arg0_6._tf:Find("HidePanel/ActTimeTip/Tip")

	setText(var7_6, i18n("meta_acttime_limit"))
end

function var0_0.initData(arg0_7)
	arg0_7.metaProgressVOList = {}
	arg0_7.curMetaGroupID = nil
	arg0_7.curMetaProgress = nil
	arg0_7.toggleList = {}
	arg0_7.bannerTFList = {}
	arg0_7.curPageIndex = nil
	arg0_7.curMetaIndex = nil
	arg0_7.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0_7.bayProxy = getProxy(BayProxy)
	arg0_7.indexDatas = {}
end

function var0_0.findUI(arg0_8)
	arg0_8.shipImg = arg0_8._tf:Find("HidePanel/ShipImg")
	arg0_8.shipNameImg = arg0_8._tf:Find("HidePanel/NameImg")
	arg0_8.noCharTF = arg0_8._tf:Find("BG/NoCharacter")
	arg0_8.indexBtn = arg0_8._tf:Find("blur_panel/adapt/top/index")
	arg0_8.hidePanel = arg0_8._tf:Find("HidePanel")
	arg0_8.scrollPanel = arg0_8.hidePanel:Find("ScrollPanel")
	arg0_8.bannerListPanel = arg0_8.scrollPanel:Find("ListPanel")
	arg0_8.bannerContainer = arg0_8.bannerListPanel:Find("Container")
	arg0_8.bannerTpl = arg0_8.bannerListPanel:Find("BannerTpl")
	arg0_8.actTimePanel = arg0_8.hidePanel:Find("ActTimeTip")
	arg0_8.actTimeText = arg0_8.actTimePanel:Find("Text")
	arg0_8.menuPanel = arg0_8.hidePanel:Find("MenuPanel")
	arg0_8.energyBtn = arg0_8.menuPanel:Find("EnergyBtn")
	arg0_8.repairBtn = arg0_8.menuPanel:Find("RepairBtn")
	arg0_8.tacticsBtn = arg0_8.menuPanel:Find("TacticsBtn")
	arg0_8.synBtn = arg0_8.menuPanel:Find("SynBtn")
	arg0_8.synDecorateTF = arg0_8.menuPanel:Find("SynDecorate")
	arg0_8.synBtnLimitTimeTF = arg0_8.synBtn:Find("Limit")
	arg0_8.synBtnLock = arg0_8.synBtn:Find("LockMask")
	arg0_8.ptPanel = arg0_8.hidePanel:Find("PTPanel")
	arg0_8.ptRedBarImg = arg0_8.ptPanel:Find("RedBar")
	arg0_8.ptPreviewBtn = arg0_8.ptPanel:Find("PreviewBtn")
	arg0_8.ptGetBtn = arg0_8.ptPanel:Find("SynBtn")
	arg0_8.ptGetBtnTag = arg0_8.ptGetBtn:Find("Tag")
	arg0_8.ptShowWayBtn = arg0_8.ptPanel:Find("ShowWayBtn")

	local var0_8 = arg0_8.ptPanel:Find("Progress")

	arg0_8.ptProgressImg = var0_8:Find("CircleProgress/ProgressImg")
	arg0_8.ptProgressScaleLine = var0_8:Find("CircleProgress/ScaleLine")
	arg0_8.ptInfoPanel = var0_8:Find("PT")
	arg0_8.ptProgressRedRightNumText = arg0_8.ptInfoPanel:Find("ProgressTextBG/PointRedText/RightNumText")
	arg0_8.ptProgressRedLeftNumText = arg0_8.ptInfoPanel:Find("ProgressTextBG/PointRedText/LeftNumText")
	arg0_8.ptProgressWhiteRightNumText = arg0_8.ptInfoPanel:Find("ProgressTextBG/PointText/RightNumText")
	arg0_8.ptProgressWhiteLeftNumText = arg0_8.ptInfoPanel:Find("ProgressTextBG/PointText/LeftNumText")
	arg0_8.ptIcon = arg0_8.ptInfoPanel:Find("PTProgressText/PTIcon")
	arg0_8.ptProgressRedText = arg0_8.ptInfoPanel:Find("PTProgressRedText")
	arg0_8.ptProgressWhiteText = arg0_8.ptInfoPanel:Find("PTProgressText")
	arg0_8.storyInfoPanel = var0_8:Find("Story")

	local var1_8 = arg0_8.storyInfoPanel:Find("TipText1")
	local var2_8 = arg0_8.storyInfoPanel:Find("TipText2")

	arg0_8.storyNameText = arg0_8.storyInfoPanel:Find("StroyNameText")
	arg0_8.getShipBtn = var0_8:Find("FinishBtn")
	arg0_8.goGetPanel = arg0_8.hidePanel:Find("GoGetPanel")
	arg0_8.goGetBtn = arg0_8.goGetPanel:Find("GoGetBtn")
	arg0_8.blurPanel = arg0_8._tf:Find("blur_panel")

	local var3_8 = arg0_8.blurPanel:Find("adapt")

	arg0_8.backBtn = var3_8:Find("top/back")
	arg0_8.helpBtn = var3_8:Find("top/help")
	arg0_8.toggleBtnsTF = var3_8:Find("left/Btns")
	arg0_8.toggleGroupSC = GetComponent(arg0_8.toggleBtnsTF, "ToggleGroup")
	arg0_8.toggleGroupSC.allowSwitchOff = true
	arg0_8.toggleList[1] = arg0_8.toggleBtnsTF:Find("Energy")
	arg0_8.toggleList[2] = arg0_8.toggleBtnsTF:Find("Tactics")
	arg0_8.toggleList[3] = arg0_8.toggleBtnsTF:Find("Repair")
	arg0_8.toggleList[4] = arg0_8.toggleBtnsTF:Find("Syn")
	arg0_8.synToggleLock = arg0_8.toggleBtnsTF:Find("SynLock")
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		local var0_10 = arg0_9.curPageIndex

		if var0_10 then
			arg0_9:enterMenuPage(false)
			arg0_9:emit(var0_0.PAGES_EVENTS[arg0_9.curPageIndex], nil, false)

			if var0_10 == var0_0.PAGES.REPAIR then
				arg0_9:backFromRepair()
			else
				arg0_9:backFromNotRepair()
			end
		else
			arg0_9:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.meta_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.indexBtn, function()
		arg0_9:openIndexLayer()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.goGetBtn, function()
		local var0_13 = arg0_9:getCurMetaProgressVO()
		local var1_13 = var0_13:isPassType()
		local var2_13 = var0_13:isBuildType()

		if var1_13 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
		elseif var2_13 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.ptPreviewBtn, function()
		arg0_9:emit(MetaCharacterMediator.OPEN_PT_PREVIEW_LAYER, arg0_9:getCurMetaProgressVO())
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.ptGetBtn, function()
		local var0_15 = arg0_9:getCurMetaProgressVO()
		local var1_15 = var0_15:getMetaProgressPTState()

		if var1_15 == MetaProgress.STATE_CAN_AWARD then
			local var2_15, var3_15 = arg0_9:getOneStepPTAwardLevelAndCount()

			pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
				groupID = var0_15.id,
				targetCount = var3_15
			})
		elseif var1_15 == MetaProgress.STATE_LESS_PT then
			local var4_15 = false
			local var5_15 = nowWorld()

			if var5_15 then
				var4_15 = var5_15:IsSystemOpen(WorldConst.SystemWorldBoss)
			end

			local var6_15 = var4_15 and "meta_pt_notenough" or "meta_boss_unlock"

			pg.TipsMgr.GetInstance():ShowTips(i18n(var6_15))
		elseif var1_15 == MetaProgress.STATE_LESS_STORY then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_story_lock"))
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.ptShowWayBtn, function()
		local var0_16 = false
		local var1_16 = nowWorld()

		if var1_16 then
			var0_16 = var1_16:IsSystemOpen(WorldConst.SystemWorldBoss)
		end

		local var2_16 = var0_16 and "meta_pt_notenough" or "meta_boss_unlock"

		pg.TipsMgr.GetInstance():ShowTips(i18n(var2_16))
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.getShipBtn, function()
		local var0_17 = arg0_9:getCurMetaProgressVO()
		local var1_17, var2_17 = var0_17.metaPtData:GetResProgress()

		pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
			groupID = var0_17.id,
			targetCount = var2_17
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.synToggleLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.synBtnLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end)
	onButton(arg0_9, arg0_9.repairBtn:Find("RepairBtn"), function()
		arg0_9:switchPage(var0_0.PAGES.REPAIR)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.energyBtn, function()
		arg0_9.isMainOpenLayerTag = true

		arg0_9:switchPage(var0_0.PAGES.ENERGY)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.tacticsBtn, function()
		arg0_9.isMainOpenLayerTag = true

		arg0_9:switchPage(var0_0.PAGES.TACTICS)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.synBtn, function()
		if not isActive(arg0_9.synBtnLock) then
			arg0_9.isMainOpenLayerTag = true

			arg0_9:switchPage(var0_0.PAGES.SYN)
		end
	end, SFX_PANEL)

	for iter0_9, iter1_9 in ipairs(arg0_9.toggleList) do
		onToggle(arg0_9, iter1_9, function(arg0_24)
			if arg0_9.curPageIndex == iter0_9 and arg0_24 == true then
				return
			end

			local var0_24 = arg0_9:getCurMetaProgressVO():getShip()

			if arg0_9.curPageIndex == iter0_9 and arg0_24 == false then
				arg0_9:enterMenuPage(false)
				arg0_9:emit(var0_0.PAGES_EVENTS[iter0_9], var0_24.id, false)
			end

			if arg0_9.curPageIndex ~= iter0_9 and arg0_24 == true then
				arg0_9:enterMenuPage(true)

				arg0_9.curPageIndex = iter0_9

				arg0_9:emit(var0_0.PAGES_EVENTS[iter0_9], var0_24.id, true)
			end
		end)
	end
end

function var0_0.resetToggleList(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.toggleList) do
		setActive(iter1_25:Find("On"), false)
		setActive(iter1_25:Find("Off"), true)
	end
end

function var0_0.initMetaProgressList(arg0_26)
	arg0_26.metaProgressVOList = arg0_26:getMetaProgressListForShow()

	arg0_26:fillMetaProgressList()
end

function var0_0.fillMetaProgressList(arg0_27)
	if #arg0_27.metaProgressVOList < 5 then
		for iter0_27 = #arg0_27.metaProgressVOList + 1, 5 do
			table.insert(arg0_27.metaProgressVOList, false)
		end
	end
end

function var0_0.initBannerList(arg0_28)
	arg0_28.scrollUIItemList = UIItemList.New(arg0_28.bannerContainer, arg0_28.bannerTpl)

	arg0_28.scrollUIItemList:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			table.insert(arg0_28.bannerTFList, arg2_29)

			local var0_29 = arg0_28.metaProgressVOList[arg1_29 + 1]

			arg0_28:updateBannerTF(var0_29, arg2_29, arg1_29 + 1)
		end
	end)
end

function var0_0.updateBannerTF(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = arg2_30
	local var1_30 = arg2_30:Find("ForScale")
	local var2_30 = var1_30:Find("WillCome")
	local var3_30 = var1_30:Find("Empty")
	local var4_30 = var1_30:Find("Active")

	if arg1_30 then
		local var5_30 = arg1_30:isInAct()
		local var6_30 = var3_30:Find("ActType/Tag")
		local var7_30 = var3_30:Find("BuildType/Tag")
		local var8_30 = var4_30:Find("ActType/Tag")
		local var9_30 = var4_30:Find("BuildType/Tag")

		setActive(var6_30, var5_30)
		setActive(var7_30, var5_30)
		setActive(var8_30, var5_30)
		setActive(var9_30, var5_30)
	end

	if arg1_30 then
		local var10_30 = Ship.New({
			configId = tonumber(arg1_30.configId .. 1)
		}):getName()
		local var11_30
		local var12_30 = var1_30:Find("Empty/ActType/ShipNameMask/ShipNameText")

		setText(var12_30, var10_30)
		setScrollText(var12_30, var10_30)
		setActive(var12_30, true)

		local var13_30 = var1_30:Find("Empty/BuildType/ShipNameMask/ShipNameText")

		setText(var13_30, var10_30)
		setScrollText(var13_30, var10_30)
		setActive(var13_30, true)

		local var14_30 = var1_30:Find("Empty/PassType/ShipNameMask/ShipNameText")

		setText(var14_30, var10_30)
		setScrollText(var14_30, var10_30)
		setActive(var14_30, true)

		local var15_30 = var1_30:Find("Active/ActType/ShipNameMask/ShipNameText")

		setText(var15_30, var10_30)
		setScrollText(var15_30, var10_30)
		setActive(var15_30, true)

		local var16_30 = var1_30:Find("Active/BuildType/ShipNameMask/ShipNameText")

		setText(var16_30, var10_30)
		setScrollText(var16_30, var10_30)
		setActive(var16_30, true)

		local var17_30 = var1_30:Find("Active/PassType/ShipNameMask/ShipNameText")

		setText(var17_30, var10_30)
		setScrollText(var17_30, var10_30)
		setActive(var17_30, true)
	end

	if arg1_30 == false then
		setActive(var2_30, true)
		setActive(var3_30, false)
		setActive(var4_30, false)
	else
		setActive(var2_30, false)

		local var18_30 = arg1_30:isUnlocked()

		setActive(var3_30, not var18_30)
		setActive(var4_30, var18_30)

		local var19_30 = arg1_30:isPtType()
		local var20_30 = arg1_30:isPassType()
		local var21_30 = arg1_30:isBuildType()

		if not var18_30 then
			local var22_30 = var1_30:Find("Empty/ActType")
			local var23_30 = var1_30:Find("Empty/BuildType")
			local var24_30 = var1_30:Find("Empty/PassType")

			setActive(var22_30, var19_30)
			setActive(var23_30, var21_30)
			setActive(var24_30, var20_30)

			local var25_30, var26_30 = arg1_30:getBannerPathAndName()
			local var27_30 = LoadSprite(var25_30, var26_30)

			setImageSprite(var22_30, var27_30)
			setImageSprite(var23_30, var27_30)
			setImageSprite(var24_30, var27_30)

			if var19_30 then
				local var28_30 = var22_30:Find("NumText")
				local var29_30 = string.format("%d", arg1_30:getSynRate() * 100) .. "%"

				setText(var28_30, var29_30)

				local var30_30 = var22_30:Find("Slider")

				setSlider(var30_30, 0, 1, arg1_30:getSynRate())
				setActive(var30_30, false)
			end

			local var31_30 = pg.ship_strengthen_meta[arg1_30.configId].ship_id
			local var32_30 = Ship.New({
				configId = var31_30
			})
			local var33_30 = var32_30:getMaxStar()
			local var34_30 = var32_30:getStar()
			local var35_30 = var1_30:Find("Empty/StarTpl")
			local var36_30 = var1_30:Find("Empty/Stars")
			local var37_30 = UIItemList.New(var36_30, var35_30)

			var37_30:make(function(arg0_31, arg1_31, arg2_31)
				if arg0_31 == UIItemList.EventUpdate then
					arg1_31 = arg1_31 + 1

					local var0_31 = arg2_31:Find("On")

					setActive(var0_31, arg1_31 <= var34_30)
				end
			end)
			var37_30:align(var33_30)
		else
			local var38_30 = var1_30:Find("Active/ActType")
			local var39_30 = var1_30:Find("Active/BuildType")
			local var40_30 = var1_30:Find("Active/PassType")

			setActive(var38_30, var19_30)
			setActive(var39_30, var21_30)
			setActive(var40_30, var20_30)

			local var41_30, var42_30 = arg1_30:getBannerPathAndName()
			local var43_30 = LoadSprite(var41_30, var42_30)

			setImageSprite(var1_30:Find("Active"), LoadSprite(var41_30, var42_30))

			local var44_30 = arg1_30:getShip()
			local var45_30 = var44_30:getMetaCharacter()

			if var19_30 then
				local var46_30 = var38_30:Find("NumText")
				local var47_30 = string.format("%d", var45_30:getRepairRate() * 100) .. "%"

				setText(var46_30, var47_30)

				local var48_30 = var38_30:Find("Slider")

				setSlider(var48_30, 0, 1, var45_30:getRepairRate())
				setActive(var48_30, false)
			end

			local var49_30 = var44_30:getMaxStar()
			local var50_30 = var44_30:getStar()
			local var51_30 = var1_30:Find("Active/StarTpl")
			local var52_30 = var1_30:Find("Active/Stars")
			local var53_30 = UIItemList.New(var52_30, var51_30)

			var53_30:make(function(arg0_32, arg1_32, arg2_32)
				if arg0_32 == UIItemList.EventUpdate then
					arg1_32 = arg1_32 + 1

					local var0_32 = arg2_32:Find("On")

					setActive(var0_32, arg1_32 <= var50_30)
				end
			end)
			var53_30:align(var49_30)
		end
	end

	onButton(arg0_30, var0_30, function()
		if arg0_30.curMetaIndex ~= arg3_30 then
			if arg0_30.curMetaIndex and arg0_30.curMetaIndex > 0 then
				arg0_30:changeBannerOnClick(arg0_30.bannerTFList[arg0_30.curMetaIndex], false)
			end

			arg0_30.curMetaIndex = arg3_30

			arg0_30:changeBannerOnClick(var0_30, true)
			arg0_30:updateMain()
		end
	end, SFX_PANEL)

	if arg1_30 == false then
		setButtonEnabled(var0_30, false)
	else
		setButtonEnabled(var0_30, true)
	end
end

function var0_0.changeBannerOnClick(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg1_34:GetComponent("LayoutElement")
	local var1_34 = arg1_34:Find("ForScale")

	if arg2_34 == true then
		setLocalScale(var1_34, var0_0.SCALE_ON_PITCH)

		var0_34.preferredWidth = 338.3
		var0_34.preferredHeight = 102
	else
		setLocalScale(var1_34, Vector2.one)

		var0_34.preferredWidth = 199
		var0_34.preferredHeight = 60
	end

	local var2_34 = var1_34:Find("SelectedTag")

	setActive(var2_34, arg2_34)
end

function var0_0.updateBannerShipName(arg0_35, arg1_35)
	local var0_35 = arg1_35:Find("ForScale")
	local var1_35 = var0_35:Find("SelectedTag")
	local var2_35 = isActive(var1_35)
	local var3_35
	local var4_35 = var0_35:Find("Empty/ActType/ShipNameText")

	setActive(var4_35, var2_35)

	local var5_35 = var0_35:Find("Empty/BuildType/ShipNameText")

	setActive(var5_35, var2_35)

	local var6_35 = var0_35:Find("Active/ActType/ShipNameText")

	setActive(var6_35, var2_35)

	local var7_35 = var0_35:Find("Active/BuildType/ShipNameText")

	setActive(var7_35, var2_35)

	local var8_35
	local var9_35 = var0_35:Find("Empty/ActType/TipText")

	setActive(var9_35, not var2_35)

	local var10_35 = var0_35:Find("Empty/BuildType/TipText")

	setActive(var10_35, not var2_35)

	local var11_35 = var0_35:Find("Active/ActType/Text")

	setActive(var11_35, not var2_35)

	local var12_35 = var0_35:Find("Active/BuildType/Text")

	setActive(var12_35, not var2_35)
end

function var0_0.updateBannerUIList(arg0_36)
	arg0_36.bannerTFList = {}

	arg0_36.scrollUIItemList:align(#arg0_36.metaProgressVOList)
end

function var0_0.updateStart(arg0_37)
	local var0_37 = false

	for iter0_37, iter1_37 in ipairs(arg0_37.metaProgressVOList) do
		if iter1_37 ~= false then
			var0_37 = true

			break
		end
	end

	local var1_37 = arg0_37.indexBtn:Find("On")

	setActive(var1_37, not arg0_37:isDefaultStatus())
	setActive(arg0_37.noCharTF, not var0_37)
	setActive(arg0_37.hidePanel, var0_37)

	if not var0_37 then
		return
	end

	arg0_37:resetBannerListScale()
	arg0_37:updateBannerUIList()

	arg0_37.curMetaIndex = nil

	if var0_37 then
		triggerButton(arg0_37.bannerTFList[1])
	end
end

function var0_0.resetBannerListScale(arg0_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.bannerTFList) do
		local var0_38 = iter1_38:GetComponent("LayoutElement")
		local var1_38 = iter1_38:Find("ForScale")

		setLocalScale(var1_38, Vector2.one)

		var0_38.preferredWidth = 199
		var0_38.preferredHeight = 60
	end
end

function var0_0.updateMain(arg0_39, arg1_39)
	local var0_39 = arg0_39:getCurMetaProgressVO()
	local var1_39 = var0_39:isUnlocked()

	setActive(arg0_39.menuPanel, var1_39)
	setActive(arg0_39.ptPanel, not var1_39)
	setActive(arg0_39.goGetPanel, not var1_39)
	arg0_39:updateActTimePanel()

	if not var1_39 then
		local var2_39 = var0_39:isPtType()
		local var3_39 = var0_39:isPassType()
		local var4_39 = var0_39:isBuildType()

		setActive(arg0_39.ptPanel, var2_39)
		setActive(arg0_39.goGetPanel, var3_39 or var4_39)

		if var2_39 then
			arg0_39:updatePTPanel(arg1_39)
		end
	else
		arg0_39:TryPlayGuide()
	end

	arg0_39:updateRedPoints()

	local var5_39, var6_39 = var0_39:getPaintPathAndName()

	setImageSprite(arg0_39.shipImg, LoadSprite(var5_39, var6_39), true)

	local var7_39, var8_39 = var0_39:getBGNamePathAndName()

	setImageSprite(arg0_39.shipNameImg, LoadSprite(var7_39, var8_39), true)

	local var9_39 = var0_39.id
	local var10_39 = MetaCharacterConst.UIConfig[var9_39]

	setLocalPosition(arg0_39.shipImg, {
		x = var10_39[1],
		y = var10_39[2]
	})
	setLocalScale(arg0_39.shipImg, {
		x = var10_39[3],
		y = var10_39[4]
	})
end

function var0_0.TryPlayGuide(arg0_40)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0024")
end

function var0_0.updateActTimePanel(arg0_41)
	local var0_41 = arg0_41:getCurMetaProgressVO()
	local var1_41 = var0_41:isUnlocked()
	local var2_41 = var0_41:isInAct()

	setActive(arg0_41.actTimePanel, not var1_41 and var2_41)
	setActive(arg0_41.synBtnLimitTimeTF, var2_41)

	if var2_41 then
		local var3_41 = var0_41.timeConfig[1][1]
		local var4_41 = var0_41.timeConfig[2][1]
		local var5_41 = "%d.%d.%d-%d.%d.%d"
		local var6_41 = string.format(var5_41, var3_41[1], var3_41[2], var3_41[3], var4_41[1], var4_41[2], var4_41[3])

		setText(arg0_41.actTimeText, var6_41)

		local var7_41 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_41.timeConfig[2])
		local var8_41 = pg.TimeMgr.GetInstance():GetServerTime()
		local var9_41 = pg.TimeMgr.GetInstance():DiffDay(var8_41, var7_41)
		local var10_41 = arg0_41.synBtnLimitTimeTF:Find("Text")

		setText(var10_41, i18n("meta_pt_left", var9_41))
	end
end

function var0_0.updatePTPanel(arg0_42, arg1_42)
	local var0_42 = arg0_42:getCurMetaProgressVO()
	local var1_42 = var0_42:getSynRate()
	local var2_42 = var1_42 * 100
	local var3_42 = tonumber(tostring(var2_42))

	setImageSprite(arg0_42.ptIcon, LoadSprite(var0_42:getPtIconPath()))
	setFillAmount(arg0_42.ptProgressImg, var1_42)
	setActive(arg0_42.ptProgressScaleLine, var1_42 < 1)

	arg0_42.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * var1_42)

	local var4_42 = string.format("%d", var3_42)
	local var5_42 = (var3_42 - math.floor(var3_42)) * 100 == 0
	local var6_42 = string.format("%2d", (var3_42 - math.floor(var3_42)) * 100)

	var6_42 = var5_42 and var6_42 .. "0%" or var6_42 .. "%"

	setText(arg0_42.ptProgressRedLeftNumText, var4_42)
	setText(arg0_42.ptProgressWhiteLeftNumText, var4_42)
	setText(arg0_42.ptProgressRedRightNumText, var6_42)
	setText(arg0_42.ptProgressWhiteRightNumText, var6_42)

	local var7_42, var8_42, var9_42 = var0_42.metaPtData:GetResProgress()

	setText(arg0_42.ptProgressRedText, (var9_42 >= 1 and setColorStr(var7_42, COLOR_GREEN) or setColorStr(var7_42, COLOR_RED)) .. "/" .. var8_42)
	setText(arg0_42.ptProgressWhiteText, (var9_42 >= 1 and setColorStr(var7_42, COLOR_GREEN) or setColorStr(var7_42, COLOR_RED)) .. "/" .. var8_42)

	local var10_42 = var0_42:getMetaProgressPTState()

	if var10_42 == MetaProgress.STATE_CAN_FINISH then
		setActive(arg0_42.ptRedBarImg, true)
		setActive(arg0_42.ptPreviewBtn, false)
		setActive(arg0_42.ptGetBtn, false)
		setActive(arg0_42.ptShowWayBtn, false)
		setActive(arg0_42.ptInfoPanel, false)
		setActive(arg0_42.storyInfoPanel, false)
		setActive(arg0_42.getShipBtn, true)
	elseif var10_42 == MetaProgress.STATE_CAN_AWARD then
		setActive(arg0_42.ptRedBarImg, false)
		setActive(arg0_42.ptPreviewBtn, true)
		setActive(arg0_42.ptGetBtn, true)
		setActive(arg0_42.ptShowWayBtn, false)
		setActive(arg0_42.ptGetBtnTag, true)
		setActive(arg0_42.ptInfoPanel, true)
		setActive(arg0_42.storyInfoPanel, false)
		setActive(arg0_42.getShipBtn, false)
		setImageAlpha(arg0_42.ptPreviewBtn, 0)
		setImageAlpha(arg0_42.ptGetBtn, 0)
		setImageAlpha(arg0_42.ptGetBtnTag, 0)
		setImageAlpha(arg0_42.ptShowWayBtn, 0)
	elseif var10_42 == MetaProgress.STATE_LESS_STORY then
		setActive(arg0_42.ptRedBarImg, true)
		setActive(arg0_42.ptPreviewBtn, true)
		setActive(arg0_42.ptGetBtn, true)
		setActive(arg0_42.ptShowWayBtn, false)
		setActive(arg0_42.ptGetBtnTag, false)
		setActive(arg0_42.ptInfoPanel, false)
		setActive(arg0_42.storyInfoPanel, true)
		setActive(arg0_42.getShipBtn, false)

		local var11_42 = var0_42:getCurLevelStoryName()

		setText(arg0_42.storyNameText, var11_42)
	elseif var10_42 == MetaProgress.STATE_LESS_PT then
		setActive(arg0_42.ptRedBarImg, false)
		setActive(arg0_42.ptPreviewBtn, true)
		setActive(arg0_42.ptGetBtn, false)
		setActive(arg0_42.ptShowWayBtn, true)
		setActive(arg0_42.ptGetBtnTag, false)
		setActive(arg0_42.ptInfoPanel, true)
		setActive(arg0_42.storyInfoPanel, false)
		setActive(arg0_42.getShipBtn, false)
		setImageAlpha(arg0_42.ptPreviewBtn, 0)
		setImageAlpha(arg0_42.ptGetBtn, 0)
		setImageAlpha(arg0_42.ptShowWayBtn, 0)
	end

	if var1_42 > 0 and not arg1_42 then
		if var10_42 == MetaProgress.STATE_CAN_AWARD or var10_42 == MetaProgress.STATE_LESS_PT then
			local var12_42 = math.min(var1_42, 1)

			arg0_42:managedTween(LeanTween.value, nil, go(arg0_42.ptPanel), 0, var1_42, var12_42):setOnUpdate(System.Action_float(function(arg0_43)
				setFillAmount(arg0_42.ptProgressImg, arg0_43)
				setActive(arg0_42.ptProgressScaleLine, arg0_43 < 1)

				arg0_42.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * arg0_43)

				local var0_43 = arg0_43 * 100
				local var1_43 = string.format("%d", var0_43)
				local var2_43 = (var0_43 - math.floor(var0_43)) * 100 == 0
				local var3_43 = string.format("%2d", (var0_43 - math.floor(var0_43)) * 100)

				var3_43 = var2_43 and var3_43 .. "0%" or var3_43 .. "%"

				setText(arg0_42.ptProgressRedLeftNumText, var1_43)
				setText(arg0_42.ptProgressWhiteLeftNumText, var1_43)
				setText(arg0_42.ptProgressRedRightNumText, var3_43)
				setText(arg0_42.ptProgressWhiteRightNumText, var3_43)
			end)):setOnComplete(System.Action(function()
				setFillAmount(arg0_42.ptProgressImg, var1_42)
				setActive(arg0_42.ptProgressScaleLine, var1_42 < 1)

				arg0_42.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * var1_42)

				local var0_44 = string.format("%d", var3_42)
				local var1_44 = (var3_42 - math.floor(var3_42)) * 100 == 0
				local var2_44 = string.format("%2d", (var3_42 - math.floor(var3_42)) * 100)

				var2_44 = var1_44 and var2_44 .. "0%" or var2_44 .. "%"

				setText(arg0_42.ptProgressRedLeftNumText, var0_44)
				setText(arg0_42.ptProgressWhiteLeftNumText, var0_44)
				setText(arg0_42.ptProgressRedRightNumText, var2_44)
				setText(arg0_42.ptProgressWhiteRightNumText, var2_44)
				arg0_42:managedTween(LeanTween.value, nil, go(arg0_42.ptPanel), 0, 1, var12_42 / 2):setOnUpdate(System.Action_float(function(arg0_45)
					setImageAlpha(arg0_42.ptPreviewBtn, arg0_45)
					setImageAlpha(arg0_42.ptGetBtn, arg0_45)
					setImageAlpha(arg0_42.ptGetBtnTag, arg0_45)
					setImageAlpha(arg0_42.ptShowWayBtn, arg0_45)
				end)):setOnComplete(System.Action(function()
					setImageAlpha(arg0_42.ptPreviewBtn, 1)
					setImageAlpha(arg0_42.ptGetBtn, 1)
					setImageAlpha(arg0_42.ptGetBtnTag, 1)
					setImageAlpha(arg0_42.ptShowWayBtn, 1)
				end))
			end))
		end
	else
		setImageAlpha(arg0_42.ptPreviewBtn, 1)
		setImageAlpha(arg0_42.ptGetBtn, 1)
		setImageAlpha(arg0_42.ptGetBtnTag, 1)
		setImageAlpha(arg0_42.ptShowWayBtn, 1)
	end
end

function var0_0.updateRedPoints(arg0_47)
	local var0_47 = arg0_47:getCurMetaProgressVO()
	local var1_47 = var0_47.id
	local var2_47 = MetaCharacterConst.isMetaRepairRedTag(var1_47)

	setActive(arg0_47.repairBtn:Find("RepairBtn/Tag"), var2_47)

	local var3_47 = not MetaCharacterConst.filteMetaRepairAble(var0_47)

	setActive(arg0_47.repairBtn:Find("Finish"), var3_47)

	local var4_47 = MetaCharacterConst.isMetaEnergyRedTag(var1_47)

	setActive(arg0_47.energyBtn:Find("Tag"), var4_47)

	local var5_47 = not MetaCharacterConst.filteMetaEnergyAble(var0_47)

	setActive(arg0_47.energyBtn:Find("Finish"), var5_47)

	local var6_47 = not MetaCharacterConst.filteMetaTacticsAble(var0_47)

	setActive(arg0_47.tacticsBtn:Find("Finish"), var6_47)

	local var7_47 = MetaCharacterConst.isMetaTacticsRedTag(var1_47)
	local var8_47 = var0_47.metaShipVO

	if var8_47 then
		local var9_47 = arg0_47.metaCharacterProxy:getMetaTacticsInfoByShipID(var8_47.id):getTacticsStateForShow()

		setActive(arg0_47.tacticsBtn:Find("Tag"), false)
		setActive(arg0_47.tacticsBtn:Find("Learnable"), var9_47 == MetaTacticsInfo.States.LearnAble)
		setActive(arg0_47.tacticsBtn:Find("Learning"), var9_47 == MetaTacticsInfo.States.Learning)
		setActive(arg0_47.tacticsBtn:Find("LearnFinish"), var9_47 == MetaTacticsInfo.States.LearnFinished and var7_47)
	else
		setActive(arg0_47.tacticsBtn:Find("Tag"), false)
		setActive(arg0_47.tacticsBtn:Find("Learnable"), false)
		setActive(arg0_47.tacticsBtn:Find("Learning"), false)
		setActive(arg0_47.tacticsBtn:Find("LearnFinish"), false)
	end

	local var10_47 = var0_47:isPtType()
	local var11_47 = var0_47:isInAct()
	local var12_47 = var0_47:isInArchive()
	local var13_47 = var10_47

	setActive(arg0_47.synDecorateTF, var13_47)
	setActive(arg0_47.synBtn, var10_47)
	setActive(arg0_47.synBtnLock, var10_47 and not var11_47 and not var12_47)
	setActive(arg0_47.toggleList[4], var10_47)
	setActive(arg0_47.synToggleLock, var10_47 and not var11_47 and not var12_47)

	local var14_47

	if var13_47 then
		var14_47 = MetaCharacterConst.isMetaSynRedTag(var1_47)

		setActive(arg0_47.synBtn:Find("Tag"), var14_47)
	end

	local var15_47 = not MetaCharacterConst.filteMetaSynAble(var0_47)

	setActive(arg0_47.synBtn:Find("Finish"), var15_47)
	setActive(arg0_47.toggleList[var0_0.PAGES.REPAIR]:Find("Tip"), var2_47)
	setActive(arg0_47.toggleList[var0_0.PAGES.ENERGY]:Find("Tip"), var4_47)
	setActive(arg0_47.toggleList[var0_0.PAGES.TACTICS]:Find("Tip"), var7_47)
	setActive(arg0_47.toggleList[var0_0.PAGES.SYN]:Find("Tip"), var14_47)

	for iter0_47, iter1_47 in ipairs(arg0_47.metaProgressVOList) do
		local var16_47 = arg0_47.bannerTFList[iter0_47]:Find("ForScale/RedPoint")

		if iter1_47 then
			setActive(var16_47, MetaCharacterConst.isMetaBannerRedPoint(iter1_47.id))
		else
			setActive(var16_47, false)
		end
	end
end

function var0_0.getCurMetaProgressVO(arg0_48)
	local var0_48 = arg0_48.curMetaIndex

	return arg0_48.metaProgressVOList[var0_48]
end

function var0_0.refreshBannerTF(arg0_49)
	local var0_49 = arg0_49:getCurMetaProgressVO()
	local var1_49 = arg0_49.bannerTFList[arg0_49.curMetaIndex]

	arg0_49:updateBannerTF(var0_49, var1_49, arg0_49.curMetaIndex)
end

function var0_0.enterMenuPage(arg0_50, arg1_50)
	setActive(arg0_50.hidePanel, not arg1_50)
	setActive(arg0_50.indexBtn, not arg1_50)
	setActive(arg0_50.toggleBtnsTF, arg1_50)

	arg0_50.toggleGroupSC.allowSwitchOff = not arg1_50
end

function var0_0.switchPage(arg0_51, arg1_51)
	if not arg0_51.curPageIndex then
		setActive(arg0_51.toggleBtnsTF, true)
		triggerToggle(arg0_51.toggleList[arg1_51], true)
	end
end

function var0_0.backFromRepair(arg0_52)
	setActive(arg0_52.menuPanel, false)
	arg0_52:managedTween(LeanTween.alpha, nil, arg0_52.shipImg, 1, 0.3):setFrom(0):setOnComplete(System.Action(function()
		setActive(arg0_52.menuPanel, true)
		setActive(arg0_52.hidePanel, true)
	end))
end

function var0_0.backFromNotRepair(arg0_54)
	local var0_54 = arg0_54:getCurMetaProgressVO().id
	local var1_54 = MetaCharacterConst.UIConfig[var0_54]

	setActive(arg0_54.menuPanel, false)

	local var2_54 = -250
	local var3_54 = var1_54[1]

	arg0_54:managedTween(LeanTween.moveX, nil, rtf(arg0_54.shipImg), var3_54, 0.3):setFrom(var2_54):setOnComplete(System.Action(function()
		setActive(arg0_54.menuPanel, true)
		setActive(arg0_54.hidePanel, true)
	end))
end

function var0_0.autoOpenFunc(arg0_56)
	if arg0_56.contextData.autoOpenShipConfigID then
		local var0_56 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_56.contextData.autoOpenShipConfigID)
		local var1_56 = arg0_56:getMetaProgressListForShow()
		local var2_56 = 0

		for iter0_56, iter1_56 in ipairs(var1_56) do
			if iter1_56 and iter1_56.id == var0_56 then
				triggerButton(arg0_56.bannerTFList[iter0_56])

				arg0_56.contextData.autoOpenShipConfigID = nil
			end
		end
	end

	if arg0_56.contextData.autoOpenTactics then
		triggerButton(arg0_56.tacticsBtn)

		arg0_56.contextData.autoOpenTactics = nil
	end

	if arg0_56.contextData.autoOpenEnergy then
		triggerButton(arg0_56.energyBtn)

		arg0_56.contextData.autoOpenEnergy = nil
	end

	if arg0_56.contextData.autoOpenSyn then
		if arg0_56:getCurMetaProgressVO():isUnlocked() then
			triggerButton(arg0_56.synBtn)
		end

		arg0_56.contextData.autoOpenSyn = nil
	end

	if arg0_56.contextData.lastPageIndex then
		triggerToggle(arg0_56.toggleList[arg0_56.contextData.lastPageIndex], true)

		arg0_56.contextData.lastPageIndex = nil
	end
end

function var0_0.openIndexLayer(arg0_57)
	if not arg0_57.indexDatas then
		arg0_57.indexDatas = {}
	end

	local var0_57 = {
		indexDatas = Clone(arg0_57.indexDatas),
		customPanels = {
			minHeight = 650,
			typeIndex = {
				mode = CustomIndexLayer.Mode.AND,
				options = ShipIndexConst.TypeIndexs,
				names = ShipIndexConst.TypeNames
			},
			rarityIndex = {
				mode = CustomIndexLayer.Mode.AND,
				options = ShipIndexConst.MetaRarityIndexs,
				names = ShipIndexConst.MetaRarityNames
			},
			extraIndex = {
				mode = CustomIndexLayer.Mode.OR,
				options = ShipIndexConst.MetaExtraIndexs,
				names = ShipIndexConst.MetaExtraNames
			}
		},
		groupList = {
			{
				dropdown = false,
				titleTxt = "indexsort_type",
				titleENTxt = "indexsort_typeeng",
				tags = {
					"typeIndex"
				}
			},
			{
				dropdown = false,
				titleTxt = "indexsort_rarity",
				titleENTxt = "indexsort_rarityeng",
				tags = {
					"rarityIndex"
				}
			},
			{
				dropdown = false,
				titleTxt = "indexsort_extraindex",
				titleENTxt = "indexsort_indexeng",
				tags = {
					"extraIndex"
				}
			}
		},
		callback = function(arg0_58)
			if not isActive(arg0_57._tf) then
				return
			end

			arg0_57.indexDatas.typeIndex = arg0_58.typeIndex
			arg0_57.indexDatas.rarityIndex = arg0_58.rarityIndex
			arg0_57.indexDatas.extraIndex = arg0_58.extraIndex
			arg0_57.metaProgressVOList = arg0_57:getMetaProgressListForShow()

			arg0_57:fillMetaProgressList()
			arg0_57:updateStart()
		end
	}

	arg0_57:emit(MetaCharacterMediator.OPEN_INDEX_LAYER, var0_57)
end

function var0_0.isDefaultStatus(arg0_59)
	return (not arg0_59.indexDatas.typeIndex or arg0_59.indexDatas.typeIndex == ShipIndexConst.TypeAll) and (not arg0_59.indexDatas.rarityIndex or arg0_59.indexDatas.rarityIndex == ShipIndexConst.RarityAll) and (not arg0_59.indexDatas.extraIndex or arg0_59.indexDatas.extraIndex == ShipIndexConst.MetaExtraAll)
end

function var0_0.overLayPanel(arg0_60, arg1_60)
	if arg1_60 == true then
		arg0_60:OverlayPanel(arg0_60.blurPanel)
	elseif arg1_60 == false then
		arg0_60:UnOverlayPanel(arg0_60.blurPanel, arg0_60._tf)
	end
end

function var0_0.getMetaProgressListForShow(arg0_61)
	local var0_61 = {}
	local var1_61 = arg0_61.metaCharacterProxy:getMetaProgressVOList()
	local var2_61
	local var3_61
	local var4_61

	for iter0_61, iter1_61 in ipairs(var1_61) do
		local var5_61 = MetaCharacterConst.filteMetaByType(iter1_61, arg0_61.indexDatas.typeIndex)
		local var6_61 = MetaCharacterConst.filteMetaByRarity(iter1_61, arg0_61.indexDatas.rarityIndex)
		local var7_61 = MetaCharacterConst.filteMetaExtra(iter1_61, arg0_61.indexDatas.extraIndex)

		if var5_61 and var6_61 and var7_61 and iter1_61:isShow() then
			if iter1_61:isPtType() and iter1_61:isInAct() then
				var2_61 = iter1_61
			elseif iter1_61:isPassType() and iter1_61:isInAct() then
				var3_61 = iter1_61
			elseif iter1_61:isBuildType() and iter1_61:isInAct() then
				var4_61 = iter1_61
			else
				table.insert(var0_61, iter1_61)
			end
		end
	end

	if var4_61 then
		table.insert(var0_61, 1, var4_61)
	end

	if var3_61 then
		table.insert(var0_61, 1, var3_61)
	end

	if var2_61 then
		table.insert(var0_61, 1, var2_61)
	end

	return var0_61
end

function var0_0.filteMetaProgressList(arg0_62)
	local var0_62 = arg0_62:getMetaProgressListForShow()
	local var1_62 = {}

	for iter0_62, iter1_62 in ipairs(var0_62) do
		local var2_62 = MetaCharacterConst.filteMetaByType(iter1_62, arg0_62.indexDatas.typeIndex)
		local var3_62 = MetaCharacterConst.filteMetaByRarity(iter1_62, arg0_62.indexDatas.rarityIndex)
		local var4_62 = MetaCharacterConst.filteMetaExtra(iter1_62, arg0_62.indexDatas.extraIndex)

		if var2_62 and var3_62 and var4_62 then
			table.insert(var1_62, iter1_62)
		end
	end

	return var1_62
end

function var0_0.getOneStepPTAwardLevelAndCount(arg0_63)
	local var0_63 = arg0_63:getCurMetaProgressVO()
	local var1_63 = var0_63.metaPtData:GetResProgress()
	local var2_63 = var0_63.metaPtData.targets
	local var3_63 = var0_63:getStoryIndexList()
	local var4_63 = var0_63.unlockPTLevel
	local var5_63 = 0

	for iter0_63 = 1, var4_63 - 1 do
		local var6_63 = false
		local var7_63 = false

		if var1_63 >= var2_63[iter0_63] then
			var6_63 = true
		end

		local var8_63 = var3_63[iter0_63]

		if var8_63 == 0 then
			var7_63 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var8_63) then
			var7_63 = true
		end

		if var6_63 and var7_63 then
			var5_63 = iter0_63
		else
			break
		end
	end

	return var5_63, var2_63[var5_63]
end

return var0_0

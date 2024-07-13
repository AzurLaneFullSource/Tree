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

function var0_0.init(arg0_2)
	Input.multiTouchEnabled = false

	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initMetaProgressList()
	arg0_2:initBannerList()
end

function var0_0.didEnter(arg0_3)
	arg0_3:overLayPanel(true)
	arg0_3:updateStart()
	arg0_3:autoOpenFunc()
end

function var0_0.willExit(arg0_4)
	Input.multiTouchEnabled = true

	arg0_4:overLayPanel(false)
end

function var0_0.initUITextTips(arg0_5)
	local var0_5 = arg0_5:findTF("HidePanel/ScrollPanel/ListPanel/BannerTpl/ForScale")
	local var1_5 = arg0_5:findTF("Empty/ActType/TipText", var0_5)
	local var2_5 = arg0_5:findTF("Empty/BuildType/TipText", var0_5)
	local var3_5 = arg0_5:findTF("Active/ActType/Text", var0_5)
	local var4_5 = arg0_5:findTF("Active/BuildType/Text", var0_5)

	setText(var1_5, i18n("meta_syn_rate"))
	setText(var2_5, i18n("meta_build"))
	setText(var3_5, i18n("meta_repair_rate"))
	setText(var4_5, i18n("meta_build"))

	local var5_5 = arg0_5:findTF("HidePanel/PTPanel/Progress/Story/TipText1")
	local var6_5 = arg0_5:findTF("HidePanel/PTPanel/Progress/Story/TipText2")

	setText(var5_5, i18n("meta_story_tip_1"))
	setText(var6_5, i18n("meta_story_tip_2"))

	local var7_5 = arg0_5:findTF("HidePanel/ActTimeTip/Tip")

	setText(var7_5, i18n("meta_acttime_limit"))
end

function var0_0.initData(arg0_6)
	arg0_6.metaProgressVOList = {}
	arg0_6.curMetaGroupID = nil
	arg0_6.curMetaProgress = nil
	arg0_6.toggleList = {}
	arg0_6.bannerTFList = {}
	arg0_6.curPageIndex = nil
	arg0_6.curMetaIndex = nil
	arg0_6.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0_6.bayProxy = getProxy(BayProxy)
	arg0_6.indexDatas = {}
end

function var0_0.findUI(arg0_7)
	arg0_7.shipImg = arg0_7:findTF("HidePanel/ShipImg")
	arg0_7.shipNameImg = arg0_7:findTF("HidePanel/NameImg")
	arg0_7.noCharTF = arg0_7:findTF("BG/NoCharacter")
	arg0_7.indexBtn = arg0_7:findTF("blur_panel/adapt/top/index")
	arg0_7.hidePanel = arg0_7:findTF("HidePanel")
	arg0_7.scrollPanel = arg0_7:findTF("ScrollPanel", arg0_7.hidePanel)
	arg0_7.bannerListPanel = arg0_7:findTF("ListPanel", arg0_7.scrollPanel)
	arg0_7.bannerContainer = arg0_7:findTF("Container", arg0_7.bannerListPanel)
	arg0_7.bannerTpl = arg0_7:findTF("BannerTpl", arg0_7.bannerListPanel)
	arg0_7.actTimePanel = arg0_7:findTF("ActTimeTip", arg0_7.hidePanel)
	arg0_7.actTimeText = arg0_7:findTF("Text", arg0_7.actTimePanel)
	arg0_7.menuPanel = arg0_7:findTF("MenuPanel", arg0_7.hidePanel)
	arg0_7.energyBtn = arg0_7:findTF("EnergyBtn", arg0_7.menuPanel)
	arg0_7.repairBtn = arg0_7:findTF("RepairBtn", arg0_7.menuPanel)
	arg0_7.tacticsBtn = arg0_7:findTF("TacticsBtn", arg0_7.menuPanel)
	arg0_7.synBtn = arg0_7:findTF("SynBtn", arg0_7.menuPanel)
	arg0_7.synDecorateTF = arg0_7:findTF("SynDecorate", arg0_7.menuPanel)
	arg0_7.synBtnLimitTimeTF = arg0_7:findTF("Limit", arg0_7.synBtn)
	arg0_7.synBtnLock = arg0_7:findTF("LockMask", arg0_7.synBtn)
	arg0_7.ptPanel = arg0_7:findTF("PTPanel", arg0_7.hidePanel)
	arg0_7.ptRedBarImg = arg0_7:findTF("RedBar", arg0_7.ptPanel)
	arg0_7.ptPreviewBtn = arg0_7:findTF("PreviewBtn", arg0_7.ptPanel)
	arg0_7.ptGetBtn = arg0_7:findTF("SynBtn", arg0_7.ptPanel)
	arg0_7.ptGetBtnTag = arg0_7:findTF("Tag", arg0_7.ptGetBtn)
	arg0_7.ptShowWayBtn = arg0_7:findTF("ShowWayBtn", arg0_7.ptPanel)

	local var0_7 = arg0_7:findTF("Progress", arg0_7.ptPanel)

	arg0_7.ptProgressImg = arg0_7:findTF("CircleProgress/ProgressImg", var0_7)
	arg0_7.ptProgressScaleLine = arg0_7:findTF("CircleProgress/ScaleLine", var0_7)
	arg0_7.ptInfoPanel = arg0_7:findTF("PT", var0_7)
	arg0_7.ptProgressRedRightNumText = arg0_7:findTF("ProgressTextBG/PointRedText/RightNumText", arg0_7.ptInfoPanel)
	arg0_7.ptProgressRedLeftNumText = arg0_7:findTF("ProgressTextBG/PointRedText/LeftNumText", arg0_7.ptInfoPanel)
	arg0_7.ptProgressWhiteRightNumText = arg0_7:findTF("ProgressTextBG/PointText/RightNumText", arg0_7.ptInfoPanel)
	arg0_7.ptProgressWhiteLeftNumText = arg0_7:findTF("ProgressTextBG/PointText/LeftNumText", arg0_7.ptInfoPanel)
	arg0_7.ptIcon = arg0_7:findTF("PTProgressText/PTIcon", arg0_7.ptInfoPanel)
	arg0_7.ptProgressRedText = arg0_7:findTF("PTProgressRedText", arg0_7.ptInfoPanel)
	arg0_7.ptProgressWhiteText = arg0_7:findTF("PTProgressText", arg0_7.ptInfoPanel)
	arg0_7.storyInfoPanel = arg0_7:findTF("Story", var0_7)

	local var1_7 = arg0_7:findTF("TipText1", arg0_7.storyInfoPanel)
	local var2_7 = arg0_7:findTF("TipText2", arg0_7.storyInfoPanel)

	arg0_7.storyNameText = arg0_7:findTF("StroyNameText", arg0_7.storyInfoPanel)
	arg0_7.getShipBtn = arg0_7:findTF("FinishBtn", var0_7)
	arg0_7.goGetPanel = arg0_7:findTF("GoGetPanel", arg0_7.hidePanel)
	arg0_7.goGetBtn = arg0_7:findTF("GoGetBtn", arg0_7.goGetPanel)
	arg0_7.blurPanel = arg0_7:findTF("blur_panel")

	local var3_7 = arg0_7:findTF("adapt", arg0_7.blurPanel)

	arg0_7.backBtn = arg0_7:findTF("top/back", var3_7)
	arg0_7.helpBtn = arg0_7:findTF("top/help", var3_7)
	arg0_7.toggleBtnsTF = arg0_7:findTF("left/Btns", var3_7)
	arg0_7.toggleGroupSC = GetComponent(arg0_7.toggleBtnsTF, "ToggleGroup")
	arg0_7.toggleGroupSC.allowSwitchOff = true
	arg0_7.toggleList[1] = arg0_7:findTF("Energy", arg0_7.toggleBtnsTF)
	arg0_7.toggleList[2] = arg0_7:findTF("Tactics", arg0_7.toggleBtnsTF)
	arg0_7.toggleList[3] = arg0_7:findTF("Repair", arg0_7.toggleBtnsTF)
	arg0_7.toggleList[4] = arg0_7:findTF("Syn", arg0_7.toggleBtnsTF)
	arg0_7.synToggleLock = arg0_7:findTF("SynLock", arg0_7.toggleBtnsTF)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		local var0_9 = arg0_8.curPageIndex

		if var0_9 then
			arg0_8:enterMenuPage(false)
			arg0_8:emit(var0_0.PAGES_EVENTS[arg0_8.curPageIndex], nil, false)

			if var0_9 == var0_0.PAGES.REPAIR then
				arg0_8:backFromRepair()
			else
				arg0_8:backFromNotRepair()
			end
		else
			arg0_8:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.meta_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.indexBtn, function()
		arg0_8:openIndexLayer()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.goGetBtn, function()
		local var0_12 = arg0_8:getCurMetaProgressVO()
		local var1_12 = var0_12:isPassType()
		local var2_12 = var0_12:isBuildType()

		if var1_12 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
		elseif var2_12 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.ptPreviewBtn, function()
		arg0_8:emit(MetaCharacterMediator.OPEN_PT_PREVIEW_LAYER, arg0_8:getCurMetaProgressVO())
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.ptGetBtn, function()
		local var0_14 = arg0_8:getCurMetaProgressVO()
		local var1_14 = var0_14:getMetaProgressPTState()

		if var1_14 == MetaProgress.STATE_CAN_AWARD then
			local var2_14, var3_14 = arg0_8:getOneStepPTAwardLevelAndCount()

			pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
				groupID = var0_14.id,
				targetCount = var3_14
			})
		elseif var1_14 == MetaProgress.STATE_LESS_PT then
			local var4_14 = false
			local var5_14 = nowWorld()

			if var5_14 then
				var4_14 = var5_14:IsSystemOpen(WorldConst.SystemWorldBoss)
			end

			local var6_14 = var4_14 and "meta_pt_notenough" or "meta_boss_unlock"

			pg.TipsMgr.GetInstance():ShowTips(i18n(var6_14))
		elseif var1_14 == MetaProgress.STATE_LESS_STORY then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_story_lock"))
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.ptShowWayBtn, function()
		local var0_15 = false
		local var1_15 = nowWorld()

		if var1_15 then
			var0_15 = var1_15:IsSystemOpen(WorldConst.SystemWorldBoss)
		end

		local var2_15 = var0_15 and "meta_pt_notenough" or "meta_boss_unlock"

		pg.TipsMgr.GetInstance():ShowTips(i18n(var2_15))
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.getShipBtn, function()
		local var0_16 = arg0_8:getCurMetaProgressVO()
		local var1_16, var2_16 = var0_16.metaPtData:GetResProgress()

		pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
			groupID = var0_16.id,
			targetCount = var2_16
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.synToggleLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.synBtnLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end)
	onButton(arg0_8, arg0_8:findTF("RepairBtn", arg0_8.repairBtn), function()
		arg0_8:switchPage(var0_0.PAGES.REPAIR)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.energyBtn, function()
		arg0_8.isMainOpenLayerTag = true

		arg0_8:switchPage(var0_0.PAGES.ENERGY)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.tacticsBtn, function()
		arg0_8.isMainOpenLayerTag = true

		arg0_8:switchPage(var0_0.PAGES.TACTICS)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.synBtn, function()
		if not isActive(arg0_8.synBtnLock) then
			arg0_8.isMainOpenLayerTag = true

			arg0_8:switchPage(var0_0.PAGES.SYN)
		end
	end, SFX_PANEL)

	for iter0_8, iter1_8 in ipairs(arg0_8.toggleList) do
		onToggle(arg0_8, iter1_8, function(arg0_23)
			if arg0_8.curPageIndex == iter0_8 and arg0_23 == true then
				return
			end

			local var0_23 = arg0_8:getCurMetaProgressVO():getShip()

			if arg0_8.curPageIndex == iter0_8 and arg0_23 == false then
				arg0_8:enterMenuPage(false)
				arg0_8:emit(var0_0.PAGES_EVENTS[iter0_8], var0_23.id, false)
			end

			if arg0_8.curPageIndex ~= iter0_8 and arg0_23 == true then
				arg0_8:enterMenuPage(true)

				arg0_8.curPageIndex = iter0_8

				arg0_8:emit(var0_0.PAGES_EVENTS[iter0_8], var0_23.id, true)
			end
		end)
	end
end

function var0_0.resetToggleList(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.toggleList) do
		setActive(arg0_24:findTF("On", iter1_24), false)
		setActive(arg0_24:findTF("Off", iter1_24), true)
	end
end

function var0_0.initMetaProgressList(arg0_25)
	arg0_25.metaProgressVOList = arg0_25:getMetaProgressListForShow()

	arg0_25:fillMetaProgressList()
end

function var0_0.fillMetaProgressList(arg0_26)
	if #arg0_26.metaProgressVOList < 5 then
		for iter0_26 = #arg0_26.metaProgressVOList + 1, 5 do
			table.insert(arg0_26.metaProgressVOList, false)
		end
	end
end

function var0_0.initBannerList(arg0_27)
	arg0_27.scrollUIItemList = UIItemList.New(arg0_27.bannerContainer, arg0_27.bannerTpl)

	arg0_27.scrollUIItemList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			table.insert(arg0_27.bannerTFList, arg2_28)

			local var0_28 = arg0_27.metaProgressVOList[arg1_28 + 1]

			arg0_27:updateBannerTF(var0_28, arg2_28, arg1_28 + 1)
		end
	end)
end

function var0_0.updateBannerTF(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg2_29
	local var1_29 = arg0_29:findTF("ForScale", arg2_29)
	local var2_29 = arg0_29:findTF("WillCome", var1_29)
	local var3_29 = arg0_29:findTF("Empty", var1_29)
	local var4_29 = arg0_29:findTF("Active", var1_29)

	if arg1_29 then
		local var5_29 = arg1_29:isInAct()
		local var6_29 = arg0_29:findTF("ActType/Tag", var3_29)
		local var7_29 = arg0_29:findTF("BuildType/Tag", var3_29)
		local var8_29 = arg0_29:findTF("ActType/Tag", var4_29)
		local var9_29 = arg0_29:findTF("BuildType/Tag", var4_29)

		setActive(var6_29, var5_29)
		setActive(var7_29, var5_29)
		setActive(var8_29, var5_29)
		setActive(var9_29, var5_29)
	end

	if arg1_29 then
		local var10_29 = Ship.New({
			configId = tonumber(arg1_29.configId .. 1)
		}):getName()
		local var11_29
		local var12_29 = arg0_29:findTF("Empty/ActType/ShipNameMask/ShipNameText", var1_29)

		setText(var12_29, var10_29)
		setScrollText(var12_29, var10_29)
		setActive(var12_29, true)

		local var13_29 = arg0_29:findTF("Empty/BuildType/ShipNameMask/ShipNameText", var1_29)

		setText(var13_29, var10_29)
		setScrollText(var13_29, var10_29)
		setActive(var13_29, true)

		local var14_29 = arg0_29:findTF("Empty/PassType/ShipNameMask/ShipNameText", var1_29)

		setText(var14_29, var10_29)
		setScrollText(var14_29, var10_29)
		setActive(var14_29, true)

		local var15_29 = arg0_29:findTF("Active/ActType/ShipNameMask/ShipNameText", var1_29)

		setText(var15_29, var10_29)
		setScrollText(var15_29, var10_29)
		setActive(var15_29, true)

		local var16_29 = arg0_29:findTF("Active/BuildType/ShipNameMask/ShipNameText", var1_29)

		setText(var16_29, var10_29)
		setScrollText(var16_29, var10_29)
		setActive(var16_29, true)

		local var17_29 = arg0_29:findTF("Active/PassType/ShipNameMask/ShipNameText", var1_29)

		setText(var17_29, var10_29)
		setScrollText(var17_29, var10_29)
		setActive(var17_29, true)
	end

	if arg1_29 == false then
		setActive(var2_29, true)
		setActive(var3_29, false)
		setActive(var4_29, false)
	else
		setActive(var2_29, false)

		local var18_29 = arg1_29:isUnlocked()

		setActive(var3_29, not var18_29)
		setActive(var4_29, var18_29)

		local var19_29 = arg1_29:isPtType()
		local var20_29 = arg1_29:isPassType()
		local var21_29 = arg1_29:isBuildType()

		if not var18_29 then
			local var22_29 = arg0_29:findTF("Empty/ActType", var1_29)
			local var23_29 = arg0_29:findTF("Empty/BuildType", var1_29)
			local var24_29 = arg0_29:findTF("Empty/PassType", var1_29)

			setActive(var22_29, var19_29)
			setActive(var23_29, var21_29)
			setActive(var24_29, var20_29)

			local var25_29, var26_29 = arg1_29:getBannerPathAndName()
			local var27_29 = LoadSprite(var25_29, var26_29)

			setImageSprite(var22_29, var27_29)
			setImageSprite(var23_29, var27_29)
			setImageSprite(var24_29, var27_29)

			if var19_29 then
				local var28_29 = arg0_29:findTF("NumText", var22_29)
				local var29_29 = string.format("%d", arg1_29:getSynRate() * 100) .. "%"

				setText(var28_29, var29_29)

				local var30_29 = arg0_29:findTF("Slider", var22_29)

				setSlider(var30_29, 0, 1, arg1_29:getSynRate())
				setActive(var30_29, false)
			end

			local var31_29 = pg.ship_strengthen_meta[arg1_29.configId].ship_id
			local var32_29 = Ship.New({
				configId = var31_29
			})
			local var33_29 = var32_29:getMaxStar()
			local var34_29 = var32_29:getStar()
			local var35_29 = arg0_29:findTF("Empty/StarTpl", var1_29)
			local var36_29 = arg0_29:findTF("Empty/Stars", var1_29)
			local var37_29 = UIItemList.New(var36_29, var35_29)

			var37_29:make(function(arg0_30, arg1_30, arg2_30)
				if arg0_30 == UIItemList.EventUpdate then
					arg1_30 = arg1_30 + 1

					local var0_30 = arg0_29:findTF("On", arg2_30)

					setActive(var0_30, arg1_30 <= var34_29)
				end
			end)
			var37_29:align(var33_29)
		else
			local var38_29 = arg0_29:findTF("Active/ActType", var1_29)
			local var39_29 = arg0_29:findTF("Active/BuildType", var1_29)
			local var40_29 = arg0_29:findTF("Active/PassType", var1_29)

			setActive(var38_29, var19_29)
			setActive(var39_29, var21_29)
			setActive(var40_29, var20_29)

			local var41_29, var42_29 = arg1_29:getBannerPathAndName()
			local var43_29 = LoadSprite(var41_29, var42_29)

			setImageSprite(arg0_29:findTF("Active", var1_29), LoadSprite(var41_29, var42_29))

			local var44_29 = arg1_29:getShip()
			local var45_29 = var44_29:getMetaCharacter()

			if var19_29 then
				local var46_29 = arg0_29:findTF("NumText", var38_29)
				local var47_29 = string.format("%d", var45_29:getRepairRate() * 100) .. "%"

				setText(var46_29, var47_29)

				local var48_29 = arg0_29:findTF("Slider", var38_29)

				setSlider(var48_29, 0, 1, var45_29:getRepairRate())
				setActive(var48_29, false)
			end

			local var49_29 = var44_29:getMaxStar()
			local var50_29 = var44_29:getStar()
			local var51_29 = arg0_29:findTF("Active/StarTpl", var1_29)
			local var52_29 = arg0_29:findTF("Active/Stars", var1_29)
			local var53_29 = UIItemList.New(var52_29, var51_29)

			var53_29:make(function(arg0_31, arg1_31, arg2_31)
				if arg0_31 == UIItemList.EventUpdate then
					arg1_31 = arg1_31 + 1

					local var0_31 = arg0_29:findTF("On", arg2_31)

					setActive(var0_31, arg1_31 <= var50_29)
				end
			end)
			var53_29:align(var49_29)
		end
	end

	onButton(arg0_29, var0_29, function()
		if arg0_29.curMetaIndex ~= arg3_29 then
			if arg0_29.curMetaIndex and arg0_29.curMetaIndex > 0 then
				arg0_29:changeBannerOnClick(arg0_29.bannerTFList[arg0_29.curMetaIndex], false)
			end

			arg0_29.curMetaIndex = arg3_29

			arg0_29:changeBannerOnClick(var0_29, true)
			arg0_29:updateMain()
		end
	end, SFX_PANEL)

	if arg1_29 == false then
		setButtonEnabled(var0_29, false)
	else
		setButtonEnabled(var0_29, true)
	end
end

function var0_0.changeBannerOnClick(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg1_33:GetComponent("LayoutElement")
	local var1_33 = arg0_33:findTF("ForScale", arg1_33)

	if arg2_33 == true then
		setLocalScale(var1_33, var0_0.SCALE_ON_PITCH)

		var0_33.preferredWidth = 338.3
		var0_33.preferredHeight = 102
	else
		setLocalScale(var1_33, Vector2.one)

		var0_33.preferredWidth = 199
		var0_33.preferredHeight = 60
	end

	local var2_33 = arg0_33:findTF("SelectedTag", var1_33)

	setActive(var2_33, arg2_33)
end

function var0_0.updateBannerShipName(arg0_34, arg1_34)
	local var0_34 = arg0_34:findTF("ForScale", arg1_34)
	local var1_34 = arg0_34:findTF("SelectedTag", var0_34)
	local var2_34 = isActive(var1_34)
	local var3_34
	local var4_34 = arg0_34:findTF("Empty/ActType/ShipNameText", var0_34)

	setActive(var4_34, var2_34)

	local var5_34 = arg0_34:findTF("Empty/BuildType/ShipNameText", var0_34)

	setActive(var5_34, var2_34)

	local var6_34 = arg0_34:findTF("Active/ActType/ShipNameText", var0_34)

	setActive(var6_34, var2_34)

	local var7_34 = arg0_34:findTF("Active/BuildType/ShipNameText", var0_34)

	setActive(var7_34, var2_34)

	local var8_34
	local var9_34 = arg0_34:findTF("Empty/ActType/TipText", var0_34)

	setActive(var9_34, not var2_34)

	local var10_34 = arg0_34:findTF("Empty/BuildType/TipText", var0_34)

	setActive(var10_34, not var2_34)

	local var11_34 = arg0_34:findTF("Active/ActType/Text", var0_34)

	setActive(var11_34, not var2_34)

	local var12_34 = arg0_34:findTF("Active/BuildType/Text", var0_34)

	setActive(var12_34, not var2_34)
end

function var0_0.updateBannerUIList(arg0_35)
	arg0_35.bannerTFList = {}

	arg0_35.scrollUIItemList:align(#arg0_35.metaProgressVOList)
end

function var0_0.updateStart(arg0_36)
	local var0_36 = false

	for iter0_36, iter1_36 in ipairs(arg0_36.metaProgressVOList) do
		if iter1_36 ~= false then
			var0_36 = true

			break
		end
	end

	local var1_36 = arg0_36:findTF("On", arg0_36.indexBtn)

	setActive(var1_36, not arg0_36:isDefaultStatus())
	setActive(arg0_36.noCharTF, not var0_36)
	setActive(arg0_36.hidePanel, var0_36)

	if not var0_36 then
		return
	end

	arg0_36:resetBannerListScale()
	arg0_36:updateBannerUIList()

	arg0_36.curMetaIndex = nil

	if var0_36 then
		triggerButton(arg0_36.bannerTFList[1])
	end
end

function var0_0.resetBannerListScale(arg0_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.bannerTFList) do
		local var0_37 = iter1_37:GetComponent("LayoutElement")
		local var1_37 = arg0_37:findTF("ForScale", iter1_37)

		setLocalScale(var1_37, Vector2.one)

		var0_37.preferredWidth = 199
		var0_37.preferredHeight = 60
	end
end

function var0_0.updateMain(arg0_38, arg1_38)
	local var0_38 = arg0_38:getCurMetaProgressVO()
	local var1_38 = var0_38:isUnlocked()

	setActive(arg0_38.menuPanel, var1_38)
	setActive(arg0_38.ptPanel, not var1_38)
	setActive(arg0_38.goGetPanel, not var1_38)
	arg0_38:updateActTimePanel()

	if not var1_38 then
		local var2_38 = var0_38:isPtType()
		local var3_38 = var0_38:isPassType()
		local var4_38 = var0_38:isBuildType()

		setActive(arg0_38.ptPanel, var2_38)
		setActive(arg0_38.goGetPanel, var3_38 or var4_38)

		if var2_38 then
			arg0_38:updatePTPanel(arg1_38)
		end
	else
		arg0_38:TryPlayGuide()
	end

	arg0_38:updateRedPoints()

	local var5_38, var6_38 = var0_38:getPaintPathAndName()

	setImageSprite(arg0_38.shipImg, LoadSprite(var5_38, var6_38), true)

	local var7_38, var8_38 = var0_38:getBGNamePathAndName()

	setImageSprite(arg0_38.shipNameImg, LoadSprite(var7_38, var8_38), true)

	local var9_38 = var0_38.id
	local var10_38 = MetaCharacterConst.UIConfig[var9_38]

	setLocalPosition(arg0_38.shipImg, {
		x = var10_38[1],
		y = var10_38[2]
	})
	setLocalScale(arg0_38.shipImg, {
		x = var10_38[3],
		y = var10_38[4]
	})
end

function var0_0.TryPlayGuide(arg0_39)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0024")
end

function var0_0.updateActTimePanel(arg0_40)
	local var0_40 = arg0_40:getCurMetaProgressVO()
	local var1_40 = var0_40:isUnlocked()
	local var2_40 = var0_40:isInAct()

	setActive(arg0_40.actTimePanel, not var1_40 and var2_40)
	setActive(arg0_40.synBtnLimitTimeTF, var2_40)

	if var2_40 then
		local var3_40 = var0_40.timeConfig[1][1]
		local var4_40 = var0_40.timeConfig[2][1]
		local var5_40 = "%d.%d.%d-%d.%d.%d"
		local var6_40 = string.format(var5_40, var3_40[1], var3_40[2], var3_40[3], var4_40[1], var4_40[2], var4_40[3])

		setText(arg0_40.actTimeText, var6_40)

		local var7_40 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_40.timeConfig[2])
		local var8_40 = pg.TimeMgr.GetInstance():GetServerTime()
		local var9_40 = pg.TimeMgr.GetInstance():DiffDay(var8_40, var7_40)
		local var10_40 = arg0_40:findTF("Text", arg0_40.synBtnLimitTimeTF)

		setText(var10_40, i18n("meta_pt_left", var9_40))
	end
end

function var0_0.updatePTPanel(arg0_41, arg1_41)
	local var0_41 = arg0_41:getCurMetaProgressVO()
	local var1_41 = var0_41:getSynRate()
	local var2_41 = var1_41 * 100
	local var3_41 = tonumber(tostring(var2_41))

	setImageSprite(arg0_41.ptIcon, LoadSprite(var0_41:getPtIconPath()))
	setFillAmount(arg0_41.ptProgressImg, var1_41)
	setActive(arg0_41.ptProgressScaleLine, var1_41 < 1)

	arg0_41.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * var1_41)

	local var4_41 = string.format("%d", var3_41)
	local var5_41 = (var3_41 - math.floor(var3_41)) * 100 == 0
	local var6_41 = string.format("%2d", (var3_41 - math.floor(var3_41)) * 100)

	var6_41 = var5_41 and var6_41 .. "0%" or var6_41 .. "%"

	setText(arg0_41.ptProgressRedLeftNumText, var4_41)
	setText(arg0_41.ptProgressWhiteLeftNumText, var4_41)
	setText(arg0_41.ptProgressRedRightNumText, var6_41)
	setText(arg0_41.ptProgressWhiteRightNumText, var6_41)

	local var7_41, var8_41, var9_41 = var0_41.metaPtData:GetResProgress()

	setText(arg0_41.ptProgressRedText, (var9_41 >= 1 and setColorStr(var7_41, COLOR_GREEN) or setColorStr(var7_41, COLOR_RED)) .. "/" .. var8_41)
	setText(arg0_41.ptProgressWhiteText, (var9_41 >= 1 and setColorStr(var7_41, COLOR_GREEN) or setColorStr(var7_41, COLOR_RED)) .. "/" .. var8_41)

	local var10_41 = var0_41:getMetaProgressPTState()

	if var10_41 == MetaProgress.STATE_CAN_FINISH then
		setActive(arg0_41.ptRedBarImg, true)
		setActive(arg0_41.ptPreviewBtn, false)
		setActive(arg0_41.ptGetBtn, false)
		setActive(arg0_41.ptShowWayBtn, false)
		setActive(arg0_41.ptInfoPanel, false)
		setActive(arg0_41.storyInfoPanel, false)
		setActive(arg0_41.getShipBtn, true)
	elseif var10_41 == MetaProgress.STATE_CAN_AWARD then
		setActive(arg0_41.ptRedBarImg, false)
		setActive(arg0_41.ptPreviewBtn, true)
		setActive(arg0_41.ptGetBtn, true)
		setActive(arg0_41.ptShowWayBtn, false)
		setActive(arg0_41.ptGetBtnTag, true)
		setActive(arg0_41.ptInfoPanel, true)
		setActive(arg0_41.storyInfoPanel, false)
		setActive(arg0_41.getShipBtn, false)
		setImageAlpha(arg0_41.ptPreviewBtn, 0)
		setImageAlpha(arg0_41.ptGetBtn, 0)
		setImageAlpha(arg0_41.ptGetBtnTag, 0)
		setImageAlpha(arg0_41.ptShowWayBtn, 0)
	elseif var10_41 == MetaProgress.STATE_LESS_STORY then
		setActive(arg0_41.ptRedBarImg, true)
		setActive(arg0_41.ptPreviewBtn, true)
		setActive(arg0_41.ptGetBtn, true)
		setActive(arg0_41.ptShowWayBtn, false)
		setActive(arg0_41.ptGetBtnTag, false)
		setActive(arg0_41.ptInfoPanel, false)
		setActive(arg0_41.storyInfoPanel, true)
		setActive(arg0_41.getShipBtn, false)

		local var11_41 = var0_41:getCurLevelStoryName()

		setText(arg0_41.storyNameText, var11_41)
	elseif var10_41 == MetaProgress.STATE_LESS_PT then
		setActive(arg0_41.ptRedBarImg, false)
		setActive(arg0_41.ptPreviewBtn, true)
		setActive(arg0_41.ptGetBtn, false)
		setActive(arg0_41.ptShowWayBtn, true)
		setActive(arg0_41.ptGetBtnTag, false)
		setActive(arg0_41.ptInfoPanel, true)
		setActive(arg0_41.storyInfoPanel, false)
		setActive(arg0_41.getShipBtn, false)
		setImageAlpha(arg0_41.ptPreviewBtn, 0)
		setImageAlpha(arg0_41.ptGetBtn, 0)
		setImageAlpha(arg0_41.ptShowWayBtn, 0)
	end

	if var1_41 > 0 and not arg1_41 then
		if var10_41 == MetaProgress.STATE_CAN_AWARD or var10_41 == MetaProgress.STATE_LESS_PT then
			local var12_41 = math.min(var1_41, 1)

			arg0_41:managedTween(LeanTween.value, nil, go(arg0_41.ptPanel), 0, var1_41, var12_41):setOnUpdate(System.Action_float(function(arg0_42)
				setFillAmount(arg0_41.ptProgressImg, arg0_42)
				setActive(arg0_41.ptProgressScaleLine, arg0_42 < 1)

				arg0_41.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * arg0_42)

				local var0_42 = arg0_42 * 100
				local var1_42 = string.format("%d", var0_42)
				local var2_42 = (var0_42 - math.floor(var0_42)) * 100 == 0
				local var3_42 = string.format("%2d", (var0_42 - math.floor(var0_42)) * 100)

				var3_42 = var2_42 and var3_42 .. "0%" or var3_42 .. "%"

				setText(arg0_41.ptProgressRedLeftNumText, var1_42)
				setText(arg0_41.ptProgressWhiteLeftNumText, var1_42)
				setText(arg0_41.ptProgressRedRightNumText, var3_42)
				setText(arg0_41.ptProgressWhiteRightNumText, var3_42)
			end)):setOnComplete(System.Action(function()
				setFillAmount(arg0_41.ptProgressImg, var1_41)
				setActive(arg0_41.ptProgressScaleLine, var1_41 < 1)

				arg0_41.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * var1_41)

				local var0_43 = string.format("%d", var3_41)
				local var1_43 = (var3_41 - math.floor(var3_41)) * 100 == 0
				local var2_43 = string.format("%2d", (var3_41 - math.floor(var3_41)) * 100)

				var2_43 = var1_43 and var2_43 .. "0%" or var2_43 .. "%"

				setText(arg0_41.ptProgressRedLeftNumText, var0_43)
				setText(arg0_41.ptProgressWhiteLeftNumText, var0_43)
				setText(arg0_41.ptProgressRedRightNumText, var2_43)
				setText(arg0_41.ptProgressWhiteRightNumText, var2_43)
				arg0_41:managedTween(LeanTween.value, nil, go(arg0_41.ptPanel), 0, 1, var12_41 / 2):setOnUpdate(System.Action_float(function(arg0_44)
					setImageAlpha(arg0_41.ptPreviewBtn, arg0_44)
					setImageAlpha(arg0_41.ptGetBtn, arg0_44)
					setImageAlpha(arg0_41.ptGetBtnTag, arg0_44)
					setImageAlpha(arg0_41.ptShowWayBtn, arg0_44)
				end)):setOnComplete(System.Action(function()
					setImageAlpha(arg0_41.ptPreviewBtn, 1)
					setImageAlpha(arg0_41.ptGetBtn, 1)
					setImageAlpha(arg0_41.ptGetBtnTag, 1)
					setImageAlpha(arg0_41.ptShowWayBtn, 1)
				end))
			end))
		end
	else
		setImageAlpha(arg0_41.ptPreviewBtn, 1)
		setImageAlpha(arg0_41.ptGetBtn, 1)
		setImageAlpha(arg0_41.ptGetBtnTag, 1)
		setImageAlpha(arg0_41.ptShowWayBtn, 1)
	end
end

function var0_0.updateRedPoints(arg0_46)
	local var0_46 = arg0_46:getCurMetaProgressVO()
	local var1_46 = var0_46.id
	local var2_46 = MetaCharacterConst.isMetaRepairRedTag(var1_46)

	setActive(arg0_46:findTF("RepairBtn/Tag", arg0_46.repairBtn), var2_46)

	local var3_46 = not MetaCharacterConst.filteMetaRepairAble(var0_46)

	setActive(arg0_46:findTF("Finish", arg0_46.repairBtn), var3_46)

	local var4_46 = MetaCharacterConst.isMetaEnergyRedTag(var1_46)

	setActive(arg0_46:findTF("Tag", arg0_46.energyBtn), var4_46)

	local var5_46 = not MetaCharacterConst.filteMetaEnergyAble(var0_46)

	setActive(arg0_46:findTF("Finish", arg0_46.energyBtn), var5_46)

	local var6_46 = not MetaCharacterConst.filteMetaTacticsAble(var0_46)

	setActive(arg0_46:findTF("Finish", arg0_46.tacticsBtn), var6_46)

	local var7_46 = MetaCharacterConst.isMetaTacticsRedTag(var1_46)
	local var8_46 = var0_46.metaShipVO

	if var8_46 then
		local var9_46 = arg0_46.metaCharacterProxy:getMetaTacticsInfoByShipID(var8_46.id):getTacticsStateForShow()

		setActive(arg0_46:findTF("Tag", arg0_46.tacticsBtn), false)
		setActive(arg0_46:findTF("Learnable", arg0_46.tacticsBtn), var9_46 == MetaTacticsInfo.States.LearnAble)
		setActive(arg0_46:findTF("Learning", arg0_46.tacticsBtn), var9_46 == MetaTacticsInfo.States.Learning)
		setActive(arg0_46:findTF("LearnFinish", arg0_46.tacticsBtn), var9_46 == MetaTacticsInfo.States.LearnFinished and var7_46)
	else
		setActive(arg0_46:findTF("Tag", arg0_46.tacticsBtn), false)
		setActive(arg0_46:findTF("Learnable", arg0_46.tacticsBtn), false)
		setActive(arg0_46:findTF("Learning", arg0_46.tacticsBtn), false)
		setActive(arg0_46:findTF("LearnFinish", arg0_46.tacticsBtn), false)
	end

	local var10_46 = var0_46:isPtType()
	local var11_46 = var0_46:isInAct()
	local var12_46 = var0_46:isInArchive()
	local var13_46 = var10_46

	setActive(arg0_46.synDecorateTF, var13_46)
	setActive(arg0_46.synBtn, var10_46)
	setActive(arg0_46.synBtnLock, var10_46 and not var11_46 and not var12_46)
	setActive(arg0_46.toggleList[4], var10_46)
	setActive(arg0_46.synToggleLock, var10_46 and not var11_46 and not var12_46)

	local var14_46

	if var13_46 then
		var14_46 = MetaCharacterConst.isMetaSynRedTag(var1_46)

		setActive(arg0_46:findTF("Tag", arg0_46.synBtn), var14_46)
	end

	local var15_46 = not MetaCharacterConst.filteMetaSynAble(var0_46)

	setActive(arg0_46:findTF("Finish", arg0_46.synBtn), var15_46)
	setActive(arg0_46:findTF("Tip", arg0_46.toggleList[var0_0.PAGES.REPAIR]), var2_46)
	setActive(arg0_46:findTF("Tip", arg0_46.toggleList[var0_0.PAGES.ENERGY]), var4_46)
	setActive(arg0_46:findTF("Tip", arg0_46.toggleList[var0_0.PAGES.TACTICS]), var7_46)
	setActive(arg0_46:findTF("Tip", arg0_46.toggleList[var0_0.PAGES.SYN]), var14_46)

	for iter0_46, iter1_46 in ipairs(arg0_46.metaProgressVOList) do
		local var16_46 = arg0_46.bannerTFList[iter0_46]
		local var17_46 = arg0_46:findTF("ForScale/RedPoint", var16_46)

		if iter1_46 then
			setActive(var17_46, MetaCharacterConst.isMetaBannerRedPoint(iter1_46.id))
		else
			setActive(var17_46, false)
		end
	end
end

function var0_0.getCurMetaProgressVO(arg0_47)
	local var0_47 = arg0_47.curMetaIndex

	return arg0_47.metaProgressVOList[var0_47]
end

function var0_0.refreshBannerTF(arg0_48)
	local var0_48 = arg0_48:getCurMetaProgressVO()
	local var1_48 = arg0_48.bannerTFList[arg0_48.curMetaIndex]

	arg0_48:updateBannerTF(var0_48, var1_48, arg0_48.curMetaIndex)
end

function var0_0.enterMenuPage(arg0_49, arg1_49)
	setActive(arg0_49.hidePanel, not arg1_49)
	setActive(arg0_49.indexBtn, not arg1_49)
	setActive(arg0_49.toggleBtnsTF, arg1_49)

	arg0_49.toggleGroupSC.allowSwitchOff = not arg1_49
end

function var0_0.switchPage(arg0_50, arg1_50)
	if not arg0_50.curPageIndex then
		setActive(arg0_50.toggleBtnsTF, true)
		triggerToggle(arg0_50.toggleList[arg1_50], true)
	end
end

function var0_0.backFromRepair(arg0_51)
	setActive(arg0_51.menuPanel, false)
	arg0_51:managedTween(LeanTween.alpha, nil, arg0_51.shipImg, 1, 0.3):setFrom(0):setOnComplete(System.Action(function()
		setActive(arg0_51.menuPanel, true)
		setActive(arg0_51.hidePanel, true)
	end))
end

function var0_0.backFromNotRepair(arg0_53)
	local var0_53 = arg0_53:getCurMetaProgressVO().id
	local var1_53 = MetaCharacterConst.UIConfig[var0_53]

	setActive(arg0_53.menuPanel, false)

	local var2_53 = -250
	local var3_53 = var1_53[1]

	arg0_53:managedTween(LeanTween.moveX, nil, rtf(arg0_53.shipImg), var3_53, 0.3):setFrom(var2_53):setOnComplete(System.Action(function()
		setActive(arg0_53.menuPanel, true)
		setActive(arg0_53.hidePanel, true)
	end))
end

function var0_0.autoOpenFunc(arg0_55)
	if arg0_55.contextData.autoOpenShipConfigID then
		local var0_55 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_55.contextData.autoOpenShipConfigID)
		local var1_55 = arg0_55:getMetaProgressListForShow()
		local var2_55 = 0

		for iter0_55, iter1_55 in ipairs(var1_55) do
			if iter1_55 and iter1_55.id == var0_55 then
				triggerButton(arg0_55.bannerTFList[iter0_55])

				arg0_55.contextData.autoOpenShipConfigID = nil
			end
		end
	end

	if arg0_55.contextData.autoOpenTactics then
		triggerButton(arg0_55.tacticsBtn)

		arg0_55.contextData.autoOpenTactics = nil
	end

	if arg0_55.contextData.autoOpenEnergy then
		triggerButton(arg0_55.energyBtn)

		arg0_55.contextData.autoOpenEnergy = nil
	end

	if arg0_55.contextData.autoOpenSyn then
		if arg0_55:getCurMetaProgressVO():isUnlocked() then
			triggerButton(arg0_55.synBtn)
		end

		arg0_55.contextData.autoOpenSyn = nil
	end

	if arg0_55.contextData.lastPageIndex then
		triggerToggle(arg0_55.toggleList[arg0_55.contextData.lastPageIndex], true)

		arg0_55.contextData.lastPageIndex = nil
	end
end

function var0_0.openIndexLayer(arg0_56)
	if not arg0_56.indexDatas then
		arg0_56.indexDatas = {}
	end

	local var0_56 = {
		indexDatas = Clone(arg0_56.indexDatas),
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
		callback = function(arg0_57)
			if not isActive(arg0_56._tf) then
				return
			end

			arg0_56.indexDatas.typeIndex = arg0_57.typeIndex
			arg0_56.indexDatas.rarityIndex = arg0_57.rarityIndex
			arg0_56.indexDatas.extraIndex = arg0_57.extraIndex
			arg0_56.metaProgressVOList = arg0_56:getMetaProgressListForShow()

			arg0_56:fillMetaProgressList()
			arg0_56:updateStart()
		end
	}

	arg0_56:emit(MetaCharacterMediator.OPEN_INDEX_LAYER, var0_56)
end

function var0_0.isDefaultStatus(arg0_58)
	return (not arg0_58.indexDatas.typeIndex or arg0_58.indexDatas.typeIndex == ShipIndexConst.TypeAll) and (not arg0_58.indexDatas.rarityIndex or arg0_58.indexDatas.rarityIndex == ShipIndexConst.RarityAll) and (not arg0_58.indexDatas.extraIndex or arg0_58.indexDatas.extraIndex == ShipIndexConst.MetaExtraAll)
end

function var0_0.overLayPanel(arg0_59, arg1_59)
	if arg1_59 == true then
		pg.UIMgr.GetInstance():OverlayPanel(arg0_59.blurPanel, {
			groupName = LayerWeightConst.GROUP_META
		})
	elseif arg1_59 == false then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_59.blurPanel, arg0_59._tf)
	end
end

function var0_0.getMetaProgressListForShow(arg0_60)
	local var0_60 = {}
	local var1_60 = arg0_60.metaCharacterProxy:getMetaProgressVOList()
	local var2_60
	local var3_60
	local var4_60

	for iter0_60, iter1_60 in ipairs(var1_60) do
		local var5_60 = MetaCharacterConst.filteMetaByType(iter1_60, arg0_60.indexDatas.typeIndex)
		local var6_60 = MetaCharacterConst.filteMetaByRarity(iter1_60, arg0_60.indexDatas.rarityIndex)
		local var7_60 = MetaCharacterConst.filteMetaExtra(iter1_60, arg0_60.indexDatas.extraIndex)

		if var5_60 and var6_60 and var7_60 and iter1_60:isShow() then
			if iter1_60:isPtType() and iter1_60:isInAct() then
				var2_60 = iter1_60
			elseif iter1_60:isPassType() and iter1_60:isInAct() then
				var3_60 = iter1_60
			elseif iter1_60:isBuildType() and iter1_60:isInAct() then
				var4_60 = iter1_60
			else
				table.insert(var0_60, iter1_60)
			end
		end
	end

	if var4_60 then
		table.insert(var0_60, 1, var4_60)
	end

	if var3_60 then
		table.insert(var0_60, 1, var3_60)
	end

	if var2_60 then
		table.insert(var0_60, 1, var2_60)
	end

	return var0_60
end

function var0_0.filteMetaProgressList(arg0_61)
	local var0_61 = arg0_61:getMetaProgressListForShow()
	local var1_61 = {}

	for iter0_61, iter1_61 in ipairs(var0_61) do
		local var2_61 = MetaCharacterConst.filteMetaByType(iter1_61, arg0_61.indexDatas.typeIndex)
		local var3_61 = MetaCharacterConst.filteMetaByRarity(iter1_61, arg0_61.indexDatas.rarityIndex)
		local var4_61 = MetaCharacterConst.filteMetaExtra(iter1_61, arg0_61.indexDatas.extraIndex)

		if var2_61 and var3_61 and var4_61 then
			table.insert(var1_61, iter1_61)
		end
	end

	return var1_61
end

function var0_0.getOneStepPTAwardLevelAndCount(arg0_62)
	local var0_62 = arg0_62:getCurMetaProgressVO()
	local var1_62 = var0_62.metaPtData:GetResProgress()
	local var2_62 = var0_62.metaPtData.targets
	local var3_62 = var0_62:getStoryIndexList()
	local var4_62 = var0_62.unlockPTLevel
	local var5_62 = 0

	for iter0_62 = 1, var4_62 - 1 do
		local var6_62 = false
		local var7_62 = false

		if var1_62 >= var2_62[iter0_62] then
			var6_62 = true
		end

		local var8_62 = var3_62[iter0_62]

		if var8_62 == 0 then
			var7_62 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var8_62) then
			var7_62 = true
		end

		if var6_62 and var7_62 then
			var5_62 = iter0_62
		else
			break
		end
	end

	return var5_62, var2_62[var5_62]
end

return var0_0

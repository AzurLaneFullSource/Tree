local var0 = class("MetaCharacterScene", import("...base.BaseUI"))

var0.PAGES = {
	REPAIR = 3,
	ENERGY = 1,
	TACTICS = 2,
	SYN = 4
}
var0.PAGES_EVENTS = {
	MetaCharacterMediator.ON_ENERGY,
	MetaCharacterMediator.ON_TACTICS,
	MetaCharacterMediator.ON_REPAIR,
	MetaCharacterMediator.ON_SYN
}
var0.SCALE_ON_PITCH = {
	x = 1.7,
	y = 1.7
}
var0.ON_SKILL = "MetaCharacterScene:ON_SKILL"

function var0.getUIName(arg0)
	return "MetaCharacterUI"
end

function var0.init(arg0)
	Input.multiTouchEnabled = false

	arg0:initUITextTips()
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initMetaProgressList()
	arg0:initBannerList()
end

function var0.didEnter(arg0)
	arg0:overLayPanel(true)
	arg0:updateStart()
	arg0:autoOpenFunc()
end

function var0.willExit(arg0)
	Input.multiTouchEnabled = true

	arg0:overLayPanel(false)
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("HidePanel/ScrollPanel/ListPanel/BannerTpl/ForScale")
	local var1 = arg0:findTF("Empty/ActType/TipText", var0)
	local var2 = arg0:findTF("Empty/BuildType/TipText", var0)
	local var3 = arg0:findTF("Active/ActType/Text", var0)
	local var4 = arg0:findTF("Active/BuildType/Text", var0)

	setText(var1, i18n("meta_syn_rate"))
	setText(var2, i18n("meta_build"))
	setText(var3, i18n("meta_repair_rate"))
	setText(var4, i18n("meta_build"))

	local var5 = arg0:findTF("HidePanel/PTPanel/Progress/Story/TipText1")
	local var6 = arg0:findTF("HidePanel/PTPanel/Progress/Story/TipText2")

	setText(var5, i18n("meta_story_tip_1"))
	setText(var6, i18n("meta_story_tip_2"))

	local var7 = arg0:findTF("HidePanel/ActTimeTip/Tip")

	setText(var7, i18n("meta_acttime_limit"))
end

function var0.initData(arg0)
	arg0.metaProgressVOList = {}
	arg0.curMetaGroupID = nil
	arg0.curMetaProgress = nil
	arg0.toggleList = {}
	arg0.bannerTFList = {}
	arg0.curPageIndex = nil
	arg0.curMetaIndex = nil
	arg0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.indexDatas = {}
end

function var0.findUI(arg0)
	arg0.shipImg = arg0:findTF("HidePanel/ShipImg")
	arg0.shipNameImg = arg0:findTF("HidePanel/NameImg")
	arg0.noCharTF = arg0:findTF("BG/NoCharacter")
	arg0.indexBtn = arg0:findTF("blur_panel/adapt/top/index")
	arg0.hidePanel = arg0:findTF("HidePanel")
	arg0.scrollPanel = arg0:findTF("ScrollPanel", arg0.hidePanel)
	arg0.bannerListPanel = arg0:findTF("ListPanel", arg0.scrollPanel)
	arg0.bannerContainer = arg0:findTF("Container", arg0.bannerListPanel)
	arg0.bannerTpl = arg0:findTF("BannerTpl", arg0.bannerListPanel)
	arg0.actTimePanel = arg0:findTF("ActTimeTip", arg0.hidePanel)
	arg0.actTimeText = arg0:findTF("Text", arg0.actTimePanel)
	arg0.menuPanel = arg0:findTF("MenuPanel", arg0.hidePanel)
	arg0.energyBtn = arg0:findTF("EnergyBtn", arg0.menuPanel)
	arg0.repairBtn = arg0:findTF("RepairBtn", arg0.menuPanel)
	arg0.tacticsBtn = arg0:findTF("TacticsBtn", arg0.menuPanel)
	arg0.synBtn = arg0:findTF("SynBtn", arg0.menuPanel)
	arg0.synDecorateTF = arg0:findTF("SynDecorate", arg0.menuPanel)
	arg0.synBtnLimitTimeTF = arg0:findTF("Limit", arg0.synBtn)
	arg0.synBtnLock = arg0:findTF("LockMask", arg0.synBtn)
	arg0.ptPanel = arg0:findTF("PTPanel", arg0.hidePanel)
	arg0.ptRedBarImg = arg0:findTF("RedBar", arg0.ptPanel)
	arg0.ptPreviewBtn = arg0:findTF("PreviewBtn", arg0.ptPanel)
	arg0.ptGetBtn = arg0:findTF("SynBtn", arg0.ptPanel)
	arg0.ptGetBtnTag = arg0:findTF("Tag", arg0.ptGetBtn)
	arg0.ptShowWayBtn = arg0:findTF("ShowWayBtn", arg0.ptPanel)

	local var0 = arg0:findTF("Progress", arg0.ptPanel)

	arg0.ptProgressImg = arg0:findTF("CircleProgress/ProgressImg", var0)
	arg0.ptProgressScaleLine = arg0:findTF("CircleProgress/ScaleLine", var0)
	arg0.ptInfoPanel = arg0:findTF("PT", var0)
	arg0.ptProgressRedRightNumText = arg0:findTF("ProgressTextBG/PointRedText/RightNumText", arg0.ptInfoPanel)
	arg0.ptProgressRedLeftNumText = arg0:findTF("ProgressTextBG/PointRedText/LeftNumText", arg0.ptInfoPanel)
	arg0.ptProgressWhiteRightNumText = arg0:findTF("ProgressTextBG/PointText/RightNumText", arg0.ptInfoPanel)
	arg0.ptProgressWhiteLeftNumText = arg0:findTF("ProgressTextBG/PointText/LeftNumText", arg0.ptInfoPanel)
	arg0.ptIcon = arg0:findTF("PTProgressText/PTIcon", arg0.ptInfoPanel)
	arg0.ptProgressRedText = arg0:findTF("PTProgressRedText", arg0.ptInfoPanel)
	arg0.ptProgressWhiteText = arg0:findTF("PTProgressText", arg0.ptInfoPanel)
	arg0.storyInfoPanel = arg0:findTF("Story", var0)

	local var1 = arg0:findTF("TipText1", arg0.storyInfoPanel)
	local var2 = arg0:findTF("TipText2", arg0.storyInfoPanel)

	arg0.storyNameText = arg0:findTF("StroyNameText", arg0.storyInfoPanel)
	arg0.getShipBtn = arg0:findTF("FinishBtn", var0)
	arg0.goGetPanel = arg0:findTF("GoGetPanel", arg0.hidePanel)
	arg0.goGetBtn = arg0:findTF("GoGetBtn", arg0.goGetPanel)
	arg0.blurPanel = arg0:findTF("blur_panel")

	local var3 = arg0:findTF("adapt", arg0.blurPanel)

	arg0.backBtn = arg0:findTF("top/back", var3)
	arg0.helpBtn = arg0:findTF("top/help", var3)
	arg0.toggleBtnsTF = arg0:findTF("left/Btns", var3)
	arg0.toggleList[1] = arg0:findTF("Energy", arg0.toggleBtnsTF)
	arg0.toggleList[2] = arg0:findTF("Tactics", arg0.toggleBtnsTF)
	arg0.toggleList[3] = arg0:findTF("Repair", arg0.toggleBtnsTF)
	arg0.toggleList[4] = arg0:findTF("Syn", arg0.toggleBtnsTF)
	arg0.synToggleLock = arg0:findTF("SynLock", arg0.toggleBtnsTF)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		local var0 = arg0.curPageIndex

		if var0 then
			arg0:enterMenuPage(false)
			arg0:emit(var0.PAGES_EVENTS[arg0.curPageIndex], nil, false)

			if var0 == var0.PAGES.REPAIR then
				arg0:backFromRepair()
			else
				arg0:backFromNotRepair()
			end
		else
			arg0:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.meta_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		arg0:openIndexLayer()
	end, SFX_PANEL)
	onButton(arg0, arg0.goGetBtn, function()
		local var0 = arg0:getCurMetaProgressVO()
		local var1 = var0:isPassType()
		local var2 = var0:isBuildType()

		if var1 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
		elseif var2 then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.ptPreviewBtn, function()
		arg0:emit(MetaCharacterMediator.OPEN_PT_PREVIEW_LAYER, arg0:getCurMetaProgressVO())
	end, SFX_PANEL)
	onButton(arg0, arg0.ptGetBtn, function()
		local var0 = arg0:getCurMetaProgressVO()
		local var1 = var0:getMetaProgressPTState()

		if var1 == MetaProgress.STATE_CAN_AWARD then
			local var2, var3 = arg0:getOneStepPTAwardLevelAndCount()

			pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
				groupID = var0.id,
				targetCount = var3
			})
		elseif var1 == MetaProgress.STATE_LESS_PT then
			local var4 = false
			local var5 = nowWorld()

			if var5 then
				var4 = var5:IsSystemOpen(WorldConst.SystemWorldBoss)
			end

			local var6 = var4 and "meta_pt_notenough" or "meta_boss_unlock"

			pg.TipsMgr.GetInstance():ShowTips(i18n(var6))
		elseif var1 == MetaProgress.STATE_LESS_STORY then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_story_lock"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.ptShowWayBtn, function()
		local var0 = false
		local var1 = nowWorld()

		if var1 then
			var0 = var1:IsSystemOpen(WorldConst.SystemWorldBoss)
		end

		local var2 = var0 and "meta_pt_notenough" or "meta_boss_unlock"

		pg.TipsMgr.GetInstance():ShowTips(i18n(var2))
	end, SFX_PANEL)
	onButton(arg0, arg0.getShipBtn, function()
		local var0 = arg0:getCurMetaProgressVO()
		local var1, var2 = var0.metaPtData:GetResProgress()

		pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
			groupID = var0.id,
			targetCount = var2
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.synToggleLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end, SFX_PANEL)
	onButton(arg0, arg0.synBtnLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end)
	onButton(arg0, arg0:findTF("RepairBtn", arg0.repairBtn), function()
		arg0:switchPage(var0.PAGES.REPAIR)
	end, SFX_PANEL)
	onButton(arg0, arg0.energyBtn, function()
		arg0.isMainOpenLayerTag = true

		arg0:switchPage(var0.PAGES.ENERGY)
	end, SFX_PANEL)
	onButton(arg0, arg0.tacticsBtn, function()
		arg0.isMainOpenLayerTag = true

		arg0:switchPage(var0.PAGES.TACTICS)
	end, SFX_PANEL)
	onButton(arg0, arg0.synBtn, function()
		if not isActive(arg0.synBtnLock) then
			arg0.isMainOpenLayerTag = true

			arg0:switchPage(var0.PAGES.SYN)
		end
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.toggleList) do
		onToggle(arg0, iter1, function(arg0)
			if arg0.curPageIndex == iter0 and arg0 == true then
				return
			end

			local var0 = arg0:getCurMetaProgressVO():getShip()

			if arg0.curPageIndex == iter0 and arg0 == false then
				arg0:enterMenuPage(false)
				arg0:emit(var0.PAGES_EVENTS[iter0], var0.id, false)
			end

			if arg0.curPageIndex ~= iter0 and arg0 == true then
				arg0:enterMenuPage(true)

				arg0.curPageIndex = iter0

				arg0:emit(var0.PAGES_EVENTS[iter0], var0.id, true)
			end
		end)
	end
end

function var0.resetToggleList(arg0)
	for iter0, iter1 in ipairs(arg0.toggleList) do
		setActive(arg0:findTF("On", iter1), false)
		setActive(arg0:findTF("Off", iter1), true)
	end
end

function var0.initMetaProgressList(arg0)
	arg0.metaProgressVOList = arg0:getMetaProgressListForShow()

	arg0:fillMetaProgressList()
end

function var0.fillMetaProgressList(arg0)
	if #arg0.metaProgressVOList < 5 then
		for iter0 = #arg0.metaProgressVOList + 1, 5 do
			table.insert(arg0.metaProgressVOList, false)
		end
	end
end

function var0.initBannerList(arg0)
	arg0.scrollUIItemList = UIItemList.New(arg0.bannerContainer, arg0.bannerTpl)

	arg0.scrollUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			table.insert(arg0.bannerTFList, arg2)

			local var0 = arg0.metaProgressVOList[arg1 + 1]

			arg0:updateBannerTF(var0, arg2, arg1 + 1)
		end
	end)
end

function var0.updateBannerTF(arg0, arg1, arg2, arg3)
	local var0 = arg2
	local var1 = arg0:findTF("ForScale", arg2)
	local var2 = arg0:findTF("WillCome", var1)
	local var3 = arg0:findTF("Empty", var1)
	local var4 = arg0:findTF("Active", var1)

	if arg1 then
		local var5 = arg1:isInAct()
		local var6 = arg0:findTF("ActType/Tag", var3)
		local var7 = arg0:findTF("BuildType/Tag", var3)
		local var8 = arg0:findTF("ActType/Tag", var4)
		local var9 = arg0:findTF("BuildType/Tag", var4)

		setActive(var6, var5)
		setActive(var7, var5)
		setActive(var8, var5)
		setActive(var9, var5)
	end

	if arg1 then
		local var10 = Ship.New({
			configId = tonumber(arg1.configId .. 1)
		}):getName()
		local var11
		local var12 = arg0:findTF("Empty/ActType/ShipNameMask/ShipNameText", var1)

		setText(var12, var10)
		setScrollText(var12, var10)
		setActive(var12, true)

		local var13 = arg0:findTF("Empty/BuildType/ShipNameMask/ShipNameText", var1)

		setText(var13, var10)
		setScrollText(var13, var10)
		setActive(var13, true)

		local var14 = arg0:findTF("Empty/PassType/ShipNameMask/ShipNameText", var1)

		setText(var14, var10)
		setScrollText(var14, var10)
		setActive(var14, true)

		local var15 = arg0:findTF("Active/ActType/ShipNameMask/ShipNameText", var1)

		setText(var15, var10)
		setScrollText(var15, var10)
		setActive(var15, true)

		local var16 = arg0:findTF("Active/BuildType/ShipNameMask/ShipNameText", var1)

		setText(var16, var10)
		setScrollText(var16, var10)
		setActive(var16, true)

		local var17 = arg0:findTF("Active/PassType/ShipNameMask/ShipNameText", var1)

		setText(var17, var10)
		setScrollText(var17, var10)
		setActive(var17, true)
	end

	if arg1 == false then
		setActive(var2, true)
		setActive(var3, false)
		setActive(var4, false)
	else
		setActive(var2, false)

		local var18 = arg1:isUnlocked()

		setActive(var3, not var18)
		setActive(var4, var18)

		local var19 = arg1:isPtType()
		local var20 = arg1:isPassType()
		local var21 = arg1:isBuildType()

		if not var18 then
			local var22 = arg0:findTF("Empty/ActType", var1)
			local var23 = arg0:findTF("Empty/BuildType", var1)
			local var24 = arg0:findTF("Empty/PassType", var1)

			setActive(var22, var19)
			setActive(var23, var21)
			setActive(var24, var20)

			local var25, var26 = arg1:getBannerPathAndName()
			local var27 = LoadSprite(var25, var26)

			setImageSprite(var22, var27)
			setImageSprite(var23, var27)
			setImageSprite(var24, var27)

			if var19 then
				local var28 = arg0:findTF("NumText", var22)
				local var29 = string.format("%d", arg1:getSynRate() * 100) .. "%"

				setText(var28, var29)

				local var30 = arg0:findTF("Slider", var22)

				setSlider(var30, 0, 1, arg1:getSynRate())
				setActive(var30, false)
			end

			local var31 = pg.ship_strengthen_meta[arg1.configId].ship_id
			local var32 = Ship.New({
				configId = var31
			})
			local var33 = var32:getMaxStar()
			local var34 = var32:getStar()
			local var35 = arg0:findTF("Empty/StarTpl", var1)
			local var36 = arg0:findTF("Empty/Stars", var1)
			local var37 = UIItemList.New(var36, var35)

			var37:make(function(arg0, arg1, arg2)
				if arg0 == UIItemList.EventUpdate then
					arg1 = arg1 + 1

					local var0 = arg0:findTF("On", arg2)

					setActive(var0, arg1 <= var34)
				end
			end)
			var37:align(var33)
		else
			local var38 = arg0:findTF("Active/ActType", var1)
			local var39 = arg0:findTF("Active/BuildType", var1)
			local var40 = arg0:findTF("Active/PassType", var1)

			setActive(var38, var19)
			setActive(var39, var21)
			setActive(var40, var20)

			local var41, var42 = arg1:getBannerPathAndName()
			local var43 = LoadSprite(var41, var42)

			setImageSprite(arg0:findTF("Active", var1), LoadSprite(var41, var42))

			local var44 = arg1:getShip()
			local var45 = var44:getMetaCharacter()

			if var19 then
				local var46 = arg0:findTF("NumText", var38)
				local var47 = string.format("%d", var45:getRepairRate() * 100) .. "%"

				setText(var46, var47)

				local var48 = arg0:findTF("Slider", var38)

				setSlider(var48, 0, 1, var45:getRepairRate())
				setActive(var48, false)
			end

			local var49 = var44:getMaxStar()
			local var50 = var44:getStar()
			local var51 = arg0:findTF("Active/StarTpl", var1)
			local var52 = arg0:findTF("Active/Stars", var1)
			local var53 = UIItemList.New(var52, var51)

			var53:make(function(arg0, arg1, arg2)
				if arg0 == UIItemList.EventUpdate then
					arg1 = arg1 + 1

					local var0 = arg0:findTF("On", arg2)

					setActive(var0, arg1 <= var50)
				end
			end)
			var53:align(var49)
		end
	end

	onButton(arg0, var0, function()
		if arg0.curMetaIndex ~= arg3 then
			if arg0.curMetaIndex and arg0.curMetaIndex > 0 then
				arg0:changeBannerOnClick(arg0.bannerTFList[arg0.curMetaIndex], false)
			end

			arg0.curMetaIndex = arg3

			arg0:changeBannerOnClick(var0, true)
			arg0:updateMain()
		end
	end, SFX_PANEL)

	if arg1 == false then
		setButtonEnabled(var0, false)
	else
		setButtonEnabled(var0, true)
	end
end

function var0.changeBannerOnClick(arg0, arg1, arg2)
	local var0 = arg1:GetComponent("LayoutElement")
	local var1 = arg0:findTF("ForScale", arg1)

	if arg2 == true then
		setLocalScale(var1, var0.SCALE_ON_PITCH)

		var0.preferredWidth = 338.3
		var0.preferredHeight = 102
	else
		setLocalScale(var1, Vector2.one)

		var0.preferredWidth = 199
		var0.preferredHeight = 60
	end

	local var2 = arg0:findTF("SelectedTag", var1)

	setActive(var2, arg2)
end

function var0.updateBannerShipName(arg0, arg1)
	local var0 = arg0:findTF("ForScale", arg1)
	local var1 = arg0:findTF("SelectedTag", var0)
	local var2 = isActive(var1)
	local var3
	local var4 = arg0:findTF("Empty/ActType/ShipNameText", var0)

	setActive(var4, var2)

	local var5 = arg0:findTF("Empty/BuildType/ShipNameText", var0)

	setActive(var5, var2)

	local var6 = arg0:findTF("Active/ActType/ShipNameText", var0)

	setActive(var6, var2)

	local var7 = arg0:findTF("Active/BuildType/ShipNameText", var0)

	setActive(var7, var2)

	local var8
	local var9 = arg0:findTF("Empty/ActType/TipText", var0)

	setActive(var9, not var2)

	local var10 = arg0:findTF("Empty/BuildType/TipText", var0)

	setActive(var10, not var2)

	local var11 = arg0:findTF("Active/ActType/Text", var0)

	setActive(var11, not var2)

	local var12 = arg0:findTF("Active/BuildType/Text", var0)

	setActive(var12, not var2)
end

function var0.updateBannerUIList(arg0)
	arg0.bannerTFList = {}

	arg0.scrollUIItemList:align(#arg0.metaProgressVOList)
end

function var0.updateStart(arg0)
	local var0 = false

	for iter0, iter1 in ipairs(arg0.metaProgressVOList) do
		if iter1 ~= false then
			var0 = true

			break
		end
	end

	local var1 = arg0:findTF("On", arg0.indexBtn)

	setActive(var1, not arg0:isDefaultStatus())
	setActive(arg0.noCharTF, not var0)
	setActive(arg0.hidePanel, var0)

	if not var0 then
		return
	end

	arg0:resetBannerListScale()
	arg0:updateBannerUIList()

	arg0.curMetaIndex = nil

	if var0 then
		triggerButton(arg0.bannerTFList[1])
	end
end

function var0.resetBannerListScale(arg0)
	for iter0, iter1 in ipairs(arg0.bannerTFList) do
		local var0 = iter1:GetComponent("LayoutElement")
		local var1 = arg0:findTF("ForScale", iter1)

		setLocalScale(var1, Vector2.one)

		var0.preferredWidth = 199
		var0.preferredHeight = 60
	end
end

function var0.updateMain(arg0, arg1)
	local var0 = arg0:getCurMetaProgressVO()
	local var1 = var0:isUnlocked()

	setActive(arg0.menuPanel, var1)
	setActive(arg0.ptPanel, not var1)
	setActive(arg0.goGetPanel, not var1)
	arg0:updateActTimePanel()

	if not var1 then
		local var2 = var0:isPtType()
		local var3 = var0:isPassType()
		local var4 = var0:isBuildType()

		setActive(arg0.ptPanel, var2)
		setActive(arg0.goGetPanel, var3 or var4)

		if var2 then
			arg0:updatePTPanel(arg1)
		end
	else
		arg0:TryPlayGuide()
	end

	arg0:updateRedPoints()

	local var5, var6 = var0:getPaintPathAndName()

	setImageSprite(arg0.shipImg, LoadSprite(var5, var6), true)

	local var7, var8 = var0:getBGNamePathAndName()

	setImageSprite(arg0.shipNameImg, LoadSprite(var7, var8), true)

	local var9 = var0.id
	local var10 = MetaCharacterConst.UIConfig[var9]

	setLocalPosition(arg0.shipImg, {
		x = var10[1],
		y = var10[2]
	})
	setLocalScale(arg0.shipImg, {
		x = var10[3],
		y = var10[4]
	})
end

function var0.TryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0024")
end

function var0.updateActTimePanel(arg0)
	local var0 = arg0:getCurMetaProgressVO()
	local var1 = var0:isUnlocked()
	local var2 = var0:isInAct()

	setActive(arg0.actTimePanel, not var1 and var2)
	setActive(arg0.synBtnLimitTimeTF, var2)

	if var2 then
		local var3 = var0.timeConfig[1][1]
		local var4 = var0.timeConfig[2][1]
		local var5 = "%d.%d.%d-%d.%d.%d"
		local var6 = string.format(var5, var3[1], var3[2], var3[3], var4[1], var4[2], var4[3])

		setText(arg0.actTimeText, var6)

		local var7 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.timeConfig[2])
		local var8 = pg.TimeMgr.GetInstance():GetServerTime()
		local var9 = pg.TimeMgr.GetInstance():DiffDay(var8, var7)
		local var10 = arg0:findTF("Text", arg0.synBtnLimitTimeTF)

		setText(var10, i18n("meta_pt_left", var9))
	end
end

function var0.updatePTPanel(arg0, arg1)
	local var0 = arg0:getCurMetaProgressVO()
	local var1 = var0:getSynRate()
	local var2 = var1 * 100
	local var3 = tonumber(tostring(var2))

	setImageSprite(arg0.ptIcon, LoadSprite(var0:getPtIconPath()))
	setFillAmount(arg0.ptProgressImg, var1)
	setActive(arg0.ptProgressScaleLine, var1 < 1)

	arg0.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * var1)

	local var4 = string.format("%d", var3)
	local var5 = (var3 - math.floor(var3)) * 100 == 0
	local var6 = string.format("%2d", (var3 - math.floor(var3)) * 100)

	var6 = var5 and var6 .. "0%" or var6 .. "%"

	setText(arg0.ptProgressRedLeftNumText, var4)
	setText(arg0.ptProgressWhiteLeftNumText, var4)
	setText(arg0.ptProgressRedRightNumText, var6)
	setText(arg0.ptProgressWhiteRightNumText, var6)

	local var7, var8, var9 = var0.metaPtData:GetResProgress()

	setText(arg0.ptProgressRedText, (var9 >= 1 and setColorStr(var7, COLOR_GREEN) or setColorStr(var7, COLOR_RED)) .. "/" .. var8)
	setText(arg0.ptProgressWhiteText, (var9 >= 1 and setColorStr(var7, COLOR_GREEN) or setColorStr(var7, COLOR_RED)) .. "/" .. var8)

	local var10 = var0:getMetaProgressPTState()

	if var10 == MetaProgress.STATE_CAN_FINISH then
		setActive(arg0.ptRedBarImg, true)
		setActive(arg0.ptPreviewBtn, false)
		setActive(arg0.ptGetBtn, false)
		setActive(arg0.ptShowWayBtn, false)
		setActive(arg0.ptInfoPanel, false)
		setActive(arg0.storyInfoPanel, false)
		setActive(arg0.getShipBtn, true)
	elseif var10 == MetaProgress.STATE_CAN_AWARD then
		setActive(arg0.ptRedBarImg, false)
		setActive(arg0.ptPreviewBtn, true)
		setActive(arg0.ptGetBtn, true)
		setActive(arg0.ptShowWayBtn, false)
		setActive(arg0.ptGetBtnTag, true)
		setActive(arg0.ptInfoPanel, true)
		setActive(arg0.storyInfoPanel, false)
		setActive(arg0.getShipBtn, false)
		setImageAlpha(arg0.ptPreviewBtn, 0)
		setImageAlpha(arg0.ptGetBtn, 0)
		setImageAlpha(arg0.ptGetBtnTag, 0)
		setImageAlpha(arg0.ptShowWayBtn, 0)
	elseif var10 == MetaProgress.STATE_LESS_STORY then
		setActive(arg0.ptRedBarImg, true)
		setActive(arg0.ptPreviewBtn, true)
		setActive(arg0.ptGetBtn, true)
		setActive(arg0.ptShowWayBtn, false)
		setActive(arg0.ptGetBtnTag, false)
		setActive(arg0.ptInfoPanel, false)
		setActive(arg0.storyInfoPanel, true)
		setActive(arg0.getShipBtn, false)

		local var11 = var0:getCurLevelStoryName()

		setText(arg0.storyNameText, var11)
	elseif var10 == MetaProgress.STATE_LESS_PT then
		setActive(arg0.ptRedBarImg, false)
		setActive(arg0.ptPreviewBtn, true)
		setActive(arg0.ptGetBtn, false)
		setActive(arg0.ptShowWayBtn, true)
		setActive(arg0.ptGetBtnTag, false)
		setActive(arg0.ptInfoPanel, true)
		setActive(arg0.storyInfoPanel, false)
		setActive(arg0.getShipBtn, false)
		setImageAlpha(arg0.ptPreviewBtn, 0)
		setImageAlpha(arg0.ptGetBtn, 0)
		setImageAlpha(arg0.ptShowWayBtn, 0)
	end

	if var1 > 0 and not arg1 then
		if var10 == MetaProgress.STATE_CAN_AWARD or var10 == MetaProgress.STATE_LESS_PT then
			local var12 = math.min(var1, 1)

			arg0:managedTween(LeanTween.value, nil, go(arg0.ptPanel), 0, var1, var12):setOnUpdate(System.Action_float(function(arg0)
				setFillAmount(arg0.ptProgressImg, arg0)
				setActive(arg0.ptProgressScaleLine, arg0 < 1)

				arg0.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * arg0)

				local var0 = arg0 * 100
				local var1 = string.format("%d", var0)
				local var2 = (var0 - math.floor(var0)) * 100 == 0
				local var3 = string.format("%2d", (var0 - math.floor(var0)) * 100)

				var3 = var2 and var3 .. "0%" or var3 .. "%"

				setText(arg0.ptProgressRedLeftNumText, var1)
				setText(arg0.ptProgressWhiteLeftNumText, var1)
				setText(arg0.ptProgressRedRightNumText, var3)
				setText(arg0.ptProgressWhiteRightNumText, var3)
			end)):setOnComplete(System.Action(function()
				setFillAmount(arg0.ptProgressImg, var1)
				setActive(arg0.ptProgressScaleLine, var1 < 1)

				arg0.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * var1)

				local var0 = string.format("%d", var3)
				local var1 = (var3 - math.floor(var3)) * 100 == 0
				local var2 = string.format("%2d", (var3 - math.floor(var3)) * 100)

				var2 = var1 and var2 .. "0%" or var2 .. "%"

				setText(arg0.ptProgressRedLeftNumText, var0)
				setText(arg0.ptProgressWhiteLeftNumText, var0)
				setText(arg0.ptProgressRedRightNumText, var2)
				setText(arg0.ptProgressWhiteRightNumText, var2)
				arg0:managedTween(LeanTween.value, nil, go(arg0.ptPanel), 0, 1, var12 / 2):setOnUpdate(System.Action_float(function(arg0)
					setImageAlpha(arg0.ptPreviewBtn, arg0)
					setImageAlpha(arg0.ptGetBtn, arg0)
					setImageAlpha(arg0.ptGetBtnTag, arg0)
					setImageAlpha(arg0.ptShowWayBtn, arg0)
				end)):setOnComplete(System.Action(function()
					setImageAlpha(arg0.ptPreviewBtn, 1)
					setImageAlpha(arg0.ptGetBtn, 1)
					setImageAlpha(arg0.ptGetBtnTag, 1)
					setImageAlpha(arg0.ptShowWayBtn, 1)
				end))
			end))
		end
	else
		setImageAlpha(arg0.ptPreviewBtn, 1)
		setImageAlpha(arg0.ptGetBtn, 1)
		setImageAlpha(arg0.ptGetBtnTag, 1)
		setImageAlpha(arg0.ptShowWayBtn, 1)
	end
end

function var0.updateRedPoints(arg0)
	local var0 = arg0:getCurMetaProgressVO()
	local var1 = var0.id
	local var2 = MetaCharacterConst.isMetaRepairRedTag(var1)

	setActive(arg0:findTF("RepairBtn/Tag", arg0.repairBtn), var2)

	local var3 = not MetaCharacterConst.filteMetaRepairAble(var0)

	setActive(arg0:findTF("Finish", arg0.repairBtn), var3)

	local var4 = MetaCharacterConst.isMetaEnergyRedTag(var1)

	setActive(arg0:findTF("Tag", arg0.energyBtn), var4)

	local var5 = not MetaCharacterConst.filteMetaEnergyAble(var0)

	setActive(arg0:findTF("Finish", arg0.energyBtn), var5)

	local var6 = not MetaCharacterConst.filteMetaTacticsAble(var0)

	setActive(arg0:findTF("Finish", arg0.tacticsBtn), var6)

	local var7 = MetaCharacterConst.isMetaTacticsRedTag(var1)
	local var8 = var0.metaShipVO

	if var8 then
		local var9 = arg0.metaCharacterProxy:getMetaTacticsInfoByShipID(var8.id):getTacticsStateForShow()

		setActive(arg0:findTF("Tag", arg0.tacticsBtn), false)
		setActive(arg0:findTF("Learnable", arg0.tacticsBtn), var9 == MetaTacticsInfo.States.LearnAble)
		setActive(arg0:findTF("Learning", arg0.tacticsBtn), var9 == MetaTacticsInfo.States.Learning)
		setActive(arg0:findTF("LearnFinish", arg0.tacticsBtn), var9 == MetaTacticsInfo.States.LearnFinished and var7)
	else
		setActive(arg0:findTF("Tag", arg0.tacticsBtn), false)
		setActive(arg0:findTF("Learnable", arg0.tacticsBtn), false)
		setActive(arg0:findTF("Learning", arg0.tacticsBtn), false)
		setActive(arg0:findTF("LearnFinish", arg0.tacticsBtn), false)
	end

	local var10 = var0:isPtType()
	local var11 = var0:isInAct()
	local var12 = var0:isInArchive()
	local var13 = var10

	setActive(arg0.synDecorateTF, var13)
	setActive(arg0.synBtn, var10)
	setActive(arg0.synBtnLock, var10 and not var11 and not var12)
	setActive(arg0.toggleList[4], var10)
	setActive(arg0.synToggleLock, var10 and not var11 and not var12)

	local var14

	if var13 then
		var14 = MetaCharacterConst.isMetaSynRedTag(var1)

		setActive(arg0:findTF("Tag", arg0.synBtn), var14)
	end

	local var15 = not MetaCharacterConst.filteMetaSynAble(var0)

	setActive(arg0:findTF("Finish", arg0.synBtn), var15)
	setActive(arg0:findTF("Tip", arg0.toggleList[var0.PAGES.REPAIR]), var2)
	setActive(arg0:findTF("Tip", arg0.toggleList[var0.PAGES.ENERGY]), var4)
	setActive(arg0:findTF("Tip", arg0.toggleList[var0.PAGES.TACTICS]), var7)
	setActive(arg0:findTF("Tip", arg0.toggleList[var0.PAGES.SYN]), var14)

	for iter0, iter1 in ipairs(arg0.metaProgressVOList) do
		local var16 = arg0.bannerTFList[iter0]
		local var17 = arg0:findTF("ForScale/RedPoint", var16)

		if iter1 then
			setActive(var17, MetaCharacterConst.isMetaBannerRedPoint(iter1.id))
		else
			setActive(var17, false)
		end
	end
end

function var0.getCurMetaProgressVO(arg0)
	local var0 = arg0.curMetaIndex

	return arg0.metaProgressVOList[var0]
end

function var0.refreshBannerTF(arg0)
	local var0 = arg0:getCurMetaProgressVO()
	local var1 = arg0.bannerTFList[arg0.curMetaIndex]

	arg0:updateBannerTF(var0, var1, arg0.curMetaIndex)
end

function var0.enterMenuPage(arg0, arg1)
	setActive(arg0.hidePanel, not arg1)
	setActive(arg0.indexBtn, not arg1)
	setActive(arg0.toggleBtnsTF, arg1)
end

function var0.switchPage(arg0, arg1)
	if not arg0.curPageIndex then
		if arg1 == 1 then
			setActive(arg0.toggleBtnsTF, true)
		end

		triggerToggle(arg0.toggleList[arg1], true)
	end
end

function var0.backFromRepair(arg0)
	setActive(arg0.menuPanel, false)
	arg0:managedTween(LeanTween.alpha, nil, arg0.shipImg, 1, 0.3):setFrom(0):setOnComplete(System.Action(function()
		setActive(arg0.menuPanel, true)
		setActive(arg0.hidePanel, true)
	end))
end

function var0.backFromNotRepair(arg0)
	local var0 = arg0:getCurMetaProgressVO().id
	local var1 = MetaCharacterConst.UIConfig[var0]

	setActive(arg0.menuPanel, false)

	local var2 = -250
	local var3 = var1[1]

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.shipImg), var3, 0.3):setFrom(var2):setOnComplete(System.Action(function()
		setActive(arg0.menuPanel, true)
		setActive(arg0.hidePanel, true)
	end))
end

function var0.autoOpenFunc(arg0)
	if arg0.contextData.autoOpenShipConfigID then
		local var0 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0.contextData.autoOpenShipConfigID)
		local var1 = arg0:getMetaProgressListForShow()
		local var2 = 0

		for iter0, iter1 in ipairs(var1) do
			if iter1 and iter1.id == var0 then
				triggerButton(arg0.bannerTFList[iter0])

				arg0.contextData.autoOpenShipConfigID = nil
			end
		end
	end

	if arg0.contextData.autoOpenTactics then
		triggerButton(arg0.tacticsBtn)

		arg0.contextData.autoOpenTactics = nil
	end

	if arg0.contextData.autoOpenEnergy then
		triggerButton(arg0.energyBtn)

		arg0.contextData.autoOpenEnergy = nil
	end

	if arg0.contextData.autoOpenSyn then
		if arg0:getCurMetaProgressVO():isUnlocked() then
			triggerButton(arg0.synBtn)
		end

		arg0.contextData.autoOpenSyn = nil
	end

	if arg0.contextData.lastPageIndex then
		triggerToggle(arg0.toggleList[arg0.contextData.lastPageIndex], true)

		arg0.contextData.lastPageIndex = nil
	end
end

function var0.openIndexLayer(arg0)
	if not arg0.indexDatas then
		arg0.indexDatas = {}
	end

	local var0 = {
		indexDatas = Clone(arg0.indexDatas),
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
		callback = function(arg0)
			if not isActive(arg0._tf) then
				return
			end

			arg0.indexDatas.typeIndex = arg0.typeIndex
			arg0.indexDatas.rarityIndex = arg0.rarityIndex
			arg0.indexDatas.extraIndex = arg0.extraIndex
			arg0.metaProgressVOList = arg0:getMetaProgressListForShow()

			arg0:fillMetaProgressList()
			arg0:updateStart()
		end
	}

	arg0:emit(MetaCharacterMediator.OPEN_INDEX_LAYER, var0)
end

function var0.isDefaultStatus(arg0)
	return (not arg0.indexDatas.typeIndex or arg0.indexDatas.typeIndex == ShipIndexConst.TypeAll) and (not arg0.indexDatas.rarityIndex or arg0.indexDatas.rarityIndex == ShipIndexConst.RarityAll) and (not arg0.indexDatas.extraIndex or arg0.indexDatas.extraIndex == ShipIndexConst.MetaExtraAll)
end

function var0.overLayPanel(arg0, arg1)
	if arg1 == true then
		pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
			groupName = LayerWeightConst.GROUP_META
		})
	elseif arg1 == false then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
	end
end

function var0.getMetaProgressListForShow(arg0)
	local var0 = {}
	local var1 = arg0.metaCharacterProxy:getMetaProgressVOList()
	local var2
	local var3
	local var4

	for iter0, iter1 in ipairs(var1) do
		local var5 = MetaCharacterConst.filteMetaByType(iter1, arg0.indexDatas.typeIndex)
		local var6 = MetaCharacterConst.filteMetaByRarity(iter1, arg0.indexDatas.rarityIndex)
		local var7 = MetaCharacterConst.filteMetaExtra(iter1, arg0.indexDatas.extraIndex)

		if var5 and var6 and var7 and iter1:isShow() then
			if iter1:isPtType() and iter1:isInAct() then
				var2 = iter1
			elseif iter1:isPassType() and iter1:isInAct() then
				var3 = iter1
			elseif iter1:isBuildType() and iter1:isInAct() then
				var4 = iter1
			else
				table.insert(var0, iter1)
			end
		end
	end

	if var4 then
		table.insert(var0, 1, var4)
	end

	if var3 then
		table.insert(var0, 1, var3)
	end

	if var2 then
		table.insert(var0, 1, var2)
	end

	return var0
end

function var0.filteMetaProgressList(arg0)
	local var0 = arg0:getMetaProgressListForShow()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = MetaCharacterConst.filteMetaByType(iter1, arg0.indexDatas.typeIndex)
		local var3 = MetaCharacterConst.filteMetaByRarity(iter1, arg0.indexDatas.rarityIndex)
		local var4 = MetaCharacterConst.filteMetaExtra(iter1, arg0.indexDatas.extraIndex)

		if var2 and var3 and var4 then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var0.getOneStepPTAwardLevelAndCount(arg0)
	local var0 = arg0:getCurMetaProgressVO()
	local var1 = var0.metaPtData:GetResProgress()
	local var2 = var0.metaPtData.targets
	local var3 = var0:getStoryIndexList()
	local var4 = var0.unlockPTLevel
	local var5 = 0

	for iter0 = 1, var4 - 1 do
		local var6 = false
		local var7 = false

		if var1 >= var2[iter0] then
			var6 = true
		end

		local var8 = var3[iter0]

		if var8 == 0 then
			var7 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var8) then
			var7 = true
		end

		if var6 and var7 then
			var5 = iter0
		else
			break
		end
	end

	return var5, var2[var5]
end

return var0

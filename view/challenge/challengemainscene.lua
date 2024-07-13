local var0_0 = class("ChallengeMainScene", import("..base.BaseUI"))

var0_0.BOSS_NUM = 5
var0_0.FADE_TIME = 5

function var0_0.getUIName(arg0_1)
	return "ChallengeMainUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateGrade(arg0_3.challengeInfo:getGradeList())
	arg0_3:updateTimePanel()
	arg0_3:updateSwitchModBtn()
	arg0_3:updateAwardPanel()
	arg0_3:updatePaintingList(arg0_3.nameList, arg0_3.showingIndex)
	arg0_3:updateRoundText(arg0_3.showingIndex)
	arg0_3:updateSlider(arg0_3.showingIndex)
	arg0_3:updateFuncBtns()
	arg0_3:showSLResetMsgBox()

	if arg0_3.contextData.editFleet then
		arg0_3:doOnFleetPanel()

		arg0_3.contextData.editFleet = nil
	end

	arg0_3:tryPlayGuide()
end

function var0_0.willExit(arg0_4)
	LeanTween.cancel(go(arg0_4.modTipTF))

	if arg0_4.timer then
		arg0_4.timer:Stop()
	end

	arg0_4:destroyCommanderPanel()
end

function var0_0.onBackPressed(arg0_5)
	if isActive(arg0_5.fleetSelect) then
		arg0_5:hideFleetEdit()
	else
		triggerButton(arg0_5.backBtn)
	end
end

function var0_0.setFleet(arg0_6, arg1_6)
	arg0_6.fleets = {}

	local function var0_6(arg0_7)
		arg0_6.fleets[arg0_7] = {
			arg1_6[arg0_7 + 1],
			[11] = arg1_6[arg0_7 + 11]
		}
	end

	var0_6(ChallengeProxy.MODE_CASUAL)
	var0_6(ChallengeProxy.MODE_INFINITE)
end

function var0_0.findUI(arg0_8)
	arg0_8.northTF = arg0_8:findTF("ForNorth")
	arg0_8.paintingListTF = arg0_8:findTF("PaintingList")
	arg0_8.backBtn = arg0_8:findTF("top/back_button", arg0_8.northTF)
	arg0_8.gradeContainer = arg0_8:findTF("GradeContainer", arg0_8.northTF)
	arg0_8.seasonBestPointText = arg0_8:findTF("SeasonBestPoint/Text", arg0_8.gradeContainer)
	arg0_8.activityBestPointText = arg0_8:findTF("ActivityBestPoint/Text", arg0_8.gradeContainer)
	arg0_8.seasonLevelNumText = arg0_8:findTF("SeasonLevelNum/Text", arg0_8.gradeContainer)
	arg0_8.activityLevelNumText = arg0_8:findTF("ActivityLevelNum/Text", arg0_8.gradeContainer)
	arg0_8.timeTipTF = arg0_8:findTF("TimeTip", arg0_8.northTF)
	arg0_8.activityTimeText = arg0_8:findTF("ActivityTimeText", arg0_8.timeTipTF)
	arg0_8.seasonDayText = arg0_8:findTF("SeasonTipText/DayText", arg0_8.timeTipTF)
	arg0_8.seasonTimeText = arg0_8:findTF("SeasonTimeText", arg0_8.timeTipTF)
	arg0_8.switchModTF = arg0_8:findTF("SwitchMod", arg0_8.northTF)
	arg0_8.casualModBtn = arg0_8:findTF("NormalBtn", arg0_8.switchModTF)
	arg0_8.infiniteModBtn = arg0_8:findTF("EndlessBtn", arg0_8.switchModTF)
	arg0_8.casualModBtnBG = arg0_8:findTF("BG", arg0_8.casualModBtn)
	arg0_8.infiniteModBtnBG = arg0_8:findTF("BG", arg0_8.infiniteModBtn)
	arg0_8.casualModBtnSC = GetComponent(arg0_8.casualModBtn, "Button")
	arg0_8.infiniteModBtnSC = GetComponent(arg0_8.infiniteModBtn, "Button")
	arg0_8.functionBtnsTF = arg0_8:findTF("FunctionBtns", arg0_8.northTF)
	arg0_8.rankBtn = arg0_8:findTF("RankBtn", arg0_8.functionBtnsTF)
	arg0_8.startBtn = arg0_8:findTF("StartBtn", arg0_8.functionBtnsTF)
	arg0_8.resetBtn = arg0_8:findTF("ResetBtn", arg0_8.functionBtnsTF)
	arg0_8.startBtnBanned = arg0_8:findTF("StartBtnBanned", arg0_8.functionBtnsTF)
	arg0_8.resetBtnBanned = arg0_8:findTF("ResetBtnBanned", arg0_8.functionBtnsTF)
	arg0_8.awardTF = arg0_8:findTF("Award", arg0_8.northTF)
	arg0_8.helpBtn = arg0_8:findTF("HelpBtn", arg0_8.awardTF)
	arg0_8.getBtn = arg0_8:findTF("GetBtn", arg0_8.awardTF)
	arg0_8.gotBtn = arg0_8:findTF("GotBtn", arg0_8.awardTF)
	arg0_8.getBtnBanned = arg0_8:findTF("GetBtnBanned", arg0_8.awardTF)
	arg0_8.itemTF = arg0_8:findTF("ItemBG/item", arg0_8.awardTF)
	arg0_8.scoreText = arg0_8:findTF("Score/ScoreText", arg0_8.awardTF)
	arg0_8.slider = arg0_8:findTF("Slider", arg0_8.northTF)
	arg0_8.squareContainer = arg0_8:findTF("SquareList", arg0_8.slider)
	arg0_8.squareTpl = arg0_8:findTF("Squre", arg0_8.slider)
	arg0_8.squareList = UIItemList.New(arg0_8.squareContainer, arg0_8.squareTpl)
	arg0_8.sliderSC = GetComponent(arg0_8.slider, "Slider")
	arg0_8.paintingContainer = arg0_8:findTF("PaintingList")
	arg0_8.scrollSC = GetComponent(arg0_8.paintingContainer, "Slider")
	arg0_8.material = arg0_8:findTF("material"):GetComponent(typeof(Image)).material
	arg0_8.material1 = arg0_8:findTF("material1"):GetComponent(typeof(Image)).material
	arg0_8.painting = arg0_8:findTF("Painting", arg0_8.paintingContainer)
	arg0_8.paintingShadow1 = arg0_8:findTF("PaintingShadow1", arg0_8.painting)
	arg0_8.paintingShadow2 = arg0_8:findTF("PaintingShadow2", arg0_8.painting)
	arg0_8.bossInfoImg = arg0_8:findTF("InfoImg", arg0_8.painting)
	arg0_8.roundNumText = arg0_8:findTF("Round/NumText", arg0_8.painting)
	arg0_8.completeEffectTF = arg0_8:findTF("TZ02", arg0_8.painting)

	SetActive(arg0_8.completeEffectTF, false)

	arg0_8.card1TF = arg0_8:findTF("Card1", arg0_8.paintingContainer)
	arg0_8.shipPaintImg_1 = arg0_8:findTF("Mask/ShipPaint", arg0_8.card1TF)
	arg0_8.tag_1 = arg0_8:findTF("Tag", arg0_8.card1TF)
	arg0_8.mask_1 = arg0_8:findTF("Mask", arg0_8.card1TF)
	arg0_8.roundTF_1 = arg0_8:findTF("Round", arg0_8.card1TF)
	arg0_8.roundText_1 = arg0_8:findTF("Round/RoundText", arg0_8.card1TF)
	arg0_8.card2TF = arg0_8:findTF("Card2", arg0_8.paintingContainer)
	arg0_8.shipPaintImg_2 = arg0_8:findTF("Mask/ShipPaint", arg0_8.card2TF)
	arg0_8.tag_2 = arg0_8:findTF("Tag", arg0_8.card2TF)
	arg0_8.mask_2 = arg0_8:findTF("Mask", arg0_8.card2TF)
	arg0_8.roundTF_2 = arg0_8:findTF("Round", arg0_8.card2TF)
	arg0_8.roundText_2 = arg0_8:findTF("Round/RoundText", arg0_8.card2TF)
	arg0_8.modTipBtn = arg0_8:findTF("ModTipBtn", arg0_8.northTF)
	arg0_8.modTipTF = arg0_8:findTF("TipText", arg0_8.northTF)
	arg0_8.modTipText = arg0_8:findTF("Text", arg0_8.modTipTF)

	setActive(arg0_8.modTipTF, false)

	arg0_8.fleetSelect = arg0_8:findTF("LevelFleetSelectView")
	arg0_8.fleetEditPanel = ActivityFleetPanel.New(arg0_8.fleetSelect.gameObject)

	function arg0_8.fleetEditPanel.onCancel()
		arg0_8:hideFleetEdit()
	end

	function arg0_8.fleetEditPanel.onCommit()
		arg0_8:commitEdit()
	end

	function arg0_8.fleetEditPanel.onCombat()
		arg0_8:commitEdit()
		arg0_8:emit(ChallengeMainMediator.ON_PRECOMBAT, arg0_8.curMode)
	end

	function arg0_8.fleetEditPanel.onLongPressShip(arg0_12, arg1_12)
		arg0_8:openShipInfo(arg0_12, arg1_12)
	end

	arg0_8:buildCommanderPanel()
end

function var0_0.tryPlayGuide(arg0_13)
	pg.SystemGuideMgr.GetInstance():Play(arg0_13)
end

function var0_0.initData(arg0_14)
	arg0_14.challengeProxy = getProxy(ChallengeProxy)
	arg0_14.challengeInfo = arg0_14.challengeProxy:getChallengeInfo()
	arg0_14.userChallengeInfoList = arg0_14.challengeProxy:getUserChallengeInfoList()
	arg0_14.timeOverTag = false

	arg0_14:updateData()

	arg0_14.openedCommanerSystem = true
end

function var0_0.addListener(arg0_15)
	onButton(arg0_15, arg0_15.backBtn, function()
		arg0_15:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.challenge_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.rankBtn, function()
		arg0_15:emit(ChallengeMainMediator.ON_OPEN_RANK)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.startBtn, function()
		local var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

		if not var0_19 or var0_19:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
			triggerButton(arg0_15.backBtn)

			return
		end

		if arg0_15:isCrossedSeason() == true then
			local var1_19 = arg0_15.challengeProxy:getCurMode()

			if not arg0_15.curModeInfo then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("challenge_season_update"),
					onYes = function()
						arg0_15:emit(ChallengeConst.RESET_DATA_EVENT, var1_19)
					end,
					onNo = function()
						arg0_15:emit(ChallengeConst.RESET_DATA_EVENT, var1_19)
					end
				})

				return
			else
				local var2_19 = var1_19 == ChallengeProxy.MODE_CASUAL and "challenge_season_update_casual_clear" or "challenge_season_update_infinite_clear"
				local var3_19 = var1_19 == ChallengeProxy.MODE_CASUAL and arg0_15.curModeInfo:getScore() or arg0_15.curModeInfo:getLevel()

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = false,
					content = i18n(var2_19, var3_19),
					onNo = function()
						arg0_15:emit(ChallengeConst.RESET_DATA_EVENT, var1_19)
					end,
					onYes = function()
						arg0_15:emit(ChallengeMainMediator.ON_PRECOMBAT, arg0_15.curMode)
					end
				})

				return
			end
		end

		if not arg0_15.curModeInfo then
			arg0_15:doOnFleetPanel()

			return
		end

		arg0_15:emit(ChallengeMainMediator.ON_PRECOMBAT, arg0_15.curMode)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.resetBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("challenge_normal_reset"),
			onYes = function()
				arg0_15:emit(ChallengeConst.RESET_DATA_EVENT, arg0_15.challengeProxy:getCurMode())
			end
		})
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.modTipBtn, function()
		arg0_15:showTipText()
	end)

	local function var0_15()
		if arg0_15.showingIndex % ChallengeConst.BOSS_NUM == 1 then
			return
		end

		arg0_15.showingIndex = arg0_15.showingIndex - 1

		arg0_15:updatePaintingList(arg0_15.nameList, arg0_15.showingIndex)
		arg0_15:updateRoundText(arg0_15.showingIndex)
		arg0_15:updateSlider(arg0_15.showingIndex)
	end

	local function var1_15()
		if arg0_15.showingIndex % ChallengeConst.BOSS_NUM == 0 then
			return
		end

		arg0_15.showingIndex = arg0_15.showingIndex + 1

		arg0_15:updatePaintingList(arg0_15.nameList, arg0_15.showingIndex)
		arg0_15:updateRoundText(arg0_15.showingIndex)
		arg0_15:updateSlider(arg0_15.showingIndex)
	end

	addSlip(SLIP_TYPE_HRZ, arg0_15.paintingContainer, var0_15, var1_15)
end

function var0_0.updateData(arg0_29)
	arg0_29.curMode = arg0_29.challengeProxy:getCurMode()
	arg0_29.curModeInfo = arg0_29.userChallengeInfoList[arg0_29.curMode]
	arg0_29.timeOverTag = false

	if not arg0_29.curModeInfo then
		arg0_29.curLevel = 1
		arg0_29.showingIndex = arg0_29.curLevel

		if arg0_29.curMode == ChallengeProxy.MODE_CASUAL then
			arg0_29.dungeonIDList = arg0_29.challengeInfo:getDungeonIDList()
		elseif arg0_29.curMode == ChallengeProxy.MODE_INFINITE then
			local var0_29 = arg0_29.challengeInfo:getSeasonID()
			local var1_29 = arg0_29.challengeInfo:getActivityIndex()

			arg0_29.dungeonIDList = pg.activity_event_challenge[var1_29].infinite_stage[var0_29][1]
		end
	else
		arg0_29.curLevel = arg0_29.curModeInfo:getLevel()
		arg0_29.showingIndex = arg0_29.curLevel
		arg0_29.dungeonIDList = arg0_29.curModeInfo:getDungeonIDList()

		print("self.dungeonIDList", tostring(arg0_29.dungeonIDList))
	end

	arg0_29.nameList = {}

	print("创建nameList", tostring(arg0_29.nameList), tostring(arg0_29.dungeonIDList), tostring(#arg0_29.dungeonIDList))

	arg0_29.infoNameList = {}

	for iter0_29, iter1_29 in ipairs(arg0_29.dungeonIDList) do
		local var2_29 = pg.expedition_challenge_template[iter1_29].char_icon[1]

		arg0_29.nameList[iter0_29] = var2_29

		print("self.nameList", tostring(var2_29))

		local var3_29 = pg.expedition_challenge_template[iter1_29].name_p

		arg0_29.infoNameList[iter0_29] = var3_29
	end

	arg0_29.nextNameList = {}

	if arg0_29.curMode == ChallengeProxy.MODE_INFINITE then
		local var4_29

		if arg0_29.curModeInfo then
			var4_29 = arg0_29.curModeInfo:getNextInfiniteDungeonIDList()
		else
			local var5_29 = arg0_29.challengeInfo:getSeasonID()
			local var6_29 = arg0_29.challengeInfo:getActivityIndex()

			if pg.activity_event_challenge[var6_29].infinite_stage[var5_29][2] then
				var4_29 = pg.activity_event_challenge[var6_29].infinite_stage[var5_29][2]
			else
				var4_29 = pg.activity_event_challenge[var6_29].infinite_stage[var5_29][1]
			end
		end

		for iter2_29, iter3_29 in ipairs(var4_29) do
			local var7_29 = pg.expedition_challenge_template[iter3_29].char_icon[1]

			arg0_29.nextNameList[iter2_29 + ChallengeConst.BOSS_NUM] = var7_29
		end
	end
end

function var0_0.updatePaintingList(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg1_30 or arg0_30.nameList
	local var1_30 = arg2_30 or arg0_30.showingIndex
	local var2_30 = arg0_30.curLevel

	if var1_30 > ChallengeConst.BOSS_NUM then
		var1_30 = var1_30 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var1_30 % ChallengeConst.BOSS_NUM
	end

	if arg0_30.curMode == ChallengeProxy.MODE_INFINITE and var2_30 > ChallengeConst.BOSS_NUM then
		var2_30 = var2_30 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var2_30 % ChallengeConst.BOSS_NUM
	end

	local function var3_30(arg0_31)
		arg0_31.material:SetFloat("_LineGray", 0.3)
		arg0_31.material:SetFloat("_TearDistance", 0)
		LeanTween.cancel(arg0_31.gameObject)
		LeanTween.value(arg0_31.gameObject, 0, 2, 2):setLoopClamp():setOnUpdate(System.Action_float(function(arg0_32)
			if arg0_32 >= 1.2 then
				arg0_31.material:SetFloat("_LineGray", 0.3)
			elseif arg0_32 >= 1.1 then
				arg0_31.material:SetFloat("_LineGray", 0.45)
			elseif arg0_32 >= 1.03 then
				arg0_31.material:SetFloat("_TearDistance", 0)
			elseif arg0_32 >= 1 then
				arg0_31.material:SetFloat("_TearDistance", 0.3)
			elseif arg0_32 >= 0.35 then
				arg0_31.material:SetFloat("_LineGray", 0.3)
			elseif arg0_32 >= 0.3 then
				arg0_31.material:SetFloat("_LineGray", 0.4)
			elseif arg0_32 >= 0.25 then
				arg0_31.material:SetFloat("_LineGray", 0.3)
			elseif arg0_32 >= 0.2 then
				arg0_31.material:SetFloat("_LineGray", 0.4)
			end
		end))
	end

	setPaintingPrefabAsync(arg0_30.painting, var0_30[var1_30], "chuanwu", function()
		local var0_33 = arg0_30:findTF("fitter", arg0_30.painting):GetChild(0)

		if var0_33 then
			local var1_33 = GetComponent(var0_33, "MeshImage")
			local var2_33 = var2_30 - 1 - var1_30 >= 0

			SetActive(arg0_30.completeEffectTF, var2_33)

			if var2_33 then
				var1_33.material = arg0_30.material1

				var1_33.material:SetFloat("_LineDensity", 7)
				var3_30(var1_33)
			else
				var1_33.material = arg0_30.material

				var1_33.material:SetFloat("_Range", 16)
				var1_33.material:SetFloat("_Degree", 7)
			end
		end
	end)
	setPaintingPrefabAsync(arg0_30.paintingShadow1, var0_30[var1_30], "chuanwu", function()
		local var0_34 = arg0_30:findTF("fitter", arg0_30.paintingShadow1):GetChild(0)

		if var0_34 then
			var0_34:GetComponent("Image").color = Color.New(0, 0, 0, 0.44)
		end
	end)
	setPaintingPrefabAsync(arg0_30.paintingShadow2, var0_30[var1_30], "chuanwu", function()
		local var0_35 = arg0_30:findTF("fitter", arg0_30.paintingShadow2):GetChild(0)

		if var0_35 then
			var0_35:GetComponent("Image").color = Color.New(1, 1, 1, 0.15)
		end
	end)
	LoadSpriteAsync("ChallengeBossInfo/" .. arg0_30.infoNameList[var1_30], function(arg0_36)
		setImageSprite(arg0_30.bossInfoImg, arg0_36, true)
	end)

	if var0_0.BOSS_NUM - var1_30 >= 2 then
		setActive(arg0_30.roundTF_1, true)
		setActive(arg0_30.roundTF_2, true)
		setActive(arg0_30.mask_1, true)
		setActive(arg0_30.mask_2, true)
		LoadSpriteAsync("shipYardIcon/" .. var0_30[var1_30 + 1], function(arg0_37)
			setImageSprite(arg0_30.shipPaintImg_1, arg0_37)
		end)
		LoadSpriteAsync("shipYardIcon/" .. var0_30[var1_30 + 2], function(arg0_38)
			setImageSprite(arg0_30.shipPaintImg_2, arg0_38)
		end)
	elseif var0_0.BOSS_NUM - var1_30 == 1 then
		setActive(arg0_30.roundTF_1, true)
		setActive(arg0_30.roundTF_2, false)
		setActive(arg0_30.mask_1, true)
		setActive(arg0_30.mask_2, false)
		LoadSpriteAsync("shipYardIcon/" .. var0_30[var1_30 + 1], function(arg0_39)
			setImageSprite(arg0_30.shipPaintImg_1, arg0_39)
		end)

		if arg0_30.curMode == ChallengeProxy.MODE_INFINITE then
			LoadSpriteAsync("shipYardIcon/" .. arg0_30.nextNameList[var1_30 + 2], function(arg0_40)
				setImageSprite(arg0_30.shipPaintImg_2, arg0_40)
				setActive(arg0_30.mask_2, true)
				setActive(arg0_30.roundTF_2, true)
			end)
		end
	else
		setActive(arg0_30.roundTF_1, false)
		setActive(arg0_30.roundTF_2, false)
		setActive(arg0_30.mask_1, false)
		setActive(arg0_30.mask_2, false)

		if arg0_30.curMode == ChallengeProxy.MODE_INFINITE then
			LoadSpriteAsync("shipYardIcon/" .. arg0_30.nextNameList[var1_30 + 1], function(arg0_41)
				setImageSprite(arg0_30.shipPaintImg_1, arg0_41)
				setActive(arg0_30.mask_1, true)
				setActive(arg0_30.roundTF_1, true)
			end)
			LoadSpriteAsync("shipYardIcon/" .. arg0_30.nextNameList[var1_30 + 2], function(arg0_42)
				setImageSprite(arg0_30.shipPaintImg_2, arg0_42)
				setActive(arg0_30.mask_2, true)
				setActive(arg0_30.roundTF_2, true)
			end)
		end
	end

	if var2_30 - 1 - var1_30 >= 2 then
		setActive(arg0_30.tag_1, true)
		setActive(arg0_30.tag_2, true)
	elseif var2_30 - 1 - var1_30 == 1 then
		setActive(arg0_30.tag_1, true)
		setActive(arg0_30.tag_2, false)
	elseif var2_30 - 1 - var1_30 <= 0 then
		setActive(arg0_30.tag_1, false)
		setActive(arg0_30.tag_2, false)
	end
end

function var0_0.updateRoundText(arg0_43, arg1_43)
	local var0_43 = arg1_43 or arg0_43.showingIndex

	if arg0_43.curMode == ChallengeProxy.MODE_CASUAL and var0_43 > ChallengeConst.BOSS_NUM then
		var0_43 = var0_43 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0_43 % ChallengeConst.BOSS_NUM
	end

	setText(arg0_43.roundNumText, string.format("%02d", var0_43))
	setText(arg0_43.roundText_1, "Round" .. var0_43 + 1)
	setText(arg0_43.roundText_2, "Round" .. var0_43 + 2)
end

function var0_0.updateSlider(arg0_44, arg1_44)
	local var0_44 = arg1_44 or arg0_44.showingIndex
	local var1_44 = arg0_44.curLevel

	if var0_44 > ChallengeConst.BOSS_NUM then
		var0_44 = var0_44 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0_44 % ChallengeConst.BOSS_NUM
	end

	if arg0_44.curMode == ChallengeProxy.MODE_INFINITE and var1_44 > ChallengeConst.BOSS_NUM then
		var1_44 = var1_44 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var1_44 % ChallengeConst.BOSS_NUM
	end

	local var2_44 = 1 / (ChallengeConst.BOSS_NUM - 1)
	local var3_44 = (var1_44 - 1) * var2_44

	arg0_44.sliderSC.value = var3_44

	arg0_44.squareList:make(function(arg0_45, arg1_45, arg2_45)
		local var0_45 = arg0_44:findTF("UnFinished", arg2_45)
		local var1_45 = arg0_44:findTF("Finished", arg2_45)
		local var2_45 = arg0_44:findTF("Challengeing", arg2_45)
		local var3_45 = arg0_44:findTF("Arrow", arg2_45)

		local function var4_45()
			setActive(var1_45, true)
			setActive(var0_45, false)
			setActive(var2_45, false)
		end

		local function var5_45()
			setActive(var1_45, false)
			setActive(var0_45, true)
			setActive(var2_45, false)
		end

		local function var6_45()
			setActive(var1_45, false)
			setActive(var0_45, false)
			setActive(var2_45, true)
		end

		if arg0_45 == UIItemList.EventUpdate then
			if arg1_45 + 1 < var1_44 then
				var4_45()
			elseif arg1_45 + 1 == var1_44 then
				var6_45()
			elseif arg1_45 + 1 > var1_44 then
				var5_45()
			end

			if arg1_45 + 1 == var0_44 then
				setActive(var3_45, true)
			else
				setActive(var3_45, false)
			end
		end
	end)
	arg0_44.squareList:align(ChallengeConst.BOSS_NUM)
end

function var0_0.updateGrade(arg0_49, arg1_49)
	setText(arg0_49.seasonBestPointText, arg1_49.seasonMaxScore)
	setText(arg0_49.activityBestPointText, arg1_49.activityMaxScore)
	setText(arg0_49.seasonLevelNumText, arg1_49.seasonMaxLevel)
	setText(arg0_49.activityLevelNumText, arg1_49.activityMaxLevel)
end

function var0_0.updateTimePanel(arg0_50)
	local var0_50 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE).stopTime
	local var1_50 = pg.TimeMgr.GetInstance():STimeDescS(var0_50, "%Y.%m.%d")

	setText(arg0_50.activityTimeText, var1_50)

	local var2_50 = pg.TimeMgr.GetInstance()
	local var3_50 = var2_50:GetNextWeekTime(1, 0, 0, 0) - var2_50:GetServerTime()
	local var4_50, var5_50, var6_50, var7_50 = var2_50:parseTimeFrom(var3_50)

	setText(arg0_50.seasonDayText, var4_50)
	setText(arg0_50.seasonTimeText, string.format("%02d:%02d:%02d", var5_50, var6_50, var7_50))

	if arg0_50.timer then
		arg0_50.timer:Stop()
	end

	arg0_50.timer = Timer.New(function()
		var3_50 = var3_50 - 1

		local var0_51, var1_51, var2_51, var3_51 = pg.TimeMgr.GetInstance():parseTimeFrom(var3_50)

		setText(arg0_50.seasonDayText, var0_51)
		setText(arg0_50.seasonTimeText, string.format("%02d:%02d:%02d", var1_51, var2_51, var3_51))

		if var3_50 <= 0 then
			arg0_50.timeOverTag = true

			arg0_50.timer:Stop()
		end
	end, 1, -1)

	arg0_50.timer:Start()
end

function var0_0.updateSwitchModBtn(arg0_52)
	if not arg0_52:isFinishedCasualMode() then
		setActive(arg0_52.infiniteModBtn, false)
	else
		setActive(arg0_52.infiniteModBtn, true)
	end

	if arg0_52.curMode == ChallengeProxy.MODE_CASUAL then
		setActive(arg0_52.casualModBtnBG, true)
		setActive(arg0_52.infiniteModBtnBG, false)
	else
		setActive(arg0_52.casualModBtnBG, false)
		setActive(arg0_52.infiniteModBtnBG, true)
	end

	onButton(arg0_52, arg0_52.casualModBtn, function()
		if arg0_52.curMode == ChallengeProxy.MODE_CASUAL then
			return
		end

		local var0_53 = arg0_52.curModeInfo and arg0_52.curModeInfo:getLevel() or 0

		local function var1_53()
			arg0_52.challengeProxy:setCurMode(ChallengeProxy.MODE_CASUAL)
			setActive(arg0_52.casualModBtnBG, true)
			setActive(arg0_52.infiniteModBtnBG, false)
			arg0_52:updateData()
			arg0_52:updatePaintingList(arg0_52.nameList, arg0_52.showingIndex)
			arg0_52:updateRoundText(arg0_52.showingIndex)
			arg0_52:updateSlider(arg0_52.showingIndex)
			arg0_52:updateSwitchModBtn()
			arg0_52:updateFuncBtns()
			arg0_52:showTipText()
		end

		if arg0_52:isCrossedSeason() then
			local var2_53 = "challenge_season_update_infinite_switch"
			local var3_53 = var0_53

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n(var2_53, var3_53),
				onYes = function()
					arg0_52:emit(ChallengeConst.RESET_DATA_EVENT, ChallengeProxy.MODE_INFINITE)
				end,
				onNo = var1_53
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("challenge_infinite_click_switch", var0_53),
			onYes = var1_53
		})
	end, SFX_PANEL)
	onButton(arg0_52, arg0_52.infiniteModBtn, function()
		if arg0_52.curMode == ChallengeProxy.MODE_INFINITE then
			return
		end

		local var0_56 = arg0_52.curModeInfo and arg0_52.curModeInfo:getScore() or arg0_52.challengeInfo:getGradeList().seasonMaxScore

		local function var1_56()
			arg0_52.challengeProxy:setCurMode(ChallengeProxy.MODE_INFINITE)
			setActive(arg0_52.casualModBtnBG, false)
			setActive(arg0_52.infiniteModBtnBG, true)
			arg0_52:updateData()
			arg0_52:updatePaintingList(arg0_52.nameList, arg0_52.showingIndex)
			arg0_52:updateRoundText(arg0_52.showingIndex)
			arg0_52:updateSlider(arg0_52.showingIndex)
			arg0_52:updateFuncBtns()
			arg0_52:showTipText()
		end

		if arg0_52:isCrossedSeason() then
			local var2_56 = "challenge_season_update_casual_switch"
			local var3_56 = var0_56

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n(var2_56, var3_56),
				onYes = function()
					arg0_52:emit(ChallengeConst.RESET_DATA_EVENT, ChallengeProxy.MODE_CASUAL)
				end,
				onNo = var1_56
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("challenge_casual_click_switch", var0_56),
			onYes = var1_56
		})
	end, SFX_PANEL)
end

function var0_0.updateResetBtn(arg0_59)
	if arg0_59.userChallengeInfoList[arg0_59.curMode] then
		setActive(arg0_59.resetBtn, true)
		SetActive(arg0_59.resetBtnBanned, false)
	else
		setActive(arg0_59.resetBtn, false)
		SetActive(arg0_59.resetBtnBanned, true)
	end
end

function var0_0.updateStartBtn(arg0_60)
	local var0_60 = arg0_60.userChallengeInfoList[arg0_60.curMode]

	if var0_60 then
		if arg0_60.curMode == ChallengeProxy.MODE_CASUAL and var0_60:getLevel() > ChallengeConst.BOSS_NUM then
			SetActive(arg0_60.startBtn, false)
			SetActive(arg0_60.startBtnBanned, true)
		else
			SetActive(arg0_60.startBtn, true)
			SetActive(arg0_60.startBtnBanned, false)
		end
	else
		SetActive(arg0_60.startBtn, true)
		SetActive(arg0_60.startBtnBanned, false)
	end
end

function var0_0.updateFuncBtns(arg0_61)
	arg0_61:updateResetBtn()
	arg0_61:updateStartBtn()
end

function var0_0.updateAwardPanel(arg0_62)
	local var0_62 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
	local var1_62 = pg.activity_template[var0_62.id].config_data[1]
	local var2_62 = pg.activity_template[var1_62].config_data[1]
	local var3_62 = getProxy(TaskProxy):getTaskById(var2_62) or getProxy(TaskProxy):getFinishTaskById(var2_62)
	local var4_62 = var3_62:getConfig("target_num")
	local var5_62 = arg0_62.challengeInfo:getGradeList().activityMaxScore

	setText(arg0_62.scoreText, var5_62 .. " / " .. var4_62)

	local var6_62 = var3_62:getTaskStatus()

	if var6_62 == 0 then
		setActive(arg0_62.getBtn, false)
		setActive(arg0_62.getBtnBanned, true)
		setActive(arg0_62.gotBtn, false)
	elseif var6_62 == 1 then
		setActive(arg0_62.getBtn, true)
		setActive(arg0_62.getBtnBanned, false)
		setActive(arg0_62.gotBtn, false)
	elseif var6_62 == 2 then
		setActive(arg0_62.getBtn, false)
		setActive(arg0_62.getBtnBanned, false)
		setActive(arg0_62.gotBtn, true)
	end

	local var7_62 = var3_62:getConfig("award_display")[1]
	local var8_62 = {
		type = var7_62[1],
		id = var7_62[2],
		count = var7_62[3]
	}

	updateDrop(arg0_62.itemTF, var8_62)
	onButton(arg0_62, arg0_62.itemTF, function()
		arg0_62:emit(BaseUI.ON_DROP, var8_62)
	end, SFX_PANEL)
	onButton(arg0_62, arg0_62.getBtn, function()
		arg0_62:emit(ChallengeConst.CLICK_GET_AWARD_BTN, var3_62.id)
	end, SFX_PANEL)

	local var9_62
end

function var0_0.showSLResetMsgBox(arg0_65)
	local var0_65 = false
	local var1_65
	local var2_65

	for iter0_65, iter1_65 in pairs(arg0_65.userChallengeInfoList) do
		if iter1_65:getResetFlag() >= ChallengeConst.NEED_TO_RESET_SAVELOAD then
			var0_65 = true
			var1_65 = iter1_65
			var2_65 = iter0_65

			break
		end
	end

	if var0_65 == true then
		local var3_65
		local var4_65

		if var2_65 == ChallengeProxy.MODE_CASUAL then
			var3_65 = "challenge_casual_reset"
			var4_65 = var1_65:getScore()
		elseif var2_65 == ChallengeProxy.MODE_INFINITE then
			var3_65 = "challenge_infinite_reset"
			var4_65 = var1_65:getLevel() - 1
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n(var3_65, var4_65),
			onYes = function()
				arg0_65:emit(ChallengeConst.RESET_DATA_EVENT, var2_65)
			end,
			onNo = function()
				arg0_65:emit(ChallengeConst.RESET_DATA_EVENT, var2_65)
			end
		})
	end
end

function var0_0.showTipText(arg0_68)
	local var0_68
	local var1_68 = arg0_68.curMode == ChallengeProxy.MODE_CASUAL and "challenge_normal_tip" or "challenge_unlimited_tip"

	setText(arg0_68.modTipText, i18n(var1_68))

	local var2_68 = arg0_68.modTipTF:GetComponent(typeof(DftAniEvent))

	if var2_68 then
		var2_68:SetEndEvent(function(arg0_69)
			setActive(arg0_68.modTipText, false)
			setActive(arg0_68.modTipTF, false)
		end)
	end

	setActive(arg0_68.modTipTF, true)
	setActive(arg0_68.modTipText, true)
end

function var0_0.doOnFleetPanel(arg0_70)
	arg0_70.fleetEditPanel:attach(arg0_70)
	arg0_70.fleetEditPanel:setFleets(arg0_70.fleets[arg0_70.curMode])
	arg0_70.fleetEditPanel:set(1, 1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_70.fleetEditPanel._tf)
end

function var0_0.isFinishedCasualMode(arg0_71)
	local var0_71 = false
	local var1_71 = arg0_71.userChallengeInfoList[ChallengeProxy.MODE_INFINITE]
	local var2_71 = arg0_71.userChallengeInfoList[ChallengeProxy.MODE_CASUAL]

	if var1_71 then
		var0_71 = true
	elseif not var1_71 then
		local var3_71 = arg0_71.challengeInfo:getGradeList().seasonMaxLevel

		if var2_71 then
			if var2_71:getSeasonID() == arg0_71.challengeInfo:getSeasonID() then
				if var3_71 >= ChallengeConst.BOSS_NUM then
					var0_71 = true
				else
					var0_71 = false
				end
			else
				var0_71 = false
			end
		elseif var3_71 >= ChallengeConst.BOSS_NUM then
			var0_71 = true
		elseif not var2_71 then
			var0_71 = false
		end
	end

	return var0_71
end

function var0_0.isCrossedSeason(arg0_72)
	local var0_72 = false

	if arg0_72.timeOverTag == true then
		var0_72 = true
	elseif arg0_72.curModeInfo then
		if arg0_72.curModeInfo:getSeasonID() ~= arg0_72.challengeInfo:getSeasonID() then
			var0_72 = true
		end
	else
		var0_72 = false
	end

	return var0_72
end

function var0_0.commitEdit(arg0_73)
	arg0_73:emit(ChallengeMainMediator.ON_COMMIT_FLEET)
end

function var0_0.openShipInfo(arg0_74, arg1_74, arg2_74)
	arg0_74:emit(ChallengeMainMediator.ON_FLEET_SHIPINFO, {
		shipId = arg1_74,
		shipVOs = arg2_74
	})
end

function var0_0.hideFleetEdit(arg0_75)
	setActive(arg0_75.fleetSelect, false)
	arg0_75:closeCommanderPanel()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_75.fleetSelect, arg0_75._tf)
	setParent(arg0_75.fleetSelect, arg0_75._tf, false)
end

function var0_0.updateEditPanel(arg0_76)
	arg0_76.fleetEditPanel:setFleets(arg0_76.fleets[arg0_76.curMode])
	arg0_76.fleetEditPanel:updateFleets()
end

function var0_0.setCommanderPrefabs(arg0_77, arg1_77)
	arg0_77.commanderPrefabs = arg1_77
end

function var0_0.openCommanderPanel(arg0_78, arg1_78, arg2_78)
	local var0_78 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE).id

	arg0_78.levelCMDFormationView:setCallback(function(arg0_79)
		if arg0_79.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_78:emit(ChallengeMainMediator.ON_COMMANDER_SKILL, arg0_79.skill)
		elseif arg0_79.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_78.contextData.eliteCommanderSelected = {
				fleetIndex = arg2_78,
				cmdPos = arg0_79.pos,
				mode = arg0_78.curMode
			}

			arg0_78:emit(ChallengeMainMediator.ON_SELECT_ELITE_COMMANDER, arg2_78, arg0_79.pos)
			arg0_78:closeCommanderPanel()
			arg0_78:hideFleetEdit()
		else
			arg0_78:emit(ChallengeMainMediator.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0_79,
				fleetId = arg1_78.id,
				actId = var0_78
			})
		end
	end)
	arg0_78.levelCMDFormationView:Load()
	arg0_78.levelCMDFormationView:ActionInvoke("update", arg1_78, arg0_78.commanderPrefabs)
	arg0_78.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.closeCommanderPanel(arg0_80)
	if arg0_80.levelCMDFormationView:isShowing() then
		arg0_80.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0_0.updateCommanderFleet(arg0_81, arg1_81)
	if arg0_81.levelCMDFormationView:isShowing() then
		arg0_81.levelCMDFormationView:ActionInvoke("updateFleet", arg1_81)
	end
end

function var0_0.updateCommanderPrefab(arg0_82)
	if arg0_82.levelCMDFormationView:isShowing() then
		arg0_82.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_82.commanderPrefabs)
	end
end

function var0_0.buildCommanderPanel(arg0_83)
	arg0_83.levelCMDFormationView = LevelCMDFormationView.New(arg0_83.fleetSelect, arg0_83.event, arg0_83.contextData)
end

function var0_0.destroyCommanderPanel(arg0_84)
	arg0_84.levelCMDFormationView:Destroy()

	arg0_84.levelCMDFormationView = nil
end

return var0_0

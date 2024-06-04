local var0 = class("ChallengeMainScene", import("..base.BaseUI"))

var0.BOSS_NUM = 5
var0.FADE_TIME = 5

function var0.getUIName(arg0)
	return "ChallengeMainUI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateGrade(arg0.challengeInfo:getGradeList())
	arg0:updateTimePanel()
	arg0:updateSwitchModBtn()
	arg0:updateAwardPanel()
	arg0:updatePaintingList(arg0.nameList, arg0.showingIndex)
	arg0:updateRoundText(arg0.showingIndex)
	arg0:updateSlider(arg0.showingIndex)
	arg0:updateFuncBtns()
	arg0:showSLResetMsgBox()

	if arg0.contextData.editFleet then
		arg0:doOnFleetPanel()

		arg0.contextData.editFleet = nil
	end

	arg0:tryPlayGuide()
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.modTipTF))

	if arg0.timer then
		arg0.timer:Stop()
	end

	arg0:destroyCommanderPanel()
end

function var0.onBackPressed(arg0)
	if isActive(arg0.fleetSelect) then
		arg0:hideFleetEdit()
	else
		triggerButton(arg0.backBtn)
	end
end

function var0.setFleet(arg0, arg1)
	arg0.fleets = {}

	local function var0(arg0)
		arg0.fleets[arg0] = {
			arg1[arg0 + 1],
			[11] = arg1[arg0 + 11]
		}
	end

	var0(ChallengeProxy.MODE_CASUAL)
	var0(ChallengeProxy.MODE_INFINITE)
end

function var0.findUI(arg0)
	arg0.northTF = arg0:findTF("ForNorth")
	arg0.paintingListTF = arg0:findTF("PaintingList")
	arg0.backBtn = arg0:findTF("top/back_button", arg0.northTF)
	arg0.gradeContainer = arg0:findTF("GradeContainer", arg0.northTF)
	arg0.seasonBestPointText = arg0:findTF("SeasonBestPoint/Text", arg0.gradeContainer)
	arg0.activityBestPointText = arg0:findTF("ActivityBestPoint/Text", arg0.gradeContainer)
	arg0.seasonLevelNumText = arg0:findTF("SeasonLevelNum/Text", arg0.gradeContainer)
	arg0.activityLevelNumText = arg0:findTF("ActivityLevelNum/Text", arg0.gradeContainer)
	arg0.timeTipTF = arg0:findTF("TimeTip", arg0.northTF)
	arg0.activityTimeText = arg0:findTF("ActivityTimeText", arg0.timeTipTF)
	arg0.seasonDayText = arg0:findTF("SeasonTipText/DayText", arg0.timeTipTF)
	arg0.seasonTimeText = arg0:findTF("SeasonTimeText", arg0.timeTipTF)
	arg0.switchModTF = arg0:findTF("SwitchMod", arg0.northTF)
	arg0.casualModBtn = arg0:findTF("NormalBtn", arg0.switchModTF)
	arg0.infiniteModBtn = arg0:findTF("EndlessBtn", arg0.switchModTF)
	arg0.casualModBtnBG = arg0:findTF("BG", arg0.casualModBtn)
	arg0.infiniteModBtnBG = arg0:findTF("BG", arg0.infiniteModBtn)
	arg0.casualModBtnSC = GetComponent(arg0.casualModBtn, "Button")
	arg0.infiniteModBtnSC = GetComponent(arg0.infiniteModBtn, "Button")
	arg0.functionBtnsTF = arg0:findTF("FunctionBtns", arg0.northTF)
	arg0.rankBtn = arg0:findTF("RankBtn", arg0.functionBtnsTF)
	arg0.startBtn = arg0:findTF("StartBtn", arg0.functionBtnsTF)
	arg0.resetBtn = arg0:findTF("ResetBtn", arg0.functionBtnsTF)
	arg0.startBtnBanned = arg0:findTF("StartBtnBanned", arg0.functionBtnsTF)
	arg0.resetBtnBanned = arg0:findTF("ResetBtnBanned", arg0.functionBtnsTF)
	arg0.awardTF = arg0:findTF("Award", arg0.northTF)
	arg0.helpBtn = arg0:findTF("HelpBtn", arg0.awardTF)
	arg0.getBtn = arg0:findTF("GetBtn", arg0.awardTF)
	arg0.gotBtn = arg0:findTF("GotBtn", arg0.awardTF)
	arg0.getBtnBanned = arg0:findTF("GetBtnBanned", arg0.awardTF)
	arg0.itemTF = arg0:findTF("ItemBG/item", arg0.awardTF)
	arg0.scoreText = arg0:findTF("Score/ScoreText", arg0.awardTF)
	arg0.slider = arg0:findTF("Slider", arg0.northTF)
	arg0.squareContainer = arg0:findTF("SquareList", arg0.slider)
	arg0.squareTpl = arg0:findTF("Squre", arg0.slider)
	arg0.squareList = UIItemList.New(arg0.squareContainer, arg0.squareTpl)
	arg0.sliderSC = GetComponent(arg0.slider, "Slider")
	arg0.paintingContainer = arg0:findTF("PaintingList")
	arg0.scrollSC = GetComponent(arg0.paintingContainer, "Slider")
	arg0.material = arg0:findTF("material"):GetComponent(typeof(Image)).material
	arg0.material1 = arg0:findTF("material1"):GetComponent(typeof(Image)).material
	arg0.painting = arg0:findTF("Painting", arg0.paintingContainer)
	arg0.paintingShadow1 = arg0:findTF("PaintingShadow1", arg0.painting)
	arg0.paintingShadow2 = arg0:findTF("PaintingShadow2", arg0.painting)
	arg0.bossInfoImg = arg0:findTF("InfoImg", arg0.painting)
	arg0.roundNumText = arg0:findTF("Round/NumText", arg0.painting)
	arg0.completeEffectTF = arg0:findTF("TZ02", arg0.painting)

	SetActive(arg0.completeEffectTF, false)

	arg0.card1TF = arg0:findTF("Card1", arg0.paintingContainer)
	arg0.shipPaintImg_1 = arg0:findTF("Mask/ShipPaint", arg0.card1TF)
	arg0.tag_1 = arg0:findTF("Tag", arg0.card1TF)
	arg0.mask_1 = arg0:findTF("Mask", arg0.card1TF)
	arg0.roundTF_1 = arg0:findTF("Round", arg0.card1TF)
	arg0.roundText_1 = arg0:findTF("Round/RoundText", arg0.card1TF)
	arg0.card2TF = arg0:findTF("Card2", arg0.paintingContainer)
	arg0.shipPaintImg_2 = arg0:findTF("Mask/ShipPaint", arg0.card2TF)
	arg0.tag_2 = arg0:findTF("Tag", arg0.card2TF)
	arg0.mask_2 = arg0:findTF("Mask", arg0.card2TF)
	arg0.roundTF_2 = arg0:findTF("Round", arg0.card2TF)
	arg0.roundText_2 = arg0:findTF("Round/RoundText", arg0.card2TF)
	arg0.modTipBtn = arg0:findTF("ModTipBtn", arg0.northTF)
	arg0.modTipTF = arg0:findTF("TipText", arg0.northTF)
	arg0.modTipText = arg0:findTF("Text", arg0.modTipTF)

	setActive(arg0.modTipTF, false)

	arg0.fleetSelect = arg0:findTF("LevelFleetSelectView")
	arg0.fleetEditPanel = ActivityFleetPanel.New(arg0.fleetSelect.gameObject)

	function arg0.fleetEditPanel.onCancel()
		arg0:hideFleetEdit()
	end

	function arg0.fleetEditPanel.onCommit()
		arg0:commitEdit()
	end

	function arg0.fleetEditPanel.onCombat()
		arg0:commitEdit()
		arg0:emit(ChallengeMainMediator.ON_PRECOMBAT, arg0.curMode)
	end

	function arg0.fleetEditPanel.onLongPressShip(arg0, arg1)
		arg0:openShipInfo(arg0, arg1)
	end

	arg0:buildCommanderPanel()
end

function var0.tryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():Play(arg0)
end

function var0.initData(arg0)
	arg0.challengeProxy = getProxy(ChallengeProxy)
	arg0.challengeInfo = arg0.challengeProxy:getChallengeInfo()
	arg0.userChallengeInfoList = arg0.challengeProxy:getUserChallengeInfoList()
	arg0.timeOverTag = false

	arg0:updateData()

	arg0.openedCommanerSystem = true
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.challenge_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.rankBtn, function()
		arg0:emit(ChallengeMainMediator.ON_OPEN_RANK)
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
			triggerButton(arg0.backBtn)

			return
		end

		if arg0:isCrossedSeason() == true then
			local var1 = arg0.challengeProxy:getCurMode()

			if not arg0.curModeInfo then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("challenge_season_update"),
					onYes = function()
						arg0:emit(ChallengeConst.RESET_DATA_EVENT, var1)
					end,
					onNo = function()
						arg0:emit(ChallengeConst.RESET_DATA_EVENT, var1)
					end
				})

				return
			else
				local var2 = var1 == ChallengeProxy.MODE_CASUAL and "challenge_season_update_casual_clear" or "challenge_season_update_infinite_clear"
				local var3 = var1 == ChallengeProxy.MODE_CASUAL and arg0.curModeInfo:getScore() or arg0.curModeInfo:getLevel()

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = false,
					content = i18n(var2, var3),
					onNo = function()
						arg0:emit(ChallengeConst.RESET_DATA_EVENT, var1)
					end,
					onYes = function()
						arg0:emit(ChallengeMainMediator.ON_PRECOMBAT, arg0.curMode)
					end
				})

				return
			end
		end

		if not arg0.curModeInfo then
			arg0:doOnFleetPanel()

			return
		end

		arg0:emit(ChallengeMainMediator.ON_PRECOMBAT, arg0.curMode)
	end, SFX_PANEL)
	onButton(arg0, arg0.resetBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("challenge_normal_reset"),
			onYes = function()
				arg0:emit(ChallengeConst.RESET_DATA_EVENT, arg0.challengeProxy:getCurMode())
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.modTipBtn, function()
		arg0:showTipText()
	end)

	local function var0()
		if arg0.showingIndex % ChallengeConst.BOSS_NUM == 1 then
			return
		end

		arg0.showingIndex = arg0.showingIndex - 1

		arg0:updatePaintingList(arg0.nameList, arg0.showingIndex)
		arg0:updateRoundText(arg0.showingIndex)
		arg0:updateSlider(arg0.showingIndex)
	end

	local function var1()
		if arg0.showingIndex % ChallengeConst.BOSS_NUM == 0 then
			return
		end

		arg0.showingIndex = arg0.showingIndex + 1

		arg0:updatePaintingList(arg0.nameList, arg0.showingIndex)
		arg0:updateRoundText(arg0.showingIndex)
		arg0:updateSlider(arg0.showingIndex)
	end

	addSlip(SLIP_TYPE_HRZ, arg0.paintingContainer, var0, var1)
end

function var0.updateData(arg0)
	arg0.curMode = arg0.challengeProxy:getCurMode()
	arg0.curModeInfo = arg0.userChallengeInfoList[arg0.curMode]
	arg0.timeOverTag = false

	if not arg0.curModeInfo then
		arg0.curLevel = 1
		arg0.showingIndex = arg0.curLevel

		if arg0.curMode == ChallengeProxy.MODE_CASUAL then
			arg0.dungeonIDList = arg0.challengeInfo:getDungeonIDList()
		elseif arg0.curMode == ChallengeProxy.MODE_INFINITE then
			local var0 = arg0.challengeInfo:getSeasonID()
			local var1 = arg0.challengeInfo:getActivityIndex()

			arg0.dungeonIDList = pg.activity_event_challenge[var1].infinite_stage[var0][1]
		end
	else
		arg0.curLevel = arg0.curModeInfo:getLevel()
		arg0.showingIndex = arg0.curLevel
		arg0.dungeonIDList = arg0.curModeInfo:getDungeonIDList()

		print("self.dungeonIDList", tostring(arg0.dungeonIDList))
	end

	arg0.nameList = {}

	print("创建nameList", tostring(arg0.nameList), tostring(arg0.dungeonIDList), tostring(#arg0.dungeonIDList))

	arg0.infoNameList = {}

	for iter0, iter1 in ipairs(arg0.dungeonIDList) do
		local var2 = pg.expedition_challenge_template[iter1].char_icon[1]

		arg0.nameList[iter0] = var2

		print("self.nameList", tostring(var2))

		local var3 = pg.expedition_challenge_template[iter1].name_p

		arg0.infoNameList[iter0] = var3
	end

	arg0.nextNameList = {}

	if arg0.curMode == ChallengeProxy.MODE_INFINITE then
		local var4

		if arg0.curModeInfo then
			var4 = arg0.curModeInfo:getNextInfiniteDungeonIDList()
		else
			local var5 = arg0.challengeInfo:getSeasonID()
			local var6 = arg0.challengeInfo:getActivityIndex()

			if pg.activity_event_challenge[var6].infinite_stage[var5][2] then
				var4 = pg.activity_event_challenge[var6].infinite_stage[var5][2]
			else
				var4 = pg.activity_event_challenge[var6].infinite_stage[var5][1]
			end
		end

		for iter2, iter3 in ipairs(var4) do
			local var7 = pg.expedition_challenge_template[iter3].char_icon[1]

			arg0.nextNameList[iter2 + ChallengeConst.BOSS_NUM] = var7
		end
	end
end

function var0.updatePaintingList(arg0, arg1, arg2)
	local var0 = arg1 or arg0.nameList
	local var1 = arg2 or arg0.showingIndex
	local var2 = arg0.curLevel

	if var1 > ChallengeConst.BOSS_NUM then
		var1 = var1 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var1 % ChallengeConst.BOSS_NUM
	end

	if arg0.curMode == ChallengeProxy.MODE_INFINITE and var2 > ChallengeConst.BOSS_NUM then
		var2 = var2 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var2 % ChallengeConst.BOSS_NUM
	end

	local function var3(arg0)
		arg0.material:SetFloat("_LineGray", 0.3)
		arg0.material:SetFloat("_TearDistance", 0)
		LeanTween.cancel(arg0.gameObject)
		LeanTween.value(arg0.gameObject, 0, 2, 2):setLoopClamp():setOnUpdate(System.Action_float(function(arg0)
			if arg0 >= 1.2 then
				arg0.material:SetFloat("_LineGray", 0.3)
			elseif arg0 >= 1.1 then
				arg0.material:SetFloat("_LineGray", 0.45)
			elseif arg0 >= 1.03 then
				arg0.material:SetFloat("_TearDistance", 0)
			elseif arg0 >= 1 then
				arg0.material:SetFloat("_TearDistance", 0.3)
			elseif arg0 >= 0.35 then
				arg0.material:SetFloat("_LineGray", 0.3)
			elseif arg0 >= 0.3 then
				arg0.material:SetFloat("_LineGray", 0.4)
			elseif arg0 >= 0.25 then
				arg0.material:SetFloat("_LineGray", 0.3)
			elseif arg0 >= 0.2 then
				arg0.material:SetFloat("_LineGray", 0.4)
			end
		end))
	end

	setPaintingPrefabAsync(arg0.painting, var0[var1], "chuanwu", function()
		local var0 = arg0:findTF("fitter", arg0.painting):GetChild(0)

		if var0 then
			local var1 = GetComponent(var0, "MeshImage")
			local var2 = var2 - 1 - var1 >= 0

			SetActive(arg0.completeEffectTF, var2)

			if var2 then
				var1.material = arg0.material1

				var1.material:SetFloat("_LineDensity", 7)
				var3(var1)
			else
				var1.material = arg0.material

				var1.material:SetFloat("_Range", 16)
				var1.material:SetFloat("_Degree", 7)
			end
		end
	end)
	setPaintingPrefabAsync(arg0.paintingShadow1, var0[var1], "chuanwu", function()
		local var0 = arg0:findTF("fitter", arg0.paintingShadow1):GetChild(0)

		if var0 then
			var0:GetComponent("Image").color = Color.New(0, 0, 0, 0.44)
		end
	end)
	setPaintingPrefabAsync(arg0.paintingShadow2, var0[var1], "chuanwu", function()
		local var0 = arg0:findTF("fitter", arg0.paintingShadow2):GetChild(0)

		if var0 then
			var0:GetComponent("Image").color = Color.New(1, 1, 1, 0.15)
		end
	end)
	LoadSpriteAsync("ChallengeBossInfo/" .. arg0.infoNameList[var1], function(arg0)
		setImageSprite(arg0.bossInfoImg, arg0, true)
	end)

	if var0.BOSS_NUM - var1 >= 2 then
		setActive(arg0.roundTF_1, true)
		setActive(arg0.roundTF_2, true)
		setActive(arg0.mask_1, true)
		setActive(arg0.mask_2, true)
		LoadSpriteAsync("shipYardIcon/" .. var0[var1 + 1], function(arg0)
			setImageSprite(arg0.shipPaintImg_1, arg0)
		end)
		LoadSpriteAsync("shipYardIcon/" .. var0[var1 + 2], function(arg0)
			setImageSprite(arg0.shipPaintImg_2, arg0)
		end)
	elseif var0.BOSS_NUM - var1 == 1 then
		setActive(arg0.roundTF_1, true)
		setActive(arg0.roundTF_2, false)
		setActive(arg0.mask_1, true)
		setActive(arg0.mask_2, false)
		LoadSpriteAsync("shipYardIcon/" .. var0[var1 + 1], function(arg0)
			setImageSprite(arg0.shipPaintImg_1, arg0)
		end)

		if arg0.curMode == ChallengeProxy.MODE_INFINITE then
			LoadSpriteAsync("shipYardIcon/" .. arg0.nextNameList[var1 + 2], function(arg0)
				setImageSprite(arg0.shipPaintImg_2, arg0)
				setActive(arg0.mask_2, true)
				setActive(arg0.roundTF_2, true)
			end)
		end
	else
		setActive(arg0.roundTF_1, false)
		setActive(arg0.roundTF_2, false)
		setActive(arg0.mask_1, false)
		setActive(arg0.mask_2, false)

		if arg0.curMode == ChallengeProxy.MODE_INFINITE then
			LoadSpriteAsync("shipYardIcon/" .. arg0.nextNameList[var1 + 1], function(arg0)
				setImageSprite(arg0.shipPaintImg_1, arg0)
				setActive(arg0.mask_1, true)
				setActive(arg0.roundTF_1, true)
			end)
			LoadSpriteAsync("shipYardIcon/" .. arg0.nextNameList[var1 + 2], function(arg0)
				setImageSprite(arg0.shipPaintImg_2, arg0)
				setActive(arg0.mask_2, true)
				setActive(arg0.roundTF_2, true)
			end)
		end
	end

	if var2 - 1 - var1 >= 2 then
		setActive(arg0.tag_1, true)
		setActive(arg0.tag_2, true)
	elseif var2 - 1 - var1 == 1 then
		setActive(arg0.tag_1, true)
		setActive(arg0.tag_2, false)
	elseif var2 - 1 - var1 <= 0 then
		setActive(arg0.tag_1, false)
		setActive(arg0.tag_2, false)
	end
end

function var0.updateRoundText(arg0, arg1)
	local var0 = arg1 or arg0.showingIndex

	if arg0.curMode == ChallengeProxy.MODE_CASUAL and var0 > ChallengeConst.BOSS_NUM then
		var0 = var0 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0 % ChallengeConst.BOSS_NUM
	end

	setText(arg0.roundNumText, string.format("%02d", var0))
	setText(arg0.roundText_1, "Round" .. var0 + 1)
	setText(arg0.roundText_2, "Round" .. var0 + 2)
end

function var0.updateSlider(arg0, arg1)
	local var0 = arg1 or arg0.showingIndex
	local var1 = arg0.curLevel

	if var0 > ChallengeConst.BOSS_NUM then
		var0 = var0 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0 % ChallengeConst.BOSS_NUM
	end

	if arg0.curMode == ChallengeProxy.MODE_INFINITE and var1 > ChallengeConst.BOSS_NUM then
		var1 = var1 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var1 % ChallengeConst.BOSS_NUM
	end

	local var2 = 1 / (ChallengeConst.BOSS_NUM - 1)
	local var3 = (var1 - 1) * var2

	arg0.sliderSC.value = var3

	arg0.squareList:make(function(arg0, arg1, arg2)
		local var0 = arg0:findTF("UnFinished", arg2)
		local var1 = arg0:findTF("Finished", arg2)
		local var2 = arg0:findTF("Challengeing", arg2)
		local var3 = arg0:findTF("Arrow", arg2)

		local function var4()
			setActive(var1, true)
			setActive(var0, false)
			setActive(var2, false)
		end

		local function var5()
			setActive(var1, false)
			setActive(var0, true)
			setActive(var2, false)
		end

		local function var6()
			setActive(var1, false)
			setActive(var0, false)
			setActive(var2, true)
		end

		if arg0 == UIItemList.EventUpdate then
			if arg1 + 1 < var1 then
				var4()
			elseif arg1 + 1 == var1 then
				var6()
			elseif arg1 + 1 > var1 then
				var5()
			end

			if arg1 + 1 == var0 then
				setActive(var3, true)
			else
				setActive(var3, false)
			end
		end
	end)
	arg0.squareList:align(ChallengeConst.BOSS_NUM)
end

function var0.updateGrade(arg0, arg1)
	setText(arg0.seasonBestPointText, arg1.seasonMaxScore)
	setText(arg0.activityBestPointText, arg1.activityMaxScore)
	setText(arg0.seasonLevelNumText, arg1.seasonMaxLevel)
	setText(arg0.activityLevelNumText, arg1.activityMaxLevel)
end

function var0.updateTimePanel(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE).stopTime
	local var1 = pg.TimeMgr.GetInstance():STimeDescS(var0, "%Y.%m.%d")

	setText(arg0.activityTimeText, var1)

	local var2 = pg.TimeMgr.GetInstance()
	local var3 = var2:GetNextWeekTime(1, 0, 0, 0) - var2:GetServerTime()
	local var4, var5, var6, var7 = var2:parseTimeFrom(var3)

	setText(arg0.seasonDayText, var4)
	setText(arg0.seasonTimeText, string.format("%02d:%02d:%02d", var5, var6, var7))

	if arg0.timer then
		arg0.timer:Stop()
	end

	arg0.timer = Timer.New(function()
		var3 = var3 - 1

		local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(var3)

		setText(arg0.seasonDayText, var0)
		setText(arg0.seasonTimeText, string.format("%02d:%02d:%02d", var1, var2, var3))

		if var3 <= 0 then
			arg0.timeOverTag = true

			arg0.timer:Stop()
		end
	end, 1, -1)

	arg0.timer:Start()
end

function var0.updateSwitchModBtn(arg0)
	if not arg0:isFinishedCasualMode() then
		setActive(arg0.infiniteModBtn, false)
	else
		setActive(arg0.infiniteModBtn, true)
	end

	if arg0.curMode == ChallengeProxy.MODE_CASUAL then
		setActive(arg0.casualModBtnBG, true)
		setActive(arg0.infiniteModBtnBG, false)
	else
		setActive(arg0.casualModBtnBG, false)
		setActive(arg0.infiniteModBtnBG, true)
	end

	onButton(arg0, arg0.casualModBtn, function()
		if arg0.curMode == ChallengeProxy.MODE_CASUAL then
			return
		end

		local var0 = arg0.curModeInfo and arg0.curModeInfo:getLevel() or 0

		local function var1()
			arg0.challengeProxy:setCurMode(ChallengeProxy.MODE_CASUAL)
			setActive(arg0.casualModBtnBG, true)
			setActive(arg0.infiniteModBtnBG, false)
			arg0:updateData()
			arg0:updatePaintingList(arg0.nameList, arg0.showingIndex)
			arg0:updateRoundText(arg0.showingIndex)
			arg0:updateSlider(arg0.showingIndex)
			arg0:updateSwitchModBtn()
			arg0:updateFuncBtns()
			arg0:showTipText()
		end

		if arg0:isCrossedSeason() then
			local var2 = "challenge_season_update_infinite_switch"
			local var3 = var0

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n(var2, var3),
				onYes = function()
					arg0:emit(ChallengeConst.RESET_DATA_EVENT, ChallengeProxy.MODE_INFINITE)
				end,
				onNo = var1
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("challenge_infinite_click_switch", var0),
			onYes = var1
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.infiniteModBtn, function()
		if arg0.curMode == ChallengeProxy.MODE_INFINITE then
			return
		end

		local var0 = arg0.curModeInfo and arg0.curModeInfo:getScore() or arg0.challengeInfo:getGradeList().seasonMaxScore

		local function var1()
			arg0.challengeProxy:setCurMode(ChallengeProxy.MODE_INFINITE)
			setActive(arg0.casualModBtnBG, false)
			setActive(arg0.infiniteModBtnBG, true)
			arg0:updateData()
			arg0:updatePaintingList(arg0.nameList, arg0.showingIndex)
			arg0:updateRoundText(arg0.showingIndex)
			arg0:updateSlider(arg0.showingIndex)
			arg0:updateFuncBtns()
			arg0:showTipText()
		end

		if arg0:isCrossedSeason() then
			local var2 = "challenge_season_update_casual_switch"
			local var3 = var0

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n(var2, var3),
				onYes = function()
					arg0:emit(ChallengeConst.RESET_DATA_EVENT, ChallengeProxy.MODE_CASUAL)
				end,
				onNo = var1
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("challenge_casual_click_switch", var0),
			onYes = var1
		})
	end, SFX_PANEL)
end

function var0.updateResetBtn(arg0)
	if arg0.userChallengeInfoList[arg0.curMode] then
		setActive(arg0.resetBtn, true)
		SetActive(arg0.resetBtnBanned, false)
	else
		setActive(arg0.resetBtn, false)
		SetActive(arg0.resetBtnBanned, true)
	end
end

function var0.updateStartBtn(arg0)
	local var0 = arg0.userChallengeInfoList[arg0.curMode]

	if var0 then
		if arg0.curMode == ChallengeProxy.MODE_CASUAL and var0:getLevel() > ChallengeConst.BOSS_NUM then
			SetActive(arg0.startBtn, false)
			SetActive(arg0.startBtnBanned, true)
		else
			SetActive(arg0.startBtn, true)
			SetActive(arg0.startBtnBanned, false)
		end
	else
		SetActive(arg0.startBtn, true)
		SetActive(arg0.startBtnBanned, false)
	end
end

function var0.updateFuncBtns(arg0)
	arg0:updateResetBtn()
	arg0:updateStartBtn()
end

function var0.updateAwardPanel(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
	local var1 = pg.activity_template[var0.id].config_data[1]
	local var2 = pg.activity_template[var1].config_data[1]
	local var3 = getProxy(TaskProxy):getTaskById(var2) or getProxy(TaskProxy):getFinishTaskById(var2)
	local var4 = var3:getConfig("target_num")
	local var5 = arg0.challengeInfo:getGradeList().activityMaxScore

	setText(arg0.scoreText, var5 .. " / " .. var4)

	local var6 = var3:getTaskStatus()

	if var6 == 0 then
		setActive(arg0.getBtn, false)
		setActive(arg0.getBtnBanned, true)
		setActive(arg0.gotBtn, false)
	elseif var6 == 1 then
		setActive(arg0.getBtn, true)
		setActive(arg0.getBtnBanned, false)
		setActive(arg0.gotBtn, false)
	elseif var6 == 2 then
		setActive(arg0.getBtn, false)
		setActive(arg0.getBtnBanned, false)
		setActive(arg0.gotBtn, true)
	end

	local var7 = var3:getConfig("award_display")[1]
	local var8 = {
		type = var7[1],
		id = var7[2],
		count = var7[3]
	}

	updateDrop(arg0.itemTF, var8)
	onButton(arg0, arg0.itemTF, function()
		arg0:emit(BaseUI.ON_DROP, var8)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ChallengeConst.CLICK_GET_AWARD_BTN, var3.id)
	end, SFX_PANEL)

	local var9
end

function var0.showSLResetMsgBox(arg0)
	local var0 = false
	local var1
	local var2

	for iter0, iter1 in pairs(arg0.userChallengeInfoList) do
		if iter1:getResetFlag() >= ChallengeConst.NEED_TO_RESET_SAVELOAD then
			var0 = true
			var1 = iter1
			var2 = iter0

			break
		end
	end

	if var0 == true then
		local var3
		local var4

		if var2 == ChallengeProxy.MODE_CASUAL then
			var3 = "challenge_casual_reset"
			var4 = var1:getScore()
		elseif var2 == ChallengeProxy.MODE_INFINITE then
			var3 = "challenge_infinite_reset"
			var4 = var1:getLevel() - 1
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n(var3, var4),
			onYes = function()
				arg0:emit(ChallengeConst.RESET_DATA_EVENT, var2)
			end,
			onNo = function()
				arg0:emit(ChallengeConst.RESET_DATA_EVENT, var2)
			end
		})
	end
end

function var0.showTipText(arg0)
	local var0
	local var1 = arg0.curMode == ChallengeProxy.MODE_CASUAL and "challenge_normal_tip" or "challenge_unlimited_tip"

	setText(arg0.modTipText, i18n(var1))

	local var2 = arg0.modTipTF:GetComponent(typeof(DftAniEvent))

	if var2 then
		var2:SetEndEvent(function(arg0)
			setActive(arg0.modTipText, false)
			setActive(arg0.modTipTF, false)
		end)
	end

	setActive(arg0.modTipTF, true)
	setActive(arg0.modTipText, true)
end

function var0.doOnFleetPanel(arg0)
	arg0.fleetEditPanel:attach(arg0)
	arg0.fleetEditPanel:setFleets(arg0.fleets[arg0.curMode])
	arg0.fleetEditPanel:set(1, 1)
	pg.UIMgr.GetInstance():BlurPanel(arg0.fleetEditPanel._tf)
end

function var0.isFinishedCasualMode(arg0)
	local var0 = false
	local var1 = arg0.userChallengeInfoList[ChallengeProxy.MODE_INFINITE]
	local var2 = arg0.userChallengeInfoList[ChallengeProxy.MODE_CASUAL]

	if var1 then
		var0 = true
	elseif not var1 then
		local var3 = arg0.challengeInfo:getGradeList().seasonMaxLevel

		if var2 then
			if var2:getSeasonID() == arg0.challengeInfo:getSeasonID() then
				if var3 >= ChallengeConst.BOSS_NUM then
					var0 = true
				else
					var0 = false
				end
			else
				var0 = false
			end
		elseif var3 >= ChallengeConst.BOSS_NUM then
			var0 = true
		elseif not var2 then
			var0 = false
		end
	end

	return var0
end

function var0.isCrossedSeason(arg0)
	local var0 = false

	if arg0.timeOverTag == true then
		var0 = true
	elseif arg0.curModeInfo then
		if arg0.curModeInfo:getSeasonID() ~= arg0.challengeInfo:getSeasonID() then
			var0 = true
		end
	else
		var0 = false
	end

	return var0
end

function var0.commitEdit(arg0)
	arg0:emit(ChallengeMainMediator.ON_COMMIT_FLEET)
end

function var0.openShipInfo(arg0, arg1, arg2)
	arg0:emit(ChallengeMainMediator.ON_FLEET_SHIPINFO, {
		shipId = arg1,
		shipVOs = arg2
	})
end

function var0.hideFleetEdit(arg0)
	setActive(arg0.fleetSelect, false)
	arg0:closeCommanderPanel()
	pg.UIMgr.GetInstance():UnblurPanel(arg0.fleetSelect, arg0._tf)
	setParent(arg0.fleetSelect, arg0._tf, false)
end

function var0.updateEditPanel(arg0)
	arg0.fleetEditPanel:setFleets(arg0.fleets[arg0.curMode])
	arg0.fleetEditPanel:updateFleets()
end

function var0.setCommanderPrefabs(arg0, arg1)
	arg0.commanderPrefabs = arg1
end

function var0.openCommanderPanel(arg0, arg1, arg2)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE).id

	arg0.levelCMDFormationView:setCallback(function(arg0)
		if arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0:emit(ChallengeMainMediator.ON_COMMANDER_SKILL, arg0.skill)
		elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0.contextData.eliteCommanderSelected = {
				fleetIndex = arg2,
				cmdPos = arg0.pos,
				mode = arg0.curMode
			}

			arg0:emit(ChallengeMainMediator.ON_SELECT_ELITE_COMMANDER, arg2, arg0.pos)
			arg0:closeCommanderPanel()
			arg0:hideFleetEdit()
		else
			arg0:emit(ChallengeMainMediator.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0,
				fleetId = arg1.id,
				actId = var0
			})
		end
	end)
	arg0.levelCMDFormationView:Load()
	arg0.levelCMDFormationView:ActionInvoke("update", arg1, arg0.commanderPrefabs)
	arg0.levelCMDFormationView:ActionInvoke("Show")
end

function var0.closeCommanderPanel(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0.updateCommanderFleet(arg0, arg1)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updateFleet", arg1)
	end
end

function var0.updateCommanderPrefab(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0.commanderPrefabs)
	end
end

function var0.buildCommanderPanel(arg0)
	arg0.levelCMDFormationView = LevelCMDFormationView.New(arg0.fleetSelect, arg0.event, arg0.contextData)
end

function var0.destroyCommanderPanel(arg0)
	arg0.levelCMDFormationView:Destroy()

	arg0.levelCMDFormationView = nil
end

return var0

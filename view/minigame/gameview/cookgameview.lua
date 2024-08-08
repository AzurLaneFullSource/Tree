local var0_0 = class("CookGameView", import("..BaseMiniGameView"))
local var1_0 = "bar-soft"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/break_out_full"
local var4_0 = 60
local var5_0 = "cookgameui_atlas"
local var6_0 = 0.1
local var7_0 = 8
local var8_0 = {
	time_up = 0.5,
	cake_num = 5,
	extend_time = 10,
	char_path = "ui/minigameui/",
	speed_num = 3,
	path = "ui/minigameui/" .. var5_0
}

var0_0.CLICK_JUDGE_EVENT = "click judge event"
var0_0.AC_CAKE_EVENT = "ac cake event"
var0_0.SERVE_EVENT = "serve event"
var0_0.EXTEND_EVENT = "extend event"

function var0_0.getUIName(arg0_1)
	return "CookGameUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2:initEvent()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:initGameUI()
	arg0_2:initController()
	arg0_2:updateMenuUI()
	arg0_2:openMenuUI()
end

function var0_0.initEvent(arg0_3)
	if not arg0_3.uiCam then
		arg0_3.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0_3:bind(CookGameView.CLICK_JUDGE_EVENT, function(arg0_4, arg1_4, arg2_4)
		if arg0_3.charController then
			arg0_3.charController:setJudgeAction(arg1_4, nil, arg2_4)
		end
	end)
	arg0_3:bind(CookGameView.AC_CAKE_EVENT, function(arg0_5, arg1_5, arg2_5)
		if arg0_3.charController then
			arg0_3.charController:createAcCake(arg1_5, arg2_5)
		end
	end)
	arg0_3:bind(CookGameView.SERVE_EVENT, function(arg0_6, arg1_6, arg2_6)
		local var0_6 = arg1_6.serveData.battleData.id
		local var1_6 = arg1_6.right
		local var2_6 = arg1_6.pos
		local var3_6 = arg1_6.rate
		local var4_6 = arg1_6.weight
		local var5_6 = var1_6 and 1 or -1
		local var6_6 = var1_6 and 1 or 0
		local var7_6 = arg1_6.serveData.parameter.right_index
		local var8_6
		local var9_6 = var0_6 ~= var8_0.playerChar and var0_6 ~= var8_0.partnerChar and var0_6 ~= var8_0.partnerPet

		if not arg1_6.serveData.battleData.weight then
			local var10_6 = 0
		end

		if var1_6 and arg1_6.serveData.battleData.cake_allow then
			var6_6 = 3
		end

		if var1_6 and arg1_6.serveData.battleData.score_added then
			var5_6 = var5_6 + arg1_6.serveData.parameter.series_right_index - 1
		end

		if arg1_6.serveData.battleData.random_score then
			var5_6 = var5_6 * math.random(1, CookGameConst.random_score)
		end

		local var11_6 = var5_6 * var3_6

		arg0_3:addScore(var11_6, var9_6)
		arg0_3:showScore(var11_6, var2_6, var6_6)

		if arg1_6.serveData.battleData.double_score == 8 then
			if var1_6 and var7_6 and var7_6 % 2 == 0 then
				arg0_3:addScore(var11_6, var9_6)
				LeanTween.delayedCall(go(arg0_3._tf), 0.5, System.Action(function()
					arg0_3:showScore(var11_6, var2_6, 2)
				end))
			end
		elseif arg1_6.serveData.battleData.half_double and var1_6 and math.random() > 0.5 then
			arg0_3:addScore(var11_6, var9_6)
			LeanTween.delayedCall(go(arg0_3._tf), 0.5, System.Action(function()
				arg0_3:showScore(var11_6, var2_6, 2)
			end))
		end
	end)
	arg0_3:bind(CookGameView.EXTEND_EVENT, function(arg0_9, arg1_9, arg2_9)
		if arg0_3.judgesController then
			arg0_3.judgesController:extend()
		end

		arg0_3.waitingExtendTime = false
		arg0_3.extendTime = var8_0.extend_time
		arg0_3.gameTime = 0
	end)
end

function var0_0.showScore(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg1_10 == 0 then
		return
	end

	local var0_10

	if #arg0_10.showScoresPool > 0 then
		var0_10 = table.remove(arg0_10.showScoresPool, 1)
	else
		var0_10 = tf(Instantiate(arg0_10.showScoreTpl))

		setParent(var0_10, arg0_10.sceneFrontContainer)
		GetComponent(findTF(var0_10, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			for iter0_11 = #arg0_10.showScores, 1, -1 do
				if var0_10 == arg0_10.showScores[iter0_11] then
					setActive(var0_10, false)
					table.insert(arg0_10.showScoresPool, table.remove(arg0_10.showScores, iter0_11))
				end
			end
		end)
	end

	var0_10.anchoredPosition = arg0_10.sceneFrontContainer:InverseTransformPoint(arg2_10)

	setText(findTF(var0_10, "anim/text_sub"), "" .. tostring(arg1_10))
	setText(findTF(var0_10, "anim/text_add"), "+" .. tostring(arg1_10))

	if arg1_10 > 0 then
		setActive(findTF(var0_10, "anim/text_sub"), false)
		setActive(findTF(var0_10, "anim/text_add"), true)
	else
		setActive(findTF(var0_10, "anim/text_sub"), true)
		setActive(findTF(var0_10, "anim/text_add"), false)
	end

	setActive(var0_10, false)
	setActive(var0_10, true)
	table.insert(arg0_10.showScores, var0_10)
end

function var0_0.onEventHandle(arg0_12, arg1_12)
	return
end

function var0_0.initData(arg0_13)
	local var0_13 = Application.targetFrameRate or 60

	if var0_13 > 60 then
		var0_13 = 60
	end

	arg0_13.timer = Timer.New(function()
		arg0_13:onTimer()
	end, 1 / var0_13, -1)
	arg0_13.showScores = {}
	arg0_13.showScoresPool = {}
	arg0_13.dropData = pg.mini_game[arg0_13:GetMGData().id].simple_config_data.drop_ids
	var8_0.playerChar = nil
	var8_0.partnerChar = nil
	var8_0.partnerPet = nil
	var8_0.enemy1Char = nil
	var8_0.enemy2Char = nil
	var8_0.enemyPet = nil
	arg0_13.selectPlayer = true
	arg0_13.selectPartner = false
end

function var0_0.initUI(arg0_15)
	arg0_15.backSceneTf = findTF(arg0_15._tf, "scene_background")
	arg0_15.sceneContainer = findTF(arg0_15._tf, "sceneMask/sceneContainer")
	arg0_15.sceneFrontContainer = findTF(arg0_15._tf, "sceneMask/sceneContainer/scene_front")
	arg0_15.clickMask = findTF(arg0_15._tf, "clickMask")
	arg0_15.bg = findTF(arg0_15._tf, "bg")
	arg0_15.countUI = findTF(arg0_15._tf, "pop/CountUI")
	arg0_15.countAnimator = GetComponent(findTF(arg0_15.countUI, "count"), typeof(Animator))
	arg0_15.countDft = GetOrAddComponent(findTF(arg0_15.countUI, "count"), typeof(DftAniEvent))

	arg0_15.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_15.countDft:SetEndEvent(function()
		setActive(arg0_15.countUI, false)
		arg0_15:gameStart()
	end)

	arg0_15.leaveUI = findTF(arg0_15._tf, "pop/LeaveUI")

	onButton(arg0_15, findTF(arg0_15.leaveUI, "ad/btnOk"), function()
		arg0_15:resumeGame()
		arg0_15:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_15, findTF(arg0_15.leaveUI, "ad/btnCancel"), function()
		arg0_15:resumeGame()
	end, SFX_CANCEL)
	setActive(arg0_15.leaveUI, false)

	arg0_15.pauseUI = findTF(arg0_15._tf, "pop/pauseUI")

	onButton(arg0_15, findTF(arg0_15.pauseUI, "ad/btnOk"), function()
		setActive(arg0_15.pauseUI, false)
		arg0_15:resumeGame()
	end, SFX_CANCEL)

	arg0_15.settlementUI = findTF(arg0_15._tf, "pop/SettleMentUI")

	onButton(arg0_15, findTF(arg0_15.settlementUI, "ad/btnOver"), function()
		setActive(arg0_15.settlementUI, false)
		arg0_15:openMenuUI()
	end, SFX_CANCEL)
	setActive(arg0_15.settlementUI, false)

	arg0_15.menuUI = findTF(arg0_15._tf, "pop/menuUI")
	arg0_15.battleScrollRect = GetComponent(findTF(arg0_15.menuUI, "battList"), typeof(ScrollRect))
	arg0_15.totalTimes = arg0_15:getGameTotalTime()

	local var0_15 = arg0_15:getGameUsedTimes() - 4 < 0 and 0 or arg0_15:getGameUsedTimes() - 4

	scrollTo(arg0_15.battleScrollRect, 0, 1 - var0_15 / (arg0_15.totalTimes - 4))
	onButton(arg0_15, findTF(arg0_15.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_22 = arg0_15.battleScrollRect.normalizedPosition.y + 1 / (arg0_15.totalTimes - 4)

		if var0_22 > 1 then
			var0_22 = 1
		end

		scrollTo(arg0_15.battleScrollRect, 0, var0_22)
	end, SFX_CANCEL)
	onButton(arg0_15, findTF(arg0_15.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_23 = arg0_15.battleScrollRect.normalizedPosition.y - 1 / (arg0_15.totalTimes - 4)

		if var0_23 < 0 then
			var0_23 = 0
		end

		scrollTo(arg0_15.battleScrollRect, 0, var0_23)
	end, SFX_CANCEL)
	onButton(arg0_15, findTF(arg0_15.menuUI, "adButton/btnBack"), function()
		arg0_15:closeView()
	end, SFX_CANCEL)
	onButton(arg0_15, findTF(arg0_15.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.mini_cookgametip.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_15, findTF(arg0_15.menuUI, "btnStart"), function()
		setActive(arg0_15.menuUI, false)
		arg0_15:openSelectUI()
	end, SFX_CANCEL)

	local var1_15 = findTF(arg0_15.menuUI, "tplBattleItem")

	arg0_15.battleItems = {}
	arg0_15.dropItems = {}

	for iter0_15 = 1, 7 do
		local var2_15 = tf(instantiate(var1_15))

		var2_15.name = "battleItem_" .. iter0_15

		setParent(var2_15, findTF(arg0_15.menuUI, "battList/Viewport/Content"))

		local var3_15 = iter0_15

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, "battleDesc" .. var3_15, function(arg0_27)
			if arg0_27 then
				setImageSprite(findTF(var2_15, "state_open/desc"), arg0_27, true)
				setImageSprite(findTF(var2_15, "state_clear/desc"), arg0_27, true)
				setImageSprite(findTF(var2_15, "state_current/desc"), arg0_27, true)
				setImageSprite(findTF(var2_15, "state_closed/desc"), arg0_27, true)
			end
		end)

		local var4_15 = findTF(var2_15, "icon")
		local var5_15 = {
			type = arg0_15.dropData[iter0_15][1],
			id = arg0_15.dropData[iter0_15][2],
			amount = arg0_15.dropData[iter0_15][3]
		}

		updateDrop(var4_15, var5_15)
		onButton(arg0_15, var4_15, function()
			arg0_15:emit(BaseUI.ON_DROP, var5_15)
		end, SFX_PANEL)
		table.insert(arg0_15.dropItems, var4_15)
		setActive(var2_15, true)
		table.insert(arg0_15.battleItems, var2_15)
	end

	arg0_15.selectUI = findTF(arg0_15._tf, "pop/selectUI")
	arg0_15.selectCharTpl = findTF(arg0_15.selectUI, "ad/charTpl")

	setActive(arg0_15.selectCharTpl, false)

	arg0_15.selectCharsContainer = findTF(arg0_15.selectUI, "ad/chars/Viewport/Content")
	arg0_15.selectCharId = nil
	arg0_15.selectChars = {}

	local var6_15 = #CookGameConst.char_ids
	local var7_15 = findTF(arg0_15.selectUI, "ad/charDetail")

	arg0_15.detailDescPositons = {}

	for iter1_15 = 1, var6_15 do
		local var8_15 = CookGameConst.char_ids[iter1_15]
		local var9_15 = arg0_15:getCharDataById(var8_15)
		local var10_15 = tf(instantiate(arg0_15.selectCharTpl))

		setParent(var10_15, arg0_15.selectCharsContainer)

		if var9_15 then
			local var11_15 = var9_15.icon
			local var12_15 = var9_15.pos
			local var13_15 = pg.gametip[var9_15.desc].tip
			local var14_15 = pg.ship_data_statistics[var9_15.ship_id].name

			setScrollText(findTF(var10_15, "name/text"), var14_15)
			setActive(findTF(var10_15, "desc"), false)
			setActive(findTF(var10_15, "desc_en"), false)

			if PLATFORM_CODE == PLATFORM_US then
				setActive(findTF(var10_15, "desc_en"), true)
				setText(findTF(var10_15, "desc_en"), var13_15)
			else
				setActive(findTF(var10_15, "desc"), true)
				setText(findTF(var10_15, "desc"), var13_15)
			end

			local var15_15 = findTF(var10_15, "detailDesc")

			setActive(var15_15, false)

			if var9_15.detail_name then
				arg0_15.detailDescPositons[var9_15.detail_name] = var15_15.anchoredPosition

				setText(findTF(var15_15, "name"), i18n(var9_15.detail_name))
				setText(findTF(var15_15, "desc"), i18n(var9_15.detail_desc))
				setActive(findTF(var10_15, "clickDesc"), true)
				onButton(arg0_15, findTF(var10_15, "clickDesc"), function()
					local var0_29 = isActive(var15_15)
					local var1_29

					if not var0_29 then
						var1_29 = var7_15:InverseTransformPoint(var15_15.position)

						setParent(var15_15, var7_15)

						arg0_15.detailDescTf = var15_15
						arg0_15.detailDescContent = var10_15
						arg0_15.detailDescName = var9_15.detail_name
					else
						var1_29 = arg0_15.detailDescPositons[var9_15.detail_name]

						setParent(var15_15, var10_15)

						arg0_15.detailDescTf = nil
						arg0_15.detailDescContent = nil
						arg0_15.detailDescName = nil
					end

					var15_15.anchoredPosition = var1_29

					setActive(var15_15, not var0_29)
				end)
			end

			GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var11_15, function(arg0_30)
				local var0_30 = findTF(var10_15, "icon/img")

				setActive(var0_30, true)

				var0_30.anchoredPosition = var12_15

				setImageSprite(var0_30, arg0_30, true)
			end)
			setActive(findTF(var10_15, "selected"), false)
			onButton(arg0_15, findTF(var10_15, "click"), function()
				arg0_15:selectChar(var9_15.id)
			end, SFX_PANEL)
		else
			GetComponent(var10_15, typeof(CanvasGroup)).alpha = 0
		end

		setActive(var10_15, true)
		table.insert(arg0_15.selectChars, {
			data = var9_15,
			tf = var10_15
		})
	end

	arg0_15.playerTf = findTF(arg0_15.selectUI, "ad/player")
	arg0_15.partnerTf = findTF(arg0_15.selectUI, "ad/partner")
	arg0_15.selectClickTf = findTF(arg0_15.selectUI, "ad/click")

	setActive(arg0_15.selectClickTf, false)
	onButton(arg0_15, findTF(arg0_15.selectUI, "ad/btnStart"), function()
		if var8_0.playerChar and var8_0.partnerChar then
			arg0_15:randomAIShip()
			setActive(arg0_15.selectUI, false)
			arg0_15:readyStart()
		end
	end, SFX_PANEL)
	onButton(arg0_15, findTF(arg0_15.selectUI, "ad/player"), function()
		arg0_15.selectPlayer = true
		arg0_15.selectPartner = false

		arg0_15:updateSelectUI()
	end, SFX_PANEL)
	onButton(arg0_15, findTF(arg0_15.selectUI, "ad/partner"), function()
		arg0_15.selectPlayer = false
		arg0_15.selectPartner = true

		arg0_15:updateSelectUI()
	end, SFX_PANEL)
	onButton(arg0_15, findTF(arg0_15.selectUI, "ad/back"), function()
		setActive(arg0_15.selectUI, false)
		arg0_15:openMenuUI()
	end, SFX_PANEL)

	arg0_15.pageMax = math.ceil(var6_15 / var7_0) - 1
	arg0_15.curPageIndex = 0
	arg0_15.scrollNum = 1 / arg0_15.pageMax
	arg0_15.scrollRect = GetComponent(findTF(arg0_15.selectUI, "ad/chars"), typeof(ScrollRect))
	arg0_15.scrollRect.normalizedPosition = Vector2(0, 0)

	arg0_15.scrollRect.onValueChanged:Invoke(Vector2(0, 0))

	arg0_15.scrollRect.normalizedPosition = Vector2(0, 0)

	arg0_15.scrollRect.onValueChanged:Invoke(Vector2(0, 0))
	GetOrAddComponent(findTF(arg0_15.selectUI, "ad/chars"), typeof(EventTriggerListener)):AddPointDownFunc(function(arg0_36, arg1_36)
		return
	end)
	arg0_15.scrollRect.onValueChanged:AddListener(function(arg0_37, arg1_37, arg2_37)
		if arg0_15.detailDescTf then
			setActive(arg0_15.detailDescTf, false)
			setParent(arg0_15.detailDescTf, arg0_15.detailDescContent)

			arg0_15.detailDescTf.anchoredPosition = arg0_15.detailDescPositons[arg0_15.detailDescName]
			arg0_15.detailDescTf = nil
			arg0_15.detailDescContent = nil
			arg0_15.detailDescName = nil
		end
	end)
	onButton(arg0_15, findTF(arg0_15.selectUI, "ad/next"), function()
		arg0_15.curPageIndex = arg0_15.curPageIndex + arg0_15.scrollNum

		if arg0_15.curPageIndex > 1 then
			arg0_15.curPageIndex = 1
		end

		arg0_15.scrollRect.normalizedPosition = Vector2(arg0_15.curPageIndex, 0)

		arg0_15.scrollRect.onValueChanged:Invoke(Vector2(arg0_15.curPageIndex, 0))
	end, SFX_PANEL)
	onButton(arg0_15, findTF(arg0_15.selectUI, "ad/pre"), function()
		arg0_15.curPageIndex = arg0_15.curPageIndex - arg0_15.scrollNum

		if arg0_15.curPageIndex < 0 then
			arg0_15.curPageIndex = 0
		end

		arg0_15.scrollRect.normalizedPosition = Vector2(arg0_15.curPageIndex, 0)

		arg0_15.scrollRect.onValueChanged:Invoke(Vector2(arg0_15.curPageIndex, 0))
	end, SFX_PANEL)
	setActive(arg0_15.selectUI, false)

	if not arg0_15.handle and IsUnityEditor then
		arg0_15.handle = UpdateBeat:CreateListener(arg0_15.Update, arg0_15)

		UpdateBeat:AddListener(arg0_15.handle)
	end

	GetComponent(findTF(arg0_15.selectUI, "ad/playerDesc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_15.selectUI, "ad/partnerDesc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_15.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_15.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
end

function var0_0.initGameUI(arg0_40)
	arg0_40.gameUI = findTF(arg0_40._tf, "ui/gameUI")
	arg0_40.showScoreTpl = findTF(arg0_40.sceneFrontContainer, "score")

	setActive(arg0_40.showScoreTpl, false)
	onButton(arg0_40, findTF(arg0_40.gameUI, "topRight/btnStop"), function()
		arg0_40:stopGame()
		setActive(arg0_40.pauseUI, true)
	end)
	onButton(arg0_40, findTF(arg0_40.gameUI, "btnLeave"), function()
		arg0_40:stopGame()
		setActive(arg0_40.leaveUI, true)
	end)

	arg0_40.gameTimeS = findTF(arg0_40.gameUI, "top/time/s")
	arg0_40.scoreTf = findTF(arg0_40.gameUI, "top/score")
	arg0_40.otherScoreTf = findTF(arg0_40.gameUI, "top/otherScore")
end

function var0_0.initController(arg0_43)
	arg0_43.judgesController = CookGameJudgesController.New(arg0_43.sceneContainer, var8_0, arg0_43)

	local var0_43 = findTF(arg0_43.sceneContainer, "scene_background/charTpl")

	setActive(var0_43, false)

	arg0_43.charController = CookGameCharController.New(arg0_43.sceneContainer, var8_0, arg0_43)
end

function var0_0.Update(arg0_44)
	arg0_44:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_45)
	if arg0_45.gameStop or arg0_45.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_46)
	local var0_46 = arg0_46:getGameUsedTimes()
	local var1_46 = arg0_46:getGameTimes()

	for iter0_46 = 1, #arg0_46.battleItems do
		setActive(findTF(arg0_46.battleItems[iter0_46], "state_open"), false)
		setActive(findTF(arg0_46.battleItems[iter0_46], "state_closed"), false)
		setActive(findTF(arg0_46.battleItems[iter0_46], "state_clear"), false)
		setActive(findTF(arg0_46.battleItems[iter0_46], "state_current"), false)

		if iter0_46 <= var0_46 then
			SetParent(arg0_46.dropItems[iter0_46], findTF(arg0_46.battleItems[iter0_46], "state_clear/icon"))
			setActive(arg0_46.dropItems[iter0_46], true)
			setActive(findTF(arg0_46.battleItems[iter0_46], "state_clear"), true)
		elseif iter0_46 == var0_46 + 1 and var1_46 >= 1 then
			setActive(findTF(arg0_46.battleItems[iter0_46], "state_current"), true)
			SetParent(arg0_46.dropItems[iter0_46], findTF(arg0_46.battleItems[iter0_46], "state_current/icon"))
			setActive(arg0_46.dropItems[iter0_46], true)
		elseif var0_46 < iter0_46 and iter0_46 <= var0_46 + var1_46 then
			setActive(findTF(arg0_46.battleItems[iter0_46], "state_open"), true)
			SetParent(arg0_46.dropItems[iter0_46], findTF(arg0_46.battleItems[iter0_46], "state_open/icon"))
			setActive(arg0_46.dropItems[iter0_46], true)
		else
			setActive(findTF(arg0_46.battleItems[iter0_46], "state_closed"), true)
			SetParent(arg0_46.dropItems[iter0_46], findTF(arg0_46.battleItems[iter0_46], "state_closed/icon"))
			setActive(arg0_46.dropItems[iter0_46], true)
		end
	end

	arg0_46.totalTimes = arg0_46:getGameTotalTime()

	local var2_46 = 1 - (arg0_46:getGameUsedTimes() - 3 < 0 and 0 or arg0_46:getGameUsedTimes() - 3) / (arg0_46.totalTimes - 4)

	if var2_46 > 1 then
		var2_46 = 1
	end

	scrollTo(arg0_46.battleScrollRect, 0, var2_46)
	setActive(findTF(arg0_46.menuUI, "btnStart/tip"), var1_46 > 0)
	arg0_46:CheckGet()
end

function var0_0.CheckGet(arg0_47)
	setActive(findTF(arg0_47.menuUI, "got"), false)

	if arg0_47:getUltimate() and arg0_47:getUltimate() ~= 0 then
		setActive(findTF(arg0_47.menuUI, "got"), true)
	end

	if arg0_47:getUltimate() == 0 then
		if arg0_47:getGameTotalTime() > arg0_47:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_47:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_47.menuUI, "got"), true)
	end
end

function var0_0.openSelectUI(arg0_48)
	setActive(arg0_48.selectUI, true)

	arg0_48.selectPlayer = true
	arg0_48.selectPartner = false

	arg0_48:updateSelectUI()
end

function var0_0.updateSelectUI(arg0_49)
	local var0_49 = var8_0.playerChar

	if var0_49 then
		local var1_49 = findTF(arg0_49.selectUI, "ad/player/icon/img")
		local var2_49 = arg0_49:getCharData(var0_49, "icon")
		local var3_49 = arg0_49:getCharData(var0_49, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var2_49, function(arg0_50)
			var1_49.anchoredPosition = var3_49

			setActive(var1_49, true)
			setImageSprite(var1_49, arg0_50, true)
		end)
	else
		setActive(findTF(arg0_49.selectUI, "ad/player/icon/img"), false)
	end

	local var4_49 = var8_0.partnerChar

	if var4_49 then
		local var5_49 = findTF(arg0_49.selectUI, "ad/partner/icon/img")
		local var6_49 = arg0_49:getCharData(var4_49, "icon")
		local var7_49 = arg0_49:getCharData(var4_49, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var6_49, function(arg0_51)
			var5_49.anchoredPosition = var7_49

			setActive(var5_49, true)
			setImageSprite(var5_49, arg0_51, true)
		end)
	else
		setActive(findTF(arg0_49.selectUI, "ad/partner/icon/img"), false)
	end

	if arg0_49.selectPlayer then
		setActive(findTF(arg0_49.selectUI, "ad/player/selected"), true)
		setActive(findTF(arg0_49.selectUI, "ad/partner/selected"), false)
	elseif arg0_49.selectPartner then
		setActive(findTF(arg0_49.selectUI, "ad/player/selected"), false)
		setActive(findTF(arg0_49.selectUI, "ad/partner/selected"), true)
	end
end

function var0_0.selectChar(arg0_52, arg1_52)
	arg0_52.selectCharId = arg1_52

	for iter0_52 = 1, #arg0_52.selectChars do
		local var0_52 = arg0_52.selectChars[iter0_52].data

		if var0_52 then
			local var1_52 = arg0_52.selectChars[iter0_52].tf

			if var0_52.id == arg1_52 then
				setActive(findTF(var1_52, "selected"), true)
			else
				setActive(findTF(var1_52, "selected"), false)
			end
		end
	end

	if arg0_52.selectPlayer then
		if var8_0.partnerChar and var8_0.partnerChar == arg1_52 then
			var8_0.partnerChar = var8_0.playerChar or nil
		end

		var8_0.playerChar = arg1_52

		if not var8_0.partnerChar then
			arg0_52.selectPlayer = false
			arg0_52.selectPartner = true
		end
	elseif arg0_52.selectPartner then
		if var8_0.playerChar and var8_0.playerChar == arg1_52 then
			var8_0.playerChar = var8_0.partnerChar
		end

		var8_0.partnerChar = arg1_52

		if not var8_0.playerChar then
			arg0_52.selectPlayer = true
			arg0_52.selectPartner = false
		end
	end

	if var8_0.playerChar and CookGameConst.char_battle_data[var8_0.playerChar].pet then
		var8_0.partnerPet = CookGameConst.char_battle_data[var8_0.playerChar].pet
	elseif var8_0.partnerChar and CookGameConst.char_battle_data[var8_0.partnerChar].pet then
		var8_0.partnerPet = CookGameConst.char_battle_data[var8_0.partnerChar].pet
	else
		var8_0.partnerPet = nil
	end

	arg0_52:updateSelectUI()
end

function var0_0.getCharDataById(arg0_53, arg1_53)
	for iter0_53, iter1_53 in pairs(CookGameConst.char_data) do
		if iter1_53.id == arg1_53 then
			return Clone(iter1_53)
		end
	end

	return nil
end

function var0_0.getCharData(arg0_54, arg1_54, arg2_54)
	for iter0_54 = 1, #CookGameConst.char_data do
		local var0_54 = CookGameConst.char_data[iter0_54]

		if var0_54.id == arg1_54 then
			if not arg2_54 then
				return Clone(var0_54)
			else
				return Clone(var0_54[arg2_54])
			end
		end
	end

	return nil
end

function var0_0.randomAIShip(arg0_55)
	local var0_55 = {}

	for iter0_55, iter1_55 in pairs(CookGameConst.char_battle_data) do
		if iter1_55.extend then
			table.insert(var0_55, iter1_55.id)
		end
	end

	if var8_0.playerChar then
		table.insert(var0_55, var8_0.playerChar)
	end

	if var8_0.partnerChar then
		table.insert(var0_55, var8_0.partnerChar)
	end

	local var1_55 = Clone(CookGameConst.random_ids)

	for iter2_55 = #var1_55, 1, -1 do
		if table.contains(var0_55, var1_55[iter2_55]) then
			table.remove(var1_55, iter2_55)
		end
	end

	var8_0.enemy1Char = table.remove(var1_55, math.random(1, #var1_55))
	var8_0.enemy2Char = table.remove(var1_55, math.random(1, #var1_55))
	var8_0.enemyPet = CookGameConst.char_battle_data[var8_0.enemy1Char].pet or CookGameConst.char_battle_data[var8_0.enemy2Char].pet or nil
end

function var0_0.openMenuUI(arg0_56)
	setActive(findTF(arg0_56.sceneContainer, "scene_front"), false)
	setActive(findTF(arg0_56.sceneContainer, "scene_background"), false)
	setActive(findTF(arg0_56.sceneContainer, "scene"), false)
	setActive(arg0_56.gameUI, false)
	setActive(arg0_56.menuUI, true)
	setActive(arg0_56.bg, true)
	arg0_56:updateMenuUI()
end

function var0_0.clearUI(arg0_57)
	setActive(arg0_57.sceneContainer, false)
	setActive(arg0_57.settlementUI, false)
	setActive(arg0_57.countUI, false)
	setActive(arg0_57.menuUI, false)
	setActive(arg0_57.gameUI, false)
	setActive(arg0_57.selectUI, false)
end

function var0_0.readyStart(arg0_58)
	arg0_58.readyStartFlag = true

	arg0_58:controllerReady()
	setActive(arg0_58.countUI, true)
	arg0_58.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)

	arg0_58.readyStartFlag = false
end

function var0_0.gameStart(arg0_59)
	setActive(findTF(arg0_59.sceneContainer, "scene_front"), true)
	setActive(findTF(arg0_59.sceneContainer, "scene_background"), true)
	setActive(findTF(arg0_59.sceneContainer, "scene"), true)

	GetComponent(findTF(arg0_59.sceneContainer, "scene"), typeof(CanvasGroup)).alpha = 1

	setActive(arg0_59.bg, false)

	arg0_59.sceneContainer.anchoredPosition = Vector2(0, 0)
	arg0_59.offsetPosition = Vector2(0, 0)

	setActive(arg0_59.gameUI, true)

	arg0_59.gameStartFlag = true
	arg0_59.scoreNum = 0
	arg0_59.otherScoreNum = 0
	arg0_59.gameStepTime = 0
	arg0_59.gameTime = var4_0
	arg0_59.extendTime = nil
	arg0_59.waitingExtendTime = false

	if var8_0.playerChar == 6 or var8_0.partnerChar == 6 then
		arg0_59.waitingExtendTime = true
	end

	for iter0_59 = #arg0_59.showScores, 1, -1 do
		if not table.contains(arg0_59.showScoresPool, arg0_59.showScores[iter0_59]) then
			local var0_59 = table.remove(arg0_59.showScores, iter0_59)

			table.insert(arg0_59.showScoresPool, var0_59)
		end
	end

	for iter1_59 = #arg0_59.showScoresPool, 1, -1 do
		setActive(arg0_59.showScoresPool[iter1_59], false)
	end

	local function var1_59(arg0_60, arg1_60)
		local var0_60 = arg0_59:getCharData(arg0_60, "icon")
		local var1_60 = arg0_59:getCharData(arg0_60, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var0_60, function(arg0_61)
			setActive(arg1_60, true)
			setImageSprite(arg1_60, arg0_61, true)
		end)
	end

	var1_59(var8_0.playerChar, findTF(arg0_59.gameUI, "top/leftCharPos/player/img"))
	var1_59(var8_0.partnerChar, findTF(arg0_59.gameUI, "top/leftCharPos/partner/img"))
	var1_59(var8_0.enemy1Char, findTF(arg0_59.gameUI, "top/rightCharPos/enemy1/img"))
	var1_59(var8_0.enemy2Char, findTF(arg0_59.gameUI, "top/rightCharPos/enemy2/img"))
	arg0_59:updateGameUI()
	arg0_59:timerStart()
	arg0_59:controllerStart()
end

function var0_0.controllerReady(arg0_62)
	GetComponent(findTF(arg0_62.sceneContainer, "scene"), typeof(CanvasGroup)).alpha = 0

	setActive(findTF(arg0_62.sceneContainer, "scene"), true)
	arg0_62.charController:readyStart()
end

function var0_0.controllerStart(arg0_63)
	arg0_63.judgesController:start()
	arg0_63.charController:start()
end

function var0_0.getGameTimes(arg0_64)
	return arg0_64:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_65)
	return arg0_65:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_66)
	return arg0_66:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_67)
	return (arg0_67:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_68, arg1_68)
	if arg0_68.judgesController then
		arg0_68.judgesController:changeSpeed(arg1_68)
	end

	if arg0_68.charController then
		arg0_68.charController:changeSpeed(arg1_68)
	end
end

function var0_0.onTimer(arg0_69)
	arg0_69:gameStep()
end

function var0_0.gameStep(arg0_70)
	if arg0_70.gameTime and arg0_70.gameTime > 3 and arg0_70.gameTime - Time.deltaTime < 3 and var8_0.playerChar ~= 6 and var8_0.playerChar ~= 6 then
		arg0_70.judgesController:timeUp()
	end

	if arg0_70.extendTime and arg0_70.extendTime > 3 and arg0_70.extendTime - Time.deltaTime < 3 then
		arg0_70.judgesController:timeUp()
	end

	arg0_70.gameTime = arg0_70.gameTime - Time.deltaTime

	if arg0_70.gameTime < 0 then
		arg0_70.gameTime = 0
	end

	var8_0.gameTime = arg0_70.gameTime

	if arg0_70.extendTime and arg0_70.extendTime > 0 then
		arg0_70.extendTime = arg0_70.extendTime - Time.deltaTime

		if arg0_70.extendTime < 0 then
			arg0_70.extendTime = 0
		end
	end

	arg0_70.gameStepTime = arg0_70.gameStepTime + Time.deltaTime

	arg0_70:controllerStep(Time.deltaTime)
	arg0_70:updateGameUI()

	if not arg0_70.waitingExtendTime and arg0_70.gameTime <= 0 then
		if arg0_70.extendTime then
			if arg0_70.extendTime <= 0 then
				arg0_70:onGameOver()
			end
		else
			arg0_70:onGameOver()
		end

		return
	end
end

function var0_0.controllerStep(arg0_71, arg1_71)
	arg0_71.judgesController:step(arg1_71)
	arg0_71.charController:step(arg1_71)
end

function var0_0.timerStart(arg0_72)
	if not arg0_72.timer.running then
		arg0_72.timer:Start()
	end
end

function var0_0.timerStop(arg0_73)
	if arg0_73.timer.running then
		arg0_73.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_74)
	setText(arg0_74.scoreTf, arg0_74.scoreNum)
	setText(arg0_74.otherScoreTf, arg0_74.otherScoreNum)

	if arg0_74.extendTime and arg0_74.extendTime > 0 then
		setText(arg0_74.gameTimeS, math.ceil(arg0_74.extendTime))
	else
		setText(arg0_74.gameTimeS, math.ceil(arg0_74.gameTime))
	end
end

function var0_0.addScore(arg0_75, arg1_75, arg2_75)
	if arg2_75 then
		arg0_75.otherScoreNum = arg0_75.otherScoreNum + arg1_75

		if arg0_75.otherScoreNum < 0 then
			arg0_75.otherScoreNum = 0
		end
	else
		arg0_75.scoreNum = arg0_75.scoreNum + arg1_75

		if arg0_75.scoreNum < 0 then
			arg0_75.scoreNum = 0
		end
	end
end

function var0_0.onGameOver(arg0_76)
	if arg0_76.settlementFlag then
		return
	end

	arg0_76:timerStop()
	arg0_76:controllerClear()

	arg0_76.settlementFlag = true

	setActive(arg0_76.clickMask, true)
	LeanTween.delayedCall(go(arg0_76._tf), 0.1, System.Action(function()
		arg0_76.settlementFlag = false
		arg0_76.gameStartFlag = false

		setActive(arg0_76.clickMask, false)
		arg0_76:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_78)
	setActive(arg0_78.settlementUI, true)
	GetComponent(findTF(arg0_78.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_78 = arg0_78:GetMGData():GetRuntimeData("elements")
	local var1_78 = arg0_78.scoreNum
	local var2_78 = var0_78 and #var0_78 > 0 and var0_78[1] or 0
	local var3_78 = arg0_78.otherScoreNum or 0

	setActive(findTF(arg0_78.settlementUI, "ad/new"), var2_78 < var1_78)

	if var2_78 <= var1_78 then
		var2_78 = var1_78

		arg0_78:StoreDataToServer({
			var2_78
		})
	end

	local var4_78 = findTF(arg0_78.settlementUI, "ad/highText")
	local var5_78 = findTF(arg0_78.settlementUI, "ad/currentText")
	local var6_78 = findTF(arg0_78.settlementUI, "ad/otherText")

	setText(var4_78, var2_78)
	setText(var5_78, var1_78)
	setText(var6_78, var3_78)

	if arg0_78:getGameTimes() and arg0_78:getGameTimes() > 0 then
		arg0_78.sendSuccessFlag = true

		arg0_78:SendSuccess(0)
	end

	if var3_78 < var1_78 then
		setActive(findTF(arg0_78.settlementUI, "ad/win"), true)
		setActive(findTF(arg0_78.settlementUI, "ad/defeat"), false)
	elseif var1_78 < var3_78 then
		setActive(findTF(arg0_78.settlementUI, "ad/win"), false)
		setActive(findTF(arg0_78.settlementUI, "ad/defeat"), true)
	else
		setActive(findTF(arg0_78.settlementUI, "ad/win"), false)
		setActive(findTF(arg0_78.settlementUI, "ad/defeat"), false)
	end

	local var7_78 = {}

	table.insert(var7_78, {
		name = "player",
		char_id = var8_0.playerChar
	})
	table.insert(var7_78, {
		name = "partner",
		char_id = var8_0.partnerChar
	})
	table.insert(var7_78, {
		name = "enemy1",
		char_id = var8_0.enemy1Char
	})
	table.insert(var7_78, {
		name = "enemy2",
		char_id = var8_0.enemy2Char
	})

	for iter0_78 = 1, #var7_78 do
		local var8_78 = var7_78[iter0_78].char_id
		local var9_78 = findTF(arg0_78.settlementUI, "ad/" .. var7_78[iter0_78].name)
		local var10_78 = arg0_78:getCharData(var8_78, "icon")
		local var11_78 = arg0_78:getCharData(var8_78, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var10_78, function(arg0_79)
			local var0_79 = findTF(var9_78, "mask/img")

			setActive(var0_79, true)

			var0_79.anchoredPosition = var11_78

			setImageSprite(var0_79, arg0_79, true)
		end)
	end
end

function var0_0.OnApplicationPaused(arg0_80)
	if not arg0_80.gameStartFlag then
		return
	end

	if arg0_80.readyStartFlag then
		return
	end

	if arg0_80.settlementFlag then
		return
	end

	if isActive(arg0_80.pauseUI) or isActive(arg0_80.leaveUI) then
		return
	end

	if not isActive(arg0_80.pauseUI) then
		setActive(arg0_80.pauseUI, true)
	end

	arg0_80:stopGame()
end

function var0_0.controllerClear(arg0_81)
	arg0_81.judgesController:clear()
	arg0_81.charController:clear()
end

function var0_0.resumeGame(arg0_82)
	arg0_82.gameStop = false

	setActive(arg0_82.leaveUI, false)
	arg0_82:changeSpeed(1)
	arg0_82:timerStart()
end

function var0_0.stopGame(arg0_83)
	arg0_83.gameStop = true

	arg0_83:timerStop()
	arg0_83:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_84)
	if arg0_84.readyStartFlag then
		return
	end

	if not arg0_84.gameStartFlag then
		arg0_84:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_84.settlementFlag then
			return
		end

		if isActive(arg0_84.pauseUI) then
			setActive(arg0_84.pauseUI, false)
		end

		arg0_84:stopGame()
		setActive(arg0_84.leaveUI, true)
	end
end

function var0_0.willExit(arg0_85)
	if arg0_85.handle then
		UpdateBeat:RemoveListener(arg0_85.handle)
	end

	if arg0_85._tf and LeanTween.isTweening(go(arg0_85._tf)) then
		LeanTween.cancel(go(arg0_85._tf))
	end

	arg0_85:destroyController()

	if arg0_85.timer and arg0_85.timer.running then
		arg0_85.timer:Stop()
	end

	arg0_85.scrollRect.onValueChanged:RemoveAllListeners()

	Time.timeScale = 1
	arg0_85.timer = nil
end

function var0_0.destroyController(arg0_86)
	return
end

return var0_0

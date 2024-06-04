local var0 = class("CookGameView", import("..BaseMiniGameView"))
local var1 = "bar-soft"
local var2 = "event:/ui/ddldaoshu2"
local var3 = "event:/ui/break_out_full"
local var4 = 60
local var5 = "cookgameui_atlas"
local var6 = 0.1
local var7 = 8
local var8 = {
	time_up = 0.5,
	cake_num = 5,
	extend_time = 10,
	char_path = "ui/minigameui/cookgameassets",
	speed_num = 3,
	path = "ui/minigameui/" .. var5
}

var0.CLICK_JUDGE_EVENT = "click judge event"
var0.AC_CAKE_EVENT = "ac cake event"
var0.SERVE_EVENT = "serve event"
var0.EXTEND_EVENT = "extend event"

function var0.getUIName(arg0)
	return "CookGameUI"
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:initController()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	if not arg0.uiCam then
		arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0:bind(CookGameView.CLICK_JUDGE_EVENT, function(arg0, arg1, arg2)
		if arg0.charController then
			arg0.charController:setJudgeAction(arg1, nil, arg2)
		end
	end)
	arg0:bind(CookGameView.AC_CAKE_EVENT, function(arg0, arg1, arg2)
		if arg0.charController then
			arg0.charController:createAcCake(arg1, arg2)
		end
	end)
	arg0:bind(CookGameView.SERVE_EVENT, function(arg0, arg1, arg2)
		local var0 = arg1.serveData.battleData.id
		local var1 = arg1.right
		local var2 = arg1.pos
		local var3 = arg1.rate
		local var4 = arg1.weight
		local var5 = var1 and 1 or -1
		local var6 = var1 and 1 or 0
		local var7 = arg1.serveData.parameter.right_index
		local var8
		local var9 = var0 ~= var8.playerChar and var0 ~= var8.partnerChar and var0 ~= var8.partnerPet

		if not arg1.serveData.battleData.weight then
			local var10 = 0
		end

		if var1 and arg1.serveData.battleData.cake_allow then
			var6 = 3
		end

		if var1 and arg1.serveData.battleData.score_added then
			var5 = var5 + arg1.serveData.parameter.series_right_index - 1
		end

		if arg1.serveData.battleData.random_score then
			var5 = var5 * math.random(1, CookGameConst.random_score)
		end

		local var11 = var5 * var3

		arg0:addScore(var11, var9)
		arg0:showScore(var11, var2, var6)

		if arg1.serveData.battleData.double_score == 8 then
			if var1 and var7 and var7 % 2 == 0 then
				arg0:addScore(var11, var9)
				LeanTween.delayedCall(go(arg0._tf), 0.5, System.Action(function()
					arg0:showScore(var11, var2, 2)
				end))
			end
		elseif arg1.serveData.battleData.half_double and var1 and math.random() > 0.5 then
			arg0:addScore(var11, var9)
			LeanTween.delayedCall(go(arg0._tf), 0.5, System.Action(function()
				arg0:showScore(var11, var2, 2)
			end))
		end
	end)
	arg0:bind(CookGameView.EXTEND_EVENT, function(arg0, arg1, arg2)
		if arg0.judgesController then
			arg0.judgesController:extend()
		end

		arg0.waitingExtendTime = false
		arg0.extendTime = var8.extend_time
		arg0.gameTime = 0
	end)
end

function var0.showScore(arg0, arg1, arg2, arg3)
	if arg1 == 0 then
		return
	end

	local var0

	if #arg0.showScoresPool > 0 then
		var0 = table.remove(arg0.showScoresPool, 1)
	else
		var0 = tf(Instantiate(arg0.showScoreTpl))

		setParent(var0, arg0.sceneFrontContainer)
		GetComponent(findTF(var0, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			for iter0 = #arg0.showScores, 1, -1 do
				if var0 == arg0.showScores[iter0] then
					setActive(var0, false)
					table.insert(arg0.showScoresPool, table.remove(arg0.showScores, iter0))
				end
			end
		end)
	end

	var0.anchoredPosition = arg0.sceneFrontContainer:InverseTransformPoint(arg2)

	setText(findTF(var0, "anim/text_sub"), "" .. tostring(arg1))
	setText(findTF(var0, "anim/text_add"), "+" .. tostring(arg1))

	if arg1 > 0 then
		setActive(findTF(var0, "anim/text_sub"), false)
		setActive(findTF(var0, "anim/text_add"), true)
	else
		setActive(findTF(var0, "anim/text_sub"), true)
		setActive(findTF(var0, "anim/text_add"), false)
	end

	setActive(var0, false)
	setActive(var0, true)
	table.insert(arg0.showScores, var0)
end

function var0.onEventHandle(arg0, arg1)
	return
end

function var0.initData(arg0)
	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
	arg0.showScores = {}
	arg0.showScoresPool = {}
	arg0.dropData = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop_ids
	var8.playerChar = nil
	var8.partnerChar = nil
	var8.partnerPet = nil
	var8.enemy1Char = nil
	var8.enemy2Char = nil
	var8.enemyPet = nil
	arg0.selectPlayer = true
	arg0.selectPartner = false
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "scene_background")
	arg0.sceneContainer = findTF(arg0._tf, "sceneMask/sceneContainer")
	arg0.sceneFrontContainer = findTF(arg0._tf, "sceneMask/sceneContainer/scene_front")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.bg = findTF(arg0._tf, "bg")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)
	setActive(arg0.leaveUI, false)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)
	setActive(arg0.settlementUI, false)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "adButton/btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.mini_cookgametip.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:openSelectUI()
	end, SFX_CANCEL)

	local var1 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}
	arg0.dropItems = {}

	for iter0 = 1, 7 do
		local var2 = tf(instantiate(var1))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5, "battleDesc" .. var3, function(arg0)
			if arg0 then
				setImageSprite(findTF(var2, "state_open/desc"), arg0, true)
				setImageSprite(findTF(var2, "state_clear/desc"), arg0, true)
				setImageSprite(findTF(var2, "state_current/desc"), arg0, true)
				setImageSprite(findTF(var2, "state_closed/desc"), arg0, true)
			end
		end)

		local var4 = findTF(var2, "icon")
		local var5 = {
			type = arg0.dropData[iter0][1],
			id = arg0.dropData[iter0][2],
			amount = arg0.dropData[iter0][3]
		}

		updateDrop(var4, var5)
		onButton(arg0, var4, function()
			arg0:emit(BaseUI.ON_DROP, var5)
		end, SFX_PANEL)
		table.insert(arg0.dropItems, var4)
		setActive(var2, true)
		table.insert(arg0.battleItems, var2)
	end

	arg0.selectUI = findTF(arg0._tf, "pop/selectUI")
	arg0.selectCharTpl = findTF(arg0.selectUI, "ad/charTpl")

	setActive(arg0.selectCharTpl, false)

	arg0.selectCharsContainer = findTF(arg0.selectUI, "ad/chars/Viewport/Content")
	arg0.selectCharId = nil
	arg0.selectChars = {}

	local var6 = #CookGameConst.char_ids
	local var7 = findTF(arg0.selectUI, "ad/charDetail")

	arg0.detailDescPositons = {}

	for iter1 = 1, var6 do
		local var8 = CookGameConst.char_ids[iter1]
		local var9 = arg0:getCharDataById(var8)
		local var10 = tf(instantiate(arg0.selectCharTpl))

		setParent(var10, arg0.selectCharsContainer)

		if var9 then
			local var11 = var9.icon
			local var12 = var9.pos
			local var13 = pg.gametip[var9.desc].tip
			local var14 = pg.ship_data_statistics[var9.ship_id].name

			setScrollText(findTF(var10, "name/text"), var14)
			setActive(findTF(var10, "desc"), false)
			setActive(findTF(var10, "desc_en"), false)

			if PLATFORM_CODE == PLATFORM_US then
				setActive(findTF(var10, "desc_en"), true)
				setText(findTF(var10, "desc_en"), var13)
			else
				setActive(findTF(var10, "desc"), true)
				setText(findTF(var10, "desc"), var13)
			end

			local var15 = findTF(var10, "detailDesc")

			setActive(var15, false)

			if var9.detail_name then
				arg0.detailDescPositons[var9.detail_name] = var15.anchoredPosition

				setText(findTF(var15, "name"), i18n(var9.detail_name))
				setText(findTF(var15, "desc"), i18n(var9.detail_desc))
				setActive(findTF(var10, "clickDesc"), true)
				onButton(arg0, findTF(var10, "clickDesc"), function()
					local var0 = isActive(var15)
					local var1

					if not var0 then
						var1 = var7:InverseTransformPoint(var15.position)

						setParent(var15, var7)

						arg0.detailDescTf = var15
						arg0.detailDescContent = var10
						arg0.detailDescName = var9.detail_name
					else
						var1 = arg0.detailDescPositons[var9.detail_name]

						setParent(var15, var10)

						arg0.detailDescTf = nil
						arg0.detailDescContent = nil
						arg0.detailDescName = nil
					end

					var15.anchoredPosition = var1

					setActive(var15, not var0)
				end)
			end

			GetSpriteFromAtlasAsync("ui/minigameui/" .. var5, var11, function(arg0)
				local var0 = findTF(var10, "icon/img")

				setActive(var0, true)

				var0.anchoredPosition = var12

				setImageSprite(var0, arg0, true)
			end)
			setActive(findTF(var10, "selected"), false)
			onButton(arg0, findTF(var10, "click"), function()
				arg0:selectChar(var9.id)
			end, SFX_PANEL)
		else
			GetComponent(var10, typeof(CanvasGroup)).alpha = 0
		end

		setActive(var10, true)
		table.insert(arg0.selectChars, {
			data = var9,
			tf = var10
		})
	end

	arg0.playerTf = findTF(arg0.selectUI, "ad/player")
	arg0.partnerTf = findTF(arg0.selectUI, "ad/partner")
	arg0.selectClickTf = findTF(arg0.selectUI, "ad/click")

	setActive(arg0.selectClickTf, false)
	onButton(arg0, findTF(arg0.selectUI, "ad/btnStart"), function()
		if var8.playerChar and var8.partnerChar then
			arg0:randomAIShip()
			setActive(arg0.selectUI, false)
			arg0:readyStart()
		end
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.selectUI, "ad/player"), function()
		arg0.selectPlayer = true
		arg0.selectPartner = false

		arg0:updateSelectUI()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.selectUI, "ad/partner"), function()
		arg0.selectPlayer = false
		arg0.selectPartner = true

		arg0:updateSelectUI()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.selectUI, "ad/back"), function()
		setActive(arg0.selectUI, false)
		arg0:openMenuUI()
	end, SFX_PANEL)

	arg0.pageMax = math.ceil(var6 / var7) - 1
	arg0.curPageIndex = 0
	arg0.scrollNum = 1 / arg0.pageMax
	arg0.scrollRect = GetComponent(findTF(arg0.selectUI, "ad/chars"), typeof(ScrollRect))
	arg0.scrollRect.normalizedPosition = Vector2(0, 0)

	arg0.scrollRect.onValueChanged:Invoke(Vector2(0, 0))

	arg0.scrollRect.normalizedPosition = Vector2(0, 0)

	arg0.scrollRect.onValueChanged:Invoke(Vector2(0, 0))
	GetOrAddComponent(findTF(arg0.selectUI, "ad/chars"), typeof(EventTriggerListener)):AddPointDownFunc(function(arg0, arg1)
		return
	end)
	arg0.scrollRect.onValueChanged:AddListener(function(arg0, arg1, arg2)
		if arg0.detailDescTf then
			setActive(arg0.detailDescTf, false)
			setParent(arg0.detailDescTf, arg0.detailDescContent)

			arg0.detailDescTf.anchoredPosition = arg0.detailDescPositons[arg0.detailDescName]
			arg0.detailDescTf = nil
			arg0.detailDescContent = nil
			arg0.detailDescName = nil
		end
	end)
	onButton(arg0, findTF(arg0.selectUI, "ad/next"), function()
		arg0.curPageIndex = arg0.curPageIndex + arg0.scrollNum

		if arg0.curPageIndex > 1 then
			arg0.curPageIndex = 1
		end

		arg0.scrollRect.normalizedPosition = Vector2(arg0.curPageIndex, 0)

		arg0.scrollRect.onValueChanged:Invoke(Vector2(arg0.curPageIndex, 0))
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.selectUI, "ad/pre"), function()
		arg0.curPageIndex = arg0.curPageIndex - arg0.scrollNum

		if arg0.curPageIndex < 0 then
			arg0.curPageIndex = 0
		end

		arg0.scrollRect.normalizedPosition = Vector2(arg0.curPageIndex, 0)

		arg0.scrollRect.onValueChanged:Invoke(Vector2(arg0.curPageIndex, 0))
	end, SFX_PANEL)
	setActive(arg0.selectUI, false)

	if not arg0.handle and IsUnityEditor then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end

	GetComponent(findTF(arg0.selectUI, "ad/playerDesc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0.selectUI, "ad/partnerDesc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.showScoreTpl = findTF(arg0.sceneFrontContainer, "score")

	setActive(arg0.showScoreTpl, false)
	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.otherScoreTf = findTF(arg0.gameUI, "top/otherScore")
end

function var0.initController(arg0)
	arg0.judgesController = CookGameJudgesController.New(arg0.sceneContainer, var8, arg0)

	local var0 = findTF(arg0.sceneContainer, "scene_background/charTpl")

	setActive(var0, false)

	arg0.charController = CookGameCharController.New(arg0.sceneContainer, var8, arg0)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_clear/icon"))
			setActive(arg0.dropItems[iter0], true)
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_current/icon"))
			setActive(arg0.dropItems[iter0], true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_open/icon"))
			setActive(arg0.dropItems[iter0], true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_closed/icon"))
			setActive(arg0.dropItems[iter0], true)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openSelectUI(arg0)
	setActive(arg0.selectUI, true)

	arg0.selectPlayer = true
	arg0.selectPartner = false

	arg0:updateSelectUI()
end

function var0.updateSelectUI(arg0)
	local var0 = var8.playerChar

	if var0 then
		local var1 = findTF(arg0.selectUI, "ad/player/icon/img")
		local var2 = arg0:getCharData(var0, "icon")
		local var3 = arg0:getCharData(var0, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5, var2, function(arg0)
			var1.anchoredPosition = var3

			setActive(var1, true)
			setImageSprite(var1, arg0, true)
		end)
	else
		setActive(findTF(arg0.selectUI, "ad/player/icon/img"), false)
	end

	local var4 = var8.partnerChar

	if var4 then
		local var5 = findTF(arg0.selectUI, "ad/partner/icon/img")
		local var6 = arg0:getCharData(var4, "icon")
		local var7 = arg0:getCharData(var4, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5, var6, function(arg0)
			var5.anchoredPosition = var7

			setActive(var5, true)
			setImageSprite(var5, arg0, true)
		end)
	else
		setActive(findTF(arg0.selectUI, "ad/partner/icon/img"), false)
	end

	if arg0.selectPlayer then
		setActive(findTF(arg0.selectUI, "ad/player/selected"), true)
		setActive(findTF(arg0.selectUI, "ad/partner/selected"), false)
	elseif arg0.selectPartner then
		setActive(findTF(arg0.selectUI, "ad/player/selected"), false)
		setActive(findTF(arg0.selectUI, "ad/partner/selected"), true)
	end
end

function var0.selectChar(arg0, arg1)
	arg0.selectCharId = arg1

	for iter0 = 1, #arg0.selectChars do
		local var0 = arg0.selectChars[iter0].data

		if var0 then
			local var1 = arg0.selectChars[iter0].tf

			if var0.id == arg1 then
				setActive(findTF(var1, "selected"), true)
			else
				setActive(findTF(var1, "selected"), false)
			end
		end
	end

	if arg0.selectPlayer then
		if var8.partnerChar and var8.partnerChar == arg1 then
			var8.partnerChar = var8.playerChar or nil
		end

		var8.playerChar = arg1

		if not var8.partnerChar then
			arg0.selectPlayer = false
			arg0.selectPartner = true
		end
	elseif arg0.selectPartner then
		if var8.playerChar and var8.playerChar == arg1 then
			var8.playerChar = var8.partnerChar
		end

		var8.partnerChar = arg1

		if not var8.playerChar then
			arg0.selectPlayer = true
			arg0.selectPartner = false
		end
	end

	if var8.playerChar and CookGameConst.char_battle_data[var8.playerChar].pet then
		var8.partnerPet = CookGameConst.char_battle_data[var8.playerChar].pet
	elseif var8.partnerChar and CookGameConst.char_battle_data[var8.partnerChar].pet then
		var8.partnerPet = CookGameConst.char_battle_data[var8.partnerChar].pet
	else
		var8.partnerPet = nil
	end

	arg0:updateSelectUI()
end

function var0.getCharDataById(arg0, arg1)
	for iter0, iter1 in pairs(CookGameConst.char_data) do
		if iter1.id == arg1 then
			return Clone(iter1)
		end
	end

	return nil
end

function var0.getCharData(arg0, arg1, arg2)
	for iter0 = 1, #CookGameConst.char_data do
		local var0 = CookGameConst.char_data[iter0]

		if var0.id == arg1 then
			if not arg2 then
				return Clone(var0)
			else
				return Clone(var0[arg2])
			end
		end
	end

	return nil
end

function var0.randomAIShip(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(CookGameConst.char_battle_data) do
		if iter1.extend then
			table.insert(var0, iter1.id)
		end
	end

	if var8.playerChar then
		table.insert(var0, var8.playerChar)
	end

	if var8.partnerChar then
		table.insert(var0, var8.partnerChar)
	end

	local var1 = Clone(CookGameConst.random_ids)

	for iter2 = #var1, 1, -1 do
		if table.contains(var0, var1[iter2]) then
			table.remove(var1, iter2)
		end
	end

	var8.enemy1Char = table.remove(var1, math.random(1, #var1))
	var8.enemy2Char = table.remove(var1, math.random(1, #var1))
	var8.enemyPet = CookGameConst.char_battle_data[var8.enemy1Char].pet or CookGameConst.char_battle_data[var8.enemy2Char].pet or nil
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0.sceneContainer, "scene_front"), false)
	setActive(findTF(arg0.sceneContainer, "scene_background"), false)
	setActive(findTF(arg0.sceneContainer, "scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	setActive(arg0.bg, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneContainer, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
	setActive(arg0.selectUI, false)
end

function var0.readyStart(arg0)
	arg0.readyStartFlag = true

	arg0:controllerReady()
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)

	arg0.readyStartFlag = false
end

function var0.gameStart(arg0)
	setActive(findTF(arg0.sceneContainer, "scene_front"), true)
	setActive(findTF(arg0.sceneContainer, "scene_background"), true)
	setActive(findTF(arg0.sceneContainer, "scene"), true)

	GetComponent(findTF(arg0.sceneContainer, "scene"), typeof(CanvasGroup)).alpha = 1

	setActive(arg0.bg, false)

	arg0.sceneContainer.anchoredPosition = Vector2(0, 0)
	arg0.offsetPosition = Vector2(0, 0)

	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.otherScoreNum = 0
	arg0.gameStepTime = 0
	arg0.gameTime = var4
	arg0.extendTime = nil
	arg0.waitingExtendTime = false

	if var8.playerChar == 6 or var8.partnerChar == 6 then
		arg0.waitingExtendTime = true
	end

	for iter0 = #arg0.showScores, 1, -1 do
		if not table.contains(arg0.showScoresPool, arg0.showScores[iter0]) then
			local var0 = table.remove(arg0.showScores, iter0)

			table.insert(arg0.showScoresPool, var0)
		end
	end

	for iter1 = #arg0.showScoresPool, 1, -1 do
		setActive(arg0.showScoresPool[iter1], false)
	end

	local function var1(arg0, arg1)
		local var0 = arg0:getCharData(arg0, "icon")
		local var1 = arg0:getCharData(arg0, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5, var0, function(arg0)
			setActive(arg1, true)
			setImageSprite(arg1, arg0, true)
		end)
	end

	var1(var8.playerChar, findTF(arg0.gameUI, "top/leftCharPos/player/img"))
	var1(var8.partnerChar, findTF(arg0.gameUI, "top/leftCharPos/partner/img"))
	var1(var8.enemy1Char, findTF(arg0.gameUI, "top/rightCharPos/enemy1/img"))
	var1(var8.enemy2Char, findTF(arg0.gameUI, "top/rightCharPos/enemy2/img"))
	arg0:updateGameUI()
	arg0:timerStart()
	arg0:controllerStart()
end

function var0.controllerReady(arg0)
	GetComponent(findTF(arg0.sceneContainer, "scene"), typeof(CanvasGroup)).alpha = 0

	setActive(findTF(arg0.sceneContainer, "scene"), true)
	arg0.charController:readyStart()
end

function var0.controllerStart(arg0)
	arg0.judgesController:start()
	arg0.charController:start()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.changeSpeed(arg0, arg1)
	if arg0.judgesController then
		arg0.judgesController:changeSpeed(arg1)
	end

	if arg0.charController then
		arg0.charController:changeSpeed(arg1)
	end
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	if arg0.gameTime and arg0.gameTime > 3 and arg0.gameTime - Time.deltaTime < 3 and var8.playerChar ~= 6 and var8.playerChar ~= 6 then
		arg0.judgesController:timeUp()
	end

	if arg0.extendTime and arg0.extendTime > 3 and arg0.extendTime - Time.deltaTime < 3 then
		arg0.judgesController:timeUp()
	end

	arg0.gameTime = arg0.gameTime - Time.deltaTime

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	var8.gameTime = arg0.gameTime

	if arg0.extendTime and arg0.extendTime > 0 then
		arg0.extendTime = arg0.extendTime - Time.deltaTime

		if arg0.extendTime < 0 then
			arg0.extendTime = 0
		end
	end

	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

	arg0:controllerStep(Time.deltaTime)
	arg0:updateGameUI()

	if not arg0.waitingExtendTime and arg0.gameTime <= 0 then
		if arg0.extendTime then
			if arg0.extendTime <= 0 then
				arg0:onGameOver()
			end
		else
			arg0:onGameOver()
		end

		return
	end
end

function var0.controllerStep(arg0, arg1)
	arg0.judgesController:step(arg1)
	arg0.charController:step(arg1)
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.otherScoreTf, arg0.otherScoreNum)

	if arg0.extendTime and arg0.extendTime > 0 then
		setText(arg0.gameTimeS, math.ceil(arg0.extendTime))
	else
		setText(arg0.gameTimeS, math.ceil(arg0.gameTime))
	end
end

function var0.addScore(arg0, arg1, arg2)
	if arg2 then
		arg0.otherScoreNum = arg0.otherScoreNum + arg1

		if arg0.otherScoreNum < 0 then
			arg0.otherScoreNum = 0
		end
	else
		arg0.scoreNum = arg0.scoreNum + arg1

		if arg0.scoreNum < 0 then
			arg0.scoreNum = 0
		end
	end
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()
	arg0:controllerClear()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 0.1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0
	local var3 = arg0.otherScoreNum or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var4 = findTF(arg0.settlementUI, "ad/highText")
	local var5 = findTF(arg0.settlementUI, "ad/currentText")
	local var6 = findTF(arg0.settlementUI, "ad/otherText")

	setText(var4, var2)
	setText(var5, var1)
	setText(var6, var3)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end

	if var3 < var1 then
		setActive(findTF(arg0.settlementUI, "ad/win"), true)
		setActive(findTF(arg0.settlementUI, "ad/defeat"), false)
	elseif var1 < var3 then
		setActive(findTF(arg0.settlementUI, "ad/win"), false)
		setActive(findTF(arg0.settlementUI, "ad/defeat"), true)
	else
		setActive(findTF(arg0.settlementUI, "ad/win"), false)
		setActive(findTF(arg0.settlementUI, "ad/defeat"), false)
	end

	local var7 = {}

	table.insert(var7, {
		name = "player",
		char_id = var8.playerChar
	})
	table.insert(var7, {
		name = "partner",
		char_id = var8.partnerChar
	})
	table.insert(var7, {
		name = "enemy1",
		char_id = var8.enemy1Char
	})
	table.insert(var7, {
		name = "enemy2",
		char_id = var8.enemy2Char
	})

	for iter0 = 1, #var7 do
		local var8 = var7[iter0].char_id
		local var9 = findTF(arg0.settlementUI, "ad/" .. var7[iter0].name)
		local var10 = arg0:getCharData(var8, "icon")
		local var11 = arg0:getCharData(var8, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5, var10, function(arg0)
			local var0 = findTF(var9, "mask/img")

			setActive(var0, true)

			var0.anchoredPosition = var11

			setImageSprite(var0, arg0, true)
		end)
	end
end

function var0.OnApplicationPaused(arg0)
	if not arg0.gameStartFlag then
		return
	end

	if arg0.readyStartFlag then
		return
	end

	if arg0.settlementFlag then
		return
	end

	if isActive(arg0.pauseUI) or isActive(arg0.leaveUI) then
		return
	end

	if not isActive(arg0.pauseUI) then
		setActive(arg0.pauseUI, true)
	end

	arg0:stopGame()
end

function var0.controllerClear(arg0)
	arg0.judgesController:clear()
	arg0.charController:clear()
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
	arg0:changeSpeed(0)
end

function var0.onBackPressed(arg0)
	if arg0.readyStartFlag then
		return
	end

	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	arg0:destroyController()

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	arg0.scrollRect.onValueChanged:RemoveAllListeners()

	Time.timeScale = 1
	arg0.timer = nil
end

function var0.destroyController(arg0)
	return
end

return var0

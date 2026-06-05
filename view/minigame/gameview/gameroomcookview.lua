local var0_0 = class("GameRoomCookView", import("..BaseMiniGameView"))
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
	return "GameRoomCookUI"
end

function var0_0.preload(arg0_2, arg1_2)
	AssetBundleHelper.StoreAssetBundle(var8_0.path, false, true)

	arg0_2.cookGameUIAtlasStored = true

	arg1_2()
end

function var0_0.didEnter(arg0_3)
	arg0_3:initEvent()
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:initGameUI()
	arg0_3:initController()
	arg0_3:updateMenuUI()
	arg0_3:openMenuUI()
end

function var0_0.initEvent(arg0_4)
	if not arg0_4.uiCam then
		arg0_4.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0_4:bind(CookGameView.CLICK_JUDGE_EVENT, function(arg0_5, arg1_5, arg2_5)
		if arg0_4.charController then
			arg0_4.charController:setJudgeAction(arg1_5, nil, arg2_5)
		end
	end)
	arg0_4:bind(CookGameView.AC_CAKE_EVENT, function(arg0_6, arg1_6, arg2_6)
		if arg0_4.charController then
			arg0_4.charController:createAcCake(arg1_6, arg2_6)
		end
	end)
	arg0_4:bind(CookGameView.SERVE_EVENT, function(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg1_7.serveData.battleData.id
		local var1_7 = arg1_7.right
		local var2_7 = arg1_7.pos
		local var3_7 = arg1_7.rate
		local var4_7 = arg1_7.weight
		local var5_7 = var1_7 and 1 or -1
		local var6_7 = var1_7 and 1 or 0
		local var7_7 = arg1_7.serveData.parameter.right_index
		local var8_7
		local var9_7 = var0_7 ~= var8_0.playerChar and var0_7 ~= var8_0.partnerChar and var0_7 ~= var8_0.partnerPet

		if not arg1_7.serveData.battleData.weight then
			local var10_7 = 0
		end

		if var1_7 and arg1_7.serveData.battleData.cake_allow then
			var6_7 = 3
		end

		if var1_7 and arg1_7.serveData.battleData.score_added then
			var5_7 = var5_7 + arg1_7.serveData.parameter.series_right_index - 1
		end

		if arg1_7.serveData.battleData.random_score then
			var5_7 = var5_7 * math.random(1, CookGameConst.random_score)
		end

		local var11_7 = var5_7 * var3_7

		arg0_4:addScore(var11_7, var9_7)
		arg0_4:showScore(var11_7, var2_7, var6_7)

		if arg1_7.serveData.battleData.double_score == 8 then
			if var1_7 and var7_7 and var7_7 % 2 == 0 then
				arg0_4:addScore(var11_7, var9_7)
				LeanTween.delayedCall(go(arg0_4._tf), 0.5, System.Action(function()
					arg0_4:showScore(var11_7, var2_7, 2)
				end))
			end
		elseif arg1_7.serveData.battleData.half_double and var1_7 and math.random() > 0.5 then
			arg0_4:addScore(var11_7, var9_7)
			LeanTween.delayedCall(go(arg0_4._tf), 0.5, System.Action(function()
				arg0_4:showScore(var11_7, var2_7, 2)
			end))
		end
	end)
	arg0_4:bind(CookGameView.EXTEND_EVENT, function(arg0_10, arg1_10, arg2_10)
		if arg0_4.judgesController then
			arg0_4.judgesController:extend()
		end

		arg0_4.waitingExtendTime = false
		arg0_4.extendTime = var8_0.extend_time
		arg0_4.gameTime = 0
	end)
end

function var0_0.showScore(arg0_11, arg1_11, arg2_11, arg3_11)
	if arg1_11 == 0 then
		return
	end

	local var0_11

	if #arg0_11.showScoresPool > 0 then
		var0_11 = table.remove(arg0_11.showScoresPool, 1)
	else
		var0_11 = tf(Instantiate(arg0_11.showScoreTpl))

		setParent(var0_11, arg0_11.sceneFrontContainer)
		GetComponent(findTF(var0_11, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			for iter0_12 = #arg0_11.showScores, 1, -1 do
				if var0_11 == arg0_11.showScores[iter0_12] then
					setActive(var0_11, false)
					table.insert(arg0_11.showScoresPool, table.remove(arg0_11.showScores, iter0_12))
				end
			end
		end)
	end

	var0_11.anchoredPosition = arg0_11.sceneFrontContainer:InverseTransformPoint(arg2_11)

	setText(findTF(var0_11, "anim/text_sub"), "" .. tostring(arg1_11))
	setText(findTF(var0_11, "anim/text_add"), "+" .. tostring(arg1_11))

	if arg1_11 > 0 then
		setActive(findTF(var0_11, "anim/text_sub"), false)
		setActive(findTF(var0_11, "anim/text_add"), true)
	else
		setActive(findTF(var0_11, "anim/text_sub"), true)
		setActive(findTF(var0_11, "anim/text_add"), false)
	end

	setActive(var0_11, false)
	setActive(var0_11, true)
	table.insert(arg0_11.showScores, var0_11)
end

function var0_0.onEventHandle(arg0_13, arg1_13)
	return
end

function var0_0.initData(arg0_14)
	local var0_14 = Application.targetFrameRate or 60

	if var0_14 > 60 then
		var0_14 = 60
	end

	arg0_14.timer = Timer.New(function()
		arg0_14:onTimer()
	end, 1 / var0_14, -1)
	arg0_14.showScores = {}
	arg0_14.showScoresPool = {}
	arg0_14.dropData = pg.mini_game[arg0_14:GetMGData().id].simple_config_data.drop_ids
	var8_0.playerChar = nil
	var8_0.partnerChar = nil
	var8_0.partnerPet = nil
	var8_0.enemy1Char = nil
	var8_0.enemy2Char = nil
	var8_0.enemyPet = nil
	arg0_14.selectPlayer = true
	arg0_14.selectPartner = false
end

function var0_0.initUI(arg0_16)
	arg0_16.backSceneTf = findTF(arg0_16._tf, "scene_background")
	arg0_16.sceneContainer = findTF(arg0_16._tf, "sceneMask/sceneContainer")
	arg0_16.sceneFrontContainer = findTF(arg0_16._tf, "sceneMask/sceneContainer/scene_front")
	arg0_16.clickMask = findTF(arg0_16._tf, "clickMask")
	arg0_16.bg = findTF(arg0_16._tf, "bg")
	arg0_16.countUI = findTF(arg0_16._tf, "pop/CountUI")
	arg0_16.countAnimator = GetComponent(findTF(arg0_16.countUI, "count"), typeof(Animator))
	arg0_16.countDft = GetOrAddComponent(findTF(arg0_16.countUI, "count"), typeof(DftAniEvent))

	arg0_16.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_16.countDft:SetEndEvent(function()
		setActive(arg0_16.countUI, false)
		arg0_16:gameStart()
	end)

	arg0_16.leaveUI = findTF(arg0_16._tf, "pop/LeaveUI")

	onButton(arg0_16, findTF(arg0_16.leaveUI, "ad/btnOk"), function()
		arg0_16:resumeGame()
		arg0_16:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.leaveUI, "ad/btnCancel"), function()
		arg0_16:resumeGame()
	end, SFX_CANCEL)
	setActive(arg0_16.leaveUI, false)

	arg0_16.pauseUI = findTF(arg0_16._tf, "pop/pauseUI")

	onButton(arg0_16, findTF(arg0_16.pauseUI, "ad/btnOk"), function()
		setActive(arg0_16.pauseUI, false)
		arg0_16:resumeGame()
	end, SFX_CANCEL)

	arg0_16.settlementUI = findTF(arg0_16._tf, "pop/SettleMentUI")

	onButton(arg0_16, findTF(arg0_16.settlementUI, "ad/btnOver"), function()
		setActive(arg0_16.settlementUI, false)
		arg0_16:openMenuUI()
	end, SFX_CANCEL)
	setActive(arg0_16.settlementUI, false)

	arg0_16.menuUI = findTF(arg0_16._tf, "pop/menuUI")
	arg0_16.battleScrollRect = GetComponent(findTF(arg0_16.menuUI, "battList"), typeof(ScrollRect))
	arg0_16.totalTimes = arg0_16:getGameTotalTime()

	local var0_16 = arg0_16:getGameUsedTimes() - 4 < 0 and 0 or arg0_16:getGameUsedTimes() - 4

	scrollTo(arg0_16.battleScrollRect, 0, 1 - var0_16 / (arg0_16.totalTimes - 4))
	onButton(arg0_16, findTF(arg0_16.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_23 = arg0_16.battleScrollRect.normalizedPosition.y + 1 / (arg0_16.totalTimes - 4)

		if var0_23 > 1 then
			var0_23 = 1
		end

		scrollTo(arg0_16.battleScrollRect, 0, var0_23)
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_24 = arg0_16.battleScrollRect.normalizedPosition.y - 1 / (arg0_16.totalTimes - 4)

		if var0_24 < 0 then
			var0_24 = 0
		end

		scrollTo(arg0_16.battleScrollRect, 0, var0_24)
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.menuUI, "adButton/btnBack"), function()
		arg0_16:closeView()
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_16:getGameRoomData().game_help
		})
	end, SFX_CANCEL)
	onButton(arg0_16, findTF(arg0_16.menuUI, "btnStart"), function()
		setActive(arg0_16.menuUI, false)
		arg0_16:openCoinLayer(false)
		arg0_16:openSelectUI()
	end, SFX_CANCEL)

	local var1_16 = findTF(arg0_16.menuUI, "tplBattleItem")

	arg0_16.battleItems = {}
	arg0_16.dropItems = {}

	for iter0_16 = 1, 7 do
		local var2_16 = tf(instantiate(var1_16))

		var2_16.name = "battleItem_" .. iter0_16

		setParent(var2_16, findTF(arg0_16.menuUI, "battList/Viewport/Content"))

		local var3_16 = iter0_16

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, "battleDesc" .. var3_16, function(arg0_28)
			if arg0_28 then
				setImageSprite(findTF(var2_16, "state_open/desc"), arg0_28, true)
				setImageSprite(findTF(var2_16, "state_clear/desc"), arg0_28, true)
				setImageSprite(findTF(var2_16, "state_current/desc"), arg0_28, true)
				setImageSprite(findTF(var2_16, "state_closed/desc"), arg0_28, true)
			end
		end)

		local var4_16 = findTF(var2_16, "icon")
		local var5_16 = {
			type = arg0_16.dropData[iter0_16][1],
			id = arg0_16.dropData[iter0_16][2],
			amount = arg0_16.dropData[iter0_16][3]
		}

		updateDrop(var4_16, var5_16)
		onButton(arg0_16, var4_16, function()
			arg0_16:emit(BaseUI.ON_DROP, var5_16)
		end, SFX_PANEL)
		table.insert(arg0_16.dropItems, var4_16)
		setActive(var2_16, true)
		table.insert(arg0_16.battleItems, var2_16)
	end

	arg0_16.selectUI = findTF(arg0_16._tf, "pop/selectUI")
	arg0_16.selectCharTpl = findTF(arg0_16.selectUI, "ad/charTpl")

	setActive(arg0_16.selectCharTpl, false)

	arg0_16.selectCharsContainer = findTF(arg0_16.selectUI, "ad/chars/Viewport/Content")
	arg0_16.selectCharId = nil
	arg0_16.selectChars = {}

	local var6_16 = #CookGameConst.char_ids
	local var7_16 = findTF(arg0_16.selectUI, "ad/charDetail")

	arg0_16.detailDescPositons = {}

	for iter1_16 = 1, var6_16 do
		local var8_16 = CookGameConst.char_ids[iter1_16]
		local var9_16 = arg0_16:getCharDataById(var8_16)
		local var10_16 = tf(instantiate(arg0_16.selectCharTpl))

		setParent(var10_16, arg0_16.selectCharsContainer)

		if var9_16 then
			local var11_16 = var9_16.icon
			local var12_16 = var9_16.pos
			local var13_16 = pg.gametip[var9_16.desc].tip
			local var14_16 = pg.ship_data_statistics[var9_16.ship_id].name

			setScrollText(findTF(var10_16, "name/text"), var14_16)
			setActive(findTF(var10_16, "desc"), false)
			setActive(findTF(var10_16, "desc_en"), false)

			if PLATFORM_CODE == PLATFORM_US then
				setActive(findTF(var10_16, "desc_en"), true)
				setText(findTF(var10_16, "desc_en"), var13_16)
			else
				setActive(findTF(var10_16, "desc"), true)
				setText(findTF(var10_16, "desc"), var13_16)
			end

			local var15_16 = findTF(var10_16, "detailDesc")

			setActive(var15_16, false)

			if var9_16.detail_name then
				arg0_16.detailDescPositons[var9_16.detail_name] = var15_16.anchoredPosition

				setText(findTF(var15_16, "name"), i18n(var9_16.detail_name))
				setText(findTF(var15_16, "desc"), i18n(var9_16.detail_desc))
				setActive(findTF(var10_16, "clickDesc"), true)
				onButton(arg0_16, findTF(var10_16, "clickDesc"), function()
					local var0_30 = isActive(var15_16)
					local var1_30

					if not var0_30 then
						var1_30 = var7_16:InverseTransformPoint(var15_16.position)

						setParent(var15_16, var7_16)

						arg0_16.detailDescTf = var15_16
						arg0_16.detailDescContent = var10_16
						arg0_16.detailDescName = var9_16.detail_name
					else
						var1_30 = arg0_16.detailDescPositons[var9_16.detail_name]

						setParent(var15_16, var10_16)

						arg0_16.detailDescTf = nil
						arg0_16.detailDescContent = nil
						arg0_16.detailDescName = nil
					end

					var15_16.anchoredPosition = var1_30

					setActive(var15_16, not var0_30)
				end)
			end

			GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var11_16, function(arg0_31)
				local var0_31 = findTF(var10_16, "icon/img")

				setActive(var0_31, true)

				var0_31.anchoredPosition = var12_16

				setImageSprite(var0_31, arg0_31, true)
			end)
			setActive(findTF(var10_16, "selected"), false)
			onButton(arg0_16, findTF(var10_16, "click"), function()
				arg0_16:selectChar(var9_16.id)
			end, SFX_PANEL)
		else
			GetComponent(var10_16, typeof(CanvasGroup)).alpha = 0
		end

		setActive(var10_16, true)
		table.insert(arg0_16.selectChars, {
			data = var9_16,
			tf = var10_16
		})
	end

	arg0_16.playerTf = findTF(arg0_16.selectUI, "ad/player")
	arg0_16.partnerTf = findTF(arg0_16.selectUI, "ad/partner")
	arg0_16.selectClickTf = findTF(arg0_16.selectUI, "ad/click")

	setActive(arg0_16.selectClickTf, false)
	onButton(arg0_16, findTF(arg0_16.selectUI, "ad/btnStart"), function()
		if var8_0.playerChar and var8_0.partnerChar then
			arg0_16:randomAIShip()
			setActive(arg0_16.selectUI, false)
			arg0_16:readyStart()
		end
	end, SFX_PANEL)
	onButton(arg0_16, findTF(arg0_16.selectUI, "ad/player"), function()
		arg0_16.selectPlayer = true
		arg0_16.selectPartner = false

		arg0_16:updateSelectUI()
	end, SFX_PANEL)
	onButton(arg0_16, findTF(arg0_16.selectUI, "ad/partner"), function()
		arg0_16.selectPlayer = false
		arg0_16.selectPartner = true

		arg0_16:updateSelectUI()
	end, SFX_PANEL)
	onButton(arg0_16, findTF(arg0_16.selectUI, "ad/back"), function()
		setActive(arg0_16.selectUI, false)
		arg0_16:openMenuUI()
	end, SFX_PANEL)

	arg0_16.pageMax = math.ceil(var6_16 / var7_0) - 1
	arg0_16.curPageIndex = 0
	arg0_16.scrollNum = 1 / arg0_16.pageMax
	arg0_16.scrollRect = GetComponent(findTF(arg0_16.selectUI, "ad/chars"), typeof(ScrollRect))
	arg0_16.scrollRect.normalizedPosition = Vector2(0, 0)

	arg0_16.scrollRect.onValueChanged:Invoke(Vector2(0, 0))

	arg0_16.scrollRect.normalizedPosition = Vector2(0, 0)

	arg0_16.scrollRect.onValueChanged:Invoke(Vector2(0, 0))
	GetOrAddComponent(findTF(arg0_16.selectUI, "ad/chars"), typeof(EventTriggerListener)):AddPointDownFunc(function(arg0_37, arg1_37)
		return
	end)
	arg0_16.scrollRect.onValueChanged:AddListener(function(arg0_38, arg1_38, arg2_38)
		if arg0_16.detailDescTf then
			setActive(arg0_16.detailDescTf, false)
			setParent(arg0_16.detailDescTf, arg0_16.detailDescContent)

			arg0_16.detailDescTf.anchoredPosition = arg0_16.detailDescPositons[arg0_16.detailDescName]
			arg0_16.detailDescTf = nil
			arg0_16.detailDescContent = nil
			arg0_16.detailDescName = nil
		end
	end)
	onButton(arg0_16, findTF(arg0_16.selectUI, "ad/next"), function()
		arg0_16.curPageIndex = arg0_16.curPageIndex + arg0_16.scrollNum

		if arg0_16.curPageIndex > 1 then
			arg0_16.curPageIndex = 1
		end

		arg0_16.scrollRect.normalizedPosition = Vector2(arg0_16.curPageIndex, 0)

		arg0_16.scrollRect.onValueChanged:Invoke(Vector2(arg0_16.curPageIndex, 0))
	end, SFX_PANEL)
	onButton(arg0_16, findTF(arg0_16.selectUI, "ad/pre"), function()
		arg0_16.curPageIndex = arg0_16.curPageIndex - arg0_16.scrollNum

		if arg0_16.curPageIndex < 0 then
			arg0_16.curPageIndex = 0
		end

		arg0_16.scrollRect.normalizedPosition = Vector2(arg0_16.curPageIndex, 0)

		arg0_16.scrollRect.onValueChanged:Invoke(Vector2(arg0_16.curPageIndex, 0))
	end, SFX_PANEL)
	setActive(arg0_16.selectUI, false)

	if not arg0_16.handle and IsUnityEditor then
		arg0_16.handle = UpdateBeat:CreateListener(arg0_16.Update, arg0_16)

		UpdateBeat:AddListener(arg0_16.handle)
	end

	GetComponent(findTF(arg0_16.selectUI, "ad/playerDesc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_16.selectUI, "ad/partnerDesc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_16.pauseUI, "ad/desc"), typeof(Image)):SetNativeSize()
	GetComponent(findTF(arg0_16.leaveUI, "ad/desc"), typeof(Image)):SetNativeSize()
end

function var0_0.initGameUI(arg0_41)
	arg0_41.gameUI = findTF(arg0_41._tf, "ui/gameUI")
	arg0_41.showScoreTpl = findTF(arg0_41.sceneFrontContainer, "score")

	setActive(arg0_41.showScoreTpl, false)
	onButton(arg0_41, findTF(arg0_41.gameUI, "topRight/btnStop"), function()
		arg0_41:stopGame()
		setActive(arg0_41.pauseUI, true)
	end)
	onButton(arg0_41, findTF(arg0_41.gameUI, "btnLeave"), function()
		arg0_41:stopGame()
		setActive(arg0_41.leaveUI, true)
	end)

	arg0_41.gameTimeS = findTF(arg0_41.gameUI, "top/time/s")
	arg0_41.scoreTf = findTF(arg0_41.gameUI, "top/score")
	arg0_41.otherScoreTf = findTF(arg0_41.gameUI, "top/otherScore")
end

function var0_0.initController(arg0_44)
	arg0_44.judgesController = CookGameJudgesController.New(arg0_44.sceneContainer, var8_0, arg0_44)

	local var0_44 = findTF(arg0_44.sceneContainer, "scene_background/charTpl")

	setActive(var0_44, false)

	arg0_44.charController = CookGameCharController.New(arg0_44.sceneContainer, var8_0, arg0_44)
end

function var0_0.Update(arg0_45)
	arg0_45:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_46)
	if arg0_46.gameStop or arg0_46.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_47)
	local var0_47 = arg0_47:getGameUsedTimes()
	local var1_47 = arg0_47:getGameTimes()

	for iter0_47 = 1, #arg0_47.battleItems do
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_open"), false)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_closed"), false)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_clear"), false)
		setActive(findTF(arg0_47.battleItems[iter0_47], "state_current"), false)

		if iter0_47 <= var0_47 then
			SetParent(arg0_47.dropItems[iter0_47], findTF(arg0_47.battleItems[iter0_47], "state_clear/icon"))
			setActive(arg0_47.dropItems[iter0_47], true)
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_clear"), true)
		elseif iter0_47 == var0_47 + 1 and var1_47 >= 1 then
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_current"), true)
			SetParent(arg0_47.dropItems[iter0_47], findTF(arg0_47.battleItems[iter0_47], "state_current/icon"))
			setActive(arg0_47.dropItems[iter0_47], true)
		elseif var0_47 < iter0_47 and iter0_47 <= var0_47 + var1_47 then
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_open"), true)
			SetParent(arg0_47.dropItems[iter0_47], findTF(arg0_47.battleItems[iter0_47], "state_open/icon"))
			setActive(arg0_47.dropItems[iter0_47], true)
		else
			setActive(findTF(arg0_47.battleItems[iter0_47], "state_closed"), true)
			SetParent(arg0_47.dropItems[iter0_47], findTF(arg0_47.battleItems[iter0_47], "state_closed/icon"))
			setActive(arg0_47.dropItems[iter0_47], true)
		end
	end

	arg0_47.totalTimes = arg0_47:getGameTotalTime()

	local var2_47 = 1 - (arg0_47:getGameUsedTimes() - 3 < 0 and 0 or arg0_47:getGameUsedTimes() - 3) / (arg0_47.totalTimes - 4)

	if var2_47 > 1 then
		var2_47 = 1
	end

	scrollTo(arg0_47.battleScrollRect, 0, var2_47)
	setActive(findTF(arg0_47.menuUI, "btnStart/tip"), var1_47 > 0)
	arg0_47:CheckGet()
end

function var0_0.CheckGet(arg0_48)
	setActive(findTF(arg0_48.menuUI, "got"), false)

	if arg0_48:getUltimate() and arg0_48:getUltimate() ~= 0 then
		setActive(findTF(arg0_48.menuUI, "got"), true)
	end

	if arg0_48:getUltimate() == 0 then
		if arg0_48:getGameTotalTime() > arg0_48:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_48:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_48.menuUI, "got"), true)
	end
end

function var0_0.openSelectUI(arg0_49)
	setActive(arg0_49.selectUI, true)

	arg0_49.selectPlayer = true
	arg0_49.selectPartner = false

	arg0_49:updateSelectUI()
end

function var0_0.updateSelectUI(arg0_50)
	local var0_50 = var8_0.playerChar

	if var0_50 then
		local var1_50 = findTF(arg0_50.selectUI, "ad/player/icon/img")
		local var2_50 = arg0_50:getCharData(var0_50, "icon")
		local var3_50 = arg0_50:getCharData(var0_50, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var2_50, function(arg0_51)
			var1_50.anchoredPosition = var3_50

			setActive(var1_50, true)
			setImageSprite(var1_50, arg0_51, true)
		end)
	else
		setActive(findTF(arg0_50.selectUI, "ad/player/icon/img"), false)
	end

	local var4_50 = var8_0.partnerChar

	if var4_50 then
		local var5_50 = findTF(arg0_50.selectUI, "ad/partner/icon/img")
		local var6_50 = arg0_50:getCharData(var4_50, "icon")
		local var7_50 = arg0_50:getCharData(var4_50, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var6_50, function(arg0_52)
			var5_50.anchoredPosition = var7_50

			setActive(var5_50, true)
			setImageSprite(var5_50, arg0_52, true)
		end)
	else
		setActive(findTF(arg0_50.selectUI, "ad/partner/icon/img"), false)
	end

	if arg0_50.selectPlayer then
		setActive(findTF(arg0_50.selectUI, "ad/player/selected"), true)
		setActive(findTF(arg0_50.selectUI, "ad/partner/selected"), false)
	elseif arg0_50.selectPartner then
		setActive(findTF(arg0_50.selectUI, "ad/player/selected"), false)
		setActive(findTF(arg0_50.selectUI, "ad/partner/selected"), true)
	end
end

function var0_0.selectChar(arg0_53, arg1_53)
	arg0_53.selectCharId = arg1_53

	for iter0_53 = 1, #arg0_53.selectChars do
		local var0_53 = arg0_53.selectChars[iter0_53].data

		if var0_53 then
			local var1_53 = arg0_53.selectChars[iter0_53].tf

			if var0_53.id == arg1_53 then
				setActive(findTF(var1_53, "selected"), true)
			else
				setActive(findTF(var1_53, "selected"), false)
			end
		end
	end

	if arg0_53.selectPlayer then
		if var8_0.partnerChar and var8_0.partnerChar == arg1_53 then
			var8_0.partnerChar = var8_0.playerChar or nil
		end

		var8_0.playerChar = arg1_53

		if not var8_0.partnerChar then
			arg0_53.selectPlayer = false
			arg0_53.selectPartner = true
		end
	elseif arg0_53.selectPartner then
		if var8_0.playerChar and var8_0.playerChar == arg1_53 then
			var8_0.playerChar = var8_0.partnerChar
		end

		var8_0.partnerChar = arg1_53

		if not var8_0.playerChar then
			arg0_53.selectPlayer = true
			arg0_53.selectPartner = false
		end
	end

	if var8_0.playerChar and CookGameConst.char_battle_data[var8_0.playerChar].pet then
		var8_0.partnerPet = CookGameConst.char_battle_data[var8_0.playerChar].pet
	elseif var8_0.partnerChar and CookGameConst.char_battle_data[var8_0.partnerChar].pet then
		var8_0.partnerPet = CookGameConst.char_battle_data[var8_0.partnerChar].pet
	else
		var8_0.partnerPet = nil
	end

	arg0_53:updateSelectUI()
end

function var0_0.getCharDataById(arg0_54, arg1_54)
	for iter0_54, iter1_54 in pairs(CookGameConst.char_data) do
		if iter1_54.id == arg1_54 then
			return Clone(iter1_54)
		end
	end

	return nil
end

function var0_0.getCharData(arg0_55, arg1_55, arg2_55)
	for iter0_55 = 1, #CookGameConst.char_data do
		local var0_55 = CookGameConst.char_data[iter0_55]

		if var0_55.id == arg1_55 then
			if not arg2_55 then
				return Clone(var0_55)
			else
				return Clone(var0_55[arg2_55])
			end
		end
	end

	return nil
end

function var0_0.randomAIShip(arg0_56)
	local var0_56 = {}

	for iter0_56, iter1_56 in pairs(CookGameConst.char_battle_data) do
		if iter1_56.extend then
			table.insert(var0_56, iter1_56.id)
		end
	end

	if var8_0.playerChar then
		table.insert(var0_56, var8_0.playerChar)
	end

	if var8_0.partnerChar then
		table.insert(var0_56, var8_0.partnerChar)
	end

	local var1_56 = Clone(CookGameConst.random_ids)

	for iter2_56 = #var1_56, 1, -1 do
		if table.contains(var0_56, var1_56[iter2_56]) then
			table.remove(var1_56, iter2_56)
		end
	end

	var8_0.enemy1Char = table.remove(var1_56, math.random(1, #var1_56))
	var8_0.enemy2Char = table.remove(var1_56, math.random(1, #var1_56))
	var8_0.enemyPet = CookGameConst.char_battle_data[var8_0.enemy1Char].pet or CookGameConst.char_battle_data[var8_0.enemy2Char].pet or nil
end

function var0_0.openMenuUI(arg0_57)
	setActive(findTF(arg0_57.sceneContainer, "scene_front"), false)
	setActive(findTF(arg0_57.sceneContainer, "scene_background"), false)
	setActive(findTF(arg0_57.sceneContainer, "scene"), false)
	setActive(arg0_57.gameUI, false)
	setActive(arg0_57.menuUI, true)
	arg0_57:openCoinLayer(true)
	setActive(arg0_57.bg, true)
	arg0_57:updateMenuUI()
end

function var0_0.clearUI(arg0_58)
	setActive(arg0_58.sceneContainer, false)
	setActive(arg0_58.settlementUI, false)
	setActive(arg0_58.countUI, false)
	setActive(arg0_58.menuUI, false)
	setActive(arg0_58.gameUI, false)
	setActive(arg0_58.selectUI, false)
end

function var0_0.readyStart(arg0_59)
	arg0_59.readyStartFlag = true

	arg0_59:controllerReady()
	setActive(arg0_59.countUI, true)
	arg0_59.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)

	arg0_59.readyStartFlag = false
end

function var0_0.gameStart(arg0_60)
	setActive(findTF(arg0_60.sceneContainer, "scene_front"), true)
	setActive(findTF(arg0_60.sceneContainer, "scene_background"), true)
	setActive(findTF(arg0_60.sceneContainer, "scene"), true)

	GetComponent(findTF(arg0_60.sceneContainer, "scene"), typeof(CanvasGroup)).alpha = 1

	setActive(arg0_60.bg, false)

	arg0_60.sceneContainer.anchoredPosition = Vector2(0, 0)
	arg0_60.offsetPosition = Vector2(0, 0)

	setActive(arg0_60.gameUI, true)

	arg0_60.gameStartFlag = true
	arg0_60.scoreNum = 0
	arg0_60.otherScoreNum = 0
	arg0_60.gameStepTime = 0
	arg0_60.gameTime = var4_0
	arg0_60.extendTime = nil
	arg0_60.waitingExtendTime = false

	if var8_0.playerChar == 6 or var8_0.partnerChar == 6 then
		arg0_60.waitingExtendTime = true
	end

	for iter0_60 = #arg0_60.showScores, 1, -1 do
		if not table.contains(arg0_60.showScoresPool, arg0_60.showScores[iter0_60]) then
			local var0_60 = table.remove(arg0_60.showScores, iter0_60)

			table.insert(arg0_60.showScoresPool, var0_60)
		end
	end

	for iter1_60 = #arg0_60.showScoresPool, 1, -1 do
		setActive(arg0_60.showScoresPool[iter1_60], false)
	end

	local function var1_60(arg0_61, arg1_61)
		local var0_61 = arg0_60:getCharData(arg0_61, "icon")
		local var1_61 = arg0_60:getCharData(arg0_61, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var0_61, function(arg0_62)
			setActive(arg1_61, true)
			setImageSprite(arg1_61, arg0_62, true)
		end)
	end

	var1_60(var8_0.playerChar, findTF(arg0_60.gameUI, "top/leftCharPos/player/img"))
	var1_60(var8_0.partnerChar, findTF(arg0_60.gameUI, "top/leftCharPos/partner/img"))
	var1_60(var8_0.enemy1Char, findTF(arg0_60.gameUI, "top/rightCharPos/enemy1/img"))
	var1_60(var8_0.enemy2Char, findTF(arg0_60.gameUI, "top/rightCharPos/enemy2/img"))
	arg0_60:updateGameUI()
	arg0_60:timerStart()
	arg0_60:controllerStart()
end

function var0_0.controllerReady(arg0_63)
	GetComponent(findTF(arg0_63.sceneContainer, "scene"), typeof(CanvasGroup)).alpha = 0

	setActive(findTF(arg0_63.sceneContainer, "scene"), true)
	arg0_63.charController:readyStart()
end

function var0_0.controllerStart(arg0_64)
	arg0_64.judgesController:start()
	arg0_64.charController:start()
end

function var0_0.getGameTimes(arg0_65)
	return arg0_65:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_66)
	return arg0_66:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_67)
	return arg0_67:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_68)
	return (arg0_68:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_69, arg1_69)
	if arg0_69.judgesController then
		arg0_69.judgesController:changeSpeed(arg1_69)
	end

	if arg0_69.charController then
		arg0_69.charController:changeSpeed(arg1_69)
	end
end

function var0_0.onTimer(arg0_70)
	arg0_70:gameStep()
end

function var0_0.gameStep(arg0_71)
	if arg0_71.gameTime and arg0_71.gameTime > 3 and arg0_71.gameTime - Time.deltaTime < 3 and var8_0.playerChar ~= 6 and var8_0.playerChar ~= 6 then
		arg0_71.judgesController:timeUp()
	end

	if arg0_71.extendTime and arg0_71.extendTime > 3 and arg0_71.extendTime - Time.deltaTime < 3 then
		arg0_71.judgesController:timeUp()
	end

	arg0_71.gameTime = arg0_71.gameTime - Time.deltaTime

	if arg0_71.gameTime < 0 then
		arg0_71.gameTime = 0
	end

	var8_0.gameTime = arg0_71.gameTime

	if arg0_71.extendTime and arg0_71.extendTime > 0 then
		arg0_71.extendTime = arg0_71.extendTime - Time.deltaTime

		if arg0_71.extendTime < 0 then
			arg0_71.extendTime = 0
		end
	end

	arg0_71.gameStepTime = arg0_71.gameStepTime + Time.deltaTime

	arg0_71:controllerStep(Time.deltaTime)
	arg0_71:updateGameUI()

	if not arg0_71.waitingExtendTime and arg0_71.gameTime <= 0 then
		if arg0_71.extendTime then
			if arg0_71.extendTime <= 0 then
				arg0_71:onGameOver()
			end
		else
			arg0_71:onGameOver()
		end

		return
	end
end

function var0_0.controllerStep(arg0_72, arg1_72)
	arg0_72.judgesController:step(arg1_72)
	arg0_72.charController:step(arg1_72)
end

function var0_0.timerStart(arg0_73)
	if not arg0_73.timer.running then
		arg0_73.timer:Start()
	end
end

function var0_0.timerStop(arg0_74)
	if arg0_74.timer.running then
		arg0_74.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_75)
	setText(arg0_75.scoreTf, arg0_75.scoreNum)
	setText(arg0_75.otherScoreTf, arg0_75.otherScoreNum)

	if arg0_75.extendTime and arg0_75.extendTime > 0 then
		setText(arg0_75.gameTimeS, math.ceil(arg0_75.extendTime))
	else
		setText(arg0_75.gameTimeS, math.ceil(arg0_75.gameTime))
	end
end

function var0_0.addScore(arg0_76, arg1_76, arg2_76)
	if arg2_76 then
		arg0_76.otherScoreNum = arg0_76.otherScoreNum + arg1_76

		if arg0_76.otherScoreNum < 0 then
			arg0_76.otherScoreNum = 0
		end
	else
		arg0_76.scoreNum = arg0_76.scoreNum + arg1_76

		if arg0_76.scoreNum < 0 then
			arg0_76.scoreNum = 0
		end
	end
end

function var0_0.onGameOver(arg0_77)
	if arg0_77.settlementFlag then
		return
	end

	arg0_77:timerStop()
	arg0_77:controllerClear()

	arg0_77.settlementFlag = true

	setActive(arg0_77.clickMask, true)
	LeanTween.delayedCall(go(arg0_77._tf), 0.1, System.Action(function()
		arg0_77.settlementFlag = false
		arg0_77.gameStartFlag = false

		setActive(arg0_77.clickMask, false)
		arg0_77:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_79)
	setActive(arg0_79.settlementUI, true)
	GetComponent(findTF(arg0_79.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_79 = arg0_79.scoreNum
	local var1_79 = getProxy(GameRoomProxy):getRoomScore(arg0_79:getGameRoomData().id)
	local var2_79 = arg0_79.otherScoreNum or 0

	setActive(findTF(arg0_79.settlementUI, "ad/new"), var1_79 < var0_79)

	if var1_79 <= var0_79 then
		var1_79 = var0_79

		arg0_79:StoreDataToServer({
			var1_79
		})
	end

	local var3_79 = findTF(arg0_79.settlementUI, "ad/highText")
	local var4_79 = findTF(arg0_79.settlementUI, "ad/currentText")
	local var5_79 = findTF(arg0_79.settlementUI, "ad/otherText")

	setText(var3_79, var1_79)
	setText(var4_79, var0_79)
	setText(var5_79, var2_79)

	if arg0_79:getGameTimes() and arg0_79:getGameTimes() > 0 then
		arg0_79.sendSuccessFlag = true

		arg0_79:SendSuccess(var0_79)
	end

	if var2_79 < var0_79 then
		setActive(findTF(arg0_79.settlementUI, "ad/win"), true)
		setActive(findTF(arg0_79.settlementUI, "ad/defeat"), false)
	elseif var0_79 < var2_79 then
		setActive(findTF(arg0_79.settlementUI, "ad/win"), false)
		setActive(findTF(arg0_79.settlementUI, "ad/defeat"), true)
	else
		setActive(findTF(arg0_79.settlementUI, "ad/win"), false)
		setActive(findTF(arg0_79.settlementUI, "ad/defeat"), false)
	end

	local var6_79 = {}

	table.insert(var6_79, {
		name = "player",
		char_id = var8_0.playerChar
	})
	table.insert(var6_79, {
		name = "partner",
		char_id = var8_0.partnerChar
	})
	table.insert(var6_79, {
		name = "enemy1",
		char_id = var8_0.enemy1Char
	})
	table.insert(var6_79, {
		name = "enemy2",
		char_id = var8_0.enemy2Char
	})

	for iter0_79 = 1, #var6_79 do
		local var7_79 = var6_79[iter0_79].char_id
		local var8_79 = findTF(arg0_79.settlementUI, "ad/" .. var6_79[iter0_79].name)
		local var9_79 = arg0_79:getCharData(var7_79, "icon")
		local var10_79 = arg0_79:getCharData(var7_79, "pos")

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var5_0, var9_79, function(arg0_80)
			local var0_80 = findTF(var8_79, "mask/img")

			setActive(var0_80, true)

			var0_80.anchoredPosition = var10_79

			setImageSprite(var0_80, arg0_80, true)
		end)
	end
end

function var0_0.OnApplicationPaused(arg0_81)
	if not arg0_81.gameStartFlag then
		return
	end

	if arg0_81.readyStartFlag then
		return
	end

	if arg0_81.settlementFlag then
		return
	end

	if isActive(arg0_81.pauseUI) or isActive(arg0_81.leaveUI) then
		return
	end

	if not isActive(arg0_81.pauseUI) then
		setActive(arg0_81.pauseUI, true)
	end

	arg0_81:stopGame()
end

function var0_0.controllerClear(arg0_82)
	arg0_82.judgesController:clear()
	arg0_82.charController:clear()
end

function var0_0.resumeGame(arg0_83)
	arg0_83.gameStop = false

	setActive(arg0_83.leaveUI, false)
	arg0_83:changeSpeed(1)
	arg0_83:timerStart()
end

function var0_0.stopGame(arg0_84)
	arg0_84.gameStop = true

	arg0_84:timerStop()
	arg0_84:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_85)
	if arg0_85.readyStartFlag then
		return
	end

	if not arg0_85.gameStartFlag then
		arg0_85:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_85.settlementFlag then
			return
		end

		if isActive(arg0_85.pauseUI) then
			setActive(arg0_85.pauseUI, false)
		end

		arg0_85:stopGame()
		setActive(arg0_85.leaveUI, true)
	end
end

function var0_0.willExit(arg0_86)
	if arg0_86.cookGameUIAtlasStored then
		AssetBundleHelper.UnstoreAssetBundle(var8_0.path, true)

		arg0_86.cookGameUIAtlasStored = false
	end

	if arg0_86.handle then
		UpdateBeat:RemoveListener(arg0_86.handle)
	end

	if arg0_86._tf and LeanTween.isTweening(go(arg0_86._tf)) then
		LeanTween.cancel(go(arg0_86._tf))
	end

	arg0_86:destroyController()

	if arg0_86.timer and arg0_86.timer.running then
		arg0_86.timer:Stop()
	end

	arg0_86.scrollRect.onValueChanged:RemoveAllListeners()

	Time.timeScale = 1
	arg0_86.timer = nil
end

function var0_0.destroyController(arg0_87)
	return
end

return var0_0

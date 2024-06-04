local var0 = class("VolleyballGameView", import("..BaseMiniGameView"))
local var1 = {
	"maliluosi_2_DOA",
	"suixiang_2_doa",
	"xia_2_DOA",
	"haixiao_2_DOA",
	"zhixiao_2_DOA",
	"nvtiangou_2_DOA",
	"monika_2_DOA"
}
local var2 = {
	10600010,
	10600020,
	10600030,
	10600040,
	10600050,
	10600060,
	10600070
}
local var3 = 1
local var4 = 2
local var5 = -1
local var6 = 0
local var7 = 0.35
local var8 = 0.15
local var9 = 0
local var10 = 1
local var11 = 2
local var12 = 0
local var13 = 1
local var14 = 2
local var15 = 1.5
local var16 = 1
local var17 = 0.5
local var18 = 0.5
local var19 = 0.43
local var20 = 0.5
local var21 = 0.76
local var22 = 0.83
local var23 = -30
local var24 = 50
local var25 = 60
local var26 = 230
local var27 = 60
local var28 = "event:/ui/ddldaoshu2"
local var29 = "event:/ui/fighterplane_click"
local var30 = "event:/ui/jieqiu"
local var31 = "event:/ui/kouqiu"
local var32 = 0.8
local var33 = -1000

function var0.getUIName(arg0)
	return "VolleyballGameUI"
end

function var0.init(arg0)
	arg0.countTimeUI = arg0:findTF("count_time_ui")
	arg0.countTimeImage = arg0:findTF("time", arg0.countTimeUI)
	arg0.countTimeNumImage = arg0:findTF("nums", arg0.countTimeUI)
	arg0.mainUI = arg0:findTF("main_ui")
	arg0.returnBtn = arg0:findTF("return_btn", arg0.mainUI)
	arg0.mainStartBtn = arg0:findTF("start_btn", arg0.mainUI)
	arg0.ruleBtn = arg0:findTF("rule_btn", arg0.mainUI)
	arg0.progressScroll = arg0:findTF("right_panel/scroll_view/", arg0.mainUI)
	arg0.progressContent = arg0:findTF("right_panel/scroll_view/viewport/content", arg0.mainUI)
	arg0.colors = arg0:findTF("right_panel/colors", arg0.mainUI)
	arg0.icons = arg0:findTF("right_panel/icons", arg0.mainUI)
	arg0.gotIcon = arg0:findTF("bg/got", arg0.mainUI)
	arg0.selectUI = arg0:findTF("select_ui")
	arg0.selectBackBtn = arg0:findTF("back_btn", arg0.selectUI)
	arg0.selectStartBtn = arg0:findTF("start_btn", arg0.selectUI)
	arg0.tags = arg0:findTF("select_panel/tags", arg0.selectUI)
	arg0.paints = arg0:findTF("select_panel/paints", arg0.selectUI)
	arg0.freeTitle = arg0:findTF("select_panel/title/free", arg0.selectUI)
	arg0.dayTitle = arg0:findTF("select_panel/title/challenge", arg0.selectUI)
	arg0.titleDayNum = arg0:findTF("select_panel/title/challenge/num", arg0.selectUI)
	arg0.ruleTxt = arg0:findTF("select_panel/rule/rule_txt", arg0.selectUI)
	arg0.select4Chars = arg0:findTF("select_panel/chars", arg0.selectUI)
	arg0.selectWindow = arg0:findTF("select_windows", arg0.selectUI)
	arg0.selectSureBtn = arg0:findTF("windows/sure_btn", arg0.selectWindow)
	arg0.select9Chars = arg0:findTF("windows/char_layout", arg0.selectWindow)
	arg0.selectNum = arg0:findTF("windows/tips/num", arg0.selectWindow)
	arg0.gameUI = arg0:findTF("game_ui")
	arg0.bgEffect = arg0:findTF("bg/shatanpaiqiu_hailang", arg0.gameUI)
	arg0.hitEffect = arg0:findTF("shatanpaiqiu_jida", arg0.gameUI)
	arg0.upEffect = arg0:findTF("shatanpaiqiu_jieqiu", arg0.gameUI)
	arg0.ball = arg0:findTF("ball", arg0.gameUI)
	arg0.ballShadow = arg0:findTF("ball_shadow", arg0.gameUI)
	arg0.pauseBtn = arg0:findTF("pause_btn", arg0.gameUI)
	arg0.backBtn = arg0:findTF("back_btn", arg0.gameUI)
	arg0.qteBtn = arg0:findTF("qte_btn", arg0.gameUI)
	arg0.pos = arg0:findTF("pos", arg0.gameUI)

	arg0:initPos()

	arg0.ourScore = arg0:findTF("score/our", arg0.gameUI)
	arg0.enemyScore = arg0:findTF("score/enemy", arg0.gameUI)
	arg0.qte = arg0:findTF("qte", arg0.gameUI)
	arg0.qteCircles = arg0:findTF("circles", arg0.qte)
	arg0.qteCircle = arg0:findTF("circles/big", arg0.qte)
	arg0.result = arg0:findTF("result", arg0.qte)
	arg0.resultTxt = arg0:findTF("txts", arg0.qte)
	arg0.cutin = arg0:findTF("cutin", arg0.gameUI)
	arg0.cutinPaint = arg0:findTF("cutin/paint", arg0.gameUI)
	arg0.cutinPaints = arg0:findTF("cutin_paints", arg0.gameUI)
	arg0.scoreCutin = arg0:findTF("score_cutin", arg0.gameUI)
	arg0.scoreCutinNums = arg0:findTF("score_cutin/nums", arg0.gameUI)
	arg0.ourScoreCutin = arg0:findTF("score_cutin/our", arg0.gameUI)
	arg0.enemyScoreCutin = arg0:findTF("score_cutin/enemy", arg0.gameUI)
	arg0.charTF = {}
	arg0.charTF.our1 = arg0:findTF("char/our1", arg0.gameUI)
	arg0.charTF.our2 = arg0:findTF("char/our2", arg0.gameUI)
	arg0.charTF.enemy1 = arg0:findTF("char/enemy1", arg0.gameUI)
	arg0.charTF.enemy2 = arg0:findTF("char/enemy2", arg0.gameUI)
	arg0.charModels = {}
	arg0.charactor = {}
	arg0.cutinMask = arg0:findTF("cutin_mask", arg0.gameUI)
	arg0.endUI = arg0:findTF("end_ui")
	arg0.endDayTitle = arg0:findTF("title/race", arg0.endUI)
	arg0.endFreeTitle = arg0:findTF("title/free", arg0.endUI)
	arg0.endTitleDay = arg0:findTF("title/race/num", arg0.endUI)
	arg0.titleDays = arg0:findTF("title_days", arg0.endUI)
	arg0.endOurScore = arg0:findTF("score_panel/score/our", arg0.endUI)
	arg0.endEnemyScore = arg0:findTF("score_panel/score/enemy", arg0.endUI)
	arg0.endScoreNums = arg0:findTF("nums", arg0.endUI)
	arg0.sureBtn = arg0:findTF("sure_btn", arg0.endUI)
	arg0.winTag = arg0:findTF("score_panel/score/win", arg0.endUI)
	arg0.loseTag = arg0:findTF("score_panel/score/lose", arg0.endUI)
	arg0.helpUI = arg0:findTF("help_ui")
end

function var0.initPos(arg0)
	arg0.orgPos = {}
	arg0.orgPos.our_serve = arg0:findTF("our_pos/serve_pos", arg0.pos).anchoredPosition
	arg0.orgPos.our1 = arg0:findTF("our_pos/drop_pos1", arg0.pos).anchoredPosition
	arg0.orgPos.our2 = arg0:findTF("our_pos/drop_pos2", arg0.pos).anchoredPosition
	arg0.orgPos.enemy_serve = arg0:findTF("enemy_pos/serve_pos", arg0.pos).anchoredPosition
	arg0.orgPos.enemy1 = arg0:findTF("enemy_pos/drop_pos1", arg0.pos).anchoredPosition
	arg0.orgPos.enemy2 = arg0:findTF("enemy_pos/drop_pos2", arg0.pos).anchoredPosition

	arg0:resetPos()
end

function var0.resetPos(arg0)
	arg0.anchoredPos = Clone(arg0.orgPos)
	arg0.anchoredPos.our1 = arg0:getRandomPos("our1")
	arg0.anchoredPos.our2 = arg0:getRandomPos("our2")
	arg0.anchoredPos.enemy1 = arg0:getRandomPos("enemy1")
	arg0.anchoredPos.enemy2 = arg0:getRandomPos("enemy2")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.returnBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.ruleBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("venusvolleyball_help")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.mainStartBtn, function()
		setActive(arg0.selectUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0.selectUI)
		arg0:initSelectUI()
	end, SFX_PANEL)
	onButton(arg0, arg0.selectBackBtn, function()
		setActive(arg0.selectUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.selectUI, arg0._tf)
	end, SFX_PANEL)

	arg0.canStartGame = false

	onButton(arg0, arg0.selectStartBtn, function()
		if not arg0.canStartGame then
			return
		end

		setActive(arg0.mainUI, false)
		setActive(arg0.selectUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.selectUI, arg0._tf)
		setActive(arg0.gameUI, true)
		arg0:resetGameData()

		if arg0.isFirstgame == 0 then
			arg0:firstShow(function()
				arg0:startCountTimer()
			end)
		else
			arg0:startCountTimer()
		end
	end, SFX_PANEL)

	arg0.canSureChar = false

	onButton(arg0, arg0.selectSureBtn, function()
		if not arg0.canSureChar then
			return
		end

		if arg0.selectCharCamp == "enemy" then
			arg0.charNames.enemy1 = var1[arg0.selectSDIndex1]
			arg0.charNames.enemy2 = var1[arg0.selectSDIndex2]
		elseif arg0.selectCharCamp == "our" then
			arg0.charNames.our1 = var1[arg0.selectSDIndex1]
			arg0.charNames.our2 = var1[arg0.selectSDIndex2]
		end

		setActive(arg0.selectWindow, false)
		arg0:refreshSelectUI()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("mask", arg0.selectWindow), function()
		setActive(arg0.selectWindow, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.pauseBtn, function()
		if not arg0.btnAvailable then
			return
		end

		arg0:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("venusvolleyball_suspend_tip"),
			onNo = function()
				arg0:resumeGame()
			end,
			onYes = function()
				arg0:resumeGame()
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		if not arg0.btnAvailable then
			return
		end

		arg0:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("venusvolleyball_return_tip"),
			onNo = function()
				arg0:resumeGame()
			end,
			onYes = function()
				arg0:endGame()
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.qteBtn, function()
		if arg0.qteBtnStatus == var5 then
			return
		end

		arg0:qteResult()
	end)
	onButton(arg0, arg0.sureBtn, function()
		setActive(arg0.mainUI, true)
		arg0:initMainUI()
		setActive(arg0.gameUI, false)
		setActive(arg0.endUI, false)
		arg0:clearSpineChars()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.endUI, arg0._tf)
	end, SFX_PANEL)
	arg0:initMainUI()
end

function var0.playEffect(arg0, arg1, arg2)
	if arg2 then
		arg1.anchoredPosition = arg2
	else
		arg1.anchoredPosition = arg0.ball.anchoredPosition
	end

	setActive(arg1, false)
	setActive(arg1, true)
end

function var0.getGameData(arg0)
	arg0.mgProxy = getProxy(MiniGameProxy)
	arg0.hubData = arg0.mgProxy:GetHubByHubId(13)
	arg0.curDay = arg0.hubData.ultimate == 0 and arg0.hubData.usedtime + 1 or 8
	arg0.unlockDay = arg0.hubData.usedtime + arg0.hubData.count
	arg0.curDay = arg0.curDay <= arg0.unlockDay and arg0.curDay or arg0.unlockDay
	arg0.mgData = arg0.mgProxy:GetMiniGameData(17)
	arg0.endScore = arg0.mgData:GetSimpleValue("endScore")[arg0.curDay]
	arg0.storylist = arg0.mgData:GetSimpleValue("story")

	local var0 = getProxy(PlayerProxy):getData().id

	arg0.isFirstgame = PlayerPrefs.GetInt("volleyballgame_first_" .. var0)
end

function var0.getEnemyCharsIndex(arg0)
	return arg0.mgData:GetSimpleValue("mainChar")[arg0.curDay], arg0.mgData:GetSimpleValue("minorChar")[arg0.curDay]
end

function var0.initMainUI(arg0)
	arg0.isInGame = false

	arg0:getGameData()

	if arg0.hubData.ultimate == 0 and arg0.hubData.usedtime >= arg0.hubData:getConfig("reward_need") then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0.hubData.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end

	arg0.isFree = arg0.hubData.ultimate ~= 0 and true or false

	setActive(arg0:findTF("free_tag", arg0.mainStartBtn), arg0.isFree)
	setActive(arg0.gotIcon, arg0.isFree)
	eachChild(arg0.progressContent, function(arg0)
		local var0 = ""
		local var1 = tonumber(arg0.name)
		local var2 = var1[arg0.mgData:GetSimpleValue("mainChar")[var1]]

		setActive(arg0:findTF("char_bg/mask", arg0), false)
		setActive(arg0:findTF("name_bg/mask", arg0), false)
		setActive(arg0:findTF("pass", arg0), false)

		if var1 == arg0.curDay and arg0.hubData.count > 0 then
			var0 = "red"

			setImageSprite(arg0:findTF("char_bg/icon", arg0), arg0.icons:Find(arg0:getCharIndex(var2)):GetComponent(typeof(Image)).sprite, true)
		elseif var1 < arg0.curDay or var1 == arg0.curDay and arg0.hubData.count == 0 then
			var0 = "grey"

			setImageSprite(arg0:findTF("char_bg/icon", arg0), arg0.icons:Find(arg0:getCharIndex(var2)):GetComponent(typeof(Image)).sprite, true)
			setActive(arg0:findTF("char_bg/mask", arg0), true)
			setActive(arg0:findTF("name_bg/mask", arg0), true)
			setActive(arg0:findTF("pass", arg0), true)
		elseif var1 > arg0.curDay and var1 <= arg0.unlockDay then
			var0 = "blue"

			setImageSprite(arg0:findTF("char_bg/icon", arg0), arg0.icons:Find(arg0:getCharIndex(var2)):GetComponent(typeof(Image)).sprite, true)
		else
			var0 = "grey"

			setImageSprite(arg0:findTF("char_bg/icon", arg0), arg0.colors:Find("unkonwn"):GetComponent(typeof(Image)).sprite)
		end

		setImageSprite(arg0:findTF("name_bg", arg0), arg0.colors:Find(var0):GetComponent(typeof(Image)).sprite)
	end)

	local var0 = 215
	local var1 = math.min(645, (arg0.curDay - 1) * var0)

	arg0.progressContent.anchoredPosition = {
		x = 0,
		y = var1
	}

	onScroll(arg0, arg0.progressScroll, function(arg0)
		setActive(arg0:findTF("right_panel/arraws_up", arg0.mainUI), arg0.y < 1 and true or false)
		setActive(arg0:findTF("right_panel/arraws_down", arg0.mainUI), arg0.y > 0 and true or false)
	end)
end

function var0.initSelectUI(arg0)
	setActive(arg0.freeTitle, arg0.isFree)
	setActive(arg0.dayTitle, not arg0.isFree)
	setText(arg0.titleDayNum, arg0.curDay)
	setText(arg0.ruleTxt, i18n("venusvolleyball_rule_tip", arg0.endScore))

	arg0.charNames = {}
	arg0.lastSelectNames = {}

	eachChild(arg0.select4Chars, function(arg0)
		local var0 = arg0.name

		onButton(arg0, arg0, function()
			if not arg0.isFree and string.find(var0, "enemy") then
				return
			end

			arg0.selectCharCamp = string.find(var0, "enemy") and "enemy" or "our"

			arg0:openSelectWindow()
		end)
	end)

	if not arg0.isFree then
		local var0, var1 = arg0:getEnemyCharsIndex()

		arg0.charNames.enemy1, arg0.charNames.enemy2 = var1[var0], var1[var1]
	end

	arg0:refreshSelectUI()
end

function var0.getCharIndex(arg0, arg1)
	for iter0, iter1 in ipairs(var1) do
		if iter1 == arg1 then
			return iter0
		end
	end

	return 1
end

function var0.refreshSelectUI(arg0)
	eachChild(arg0.select4Chars, function(arg0)
		local var0 = arg0.name

		if arg0.charNames[var0] then
			setActive(arg0:findTF("select_btn", arg0), false)
			setActive(arg0:findTF("char", arg0), true)
			setImageSprite(arg0:findTF("char/icon", arg0), arg0.paints:Find(arg0:getCharIndex(arg0.charNames[var0])):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(arg0:findTF("char/tag", arg0), arg0.tags:Find(arg0:getCharIndex(arg0.charNames[var0])):GetComponent(typeof(Image)).sprite, true)
		else
			setActive(arg0:findTF("select_btn", arg0), true)
			setActive(arg0:findTF("char", arg0), false)
		end
	end)

	arg0.canStartGame = arg0.charNames.our1 and arg0.charNames.our2 and arg0.charNames.enemy1 and arg0.charNames.enemy2 and true or false

	setGray(arg0.selectStartBtn, not arg0.canStartGame, not arg0.canStartGame)
end

function var0.isSelected(arg0, arg1, arg2)
	local var0 = false

	for iter0, iter1 in pairs(arg0.charNames) do
		if arg1 == iter1 then
			var0 = not string.find(iter0, arg2) and true or false
		end
	end

	return var0
end

function var0.openSelectWindow(arg0)
	setActive(arg0.selectWindow, true)

	arg0.hasSelectNum = 0

	setText(arg0.selectNum, setColorStr(arg0.hasSelectNum, COLOR_GREEN) .. "/2")

	arg0.selectSDIndex1 = nil
	arg0.selectSDIndex2 = nil

	eachChild(arg0.select9Chars, function(arg0)
		local var0 = tonumber(arg0.name)

		setImageSprite(arg0:findTF("char/frame/icon", arg0), arg0.icons:Find(var0):GetComponent(typeof(Image)).sprite, true)
		onButton(arg0, arg0, function()
			if arg0:isSelected(var1[var0], arg0.selectCharCamp) then
				return
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var29)

			if isActive(arg0:findTF("selected", arg0)) then
				setActive(arg0:findTF("selected", arg0), false)

				if arg0.selectSDIndex1 and arg0.selectSDIndex1 == var0 then
					arg0.selectSDIndex1 = nil
				end

				if arg0.selectSDIndex2 and arg0.selectSDIndex2 == var0 then
					arg0.selectSDIndex2 = nil
				end

				arg0.hasSelectNum = arg0.hasSelectNum - 1
			elseif arg0.selectSDIndex1 and arg0.selectSDIndex2 then
				-- block empty
			elseif arg0.selectSDIndex1 then
				arg0.selectSDIndex2 = var0
				arg0.hasSelectNum = arg0.hasSelectNum + 1
			else
				arg0.selectSDIndex1 = var0
				arg0.hasSelectNum = arg0.hasSelectNum + 1
			end

			arg0:refreshSelectWindow()
		end)
	end)
	arg0:refreshSelectWindow()
end

function var0.refreshSelectWindow(arg0)
	eachChild(arg0.select9Chars, function(arg0)
		local var0 = tonumber(arg0.name)

		setActive(arg0:findTF("char/mask", arg0), arg0:isSelected(var1[var0], arg0.selectCharCamp) and true or false)

		if var0 == arg0.selectSDIndex1 or var0 == arg0.selectSDIndex2 then
			setActive(arg0:findTF("selected", arg0), true)
		else
			setActive(arg0:findTF("selected", arg0), false)
		end
	end)
	setText(arg0.selectNum, setColorStr(arg0.hasSelectNum, COLOR_GREEN) .. "/2")

	arg0.canSureChar = arg0.selectSDIndex1 and arg0.selectSDIndex2 and true or false

	setGray(arg0.selectSureBtn, not arg0.canSureChar, not arg0.canSureChar)
end

function var0.firstShow(arg0, arg1)
	setActive(arg0.helpUI, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.helpUI)
	onButton(arg0, arg0.helpUI, function()
		local var0 = getProxy(PlayerProxy):getData().id

		PlayerPrefs.SetInt("volleyballgame_first_" .. var0, 1)
		setActive(arg0.helpUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.helpUI, arg0._tf)

		if arg1 then
			arg1()
		end
	end, SFX_PANEL)
end

function var0.startCountTimer(arg0)
	arg0:setBtnAvailable(false)
	setActive(arg0.countTimeUI, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.countTimeUI)

	arg0.countTime = 3

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var28)
	setImageSprite(arg0.countTimeImage, arg0.countTimeNumImage:Find(arg0.countTime):GetComponent(typeof(Image)).sprite)

	local function var0()
		arg0.countTime = arg0.countTime - 1

		if arg0.countTime <= 0 then
			setActive(arg0.countTimeUI, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.countTimeUI, arg0._tf)
			arg0:resetGameAni()
			arg0:startGame()
		else
			setImageSprite(arg0.countTimeImage, arg0.countTimeNumImage:Find(arg0.countTime):GetComponent(typeof(Image)).sprite)
		end
	end

	if arg0.countTimer then
		arg0.countTimer:Reset(var0, 1, -1)
	else
		arg0.countTimer = Timer.New(var0, 1, -1)
	end

	arg0.countTimer:Start()
end

function var0.setBtnAvailable(arg0, arg1)
	arg0.btnAvailable = arg1

	setGray(arg0.backBtn, not arg1, not arg1)
	setGray(arg0.pauseBtn, not arg1, not arg1)
end

function var0.startGame(arg0)
	arg0.isInGame = true

	arg0:setBtnAvailable(true)
	setActive(arg0.bgEffect, false)
	setActive(arg0.bgEffect, true)

	if arg0.beginTeam == var3 then
		arg0:ourServe(function()
			arg0:enemyUp2Up(function()
				arg0:enemyUp2Hit(function()
					arg0:enemyThrow(function()
						arg0:enterLoop()
					end)
				end)
			end)
		end)
	else
		arg0:enemyServe(function()
			arg0:enterLoop()
		end)
	end
end

function var0.enterLoop(arg0)
	arg0:ourUp2Up(function()
		arg0:ourUp2Hit(function()
			arg0:ourThrow(function()
				arg0:enemyUp2Up(function()
					arg0:enemyUp2Hit(function()
						arg0:enemyThrow(function()
							arg0:enterLoop()
						end)
					end)
				end)
			end)
		end)
	end)
end

function var0.ourServe(arg0, arg1)
	arg0.ballPosTag = "our_serve"

	setActive(arg0.ball, true)
	arg0:charServeBall()
	arg0:managedTween(LeanTween.delayedCall, function()
		local var0 = "enemy" .. math.random(2)

		arg0.ballPosTag = var0
		arg0.anchoredPos[arg0.ballPosTag] = arg0:getRandomPos(arg0.ballPosTag)

		arg0:ballServe(arg0.ball, var15, arg0.anchoredPos[var0], function()
			if arg1 then
				arg1()
			end
		end)
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:charUpBall()
		end, var15 - var21, nil)
	end, var20 + 0.5, nil)
end

function var0.enemyServe(arg0, arg1)
	arg0.ballPosTag = "enemy_serve"

	setActive(arg0.ball, true)
	arg0:charServeBall()
	arg0:managedTween(LeanTween.delayedCall, function()
		local var0 = "our" .. math.random(2)

		arg0.ballPosTag = var0
		arg0.anchoredPos[arg0.ballPosTag] = arg0:getRandomPos(arg0.ballPosTag)

		arg0:ballServe(arg0.ball, var15, arg0.anchoredPos[var0], function()
			if arg1 then
				arg1()
			end
		end)
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:charUpBall()
		end, var15 - var21, nil)
	end, var20 + 0.5, nil)
end

function var0.ourUp2Up(arg0, arg1)
	if arg0.qteStatus == var11 and arg0.qteType == var13 then
		arg0:ourFly()

		return
	end

	arg0.ballPosTag = arg0.ballPosTag == "our1" and "our2" or "our1"

	arg0:ballUp2Up(arg0.ball, var16, arg0.anchoredPos[arg0.ballPosTag], function()
		if arg1 then
			arg1()
		end
	end)
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:charUpBall()
	end, 0.3, nil)
end

function var0.ourUp2Hit(arg0, arg1)
	local var0 = {}

	arg0.ballPosTag = arg0.ballPosTag == "our1" and "our2" or "our1"
	arg0.anchoredPos[arg0.ballPosTag] = arg0:getRandomPos(arg0.ballPosTag)
	arg0.qteType = var14

	arg0:charHitBall()

	local var1 = false

	local function var2(arg0)
		if var1 then
			arg0()
		else
			var1 = true
		end
	end

	table.insert(var0, function(arg0)
		local function var0()
			if arg0.isCutin then
				arg0:showcutin(function()
					arg0.isCutin = false

					arg0()
				end)
			else
				arg0()
			end
		end

		arg0:managedTween(LeanTween.delayedCall, function()
			var2(var0)
		end, var16 - 0.2, nil)
		arg0:managedTween(LeanTween.delayedCall, function()
			arg0:startQTE(var32, 200, arg0.anchoredPos[arg0.ballPosTag], function()
				var2(var0)
			end)
		end, var16 - var32 - 0.2, nil)
	end)
	table.insert(var0, function(arg0)
		arg0:ballUp2Hit(arg0.ball, var16, arg0.anchoredPos[arg0.ballPosTag], arg0)
	end)
	parallelAsync(var0, function()
		if arg1 then
			arg1()
		end
	end)
end

function var0.ourThrow(arg0, arg1)
	local var0 = "enemy" .. math.random(2)

	arg0.ballPosTag = var0
	arg0.anchoredPos[arg0.ballPosTag] = arg0:getRandomPos(arg0.ballPosTag)

	arg0:ballHit(arg0.ball, var17, arg0.anchoredPos[var0], function()
		if arg1 then
			arg1()
		end
	end)
	arg0:charUpBall()
end

function var0.enemyUp2Up(arg0, arg1)
	if arg0.qteStatus == var10 and arg0.qteType == var14 then
		arg0:enemyFly()

		return
	end

	arg0.ballPosTag = arg0.ballPosTag == "enemy1" and "enemy2" or "enemy1"

	arg0:ballUp2Up(arg0.ball, var16, arg0.anchoredPos[arg0.ballPosTag], function()
		if arg1 then
			arg1()
		end
	end)
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:charUpBall()
	end, 0.3, nil)
end

function var0.enemyUp2Hit(arg0, arg1)
	arg0.ballPosTag = arg0.ballPosTag == "enemy1" and "enemy2" or "enemy1"
	arg0.anchoredPos[arg0.ballPosTag] = arg0:getRandomPos(arg0.ballPosTag)
	arg0.randomQtePos = "our" .. math.random(2)
	arg0.anchoredPos[arg0.randomQtePos] = arg0:getRandomPos(arg0.randomQtePos)
	arg0.qteType = var13

	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:startQTE(var32, 0, arg0.anchoredPos[arg0.randomQtePos])
	end, var16 - var32, nil)
	arg0:ballUp2Hit(arg0.ball, var16, arg0.anchoredPos[arg0.ballPosTag], function()
		if arg1 then
			arg1()
		end
	end)
	arg0:charHitBall()
end

function var0.enemyThrow(arg0, arg1)
	arg0.ballPosTag = arg0.randomQtePos

	arg0:ballHit(arg0.ball, var17, arg0.anchoredPos[arg0.ballPosTag], function()
		if arg1 then
			arg1()
		end
	end)
	arg0:charUpBall()
end

function var0.ourFly(arg0)
	arg0.ballPosTag = "out"

	local var0 = math.random(1000, 1100)
	local var1 = math.random(0, 200)

	arg0:hitFly(arg0.ball, var18, {
		x = -var0,
		y = var1 - 100
	}, function()
		arg0.qteStatus = var9

		setGray(arg0.qteBtn, true, true)

		arg0.enemyScoreNum = arg0.enemyScoreNum + 1

		arg0:updateScore()
	end)
end

function var0.enemyFly(arg0)
	arg0.ballPosTag = "out"

	local var0 = math.random(1000, 1100)
	local var1 = math.random(0, 200)

	arg0:hitFly(arg0.ball, var18, {
		x = var0,
		y = var1 - 100
	}, function()
		arg0.qteStatus = var9

		setGray(arg0.qteBtn, true, true)

		arg0.ourScoreNum = arg0.ourScoreNum + 1

		arg0:updateScore()
	end)
end

function var0.qteSuccess(arg0)
	arg0.qteStatus = var10
	arg0.beginTeam = var3

	arg0:changeQTEBtnStatus(var5)
end

function var0.qteFail(arg0)
	arg0.qteStatus = var11
	arg0.beginTeam = var4

	arg0:changeQTEBtnStatus(var5)
end

function var0.GetBeziersPoints(arg0, arg1, arg2, arg3, arg4)
	local function var0(arg0)
		local var0 = arg1:Clone():Mul((1 - arg0) * (1 - arg0))
		local var1 = arg2:Clone():Mul(2 * arg0 * (1 - arg0))
		local var2 = arg3:Clone():Mul(arg0 * arg0)

		return var0:Clone():Add(var1):Add(var2)
	end

	local var1 = {}

	table.insert(var1, Vector3(0, 0, 0))
	table.insert(var1, var0(0))

	for iter0 = 1, arg4 do
		local var2 = iter0 / arg4

		table.insert(var1, var0(var2))
	end

	table.insert(var1, Vector3(0, 0, 0))

	return var1
end

function var0.ballParabolaMove(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = Vector2(arg1.anchoredPosition.x, arg1.anchoredPosition.y - arg5)
	local var1 = Vector2(arg3.x, arg3.y)
	local var2 = var1.x - var0.x
	local var3 = var1.y - var0.y
	local var4 = math.abs(arg6 - arg5)
	local var5 = DOAParabolaCalc(arg2, math.abs(var33), var4)
	local var6
	local var7

	if arg5 < arg6 then
		var6 = var5 + var4

		local var8 = var5
	else
		var6 = var5

		local var9 = var5 + var4
	end

	local var10 = math.sqrt(2 * math.abs(var33) * var6)

	arg0:managedTween(LeanTween.value, function()
		if arg4 then
			arg4()
		end
	end, go(arg1), 0, arg2, arg2):setOnUpdate(System.Action_float(function(arg0)
		local var0 = var2 * arg0 / arg2
		local var1 = var3 * arg0 / arg2
		local var2 = var10 * arg0 + 0.5 * var33 * arg0 * arg0

		arg1.anchoredPosition = Vector2(var0.x + var0, var0.y + var1 + arg5 + var2)
	end))
end

function var0.ballServe(arg0, arg1, arg2, arg3, arg4)
	arg0:ballParabolaMove(arg1, arg2, arg3, function()
		if arg4 then
			arg4()
		end
	end, var24, var25)
	arg0:managedTween(LeanTween.move, nil, arg0.ballShadow, Vector3(arg3.x, arg3.y + var23), arg2):setEase(LeanTweenType.linear)
end

function var0.ballUp2Up(arg0, arg1, arg2, arg3, arg4)
	arg0:ballParabolaMove(arg1, arg2, arg3, function()
		if arg4 then
			arg4()
		end
	end, var25, var25)
	arg0:managedTween(LeanTween.move, nil, arg0.ballShadow, Vector3(arg3.x, arg3.y + var23), arg2):setEase(LeanTweenType.linear)
end

function var0.ballUp2Hit(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		x = arg3.x,
		y = arg3.y
	}

	arg0:ballParabolaMove(arg1, arg2, var0, function()
		if arg4 then
			arg4()
		end
	end, var25, var26)
	arg0:managedTween(LeanTween.move, nil, arg0.ballShadow, Vector3(arg3.x, arg3.y + var23), arg2):setEase(LeanTweenType.linear)
end

function var0.ballHit(arg0, arg1, arg2, arg3, arg4)
	arg3 = Vector2(arg3.x, arg3.y + var25)

	arg0:managedTween(LeanTween.moveX, function()
		if arg4 then
			arg4()
		end
	end, arg1, arg3.x, arg2):setEase(LeanTweenType.linear)
	arg0:managedTween(LeanTween.moveY, nil, arg1, arg3.y, arg2):setEase(LeanTweenType.linear)
	arg0:managedTween(LeanTween.move, nil, arg0.ballShadow, Vector3(arg3.x, arg3.y + var23), arg2):setEase(LeanTweenType.linear)
end

function var0.charMove(arg0, arg1, arg2, arg3, arg4)
	arg0:managedTween(LeanTween.moveX, nil, arg1, arg3.x, arg2):setEase(LeanTweenType.easeOutQuad)
	arg0:managedTween(LeanTween.moveY, function()
		if arg4 then
			arg4()
		end
	end, arg1, arg3.y, arg2):setEase(LeanTweenType.linear)
end

function var0.hitFly(arg0, arg1, arg2, arg3, arg4)
	arg0:ballParabolaMove(arg1, arg2, arg3, function()
		if arg4 then
			arg4()
		end
	end, var27, var26)
	arg0:managedTween(LeanTween.move, nil, arg0.ballShadow, Vector3(arg3.x, arg3.y + var23), arg2):setEase(LeanTweenType.linear)
end

function var0.startQTE(arg0, arg1, arg2, arg3, arg4)
	arg0:changeQTEBtnStatus(var6)

	arg0.qte.anchoredPosition = {
		x = arg3.x,
		y = arg3.y + arg2
	}

	setActive(arg0.qte, true)
	setActive(arg0.qteCircles, true)
	setActive(arg0.result, false)
	setLocalScale(arg0.qteCircle, Vector3(1, 1, 1))
	arg0.result:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(arg0.result, false)
	end)

	arg0.qteCallback = arg4
	arg0.qteTween = LeanTween.scale(arg0.qteCircle, Vector3(0, 0, 1), arg1):setOnComplete(System.Action(function()
		arg0:changeQTEBtnStatus(var5)
		setImageSprite(arg0.result, arg0.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		setActive(arg0.result, true)
		arg0:qteFail()

		arg0.isCutin = false

		setActive(arg0.qteCircles, false)
		existCall(arg0.qteCallback)

		arg0.qteCallback = nil
	end)).uniqueId
end

function var0.qteResult(arg0)
	if LeanTween.isTweening(arg0.qteTween) then
		LeanTween.cancel(arg0.qteTween, false)
	end

	local var0 = math.abs(arg0.qteCircle.localScale.x)

	setActive(arg0.result, true)

	arg0.isCutin = false

	if var0 <= 0 or var0 > var7 then
		setImageSprite(arg0.result, arg0.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		arg0:qteFail()
	elseif var0 > var8 then
		setImageSprite(arg0.result, arg0.resultTxt:Find("good"):GetComponent(typeof(Image)).sprite, true)
		arg0:qteSuccess()
	else
		setImageSprite(arg0.result, arg0.resultTxt:Find("perfect"):GetComponent(typeof(Image)).sprite, true)
		arg0:qteSuccess()

		if arg0.qteType == var14 then
			arg0.isCutin = true
		else
			arg0.isCutin = false
		end
	end

	setActive(arg0.qteCircles, false)
	existCall(arg0.qteCallback)

	arg0.qteCallback = nil
end

local function var34(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		_tf = arg1,
		spineAnim = arg2,
		skele = arg3,
		posTag = arg4
	}

	function var0.ctor(arg0)
		var0._tf.anchoredPosition = arg0.anchoredPos[arg4]
	end

	function var0.setPosTag(arg0, arg1)
		var0._tf.anchoredPosition = arg0.anchoredPos[arg1]
		var0.posTag = arg1
	end

	function var0.getPosTag(arg0)
		return var0.posTag
	end

	function var0.pauseSpine(arg0)
		var0.skele.timeScale = 0
	end

	function var0.resumeSpine(arg0)
		var0.skele.timeScale = 1
	end

	function var0.setActionOnce(arg0, arg1, arg2)
		var0.spineAnim:SetActionCallBack(function(arg0)
			if arg0 == "action" then
				if arg1 == "chuanqiu" or arg1 == "dianqiu" then
					arg0:playEffect(arg0.upEffect, Vector2(var0._tf.anchoredPosition.x, var0._tf.anchoredPosition.y + var25))
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var30)
				elseif arg1 == "kouqiu" then
					arg0:playEffect(arg0.hitEffect, Vector2(var0._tf.anchoredPosition.x, var0._tf.anchoredPosition.y + var25 + var26))
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var31)
				elseif arg1 == "faqiu" then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var30)
					arg0:playEffect(arg0.upEffect, Vector2(var0._tf.anchoredPosition.x, var0._tf.anchoredPosition.y + var24))
				end
			end

			if arg0 == "finish" then
				var0.spineAnim:SetActionCallBack(nil)

				if arg2 then
					arg2()
				else
					var0.spineAnim:SetAction("normal2", 0)
				end
			end
		end)
		var0.spineAnim:SetAction(arg1, 0)
	end

	function var0.move(arg0, arg1, arg2, arg3, arg4)
		local var0 = function()
			var0.spineAnim:SetAction("run", 0)

			var0.posTag = arg2

			arg0:charMove(var0._tf, arg1, arg0.anchoredPos[arg2], function()
				if arg4 then
					arg4()
				else
					var0.spineAnim:SetAction("normal2", 0)
				end
			end)
		end

		if arg3 then
			var0:setActionOnce(arg3, function()
				var0()
			end)
		else
			var0()
		end
	end

	var0:ctor()

	return var0
end

function var0.getRandomPos(arg0, arg1)
	local var0 = math.random(0, 300)
	local var1 = math.random(0, 50)
	local var2 = arg0.orgPos[arg1]
	local var3 = var2

	if string.find(arg1, "our") then
		var3 = {
			x = var2.x + var0 - 50,
			y = var2.y + var1 - 25
		}
	else
		var3 = {
			x = var2.x + var0 - 250,
			y = var2.y + var1 - 25
		}
	end

	return var3
end

function var0.loadSpineChars(arg0)
	arg0:clearSpineChars()

	arg0.beginTeam = math.random(2)

	if arg0.beginTeam == var3 then
		arg0.serveChar = "our" .. math.random(2)
	else
		arg0.serveChar = "enemy" .. math.random(2)
	end

	arg0:setBallPos()

	for iter0, iter1 in pairs(arg0.charNames) do
		arg0:loadOneSpineChar(iter0, arg0.serveChar)
	end
end

function var0.loadOneSpineChar(arg0, arg1, arg2)
	if not arg0.charNames[arg1] then
		arg0.charNames[arg1] = false

		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg0.charNames[arg1], true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		local var0 = ""
		local var1

		if string.find(arg1, "our") then
			tf(arg0).localScale = Vector3(0.6, 0.6, 1)
			tf(arg0).localPosition = Vector3(-20, 0, 0)

			if string.find(arg1, "1") then
				var1 = "our1"
			else
				var1 = "our2"
			end
		else
			tf(arg0).localScale = Vector3(-0.6, 0.6, 1)
			tf(arg0).localPosition = Vector3(20, 0, 0)
			var1 = string.find(arg1, "1") and "enemy1" or "enemy2"
		end

		arg0.charModels[arg1] = arg0

		local var2 = arg0:GetComponent("SpineAnimUI")
		local var3 = arg0:GetComponent("SkeletonGraphic")

		var2:SetAction("normal2", 0)

		var3.timeScale = 1

		local var4 = arg0._tf:Find("game_ui/char/" .. arg1)

		setParent(arg0, var4)

		arg0.charactor[arg1] = var34(arg0, var4, var2, var3, var1)

		if arg1 == arg2 then
			if arg0.beginTeam == var3 then
				arg0.charactor[arg1]:setPosTag("our_serve")
			else
				arg0.charactor[arg1]:setPosTag("enemy_serve")
			end
		end
	end)
end

function var0.clearSpineChars(arg0)
	for iter0, iter1 in pairs(arg0.charModels) do
		if arg0.charModels[iter0] and arg0.charNames[iter0] then
			PoolMgr.GetInstance():ReturnSpineChar(arg0.charNames[iter0], arg0.charModels[iter0])
		end
	end

	arg0.charModels = {}
end

function var0.getCharWithTag(arg0, arg1)
	for iter0, iter1 in pairs(arg0.charactor) do
		if iter1:getPosTag() == arg1 then
			return iter0, iter1
		end
	end

	return nil
end

function var0.getAnotherChar(arg0, arg1)
	local var0 = ""

	if string.find(arg1, "our") then
		var0 = arg1 == "our1" and "our2" or "our1"
	elseif string.find(arg1, "enemy") then
		var0 = arg1 == "enemy1" and "enemy2" or "enemy1"
	end

	return var0, arg0.charactor[var0]
end

function var0.setBallPos(arg0)
	setActive(arg0.ball, true)

	local var0 = string.find(arg0.serveChar, "our") and "our_serve" or "enemy_serve"

	arg0.ball.anchoredPosition = {
		x = arg0.orgPos[var0].x,
		y = arg0.orgPos[var0].y + 300
	}
	arg0.ballShadow.anchoredPosition = Vector3(arg0.orgPos[var0].x, arg0.orgPos[var0].y, 0)

	arg0:managedTween(LeanTween.rotate, nil, arg0.ball, 360, 0.5):setLoopClamp()
end

function var0.resetChar(arg0)
	arg0:resetPos()

	for iter0, iter1 in pairs(arg0.charactor) do
		if LeanTween.isTweening(go(iter1._tf)) then
			LeanTween.cancel(go(iter1._tf))
		end
	end

	arg0.charactor.our1:setPosTag("our1")
	arg0.charactor.our2:setPosTag("our2")
	arg0.charactor.enemy1:setPosTag("enemy1")
	arg0.charactor.enemy2:setPosTag("enemy2")

	if arg0.beginTeam == var3 then
		arg0.serveChar = "our" .. math.random(2)

		arg0.charactor[arg0.serveChar]:setPosTag("our_serve")
	else
		arg0.serveChar = "enemy" .. math.random(2)

		arg0.charactor[arg0.serveChar]:setPosTag("enemy_serve")
	end

	arg0:setBallPos()
end

function var0.charServeBall(arg0)
	arg0:managedTween(LeanTween.rotate, nil, arg0.ball, 360, 0.5):setLoopClamp()

	local var0 = string.find(arg0.serveChar, "our") and "our_serve" or "enemy_serve"

	arg0:managedTween(LeanTween.delayedCall, function()
		arg0:managedTween(LeanTween.moveY, nil, arg0.ball, arg0.orgPos[var0].y + var24, 0.5):setEase(LeanTweenType.linear)
		arg0.charactor[arg0.serveChar]:setActionOnce("faqiu", function()
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0.charactor[arg0.serveChar]:move(1, arg0.serveChar)
			end, 0.2, nil)
		end)
	end, 0.5, nil)
end

function var0.charUpBall(arg0, arg1)
	local var0, var1 = arg0:getCharWithTag(arg0.ballPosTag)

	if not var1 then
		return
	end

	arg0.upChar = var0
	arg0.hitChar = arg0:getAnotherChar(arg0.upChar)

	var1:move(0.45, arg0.ballPosTag, nil, function()
		var1:setActionOnce("chuanqiu")
	end)
end

function var0.charHitBall(arg0)
	local var0 = arg0.charactor[arg0.hitChar]

	var0:move(0.5, arg0.ballPosTag, nil, function()
		var0:setActionOnce("kouqiu")
	end)
end

function var0.showcutin(arg0, arg1)
	arg0:setBtnAvailable(false)
	arg0:pauseGame()
	setActive(arg0.cutin, true)

	local var0 = ""

	for iter0, iter1 in pairs(arg0.charNames) do
		if iter0 == arg0.hitChar then
			var0 = iter1
		end
	end

	local var1, var2, var3 = ShipWordHelper.GetWordAndCV(var2[arg0:getCharIndex(var0)], "skill")

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)
	setActive(arg0:findTF("line", arg0.gameUI), true)
	setActive(arg0:findTF("shatanpaiqiu_cutin", arg0.cutin), false)
	setActive(arg0:findTF("shatanpaiqiu_cutin", arg0.cutin), true)
	setImageSprite(arg0.cutinPaint, arg0.cutinPaints:Find(arg0:getCharIndex(var0)):GetComponent(typeof(Image)).sprite, true)
	LeanTween.moveX(arg0.cutin, 0, 0.3):setOnComplete(System.Action(function()
		LeanTween.delayedCall(1, System.Action(function()
			setActive(arg0:findTF("line", arg0.gameUI), false)
			LeanTween.moveX(arg0.cutin, -567, 0.3):setOnComplete(System.Action(function()
				setActive(arg0.cutin, false)
				arg0:setBtnAvailable(true)
				arg0:resumeGame()

				if arg1 then
					arg1()
				end
			end))
		end))
	end))
end

function var0.showScoreCutin(arg0, arg1)
	arg0:setBtnAvailable(false)
	arg0:pauseGame()
	setImageSprite(arg0.ourScoreCutin, arg0.scoreCutinNums:Find(arg0.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0.enemyScoreCutin, arg0.scoreCutinNums:Find(arg0.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)
	setActive(arg0.scoreCutin, true)
	setLocalScale(arg0.scoreCutin, Vector3(1, 0, 1))
	LeanTween.scale(arg0.scoreCutin, Vector3(1, 1, 1), 0.2):setOnComplete(System.Action(function()
		arg0:resetChar()
		LeanTween.delayedCall(0.6, System.Action(function()
			LeanTween.scale(arg0.scoreCutin, Vector3(1, 0, 1), 0.2):setOnComplete(System.Action(function()
				setActive(arg0.scoreCutin, false)
				arg0:setBtnAvailable(true)
				arg0:resumeGame()

				if arg1 then
					arg1()
				end
			end))
		end))
	end))
end

function var0.updateScore(arg0)
	setText(arg0.ourScore, arg0.ourScoreNum)
	setText(arg0.enemyScore, arg0.enemyScoreNum)
	setActive(arg0.qte, false)

	if arg0.ourScoreNum >= arg0.endScore or arg0.enemyScoreNum >= arg0.endScore then
		arg0:endGame()
	else
		arg0:showScoreCutin(function()
			arg0:startGame()
		end)
	end
end

function var0.endGame(arg0)
	setActive(arg0.winTag, arg0.ourScoreNum ~= arg0.enemyScoreNum)
	setActive(arg0.loseTag, arg0.ourScoreNum ~= arg0.enemyScoreNum)
	arg0:setBtnAvailable(false)

	arg0.isInGame = false

	pg.UIMgr.GetInstance():BlurPanel(arg0.endUI)
	setActive(arg0.endUI, true)
	setActive(arg0.endFreeTitle, arg0.isFree)
	setActive(arg0.endDayTitle, not arg0.isFree)
	setImageSprite(arg0.endTitleDay, arg0.titleDays:Find(arg0.curDay):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0.endOurScore, arg0.endScoreNums:Find(arg0.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0.endEnemyScore, arg0.endScoreNums:Find(arg0.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)

	local var0 = -20
	local var1

	if arg0.ourScoreNum > arg0.enemyScoreNum then
		arg0.winTag.anchoredPosition = Vector3(-170, 200, 0)
		arg0.loseTag.anchoredPosition = Vector3(180, 200, 0)
		var1 = -20
	else
		arg0.winTag.anchoredPosition = Vector3(170, 200, 0)
		arg0.loseTag.anchoredPosition = Vector3(-180, 200, 0)
		var1 = 20
	end

	setActive(arg0.winTag:GetChild(0), false)
	setActive(arg0.winTag:GetChild(0), true)
	setLocalRotation(arg0.loseTag, Vector3(0, 0, 0))
	LeanTween.rotateZ(go(arg0.loseTag), var1, 0.2):setOnComplete(System.Action(function()
		if arg0:GetMGHubData().count > 0 then
			arg0:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
		end
	end))
end

function var0.OnGetAwardDone(arg0, arg1)
	if arg1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0 = arg0:GetMGHubData()
		local var1 = var0.ultimate
		local var2 = var0.usedtime
		local var3 = var0:getConfig("reward_need")
		local var4 = arg0:GetMGHubData().count
		local var5 = pg.NewStoryMgr.GetInstance()
		local var6 = arg0.storylist[arg0:GetMGHubData().usedtime] and arg0.storylist[arg0:GetMGHubData().usedtime][1] or nil

		if var2 ~= 7 and var6 and not var5:IsPlayed(var6) then
			var5:Play(var6)
		end

		if var1 == 0 and var3 <= var2 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif arg1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		local var7 = arg0.storylist[7][1] and arg0.storylist[7][1] or nil
		local var8 = pg.NewStoryMgr.GetInstance()

		if var7 and not var8:IsPlayed(var7) then
			var8:Play(var7)
		end
	end
end

function var0.pauseGame(arg0)
	arg0:pauseManagedTween()

	if arg0.qteTimer then
		arg0.qteTimer:Pause()
	end

	if arg0.qteTween and LeanTween.isTweening(arg0.qteTween) then
		LeanTween.pause(arg0.qteTween)
	end

	for iter0, iter1 in pairs(arg0.charactor) do
		iter1:pauseSpine()
	end
end

function var0.resumeGame(arg0)
	arg0:resumeManagedTween()

	if arg0.qteTimer then
		arg0.qteTimer:Resume()
	end

	if arg0.qteTween and LeanTween.isTweening(arg0.qteTween) then
		LeanTween.resume(arg0.qteTween)
	end

	for iter0, iter1 in pairs(arg0.charactor) do
		iter1:resumeSpine()
	end
end

function var0.clearTimer(arg0)
	if arg0.qteTimer then
		arg0.qteTimer:Stop()

		arg0.qteTimer = nil
	end

	if arg0.countTimer then
		arg0.countTimer:Stop()

		arg0.countTimer = nil
	end
end

function var0.changeQTEBtnStatus(arg0, arg1)
	arg0.qteBtnStatus = arg1
end

function var0.resetGameData(arg0)
	arg0.qteStatus = var9
	arg0.qteType = var12

	arg0:changeQTEBtnStatus(var5)

	arg0.ballPosTag = ""
	arg0.isCutin = false
	arg0.cutin.anchoredPosition = {
		x = -567,
		y = 582
	}
	arg0.isScoreCutin = false

	setActive(arg0.scoreCutin, false)

	arg0.ourScoreNum = 0
	arg0.enemyScoreNum = 0

	setText(arg0.ourScore, arg0.ourScoreNum)
	setText(arg0.enemyScore, arg0.enemyScoreNum)
	setActive(arg0.qte, false)
	arg0:loadSpineChars()
end

function var0.exitGame(arg0)
	arg0.isInGame = false

	arg0:setBtnAvailable(true)
	arg0:resetGameAni()
end

function var0.resetGameAni(arg0)
	arg0:cleanManagedTween()

	if arg0.qteTween and LeanTween.isTweening(arg0.qteTween) then
		LeanTween.cancel(arg0.qteTween, false)
	end

	arg0:clearTimer()
end

function var0.willExit(arg0)
	arg0:clearSpineChars()
	pg.UIMgr.GetInstance():UnblurPanel(arg0.selectUI, arg0._tf)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.endUI, arg0._tf)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.countTimeUI, arg0._tf)
end

function var0.onBackPressed(arg0)
	if arg0.isInGame then
		triggerButton(arg0.backBtn)
	elseif isActive(arg0.selectUI) then
		triggerButton(arg0.selectBackBtn)
	elseif isActive(arg0.mainUI) then
		triggerButton(arg0.returnBtn)
	end
end

return var0

local var0_0 = class("VolleyballGameView", import("..BaseMiniGameView"))
local var1_0 = {
	"maliluosi_2_DOA",
	"suixiang_2_doa",
	"xia_2_DOA",
	"haixiao_2_DOA",
	"zhixiao_2_DOA",
	"nvtiangou_2_DOA",
	"monika_2_DOA"
}
local var2_0 = {
	10600010,
	10600020,
	10600030,
	10600040,
	10600050,
	10600060,
	10600070
}
local var3_0 = 1
local var4_0 = 2
local var5_0 = -1
local var6_0 = 0
local var7_0 = 0.35
local var8_0 = 0.15
local var9_0 = 0
local var10_0 = 1
local var11_0 = 2
local var12_0 = 0
local var13_0 = 1
local var14_0 = 2
local var15_0 = 1.5
local var16_0 = 1
local var17_0 = 0.5
local var18_0 = 0.5
local var19_0 = 0.43
local var20_0 = 0.5
local var21_0 = 0.76
local var22_0 = 0.83
local var23_0 = -30
local var24_0 = 50
local var25_0 = 60
local var26_0 = 230
local var27_0 = 60
local var28_0 = "event:/ui/ddldaoshu2"
local var29_0 = "event:/ui/fighterplane_click"
local var30_0 = "event:/ui/jieqiu"
local var31_0 = "event:/ui/kouqiu"
local var32_0 = 0.8
local var33_0 = -1000

function var0_0.getUIName(arg0_1)
	return "VolleyballGameUI"
end

function var0_0.init(arg0_2)
	arg0_2.countTimeUI = arg0_2._tf:Find("count_time_ui")
	arg0_2.countTimeImage = arg0_2.countTimeUI:Find("time")
	arg0_2.countTimeNumImage = arg0_2.countTimeUI:Find("nums")
	arg0_2.mainUI = arg0_2._tf:Find("main_ui")
	arg0_2.returnBtn = arg0_2.mainUI:Find("return_btn")
	arg0_2.mainStartBtn = arg0_2.mainUI:Find("start_btn")
	arg0_2.ruleBtn = arg0_2.mainUI:Find("rule_btn")
	arg0_2.progressScroll = arg0_2.mainUI:Find("right_panel/scroll_view/")
	arg0_2.progressContent = arg0_2.mainUI:Find("right_panel/scroll_view/viewport/content")
	arg0_2.colors = arg0_2.mainUI:Find("right_panel/colors")
	arg0_2.icons = arg0_2.mainUI:Find("right_panel/icons")
	arg0_2.gotIcon = arg0_2.mainUI:Find("bg/got")
	arg0_2.selectUI = arg0_2._tf:Find("select_ui")
	arg0_2.selectBackBtn = arg0_2.selectUI:Find("back_btn")
	arg0_2.selectStartBtn = arg0_2.selectUI:Find("start_btn")
	arg0_2.tags = arg0_2.selectUI:Find("select_panel/tags")
	arg0_2.paints = arg0_2.selectUI:Find("select_panel/paints")
	arg0_2.freeTitle = arg0_2.selectUI:Find("select_panel/title/free")
	arg0_2.dayTitle = arg0_2.selectUI:Find("select_panel/title/challenge")
	arg0_2.titleDayNum = arg0_2.selectUI:Find("select_panel/title/challenge/num")
	arg0_2.ruleTxt = arg0_2.selectUI:Find("select_panel/rule/rule_txt")
	arg0_2.select4Chars = arg0_2.selectUI:Find("select_panel/chars")
	arg0_2.selectWindow = arg0_2.selectUI:Find("select_windows")
	arg0_2.selectSureBtn = arg0_2.selectWindow:Find("windows/sure_btn")
	arg0_2.select9Chars = arg0_2.selectWindow:Find("windows/char_layout")
	arg0_2.selectNum = arg0_2.selectWindow:Find("windows/tips/num")
	arg0_2.gameUI = arg0_2._tf:Find("game_ui")
	arg0_2.bgEffect = arg0_2.gameUI:Find("bg/shatanpaiqiu_hailang")
	arg0_2.hitEffect = arg0_2.gameUI:Find("shatanpaiqiu_jida")
	arg0_2.upEffect = arg0_2.gameUI:Find("shatanpaiqiu_jieqiu")
	arg0_2.ball = arg0_2.gameUI:Find("ball")
	arg0_2.ballShadow = arg0_2.gameUI:Find("ball_shadow")
	arg0_2.pauseBtn = arg0_2.gameUI:Find("pause_btn")
	arg0_2.backBtn = arg0_2.gameUI:Find("back_btn")
	arg0_2.qteBtn = arg0_2.gameUI:Find("qte_btn")
	arg0_2.pos = arg0_2.gameUI:Find("pos")

	arg0_2:initPos()

	arg0_2.ourScore = arg0_2.gameUI:Find("score/our")
	arg0_2.enemyScore = arg0_2.gameUI:Find("score/enemy")
	arg0_2.qte = arg0_2.gameUI:Find("qte")
	arg0_2.qteCircles = arg0_2.qte:Find("circles")
	arg0_2.qteCircle = arg0_2.qte:Find("circles/big")
	arg0_2.result = arg0_2.qte:Find("result")
	arg0_2.resultTxt = arg0_2.qte:Find("txts")
	arg0_2.cutin = arg0_2.gameUI:Find("cutin")
	arg0_2.cutinPaint = arg0_2.gameUI:Find("cutin/paint")
	arg0_2.cutinPaints = arg0_2.gameUI:Find("cutin_paints")
	arg0_2.scoreCutin = arg0_2.gameUI:Find("score_cutin")
	arg0_2.scoreCutinNums = arg0_2.gameUI:Find("score_cutin/nums")
	arg0_2.ourScoreCutin = arg0_2.gameUI:Find("score_cutin/our")
	arg0_2.enemyScoreCutin = arg0_2.gameUI:Find("score_cutin/enemy")
	arg0_2.charTF = {}
	arg0_2.charTF.our1 = arg0_2.gameUI:Find("char/our1")
	arg0_2.charTF.our2 = arg0_2.gameUI:Find("char/our2")
	arg0_2.charTF.enemy1 = arg0_2.gameUI:Find("char/enemy1")
	arg0_2.charTF.enemy2 = arg0_2.gameUI:Find("char/enemy2")
	arg0_2.charModels = {}
	arg0_2.charactor = {}
	arg0_2.cutinMask = arg0_2.gameUI:Find("cutin_mask")
	arg0_2.endUI = arg0_2._tf:Find("end_ui")
	arg0_2.endDayTitle = arg0_2.endUI:Find("title/race")
	arg0_2.endFreeTitle = arg0_2.endUI:Find("title/free")
	arg0_2.endTitleDay = arg0_2.endUI:Find("title/race/num")
	arg0_2.titleDays = arg0_2.endUI:Find("title_days")
	arg0_2.endOurScore = arg0_2.endUI:Find("score_panel/score/our")
	arg0_2.endEnemyScore = arg0_2.endUI:Find("score_panel/score/enemy")
	arg0_2.endScoreNums = arg0_2.endUI:Find("nums")
	arg0_2.sureBtn = arg0_2.endUI:Find("sure_btn")
	arg0_2.winTag = arg0_2.endUI:Find("score_panel/score/win")
	arg0_2.loseTag = arg0_2.endUI:Find("score_panel/score/lose")
	arg0_2.helpUI = arg0_2._tf:Find("help_ui")
	arg0_2.miniGameHudId = arg0_2:GetMiniGameHudId(ActivityConst.MINIGAME_VOLLEYBALL)
	arg0_2.miniGameId = arg0_2:GetDOA2MiniGameId(ActivityConst.MINIGAME_VOLLEYBALL)
end

function var0_0.initPos(arg0_3)
	arg0_3.orgPos = {}
	arg0_3.orgPos.our_serve = arg0_3.pos:Find("our_pos/serve_pos").anchoredPosition
	arg0_3.orgPos.our1 = arg0_3.pos:Find("our_pos/drop_pos1").anchoredPosition
	arg0_3.orgPos.our2 = arg0_3.pos:Find("our_pos/drop_pos2").anchoredPosition
	arg0_3.orgPos.enemy_serve = arg0_3.pos:Find("enemy_pos/serve_pos").anchoredPosition
	arg0_3.orgPos.enemy1 = arg0_3.pos:Find("enemy_pos/drop_pos1").anchoredPosition
	arg0_3.orgPos.enemy2 = arg0_3.pos:Find("enemy_pos/drop_pos2").anchoredPosition

	arg0_3:resetPos()
end

function var0_0.resetPos(arg0_4)
	arg0_4.anchoredPos = Clone(arg0_4.orgPos)
	arg0_4.anchoredPos.our1 = arg0_4:getRandomPos("our1")
	arg0_4.anchoredPos.our2 = arg0_4:getRandomPos("our2")
	arg0_4.anchoredPos.enemy1 = arg0_4:getRandomPos("enemy1")
	arg0_4.anchoredPos.enemy2 = arg0_4:getRandomPos("enemy2")
end

function var0_0.GetMiniGameHudId(arg0_5, arg1_5)
	local var0_5 = pg.activity_template[arg1_5]

	if not var0_5 then
		return nil
	end

	return var0_5.config_id
end

function var0_0.GetDOA2MiniGameId(arg0_6, arg1_6)
	local var0_6 = pg.activity_template[arg1_6]

	if not var0_6 then
		error("未找到对应DOA活动ID")

		return nil
	end

	local var1_6 = var0_6.config_id

	for iter0_6 = #pg.mini_game.all, 1, -1 do
		local var2_6 = pg.mini_game.all[iter0_6]
		local var3_6 = pg.mini_game[var2_6]

		if var3_6 and var3_6.hub_id == var1_6 then
			return var2_6
		end
	end

	error("未找到对应DOA活动的miniGameID")

	return nil
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.returnBtn, function()
		arg0_7:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.ruleBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("venusvolleyball_help")
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.mainStartBtn, function()
		setActive(arg0_7.selectUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_7.selectUI)
		arg0_7:initSelectUI()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.selectBackBtn, function()
		setActive(arg0_7.selectUI, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.selectUI, arg0_7._tf)
	end, SFX_PANEL)

	arg0_7.canStartGame = false

	onButton(arg0_7, arg0_7.selectStartBtn, function()
		if not arg0_7.canStartGame then
			return
		end

		setActive(arg0_7.mainUI, false)
		setActive(arg0_7.selectUI, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.selectUI, arg0_7._tf)
		setActive(arg0_7.gameUI, true)
		arg0_7:resetGameData()

		if arg0_7.isFirstgame == 0 then
			arg0_7:firstShow(function()
				arg0_7:startCountTimer()
			end)
		else
			arg0_7:startCountTimer()
		end
	end, SFX_PANEL)

	arg0_7.canSureChar = false

	onButton(arg0_7, arg0_7.selectSureBtn, function()
		if not arg0_7.canSureChar then
			return
		end

		if arg0_7.selectCharCamp == "enemy" then
			arg0_7.charNames.enemy1 = var1_0[arg0_7.selectSDIndex1]
			arg0_7.charNames.enemy2 = var1_0[arg0_7.selectSDIndex2]
		elseif arg0_7.selectCharCamp == "our" then
			arg0_7.charNames.our1 = var1_0[arg0_7.selectSDIndex1]
			arg0_7.charNames.our2 = var1_0[arg0_7.selectSDIndex2]
		end

		setActive(arg0_7.selectWindow, false)
		arg0_7:refreshSelectUI()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.selectWindow:Find("mask"), function()
		setActive(arg0_7.selectWindow, false)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.pauseBtn, function()
		if not arg0_7.btnAvailable then
			return
		end

		arg0_7:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("venusvolleyball_suspend_tip"),
			onNo = function()
				arg0_7:resumeGame()
			end,
			onYes = function()
				arg0_7:resumeGame()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.backBtn, function()
		if not arg0_7.btnAvailable then
			return
		end

		arg0_7:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("venusvolleyball_return_tip"),
			onNo = function()
				arg0_7:resumeGame()
			end,
			onYes = function()
				arg0_7:endGame()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.qteBtn, function()
		if arg0_7.qteBtnStatus == var5_0 then
			return
		end

		arg0_7:qteResult()
	end)
	onButton(arg0_7, arg0_7.sureBtn, function()
		setActive(arg0_7.mainUI, true)
		arg0_7:initMainUI()
		setActive(arg0_7.gameUI, false)
		setActive(arg0_7.endUI, false)
		arg0_7:clearSpineChars()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.endUI, arg0_7._tf)
	end, SFX_PANEL)
	arg0_7:initMainUI()
end

function var0_0.playEffect(arg0_24, arg1_24, arg2_24)
	if arg2_24 then
		arg1_24.anchoredPosition = arg2_24
	else
		arg1_24.anchoredPosition = arg0_24.ball.anchoredPosition
	end

	setActive(arg1_24, false)
	setActive(arg1_24, true)
end

function var0_0.getGameData(arg0_25)
	arg0_25.mgProxy = getProxy(MiniGameProxy)
	arg0_25.hubData = arg0_25.mgProxy:GetHubByHubId(arg0_25.miniGameHudId)
	arg0_25.curDay = arg0_25.hubData.ultimate == 0 and arg0_25.hubData.usedtime + 1 or 8
	arg0_25.unlockDay = arg0_25.hubData.usedtime + arg0_25.hubData.count
	arg0_25.curDay = arg0_25.curDay <= arg0_25.unlockDay and arg0_25.curDay or arg0_25.unlockDay
	arg0_25.mgData = arg0_25.mgProxy:GetMiniGameData(arg0_25.miniGameId)
	arg0_25.endScore = arg0_25.mgData:GetSimpleValue("endScore")[arg0_25.curDay]
	arg0_25.storylist = arg0_25.mgData:GetSimpleValue("story")

	local var0_25 = getProxy(PlayerProxy):getData().id

	arg0_25.isFirstgame = PlayerPrefs.GetInt("volleyballgame_first_" .. var0_25)
end

function var0_0.getEnemyCharsIndex(arg0_26)
	return arg0_26.mgData:GetSimpleValue("mainChar")[arg0_26.curDay], arg0_26.mgData:GetSimpleValue("minorChar")[arg0_26.curDay]
end

function var0_0.initMainUI(arg0_27)
	arg0_27.isInGame = false

	arg0_27:getGameData()

	if arg0_27.hubData.ultimate == 0 and arg0_27.hubData.usedtime >= arg0_27.hubData:getConfig("reward_need") then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_27.hubData.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end

	arg0_27.isFree = arg0_27.hubData.ultimate ~= 0 and true or false

	setActive(arg0_27.mainStartBtn:Find("free_tag"), arg0_27.isFree)
	setActive(arg0_27.gotIcon, arg0_27.isFree)
	eachChild(arg0_27.progressContent, function(arg0_28)
		local var0_28 = ""
		local var1_28 = tonumber(arg0_28.name)
		local var2_28 = var1_0[arg0_27.mgData:GetSimpleValue("mainChar")[var1_28]]

		setActive(arg0_28:Find("char_bg/mask"), false)
		setActive(arg0_28:Find("name_bg/mask"), false)
		setActive(arg0_28:Find("pass"), false)

		if var1_28 == arg0_27.curDay and arg0_27.hubData.count > 0 then
			var0_28 = "red"

			setImageSprite(arg0_28:Find("char_bg/icon"), arg0_27.icons:Find(arg0_27:getCharIndex(var2_28)):GetComponent(typeof(Image)).sprite, true)
		elseif var1_28 < arg0_27.curDay or var1_28 == arg0_27.curDay and arg0_27.hubData.count == 0 then
			var0_28 = "grey"

			setImageSprite(arg0_28:Find("char_bg/icon"), arg0_27.icons:Find(arg0_27:getCharIndex(var2_28)):GetComponent(typeof(Image)).sprite, true)
			setActive(arg0_28:Find("char_bg/mask"), true)
			setActive(arg0_28:Find("name_bg/mask"), true)
			setActive(arg0_28:Find("pass"), true)
		elseif var1_28 > arg0_27.curDay and var1_28 <= arg0_27.unlockDay then
			var0_28 = "blue"

			setImageSprite(arg0_28:Find("char_bg/icon"), arg0_27.icons:Find(arg0_27:getCharIndex(var2_28)):GetComponent(typeof(Image)).sprite, true)
		else
			var0_28 = "grey"

			setImageSprite(arg0_28:Find("char_bg/icon"), arg0_27.colors:Find("unkonwn"):GetComponent(typeof(Image)).sprite)
		end

		setImageSprite(arg0_28:Find("name_bg"), arg0_27.colors:Find(var0_28):GetComponent(typeof(Image)).sprite)
	end)

	local var0_27 = 215
	local var1_27 = math.min(645, (arg0_27.curDay - 1) * var0_27)

	arg0_27.progressContent.anchoredPosition = {
		x = 0,
		y = var1_27
	}

	onScroll(arg0_27, arg0_27.progressScroll, function(arg0_29)
		setActive(arg0_27.mainUI:Find("right_panel/arraws_up"), arg0_29.y < 1 and true or false)
		setActive(arg0_27.mainUI:Find("right_panel/arraws_down"), arg0_29.y > 0 and true or false)
	end)
end

function var0_0.initSelectUI(arg0_30)
	setActive(arg0_30.freeTitle, arg0_30.isFree)
	setActive(arg0_30.dayTitle, not arg0_30.isFree)
	setText(arg0_30.titleDayNum, arg0_30.curDay)
	setText(arg0_30.ruleTxt, i18n("venusvolleyball_rule_tip", arg0_30.endScore))

	arg0_30.charNames = {}
	arg0_30.lastSelectNames = {}

	eachChild(arg0_30.select4Chars, function(arg0_31)
		local var0_31 = arg0_31.name

		onButton(arg0_30, arg0_31, function()
			if not arg0_30.isFree and string.find(var0_31, "enemy") then
				return
			end

			arg0_30.selectCharCamp = string.find(var0_31, "enemy") and "enemy" or "our"

			arg0_30:openSelectWindow()
		end)
	end)

	if not arg0_30.isFree then
		local var0_30, var1_30 = arg0_30:getEnemyCharsIndex()

		arg0_30.charNames.enemy1, arg0_30.charNames.enemy2 = var1_0[var0_30], var1_0[var1_30]
	end

	arg0_30:refreshSelectUI()
end

function var0_0.getCharIndex(arg0_33, arg1_33)
	for iter0_33, iter1_33 in ipairs(var1_0) do
		if iter1_33 == arg1_33 then
			return iter0_33
		end
	end

	return 1
end

function var0_0.refreshSelectUI(arg0_34)
	eachChild(arg0_34.select4Chars, function(arg0_35)
		local var0_35 = arg0_35.name

		if arg0_34.charNames[var0_35] then
			setActive(arg0_35:Find("select_btn"), false)
			setActive(arg0_35:Find("char"), true)
			setImageSprite(arg0_35:Find("char/icon"), arg0_34.paints:Find(arg0_34:getCharIndex(arg0_34.charNames[var0_35])):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(arg0_35:Find("char/tag"), arg0_34.tags:Find(arg0_34:getCharIndex(arg0_34.charNames[var0_35])):GetComponent(typeof(Image)).sprite, true)
		else
			setActive(arg0_35:Find("select_btn"), true)
			setActive(arg0_35:Find("char"), false)
		end
	end)

	arg0_34.canStartGame = arg0_34.charNames.our1 and arg0_34.charNames.our2 and arg0_34.charNames.enemy1 and arg0_34.charNames.enemy2 and true or false

	setGray(arg0_34.selectStartBtn, not arg0_34.canStartGame, not arg0_34.canStartGame)
end

function var0_0.isSelected(arg0_36, arg1_36, arg2_36)
	local var0_36 = false

	for iter0_36, iter1_36 in pairs(arg0_36.charNames) do
		if arg1_36 == iter1_36 then
			var0_36 = not string.find(iter0_36, arg2_36) and true or false
		end
	end

	return var0_36
end

function var0_0.openSelectWindow(arg0_37)
	setActive(arg0_37.selectWindow, true)

	arg0_37.hasSelectNum = 0

	setText(arg0_37.selectNum, setColorStr(arg0_37.hasSelectNum, COLOR_GREEN) .. "/2")

	arg0_37.selectSDIndex1 = nil
	arg0_37.selectSDIndex2 = nil

	eachChild(arg0_37.select9Chars, function(arg0_38)
		local var0_38 = tonumber(arg0_38.name)

		setImageSprite(arg0_38:Find("char/frame/icon"), arg0_37.icons:Find(var0_38):GetComponent(typeof(Image)).sprite, true)
		onButton(arg0_37, arg0_38, function()
			if arg0_37:isSelected(var1_0[var0_38], arg0_37.selectCharCamp) then
				return
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var29_0)

			if isActive(arg0_38:Find("selected")) then
				setActive(arg0_38:Find("selected"), false)

				if arg0_37.selectSDIndex1 and arg0_37.selectSDIndex1 == var0_38 then
					arg0_37.selectSDIndex1 = nil
				end

				if arg0_37.selectSDIndex2 and arg0_37.selectSDIndex2 == var0_38 then
					arg0_37.selectSDIndex2 = nil
				end

				arg0_37.hasSelectNum = arg0_37.hasSelectNum - 1
			elseif arg0_37.selectSDIndex1 and arg0_37.selectSDIndex2 then
				-- block empty
			elseif arg0_37.selectSDIndex1 then
				arg0_37.selectSDIndex2 = var0_38
				arg0_37.hasSelectNum = arg0_37.hasSelectNum + 1
			else
				arg0_37.selectSDIndex1 = var0_38
				arg0_37.hasSelectNum = arg0_37.hasSelectNum + 1
			end

			arg0_37:refreshSelectWindow()
		end)
	end)
	arg0_37:refreshSelectWindow()
end

function var0_0.refreshSelectWindow(arg0_40)
	eachChild(arg0_40.select9Chars, function(arg0_41)
		local var0_41 = tonumber(arg0_41.name)

		setActive(arg0_41:Find("char/mask"), arg0_40:isSelected(var1_0[var0_41], arg0_40.selectCharCamp) and true or false)

		if var0_41 == arg0_40.selectSDIndex1 or var0_41 == arg0_40.selectSDIndex2 then
			setActive(arg0_41:Find("selected"), true)
		else
			setActive(arg0_41:Find("selected"), false)
		end
	end)
	setText(arg0_40.selectNum, setColorStr(arg0_40.hasSelectNum, COLOR_GREEN) .. "/2")

	arg0_40.canSureChar = arg0_40.selectSDIndex1 and arg0_40.selectSDIndex2 and true or false

	setGray(arg0_40.selectSureBtn, not arg0_40.canSureChar, not arg0_40.canSureChar)
end

function var0_0.firstShow(arg0_42, arg1_42)
	setActive(arg0_42.helpUI, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_42.helpUI)
	onButton(arg0_42, arg0_42.helpUI, function()
		local var0_43 = getProxy(PlayerProxy):getData().id

		PlayerPrefs.SetInt("volleyballgame_first_" .. var0_43, 1)
		setActive(arg0_42.helpUI, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_42.helpUI, arg0_42._tf)

		if arg1_42 then
			arg1_42()
		end
	end, SFX_PANEL)
end

function var0_0.startCountTimer(arg0_44)
	arg0_44:setBtnAvailable(false)
	setActive(arg0_44.countTimeUI, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_44.countTimeUI)

	arg0_44.countTime = 3

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var28_0)
	setImageSprite(arg0_44.countTimeImage, arg0_44.countTimeNumImage:Find(arg0_44.countTime):GetComponent(typeof(Image)).sprite)

	local function var0_44()
		arg0_44.countTime = arg0_44.countTime - 1

		if arg0_44.countTime <= 0 then
			setActive(arg0_44.countTimeUI, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_44.countTimeUI, arg0_44._tf)
			arg0_44:resetGameAni()
			arg0_44:startGame()
		else
			setImageSprite(arg0_44.countTimeImage, arg0_44.countTimeNumImage:Find(arg0_44.countTime):GetComponent(typeof(Image)).sprite)
		end
	end

	if arg0_44.countTimer then
		arg0_44.countTimer:Reset(var0_44, 1, -1)
	else
		arg0_44.countTimer = Timer.New(var0_44, 1, -1)
	end

	arg0_44.countTimer:Start()
end

function var0_0.setBtnAvailable(arg0_46, arg1_46)
	arg0_46.btnAvailable = arg1_46

	setGray(arg0_46.backBtn, not arg1_46, not arg1_46)
	setGray(arg0_46.pauseBtn, not arg1_46, not arg1_46)
end

function var0_0.startGame(arg0_47)
	arg0_47.isInGame = true

	arg0_47:setBtnAvailable(true)
	setActive(arg0_47.bgEffect, false)
	setActive(arg0_47.bgEffect, true)

	if arg0_47.beginTeam == var3_0 then
		arg0_47:ourServe(function()
			arg0_47:enemyUp2Up(function()
				arg0_47:enemyUp2Hit(function()
					arg0_47:enemyThrow(function()
						arg0_47:enterLoop()
					end)
				end)
			end)
		end)
	else
		arg0_47:enemyServe(function()
			arg0_47:enterLoop()
		end)
	end
end

function var0_0.enterLoop(arg0_53)
	arg0_53:ourUp2Up(function()
		arg0_53:ourUp2Hit(function()
			arg0_53:ourThrow(function()
				arg0_53:enemyUp2Up(function()
					arg0_53:enemyUp2Hit(function()
						arg0_53:enemyThrow(function()
							arg0_53:enterLoop()
						end)
					end)
				end)
			end)
		end)
	end)
end

function var0_0.ourServe(arg0_60, arg1_60)
	arg0_60.ballPosTag = "our_serve"

	setActive(arg0_60.ball, true)
	arg0_60:charServeBall()
	arg0_60:managedTween(LeanTween.delayedCall, function()
		local var0_61 = "enemy" .. math.random(2)

		arg0_60.ballPosTag = var0_61
		arg0_60.anchoredPos[arg0_60.ballPosTag] = arg0_60:getRandomPos(arg0_60.ballPosTag)

		arg0_60:ballServe(arg0_60.ball, var15_0, arg0_60.anchoredPos[var0_61], function()
			if arg1_60 then
				arg1_60()
			end
		end)
		arg0_60:managedTween(LeanTween.delayedCall, function()
			arg0_60:charUpBall()
		end, var15_0 - var21_0, nil)
	end, var20_0 + 0.5, nil)
end

function var0_0.enemyServe(arg0_64, arg1_64)
	arg0_64.ballPosTag = "enemy_serve"

	setActive(arg0_64.ball, true)
	arg0_64:charServeBall()
	arg0_64:managedTween(LeanTween.delayedCall, function()
		local var0_65 = "our" .. math.random(2)

		arg0_64.ballPosTag = var0_65
		arg0_64.anchoredPos[arg0_64.ballPosTag] = arg0_64:getRandomPos(arg0_64.ballPosTag)

		arg0_64:ballServe(arg0_64.ball, var15_0, arg0_64.anchoredPos[var0_65], function()
			if arg1_64 then
				arg1_64()
			end
		end)
		arg0_64:managedTween(LeanTween.delayedCall, function()
			arg0_64:charUpBall()
		end, var15_0 - var21_0, nil)
	end, var20_0 + 0.5, nil)
end

function var0_0.ourUp2Up(arg0_68, arg1_68)
	if arg0_68.qteStatus == var11_0 and arg0_68.qteType == var13_0 then
		arg0_68:ourFly()

		return
	end

	arg0_68.ballPosTag = arg0_68.ballPosTag == "our1" and "our2" or "our1"

	arg0_68:ballUp2Up(arg0_68.ball, var16_0, arg0_68.anchoredPos[arg0_68.ballPosTag], function()
		if arg1_68 then
			arg1_68()
		end
	end)
	arg0_68:managedTween(LeanTween.delayedCall, function()
		arg0_68:charUpBall()
	end, 0.3, nil)
end

function var0_0.ourUp2Hit(arg0_71, arg1_71)
	local var0_71 = {}

	arg0_71.ballPosTag = arg0_71.ballPosTag == "our1" and "our2" or "our1"
	arg0_71.anchoredPos[arg0_71.ballPosTag] = arg0_71:getRandomPos(arg0_71.ballPosTag)
	arg0_71.qteType = var14_0

	arg0_71:charHitBall()

	local var1_71 = false

	local function var2_71(arg0_72)
		if var1_71 then
			arg0_72()
		else
			var1_71 = true
		end
	end

	table.insert(var0_71, function(arg0_73)
		local function var0_73()
			if arg0_71.isCutin then
				arg0_71:showcutin(function()
					arg0_71.isCutin = false

					arg0_73()
				end)
			else
				arg0_73()
			end
		end

		arg0_71:managedTween(LeanTween.delayedCall, function()
			var2_71(var0_73)
		end, var16_0 - 0.2, nil)
		arg0_71:managedTween(LeanTween.delayedCall, function()
			arg0_71:startQTE(var32_0, 200, arg0_71.anchoredPos[arg0_71.ballPosTag], function()
				var2_71(var0_73)
			end)
		end, var16_0 - var32_0 - 0.2, nil)
	end)
	table.insert(var0_71, function(arg0_79)
		arg0_71:ballUp2Hit(arg0_71.ball, var16_0, arg0_71.anchoredPos[arg0_71.ballPosTag], arg0_79)
	end)
	parallelAsync(var0_71, function()
		if arg1_71 then
			arg1_71()
		end
	end)
end

function var0_0.ourThrow(arg0_81, arg1_81)
	local var0_81 = "enemy" .. math.random(2)

	arg0_81.ballPosTag = var0_81
	arg0_81.anchoredPos[arg0_81.ballPosTag] = arg0_81:getRandomPos(arg0_81.ballPosTag)

	arg0_81:ballHit(arg0_81.ball, var17_0, arg0_81.anchoredPos[var0_81], function()
		if arg1_81 then
			arg1_81()
		end
	end)
	arg0_81:charUpBall()
end

function var0_0.enemyUp2Up(arg0_83, arg1_83)
	if arg0_83.qteStatus == var10_0 and arg0_83.qteType == var14_0 then
		arg0_83:enemyFly()

		return
	end

	arg0_83.ballPosTag = arg0_83.ballPosTag == "enemy1" and "enemy2" or "enemy1"

	arg0_83:ballUp2Up(arg0_83.ball, var16_0, arg0_83.anchoredPos[arg0_83.ballPosTag], function()
		if arg1_83 then
			arg1_83()
		end
	end)
	arg0_83:managedTween(LeanTween.delayedCall, function()
		arg0_83:charUpBall()
	end, 0.3, nil)
end

function var0_0.enemyUp2Hit(arg0_86, arg1_86)
	arg0_86.ballPosTag = arg0_86.ballPosTag == "enemy1" and "enemy2" or "enemy1"
	arg0_86.anchoredPos[arg0_86.ballPosTag] = arg0_86:getRandomPos(arg0_86.ballPosTag)
	arg0_86.randomQtePos = "our" .. math.random(2)
	arg0_86.anchoredPos[arg0_86.randomQtePos] = arg0_86:getRandomPos(arg0_86.randomQtePos)
	arg0_86.qteType = var13_0

	arg0_86:managedTween(LeanTween.delayedCall, function()
		arg0_86:startQTE(var32_0, 0, arg0_86.anchoredPos[arg0_86.randomQtePos])
	end, var16_0 - var32_0, nil)
	arg0_86:ballUp2Hit(arg0_86.ball, var16_0, arg0_86.anchoredPos[arg0_86.ballPosTag], function()
		if arg1_86 then
			arg1_86()
		end
	end)
	arg0_86:charHitBall()
end

function var0_0.enemyThrow(arg0_89, arg1_89)
	arg0_89.ballPosTag = arg0_89.randomQtePos

	arg0_89:ballHit(arg0_89.ball, var17_0, arg0_89.anchoredPos[arg0_89.ballPosTag], function()
		if arg1_89 then
			arg1_89()
		end
	end)
	arg0_89:charUpBall()
end

function var0_0.ourFly(arg0_91)
	arg0_91.ballPosTag = "out"

	local var0_91 = math.random(1000, 1100)
	local var1_91 = math.random(0, 200)

	arg0_91:hitFly(arg0_91.ball, var18_0, {
		x = -var0_91,
		y = var1_91 - 100
	}, function()
		arg0_91.qteStatus = var9_0

		setGray(arg0_91.qteBtn, true, true)

		arg0_91.enemyScoreNum = arg0_91.enemyScoreNum + 1

		arg0_91:updateScore()
	end)
end

function var0_0.enemyFly(arg0_93)
	arg0_93.ballPosTag = "out"

	local var0_93 = math.random(1000, 1100)
	local var1_93 = math.random(0, 200)

	arg0_93:hitFly(arg0_93.ball, var18_0, {
		x = var0_93,
		y = var1_93 - 100
	}, function()
		arg0_93.qteStatus = var9_0

		setGray(arg0_93.qteBtn, true, true)

		arg0_93.ourScoreNum = arg0_93.ourScoreNum + 1

		arg0_93:updateScore()
	end)
end

function var0_0.qteSuccess(arg0_95)
	arg0_95.qteStatus = var10_0
	arg0_95.beginTeam = var3_0

	arg0_95:changeQTEBtnStatus(var5_0)
end

function var0_0.qteFail(arg0_96)
	arg0_96.qteStatus = var11_0
	arg0_96.beginTeam = var4_0

	arg0_96:changeQTEBtnStatus(var5_0)
end

function var0_0.GetBeziersPoints(arg0_97, arg1_97, arg2_97, arg3_97, arg4_97)
	local function var0_97(arg0_98)
		local var0_98 = arg1_97:Clone():Mul((1 - arg0_98) * (1 - arg0_98))
		local var1_98 = arg2_97:Clone():Mul(2 * arg0_98 * (1 - arg0_98))
		local var2_98 = arg3_97:Clone():Mul(arg0_98 * arg0_98)

		return var0_98:Clone():Add(var1_98):Add(var2_98)
	end

	local var1_97 = {}

	table.insert(var1_97, Vector3(0, 0, 0))
	table.insert(var1_97, var0_97(0))

	for iter0_97 = 1, arg4_97 do
		local var2_97 = iter0_97 / arg4_97

		table.insert(var1_97, var0_97(var2_97))
	end

	table.insert(var1_97, Vector3(0, 0, 0))

	return var1_97
end

function var0_0.ballParabolaMove(arg0_99, arg1_99, arg2_99, arg3_99, arg4_99, arg5_99, arg6_99)
	local var0_99 = Vector2(arg1_99.anchoredPosition.x, arg1_99.anchoredPosition.y - arg5_99)
	local var1_99 = Vector2(arg3_99.x, arg3_99.y)
	local var2_99 = var1_99.x - var0_99.x
	local var3_99 = var1_99.y - var0_99.y
	local var4_99 = math.abs(arg6_99 - arg5_99)
	local var5_99 = DOAParabolaCalc(arg2_99, math.abs(var33_0), var4_99)
	local var6_99
	local var7_99

	if arg5_99 < arg6_99 then
		var6_99 = var5_99 + var4_99

		local var8_99 = var5_99
	else
		var6_99 = var5_99

		local var9_99 = var5_99 + var4_99
	end

	local var10_99 = math.sqrt(2 * math.abs(var33_0) * var6_99)

	arg0_99:managedTween(LeanTween.value, function()
		if arg4_99 then
			arg4_99()
		end
	end, go(arg1_99), 0, arg2_99, arg2_99):setOnUpdate(System.Action_float(function(arg0_101)
		local var0_101 = var2_99 * arg0_101 / arg2_99
		local var1_101 = var3_99 * arg0_101 / arg2_99
		local var2_101 = var10_99 * arg0_101 + 0.5 * var33_0 * arg0_101 * arg0_101

		arg1_99.anchoredPosition = Vector2(var0_99.x + var0_101, var0_99.y + var1_101 + arg5_99 + var2_101)
	end))
end

function var0_0.ballServe(arg0_102, arg1_102, arg2_102, arg3_102, arg4_102)
	arg0_102:ballParabolaMove(arg1_102, arg2_102, arg3_102, function()
		if arg4_102 then
			arg4_102()
		end
	end, var24_0, var25_0)
	arg0_102:managedTween(LeanTween.move, nil, arg0_102.ballShadow, Vector3(arg3_102.x, arg3_102.y + var23_0), arg2_102):setEase(LeanTweenType.linear)
end

function var0_0.ballUp2Up(arg0_104, arg1_104, arg2_104, arg3_104, arg4_104)
	arg0_104:ballParabolaMove(arg1_104, arg2_104, arg3_104, function()
		if arg4_104 then
			arg4_104()
		end
	end, var25_0, var25_0)
	arg0_104:managedTween(LeanTween.move, nil, arg0_104.ballShadow, Vector3(arg3_104.x, arg3_104.y + var23_0), arg2_104):setEase(LeanTweenType.linear)
end

function var0_0.ballUp2Hit(arg0_106, arg1_106, arg2_106, arg3_106, arg4_106)
	local var0_106 = {
		x = arg3_106.x,
		y = arg3_106.y
	}

	arg0_106:ballParabolaMove(arg1_106, arg2_106, var0_106, function()
		if arg4_106 then
			arg4_106()
		end
	end, var25_0, var26_0)
	arg0_106:managedTween(LeanTween.move, nil, arg0_106.ballShadow, Vector3(arg3_106.x, arg3_106.y + var23_0), arg2_106):setEase(LeanTweenType.linear)
end

function var0_0.ballHit(arg0_108, arg1_108, arg2_108, arg3_108, arg4_108)
	arg3_108 = Vector2(arg3_108.x, arg3_108.y + var25_0)

	arg0_108:managedTween(LeanTween.moveX, function()
		if arg4_108 then
			arg4_108()
		end
	end, arg1_108, arg3_108.x, arg2_108):setEase(LeanTweenType.linear)
	arg0_108:managedTween(LeanTween.moveY, nil, arg1_108, arg3_108.y, arg2_108):setEase(LeanTweenType.linear)
	arg0_108:managedTween(LeanTween.move, nil, arg0_108.ballShadow, Vector3(arg3_108.x, arg3_108.y + var23_0), arg2_108):setEase(LeanTweenType.linear)
end

function var0_0.charMove(arg0_110, arg1_110, arg2_110, arg3_110, arg4_110)
	arg0_110:managedTween(LeanTween.moveX, nil, arg1_110, arg3_110.x, arg2_110):setEase(LeanTweenType.easeOutQuad)
	arg0_110:managedTween(LeanTween.moveY, function()
		if arg4_110 then
			arg4_110()
		end
	end, arg1_110, arg3_110.y, arg2_110):setEase(LeanTweenType.linear)
end

function var0_0.hitFly(arg0_112, arg1_112, arg2_112, arg3_112, arg4_112)
	arg0_112:ballParabolaMove(arg1_112, arg2_112, arg3_112, function()
		if arg4_112 then
			arg4_112()
		end
	end, var27_0, var26_0)
	arg0_112:managedTween(LeanTween.move, nil, arg0_112.ballShadow, Vector3(arg3_112.x, arg3_112.y + var23_0), arg2_112):setEase(LeanTweenType.linear)
end

function var0_0.startQTE(arg0_114, arg1_114, arg2_114, arg3_114, arg4_114)
	arg0_114:changeQTEBtnStatus(var6_0)

	arg0_114.qte.anchoredPosition = {
		x = arg3_114.x,
		y = arg3_114.y + arg2_114
	}

	setActive(arg0_114.qte, true)
	setActive(arg0_114.qteCircles, true)
	setActive(arg0_114.result, false)
	setLocalScale(arg0_114.qteCircle, Vector3(1, 1, 1))
	arg0_114.result:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_115)
		setActive(arg0_114.result, false)
	end)

	arg0_114.qteCallback = arg4_114
	arg0_114.qteTween = LeanTween.scale(arg0_114.qteCircle, Vector3(0, 0, 1), arg1_114):setOnComplete(System.Action(function()
		arg0_114:changeQTEBtnStatus(var5_0)
		setImageSprite(arg0_114.result, arg0_114.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		setActive(arg0_114.result, true)
		arg0_114:qteFail()

		arg0_114.isCutin = false

		setActive(arg0_114.qteCircles, false)
		existCall(arg0_114.qteCallback)

		arg0_114.qteCallback = nil
	end)).uniqueId
end

function var0_0.qteResult(arg0_117)
	if LeanTween.isTweening(arg0_117.qteTween) then
		LeanTween.cancel(arg0_117.qteTween, false)
	end

	local var0_117 = math.abs(arg0_117.qteCircle.localScale.x)

	setActive(arg0_117.result, true)

	arg0_117.isCutin = false

	if var0_117 <= 0 or var0_117 > var7_0 then
		setImageSprite(arg0_117.result, arg0_117.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		arg0_117:qteFail()
	elseif var0_117 > var8_0 then
		setImageSprite(arg0_117.result, arg0_117.resultTxt:Find("good"):GetComponent(typeof(Image)).sprite, true)
		arg0_117:qteSuccess()
	else
		setImageSprite(arg0_117.result, arg0_117.resultTxt:Find("perfect"):GetComponent(typeof(Image)).sprite, true)
		arg0_117:qteSuccess()

		if arg0_117.qteType == var14_0 then
			arg0_117.isCutin = true
		else
			arg0_117.isCutin = false
		end
	end

	setActive(arg0_117.qteCircles, false)
	existCall(arg0_117.qteCallback)

	arg0_117.qteCallback = nil
end

local function var34_0(arg0_118, arg1_118, arg2_118, arg3_118, arg4_118)
	local var0_118 = {
		_tf = arg1_118,
		spineAnim = arg2_118,
		skele = arg3_118,
		posTag = arg4_118
	}

	function var0_118.ctor(arg0_119)
		var0_118._tf.anchoredPosition = arg0_118.anchoredPos[arg4_118]
	end

	function var0_118.setPosTag(arg0_120, arg1_120)
		var0_118._tf.anchoredPosition = arg0_118.anchoredPos[arg1_120]
		var0_118.posTag = arg1_120
	end

	function var0_118.getPosTag(arg0_121)
		return var0_118.posTag
	end

	function var0_118.pauseSpine(arg0_122)
		var0_118.skele.timeScale = 0
	end

	function var0_118.resumeSpine(arg0_123)
		var0_118.skele.timeScale = 1
	end

	function var0_118.setActionOnce(arg0_124, arg1_124, arg2_124)
		var0_118.spineAnim:SetActionCallBack(function(arg0_125)
			if arg0_125 == "action" then
				if arg1_124 == "chuanqiu" or arg1_124 == "dianqiu" then
					arg0_118:playEffect(arg0_118.upEffect, Vector2(var0_118._tf.anchoredPosition.x, var0_118._tf.anchoredPosition.y + var25_0))
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var30_0)
				elseif arg1_124 == "kouqiu" then
					arg0_118:playEffect(arg0_118.hitEffect, Vector2(var0_118._tf.anchoredPosition.x, var0_118._tf.anchoredPosition.y + var25_0 + var26_0))
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var31_0)
				elseif arg1_124 == "faqiu" then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var30_0)
					arg0_118:playEffect(arg0_118.upEffect, Vector2(var0_118._tf.anchoredPosition.x, var0_118._tf.anchoredPosition.y + var24_0))
				end
			end

			if arg0_125 == "finish" then
				var0_118.spineAnim:SetActionCallBack(nil)

				if arg2_124 then
					arg2_124()
				else
					var0_118.spineAnim:SetAction("normal2", 0)
				end
			end
		end)
		var0_118.spineAnim:SetAction(arg1_124, 0)
	end

	function var0_118.move(arg0_126, arg1_126, arg2_126, arg3_126, arg4_126)
		local function var0_126()
			var0_118.spineAnim:SetAction("run", 0)

			var0_118.posTag = arg2_126

			arg0_118:charMove(var0_118._tf, arg1_126, arg0_118.anchoredPos[arg2_126], function()
				if arg4_126 then
					arg4_126()
				else
					var0_118.spineAnim:SetAction("normal2", 0)
				end
			end)
		end

		if arg3_126 then
			var0_118:setActionOnce(arg3_126, function()
				var0_126()
			end)
		else
			var0_126()
		end
	end

	var0_118:ctor()

	return var0_118
end

function var0_0.getRandomPos(arg0_130, arg1_130)
	local var0_130 = math.random(0, 300)
	local var1_130 = math.random(0, 50)
	local var2_130 = arg0_130.orgPos[arg1_130]
	local var3_130 = var2_130

	if string.find(arg1_130, "our") then
		var3_130 = {
			x = var2_130.x + var0_130 - 50,
			y = var2_130.y + var1_130 - 25
		}
	else
		var3_130 = {
			x = var2_130.x + var0_130 - 250,
			y = var2_130.y + var1_130 - 25
		}
	end

	return var3_130
end

function var0_0.loadSpineChars(arg0_131)
	arg0_131:clearSpineChars()

	arg0_131.beginTeam = math.random(2)

	if arg0_131.beginTeam == var3_0 then
		arg0_131.serveChar = "our" .. math.random(2)
	else
		arg0_131.serveChar = "enemy" .. math.random(2)
	end

	arg0_131:setBallPos()

	for iter0_131, iter1_131 in pairs(arg0_131.charNames) do
		arg0_131:loadOneSpineChar(iter0_131, arg0_131.serveChar)
	end
end

function var0_0.loadOneSpineChar(arg0_132, arg1_132, arg2_132)
	if not arg0_132.charNames[arg1_132] then
		arg0_132.charNames[arg1_132] = false

		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg0_132.charNames[arg1_132], true, function(arg0_133)
		pg.UIMgr.GetInstance():LoadingOff()

		local var0_133 = ""
		local var1_133

		if string.find(arg1_132, "our") then
			tf(arg0_133).localScale = Vector3(0.6, 0.6, 1)
			tf(arg0_133).localPosition = Vector3(-20, 0, 0)

			if string.find(arg1_132, "1") then
				var1_133 = "our1"
			else
				var1_133 = "our2"
			end
		else
			tf(arg0_133).localScale = Vector3(-0.6, 0.6, 1)
			tf(arg0_133).localPosition = Vector3(20, 0, 0)
			var1_133 = string.find(arg1_132, "1") and "enemy1" or "enemy2"
		end

		arg0_132.charModels[arg1_132] = arg0_133

		local var2_133 = arg0_133:GetComponent("SpineAnimUI")
		local var3_133 = arg0_133:GetComponent("SkeletonGraphic")

		var2_133:SetAction("normal2", 0)

		var3_133.timeScale = 1

		local var4_133 = arg0_132._tf:Find("game_ui/char/" .. arg1_132)

		setParent(arg0_133, var4_133)

		arg0_132.charactor[arg1_132] = var34_0(arg0_132, var4_133, var2_133, var3_133, var1_133)

		if arg1_132 == arg2_132 then
			if arg0_132.beginTeam == var3_0 then
				arg0_132.charactor[arg1_132]:setPosTag("our_serve")
			else
				arg0_132.charactor[arg1_132]:setPosTag("enemy_serve")
			end
		end
	end)
end

function var0_0.clearSpineChars(arg0_134)
	for iter0_134, iter1_134 in pairs(arg0_134.charModels) do
		if arg0_134.charModels[iter0_134] and arg0_134.charNames[iter0_134] then
			PoolMgr.GetInstance():ReturnSpineChar(arg0_134.charNames[iter0_134], arg0_134.charModels[iter0_134])
		end
	end

	arg0_134.charModels = {}
end

function var0_0.getCharWithTag(arg0_135, arg1_135)
	for iter0_135, iter1_135 in pairs(arg0_135.charactor) do
		if iter1_135:getPosTag() == arg1_135 then
			return iter0_135, iter1_135
		end
	end

	return nil
end

function var0_0.getAnotherChar(arg0_136, arg1_136)
	local var0_136 = ""

	if string.find(arg1_136, "our") then
		var0_136 = arg1_136 == "our1" and "our2" or "our1"
	elseif string.find(arg1_136, "enemy") then
		var0_136 = arg1_136 == "enemy1" and "enemy2" or "enemy1"
	end

	return var0_136, arg0_136.charactor[var0_136]
end

function var0_0.setBallPos(arg0_137)
	setActive(arg0_137.ball, true)

	local var0_137 = string.find(arg0_137.serveChar, "our") and "our_serve" or "enemy_serve"

	arg0_137.ball.anchoredPosition = {
		x = arg0_137.orgPos[var0_137].x,
		y = arg0_137.orgPos[var0_137].y + 300
	}
	arg0_137.ballShadow.anchoredPosition = Vector3(arg0_137.orgPos[var0_137].x, arg0_137.orgPos[var0_137].y, 0)

	arg0_137:managedTween(LeanTween.rotate, nil, arg0_137.ball, 360, 0.5):setLoopClamp()
end

function var0_0.resetChar(arg0_138)
	arg0_138:resetPos()

	for iter0_138, iter1_138 in pairs(arg0_138.charactor) do
		if LeanTween.isTweening(go(iter1_138._tf)) then
			LeanTween.cancel(go(iter1_138._tf))
		end
	end

	arg0_138.charactor.our1:setPosTag("our1")
	arg0_138.charactor.our2:setPosTag("our2")
	arg0_138.charactor.enemy1:setPosTag("enemy1")
	arg0_138.charactor.enemy2:setPosTag("enemy2")

	if arg0_138.beginTeam == var3_0 then
		arg0_138.serveChar = "our" .. math.random(2)

		arg0_138.charactor[arg0_138.serveChar]:setPosTag("our_serve")
	else
		arg0_138.serveChar = "enemy" .. math.random(2)

		arg0_138.charactor[arg0_138.serveChar]:setPosTag("enemy_serve")
	end

	arg0_138:setBallPos()
end

function var0_0.charServeBall(arg0_139)
	arg0_139:managedTween(LeanTween.rotate, nil, arg0_139.ball, 360, 0.5):setLoopClamp()

	local var0_139 = string.find(arg0_139.serveChar, "our") and "our_serve" or "enemy_serve"

	arg0_139:managedTween(LeanTween.delayedCall, function()
		arg0_139:managedTween(LeanTween.moveY, nil, arg0_139.ball, arg0_139.orgPos[var0_139].y + var24_0, 0.5):setEase(LeanTweenType.linear)
		arg0_139.charactor[arg0_139.serveChar]:setActionOnce("faqiu", function()
			arg0_139:managedTween(LeanTween.delayedCall, function()
				arg0_139.charactor[arg0_139.serveChar]:move(1, arg0_139.serveChar)
			end, 0.2, nil)
		end)
	end, 0.5, nil)
end

function var0_0.charUpBall(arg0_143, arg1_143)
	local var0_143, var1_143 = arg0_143:getCharWithTag(arg0_143.ballPosTag)

	if not var1_143 then
		return
	end

	arg0_143.upChar = var0_143
	arg0_143.hitChar = arg0_143:getAnotherChar(arg0_143.upChar)

	var1_143:move(0.45, arg0_143.ballPosTag, nil, function()
		var1_143:setActionOnce("chuanqiu")
	end)
end

function var0_0.charHitBall(arg0_145)
	local var0_145 = arg0_145.charactor[arg0_145.hitChar]

	var0_145:move(0.5, arg0_145.ballPosTag, nil, function()
		var0_145:setActionOnce("kouqiu")
	end)
end

function var0_0.showcutin(arg0_147, arg1_147)
	arg0_147:setBtnAvailable(false)
	arg0_147:pauseGame()
	setActive(arg0_147.cutin, true)

	local var0_147 = ""

	for iter0_147, iter1_147 in pairs(arg0_147.charNames) do
		if iter0_147 == arg0_147.hitChar then
			var0_147 = iter1_147
		end
	end

	local var1_147, var2_147, var3_147 = ShipWordHelper.GetWordAndCV(var2_0[arg0_147:getCharIndex(var0_147)], "skill")

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_147)
	setActive(arg0_147.gameUI:Find("line"), true)
	setActive(arg0_147.cutin:Find("shatanpaiqiu_cutin"), false)
	setActive(arg0_147.cutin:Find("shatanpaiqiu_cutin"), true)
	setImageSprite(arg0_147.cutinPaint, arg0_147.cutinPaints:Find(arg0_147:getCharIndex(var0_147)):GetComponent(typeof(Image)).sprite, true)
	LeanTween.moveX(arg0_147.cutin, 0, 0.3):setOnComplete(System.Action(function()
		LeanTween.delayedCall(1, System.Action(function()
			setActive(arg0_147.gameUI:Find("line"), false)
			LeanTween.moveX(arg0_147.cutin, -567, 0.3):setOnComplete(System.Action(function()
				setActive(arg0_147.cutin, false)
				arg0_147:setBtnAvailable(true)
				arg0_147:resumeGame()

				if arg1_147 then
					arg1_147()
				end
			end))
		end))
	end))
end

function var0_0.showScoreCutin(arg0_151, arg1_151)
	arg0_151:setBtnAvailable(false)
	arg0_151:pauseGame()
	setImageSprite(arg0_151.ourScoreCutin, arg0_151.scoreCutinNums:Find(arg0_151.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0_151.enemyScoreCutin, arg0_151.scoreCutinNums:Find(arg0_151.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)
	setActive(arg0_151.scoreCutin, true)
	setLocalScale(arg0_151.scoreCutin, Vector3(1, 0, 1))
	LeanTween.scale(arg0_151.scoreCutin, Vector3(1, 1, 1), 0.2):setOnComplete(System.Action(function()
		arg0_151:resetChar()
		LeanTween.delayedCall(0.6, System.Action(function()
			LeanTween.scale(arg0_151.scoreCutin, Vector3(1, 0, 1), 0.2):setOnComplete(System.Action(function()
				setActive(arg0_151.scoreCutin, false)
				arg0_151:setBtnAvailable(true)
				arg0_151:resumeGame()

				if arg1_151 then
					arg1_151()
				end
			end))
		end))
	end))
end

function var0_0.updateScore(arg0_155)
	setText(arg0_155.ourScore, arg0_155.ourScoreNum)
	setText(arg0_155.enemyScore, arg0_155.enemyScoreNum)
	setActive(arg0_155.qte, false)

	if arg0_155.ourScoreNum >= arg0_155.endScore or arg0_155.enemyScoreNum >= arg0_155.endScore then
		arg0_155:endGame()
	else
		arg0_155:showScoreCutin(function()
			arg0_155:startGame()
		end)
	end
end

function var0_0.endGame(arg0_157)
	setActive(arg0_157.winTag, arg0_157.ourScoreNum ~= arg0_157.enemyScoreNum)
	setActive(arg0_157.loseTag, arg0_157.ourScoreNum ~= arg0_157.enemyScoreNum)
	arg0_157:setBtnAvailable(false)

	arg0_157.isInGame = false

	pg.UIMgr.GetInstance():BlurPanel(arg0_157.endUI)
	setActive(arg0_157.endUI, true)
	setActive(arg0_157.endFreeTitle, arg0_157.isFree)
	setActive(arg0_157.endDayTitle, not arg0_157.isFree)
	setImageSprite(arg0_157.endTitleDay, arg0_157.titleDays:Find(arg0_157.curDay):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0_157.endOurScore, arg0_157.endScoreNums:Find(arg0_157.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0_157.endEnemyScore, arg0_157.endScoreNums:Find(arg0_157.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)

	local var0_157 = -20
	local var1_157

	if arg0_157.ourScoreNum > arg0_157.enemyScoreNum then
		arg0_157.winTag.anchoredPosition = Vector3(-170, 200, 0)
		arg0_157.loseTag.anchoredPosition = Vector3(180, 200, 0)
		var1_157 = -20
	else
		arg0_157.winTag.anchoredPosition = Vector3(170, 200, 0)
		arg0_157.loseTag.anchoredPosition = Vector3(-180, 200, 0)
		var1_157 = 20
	end

	setActive(arg0_157.winTag:GetChild(0), false)
	setActive(arg0_157.winTag:GetChild(0), true)
	setLocalRotation(arg0_157.loseTag, Vector3(0, 0, 0))
	LeanTween.rotateZ(go(arg0_157.loseTag), var1_157, 0.2):setOnComplete(System.Action(function()
		if arg0_157:GetMGHubData().count > 0 then
			arg0_157:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
		end
	end))
end

function var0_0.OnGetAwardDone(arg0_159, arg1_159)
	if arg1_159.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_159 = arg0_159:GetMGHubData()
		local var1_159 = var0_159.ultimate
		local var2_159 = var0_159.usedtime
		local var3_159 = var0_159:getConfig("reward_need")
		local var4_159 = arg0_159:GetMGHubData().count
		local var5_159 = pg.NewStoryMgr.GetInstance()
		local var6_159 = arg0_159.storylist[arg0_159:GetMGHubData().usedtime] and arg0_159.storylist[arg0_159:GetMGHubData().usedtime][1] or nil

		if var2_159 ~= 7 and var6_159 and not var5_159:IsPlayed(var6_159) then
			var5_159:Play(var6_159)
		end

		if var1_159 == 0 and var3_159 <= var2_159 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_159.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif arg1_159.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		local var7_159 = arg0_159.storylist[7][1] and arg0_159.storylist[7][1] or nil
		local var8_159 = pg.NewStoryMgr.GetInstance()

		if var7_159 and not var8_159:IsPlayed(var7_159) then
			var8_159:Play(var7_159)
		end
	end
end

function var0_0.pauseGame(arg0_160)
	arg0_160:pauseManagedTween()

	if arg0_160.qteTimer then
		arg0_160.qteTimer:Pause()
	end

	if arg0_160.qteTween and LeanTween.isTweening(arg0_160.qteTween) then
		LeanTween.pause(arg0_160.qteTween)
	end

	for iter0_160, iter1_160 in pairs(arg0_160.charactor) do
		iter1_160:pauseSpine()
	end
end

function var0_0.resumeGame(arg0_161)
	arg0_161:resumeManagedTween()

	if arg0_161.qteTimer then
		arg0_161.qteTimer:Resume()
	end

	if arg0_161.qteTween and LeanTween.isTweening(arg0_161.qteTween) then
		LeanTween.resume(arg0_161.qteTween)
	end

	for iter0_161, iter1_161 in pairs(arg0_161.charactor) do
		iter1_161:resumeSpine()
	end
end

function var0_0.clearTimer(arg0_162)
	if arg0_162.qteTimer then
		arg0_162.qteTimer:Stop()

		arg0_162.qteTimer = nil
	end

	if arg0_162.countTimer then
		arg0_162.countTimer:Stop()

		arg0_162.countTimer = nil
	end
end

function var0_0.changeQTEBtnStatus(arg0_163, arg1_163)
	arg0_163.qteBtnStatus = arg1_163
end

function var0_0.resetGameData(arg0_164)
	arg0_164.qteStatus = var9_0
	arg0_164.qteType = var12_0

	arg0_164:changeQTEBtnStatus(var5_0)

	arg0_164.ballPosTag = ""
	arg0_164.isCutin = false
	arg0_164.cutin.anchoredPosition = {
		x = -567,
		y = 582
	}
	arg0_164.isScoreCutin = false

	setActive(arg0_164.scoreCutin, false)

	arg0_164.ourScoreNum = 0
	arg0_164.enemyScoreNum = 0

	setText(arg0_164.ourScore, arg0_164.ourScoreNum)
	setText(arg0_164.enemyScore, arg0_164.enemyScoreNum)
	setActive(arg0_164.qte, false)
	arg0_164:loadSpineChars()
end

function var0_0.exitGame(arg0_165)
	arg0_165.isInGame = false

	arg0_165:setBtnAvailable(true)
	arg0_165:resetGameAni()
end

function var0_0.resetGameAni(arg0_166)
	arg0_166:cleanManagedTween()

	if arg0_166.qteTween and LeanTween.isTweening(arg0_166.qteTween) then
		LeanTween.cancel(arg0_166.qteTween, false)
	end

	arg0_166:clearTimer()
end

function var0_0.willExit(arg0_167)
	arg0_167:clearSpineChars()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_167.selectUI, arg0_167._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_167.endUI, arg0_167._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_167.countTimeUI, arg0_167._tf)
end

function var0_0.onBackPressed(arg0_168)
	if arg0_168.isInGame then
		triggerButton(arg0_168.backBtn)
	elseif isActive(arg0_168.selectUI) then
		triggerButton(arg0_168.selectBackBtn)
	elseif isActive(arg0_168.mainUI) then
		triggerButton(arg0_168.returnBtn)
	end
end

return var0_0

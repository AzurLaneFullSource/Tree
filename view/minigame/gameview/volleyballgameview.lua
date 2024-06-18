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
	arg0_2.countTimeUI = arg0_2:findTF("count_time_ui")
	arg0_2.countTimeImage = arg0_2:findTF("time", arg0_2.countTimeUI)
	arg0_2.countTimeNumImage = arg0_2:findTF("nums", arg0_2.countTimeUI)
	arg0_2.mainUI = arg0_2:findTF("main_ui")
	arg0_2.returnBtn = arg0_2:findTF("return_btn", arg0_2.mainUI)
	arg0_2.mainStartBtn = arg0_2:findTF("start_btn", arg0_2.mainUI)
	arg0_2.ruleBtn = arg0_2:findTF("rule_btn", arg0_2.mainUI)
	arg0_2.progressScroll = arg0_2:findTF("right_panel/scroll_view/", arg0_2.mainUI)
	arg0_2.progressContent = arg0_2:findTF("right_panel/scroll_view/viewport/content", arg0_2.mainUI)
	arg0_2.colors = arg0_2:findTF("right_panel/colors", arg0_2.mainUI)
	arg0_2.icons = arg0_2:findTF("right_panel/icons", arg0_2.mainUI)
	arg0_2.gotIcon = arg0_2:findTF("bg/got", arg0_2.mainUI)
	arg0_2.selectUI = arg0_2:findTF("select_ui")
	arg0_2.selectBackBtn = arg0_2:findTF("back_btn", arg0_2.selectUI)
	arg0_2.selectStartBtn = arg0_2:findTF("start_btn", arg0_2.selectUI)
	arg0_2.tags = arg0_2:findTF("select_panel/tags", arg0_2.selectUI)
	arg0_2.paints = arg0_2:findTF("select_panel/paints", arg0_2.selectUI)
	arg0_2.freeTitle = arg0_2:findTF("select_panel/title/free", arg0_2.selectUI)
	arg0_2.dayTitle = arg0_2:findTF("select_panel/title/challenge", arg0_2.selectUI)
	arg0_2.titleDayNum = arg0_2:findTF("select_panel/title/challenge/num", arg0_2.selectUI)
	arg0_2.ruleTxt = arg0_2:findTF("select_panel/rule/rule_txt", arg0_2.selectUI)
	arg0_2.select4Chars = arg0_2:findTF("select_panel/chars", arg0_2.selectUI)
	arg0_2.selectWindow = arg0_2:findTF("select_windows", arg0_2.selectUI)
	arg0_2.selectSureBtn = arg0_2:findTF("windows/sure_btn", arg0_2.selectWindow)
	arg0_2.select9Chars = arg0_2:findTF("windows/char_layout", arg0_2.selectWindow)
	arg0_2.selectNum = arg0_2:findTF("windows/tips/num", arg0_2.selectWindow)
	arg0_2.gameUI = arg0_2:findTF("game_ui")
	arg0_2.bgEffect = arg0_2:findTF("bg/shatanpaiqiu_hailang", arg0_2.gameUI)
	arg0_2.hitEffect = arg0_2:findTF("shatanpaiqiu_jida", arg0_2.gameUI)
	arg0_2.upEffect = arg0_2:findTF("shatanpaiqiu_jieqiu", arg0_2.gameUI)
	arg0_2.ball = arg0_2:findTF("ball", arg0_2.gameUI)
	arg0_2.ballShadow = arg0_2:findTF("ball_shadow", arg0_2.gameUI)
	arg0_2.pauseBtn = arg0_2:findTF("pause_btn", arg0_2.gameUI)
	arg0_2.backBtn = arg0_2:findTF("back_btn", arg0_2.gameUI)
	arg0_2.qteBtn = arg0_2:findTF("qte_btn", arg0_2.gameUI)
	arg0_2.pos = arg0_2:findTF("pos", arg0_2.gameUI)

	arg0_2:initPos()

	arg0_2.ourScore = arg0_2:findTF("score/our", arg0_2.gameUI)
	arg0_2.enemyScore = arg0_2:findTF("score/enemy", arg0_2.gameUI)
	arg0_2.qte = arg0_2:findTF("qte", arg0_2.gameUI)
	arg0_2.qteCircles = arg0_2:findTF("circles", arg0_2.qte)
	arg0_2.qteCircle = arg0_2:findTF("circles/big", arg0_2.qte)
	arg0_2.result = arg0_2:findTF("result", arg0_2.qte)
	arg0_2.resultTxt = arg0_2:findTF("txts", arg0_2.qte)
	arg0_2.cutin = arg0_2:findTF("cutin", arg0_2.gameUI)
	arg0_2.cutinPaint = arg0_2:findTF("cutin/paint", arg0_2.gameUI)
	arg0_2.cutinPaints = arg0_2:findTF("cutin_paints", arg0_2.gameUI)
	arg0_2.scoreCutin = arg0_2:findTF("score_cutin", arg0_2.gameUI)
	arg0_2.scoreCutinNums = arg0_2:findTF("score_cutin/nums", arg0_2.gameUI)
	arg0_2.ourScoreCutin = arg0_2:findTF("score_cutin/our", arg0_2.gameUI)
	arg0_2.enemyScoreCutin = arg0_2:findTF("score_cutin/enemy", arg0_2.gameUI)
	arg0_2.charTF = {}
	arg0_2.charTF.our1 = arg0_2:findTF("char/our1", arg0_2.gameUI)
	arg0_2.charTF.our2 = arg0_2:findTF("char/our2", arg0_2.gameUI)
	arg0_2.charTF.enemy1 = arg0_2:findTF("char/enemy1", arg0_2.gameUI)
	arg0_2.charTF.enemy2 = arg0_2:findTF("char/enemy2", arg0_2.gameUI)
	arg0_2.charModels = {}
	arg0_2.charactor = {}
	arg0_2.cutinMask = arg0_2:findTF("cutin_mask", arg0_2.gameUI)
	arg0_2.endUI = arg0_2:findTF("end_ui")
	arg0_2.endDayTitle = arg0_2:findTF("title/race", arg0_2.endUI)
	arg0_2.endFreeTitle = arg0_2:findTF("title/free", arg0_2.endUI)
	arg0_2.endTitleDay = arg0_2:findTF("title/race/num", arg0_2.endUI)
	arg0_2.titleDays = arg0_2:findTF("title_days", arg0_2.endUI)
	arg0_2.endOurScore = arg0_2:findTF("score_panel/score/our", arg0_2.endUI)
	arg0_2.endEnemyScore = arg0_2:findTF("score_panel/score/enemy", arg0_2.endUI)
	arg0_2.endScoreNums = arg0_2:findTF("nums", arg0_2.endUI)
	arg0_2.sureBtn = arg0_2:findTF("sure_btn", arg0_2.endUI)
	arg0_2.winTag = arg0_2:findTF("score_panel/score/win", arg0_2.endUI)
	arg0_2.loseTag = arg0_2:findTF("score_panel/score/lose", arg0_2.endUI)
	arg0_2.helpUI = arg0_2:findTF("help_ui")
end

function var0_0.initPos(arg0_3)
	arg0_3.orgPos = {}
	arg0_3.orgPos.our_serve = arg0_3:findTF("our_pos/serve_pos", arg0_3.pos).anchoredPosition
	arg0_3.orgPos.our1 = arg0_3:findTF("our_pos/drop_pos1", arg0_3.pos).anchoredPosition
	arg0_3.orgPos.our2 = arg0_3:findTF("our_pos/drop_pos2", arg0_3.pos).anchoredPosition
	arg0_3.orgPos.enemy_serve = arg0_3:findTF("enemy_pos/serve_pos", arg0_3.pos).anchoredPosition
	arg0_3.orgPos.enemy1 = arg0_3:findTF("enemy_pos/drop_pos1", arg0_3.pos).anchoredPosition
	arg0_3.orgPos.enemy2 = arg0_3:findTF("enemy_pos/drop_pos2", arg0_3.pos).anchoredPosition

	arg0_3:resetPos()
end

function var0_0.resetPos(arg0_4)
	arg0_4.anchoredPos = Clone(arg0_4.orgPos)
	arg0_4.anchoredPos.our1 = arg0_4:getRandomPos("our1")
	arg0_4.anchoredPos.our2 = arg0_4:getRandomPos("our2")
	arg0_4.anchoredPos.enemy1 = arg0_4:getRandomPos("enemy1")
	arg0_4.anchoredPos.enemy2 = arg0_4:getRandomPos("enemy2")
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.returnBtn, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.ruleBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("venusvolleyball_help")
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.mainStartBtn, function()
		setActive(arg0_5.selectUI, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_5.selectUI)
		arg0_5:initSelectUI()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.selectBackBtn, function()
		setActive(arg0_5.selectUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_5.selectUI, arg0_5._tf)
	end, SFX_PANEL)

	arg0_5.canStartGame = false

	onButton(arg0_5, arg0_5.selectStartBtn, function()
		if not arg0_5.canStartGame then
			return
		end

		setActive(arg0_5.mainUI, false)
		setActive(arg0_5.selectUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_5.selectUI, arg0_5._tf)
		setActive(arg0_5.gameUI, true)
		arg0_5:resetGameData()

		if arg0_5.isFirstgame == 0 then
			arg0_5:firstShow(function()
				arg0_5:startCountTimer()
			end)
		else
			arg0_5:startCountTimer()
		end
	end, SFX_PANEL)

	arg0_5.canSureChar = false

	onButton(arg0_5, arg0_5.selectSureBtn, function()
		if not arg0_5.canSureChar then
			return
		end

		if arg0_5.selectCharCamp == "enemy" then
			arg0_5.charNames.enemy1 = var1_0[arg0_5.selectSDIndex1]
			arg0_5.charNames.enemy2 = var1_0[arg0_5.selectSDIndex2]
		elseif arg0_5.selectCharCamp == "our" then
			arg0_5.charNames.our1 = var1_0[arg0_5.selectSDIndex1]
			arg0_5.charNames.our2 = var1_0[arg0_5.selectSDIndex2]
		end

		setActive(arg0_5.selectWindow, false)
		arg0_5:refreshSelectUI()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("mask", arg0_5.selectWindow), function()
		setActive(arg0_5.selectWindow, false)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.pauseBtn, function()
		if not arg0_5.btnAvailable then
			return
		end

		arg0_5:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("venusvolleyball_suspend_tip"),
			onNo = function()
				arg0_5:resumeGame()
			end,
			onYes = function()
				arg0_5:resumeGame()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		if not arg0_5.btnAvailable then
			return
		end

		arg0_5:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("venusvolleyball_return_tip"),
			onNo = function()
				arg0_5:resumeGame()
			end,
			onYes = function()
				arg0_5:endGame()
			end
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.qteBtn, function()
		if arg0_5.qteBtnStatus == var5_0 then
			return
		end

		arg0_5:qteResult()
	end)
	onButton(arg0_5, arg0_5.sureBtn, function()
		setActive(arg0_5.mainUI, true)
		arg0_5:initMainUI()
		setActive(arg0_5.gameUI, false)
		setActive(arg0_5.endUI, false)
		arg0_5:clearSpineChars()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_5.endUI, arg0_5._tf)
	end, SFX_PANEL)
	arg0_5:initMainUI()
end

function var0_0.playEffect(arg0_22, arg1_22, arg2_22)
	if arg2_22 then
		arg1_22.anchoredPosition = arg2_22
	else
		arg1_22.anchoredPosition = arg0_22.ball.anchoredPosition
	end

	setActive(arg1_22, false)
	setActive(arg1_22, true)
end

function var0_0.getGameData(arg0_23)
	arg0_23.mgProxy = getProxy(MiniGameProxy)
	arg0_23.hubData = arg0_23.mgProxy:GetHubByHubId(13)
	arg0_23.curDay = arg0_23.hubData.ultimate == 0 and arg0_23.hubData.usedtime + 1 or 8
	arg0_23.unlockDay = arg0_23.hubData.usedtime + arg0_23.hubData.count
	arg0_23.curDay = arg0_23.curDay <= arg0_23.unlockDay and arg0_23.curDay or arg0_23.unlockDay
	arg0_23.mgData = arg0_23.mgProxy:GetMiniGameData(17)
	arg0_23.endScore = arg0_23.mgData:GetSimpleValue("endScore")[arg0_23.curDay]
	arg0_23.storylist = arg0_23.mgData:GetSimpleValue("story")

	local var0_23 = getProxy(PlayerProxy):getData().id

	arg0_23.isFirstgame = PlayerPrefs.GetInt("volleyballgame_first_" .. var0_23)
end

function var0_0.getEnemyCharsIndex(arg0_24)
	return arg0_24.mgData:GetSimpleValue("mainChar")[arg0_24.curDay], arg0_24.mgData:GetSimpleValue("minorChar")[arg0_24.curDay]
end

function var0_0.initMainUI(arg0_25)
	arg0_25.isInGame = false

	arg0_25:getGameData()

	if arg0_25.hubData.ultimate == 0 and arg0_25.hubData.usedtime >= arg0_25.hubData:getConfig("reward_need") then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_25.hubData.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end

	arg0_25.isFree = arg0_25.hubData.ultimate ~= 0 and true or false

	setActive(arg0_25:findTF("free_tag", arg0_25.mainStartBtn), arg0_25.isFree)
	setActive(arg0_25.gotIcon, arg0_25.isFree)
	eachChild(arg0_25.progressContent, function(arg0_26)
		local var0_26 = ""
		local var1_26 = tonumber(arg0_26.name)
		local var2_26 = var1_0[arg0_25.mgData:GetSimpleValue("mainChar")[var1_26]]

		setActive(arg0_25:findTF("char_bg/mask", arg0_26), false)
		setActive(arg0_25:findTF("name_bg/mask", arg0_26), false)
		setActive(arg0_25:findTF("pass", arg0_26), false)

		if var1_26 == arg0_25.curDay and arg0_25.hubData.count > 0 then
			var0_26 = "red"

			setImageSprite(arg0_25:findTF("char_bg/icon", arg0_26), arg0_25.icons:Find(arg0_25:getCharIndex(var2_26)):GetComponent(typeof(Image)).sprite, true)
		elseif var1_26 < arg0_25.curDay or var1_26 == arg0_25.curDay and arg0_25.hubData.count == 0 then
			var0_26 = "grey"

			setImageSprite(arg0_25:findTF("char_bg/icon", arg0_26), arg0_25.icons:Find(arg0_25:getCharIndex(var2_26)):GetComponent(typeof(Image)).sprite, true)
			setActive(arg0_25:findTF("char_bg/mask", arg0_26), true)
			setActive(arg0_25:findTF("name_bg/mask", arg0_26), true)
			setActive(arg0_25:findTF("pass", arg0_26), true)
		elseif var1_26 > arg0_25.curDay and var1_26 <= arg0_25.unlockDay then
			var0_26 = "blue"

			setImageSprite(arg0_25:findTF("char_bg/icon", arg0_26), arg0_25.icons:Find(arg0_25:getCharIndex(var2_26)):GetComponent(typeof(Image)).sprite, true)
		else
			var0_26 = "grey"

			setImageSprite(arg0_25:findTF("char_bg/icon", arg0_26), arg0_25.colors:Find("unkonwn"):GetComponent(typeof(Image)).sprite)
		end

		setImageSprite(arg0_25:findTF("name_bg", arg0_26), arg0_25.colors:Find(var0_26):GetComponent(typeof(Image)).sprite)
	end)

	local var0_25 = 215
	local var1_25 = math.min(645, (arg0_25.curDay - 1) * var0_25)

	arg0_25.progressContent.anchoredPosition = {
		x = 0,
		y = var1_25
	}

	onScroll(arg0_25, arg0_25.progressScroll, function(arg0_27)
		setActive(arg0_25:findTF("right_panel/arraws_up", arg0_25.mainUI), arg0_27.y < 1 and true or false)
		setActive(arg0_25:findTF("right_panel/arraws_down", arg0_25.mainUI), arg0_27.y > 0 and true or false)
	end)
end

function var0_0.initSelectUI(arg0_28)
	setActive(arg0_28.freeTitle, arg0_28.isFree)
	setActive(arg0_28.dayTitle, not arg0_28.isFree)
	setText(arg0_28.titleDayNum, arg0_28.curDay)
	setText(arg0_28.ruleTxt, i18n("venusvolleyball_rule_tip", arg0_28.endScore))

	arg0_28.charNames = {}
	arg0_28.lastSelectNames = {}

	eachChild(arg0_28.select4Chars, function(arg0_29)
		local var0_29 = arg0_29.name

		onButton(arg0_28, arg0_29, function()
			if not arg0_28.isFree and string.find(var0_29, "enemy") then
				return
			end

			arg0_28.selectCharCamp = string.find(var0_29, "enemy") and "enemy" or "our"

			arg0_28:openSelectWindow()
		end)
	end)

	if not arg0_28.isFree then
		local var0_28, var1_28 = arg0_28:getEnemyCharsIndex()

		arg0_28.charNames.enemy1, arg0_28.charNames.enemy2 = var1_0[var0_28], var1_0[var1_28]
	end

	arg0_28:refreshSelectUI()
end

function var0_0.getCharIndex(arg0_31, arg1_31)
	for iter0_31, iter1_31 in ipairs(var1_0) do
		if iter1_31 == arg1_31 then
			return iter0_31
		end
	end

	return 1
end

function var0_0.refreshSelectUI(arg0_32)
	eachChild(arg0_32.select4Chars, function(arg0_33)
		local var0_33 = arg0_33.name

		if arg0_32.charNames[var0_33] then
			setActive(arg0_32:findTF("select_btn", arg0_33), false)
			setActive(arg0_32:findTF("char", arg0_33), true)
			setImageSprite(arg0_32:findTF("char/icon", arg0_33), arg0_32.paints:Find(arg0_32:getCharIndex(arg0_32.charNames[var0_33])):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(arg0_32:findTF("char/tag", arg0_33), arg0_32.tags:Find(arg0_32:getCharIndex(arg0_32.charNames[var0_33])):GetComponent(typeof(Image)).sprite, true)
		else
			setActive(arg0_32:findTF("select_btn", arg0_33), true)
			setActive(arg0_32:findTF("char", arg0_33), false)
		end
	end)

	arg0_32.canStartGame = arg0_32.charNames.our1 and arg0_32.charNames.our2 and arg0_32.charNames.enemy1 and arg0_32.charNames.enemy2 and true or false

	setGray(arg0_32.selectStartBtn, not arg0_32.canStartGame, not arg0_32.canStartGame)
end

function var0_0.isSelected(arg0_34, arg1_34, arg2_34)
	local var0_34 = false

	for iter0_34, iter1_34 in pairs(arg0_34.charNames) do
		if arg1_34 == iter1_34 then
			var0_34 = not string.find(iter0_34, arg2_34) and true or false
		end
	end

	return var0_34
end

function var0_0.openSelectWindow(arg0_35)
	setActive(arg0_35.selectWindow, true)

	arg0_35.hasSelectNum = 0

	setText(arg0_35.selectNum, setColorStr(arg0_35.hasSelectNum, COLOR_GREEN) .. "/2")

	arg0_35.selectSDIndex1 = nil
	arg0_35.selectSDIndex2 = nil

	eachChild(arg0_35.select9Chars, function(arg0_36)
		local var0_36 = tonumber(arg0_36.name)

		setImageSprite(arg0_35:findTF("char/frame/icon", arg0_36), arg0_35.icons:Find(var0_36):GetComponent(typeof(Image)).sprite, true)
		onButton(arg0_35, arg0_36, function()
			if arg0_35:isSelected(var1_0[var0_36], arg0_35.selectCharCamp) then
				return
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var29_0)

			if isActive(arg0_35:findTF("selected", arg0_36)) then
				setActive(arg0_35:findTF("selected", arg0_36), false)

				if arg0_35.selectSDIndex1 and arg0_35.selectSDIndex1 == var0_36 then
					arg0_35.selectSDIndex1 = nil
				end

				if arg0_35.selectSDIndex2 and arg0_35.selectSDIndex2 == var0_36 then
					arg0_35.selectSDIndex2 = nil
				end

				arg0_35.hasSelectNum = arg0_35.hasSelectNum - 1
			elseif arg0_35.selectSDIndex1 and arg0_35.selectSDIndex2 then
				-- block empty
			elseif arg0_35.selectSDIndex1 then
				arg0_35.selectSDIndex2 = var0_36
				arg0_35.hasSelectNum = arg0_35.hasSelectNum + 1
			else
				arg0_35.selectSDIndex1 = var0_36
				arg0_35.hasSelectNum = arg0_35.hasSelectNum + 1
			end

			arg0_35:refreshSelectWindow()
		end)
	end)
	arg0_35:refreshSelectWindow()
end

function var0_0.refreshSelectWindow(arg0_38)
	eachChild(arg0_38.select9Chars, function(arg0_39)
		local var0_39 = tonumber(arg0_39.name)

		setActive(arg0_38:findTF("char/mask", arg0_39), arg0_38:isSelected(var1_0[var0_39], arg0_38.selectCharCamp) and true or false)

		if var0_39 == arg0_38.selectSDIndex1 or var0_39 == arg0_38.selectSDIndex2 then
			setActive(arg0_38:findTF("selected", arg0_39), true)
		else
			setActive(arg0_38:findTF("selected", arg0_39), false)
		end
	end)
	setText(arg0_38.selectNum, setColorStr(arg0_38.hasSelectNum, COLOR_GREEN) .. "/2")

	arg0_38.canSureChar = arg0_38.selectSDIndex1 and arg0_38.selectSDIndex2 and true or false

	setGray(arg0_38.selectSureBtn, not arg0_38.canSureChar, not arg0_38.canSureChar)
end

function var0_0.firstShow(arg0_40, arg1_40)
	setActive(arg0_40.helpUI, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_40.helpUI)
	onButton(arg0_40, arg0_40.helpUI, function()
		local var0_41 = getProxy(PlayerProxy):getData().id

		PlayerPrefs.SetInt("volleyballgame_first_" .. var0_41, 1)
		setActive(arg0_40.helpUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_40.helpUI, arg0_40._tf)

		if arg1_40 then
			arg1_40()
		end
	end, SFX_PANEL)
end

function var0_0.startCountTimer(arg0_42)
	arg0_42:setBtnAvailable(false)
	setActive(arg0_42.countTimeUI, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_42.countTimeUI)

	arg0_42.countTime = 3

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var28_0)
	setImageSprite(arg0_42.countTimeImage, arg0_42.countTimeNumImage:Find(arg0_42.countTime):GetComponent(typeof(Image)).sprite)

	local function var0_42()
		arg0_42.countTime = arg0_42.countTime - 1

		if arg0_42.countTime <= 0 then
			setActive(arg0_42.countTimeUI, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_42.countTimeUI, arg0_42._tf)
			arg0_42:resetGameAni()
			arg0_42:startGame()
		else
			setImageSprite(arg0_42.countTimeImage, arg0_42.countTimeNumImage:Find(arg0_42.countTime):GetComponent(typeof(Image)).sprite)
		end
	end

	if arg0_42.countTimer then
		arg0_42.countTimer:Reset(var0_42, 1, -1)
	else
		arg0_42.countTimer = Timer.New(var0_42, 1, -1)
	end

	arg0_42.countTimer:Start()
end

function var0_0.setBtnAvailable(arg0_44, arg1_44)
	arg0_44.btnAvailable = arg1_44

	setGray(arg0_44.backBtn, not arg1_44, not arg1_44)
	setGray(arg0_44.pauseBtn, not arg1_44, not arg1_44)
end

function var0_0.startGame(arg0_45)
	arg0_45.isInGame = true

	arg0_45:setBtnAvailable(true)
	setActive(arg0_45.bgEffect, false)
	setActive(arg0_45.bgEffect, true)

	if arg0_45.beginTeam == var3_0 then
		arg0_45:ourServe(function()
			arg0_45:enemyUp2Up(function()
				arg0_45:enemyUp2Hit(function()
					arg0_45:enemyThrow(function()
						arg0_45:enterLoop()
					end)
				end)
			end)
		end)
	else
		arg0_45:enemyServe(function()
			arg0_45:enterLoop()
		end)
	end
end

function var0_0.enterLoop(arg0_51)
	arg0_51:ourUp2Up(function()
		arg0_51:ourUp2Hit(function()
			arg0_51:ourThrow(function()
				arg0_51:enemyUp2Up(function()
					arg0_51:enemyUp2Hit(function()
						arg0_51:enemyThrow(function()
							arg0_51:enterLoop()
						end)
					end)
				end)
			end)
		end)
	end)
end

function var0_0.ourServe(arg0_58, arg1_58)
	arg0_58.ballPosTag = "our_serve"

	setActive(arg0_58.ball, true)
	arg0_58:charServeBall()
	arg0_58:managedTween(LeanTween.delayedCall, function()
		local var0_59 = "enemy" .. math.random(2)

		arg0_58.ballPosTag = var0_59
		arg0_58.anchoredPos[arg0_58.ballPosTag] = arg0_58:getRandomPos(arg0_58.ballPosTag)

		arg0_58:ballServe(arg0_58.ball, var15_0, arg0_58.anchoredPos[var0_59], function()
			if arg1_58 then
				arg1_58()
			end
		end)
		arg0_58:managedTween(LeanTween.delayedCall, function()
			arg0_58:charUpBall()
		end, var15_0 - var21_0, nil)
	end, var20_0 + 0.5, nil)
end

function var0_0.enemyServe(arg0_62, arg1_62)
	arg0_62.ballPosTag = "enemy_serve"

	setActive(arg0_62.ball, true)
	arg0_62:charServeBall()
	arg0_62:managedTween(LeanTween.delayedCall, function()
		local var0_63 = "our" .. math.random(2)

		arg0_62.ballPosTag = var0_63
		arg0_62.anchoredPos[arg0_62.ballPosTag] = arg0_62:getRandomPos(arg0_62.ballPosTag)

		arg0_62:ballServe(arg0_62.ball, var15_0, arg0_62.anchoredPos[var0_63], function()
			if arg1_62 then
				arg1_62()
			end
		end)
		arg0_62:managedTween(LeanTween.delayedCall, function()
			arg0_62:charUpBall()
		end, var15_0 - var21_0, nil)
	end, var20_0 + 0.5, nil)
end

function var0_0.ourUp2Up(arg0_66, arg1_66)
	if arg0_66.qteStatus == var11_0 and arg0_66.qteType == var13_0 then
		arg0_66:ourFly()

		return
	end

	arg0_66.ballPosTag = arg0_66.ballPosTag == "our1" and "our2" or "our1"

	arg0_66:ballUp2Up(arg0_66.ball, var16_0, arg0_66.anchoredPos[arg0_66.ballPosTag], function()
		if arg1_66 then
			arg1_66()
		end
	end)
	arg0_66:managedTween(LeanTween.delayedCall, function()
		arg0_66:charUpBall()
	end, 0.3, nil)
end

function var0_0.ourUp2Hit(arg0_69, arg1_69)
	local var0_69 = {}

	arg0_69.ballPosTag = arg0_69.ballPosTag == "our1" and "our2" or "our1"
	arg0_69.anchoredPos[arg0_69.ballPosTag] = arg0_69:getRandomPos(arg0_69.ballPosTag)
	arg0_69.qteType = var14_0

	arg0_69:charHitBall()

	local var1_69 = false

	local function var2_69(arg0_70)
		if var1_69 then
			arg0_70()
		else
			var1_69 = true
		end
	end

	table.insert(var0_69, function(arg0_71)
		local function var0_71()
			if arg0_69.isCutin then
				arg0_69:showcutin(function()
					arg0_69.isCutin = false

					arg0_71()
				end)
			else
				arg0_71()
			end
		end

		arg0_69:managedTween(LeanTween.delayedCall, function()
			var2_69(var0_71)
		end, var16_0 - 0.2, nil)
		arg0_69:managedTween(LeanTween.delayedCall, function()
			arg0_69:startQTE(var32_0, 200, arg0_69.anchoredPos[arg0_69.ballPosTag], function()
				var2_69(var0_71)
			end)
		end, var16_0 - var32_0 - 0.2, nil)
	end)
	table.insert(var0_69, function(arg0_77)
		arg0_69:ballUp2Hit(arg0_69.ball, var16_0, arg0_69.anchoredPos[arg0_69.ballPosTag], arg0_77)
	end)
	parallelAsync(var0_69, function()
		if arg1_69 then
			arg1_69()
		end
	end)
end

function var0_0.ourThrow(arg0_79, arg1_79)
	local var0_79 = "enemy" .. math.random(2)

	arg0_79.ballPosTag = var0_79
	arg0_79.anchoredPos[arg0_79.ballPosTag] = arg0_79:getRandomPos(arg0_79.ballPosTag)

	arg0_79:ballHit(arg0_79.ball, var17_0, arg0_79.anchoredPos[var0_79], function()
		if arg1_79 then
			arg1_79()
		end
	end)
	arg0_79:charUpBall()
end

function var0_0.enemyUp2Up(arg0_81, arg1_81)
	if arg0_81.qteStatus == var10_0 and arg0_81.qteType == var14_0 then
		arg0_81:enemyFly()

		return
	end

	arg0_81.ballPosTag = arg0_81.ballPosTag == "enemy1" and "enemy2" or "enemy1"

	arg0_81:ballUp2Up(arg0_81.ball, var16_0, arg0_81.anchoredPos[arg0_81.ballPosTag], function()
		if arg1_81 then
			arg1_81()
		end
	end)
	arg0_81:managedTween(LeanTween.delayedCall, function()
		arg0_81:charUpBall()
	end, 0.3, nil)
end

function var0_0.enemyUp2Hit(arg0_84, arg1_84)
	arg0_84.ballPosTag = arg0_84.ballPosTag == "enemy1" and "enemy2" or "enemy1"
	arg0_84.anchoredPos[arg0_84.ballPosTag] = arg0_84:getRandomPos(arg0_84.ballPosTag)
	arg0_84.randomQtePos = "our" .. math.random(2)
	arg0_84.anchoredPos[arg0_84.randomQtePos] = arg0_84:getRandomPos(arg0_84.randomQtePos)
	arg0_84.qteType = var13_0

	arg0_84:managedTween(LeanTween.delayedCall, function()
		arg0_84:startQTE(var32_0, 0, arg0_84.anchoredPos[arg0_84.randomQtePos])
	end, var16_0 - var32_0, nil)
	arg0_84:ballUp2Hit(arg0_84.ball, var16_0, arg0_84.anchoredPos[arg0_84.ballPosTag], function()
		if arg1_84 then
			arg1_84()
		end
	end)
	arg0_84:charHitBall()
end

function var0_0.enemyThrow(arg0_87, arg1_87)
	arg0_87.ballPosTag = arg0_87.randomQtePos

	arg0_87:ballHit(arg0_87.ball, var17_0, arg0_87.anchoredPos[arg0_87.ballPosTag], function()
		if arg1_87 then
			arg1_87()
		end
	end)
	arg0_87:charUpBall()
end

function var0_0.ourFly(arg0_89)
	arg0_89.ballPosTag = "out"

	local var0_89 = math.random(1000, 1100)
	local var1_89 = math.random(0, 200)

	arg0_89:hitFly(arg0_89.ball, var18_0, {
		x = -var0_89,
		y = var1_89 - 100
	}, function()
		arg0_89.qteStatus = var9_0

		setGray(arg0_89.qteBtn, true, true)

		arg0_89.enemyScoreNum = arg0_89.enemyScoreNum + 1

		arg0_89:updateScore()
	end)
end

function var0_0.enemyFly(arg0_91)
	arg0_91.ballPosTag = "out"

	local var0_91 = math.random(1000, 1100)
	local var1_91 = math.random(0, 200)

	arg0_91:hitFly(arg0_91.ball, var18_0, {
		x = var0_91,
		y = var1_91 - 100
	}, function()
		arg0_91.qteStatus = var9_0

		setGray(arg0_91.qteBtn, true, true)

		arg0_91.ourScoreNum = arg0_91.ourScoreNum + 1

		arg0_91:updateScore()
	end)
end

function var0_0.qteSuccess(arg0_93)
	arg0_93.qteStatus = var10_0
	arg0_93.beginTeam = var3_0

	arg0_93:changeQTEBtnStatus(var5_0)
end

function var0_0.qteFail(arg0_94)
	arg0_94.qteStatus = var11_0
	arg0_94.beginTeam = var4_0

	arg0_94:changeQTEBtnStatus(var5_0)
end

function var0_0.GetBeziersPoints(arg0_95, arg1_95, arg2_95, arg3_95, arg4_95)
	local function var0_95(arg0_96)
		local var0_96 = arg1_95:Clone():Mul((1 - arg0_96) * (1 - arg0_96))
		local var1_96 = arg2_95:Clone():Mul(2 * arg0_96 * (1 - arg0_96))
		local var2_96 = arg3_95:Clone():Mul(arg0_96 * arg0_96)

		return var0_96:Clone():Add(var1_96):Add(var2_96)
	end

	local var1_95 = {}

	table.insert(var1_95, Vector3(0, 0, 0))
	table.insert(var1_95, var0_95(0))

	for iter0_95 = 1, arg4_95 do
		local var2_95 = iter0_95 / arg4_95

		table.insert(var1_95, var0_95(var2_95))
	end

	table.insert(var1_95, Vector3(0, 0, 0))

	return var1_95
end

function var0_0.ballParabolaMove(arg0_97, arg1_97, arg2_97, arg3_97, arg4_97, arg5_97, arg6_97)
	local var0_97 = Vector2(arg1_97.anchoredPosition.x, arg1_97.anchoredPosition.y - arg5_97)
	local var1_97 = Vector2(arg3_97.x, arg3_97.y)
	local var2_97 = var1_97.x - var0_97.x
	local var3_97 = var1_97.y - var0_97.y
	local var4_97 = math.abs(arg6_97 - arg5_97)
	local var5_97 = DOAParabolaCalc(arg2_97, math.abs(var33_0), var4_97)
	local var6_97
	local var7_97

	if arg5_97 < arg6_97 then
		var6_97 = var5_97 + var4_97

		local var8_97 = var5_97
	else
		var6_97 = var5_97

		local var9_97 = var5_97 + var4_97
	end

	local var10_97 = math.sqrt(2 * math.abs(var33_0) * var6_97)

	arg0_97:managedTween(LeanTween.value, function()
		if arg4_97 then
			arg4_97()
		end
	end, go(arg1_97), 0, arg2_97, arg2_97):setOnUpdate(System.Action_float(function(arg0_99)
		local var0_99 = var2_97 * arg0_99 / arg2_97
		local var1_99 = var3_97 * arg0_99 / arg2_97
		local var2_99 = var10_97 * arg0_99 + 0.5 * var33_0 * arg0_99 * arg0_99

		arg1_97.anchoredPosition = Vector2(var0_97.x + var0_99, var0_97.y + var1_99 + arg5_97 + var2_99)
	end))
end

function var0_0.ballServe(arg0_100, arg1_100, arg2_100, arg3_100, arg4_100)
	arg0_100:ballParabolaMove(arg1_100, arg2_100, arg3_100, function()
		if arg4_100 then
			arg4_100()
		end
	end, var24_0, var25_0)
	arg0_100:managedTween(LeanTween.move, nil, arg0_100.ballShadow, Vector3(arg3_100.x, arg3_100.y + var23_0), arg2_100):setEase(LeanTweenType.linear)
end

function var0_0.ballUp2Up(arg0_102, arg1_102, arg2_102, arg3_102, arg4_102)
	arg0_102:ballParabolaMove(arg1_102, arg2_102, arg3_102, function()
		if arg4_102 then
			arg4_102()
		end
	end, var25_0, var25_0)
	arg0_102:managedTween(LeanTween.move, nil, arg0_102.ballShadow, Vector3(arg3_102.x, arg3_102.y + var23_0), arg2_102):setEase(LeanTweenType.linear)
end

function var0_0.ballUp2Hit(arg0_104, arg1_104, arg2_104, arg3_104, arg4_104)
	local var0_104 = {
		x = arg3_104.x,
		y = arg3_104.y
	}

	arg0_104:ballParabolaMove(arg1_104, arg2_104, var0_104, function()
		if arg4_104 then
			arg4_104()
		end
	end, var25_0, var26_0)
	arg0_104:managedTween(LeanTween.move, nil, arg0_104.ballShadow, Vector3(arg3_104.x, arg3_104.y + var23_0), arg2_104):setEase(LeanTweenType.linear)
end

function var0_0.ballHit(arg0_106, arg1_106, arg2_106, arg3_106, arg4_106)
	arg3_106 = Vector2(arg3_106.x, arg3_106.y + var25_0)

	arg0_106:managedTween(LeanTween.moveX, function()
		if arg4_106 then
			arg4_106()
		end
	end, arg1_106, arg3_106.x, arg2_106):setEase(LeanTweenType.linear)
	arg0_106:managedTween(LeanTween.moveY, nil, arg1_106, arg3_106.y, arg2_106):setEase(LeanTweenType.linear)
	arg0_106:managedTween(LeanTween.move, nil, arg0_106.ballShadow, Vector3(arg3_106.x, arg3_106.y + var23_0), arg2_106):setEase(LeanTweenType.linear)
end

function var0_0.charMove(arg0_108, arg1_108, arg2_108, arg3_108, arg4_108)
	arg0_108:managedTween(LeanTween.moveX, nil, arg1_108, arg3_108.x, arg2_108):setEase(LeanTweenType.easeOutQuad)
	arg0_108:managedTween(LeanTween.moveY, function()
		if arg4_108 then
			arg4_108()
		end
	end, arg1_108, arg3_108.y, arg2_108):setEase(LeanTweenType.linear)
end

function var0_0.hitFly(arg0_110, arg1_110, arg2_110, arg3_110, arg4_110)
	arg0_110:ballParabolaMove(arg1_110, arg2_110, arg3_110, function()
		if arg4_110 then
			arg4_110()
		end
	end, var27_0, var26_0)
	arg0_110:managedTween(LeanTween.move, nil, arg0_110.ballShadow, Vector3(arg3_110.x, arg3_110.y + var23_0), arg2_110):setEase(LeanTweenType.linear)
end

function var0_0.startQTE(arg0_112, arg1_112, arg2_112, arg3_112, arg4_112)
	arg0_112:changeQTEBtnStatus(var6_0)

	arg0_112.qte.anchoredPosition = {
		x = arg3_112.x,
		y = arg3_112.y + arg2_112
	}

	setActive(arg0_112.qte, true)
	setActive(arg0_112.qteCircles, true)
	setActive(arg0_112.result, false)
	setLocalScale(arg0_112.qteCircle, Vector3(1, 1, 1))
	arg0_112.result:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_113)
		setActive(arg0_112.result, false)
	end)

	arg0_112.qteCallback = arg4_112
	arg0_112.qteTween = LeanTween.scale(arg0_112.qteCircle, Vector3(0, 0, 1), arg1_112):setOnComplete(System.Action(function()
		arg0_112:changeQTEBtnStatus(var5_0)
		setImageSprite(arg0_112.result, arg0_112.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		setActive(arg0_112.result, true)
		arg0_112:qteFail()

		arg0_112.isCutin = false

		setActive(arg0_112.qteCircles, false)
		existCall(arg0_112.qteCallback)

		arg0_112.qteCallback = nil
	end)).uniqueId
end

function var0_0.qteResult(arg0_115)
	if LeanTween.isTweening(arg0_115.qteTween) then
		LeanTween.cancel(arg0_115.qteTween, false)
	end

	local var0_115 = math.abs(arg0_115.qteCircle.localScale.x)

	setActive(arg0_115.result, true)

	arg0_115.isCutin = false

	if var0_115 <= 0 or var0_115 > var7_0 then
		setImageSprite(arg0_115.result, arg0_115.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		arg0_115:qteFail()
	elseif var0_115 > var8_0 then
		setImageSprite(arg0_115.result, arg0_115.resultTxt:Find("good"):GetComponent(typeof(Image)).sprite, true)
		arg0_115:qteSuccess()
	else
		setImageSprite(arg0_115.result, arg0_115.resultTxt:Find("perfect"):GetComponent(typeof(Image)).sprite, true)
		arg0_115:qteSuccess()

		if arg0_115.qteType == var14_0 then
			arg0_115.isCutin = true
		else
			arg0_115.isCutin = false
		end
	end

	setActive(arg0_115.qteCircles, false)
	existCall(arg0_115.qteCallback)

	arg0_115.qteCallback = nil
end

local function var34_0(arg0_116, arg1_116, arg2_116, arg3_116, arg4_116)
	local var0_116 = {
		_tf = arg1_116,
		spineAnim = arg2_116,
		skele = arg3_116,
		posTag = arg4_116
	}

	function var0_116.ctor(arg0_117)
		var0_116._tf.anchoredPosition = arg0_116.anchoredPos[arg4_116]
	end

	function var0_116.setPosTag(arg0_118, arg1_118)
		var0_116._tf.anchoredPosition = arg0_116.anchoredPos[arg1_118]
		var0_116.posTag = arg1_118
	end

	function var0_116.getPosTag(arg0_119)
		return var0_116.posTag
	end

	function var0_116.pauseSpine(arg0_120)
		var0_116.skele.timeScale = 0
	end

	function var0_116.resumeSpine(arg0_121)
		var0_116.skele.timeScale = 1
	end

	function var0_116.setActionOnce(arg0_122, arg1_122, arg2_122)
		var0_116.spineAnim:SetActionCallBack(function(arg0_123)
			if arg0_123 == "action" then
				if arg1_122 == "chuanqiu" or arg1_122 == "dianqiu" then
					arg0_116:playEffect(arg0_116.upEffect, Vector2(var0_116._tf.anchoredPosition.x, var0_116._tf.anchoredPosition.y + var25_0))
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var30_0)
				elseif arg1_122 == "kouqiu" then
					arg0_116:playEffect(arg0_116.hitEffect, Vector2(var0_116._tf.anchoredPosition.x, var0_116._tf.anchoredPosition.y + var25_0 + var26_0))
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var31_0)
				elseif arg1_122 == "faqiu" then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var30_0)
					arg0_116:playEffect(arg0_116.upEffect, Vector2(var0_116._tf.anchoredPosition.x, var0_116._tf.anchoredPosition.y + var24_0))
				end
			end

			if arg0_123 == "finish" then
				var0_116.spineAnim:SetActionCallBack(nil)

				if arg2_122 then
					arg2_122()
				else
					var0_116.spineAnim:SetAction("normal2", 0)
				end
			end
		end)
		var0_116.spineAnim:SetAction(arg1_122, 0)
	end

	function var0_116.move(arg0_124, arg1_124, arg2_124, arg3_124, arg4_124)
		local function var0_124()
			var0_116.spineAnim:SetAction("run", 0)

			var0_116.posTag = arg2_124

			arg0_116:charMove(var0_116._tf, arg1_124, arg0_116.anchoredPos[arg2_124], function()
				if arg4_124 then
					arg4_124()
				else
					var0_116.spineAnim:SetAction("normal2", 0)
				end
			end)
		end

		if arg3_124 then
			var0_116:setActionOnce(arg3_124, function()
				var0_124()
			end)
		else
			var0_124()
		end
	end

	var0_116:ctor()

	return var0_116
end

function var0_0.getRandomPos(arg0_128, arg1_128)
	local var0_128 = math.random(0, 300)
	local var1_128 = math.random(0, 50)
	local var2_128 = arg0_128.orgPos[arg1_128]
	local var3_128 = var2_128

	if string.find(arg1_128, "our") then
		var3_128 = {
			x = var2_128.x + var0_128 - 50,
			y = var2_128.y + var1_128 - 25
		}
	else
		var3_128 = {
			x = var2_128.x + var0_128 - 250,
			y = var2_128.y + var1_128 - 25
		}
	end

	return var3_128
end

function var0_0.loadSpineChars(arg0_129)
	arg0_129:clearSpineChars()

	arg0_129.beginTeam = math.random(2)

	if arg0_129.beginTeam == var3_0 then
		arg0_129.serveChar = "our" .. math.random(2)
	else
		arg0_129.serveChar = "enemy" .. math.random(2)
	end

	arg0_129:setBallPos()

	for iter0_129, iter1_129 in pairs(arg0_129.charNames) do
		arg0_129:loadOneSpineChar(iter0_129, arg0_129.serveChar)
	end
end

function var0_0.loadOneSpineChar(arg0_130, arg1_130, arg2_130)
	if not arg0_130.charNames[arg1_130] then
		arg0_130.charNames[arg1_130] = false

		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg0_130.charNames[arg1_130], true, function(arg0_131)
		pg.UIMgr.GetInstance():LoadingOff()

		local var0_131 = ""
		local var1_131

		if string.find(arg1_130, "our") then
			tf(arg0_131).localScale = Vector3(0.6, 0.6, 1)
			tf(arg0_131).localPosition = Vector3(-20, 0, 0)

			if string.find(arg1_130, "1") then
				var1_131 = "our1"
			else
				var1_131 = "our2"
			end
		else
			tf(arg0_131).localScale = Vector3(-0.6, 0.6, 1)
			tf(arg0_131).localPosition = Vector3(20, 0, 0)
			var1_131 = string.find(arg1_130, "1") and "enemy1" or "enemy2"
		end

		arg0_130.charModels[arg1_130] = arg0_131

		local var2_131 = arg0_131:GetComponent("SpineAnimUI")
		local var3_131 = arg0_131:GetComponent("SkeletonGraphic")

		var2_131:SetAction("normal2", 0)

		var3_131.timeScale = 1

		local var4_131 = arg0_130._tf:Find("game_ui/char/" .. arg1_130)

		setParent(arg0_131, var4_131)

		arg0_130.charactor[arg1_130] = var34_0(arg0_130, var4_131, var2_131, var3_131, var1_131)

		if arg1_130 == arg2_130 then
			if arg0_130.beginTeam == var3_0 then
				arg0_130.charactor[arg1_130]:setPosTag("our_serve")
			else
				arg0_130.charactor[arg1_130]:setPosTag("enemy_serve")
			end
		end
	end)
end

function var0_0.clearSpineChars(arg0_132)
	for iter0_132, iter1_132 in pairs(arg0_132.charModels) do
		if arg0_132.charModels[iter0_132] and arg0_132.charNames[iter0_132] then
			PoolMgr.GetInstance():ReturnSpineChar(arg0_132.charNames[iter0_132], arg0_132.charModels[iter0_132])
		end
	end

	arg0_132.charModels = {}
end

function var0_0.getCharWithTag(arg0_133, arg1_133)
	for iter0_133, iter1_133 in pairs(arg0_133.charactor) do
		if iter1_133:getPosTag() == arg1_133 then
			return iter0_133, iter1_133
		end
	end

	return nil
end

function var0_0.getAnotherChar(arg0_134, arg1_134)
	local var0_134 = ""

	if string.find(arg1_134, "our") then
		var0_134 = arg1_134 == "our1" and "our2" or "our1"
	elseif string.find(arg1_134, "enemy") then
		var0_134 = arg1_134 == "enemy1" and "enemy2" or "enemy1"
	end

	return var0_134, arg0_134.charactor[var0_134]
end

function var0_0.setBallPos(arg0_135)
	setActive(arg0_135.ball, true)

	local var0_135 = string.find(arg0_135.serveChar, "our") and "our_serve" or "enemy_serve"

	arg0_135.ball.anchoredPosition = {
		x = arg0_135.orgPos[var0_135].x,
		y = arg0_135.orgPos[var0_135].y + 300
	}
	arg0_135.ballShadow.anchoredPosition = Vector3(arg0_135.orgPos[var0_135].x, arg0_135.orgPos[var0_135].y, 0)

	arg0_135:managedTween(LeanTween.rotate, nil, arg0_135.ball, 360, 0.5):setLoopClamp()
end

function var0_0.resetChar(arg0_136)
	arg0_136:resetPos()

	for iter0_136, iter1_136 in pairs(arg0_136.charactor) do
		if LeanTween.isTweening(go(iter1_136._tf)) then
			LeanTween.cancel(go(iter1_136._tf))
		end
	end

	arg0_136.charactor.our1:setPosTag("our1")
	arg0_136.charactor.our2:setPosTag("our2")
	arg0_136.charactor.enemy1:setPosTag("enemy1")
	arg0_136.charactor.enemy2:setPosTag("enemy2")

	if arg0_136.beginTeam == var3_0 then
		arg0_136.serveChar = "our" .. math.random(2)

		arg0_136.charactor[arg0_136.serveChar]:setPosTag("our_serve")
	else
		arg0_136.serveChar = "enemy" .. math.random(2)

		arg0_136.charactor[arg0_136.serveChar]:setPosTag("enemy_serve")
	end

	arg0_136:setBallPos()
end

function var0_0.charServeBall(arg0_137)
	arg0_137:managedTween(LeanTween.rotate, nil, arg0_137.ball, 360, 0.5):setLoopClamp()

	local var0_137 = string.find(arg0_137.serveChar, "our") and "our_serve" or "enemy_serve"

	arg0_137:managedTween(LeanTween.delayedCall, function()
		arg0_137:managedTween(LeanTween.moveY, nil, arg0_137.ball, arg0_137.orgPos[var0_137].y + var24_0, 0.5):setEase(LeanTweenType.linear)
		arg0_137.charactor[arg0_137.serveChar]:setActionOnce("faqiu", function()
			arg0_137:managedTween(LeanTween.delayedCall, function()
				arg0_137.charactor[arg0_137.serveChar]:move(1, arg0_137.serveChar)
			end, 0.2, nil)
		end)
	end, 0.5, nil)
end

function var0_0.charUpBall(arg0_141, arg1_141)
	local var0_141, var1_141 = arg0_141:getCharWithTag(arg0_141.ballPosTag)

	if not var1_141 then
		return
	end

	arg0_141.upChar = var0_141
	arg0_141.hitChar = arg0_141:getAnotherChar(arg0_141.upChar)

	var1_141:move(0.45, arg0_141.ballPosTag, nil, function()
		var1_141:setActionOnce("chuanqiu")
	end)
end

function var0_0.charHitBall(arg0_143)
	local var0_143 = arg0_143.charactor[arg0_143.hitChar]

	var0_143:move(0.5, arg0_143.ballPosTag, nil, function()
		var0_143:setActionOnce("kouqiu")
	end)
end

function var0_0.showcutin(arg0_145, arg1_145)
	arg0_145:setBtnAvailable(false)
	arg0_145:pauseGame()
	setActive(arg0_145.cutin, true)

	local var0_145 = ""

	for iter0_145, iter1_145 in pairs(arg0_145.charNames) do
		if iter0_145 == arg0_145.hitChar then
			var0_145 = iter1_145
		end
	end

	local var1_145, var2_145, var3_145 = ShipWordHelper.GetWordAndCV(var2_0[arg0_145:getCharIndex(var0_145)], "skill")

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_145)
	setActive(arg0_145:findTF("line", arg0_145.gameUI), true)
	setActive(arg0_145:findTF("shatanpaiqiu_cutin", arg0_145.cutin), false)
	setActive(arg0_145:findTF("shatanpaiqiu_cutin", arg0_145.cutin), true)
	setImageSprite(arg0_145.cutinPaint, arg0_145.cutinPaints:Find(arg0_145:getCharIndex(var0_145)):GetComponent(typeof(Image)).sprite, true)
	LeanTween.moveX(arg0_145.cutin, 0, 0.3):setOnComplete(System.Action(function()
		LeanTween.delayedCall(1, System.Action(function()
			setActive(arg0_145:findTF("line", arg0_145.gameUI), false)
			LeanTween.moveX(arg0_145.cutin, -567, 0.3):setOnComplete(System.Action(function()
				setActive(arg0_145.cutin, false)
				arg0_145:setBtnAvailable(true)
				arg0_145:resumeGame()

				if arg1_145 then
					arg1_145()
				end
			end))
		end))
	end))
end

function var0_0.showScoreCutin(arg0_149, arg1_149)
	arg0_149:setBtnAvailable(false)
	arg0_149:pauseGame()
	setImageSprite(arg0_149.ourScoreCutin, arg0_149.scoreCutinNums:Find(arg0_149.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0_149.enemyScoreCutin, arg0_149.scoreCutinNums:Find(arg0_149.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)
	setActive(arg0_149.scoreCutin, true)
	setLocalScale(arg0_149.scoreCutin, Vector3(1, 0, 1))
	LeanTween.scale(arg0_149.scoreCutin, Vector3(1, 1, 1), 0.2):setOnComplete(System.Action(function()
		arg0_149:resetChar()
		LeanTween.delayedCall(0.6, System.Action(function()
			LeanTween.scale(arg0_149.scoreCutin, Vector3(1, 0, 1), 0.2):setOnComplete(System.Action(function()
				setActive(arg0_149.scoreCutin, false)
				arg0_149:setBtnAvailable(true)
				arg0_149:resumeGame()

				if arg1_149 then
					arg1_149()
				end
			end))
		end))
	end))
end

function var0_0.updateScore(arg0_153)
	setText(arg0_153.ourScore, arg0_153.ourScoreNum)
	setText(arg0_153.enemyScore, arg0_153.enemyScoreNum)
	setActive(arg0_153.qte, false)

	if arg0_153.ourScoreNum >= arg0_153.endScore or arg0_153.enemyScoreNum >= arg0_153.endScore then
		arg0_153:endGame()
	else
		arg0_153:showScoreCutin(function()
			arg0_153:startGame()
		end)
	end
end

function var0_0.endGame(arg0_155)
	setActive(arg0_155.winTag, arg0_155.ourScoreNum ~= arg0_155.enemyScoreNum)
	setActive(arg0_155.loseTag, arg0_155.ourScoreNum ~= arg0_155.enemyScoreNum)
	arg0_155:setBtnAvailable(false)

	arg0_155.isInGame = false

	pg.UIMgr.GetInstance():BlurPanel(arg0_155.endUI)
	setActive(arg0_155.endUI, true)
	setActive(arg0_155.endFreeTitle, arg0_155.isFree)
	setActive(arg0_155.endDayTitle, not arg0_155.isFree)
	setImageSprite(arg0_155.endTitleDay, arg0_155.titleDays:Find(arg0_155.curDay):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0_155.endOurScore, arg0_155.endScoreNums:Find(arg0_155.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(arg0_155.endEnemyScore, arg0_155.endScoreNums:Find(arg0_155.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)

	local var0_155 = -20
	local var1_155

	if arg0_155.ourScoreNum > arg0_155.enemyScoreNum then
		arg0_155.winTag.anchoredPosition = Vector3(-170, 200, 0)
		arg0_155.loseTag.anchoredPosition = Vector3(180, 200, 0)
		var1_155 = -20
	else
		arg0_155.winTag.anchoredPosition = Vector3(170, 200, 0)
		arg0_155.loseTag.anchoredPosition = Vector3(-180, 200, 0)
		var1_155 = 20
	end

	setActive(arg0_155.winTag:GetChild(0), false)
	setActive(arg0_155.winTag:GetChild(0), true)
	setLocalRotation(arg0_155.loseTag, Vector3(0, 0, 0))
	LeanTween.rotateZ(go(arg0_155.loseTag), var1_155, 0.2):setOnComplete(System.Action(function()
		if arg0_155:GetMGHubData().count > 0 then
			arg0_155:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
		end
	end))
end

function var0_0.OnGetAwardDone(arg0_157, arg1_157)
	if arg1_157.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var0_157 = arg0_157:GetMGHubData()
		local var1_157 = var0_157.ultimate
		local var2_157 = var0_157.usedtime
		local var3_157 = var0_157:getConfig("reward_need")
		local var4_157 = arg0_157:GetMGHubData().count
		local var5_157 = pg.NewStoryMgr.GetInstance()
		local var6_157 = arg0_157.storylist[arg0_157:GetMGHubData().usedtime] and arg0_157.storylist[arg0_157:GetMGHubData().usedtime][1] or nil

		if var2_157 ~= 7 and var6_157 and not var5_157:IsPlayed(var6_157) then
			var5_157:Play(var6_157)
		end

		if var1_157 == 0 and var3_157 <= var2_157 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var0_157.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif arg1_157.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		local var7_157 = arg0_157.storylist[7][1] and arg0_157.storylist[7][1] or nil
		local var8_157 = pg.NewStoryMgr.GetInstance()

		if var7_157 and not var8_157:IsPlayed(var7_157) then
			var8_157:Play(var7_157)
		end
	end
end

function var0_0.pauseGame(arg0_158)
	arg0_158:pauseManagedTween()

	if arg0_158.qteTimer then
		arg0_158.qteTimer:Pause()
	end

	if arg0_158.qteTween and LeanTween.isTweening(arg0_158.qteTween) then
		LeanTween.pause(arg0_158.qteTween)
	end

	for iter0_158, iter1_158 in pairs(arg0_158.charactor) do
		iter1_158:pauseSpine()
	end
end

function var0_0.resumeGame(arg0_159)
	arg0_159:resumeManagedTween()

	if arg0_159.qteTimer then
		arg0_159.qteTimer:Resume()
	end

	if arg0_159.qteTween and LeanTween.isTweening(arg0_159.qteTween) then
		LeanTween.resume(arg0_159.qteTween)
	end

	for iter0_159, iter1_159 in pairs(arg0_159.charactor) do
		iter1_159:resumeSpine()
	end
end

function var0_0.clearTimer(arg0_160)
	if arg0_160.qteTimer then
		arg0_160.qteTimer:Stop()

		arg0_160.qteTimer = nil
	end

	if arg0_160.countTimer then
		arg0_160.countTimer:Stop()

		arg0_160.countTimer = nil
	end
end

function var0_0.changeQTEBtnStatus(arg0_161, arg1_161)
	arg0_161.qteBtnStatus = arg1_161
end

function var0_0.resetGameData(arg0_162)
	arg0_162.qteStatus = var9_0
	arg0_162.qteType = var12_0

	arg0_162:changeQTEBtnStatus(var5_0)

	arg0_162.ballPosTag = ""
	arg0_162.isCutin = false
	arg0_162.cutin.anchoredPosition = {
		x = -567,
		y = 582
	}
	arg0_162.isScoreCutin = false

	setActive(arg0_162.scoreCutin, false)

	arg0_162.ourScoreNum = 0
	arg0_162.enemyScoreNum = 0

	setText(arg0_162.ourScore, arg0_162.ourScoreNum)
	setText(arg0_162.enemyScore, arg0_162.enemyScoreNum)
	setActive(arg0_162.qte, false)
	arg0_162:loadSpineChars()
end

function var0_0.exitGame(arg0_163)
	arg0_163.isInGame = false

	arg0_163:setBtnAvailable(true)
	arg0_163:resetGameAni()
end

function var0_0.resetGameAni(arg0_164)
	arg0_164:cleanManagedTween()

	if arg0_164.qteTween and LeanTween.isTweening(arg0_164.qteTween) then
		LeanTween.cancel(arg0_164.qteTween, false)
	end

	arg0_164:clearTimer()
end

function var0_0.willExit(arg0_165)
	arg0_165:clearSpineChars()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_165.selectUI, arg0_165._tf)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_165.endUI, arg0_165._tf)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_165.countTimeUI, arg0_165._tf)
end

function var0_0.onBackPressed(arg0_166)
	if arg0_166.isInGame then
		triggerButton(arg0_166.backBtn)
	elseif isActive(arg0_166.selectUI) then
		triggerButton(arg0_166.selectBackBtn)
	elseif isActive(arg0_166.mainUI) then
		triggerButton(arg0_166.returnBtn)
	end
end

return var0_0

local var0 = class("BattleSubmarineRunResultLayer", import("..base.BaseUI"))

var0.DURATION_WIN_FADE_IN = 0.5
var0.DURATION_LOSE_FADE_IN = 1.5
var0.DURATION_GRADE_LAST = 1.5
var0.DURATION_MOVE = 0.7
var0.DURATION_WIN_SCALE = 0.7

function var0.getUIName(arg0)
	return "BattleResultUI"
end

function var0.setPlayer(arg0)
	return
end

function var0.setShips(arg0)
	return
end

function var0.init(arg0)
	arg0._grade = arg0:findTF("grade")
	arg0._levelText = arg0:findTF("chapterName/Text22", arg0._grade)
	arg0.clearFX = arg0:findTF("clear")
	arg0._main = arg0:findTF("main")
	arg0._blurConatiner = arg0:findTF("blur_container")
	arg0._bg = arg0:findTF("main/jiesuanbeijing")
	arg0._painting = arg0:findTF("painting", arg0._blurConatiner)
	arg0._failPainting = arg0:findTF("fail", arg0._painting)
	arg0._chat = arg0:findTF("chat", arg0._painting)
	arg0._rightBottomPanel = arg0:findTF("dodgem_confirm", arg0._main)
	arg0._exitBtn = arg0:findTF("confirm_btn", arg0._rightBottomPanel)
	arg0._skipBtn = arg0:findTF("skipLayer", arg0._tf)
	arg0.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0.overlay = pg.UIMgr.GetInstance().OverlayMain

	local var0 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1 = arg0:findTF("grade/Xyz/bg13")
	local var2 = arg0:findTF("grade/Xyz/bg14")
	local var3
	local var4
	local var5
	local var6 = arg0.contextData.score
	local var7 = var6 > 0

	setActive(arg0:findTF("jieuan01/BG/bg_victory", arg0._bg), var7)
	setActive(arg0:findTF("jieuan01/BG/bg_fail", arg0._bg), not var7)

	if var7 then
		local var8 = var0[var6 + 1]

		var3 = "battlescore/battle_score_" .. var8 .. "/letter_" .. var8
		var4 = "battlescore/battle_score_" .. var8 .. "/label_" .. var8
	else
		local var9 = var0[1]

		var3 = "battlescore/battle_score_" .. var9 .. "/letter_" .. var9
		var4 = "battlescore/battle_score_" .. var9 .. "/label_" .. var9
	end

	LoadImageSpriteAsync(var3, var1, false)
	LoadImageSpriteAsync(var4, var2, false)
	SetActive(arg0._levelText, false)
	SetActive(arg0:findTF("main/conditions"), false)

	arg0._ratioFitter = GetComponent(arg0._tf, typeof(AspectRatioFitter))
	arg0._ratioFitter.enabled = true
	arg0._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0, arg1)
		arg0._ratioFitter.aspectRatio = arg1
	end)
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.stageId
	local var1 = pg.expedition_data_template[var0]

	setText(arg0._levelText, var1.name)

	local var2 = rtf(arg0._grade)

	arg0._gradeUpperLeftPos = var2.localPosition
	var2.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0._grade, Vector3(0.88, 0.88, 1), var0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0._levelText, true)
		arg0:rankAnimaFinish()
	end))

	arg0._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0, arg0._skipBtn, function()
		arg0:skip()
	end, SFX_CONFIRM)
	arg0:showPainting()
end

function var0.rankAnimaFinish(arg0)
	arg0._stateFlag = BattleResultLayer.STATE_REPORTED
end

function var0.showPainting(arg0)
	local var0
	local var1

	SetActive(arg0._painting, true)

	arg0.paintingName = "u556"

	setPaintingPrefabAsync(arg0._painting, arg0.paintingName, "jiesuan", function()
		if findTF(arg0._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0._painting, "fitter"):GetChild(0), arg0.paintingName, "win_mvp")
		end
	end)
	SetActive(arg0._failPainting, false)

	if arg0.contextData.score > 1 then
		local var2

		var0, var2 = Ship.getWords(900180, "win_mvp")
	else
		local var3

		var0, var3 = Ship.getWords(900180, "lose")
	end

	setText(arg0._chat:Find("Text"), var0)

	local var4 = arg0._chat:Find("Text"):GetComponent(typeof(Text))

	if #var4.text > CHAT_POP_STR_LEN then
		var4.alignment = TextAnchor.MiddleLeft
	else
		var4.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0._chat, true)

	arg0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.moveX(rtf(arg0._painting), 50, 0.1):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0._chat.gameObject), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeOutBack)
	end))
end

function var0.skip(arg0)
	if arg0._stateFlag == BattleResultLayer.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._skipBtn)
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	pg.CameraFixMgr.GetInstance():disconnect(arg0.camEventId)
end

return var0

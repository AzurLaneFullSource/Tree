local var0_0 = class("BattleSubmarineRunResultLayer", import("..base.BaseUI"))

var0_0.DURATION_WIN_FADE_IN = 0.5
var0_0.DURATION_LOSE_FADE_IN = 1.5
var0_0.DURATION_GRADE_LAST = 1.5
var0_0.DURATION_MOVE = 0.7
var0_0.DURATION_WIN_SCALE = 0.7

function var0_0.getUIName(arg0_1)
	return "BattleResultUI"
end

function var0_0.setPlayer(arg0_2)
	return
end

function var0_0.setShips(arg0_3)
	return
end

function var0_0.init(arg0_4)
	arg0_4._grade = arg0_4:findTF("grade")
	arg0_4._levelText = arg0_4:findTF("chapterName/Text22", arg0_4._grade)
	arg0_4.clearFX = arg0_4:findTF("clear")
	arg0_4._main = arg0_4:findTF("main")
	arg0_4._blurConatiner = arg0_4:findTF("blur_container")
	arg0_4._bg = arg0_4:findTF("main/jiesuanbeijing")
	arg0_4._painting = arg0_4:findTF("painting", arg0_4._blurConatiner)
	arg0_4._failPainting = arg0_4:findTF("fail", arg0_4._painting)
	arg0_4._chat = arg0_4:findTF("chat", arg0_4._painting)
	arg0_4._rightBottomPanel = arg0_4:findTF("dodgem_confirm", arg0_4._main)
	arg0_4._exitBtn = arg0_4:findTF("confirm_btn", arg0_4._rightBottomPanel)
	arg0_4._skipBtn = arg0_4:findTF("skipLayer", arg0_4._tf)
	arg0_4.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0_4.overlay = pg.UIMgr.GetInstance().OverlayMain

	local var0_4 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_4 = arg0_4:findTF("grade/Xyz/bg13")
	local var2_4 = arg0_4:findTF("grade/Xyz/bg14")
	local var3_4
	local var4_4
	local var5_4
	local var6_4 = arg0_4.contextData.score
	local var7_4 = var6_4 > 0

	setActive(arg0_4:findTF("jieuan01/BG/bg_victory", arg0_4._bg), var7_4)
	setActive(arg0_4:findTF("jieuan01/BG/bg_fail", arg0_4._bg), not var7_4)

	if var7_4 then
		local var8_4 = var0_4[var6_4 + 1]

		var3_4 = "battlescore/battle_score_" .. var8_4 .. "/letter_" .. var8_4
		var4_4 = "battlescore/battle_score_" .. var8_4 .. "/label_" .. var8_4
	else
		local var9_4 = var0_4[1]

		var3_4 = "battlescore/battle_score_" .. var9_4 .. "/letter_" .. var9_4
		var4_4 = "battlescore/battle_score_" .. var9_4 .. "/label_" .. var9_4
	end

	LoadImageSpriteAsync(var3_4, var1_4, false)
	LoadImageSpriteAsync(var4_4, var2_4, false)
	SetActive(arg0_4._levelText, false)
	SetActive(arg0_4:findTF("main/conditions"), false)

	arg0_4._ratioFitter = GetComponent(arg0_4._tf, typeof(AspectRatioFitter))
	arg0_4._ratioFitter.enabled = true
	arg0_4._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_4.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_5, arg1_5)
		arg0_4._ratioFitter.aspectRatio = arg1_5
	end)
end

function var0_0.didEnter(arg0_6)
	local var0_6 = arg0_6.contextData.stageId
	local var1_6 = pg.expedition_data_template[var0_6]

	setText(arg0_6._levelText, var1_6.name)

	local var2_6 = rtf(arg0_6._grade)

	arg0_6._gradeUpperLeftPos = var2_6.localPosition
	var2_6.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)

	arg0_6._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0_6._grade, Vector3(0.88, 0.88, 1), var0_0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0_6._levelText, true)
		arg0_6:rankAnimaFinish()
	end))

	arg0_6._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0_6._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0_6, arg0_6._skipBtn, function()
		arg0_6:skip()
	end, SFX_CONFIRM)
	arg0_6:showPainting()
end

function var0_0.rankAnimaFinish(arg0_9)
	arg0_9._stateFlag = BattleResultLayer.STATE_REPORTED
end

function var0_0.showPainting(arg0_10)
	local var0_10
	local var1_10

	SetActive(arg0_10._painting, true)

	arg0_10.paintingName = "u556"

	setPaintingPrefabAsync(arg0_10._painting, arg0_10.paintingName, "jiesuan", function()
		if findTF(arg0_10._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_10._painting, "fitter"):GetChild(0), arg0_10.paintingName, "win_mvp")
		end
	end)
	SetActive(arg0_10._failPainting, false)

	if arg0_10.contextData.score > 1 then
		local var2_10

		var0_10, var2_10 = Ship.getWords(900180, "win_mvp")
	else
		local var3_10

		var0_10, var3_10 = Ship.getWords(900180, "lose")
	end

	setText(arg0_10._chat:Find("Text"), var0_10)

	local var4_10 = arg0_10._chat:Find("Text"):GetComponent(typeof(Text))

	if #var4_10.text > CHAT_POP_STR_LEN then
		var4_10.alignment = TextAnchor.MiddleLeft
	else
		var4_10.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0_10._chat, true)

	arg0_10._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.moveX(rtf(arg0_10._painting), 50, 0.1):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_10._chat.gameObject), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeOutBack)
	end))
end

function var0_0.skip(arg0_13)
	if arg0_13._stateFlag == BattleResultLayer.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_13._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0_13:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0_0.onBackPressed(arg0_14)
	triggerButton(arg0_14._skipBtn)
end

function var0_0.willExit(arg0_15)
	LeanTween.cancel(go(arg0_15._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_15._tf)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_15.camEventId)
end

return var0_0

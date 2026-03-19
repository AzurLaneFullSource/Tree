local var0_0 = class("NewEducateNailingGame", import("view.base.BaseSubView"))
local var1_0 = 125
local var2_0 = -25
local var3_0 = -115
local var4_0 = 400
local var5_0 = {
	-450,
	450
}
local var6_0 = 9
local var7_0 = 100
local var8_0 = 30
local var9_0 = 35
local var10_0 = {
	NORMAL = 1,
	INVALID = 2
}
local var11_0 = {
	NORMAL = 1,
	INSERTION = 2
}

function var0_0.getUIName(arg0_1)
	return "NewEducateNailingGame"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.meunUI = arg0_2._tf:Find("box/menu")
	arg0_2.countUI = arg0_2._tf:Find("box/count")

	setText(arg0_2.countUI:Find("tip/Text"), i18n("child2_nailing_game_tip"))

	arg0_2.countdownDft = arg0_2.countUI:Find("count"):GetComponent(typeof(DftAniEvent))
	arg0_2.gameUI = arg0_2._tf:Find("box/game")
	arg0_2.scoreTextCom = arg0_2.gameUI:Find("score/value"):GetComponent(typeof(Text))

	setText(arg0_2.gameUI:Find("score/Text"), i18n("child2_nailing_game_score"))

	arg0_2.countTextCom = arg0_2.gameUI:Find("count/value"):GetComponent(typeof(Text))

	setText(arg0_2.gameUI:Find("count/Text"), i18n("child2_nailing_game_count"))

	arg0_2.charSDTF = arg0_2.gameUI:Find("dailog/char")
	arg0_2.hammerTF = arg0_2.gameUI:Find("hammer")
	arg0_2.hammerAnimUI = arg0_2.hammerTF:GetComponent(typeof(SpineAnimUI))
	arg0_2.nailContainer = arg0_2.gameUI:Find("nail_container")
	arg0_2.noramlNailTpl = arg0_2.gameUI:Find("tpls/nail_normal")
	arg0_2.invalidNailTpl = arg0_2.gameUI:Find("tpls/nail_invalid")
	arg0_2.resultUI = arg0_2._tf:Find("box/result")
	arg0_2.resultScoreTextCom = arg0_2.resultUI:Find("score/Text"):GetComponent(typeof(Text))
	arg0_2.resultEffectTF = arg0_2._tf:Find("box/VX_get")

	setActive(arg0_2.resultEffectTF, false)

	arg0_2.animDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.animDft:SetEndEvent(function(arg0_3)
		arg0_2:_Hide()
	end)
end

function var0_0.OnInit(arg0_4)
	arg0_4.countdownDft:SetEndEvent(function(arg0_5)
		arg0_4:StartGame()
	end)
	onButton(arg0_4, arg0_4._tf:Find("back"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("box/menu/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child2_nailing_minigame_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.meunUI:Find("start"), function()
		arg0_4:StartCountDown()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.gameUI:Find("knock"), function()
		arg0_4:Knock()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.resultUI:Find("sure"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_11, arg1_11, arg2_11)
	var0_0.super.Show(arg0_11)

	arg0_11.id = arg1_11
	arg0_11.onHide = arg2_11
	arg0_11.configData = pg.child2_minigame[arg0_11.id].config_data
	arg0_11.totalCnt = arg0_11.configData.count
	arg0_11.speed = arg0_11.configData.hammer_spd
	arg0_11.normalCnt = arg0_11.configData.nail_count
	arg0_11.invalidCnt = arg0_11.configData.red_nail_count
	arg0_11.normalScore = arg0_11.configData.nail_score
	arg0_11.invalidScore = arg0_11.configData.red_nail_score
	arg0_11.slotList = {}

	for iter0_11 = 1, var6_0 do
		table.insert(arg0_11.slotList, iter0_11)
	end

	arg0_11:LoadCharSD()
	arg0_11:BlurPanel(arg0_11._tf, {
		groupDelta = 3
	})
end

function var0_0.LoadCharSD(arg0_12)
	local var0_12 = getProxy(NewEducateProxy):GetCurChar():getConfig("spine_char").minigame_face

	PoolMgr.GetInstance():GetSpineChar(var0_12, true, function(arg0_13)
		arg0_12.charName = var0_12
		arg0_12.charModel = arg0_13
		tf(arg0_13).localScale = Vector3(1, 1, 1)

		arg0_13:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		setParent(arg0_13, arg0_12.charSDTF)
	end)
end

function var0_0.ResetGame(arg0_14)
	arg0_14.isKnocking = false
	arg0_14.score = 0

	arg0_14:UpdateScore()

	arg0_14.remainCnt = arg0_14.totalCnt

	arg0_14:UpdateRemainCnt()
	setActive(arg0_14.meunUI, false)
	setActive(arg0_14.countUI, false)
	setActive(arg0_14.resultUI, false)
	setActive(arg0_14.gameUI, true)
	setActive(arg0_14.resultEffectTF, false)
	arg0_14:ResetHammer()
end

function var0_0.StartCountDown(arg0_15)
	setActive(arg0_15.meunUI, false)
	setActive(arg0_15.countUI, true)
	quickPlayAnimator(arg0_15.countUI:Find("count"), "countdown")
end

function var0_0.StartGame(arg0_16)
	arg0_16:ResetGame()
	arg0_16:RandomNails()
	arg0_16:MoveHammer()
end

function var0_0.RandomNails(arg0_17)
	removeAllChildren(arg0_17.nailContainer)

	arg0_17.nails = {}

	shuffle(arg0_17.slotList)

	for iter0_17 = 1, arg0_17.normalCnt + arg0_17.invalidCnt do
		local var0_17 = iter0_17 <= arg0_17.normalCnt and var10_0.NORMAL or var10_0.INVALID
		local var1_17 = var0_17 == var10_0.NORMAL and arg0_17.noramlNailTpl or arg0_17.invalidNailTpl
		local var2_17 = cloneTplTo(var1_17, arg0_17.nailContainer)
		local var3_17 = (arg0_17.slotList[iter0_17] - 1) * var7_0 + var5_0[1]
		local var4_17 = {
			y = 0,
			x = var3_17 + math.random(0, var8_0)
		}

		setLocalPosition(var2_17, var4_17)

		arg0_17.nails[var2_17] = {
			type = var0_17,
			pos = var4_17,
			state = var11_0.NORMAL
		}
	end
end

function var0_0.ResetHammer(arg0_18)
	setLocalPosition(arg0_18.hammerTF, {
		x = var5_0[1],
		y = var1_0
	})
end

function var0_0.MoveHammer(arg0_19)
	local var0_19 = (var5_0[2] - var5_0[1]) / arg0_19.speed

	arg0_19.swayTweenId = LeanTween.moveX(arg0_19.hammerTF, var5_0[2], var0_19):setLoopPingPong(0).uniqueId
end

function var0_0.PauseSway(arg0_20)
	if LeanTween.isTweening(arg0_20.swayTweenId) then
		LeanTween.pause(arg0_20.swayTweenId)
	end
end

function var0_0.ResumeSway(arg0_21)
	if LeanTween.isTweening(arg0_21.swayTweenId) then
		LeanTween.resume(arg0_21.swayTweenId)
	end
end

function var0_0.Knock(arg0_22)
	if arg0_22.isKnocking then
		return
	end

	arg0_22.isKnocking = true

	arg0_22:PauseSway()

	arg0_22.remainCnt = arg0_22.remainCnt - 1

	arg0_22:UpdateRemainCnt()

	local var0_22 = arg0_22:GetHitNailTF()
	local var1_22 = arg0_22.nails[var0_22]
	local var2_22 = var1_22 and var1_22.state == var11_0.NORMAL

	seriesAsync({
		function(arg0_23)
			arg0_22:DownHammer(var2_22, arg0_23)
		end,
		function(arg0_24)
			arg0_22:CheckHit(var0_22, arg0_24)
		end,
		function(arg0_25)
			arg0_22:UpHammer(arg0_25)
		end
	}, function()
		arg0_22:CheckGameOver()

		arg0_22.isKnocking = false
	end)
end

function var0_0.GetHitNailTF(arg0_27)
	local var0_27 = arg0_27.hammerTF.localPosition.x

	for iter0_27, iter1_27 in pairs(arg0_27.nails) do
		local var1_27 = iter0_27.localPosition.x

		if var0_27 >= var1_27 - var9_0 and var0_27 <= var1_27 + var9_0 then
			return iter0_27
		end
	end

	return nil
end

function var0_0.DownHammer(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg1_28 and var2_0 or var3_0
	local var1_28 = (var0_28 - var1_0) / var4_0

	arg0_28.downTweenId = LeanTween.moveY(arg0_28.hammerTF, var0_28, var1_28):setOnComplete(System.Action(arg2_28)).uniqueId

	arg0_28.hammerAnimUI:GetAnimationState():SetAnimation(0, "normal", false)
end

function var0_0.CheckHit(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.nails[arg1_29]

	if not (var0_29 and var0_29.state == var11_0.NORMAL) then
		-- block empty
	else
		if var0_29.type == var10_0.NORMAL then
			var0_29.state = var11_0.INSERTION
			arg0_29.score = arg0_29.score + arg0_29.normalScore

			setActive(arg1_29:Find("insertion"), true)
			setActive(arg1_29:Find("normal"), false)
		else
			arg0_29.score = math.max(arg0_29.score + arg0_29.invalidScore, 0)
		end

		arg0_29:UpdateScore()
	end

	arg2_29()
end

function var0_0.UpHammer(arg0_30, arg1_30)
	local var0_30 = (var1_0 - arg0_30.hammerTF.localPosition.y) / var4_0

	arg0_30.upTweenId = LeanTween.moveY(arg0_30.hammerTF, var1_0, var0_30):setOnComplete(System.Action(arg1_30)).uniqueId
end

function var0_0.CheckGameOver(arg0_31)
	if arg0_31.remainCnt == 0 then
		arg0_31:EndGame()
	else
		arg0_31:ResumeSway()
	end
end

function var0_0.UpdateScore(arg0_32)
	arg0_32.resultScoreTextCom.text = i18n("child2_nailing_game_result") .. arg0_32.score
	arg0_32.scoreTextCom.text = arg0_32.score
end

function var0_0.UpdateRemainCnt(arg0_33)
	arg0_33.countTextCom.text = arg0_33.remainCnt
end

function var0_0.EndGame(arg0_34)
	setActive(arg0_34.gameUI, false)
	setActive(arg0_34.resultUI, true)
	setActive(arg0_34.resultEffectTF, true)
end

function var0_0._Hide(arg0_35)
	var0_0.super.Hide(arg0_35)
	arg0_35:UnOverlayPanel(arg0_35._tf)
	existCall(arg0_35.onHide(arg0_35.score))

	arg0_35.onHide = nil

	if LeanTween.isTweening(arg0_35.swayTweenId) then
		LeanTween.cancel(arg0_35.swayTweenId)
	end

	arg0_35.swayTweenId = nil

	if LeanTween.isTweening(arg0_35.upTweenId) then
		LeanTween.cancel(arg0_35.upTweenId)
	end

	arg0_35.upTweenId = nil

	if LeanTween.isTweening(arg0_35.downTweenId) then
		LeanTween.cancel(arg0_35.downTweenId)
	end

	arg0_35.downTweenId = nil

	if arg0_35.charName and arg0_35.charModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_35.charName, arg0_35.charModel)

		arg0_35.charName = nil
		arg0_35.charModel = nil
	end
end

function var0_0.Hide(arg0_36)
	quickPlayAnimation(arg0_36._tf, "anim_NewEducateNailingGame_out")
end

function var0_0.OnDestroy(arg0_37)
	arg0_37.animDft:SetEndEvent(nil)
	arg0_37.countdownDft:SetEndEvent(nil)
	arg0_37.hammerAnimUI:SetActionCallBack(nil)
end

return var0_0

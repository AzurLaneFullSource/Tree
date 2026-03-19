local var0_0 = class("NewEducateScratchGame", import("view.base.BaseSubView"))

var0_0.HAND_MOVE_TIME = 1

function var0_0.getUIName(arg0_1)
	return "NewEducateScratchGame"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scratchCom = arg0_2._tf:Find("panel/card/rawImage"):GetComponent(typeof(UIScratch))
	arg0_2.resultTF = arg0_2._tf:Find("panel/card/result")
	arg0_2.handTF = arg0_2._tf:Find("panel/hand")
	arg0_2.sureBtn = arg0_2._tf:Find("panel/sure")
	arg0_2.resultEffectTF = arg0_2._tf:Find("bg/VX_get")

	setActive(arg0_2.resultEffectTF, false)

	arg0_2.animDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.animDft:SetEndEvent(function(arg0_3)
		arg0_2:_Hide()
	end)
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("back"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.sureBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child2_scratch_minigame_help.tip
		})
	end, SFX_PANEL)

	function arg0_4.scratchCom.onUpdateErase(arg0_8)
		arg0_4.progress = tonumber(string.format("%.2f", arg0_8))

		arg0_4:UpdateProgress()

		if isActive(arg0_4.handTF) then
			arg0_4:ResetHand()
		end
	end

	function arg0_4.scratchCom.onFinishErase()
		arg0_4:EndGame()
	end
end

function var0_0.Show(arg0_10, arg1_10, arg2_10)
	var0_0.super.Show(arg0_10)

	arg0_10.id = arg1_10
	arg0_10.configData = pg.child2_minigame[arg0_10.id].config_data
	arg0_10.finishScore = arg0_10.configData.finish_score
	arg0_10.onHide = arg2_10

	arg0_10:StartGame()
	arg0_10:BlurPanel(arg0_10._tf, {
		groupDelta = 3
	})
end

function var0_0.ResetGame(arg0_11)
	arg0_11.score = 0
	arg0_11.progress = 0

	arg0_11:UpdateProgress()
	arg0_11.scratchCom:ResetErase()

	local var0_11 = math.random(3)

	eachChild(arg0_11.resultTF, function(arg0_12)
		setActive(arg0_12, tonumber(arg0_12.name) == var0_11)
	end)
	setActive(arg0_11.sureBtn, false)
	setActive(arg0_11.resultEffectTF, false)
	arg0_11:ResetHand()
end

function var0_0.ResetHand(arg0_13)
	arg0_13:cleanManagedTween()
	setLocalPosition(arg0_13.handTF, {
		x = 318
	})
	setActive(arg0_13.handTF, false)
end

function var0_0.StartGame(arg0_14)
	arg0_14:ResetGame()
	setActive(arg0_14.handTF, true)
	arg0_14:managedTween(LeanTween.moveX, nil, arg0_14.handTF, -220, var0_0.HAND_MOVE_TIME):setLoopPingPong()
end

function var0_0.UpdateProgress(arg0_15)
	return
end

function var0_0.EndGame(arg0_16)
	arg0_16.score = arg0_16.progress >= arg0_16.scratchCom.finishPercent and arg0_16.finishScore or 0
	arg0_16.progress = 1

	arg0_16:UpdateProgress()
	setActive(arg0_16.sureBtn, true)
	setActive(arg0_16.resultEffectTF, true)
end

function var0_0._Hide(arg0_17)
	var0_0.super.Hide(arg0_17)
	arg0_17:UnOverlayPanel(arg0_17._tf)
	existCall(arg0_17.onHide(arg0_17.score))

	arg0_17.onHide = nil
end

function var0_0.Hide(arg0_18)
	quickPlayAnimation(arg0_18._tf, "anim_NewEducateScratchGame_out")
end

function var0_0.OnDestroy(arg0_19)
	arg0_19.animDft:SetEndEvent(nil)
end

return var0_0

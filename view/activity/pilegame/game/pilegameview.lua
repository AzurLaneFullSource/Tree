local var0_0 = class("PileGameView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
end

function var0_0.SetUI(arg0_2, arg1_2)
	pg.DelegateInfo.New(arg0_2)

	arg0_2._go = arg1_2
	arg0_2._tf = tf(arg1_2)
	arg0_2.bg = arg0_2._tf:Find("AD")
	arg0_2.curtainTF = arg0_2._tf:Find("AD/curtain")
	arg0_2.countDown = arg0_2.curtainTF:Find("Text"):GetComponent(typeof(Text))
	arg0_2.itemTpl = arg0_2._tf:Find("AD/item")
	arg0_2.groundTpl = arg0_2._tf:Find("AD/ground")
	arg0_2.gameContainer = arg0_2._tf:Find("AD/game")
	arg0_2.itemsContainer = arg0_2._tf:Find("AD/game/items")
	arg0_2.scoreTxt = arg0_2._tf:Find("AD/score_panel/Text"):GetComponent(typeof(Text))
	arg0_2.heats = {
		arg0_2._tf:Find("AD/score_panel/heart1"),
		arg0_2._tf:Find("AD/score_panel/heart2"),
		arg0_2._tf:Find("AD/score_panel/heart3")
	}
	arg0_2.manjuuAnim = arg0_2._tf:Find("AD/npc/manjuu"):GetComponent(typeof(Animator))
	arg0_2.anikiAnim = arg0_2._tf:Find("AD/npc/aniki"):GetComponent(typeof(Animator))
	arg0_2.manjuuPilot = arg0_2._tf:Find("AD/npc/manjuu_pilot")
	arg0_2.backBtn = arg0_2._tf:Find("AD/back")
	arg0_2.exitPanel = arg0_2._tf:Find("AD/exit_panel")
	arg0_2.exitPanelConfirmBtn = arg0_2.exitPanel:Find("frame/confirm")
	arg0_2.exitPanelCancelBtn = arg0_2.exitPanel:Find("frame/cancel")
	arg0_2.resultPanel = arg0_2._tf:Find("AD/result")
	arg0_2.endGameBtn = arg0_2.resultPanel:Find("frame/endGame")
	arg0_2.finalScoreTxt = arg0_2.resultPanel:Find("frame/score/Text"):GetComponent(typeof(Text))
	arg0_2.highestScoreText = arg0_2.resultPanel:Find("frame/highestscore/Text"):GetComponent(typeof(Text))
	arg0_2.itemIndexTF = arg0_2._tf:Find("AD/score_panel/index/target")
	arg0_2.overviewPanel = arg0_2._tf:Find("overview")
	arg0_2.startBtn = arg0_2._tf:Find("overview/start")
	arg0_2.helpBtn = arg0_2._tf:Find("overview/help")
	arg0_2.deathLine = arg0_2._tf:Find("death_line")
	arg0_2.safeLine = arg0_2._tf:Find("safe_line")
	arg0_2.itemCollider = arg0_2._tf:Find("item_collider")
	arg0_2.items = {}
	arg0_2.bgMgr = PileGameBgMgr.New(arg0_2._tf:Find("AD/bgs"))
end

function var0_0.OnEnterGame(arg0_3, arg1_3)
	arg0_3.viewData = arg1_3
	arg0_3.gameHelpTip = arg0_3.viewData.tip and arg0_3.viewData.tip or nil

	setActive(arg0_3.overviewPanel, true)
	setActive(arg0_3.bg, false)
	onButton(arg0_3, arg0_3.startBtn, function()
		arg0_3.controller:StartGame()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_3.gameHelpTip or pg.gametip.pile_game_notice.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:ShowExitMsg()
	end, SFX_PANEL)
end

function var0_0.ShowExitMsg(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7.exitPanel)
	setActive(arg0_7.exitPanel, true)

	local function var0_7()
		setActive(arg0_7.exitPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_7.exitPanel, arg0_7.bg)
	end

	onButton(arg0_7, arg0_7.exitPanelCancelBtn, var0_7, SFX_PANEL)
	onButton(arg0_7, arg0_7.exitPanelConfirmBtn, function()
		var0_7()
		arg0_7.controller:OnEndGame(false)
	end, SFX_PANEL)
end

function var0_0.DoCurtain(arg0_10, arg1_10)
	seriesAsync({
		function(arg0_11)
			arg0_10.bgMgr:Init(arg0_11)
		end,
		function(arg0_12)
			setActive(arg0_10.overviewPanel, false)
			setActive(arg0_10.bg, true)
			setActive(arg0_10.curtainTF, true)
			setAnchoredPosition(arg0_10.anikiAnim.gameObject, {
				x = -177,
				y = 158
			})

			local var0_12 = 4

			arg0_10.timer = Timer.New(function()
				var0_12 = var0_12 - 1

				if var0_12 == 3 then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_COUNTDOWN)
				end

				arg0_10.countDown.text = var0_12

				if var0_12 == 0 then
					setActive(arg0_10.curtainTF, false)
					arg0_12()
				end
			end, 1, 4)

			arg0_10.timer:Start()
			arg0_10.timer.func()
		end
	}, arg1_10)
end

function var0_0.UpdateScore(arg0_14, arg1_14, arg2_14)
	arg0_14.scoreTxt.text = arg1_14

	local var0_14 = false

	if arg1_14 > 0 and arg1_14 % PileGameConst.LEVEL_TO_HAPPY_ANIM == 0 then
		arg0_14.manjuuAnim:SetTrigger("happy")
		arg0_14.anikiAnim:SetTrigger("nice")

		var0_14 = true
	end

	local var1_14 = arg0_14.items[arg2_14]

	if var1_14 and var0_14 then
		var1_14:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("win")
	elseif var1_14 then
		var1_14:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("idle")
	end

	if arg2_14 then
		local var2_14 = arg2_14.position.x

		arg0_14.itemIndexTF.localPosition = Vector3(var2_14 / PileGameConst.RATIO, 0, 0)

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_SUCCESS)
	end
end

function var0_0.UpdateFailedCnt(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.heats) do
		setActive(iter1_15, arg2_15 < iter0_15)
	end

	if arg3_15 then
		arg0_15.anikiAnim:SetTrigger("miss")
		arg0_15.items[arg4_15]:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("miss")
	end
end

function var0_0.AddPile(arg0_16, arg1_16, arg2_16, arg3_16)
	local function var0_16(arg0_17)
		local var0_17 = tf(arg0_17)

		SetParent(var0_17, arg0_16.itemsContainer)

		var0_17.sizeDelta = arg1_16.sizeDelta
		var0_17.pivot = arg1_16.pivot
		go(var0_17).name = arg1_16.name .. "_" .. arg1_16.gname
		arg0_16.items[arg1_16] = var0_17
		var0_17.eulerAngles = Vector3(0, 0, 0)

		arg0_16:OnItemPositionChange(arg1_16)
		setActive(var0_17, not arg2_16)

		if not arg2_16 then
			var0_17:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("exit")
		end

		if PileGameConst.DEBUG then
			arg0_16:AddPileCollider(arg1_16)
		end

		arg3_16()
	end

	PoolMgr.GetInstance():GetPrefab("Stacks/" .. arg1_16.gname, arg1_16.gname, true, var0_16)
end

function var0_0.OnStartDrop(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg3_18 then
		arg0_18.manjuuAnim:SetBool("despair", PileGameController.DROP_AREA_WARN == arg2_18)
	else
		arg0_18.manjuuAnim:SetTrigger("shock")
	end

	arg0_18.items[arg1_18]:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("drop")
end

function var0_0.OnItemPositionChange(arg0_19, arg1_19)
	local var0_19 = arg0_19.items[arg1_19]

	if var0_19 then
		var0_19.localPosition = arg1_19.position
	end
end

function var0_0.OnItemPositionChangeWithAnim(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.items[arg1_20]

	if var0_20 then
		LeanTween.moveLocalY(go(var0_20), arg1_20.position.y, PileGameConst.SINK_TIME):setOnComplete(System.Action(arg2_20))
	end
end

function var0_0.OnItemIndexPositionChange(arg0_21, arg1_21)
	local var0_21 = arg1_21.position.x
	local var1_21 = arg1_21.position.y

	arg0_21.prevPosition = arg0_21.prevPosition or arg0_21.manjuuPilot.localPosition.x

	local var2_21 = 0
	local var3_21 = 1

	if var0_21 - arg0_21.prevPosition <= 0 then
		var2_21 = var0_21 + 140
		var3_21 = -1
	else
		var2_21 = var0_21 - 140
	end

	local var4_21 = var1_21 + arg1_21.sizeDelta.y + arg0_21.manjuuPilot.rect.height / 2

	arg0_21.manjuuPilot.localPosition = Vector3(var2_21, var4_21, 0)
	arg0_21.manjuuPilot.localScale = Vector3(var3_21, 1, 1)
	arg0_21.prevPosition = var0_21
end

function var0_0.OnExceedingTheHighestScore(arg0_22)
	arg0_22.manjuuAnim:SetTrigger("satisfied")
end

function var0_0.DoSink(arg0_23, arg1_23, arg2_23)
	local var0_23 = getAnchoredPosition(arg0_23.anikiAnim.gameObject)

	LeanTween.value(arg0_23.anikiAnim.gameObject, var0_23.y, var0_23.y - arg1_23, PileGameConst.SINK_TIME):setOnUpdate(System.Action_float(function(arg0_24)
		setAnchoredPosition(arg0_23.anikiAnim.gameObject, {
			y = arg0_24
		})
	end)):setOnComplete(System.Action(arg2_23))
	arg0_23.bgMgr:DoMove(arg1_23)
end

function var0_0.OnRemovePile(arg0_25, arg1_25)
	local var0_25 = arg0_25.items[arg1_25]

	if var0_25 then
		if PileGameConst.DEBUG then
			Destroy(var0_25:Find("collider").gameObject)
		end

		var0_25:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("exit")

		var0_25.eulerAngles = Vector3(0, 0, 0)

		PoolMgr.GetInstance():ReturnPrefab("Stacks/" .. arg1_25.gname, arg1_25.gname, var0_25.gameObject)

		arg0_25.items[arg1_25] = nil
	end
end

function var0_0.PlaySpeAction(arg0_26, arg1_26)
	local var0_26 = arg0_26.items[arg1_26]

	if var0_26 then
		local var1_26 = arg1_26.speActionCount

		if var1_26 == 0 then
			return
		end

		local var2_26 = math.random(1, var1_26) - 1
		local var3_26 = var2_26 == 0 and "spe" or "spe" .. var2_26

		var0_26:Find("anim"):GetComponent(typeof(Animator)):SetTrigger(var3_26)
	end
end

function var0_0.OnGameStart(arg0_27)
	onButton(arg0_27, arg0_27.bg, function()
		arg0_27.controller:Drop()
	end, SFX_PANEL)
end

function var0_0.OnGameExited(arg0_29)
	setActive(arg0_29.overviewPanel, true)
	setActive(arg0_29.bg, false)

	arg0_29.itemsContainer.eulerAngles = Vector3(0, 0, 0)
	arg0_29.itemsContainer.pivot = Vector2(0.5, 0.5)

	arg0_29.bgMgr:Clear()

	if PileGameConst.DEBUG then
		Destroy(arg0_29.gameContainer:Find("ground").gameObject)
		Destroy(arg0_29.gameContainer:Find("deathLineR").gameObject)
		Destroy(arg0_29.gameContainer:Find("deathLineL").gameObject)
		Destroy(arg0_29.gameContainer:Find("safeLineL").gameObject)
		Destroy(arg0_29.gameContainer:Find("safeLineR").gameObject)
	end
end

function var0_0.OnGameEnd(arg0_30, arg1_30, arg2_30)
	(function()
		pg.UIMgr.GetInstance():BlurPanel(arg0_30.resultPanel)
		setActive(arg0_30.resultPanel, true)
		onButton(arg0_30, arg0_30.endGameBtn, function()
			setActive(arg0_30.resultPanel, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_30.resultPanel, arg0_30.bg)
			arg0_30.controller:ExitGame()
		end)

		arg0_30.finalScoreTxt.text = arg1_30
		arg0_30.highestScoreText.text = arg2_30
	end)()
end

function var0_0.OnShake(arg0_33, arg1_33)
	local var0_33 = getAnchoredPosition(arg0_33.anikiAnim)

	setAnchoredPosition(arg0_33.anikiAnim, {
		x = var0_33.x + arg1_33
	})
end

function var0_0.OnCollapse(arg0_34, arg1_34, arg2_34, arg3_34)
	local function var0_34(arg0_35, arg1_35, arg2_35, arg3_35)
		LeanTween.value(go(arg0_34.itemsContainer), arg0_35, arg1_35, arg2_35):setOnUpdate(System.Action_float(function(arg0_36)
			arg0_34.itemsContainer.eulerAngles = Vector3(0, 0, arg0_36)
		end)):setOnComplete(System.Action(arg3_35))
	end

	seriesAsync({
		function(arg0_37)
			arg0_34.manjuuAnim:SetTrigger("shock")

			local var0_37 = 0.5 + arg1_34 / arg0_34.itemsContainer.rect.width

			arg0_34.itemsContainer.pivot = Vector2(var0_37, 0)

			local var1_37 = arg2_34 == 1 and -35 or 35

			var0_34(0, var1_37, 0.5, function()
				arg0_37(var1_37)
			end)
		end,
		function(arg0_39, arg1_39)
			local var0_39 = {}
			local var1_39 = _.values(arg0_34.items)

			table.sort(var1_39, function(arg0_40, arg1_40)
				return arg0_40.localPosition.y < arg1_40.localPosition.y
			end)

			for iter0_39, iter1_39 in ipairs(var1_39) do
				table.insert(var0_39, function(arg0_41)
					local var0_41 = arg2_34 == 1 and -90 or 90

					parallelAsync({
						function(arg0_42)
							var0_34(arg1_39, var0_41, 1, arg0_42)
						end,
						function(arg0_43)
							local var0_43 = arg2_34 == 1 and -356 or 356

							LeanTween.value(go(iter1_39), 0, var0_43, 1):setOnUpdate(System.Action_float(function(arg0_44)
								iter1_39.eulerAngles = Vector3(0, 0, arg0_44)
							end)):setOnComplete(System.Action(arg0_43))
						end,
						function(arg0_45)
							LeanTween.moveLocalY(go(iter1_39), iter1_39.localPosition.y + 50 * iter0_39, 1):setOnComplete(System.Action(arg0_45))
						end
					}, arg0_41)
				end)
			end

			parallelAsync(var0_39, arg0_39)
		end
	}, arg3_34)
end

function var0_0.InitSup(arg0_46, arg1_46)
	if PileGameConst.DEBUG then
		local var0_46 = arg1_46.ground
		local var1_46 = cloneTplTo(arg0_46.groundTpl, arg0_46.gameContainer, "ground")

		var1_46.sizeDelta = var0_46.sizeDelta
		var1_46.pivot = var0_46.pivot
		var1_46.localPosition = var0_46.position
		cloneTplTo(arg0_46.deathLine, arg0_46.gameContainer, "deathLineR").localPosition = Vector3(arg1_46.deathLine.y, 0, 0)
		cloneTplTo(arg0_46.deathLine, arg0_46.gameContainer, "deathLineL").localPosition = Vector3(arg1_46.deathLine.x, 0, 0)
		cloneTplTo(arg0_46.safeLine, arg0_46.gameContainer, "safeLineL").localPosition = Vector3(arg1_46.safeLine.x, 0, 0)
		cloneTplTo(arg0_46.safeLine, arg0_46.gameContainer, "safeLineR").localPosition = Vector3(arg1_46.safeLine.y, 0, 0)
	end
end

function var0_0.AddPileCollider(arg0_47, arg1_47)
	local var0_47 = arg0_47.items[arg1_47]
	local var1_47 = cloneTplTo(arg0_47.itemCollider, var0_47, "collider")
	local var2_47 = arg1_47.collider
	local var3_47 = (0.5 - arg1_47.pivot.x) * arg1_47.sizeDelta.x + var2_47.offset.x
	local var4_47 = (0.5 - arg1_47.pivot.y) * arg1_47.sizeDelta.y + var2_47.offset.y

	var1_47.localPosition = Vector3(var3_47, var4_47, 0)
	var1_47.sizeDelta = var2_47.sizeDelta
end

function var0_0.onBackPressed(arg0_48)
	if isActive(arg0_48.resultPanel) then
		setActive(arg0_48.resultPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_48.resultPanel, arg0_48.bg)
		arg0_48.controller:ExitGame()

		return true
	elseif isActive(arg0_48.exitPanel) then
		setActive(arg0_48.exitPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_48.exitPanel, arg0_48.bg)

		return true
	elseif isActive(arg0_48.bg) then
		arg0_48.controller:ExitGame()

		if arg0_48.timer then
			arg0_48.timer:Stop()

			arg0_48.timer = nil
		end

		return true
	end

	return false
end

function var0_0.Dispose(arg0_49)
	pg.DelegateInfo.Dispose(arg0_49)

	if arg0_49.timer then
		arg0_49.timer:Stop()

		arg0_49.timer = nil
	end

	arg0_49.bgMgr:Clear()
end

return var0_0

local var0 = class("PileGameView")

function var0.Ctor(arg0, arg1)
	arg0.controller = arg1
end

function var0.SetUI(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.bg = arg0._tf:Find("AD")
	arg0.curtainTF = arg0._tf:Find("AD/curtain")
	arg0.countDown = arg0.curtainTF:Find("Text"):GetComponent(typeof(Text))
	arg0.itemTpl = arg0._tf:Find("AD/item")
	arg0.groundTpl = arg0._tf:Find("AD/ground")
	arg0.gameContainer = arg0._tf:Find("AD/game")
	arg0.itemsContainer = arg0._tf:Find("AD/game/items")
	arg0.scoreTxt = arg0._tf:Find("AD/score_panel/Text"):GetComponent(typeof(Text))
	arg0.heats = {
		arg0._tf:Find("AD/score_panel/heart1"),
		arg0._tf:Find("AD/score_panel/heart2"),
		arg0._tf:Find("AD/score_panel/heart3")
	}
	arg0.manjuuAnim = arg0._tf:Find("AD/npc/manjuu"):GetComponent(typeof(Animator))
	arg0.anikiAnim = arg0._tf:Find("AD/npc/aniki"):GetComponent(typeof(Animator))
	arg0.manjuuPilot = arg0._tf:Find("AD/npc/manjuu_pilot")
	arg0.backBtn = arg0._tf:Find("AD/back")
	arg0.exitPanel = arg0._tf:Find("AD/exit_panel")
	arg0.exitPanelConfirmBtn = arg0.exitPanel:Find("frame/confirm")
	arg0.exitPanelCancelBtn = arg0.exitPanel:Find("frame/cancel")
	arg0.resultPanel = arg0._tf:Find("AD/result")
	arg0.endGameBtn = arg0.resultPanel:Find("frame/endGame")
	arg0.finalScoreTxt = arg0.resultPanel:Find("frame/score/Text"):GetComponent(typeof(Text))
	arg0.highestScoreText = arg0.resultPanel:Find("frame/highestscore/Text"):GetComponent(typeof(Text))
	arg0.itemIndexTF = arg0._tf:Find("AD/score_panel/index/target")
	arg0.overviewPanel = arg0._tf:Find("overview")
	arg0.startBtn = arg0._tf:Find("overview/start")
	arg0.helpBtn = arg0._tf:Find("overview/help")
	arg0.deathLine = arg0._tf:Find("death_line")
	arg0.safeLine = arg0._tf:Find("safe_line")
	arg0.itemCollider = arg0._tf:Find("item_collider")
	arg0.items = {}
	arg0.bgMgr = PileGameBgMgr.New(arg0._tf:Find("AD/bgs"))
end

function var0.OnEnterGame(arg0, arg1)
	arg0.viewData = arg1
	arg0.gameHelpTip = arg0.viewData.tip and arg0.viewData.tip or nil

	setActive(arg0.overviewPanel, true)
	setActive(arg0.bg, false)
	onButton(arg0, arg0.startBtn, function()
		arg0.controller:StartGame()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0.gameHelpTip or pg.gametip.pile_game_notice.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:ShowExitMsg()
	end, SFX_PANEL)
end

function var0.ShowExitMsg(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.exitPanel)
	setActive(arg0.exitPanel, true)

	local function var0()
		setActive(arg0.exitPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.exitPanel, arg0.bg)
	end

	onButton(arg0, arg0.exitPanelCancelBtn, var0, SFX_PANEL)
	onButton(arg0, arg0.exitPanelConfirmBtn, function()
		var0()
		arg0.controller:OnEndGame(false)
	end, SFX_PANEL)
end

function var0.DoCurtain(arg0, arg1)
	seriesAsync({
		function(arg0)
			arg0.bgMgr:Init(arg0)
		end,
		function(arg0)
			setActive(arg0.overviewPanel, false)
			setActive(arg0.bg, true)
			setActive(arg0.curtainTF, true)
			setAnchoredPosition(arg0.anikiAnim.gameObject, {
				x = -177,
				y = 158
			})

			local var0 = 4

			arg0.timer = Timer.New(function()
				var0 = var0 - 1

				if var0 == 3 then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_COUNTDOWN)
				end

				arg0.countDown.text = var0

				if var0 == 0 then
					setActive(arg0.curtainTF, false)
					arg0()
				end
			end, 1, 4)

			arg0.timer:Start()
			arg0.timer.func()
		end
	}, arg1)
end

function var0.UpdateScore(arg0, arg1, arg2)
	arg0.scoreTxt.text = arg1

	local var0 = false

	if arg1 > 0 and arg1 % PileGameConst.LEVEL_TO_HAPPY_ANIM == 0 then
		arg0.manjuuAnim:SetTrigger("happy")
		arg0.anikiAnim:SetTrigger("nice")

		var0 = true
	end

	local var1 = arg0.items[arg2]

	if var1 and var0 then
		var1:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("win")
	elseif var1 then
		var1:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("idle")
	end

	if arg2 then
		local var2 = arg2.position.x

		arg0.itemIndexTF.localPosition = Vector3(var2 / PileGameConst.RATIO, 0, 0)

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_SUCCESS)
	end
end

function var0.UpdateFailedCnt(arg0, arg1, arg2, arg3, arg4)
	for iter0, iter1 in ipairs(arg0.heats) do
		setActive(iter1, arg2 < iter0)
	end

	if arg3 then
		arg0.anikiAnim:SetTrigger("miss")
		arg0.items[arg4]:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("miss")
	end
end

function var0.AddPile(arg0, arg1, arg2, arg3)
	local function var0(arg0)
		local var0 = tf(arg0)

		SetParent(var0, arg0.itemsContainer)

		var0.sizeDelta = arg1.sizeDelta
		var0.pivot = arg1.pivot
		go(var0).name = arg1.name .. "_" .. arg1.gname
		arg0.items[arg1] = var0
		var0.eulerAngles = Vector3(0, 0, 0)

		arg0:OnItemPositionChange(arg1)
		setActive(var0, not arg2)

		if not arg2 then
			var0:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("exit")
		end

		if PileGameConst.DEBUG then
			arg0:AddPileCollider(arg1)
		end

		arg3()
	end

	PoolMgr.GetInstance():GetPrefab("Stacks/" .. arg1.gname, arg1.gname, true, var0)
end

function var0.OnStartDrop(arg0, arg1, arg2, arg3)
	if arg3 then
		arg0.manjuuAnim:SetBool("despair", PileGameController.DROP_AREA_WARN == arg2)
	else
		arg0.manjuuAnim:SetTrigger("shock")
	end

	arg0.items[arg1]:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("drop")
end

function var0.OnItemPositionChange(arg0, arg1)
	local var0 = arg0.items[arg1]

	if var0 then
		var0.localPosition = arg1.position
	end
end

function var0.OnItemPositionChangeWithAnim(arg0, arg1, arg2)
	local var0 = arg0.items[arg1]

	if var0 then
		LeanTween.moveLocalY(go(var0), arg1.position.y, PileGameConst.SINK_TIME):setOnComplete(System.Action(arg2))
	end
end

function var0.OnItemIndexPositionChange(arg0, arg1)
	local var0 = arg1.position.x
	local var1 = arg1.position.y

	arg0.prevPosition = arg0.prevPosition or arg0.manjuuPilot.localPosition.x

	local var2 = 0
	local var3 = 1

	if var0 - arg0.prevPosition <= 0 then
		var2 = var0 + 140
		var3 = -1
	else
		var2 = var0 - 140
	end

	local var4 = var1 + arg1.sizeDelta.y + arg0.manjuuPilot.rect.height / 2

	arg0.manjuuPilot.localPosition = Vector3(var2, var4, 0)
	arg0.manjuuPilot.localScale = Vector3(var3, 1, 1)
	arg0.prevPosition = var0
end

function var0.OnExceedingTheHighestScore(arg0)
	arg0.manjuuAnim:SetTrigger("satisfied")
end

function var0.DoSink(arg0, arg1, arg2)
	local var0 = getAnchoredPosition(arg0.anikiAnim.gameObject)

	LeanTween.value(arg0.anikiAnim.gameObject, var0.y, var0.y - arg1, PileGameConst.SINK_TIME):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.anikiAnim.gameObject, {
			y = arg0
		})
	end)):setOnComplete(System.Action(arg2))
	arg0.bgMgr:DoMove(arg1)
end

function var0.OnRemovePile(arg0, arg1)
	local var0 = arg0.items[arg1]

	if var0 then
		if PileGameConst.DEBUG then
			Destroy(var0:Find("collider").gameObject)
		end

		var0:Find("anim"):GetComponent(typeof(Animator)):SetTrigger("exit")

		var0.eulerAngles = Vector3(0, 0, 0)

		PoolMgr.GetInstance():ReturnPrefab("Stacks/" .. arg1.gname, arg1.gname, var0.gameObject)

		arg0.items[arg1] = nil
	end
end

function var0.PlaySpeAction(arg0, arg1)
	local var0 = arg0.items[arg1]

	if var0 then
		local var1 = arg1.speActionCount

		if var1 == 0 then
			return
		end

		local var2 = math.random(1, var1) - 1
		local var3 = var2 == 0 and "spe" or "spe" .. var2

		var0:Find("anim"):GetComponent(typeof(Animator)):SetTrigger(var3)
	end
end

function var0.OnGameStart(arg0)
	onButton(arg0, arg0.bg, function()
		arg0.controller:Drop()
	end, SFX_PANEL)
end

function var0.OnGameExited(arg0)
	setActive(arg0.overviewPanel, true)
	setActive(arg0.bg, false)

	arg0.itemsContainer.eulerAngles = Vector3(0, 0, 0)
	arg0.itemsContainer.pivot = Vector2(0.5, 0.5)

	arg0.bgMgr:Clear()

	if PileGameConst.DEBUG then
		Destroy(arg0.gameContainer:Find("ground").gameObject)
		Destroy(arg0.gameContainer:Find("deathLineR").gameObject)
		Destroy(arg0.gameContainer:Find("deathLineL").gameObject)
		Destroy(arg0.gameContainer:Find("safeLineL").gameObject)
		Destroy(arg0.gameContainer:Find("safeLineR").gameObject)
	end
end

function var0.OnGameEnd(arg0, arg1, arg2)
	(function()
		pg.UIMgr.GetInstance():BlurPanel(arg0.resultPanel)
		setActive(arg0.resultPanel, true)
		onButton(arg0, arg0.endGameBtn, function()
			setActive(arg0.resultPanel, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.resultPanel, arg0.bg)
			arg0.controller:ExitGame()
		end)

		arg0.finalScoreTxt.text = arg1
		arg0.highestScoreText.text = arg2
	end)()
end

function var0.OnShake(arg0, arg1)
	local var0 = getAnchoredPosition(arg0.anikiAnim)

	setAnchoredPosition(arg0.anikiAnim, {
		x = var0.x + arg1
	})
end

function var0.OnCollapse(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1, arg2, arg3)
		LeanTween.value(go(arg0.itemsContainer), arg0, arg1, arg2):setOnUpdate(System.Action_float(function(arg0)
			arg0.itemsContainer.eulerAngles = Vector3(0, 0, arg0)
		end)):setOnComplete(System.Action(arg3))
	end

	seriesAsync({
		function(arg0)
			arg0.manjuuAnim:SetTrigger("shock")

			local var0 = 0.5 + arg1 / arg0.itemsContainer.rect.width

			arg0.itemsContainer.pivot = Vector2(var0, 0)

			local var1 = arg2 == 1 and -35 or 35

			var0(0, var1, 0.5, function()
				arg0(var1)
			end)
		end,
		function(arg0, arg1)
			local var0 = {}
			local var1 = _.values(arg0.items)

			table.sort(var1, function(arg0, arg1)
				return arg0.localPosition.y < arg1.localPosition.y
			end)

			for iter0, iter1 in ipairs(var1) do
				table.insert(var0, function(arg0)
					local var0 = arg2 == 1 and -90 or 90

					parallelAsync({
						function(arg0)
							var0(arg1, var0, 1, arg0)
						end,
						function(arg0)
							local var0 = arg2 == 1 and -356 or 356

							LeanTween.value(go(iter1), 0, var0, 1):setOnUpdate(System.Action_float(function(arg0)
								iter1.eulerAngles = Vector3(0, 0, arg0)
							end)):setOnComplete(System.Action(arg0))
						end,
						function(arg0)
							LeanTween.moveLocalY(go(iter1), iter1.localPosition.y + 50 * iter0, 1):setOnComplete(System.Action(arg0))
						end
					}, arg0)
				end)
			end

			parallelAsync(var0, arg0)
		end
	}, arg3)
end

function var0.InitSup(arg0, arg1)
	if PileGameConst.DEBUG then
		local var0 = arg1.ground
		local var1 = cloneTplTo(arg0.groundTpl, arg0.gameContainer, "ground")

		var1.sizeDelta = var0.sizeDelta
		var1.pivot = var0.pivot
		var1.localPosition = var0.position
		cloneTplTo(arg0.deathLine, arg0.gameContainer, "deathLineR").localPosition = Vector3(arg1.deathLine.y, 0, 0)
		cloneTplTo(arg0.deathLine, arg0.gameContainer, "deathLineL").localPosition = Vector3(arg1.deathLine.x, 0, 0)
		cloneTplTo(arg0.safeLine, arg0.gameContainer, "safeLineL").localPosition = Vector3(arg1.safeLine.x, 0, 0)
		cloneTplTo(arg0.safeLine, arg0.gameContainer, "safeLineR").localPosition = Vector3(arg1.safeLine.y, 0, 0)
	end
end

function var0.AddPileCollider(arg0, arg1)
	local var0 = arg0.items[arg1]
	local var1 = cloneTplTo(arg0.itemCollider, var0, "collider")
	local var2 = arg1.collider
	local var3 = (0.5 - arg1.pivot.x) * arg1.sizeDelta.x + var2.offset.x
	local var4 = (0.5 - arg1.pivot.y) * arg1.sizeDelta.y + var2.offset.y

	var1.localPosition = Vector3(var3, var4, 0)
	var1.sizeDelta = var2.sizeDelta
end

function var0.onBackPressed(arg0)
	if isActive(arg0.resultPanel) then
		setActive(arg0.resultPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.resultPanel, arg0.bg)
		arg0.controller:ExitGame()

		return true
	elseif isActive(arg0.exitPanel) then
		setActive(arg0.exitPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.exitPanel, arg0.bg)

		return true
	elseif isActive(arg0.bg) then
		arg0.controller:ExitGame()

		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end

		return true
	end

	return false
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.bgMgr:Clear()
end

return var0

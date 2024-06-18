local var0_0 = class("QTEGameView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "QTEGameUI"
end

function var0_0.init(arg0_2)
	arg0_2.STATE_BEGIN = 1
	arg0_2.STATE_COUNT = 2
	arg0_2.STATE_CLICK = 3
	arg0_2.STATE_SHOW = 4
	arg0_2.STATE_END = 5
	arg0_2.gameState = -1
	arg0_2.typeNum = 3
	arg0_2.idNum = 3
	arg0_2.limitNum = 5
	arg0_2.TYPE_A = 1
	arg0_2.TYPE_B = 2
	arg0_2.TYPE_C = 3
	arg0_2.ITEM_ID_1 = 1
	arg0_2.ITEM_ID_2 = 2
	arg0_2.ITEM_ID_3 = 3
	arg0_2.startUI = arg0_2:findTF("start_ui")
	arg0_2.startBtn = arg0_2:findTF("start_btn", arg0_2.startUI)
	arg0_2.ruleBtn = arg0_2:findTF("rule_btn", arg0_2.startUI)
	arg0_2.qBtn = arg0_2:findTF("q_btn", arg0_2.startUI)
	arg0_2.countUI = arg0_2:findTF("count_ui")
	arg0_2.countNumTxt = arg0_2:findTF("num", arg0_2.countUI)
	arg0_2.endUI = arg0_2:findTF("end_ui")
	arg0_2.endExitBtn = arg0_2:findTF("exit_btn", arg0_2.endUI)
	arg0_2.endBestTxt = arg0_2:findTF("rope/paper/best_txt", arg0_2.endUI)
	arg0_2.endScoreTxt = arg0_2:findTF("rope/paper/score_txt", arg0_2.endUI)
	arg0_2.endComboTxt = arg0_2:findTF("rope/paper/combo_txt", arg0_2.endUI)
	arg0_2.endMissTxt = arg0_2:findTF("rope/paper/miss_txt", arg0_2.endUI)
	arg0_2.endHitTxt = arg0_2:findTF("rope/paper/hit_txt", arg0_2.endUI)
	arg0_2.endUIEvent = arg0_2:findTF("rope", arg0_2.endUI):GetComponent("DftAniEvent")
	arg0_2.content = arg0_2:findTF("content")
	arg0_2.res = arg0_2:findTF("res")
	arg0_2.gameBg = arg0_2:findTF("game_bg", arg0_2.content)
	arg0_2.xgmPos = arg0_2:findTF("xiongguimao_pos", arg0_2.content)
	arg0_2.guinuPos = arg0_2:findTF("guinu_pos", arg0_2.content)
	arg0_2.bucketA = arg0_2:findTF("content/bucket_A")
	arg0_2.bucketASpine = arg0_2.bucketA:GetComponent("SpineAnimUI")
	arg0_2.bucketAGraphic = arg0_2.bucketA:GetComponent("SkeletonGraphic")
	arg0_2.bucketB = arg0_2:findTF("content/bucket_B")
	arg0_2.bucketBSpine = arg0_2.bucketB:GetComponent("SpineAnimUI")
	arg0_2.bucketBGraphic = arg0_2.bucketB:GetComponent("SkeletonGraphic")
	arg0_2.bucketC = arg0_2:findTF("content/bucket_C")
	arg0_2.msHand = arg0_2:findTF("ani", arg0_2.bucketC)
	arg0_2.msHandAnimator = arg0_2.msHand:GetComponent("Animator")
	arg0_2.msHandSlot = arg0_2:findTF("slot", arg0_2.msHand)
	arg0_2.msHandEvent = arg0_2.msHand:GetComponent("DftAniEvent")
	arg0_2.msBlockList = {}

	arg0_2.msHandEvent:SetEndEvent(function()
		arg0_2:msClearHold()
		setActive(arg0_2.msHand, false)
	end)

	arg0_2.xgmAnimLength = {
		idle = 1,
		attack = 1
	}
	arg0_2.xgmAnimTargetLength = {
		idle = 1,
		attack = 0.5
	}
	arg0_2.guinuAnimLength = {
		action = 1.333,
		normal = 4.667
	}
	arg0_2.guinuAnimTargetLength = {
		action = 0.5,
		normal = 4.667
	}
	arg0_2.bucketAAnimLength = {
		idle = 0.167,
		attack = 0.8
	}
	arg0_2.bucketAAnimTargetLength = {
		idle = 1,
		attack = 0.6
	}
	arg0_2.bucketBAnimLength = {
		idle = 0.167,
		attack = 0.8
	}
	arg0_2.bucketBAnimTargetLength = {
		idle = 1,
		attack = 0.6
	}
	arg0_2.cut1 = arg0_2:findTF("cut_1", arg0_2.bucketB)
	arg0_2.cut2 = arg0_2:findTF("cut_2", arg0_2.bucketB)
	arg0_2.cut3 = arg0_2:findTF("cut_3", arg0_2.bucketB)
	arg0_2.cut1Animator = arg0_2.cut1:GetComponent("Animator")
	arg0_2.cut2Animator = arg0_2.cut2:GetComponent("Animator")
	arg0_2.cut3Animator = arg0_2.cut3:GetComponent("Animator")
	arg0_2.cut1Event = arg0_2.cut1:GetComponent("DftAniEvent")
	arg0_2.cut2Event = arg0_2.cut2:GetComponent("DftAniEvent")
	arg0_2.cut3Event = arg0_2.cut3:GetComponent("DftAniEvent")

	arg0_2.cut1Event:SetEndEvent(function()
		setActive(arg0_2.cut1, false)
	end)
	arg0_2.cut2Event:SetEndEvent(function()
		setActive(arg0_2.cut2, false)
	end)
	arg0_2.cut3Event:SetEndEvent(function()
		setActive(arg0_2.cut3, false)
	end)

	arg0_2.keyUI = arg0_2:findTF("key_ui", arg0_2.content)
	arg0_2.keyBar = arg0_2:findTF("key_bar", arg0_2.keyUI)
	arg0_2.aBtn = arg0_2:findTF("A_btn", arg0_2.keyUI)
	arg0_2.bBtn = arg0_2:findTF("B_btn", arg0_2.keyUI)
	arg0_2.cBtn = arg0_2:findTF("C_btn", arg0_2.keyUI)
	arg0_2.comboAni = arg0_2:findTF("combo_bar/center", arg0_2.content):GetComponent("Animator")
	arg0_2.comboTxt = arg0_2:findTF("combo_bar/center/combo_txt", arg0_2.content)
	arg0_2.comboAni.enabled = false
	arg0_2.scoreTxt = arg0_2:findTF("score_bar/txt", arg0_2.content)
	arg0_2.remainTxt = arg0_2:findTF("remain_time_bar/txt", arg0_2.content)

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2.keyBar, {
		pbList = {
			arg0_2.keyBar
		}
	})

	arg0_2.roundTxt = arg0_2:findTF("round_time_bar/txt", arg0_2.keyUI)
	arg0_2.firePos = arg0_2:findTF("content/pos/fire_pos").anchoredPosition
	arg0_2.hitPos = arg0_2:findTF("content/pos/hit_pos").anchoredPosition
	arg0_2.aPos = arg0_2:findTF("content/pos/a_pos").anchoredPosition
	arg0_2.bPos = arg0_2:findTF("content/pos/b_pos").anchoredPosition
	arg0_2.cPos = arg0_2:findTF("content/pos/c_pos").anchoredPosition
	arg0_2.missPos = arg0_2:findTF("content/pos/miss_pos").anchoredPosition
	arg0_2.backBtn = arg0_2:findTF("back_btn", arg0_2.content)
	arg0_2.autoLoader = AutoLoader.New()

	arg0_2.autoLoader:LoadSprite("ui/minigameui/qtegameuiasync_atlas", "background", arg0_2.gameBg, false)
end

function var0_0.didEnter(arg0_7)
	arg0_7:initGame()
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:setGameState(arg0_7.STATE_BEGIN)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.qBtn, function()
		arg0_7:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.ruleBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.qte_game_help.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end)
	onButton(arg0_7, arg0_7.startBtn, function()
		setButtonEnabled(arg0_7.startBtn, false)
		parallelAsync({
			function(arg0_12)
				arg0_7:loadXGM(arg0_12)
			end,
			function(arg0_13)
				arg0_7:loadGuinu(arg0_13)
			end
		}, function()
			arg0_7:setGameState(arg0_7.STATE_COUNT)
		end)
	end, SFX_PANEL)

	if QTEGAME_DEBUG then
		onButton(arg0_7, arg0_7.xgm, function()
			arg0_7:setGameState(arg0_7.STATE_SHOW)
		end)
	end

	onButton(arg0_7, arg0_7.endExitBtn, function()
		arg0_7:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	arg0_7.endUIEvent:SetEndEvent(function()
		if arg0_7:GetMGHubData().count > 0 then
			arg0_7:SendSuccess(0)
		end

		setActive(arg0_7.endExitBtn, true)
	end)

	local function var0_7(arg0_18)
		if arg0_7.gameState == arg0_7.STATE_CLICK and arg0_7.curShowBlock then
			arg0_7.curShowBlock:select(arg0_18)

			arg0_7.curShowBlock = arg0_7.curShowBlock.nextBlock

			if arg0_7.curShowBlock == nil then
				arg0_7:managedTween(LeanTween.delayedCall, function()
					arg0_7:setGameState(arg0_7.STATE_SHOW)
				end, 0.2, nil)
			end
		end
	end

	onButton(arg0_7, arg0_7.aBtn, function()
		var0_7(arg0_7.TYPE_A)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.bBtn, function()
		var0_7(arg0_7.TYPE_B)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.cBtn, function()
		var0_7(arg0_7.TYPE_C)
	end, SFX_PANEL)
	arg0_7:setGameState(arg0_7.STATE_BEGIN)
	arg0_7:checkHelp()
end

function var0_0.initGame(arg0_23)
	arg0_23.curShowBlock = nil
	arg0_23.randomBlockList = nil
	arg0_23.scorePerHit = arg0_23:GetMGData():GetSimpleValue("scorePerHit")
	arg0_23.comboRange = arg0_23:GetMGData():GetSimpleValue("comboRange")
	arg0_23.comboAddScore = arg0_23:GetMGData():GetSimpleValue("comboAddScore")
	arg0_23.targetCombo = arg0_23:GetMGData():GetSimpleValue("targetCombo")
	arg0_23.targetComboScore = arg0_23:GetMGData():GetSimpleValue("targetComboScore")
	arg0_23.usingBlockList = {}
	arg0_23.blockUniId = 0

	arg0_23:resetGame()
	arg0_23.bucketASpine:SetActionCallBack(function(arg0_24)
		if arg0_24 == "FINISH" then
			arg0_23:setBucketAAction("idle")
		end
	end)
	arg0_23.bucketBSpine:SetActionCallBack(function(arg0_25)
		if arg0_25 == "FINISH" then
			arg0_23:setBucketBAction("idle")
		end
	end)
end

function var0_0.resetGame(arg0_26)
	arg0_26:setXgmAction("idle")
	arg0_26:setGuinuAction("normal")
	arg0_26:setBucketAAction("idle")
	arg0_26:setBucketBAction("idle")
	setActive(arg0_26.msHand, false)

	arg0_26.score = 0
	arg0_26.bestComboNum = 0
	arg0_26.comboNum = 0
	arg0_26.missNum = 0
	arg0_26.hitNum = 0
	arg0_26.remainTime = arg0_26:GetMGData():GetSimpleValue("gameTime")
	arg0_26.roundTime = arg0_26:GetMGData():GetSimpleValue("roundTime")

	setText(arg0_26.comboTxt, 0)
	setText(arg0_26.scoreTxt, 0)
	setText(arg0_26.remainTxt, arg0_26.remainTime .. "S")
	setText(arg0_26.roundTxt, arg0_26.roundTime)
	arg0_26:clearTimer()
	arg0_26:hideRandomList()
	arg0_26:clearUsingBlock()
	arg0_26:cleanManagedTween()
end

function var0_0.setGameState(arg0_27, arg1_27)
	if arg1_27 == arg0_27.gameState then
		return
	end

	arg0_27.gameState = arg1_27

	local function var0_27(arg0_28)
		local var0_28 = {
			arg0_27.startUI,
			arg0_27.content,
			arg0_27.endUI,
			arg0_27.countUI,
			arg0_27.keyUI,
			arg0_27.keyBar
		}

		for iter0_28, iter1_28 in pairs(var0_28) do
			local var1_28 = table.indexof(arg0_28, iter1_28) and true

			setActive(iter1_28, var1_28)
		end

		if isActive(arg0_27.endUI) then
			pg.UIMgr.GetInstance():BlurPanel(arg0_27.endUI)
		else
			pg.UIMgr.GetInstance():UnblurPanel(arg0_27.endUI, arg0_27._tf)
		end
	end

	if arg0_27.gameState == arg0_27.STATE_BEGIN then
		setButtonEnabled(arg0_27.startBtn, true)
		var0_27({
			arg0_27.startUI
		})
		arg0_27:resetGame()
	elseif arg0_27.gameState == arg0_27.STATE_COUNT then
		var0_27({
			arg0_27.countUI,
			arg0_27.content
		})

		local var1_27 = Time.realtimeSinceStartup

		arg0_27:managedTween(LeanTween.delayedCall, function()
			arg0_27:startGameTimer()
			arg0_27:setGameState(arg0_27.STATE_CLICK)
		end, 3, nil):setOnUpdate(System.Action_float(function(arg0_30)
			setText(arg0_27.countNumTxt, math.ceil(3 - (Time.realtimeSinceStartup - var1_27)))
		end))
	elseif arg0_27.gameState == arg0_27.STATE_CLICK then
		var0_27({
			arg0_27.content,
			arg0_27.keyUI,
			arg0_27.keyBar
		})

		arg0_27.randomBlockList, arg0_27.curShowBlock, arg0_27.firstShowBlock = arg0_27:getRandomList()

		arg0_27:startRoundTimer()
	elseif arg0_27.gameState == arg0_27.STATE_SHOW then
		var0_27({
			arg0_27.content
		})
		arg0_27:hideRandomList()
		arg0_27:playArchiveAnim(arg0_27.randomBlockList, arg0_27:getUserResult())
	elseif arg0_27.gameState == arg0_27.STATE_END then
		var0_27({
			arg0_27.content,
			arg0_27.endUI
		})
		setActive(arg0_27.endExitBtn, false)

		local var2_27 = 0
		local var3_27 = arg0_27:GetMGData():GetRuntimeData("elements")

		if var3_27 and #var3_27 > 0 then
			var2_27 = var3_27[1]
		end

		if var2_27 < arg0_27.score then
			var2_27 = arg0_27.score

			arg0_27:StoreDataToServer({
				var2_27
			})
		end

		setText(arg0_27.endBestTxt, var2_27)
		setText(arg0_27.endScoreTxt, arg0_27.score)
		setText(arg0_27.endComboTxt, arg0_27.bestComboNum)
		setText(arg0_27.endMissTxt, arg0_27.missNum)
		setText(arg0_27.endHitTxt, arg0_27.hitNum)
		arg0_27:clearTimer()
	end
end

function var0_0.fireBlocks(arg0_31)
	local var0_31 = arg0_31.opIndex
	local var1_31 = arg0_31.arBlockList[var0_31].type
	local var2_31 = arg0_31.arBlockList[var0_31].id
	local var3_31 = arg0_31.opList[var0_31]
	local var4_31 = arg0_31:getBlock(var1_31, var2_31)
	local var5_31 = var4_31.tf

	arg0_31:addUsingBlock(var4_31)

	local var6_31

	if var3_31 then
		if var1_31 == arg0_31.TYPE_A then
			var6_31 = arg0_31.aPos
		elseif var1_31 == arg0_31.TYPE_B then
			var6_31 = arg0_31.bPos
		elseif var1_31 == arg0_31.TYPE_C then
			var6_31 = arg0_31.cPos
		end
	else
		var6_31 = arg0_31.missPos
	end

	var5_31.anchoredPosition = arg0_31.firePos

	arg0_31:hitFly(var5_31, 0.5, arg0_31.hitPos, function()
		var5_31.anchoredPosition = arg0_31.hitPos

		if var3_31 then
			local var0_32 = 0.4
			local var1_32 = arg0_31.parabolaMove

			if var1_31 == arg0_31.TYPE_A then
				var0_32 = 0.3
				var1_32 = arg0_31.parabolaMove_center

				arg0_31:setBucketAAction("attack")
			elseif var1_31 == arg0_31.TYPE_B then
				arg0_31:managedTween(LeanTween.delayedCall, function()
					arg0_31:setBucketBAction("attack")
				end, 0.2, nil)
			elseif var1_31 == arg0_31.TYPE_C then
				var0_32 = 0.3
				var1_32 = arg0_31.parabolaMove_center

				setActive(arg0_31.msHand, true)
				arg0_31.msHandAnimator:Play("mingshi_hand", -1, 0)
			end

			var1_32(arg0_31, var5_31, var0_32, var6_31, function()
				if var1_31 == arg0_31.TYPE_A then
					arg0_31:removeUsingBlock(var4_31)
					arg0_31:showBucketAEffect()
					pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_hitcake")
				elseif var1_31 == arg0_31.TYPE_B then
					setActive(arg0_31["cut" .. var2_31], true)
					arg0_31["cut" .. var2_31 .. "Animator"]:Play("cut_fruit", -1, 0)
					arg0_31:removeUsingBlock(var4_31)
					pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_sword")
				elseif var1_31 == arg0_31.TYPE_C then
					arg0_31:msClearHold()
					arg0_31:msHoldBlock(var4_31)
				end

				arg0_31:checkEnd(var0_31)
			end)
		else
			arg0_31:hitFly(var5_31, 0.6, var6_31, function()
				arg0_31:removeUsingBlock(var4_31)
				arg0_31:checkEnd(var0_31)
			end)
		end

		pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_hitwood")
		arg0_31:countScore(var3_31)
	end)
	arg0_31:managedTween(LeanTween.delayedCall, function()
		arg0_31:setGuinuAction("action")
	end, 0.2, nil)
end

function var0_0.getRandomList(arg0_37)
	if not arg0_37.allList then
		arg0_37.allList = {}

		for iter0_37 = 1, arg0_37.typeNum do
			for iter1_37 = 1, arg0_37.idNum do
				arg0_37.allList[#arg0_37.allList + 1] = {
					type = iter0_37,
					id = iter1_37
				}
			end
		end
	end

	local var0_37 = Clone(arg0_37.allList)
	local var1_37 = {}

	for iter2_37 = 1, arg0_37.limitNum do
		var1_37[#var1_37 + 1] = table.remove(var0_37, math.random(1, #var0_37))
	end

	local var2_37
	local var3_37
	local var4_37

	for iter3_37, iter4_37 in ipairs(var1_37) do
		local var5_37 = arg0_37:getShowBlock(iter4_37.type, iter4_37.id)

		if var2_37 then
			var2_37.nextBlock = var5_37
		end

		if iter3_37 >= arg0_37.limitNum then
			var5_37.nextBlock = nil
		end

		if iter3_37 == 1 then
			var3_37 = var5_37
			var4_37 = var5_37
		end

		var5_37:showOrHide(true)

		var2_37 = var5_37
	end

	return var1_37, var3_37, var4_37
end

function var0_0.hideRandomList(arg0_38)
	local var0_38 = arg0_38.firstShowBlock

	while var0_38 do
		var0_38:showOrHide(false)

		var0_38 = var0_38.nextBlock
	end
end

function var0_0.countScore(arg0_39, arg1_39)
	if arg1_39 then
		local var0_39

		for iter0_39, iter1_39 in ipairs(arg0_39.comboRange) do
			if iter1_39 > arg0_39.comboNum then
				var0_39 = iter0_39 - 1

				break
			elseif iter0_39 == #arg0_39.comboRange then
				var0_39 = #arg0_39.comboRange
			end
		end

		local var1_39 = arg0_39.comboAddScore[var0_39] or 0

		arg0_39.comboNum = arg0_39.comboNum + 1

		local var2_39 = table.indexof(arg0_39.targetCombo, arg0_39.comboNum)
		local var3_39 = arg0_39.targetComboScore[var2_39] or 0

		arg0_39.score = arg0_39.score + arg0_39.scorePerHit + var1_39 + var3_39
		arg0_39.hitNum = arg0_39.hitNum + 1
		arg0_39.comboAni.enabled = true

		arg0_39.comboAni:Play("combo_shake", -1, 0)
	else
		arg0_39.comboNum = 0
		arg0_39.missNum = arg0_39.missNum + 1
	end

	if arg0_39.comboNum > arg0_39.bestComboNum then
		arg0_39.bestComboNum = arg0_39.comboNum
	end

	setText(arg0_39.comboTxt, arg0_39.comboNum < 0 and 0 or arg0_39.comboNum)
	setText(arg0_39.scoreTxt, arg0_39.score)
end

function var0_0.getUserResult(arg0_40)
	local var0_40 = {}
	local var1_40 = arg0_40.firstShowBlock

	while var1_40 do
		var0_40[#var0_40 + 1] = var1_40:isRight()
		var1_40 = var1_40.nextBlock
	end

	return var0_40
end

function var0_0.playArchiveAnim(arg0_41, arg1_41, arg2_41)
	arg0_41.arBlockList = arg1_41
	arg0_41.opList = arg2_41
	arg0_41.opIndex = 1

	arg0_41:setXgmAction("attack")
end

function var0_0.checkPlayFinished(arg0_42)
	if arg0_42.opIndex >= #arg0_42.opList and arg0_42.remainTime > 0 then
		arg0_42:setGameState(arg0_42.STATE_CLICK)
	end
end

function var0_0.checkEnd(arg0_43, arg1_43)
	if arg1_43 >= #arg0_43.opList and arg0_43.remainTime <= 0 then
		arg0_43:setGameState(arg0_43.STATE_END)
	end
end

function var0_0.parabolaMove(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44)
	arg0_44:managedTween(LeanTween.rotate, nil, arg1_44, 135, arg2_44)
	arg0_44:managedTween(LeanTween.moveX, nil, arg1_44, arg3_44.x, arg2_44):setEase(LeanTweenType.linear)
	arg0_44:managedTween(LeanTween.moveY, function()
		if arg4_44 then
			arg4_44()
		end
	end, arg1_44, arg3_44.y, arg2_44):setEase(LeanTweenType.easeInQuad)
end

function var0_0.parabolaMove_center(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
	arg0_46:managedTween(LeanTween.rotate, nil, arg1_46, 135, arg2_46)
	arg0_46:managedTween(LeanTween.moveX, nil, arg1_46, arg3_46.x, arg2_46):setEase(LeanTweenType.easeOutQuad)
	arg0_46:managedTween(LeanTween.moveY, function()
		if arg4_46 then
			arg4_46()
		end
	end, arg1_46, arg3_46.y, arg2_46):setEase(LeanTweenType.linear)
end

function var0_0.hitFly(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48)
	arg0_48:managedTween(LeanTween.rotate, nil, arg1_48, 135, arg2_48)
	arg0_48:managedTween(LeanTween.moveX, nil, arg1_48, arg3_48.x, arg2_48):setEase(LeanTweenType.linear)
	arg0_48:managedTween(LeanTween.moveY, function()
		if arg4_48 then
			arg4_48()
		end
	end, arg1_48, arg3_48.y, arg2_48):setEase(LeanTweenType.easeOutQuad)
end

function var0_0.loadXGM(arg0_50, arg1_50)
	if arg0_50.xgm then
		arg1_50()
	else
		arg0_50.autoLoader:LoadPrefab("ui/minigameui/qtegameuiasync_atlas", "xiongguimao", function(arg0_51)
			arg0_50.xgm = tf(arg0_51)
			arg0_50.xgmSpine = arg0_50.xgm:GetComponent("SpineAnimUI")
			arg0_50.xgmSklGraphic = arg0_50.xgm:GetComponent("SkeletonGraphic")

			setParent(arg0_50.xgm, arg0_50.xgmPos, false)
			arg0_50:initXGM()
			arg1_50()
		end)
	end
end

function var0_0.initXGM(arg0_52)
	arg0_52.xgmSpine:SetActionCallBack(function(arg0_53)
		if arg0_53 == "FIRE" then
			arg0_52:fireBlocks()
		elseif arg0_53 == "FINISH" then
			if arg0_52.opIndex < #arg0_52.opList then
				arg0_52.opIndex = arg0_52.opIndex + 1

				arg0_52:setXgmAction("attack")
			else
				arg0_52:setXgmAction("idle")
				arg0_52:checkPlayFinished()
			end
		end
	end)
end

function var0_0.loadGuinu(arg0_54, arg1_54)
	if arg0_54.guinu then
		arg1_54()
	else
		arg0_54.autoLoader:GetSpine("guinu_2", function(arg0_55)
			arg0_54.guinu = tf(arg0_55)
			arg0_54.guinuSpine = arg0_54.guinu:GetComponent("SpineAnimUI")
			arg0_54.guinuSklGraphic = arg0_54.guinu:GetComponent("SkeletonGraphic")

			setParent(arg0_54.guinu, arg0_54.guinuPos, false)
			arg0_54:initGuinu()
			arg1_54()
		end)
	end
end

function var0_0.initGuinu(arg0_56)
	arg0_56.guinu.localScale = Vector3.one

	arg0_56:setGuinuAction("normal")
	arg0_56.guinuSpine:SetActionCallBack(function(arg0_57)
		if arg0_57 == "finish" then
			arg0_56:setGuinuAction("normal")
		end
	end)
end

function var0_0.setXgmAction(arg0_58, arg1_58)
	if not arg0_58.xgm then
		return
	end

	local var0_58 = arg0_58.xgmAnimLength[arg1_58] / arg0_58.xgmAnimTargetLength[arg1_58]

	arg0_58.xgmSklGraphic.timeScale = var0_58

	arg0_58.xgmSpine:SetAction(arg1_58, 0)
end

function var0_0.setGuinuAction(arg0_59, arg1_59)
	if not arg0_59.guinu then
		return
	end

	local var0_59 = arg0_59.guinuAnimLength[arg1_59] / arg0_59.guinuAnimTargetLength[arg1_59]

	arg0_59.guinuSklGraphic.timeScale = var0_59

	arg0_59.guinuSpine:SetAction(arg1_59, 0)
end

function var0_0.setBucketAAction(arg0_60, arg1_60)
	local var0_60 = arg0_60.bucketAAnimLength[arg1_60] / arg0_60.bucketAAnimTargetLength[arg1_60]

	arg0_60.bucketAGraphic.timeScale = var0_60

	arg0_60.bucketASpine:SetAction(arg1_60, 0)
end

function var0_0.setBucketBAction(arg0_61, arg1_61)
	local var0_61 = arg0_61.bucketBAnimLength[arg1_61] / arg0_61.bucketBAnimTargetLength[arg1_61]

	arg0_61.bucketBGraphic.timeScale = var0_61

	arg0_61.bucketBSpine:SetAction(arg1_61, 0)
end

function var0_0.showBucketAEffect(arg0_62)
	arg0_62.aEffectList = arg0_62.aEffectList or {}
	arg0_62.aEffectUsingList = arg0_62.aEffectUsingList or {}

	local function var0_62()
		local var0_63 = table.remove(arg0_62.aEffectList, #arg0_62.aEffectList)

		arg0_62.aEffectUsingList[#arg0_62.aEffectUsingList + 1] = var0_63

		setParent(var0_63, arg0_62.bucketA, false)

		var0_63.localScale = Vector3.one

		setActive(var0_63, true)
		arg0_62:managedTween(LeanTween.delayedCall, function()
			arg0_62:recycleBucketAEffect(var0_63)
		end, 2, nil)
	end

	if #arg0_62.aEffectList == 0 then
		arg0_62.autoLoader:LoadPrefab("effect/xinnianyouxi_baozha", nil, function(arg0_65)
			arg0_62.aEffectList[#arg0_62.aEffectList + 1] = tf(arg0_65)

			var0_62()
		end)
	else
		var0_62()
	end
end

function var0_0.recycleBucketAEffect(arg0_66, arg1_66)
	for iter0_66 = #arg0_66.aEffectUsingList, 1, -1 do
		if arg0_66.aEffectUsingList[iter0_66] == arg1_66 then
			setActive(arg1_66, false)

			arg0_66.aEffectList[#arg0_66.aEffectList + 1] = table.remove(arg0_66.aEffectUsingList, iter0_66)
		end
	end
end

function var0_0.getBlock(arg0_67, arg1_67, arg2_67)
	local var0_67 = arg1_67 .. "-" .. arg2_67

	if not arg0_67.blockPool then
		arg0_67.blockPool = {}
		arg0_67.blockSource = {}

		for iter0_67 = 1, 3 do
			for iter1_67 = 1, 3 do
				local var1_67 = iter0_67 .. "-" .. iter1_67
				local var2_67 = arg0_67:findTF("res/item" .. var1_67)

				arg0_67.blockPool[var1_67] = {}
				arg0_67.blockPool[var1_67][#arg0_67.blockPool[var1_67] + 1] = var2_67
				arg0_67.blockSource[var1_67] = var2_67
			end
		end
	end

	local var3_67

	if #arg0_67.blockPool[var0_67] > 0 then
		var3_67 = table.remove(arg0_67.blockPool[var0_67], #arg0_67.blockPool[var0_67])

		var3_67:SetParent(arg0_67.content, false)
	else
		var3_67 = cloneTplTo(arg0_67.blockSource[var0_67], arg0_67.content)
	end

	setActive(var3_67, true)

	arg0_67.blockUniId = arg0_67.blockUniId + 1

	return {
		uid = arg0_67.blockUniId,
		key = var0_67,
		tf = var3_67
	}
end

function var0_0.recycleBlock(arg0_68, arg1_68)
	local var0_68 = arg1_68.tf
	local var1_68 = arg0_68.blockPool[arg1_68.key]

	var1_68[#var1_68 + 1] = var0_68

	var0_68:SetParent(arg0_68.res, false)
	setActive(var0_68, false)
end

function var0_0.msHoldBlock(arg0_69, arg1_69)
	setParent(arg1_69.tf, arg0_69.msHandSlot, false)

	arg1_69.tf.localPosition = Vector2.zero
	arg0_69.msBlockList[#arg0_69.msBlockList + 1] = arg1_69
end

function var0_0.msClearHold(arg0_70)
	for iter0_70 = #arg0_70.msBlockList, 1, -1 do
		arg0_70:removeUsingBlock(table.remove(arg0_70.msBlockList, iter0_70))
	end
end

function var0_0.addUsingBlock(arg0_71, arg1_71)
	arg0_71.usingBlockList[#arg0_71.usingBlockList + 1] = arg1_71
end

function var0_0.removeUsingBlock(arg0_72, arg1_72)
	for iter0_72 = #arg0_72.usingBlockList, 1, -1 do
		if arg0_72.usingBlockList[iter0_72].uid == arg1_72.uid then
			arg0_72:recycleBlock(arg0_72.usingBlockList[iter0_72])
			table.remove(arg0_72.usingBlockList, iter0_72)
		end
	end
end

function var0_0.clearUsingBlock(arg0_73)
	for iter0_73 = #arg0_73.usingBlockList, 1, -1 do
		arg0_73:recycleBlock(arg0_73.usingBlockList[iter0_73])
		table.remove(arg0_73.usingBlockList, iter0_73)
	end
end

function var0_0.getShowBlock(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg1_74 .. "-" .. arg2_74
	local var1_74 = "item" .. var0_74

	arg0_74.showBlockDic = arg0_74.showBlockDic or {}

	local var2_74

	if arg0_74.showBlockDic[var0_74] then
		var2_74 = arg0_74.showBlockDic[var0_74]
	else
		var2_74 = {
			type = arg1_74,
			id = arg2_74,
			goName = var1_74,
			tf = arg0_74:findTF(var1_74, arg0_74.keyBar)
		}
		var2_74.wrongTag = arg0_74:findTF("wrong", var2_74.tf)
		var2_74.rightTag = arg0_74:findTF("right", var2_74.tf)
		var2_74.nextBlock = nil
		var2_74.userChoose = nil

		function var2_74.init(arg0_75)
			setActive(arg0_75.wrongTag, false)
			setActive(arg0_75.rightTag, false)

			arg0_75.userChoose = nil

			arg0_75.tf:SetAsLastSibling()
		end

		function var2_74.select(arg0_76, arg1_76)
			arg0_76.userChoose = arg1_76

			setActive(arg0_76.wrongTag, not arg0_76:isRight())
			setActive(arg0_76.rightTag, arg0_76:isRight())
		end

		function var2_74.showOrHide(arg0_77, arg1_77)
			setActive(arg0_77.tf, arg1_77)
		end

		function var2_74.isRight(arg0_78)
			return arg0_78.userChoose == arg0_78.type
		end
	end

	var2_74:init()

	return var2_74
end

function var0_0.startGameTimer(arg0_79)
	arg0_79.remainTime = arg0_79:GetMGData():GetSimpleValue("gameTime")

	setText(arg0_79.remainTxt, arg0_79.remainTime .. "S")

	local function var0_79()
		arg0_79.remainTime = arg0_79.remainTime - 1

		setText(arg0_79.remainTxt, arg0_79.remainTime .. "S")

		if arg0_79.remainTime <= 0 then
			arg0_79.remainTimer:Stop()
		end
	end

	if arg0_79.remainTimer then
		arg0_79.remainTimer:Reset(var0_79, 1, -1)
	else
		arg0_79.remainTimer = Timer.New(var0_79, 1, -1)
	end

	arg0_79.remainTimer:Start()
end

function var0_0.startRoundTimer(arg0_81)
	arg0_81.roundTime = arg0_81:GetMGData():GetSimpleValue("roundTime")

	setText(arg0_81.roundTxt, arg0_81.roundTime)

	local function var0_81()
		arg0_81.roundTime = arg0_81.roundTime - 1

		setText(arg0_81.roundTxt, arg0_81.roundTime)

		if arg0_81.roundTime <= 0 then
			arg0_81.roundTimer:Stop()

			if not QTEGAME_DEBUG then
				arg0_81:setGameState(arg0_81.STATE_SHOW)
			end
		end
	end

	if arg0_81.roundTimer then
		arg0_81.roundTimer:Reset(var0_81, 1, -1)
	else
		arg0_81.roundTimer = Timer.New(var0_81, 1, -1)
	end

	arg0_81.roundTimer:Start()
end

function var0_0.clearTimer(arg0_83)
	if arg0_83.remainTimer then
		arg0_83.remainTimer:Stop()

		arg0_83.remainTimer = nil
	end

	if arg0_83.roundTimer then
		arg0_83.roundTimer:Stop()

		arg0_83.roundTimer = nil
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_84, arg1_84)
	local var0_84 = arg1_84.argList

	if arg1_84.cmd == MiniGameOPCommand.CMD_COMPLETE and var0_84[1] == 0 then
		arg0_84:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			arg0_84:GetMGData():GetSimpleValue("shrineGameId"),
			1
		})
	end
end

function var0_0.checkHelp(arg0_85)
	if PlayerPrefs.GetInt("QTEGameGuide", 0) == 0 then
		triggerButton(arg0_85.ruleBtn)
		PlayerPrefs.SetInt("QTEGameGuide", 1)
		PlayerPrefs.Save()
	end
end

function var0_0.willExit(arg0_86)
	arg0_86:clearTimer()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_86.endUI, arg0_86._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_86.keyBar, arg0_86.content)

	arg0_86.xgm = nil
	arg0_86.xgmSpine = nil
	arg0_86.xgmSklGraphic = nil
	arg0_86.guinu = nil
	arg0_86.guinuSpine = nil
	arg0_86.guinuSklGraphic = nil

	arg0_86.autoLoader:Clear()
end

return var0_0

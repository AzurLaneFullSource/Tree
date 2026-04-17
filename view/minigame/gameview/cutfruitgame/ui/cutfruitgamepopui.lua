local var0_0 = class("CutFruitGamePopUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initCountUI()
	arg0_1:initLeavelUI()
	arg0_1:initPauseUI()
	arg0_1:initSettlementUI()
	arg0_1:initSelectUI()
end

function var0_0.initSelectUI(arg0_2)
	local function var0_2(arg0_3)
		if arg0_2.selectChar and arg0_2.selectChar == arg0_3 then
			return
		end

		if table.contains(arg0_2.selectNpc, arg0_3) then
			return
		end

		if arg0_2.selectChar and arg0_2.selectChar > 0 then
			setActive(findTF(arg0_2.selectGridList[arg0_2.selectChar], "ad/use"), false)
		end

		if arg0_3 > 0 then
			setActive(findTF(arg0_2.selectGridList[arg0_3], "ad/use"), true)
		end

		GetSpriteFromAtlasAsync(CutFruitGameConst.ui_atlas, "char_" .. arg0_3, function(arg0_4)
			setImageSprite(arg0_2.selectCharTF, arg0_4, true)
		end)

		arg0_2.selectChar = arg0_3
	end

	arg0_2.selectUI = findTF(arg0_2._tf, "pop/SelectUI")

	local var1_2 = findTF(arg0_2.selectUI, "ad/select_list/grid_tpl")

	setActive(var1_2, false)

	local var2_2 = findTF(arg0_2.selectUI, "ad/select_list")

	arg0_2.selectGridList = {}

	for iter0_2 = 1, CutFruitGameConst.character_num do
		local var3_2 = iter0_2
		local var4_2 = tf(instantiate(var1_2))

		setActive(var4_2, true)
		SetParent(var4_2, var2_2)
		onButton(arg0_2._event, var4_2, function()
			var0_2(var3_2)
		end, SFX_CONFIRM)
		GetSpriteFromAtlasAsync(CutFruitGameConst.ui_atlas, "char_grid_" .. var3_2, function(arg0_6)
			setImageSprite(findTF(var4_2, "ad/char"), arg0_6, true)
		end)
		table.insert(arg0_2.selectGridList, var4_2)
	end

	arg0_2.selectCharTF = findTF(arg0_2.selectUI, "ad/char")
	arg0_2.selectStartTF = findTF(arg0_2.selectUI, "ad/start")
	arg0_2.selectCloseTF = findTF(arg0_2.selectUI, "ad/close")

	onButton(arg0_2._event, arg0_2.selectStartTF, function()
		arg0_2._event:emit(SimpleMGEvent.READY_START, {
			char = arg0_2.selectChar,
			npc = arg0_2.selectNpc
		})
		arg0_2:PopSelectUI(false)
	end, SFX_CONFIRM)
	onButton(arg0_2._event, arg0_2.selectCloseTF, function()
		arg0_2._event:emit(SimpleMGEvent.CLOSE_GAME)
	end, SFX_CANCEL)

	local var5_2 = CutFruitGameConst.chapter_data[arg0_2._gameVo:GetGameRound()]

	arg0_2.selectChar = var5_2.char ~= 0 and var5_2.char or math.random(1, CutFruitGameConst.character_num)
	arg0_2.selectNpc = #var5_2.npc > 0 and var5_2.npc or arg0_2:GetNpcRandom(arg0_2.selectChar)

	arg0_2:updateSelectUI()
end

function var0_0.updateSelectUI(arg0_9)
	for iter0_9 = 1, #arg0_9.selectGridList do
		local var0_9 = arg0_9.selectGridList[iter0_9]
		local var1_9 = iter0_9

		if arg0_9.selectChar and arg0_9.selectChar == var1_9 then
			setActive(findTF(var0_9, "ad/use"), true)
			GetSpriteFromAtlasAsync(CutFruitGameConst.ui_atlas, "char_" .. var1_9, function(arg0_10)
				setImageSprite(arg0_9.selectCharTF, arg0_10, true)
			end)
		else
			setActive(findTF(var0_9, "ad/use"), false)
		end

		if table.contains(arg0_9.selectNpc, var1_9) then
			setActive(findTF(var0_9, "ad/npc"), true)
		else
			setActive(findTF(var0_9, "ad/npc"), false)
		end
	end
end

function var0_0.GetNpcRandom(arg0_11, arg1_11)
	local var0_11 = {}
	local var1_11 = {}

	for iter0_11 = 1, CutFruitGameConst.character_num do
		if iter0_11 ~= arg1_11 then
			table.insert(var1_11, iter0_11)
		end
	end

	for iter1_11 = 1, 2 do
		table.insert(var0_11, table.remove(var1_11, math.random(1, #var1_11)))
	end

	return var0_11
end

function var0_0.initCountUI(arg0_12)
	arg0_12.countUI = findTF(arg0_12._tf, "pop/CountUI")
	arg0_12.countAnimator = GetComponent(findTF(arg0_12.countUI, "count"), typeof(Animator))
	arg0_12.countDft = GetOrAddComponent(findTF(arg0_12.countUI, "count"), typeof(DftAniEvent))

	arg0_12.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_12.countDft:SetEndEvent(function()
		arg0_12._event:emit(SimpleMGEvent.COUNT_DOWN)
	end)
end

function var0_0.initLeavelUI(arg0_15)
	arg0_15.leaveUI = findTF(arg0_15._tf, "pop/LeaveUI")

	setActive(arg0_15.leaveUI, false)
	onButton(arg0_15._event, findTF(arg0_15.leaveUI, "ad/btnConfirm"), function()
		arg0_15:ResumeGame()
		arg0_15._event:emit(SimpleMGEvent.LEVEL_GAME, true)
	end, SFX_CANCEL)
	onButton(arg0_15._event, findTF(arg0_15.leaveUI, "ad/btnCancel"), function()
		arg0_15:ResumeGame()
		arg0_15._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initPauseUI(arg0_18)
	arg0_18.pauseUI = findTF(arg0_18._tf, "pop/pauseUI")

	setActive(arg0_18.pauseUI, false)
	onButton(arg0_18._event, findTF(arg0_18.pauseUI, "ad/btnOk"), function()
		arg0_18:ResumeGame()
		arg0_18._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	end, SFX_CANCEL)
end

function var0_0.initSettlementUI(arg0_20)
	arg0_20.settlementUI = findTF(arg0_20._tf, "pop/SettleMentUI")

	setActive(arg0_20.settlementUI, false)
	onButton(arg0_20._event, findTF(arg0_20.settlementUI, "ad/btnOver"), function()
		arg0_20:ClearUI()
		arg0_20._event:emit(SimpleMGEvent.BACK_MENU)
	end, SFX_CANCEL)
	onButton(arg0_20._event, findTF(arg0_20.settlementUI, "ad/btnAgain"), function()
		arg0_20:ClearUI()
		arg0_20._event:emit(SimpleMGEvent.BACK_MENU, {
			restart = true
		})
	end, SFX_CANCEL)
end

function var0_0.setChildVisible(arg0_23, arg1_23, arg2_23)
	for iter0_23 = 1, arg1_23.childCount do
		local var0_23 = arg1_23:GetChild(iter0_23 - 1)

		setActive(var0_23, arg2_23)
	end
end

function var0_0.PopSelectUI(arg0_24, arg1_24)
	setActive(arg0_24.selectUI, arg1_24)
end

function var0_0.PopPauseUI(arg0_25)
	if isActive(arg0_25.leaveUI) then
		setActive(arg0_25.leaveUI, false)
	end

	setActive(arg0_25.pauseUI, true)
end

function var0_0.PopCountUI(arg0_26, arg1_26)
	setActive(arg0_26.countUI, arg1_26)
end

function var0_0.PopSettlementUI(arg0_27, arg1_27)
	setActive(arg0_27.settlementUI, arg1_27)
end

function var0_0.PopLeaveUI(arg0_28)
	if isActive(arg0_28.pauseUI) then
		setActive(arg0_28.pauseUI, false)
	end

	setActive(arg0_28.leaveUI, true)
end

function var0_0.UpdateSettlementUI(arg0_29)
	local var0_29 = arg0_29._gameVo:GetStepTimeInteger()

	if arg0_29._gameVo:GetSuccess() then
		setActive(findTF(arg0_29.settlementUI, "ad/1"), true)
		setActive(findTF(arg0_29.settlementUI, "ad/2"), false)
		setActive(findTF(arg0_29.settlementUI, "ad/currentText"), true)
	else
		setActive(findTF(arg0_29.settlementUI, "ad/1"), false)
		setActive(findTF(arg0_29.settlementUI, "ad/2"), true)
		setActive(findTF(arg0_29.settlementUI, "ad/currentText"), false)
	end

	local var1_29 = findTF(arg0_29.settlementUI, "ad/currentText")

	if var0_29 < 0 then
		var0_29 = ""
	end

	setText(var1_29, var0_29)
	arg0_29._event:emit(SimpleMGEvent.SUBMIT_GAME_SUCCESS, var0_29)
end

function var0_0.BackPressed(arg0_30)
	if isActive(arg0_30.pauseUI) then
		arg0_30:ResumeGame()
		arg0_30._event:emit(SimpleMGEvent.PAUSE_GAME, false)
	elseif isActive(arg0_30.leaveUI) then
		arg0_30:ResumeGame()
		arg0_30._event:emit(SimpleMGEvent.LEVEL_GAME, false)
	elseif not isActive(arg0_30.pauseUI) and not isActive(arg0_30.pauseUI) then
		if not arg0_30._gameVo:IsSettlement() then
			arg0_30:PopPauseUI()
			arg0_30._event:emit(SimpleMGEvent.PAUSE_GAME, true)
		end
	else
		arg0_30:ResumeGame()
	end
end

function var0_0.ResumeGame(arg0_31)
	setActive(arg0_31.leaveUI, false)
	setActive(arg0_31.pauseUI, false)
end

function var0_0.UpdateGameUI(arg0_32, arg1_32)
	setText(arg0_32.scoreTf, arg1_32.scoreNum)
	setText(arg0_32.gameTimeS, math.ceil(arg1_32.gameTime))
end

function var0_0.ReadyStart(arg0_33)
	arg0_33:PopCountUI(true)
	arg0_33.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(CutFruitGameConst.SFX_COUNT_DOWN)
end

function var0_0.ClearUI(arg0_34)
	setActive(arg0_34.settlementUI, false)
	setActive(arg0_34.countUI, false)
end

return var0_0

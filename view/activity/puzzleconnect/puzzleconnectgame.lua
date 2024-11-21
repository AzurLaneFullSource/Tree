local var0_0 = class("PuzzleConnectGame")
local var1_0 = 1
local var2_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._content = findTF(arg0_1._tf, "ad/content")
	arg0_1._pop = findTF(arg0_1._tf, "ad/pop")
	arg0_1._animation = GetComponent(arg0_1._tf, typeof(Animation))
	arg0_1.cheatCount = 0

	setText(findTF(arg0_1._tf, "ad/pop/btnOver/text"), i18n("tolovegame_puzzle_pop_finish"))
	setText(findTF(arg0_1._tf, "ad/pop/btnNext/text"), i18n("tolovegame_puzzle_pop_next"))
	setText(findTF(arg0_1._tf, "ad/pop/titleDesc"), i18n("tolovegame_puzzle_pop_save"))
	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/back"), function()
		arg0_1._event:emit(PuzzleConnectLayer.OPEN_DETAIL)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/title"), function()
		if arg0_1.lockCheat then
			return
		end

		arg0_1.cheatCount = arg0_1.cheatCount + 1

		if arg0_1.cheatCount >= 5 then
			arg0_1.cheatCount = 0
			arg0_1.lockCheat = true

			if arg0_1:getState() == PuzzleConnectPlaying.game_state_connect then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tolovegame_puzzle_cheat"))
				arg0_1:openComplete(var2_0)
				arg0_1._animation:Play("anim_puzzle_playing_phase2")
			elseif arg0_1:getState() == PuzzleConnectPlaying.game_state_puzzle then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tolovegame_puzzle_cheat"))
				arg0_1:openComplete(var1_0)
				arg0_1._animation:Play("anim_puzzle_playing_phase2")
				arg0_1._event:emit(PuzzleConnectMediator.CMD_ACTIVITY, {
					index = 2,
					config_id = arg0_1._configData.id
				})
			end
		end
	end, SFX_CONFIRM)

	arg0_1.lockCheat = false

	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/home"), function()
		arg0_1._event:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/reset"), function()
		arg0_1.playingUI:reset()
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1._pop, "btnNext"), function()
		arg0_1:openPlayUI(arg0_1:getState())
		arg0_1._animation:Play("anim_puzzle_playing_phase3")

		arg0_1.lockCheat = false
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1._pop, "btnOver"), function()
		if arg0_1._configData.after_story then
			pg.NewStoryMgr.GetInstance():Play(arg0_1._configData.after_story, function()
				arg0_1._event:emit(PuzzleConnectMediator.CMD_ACTIVITY, {
					index = 3,
					config_id = arg0_1._configData.id
				})
			end)
		else
			arg0_1._event:emit(PuzzleConnectMediator.CMD_ACTIVITY, {
				index = 3,
				config_id = arg0_1._configData.id
			})
		end

		arg0_1._event:emit(PuzzleConnectLayer.OPEN_MENU)

		arg0_1.lockCheat = false
	end, SFX_CANCEL)

	arg0_1.playingUI = PuzzleConnectPlaying.New(findTF(arg0_1._tf, "ad/content/PuzzleConnectPlayingUI"))

	arg0_1.playingUI:addCallback(function()
		arg0_1:openComplete(var1_0)
		arg0_1._animation:Play("anim_puzzle_playing_phase2")
		arg0_1._event:emit(PuzzleConnectMediator.CMD_ACTIVITY, {
			index = 2,
			config_id = arg0_1._configData.id
		})
	end, function()
		arg0_1:openComplete(var2_0)
		arg0_1._animation:Play("anim_puzzle_playing_phase2")
	end)
end

function var0_0.show(arg0_11)
	setActive(arg0_11._tf, true)
end

function var0_0.setData(arg0_12, arg1_12)
	arg0_12._data = arg1_12
	arg0_12._configData = arg1_12.data
	arg0_12._index = arg1_12.index

	arg0_12:openPlayUI(arg0_12:getState())
end

function var0_0.setActivity(arg0_13, arg1_13)
	arg0_13._activity = arg1_13
end

function var0_0.getState(arg0_14)
	if arg0_14._activity then
		local var0_14 = arg0_14._activity.data2_list

		if table.contains(var0_14, arg0_14._configData.id) then
			return PuzzleConnectPlaying.game_state_connect
		else
			return PuzzleConnectPlaying.game_state_puzzle
		end
	end

	return PuzzleConnectPlaying.game_state_puzzle
end

function var0_0.openComplete(arg0_15, arg1_15)
	setActive(arg0_15._content, false)
	setActive(arg0_15._pop, true)

	if arg1_15 == var1_0 then
		setActive(findTF(arg0_15._pop, "bgConnect"), false)
		setActive(findTF(arg0_15._pop, "bgPuzzle"), true)
		setActive(findTF(arg0_15._pop, "btnNext"), true)
		setActive(findTF(arg0_15._pop, "btnOver"), false)
		setActive(findTF(arg0_15._pop, "btnOver"), false)
		setActive(findTF(arg0_15._pop, "progress/success/line_2"), true)
		setActive(findTF(arg0_15._pop, "progress/success/line_3"), false)
		setActive(findTF(arg0_15._pop, "progress/success/3"), false)
	elseif arg1_15 == var2_0 then
		setActive(findTF(arg0_15._pop, "bgConnect"), true)
		setActive(findTF(arg0_15._pop, "bgPuzzle"), false)
		setActive(findTF(arg0_15._pop, "btnNext"), false)
		setActive(findTF(arg0_15._pop, "btnOver"), true)
		setActive(findTF(arg0_15._pop, "progress/success/line_2"), true)
		setActive(findTF(arg0_15._pop, "progress/success/line_3"), true)
		setActive(findTF(arg0_15._pop, "progress/success/3"), true)
	end
end

function var0_0.openPlayUI(arg0_16, arg1_16)
	setActive(arg0_16._content, true)
	setActive(arg0_16._pop, false)
	arg0_16.playingUI:setData(PuzzleConnectConst.chapter_data[arg0_16._configData.id], arg1_16)

	arg0_16.lockCheat = false
end

function var0_0.hide(arg0_17)
	setActive(arg0_17._tf, false)

	arg0_17.lockCheat = false
end

function var0_0.dispose(arg0_18)
	return
end

return var0_0

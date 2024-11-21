local var0_0 = class("PuzzleConnectDetail")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._leftIcon1 = findTF(arg0_1._tf, "ad/leftIcon1/mask/img")
	arg0_1._leftIcon2 = findTF(arg0_1._tf, "ad/leftIcon2/mask/img")
	arg0_1._playerDesc = findTF(arg0_1._tf, "ad/playerDesc")
	arg0_1._progressTitle = findTF(arg0_1._tf, "ad/progressTitle")
	arg0_1._chatText = findTF(arg0_1._tf, "ad/chat/text")
	arg0_1._btnGo = findTF(arg0_1._tf, "ad/btnGo")
	arg0_1._btnGoText = findTF(arg0_1._tf, "ad/btnGo/text")

	onButton(arg0_1._event, arg0_1._btnGo, function()
		arg0_1._stateType = PuzzleConnectMediator.GetPuzzleActivityState(arg0_1._configData.id, arg0_1._activity)

		if arg0_1._stateType == PuzzleConnectMediator.state_collection then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL)
		elseif arg0_1._stateType == PuzzleConnectMediator.state_puzzle then
			arg0_1._event:emit(PuzzleConnectLayer.OPEN_GAME, arg0_1._data)
		elseif arg0_1._stateType == PuzzleConnectMediator.state_connection then
			arg0_1._event:emit(PuzzleConnectLayer.OPEN_GAME, arg0_1._data)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/btnClose"), function()
		arg0_1._event:emit(PuzzleConnectLayer.OPEN_MENU)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, findTF(arg0_1._tf, "bottom"), function()
		arg0_1._event:emit(PuzzleConnectLayer.OPEN_MENU)
	end, SFX_CONFIRM)

	arg0_1._timer = Timer.New(function()
		arg0_1._chatIndex = arg0_1._chatIndex + 1

		if arg0_1._chatIndex > arg0_1._chatLengh then
			arg0_1._timer:Stop()

			return
		end

		local var0_5 = utf8.sub(arg0_1._chatStr, 1, arg0_1._chatIndex)

		setText(arg0_1._chatText, var0_5)
	end, 0.1, -1)

	setText(findTF(arg0_1._tf, "ad/title/text"), i18n("tolovegame_puzzle_title_desc"))
end

function var0_0.startChat(arg0_6)
	arg0_6._chatIndex = 1

	arg0_6._timer:Start()
end

function var0_0.show(arg0_7)
	setActive(arg0_7._tf, true)
end

function var0_0.hide(arg0_8)
	arg0_8._timer:Stop()
	setActive(arg0_8._tf, false)
end

function var0_0.setData(arg0_9, arg1_9)
	arg0_9._data = arg1_9
	arg0_9._configData = arg1_9.data
	arg0_9._index = arg1_9.index
	arg0_9._chatStr = arg0_9._configData.desc_bubble
	arg0_9._chatLengh = utf8.len(arg0_9._chatStr)
	arg0_9._stepDescList = arg0_9._configData.desc_step

	arg0_9:updateUI()
	arg0_9:startChat()
end

function var0_0.setActivity(arg0_10, arg1_10)
	arg0_10._activity = arg1_10

	if not arg0_10._configData then
		return
	end

	arg0_10._stateType = PuzzleConnectMediator.GetPuzzleActivityState(arg0_10._configData.id, arg0_10._activity)

	setActive(arg0_10._btnGo, true)

	local var0_10 = arg0_10._configData.need[3]
	local var1_10 = 0

	if arg0_10._stateType == PuzzleConnectMediator.state_collection then
		setText(arg0_10._btnGoText, i18n("tolovegame_puzzle_detail_collect"))

		local var2_10 = pg.activity_tolove_jigsaw[arg0_10._configData.id].need[2]

		var0_10 = getProxy(PlayerProxy):getData():getResource(var2_10)
		var1_10 = 0
	elseif arg0_10._stateType == PuzzleConnectMediator.state_puzzle then
		setText(arg0_10._btnGoText, i18n("tolovegame_puzzle_detail_puzzle"))

		var1_10 = 2
	elseif arg0_10._stateType == PuzzleConnectMediator.state_connection then
		setText(arg0_10._btnGoText, i18n("tolovegame_puzzle_detail_connection"))

		var1_10 = 3
	elseif arg0_10._stateType == PuzzleConnectMediator.state_complete then
		setActive(arg0_10._btnGo, false)

		var1_10 = 4
	end

	for iter0_10 = 1, #arg0_10._stepDescList do
		local var3_10 = arg0_10._stepDescList[iter0_10]
		local var4_10 = findTF(arg0_10._tf, "ad/list/text_" .. iter0_10)

		setText(var4_10, arg0_10:replaceStr(var3_10, arg0_10._configData.need[3], var0_10, arg0_10._configData.need[3]))

		if iter0_10 <= var1_10 then
			GetComponent(var4_10, "RichText").color = Color.New(0.49, 0.5, 0.53, 1)
		else
			GetComponent(var4_10, "RichText").color = Color.New(0.18, 0.16, 0.18, 1)
		end

		if iter0_10 > 2 and iter0_10 > var1_10 + 1 then
			setActive(var4_10, false)
		else
			setActive(var4_10, true)
		end
	end
end

function var0_0.updateUI(arg0_11)
	LoadImageSpriteAsync("SquareIcon/" .. arg0_11._configData.portrait_up, arg0_11._leftIcon1)
	LoadImageSpriteAsync("SquareIcon/" .. arg0_11._configData.portrait_down, arg0_11._leftIcon2)

	local var0_11 = pg.ship_data_statistics[arg0_11._configData.ship_id].name

	setText(findTF(arg0_11._tf, "ad/player"), i18n("tolovegame_puzzle_ship_need", var0_11))
	setText(arg0_11._playerDesc, arg0_11._configData.desc_demand)
	setText(arg0_11._progressTitle, i18n("tolovegame_puzzle_task_need"))
	setText(arg0_11._chatText, arg0_11._configData.desc_bubble)
end

function var0_0.replaceStr(arg0_12, arg1_12, ...)
	if arg1_12 then
		for iter0_12, iter1_12 in ipairs({
			...
		}) do
			arg1_12 = string.gsub(arg1_12, "$" .. iter0_12, iter1_12)
		end

		return arg1_12
	end

	return arg1_12
end

function var0_0.dispose(arg0_13)
	if arg0_13._timer and arg0_13._timer.running then
		arg0_13._timer:Stop()

		arg0_13._timer = nil
	end
end

return var0_0

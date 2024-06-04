local var0 = class("HoloLiveLinkGameView", import("..BaseMiniGameView"))

var0.MAX_ROW = 6
var0.MAX_COLUMN = 11
var0.COUNT_DOWN = 3
var0.RESET_CD = 5
var0.GAME_STATE_BEGIN = 0
var0.GAME_STATE_GAMING = 1
var0.GAME_STATE_END = 2
var0.CARD_STATE_NORMAL = 0
var0.CARD_STATE_LINKED = 1
var0.CARD_STATE_BLANK = 2
var0.NAME_TO_INDEX = {
	Kawakaze = 7,
	shion = 5,
	aqua = 2,
	fubuki = 0,
	Purifier = 8,
	mio = 4,
	matsuri = 1,
	sora = 6,
	ayame = 3
}

function var0.getUIName(arg0)
	return "HoloLiveLinkGameUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0.miniGameData = arg0:GetMGData()
	arg0.linkGameID = arg0.miniGameData:GetRuntimeData("curLinkGameID")
	arg0.bestScoreTable = arg0.miniGameData:GetRuntimeData("elements")

	if #arg0.bestScoreTable == 0 then
		arg0.bestScoreTable = {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
		}

		arg0.miniGameData:SetRuntimeData("elements", arg0.bestScoreTable)
	end

	setText(arg0.bestTxt, arg0:FormatRecordTime(arg0.bestScoreTable[arg0.linkGameID]))
	arg0:SetState(var0.GAME_STATE_BEGIN)
end

function var0.OnSendMiniGameOPDone(arg0)
	return
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.backBtn)
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.countDown))

	for iter0 = 0, arg0.layout.childCount - 1 do
		LeanTween.cancel(go(arg0.layout:GetChild(iter0)))
	end

	if arg0.countTimer then
		arg0.countTimer:Stop()

		arg0.countTimer = nil
	end
end

function var0.initData(arg0)
	return
end

function var0.findUI(arg0)
	arg0.backBtn = arg0:findTF("ForNotchPanel/BackBtn")
	arg0.helpBtn = arg0:findTF("ForNotchPanel/HelpBtn")
	arg0.resetBtn = arg0:findTF("ResetBtn")
	arg0.timeTxt = arg0:findTF("ForNotchPanel/CurTime/Text")
	arg0.bestTxt = arg0:findTF("ForNotchPanel/BestTime/Text")
	arg0.layout = arg0:findTF("card_con/layout")
	arg0.item = arg0.layout:Find("card")
	arg0.bottom = arg0:findTF("card_con/bottom")
	arg0.line = arg0.bottom:Find("card")
	arg0.countDown = arg0:findTF("count_down")
	arg0.resource = arg0:findTF("resource")
	arg0.resultPanel = arg0:findTF("ResultPanel")
	arg0.resultPanelBG = arg0:findTF("BG", arg0.resultPanel)

	local var0 = arg0:findTF("Result", arg0.resultPanel)

	arg0.resultNewImg = arg0:findTF("NewImg", var0)
	arg0.resultTimeText = arg0:findTF("TimeText", var0)
	arg0.resultRestartBtn = arg0:findTF("RestartBtn", var0)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_lianliankan.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.resultPanelBG, function()
		arg0:showResultPanel(false)
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.resultRestartBtn, function()
		arg0:showResultPanel(false)
		arg0:SetState(var0.GAME_STATE_BEGIN)
	end, SFX_PANEL)
end

function var0.showResultPanel(arg0, arg1)
	if not arg1 then
		SetActive(arg0.resultPanel, false)

		return
	end

	setText(arg0.resultTimeText, arg0:FormatRecordTime(arg0.lastRecord))
	SetActive(arg0.resultPanel, true)
end

function var0.playStory(arg0)
	local var0 = arg0.miniGameData:GetConfigCsvLine(arg0.linkGameID).story

	if var0 == "" then
		arg0:showResultPanel(true)
	else
		local var1 = var0[1]
		local var2 = pg.NewStoryMgr.GetInstance()

		if not var2:IsPlayed(var1) then
			var2:Play(var1, function()
				arg0:showResultPanel(true)
			end)
		end
	end
end

function var0.SetState(arg0, arg1)
	if arg0.state ~= arg1 then
		arg0.state = arg1

		if arg1 == var0.GAME_STATE_BEGIN then
			arg0:GameBegin()
		elseif arg1 == var0.GAME_STATE_GAMING then
			arg0:GameLoop()
		elseif arg1 == var0.GAME_STATE_END then
			arg0:GameEnd()
		end
	end
end

function var0.GameBegin(arg0)
	arg0.cards = {}

	local var0 = arg0:setIconList()
	local var1 = 0

	while #var0 > 0 do
		local var2 = math.clamp(math.floor(math.random() * #var0 + 1), 1, #var0)
		local var3 = math.floor(var1 / (var0.MAX_COLUMN - 2)) + 1
		local var4 = var1 % (var0.MAX_COLUMN - 2) + 1

		arg0.cards[var3] = arg0.cards[var3] or {}
		arg0.cards[var3][var4] = {
			row = var3,
			column = var4,
			id = var0[var2],
			state = var0.CARD_STATE_NORMAL
		}

		table.remove(var0, var2)

		var1 = var1 + 1
	end

	for iter0 = 0, var0.MAX_ROW - 1 do
		for iter1 = 0, var0.MAX_COLUMN - 1 do
			arg0.cards[iter0] = arg0.cards[iter0] or {}
			arg0.cards[iter0][iter1] = arg0.cards[iter0][iter1] or {
				row = iter0,
				column = iter1,
				state = var0.CARD_STATE_BLANK
			}
		end
	end

	arg0.list = UIItemList.New(arg0.layout, arg0.item)

	arg0.list:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = math.floor(arg1 / var0.MAX_COLUMN)
			local var1 = arg1 % var0.MAX_COLUMN
			local var2 = arg0.cards[var0][var1]

			arg2.name = var0 .. "_" .. var1
			arg2.localScale = Vector3.one

			setActive(arg2:Find("display"), var2.state == var0.CARD_STATE_NORMAL)

			if var2.state == var0.CARD_STATE_NORMAL then
				local var3 = getImageSprite(arg0.resource:GetChild(var2.id))

				setImageSprite(arg2:Find("display/icon"), var3)
				setActive(arg2:Find("display/selected"), false)

				local var4 = GetComponent(arg2, typeof(Animator))

				var4.enabled = true

				var4:SetBool("AniSwitch", false)
			end
		end
	end)
	arg0.list:align(var0.MAX_ROW * var0.MAX_COLUMN)

	arg0.llist = UIItemList.New(arg0.bottom, arg0.line)

	arg0.llist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2:Find("lines")

			for iter0 = 0, var0.childCount - 1 do
				setActive(var0:GetChild(iter0), false)
			end
		end
	end)
	arg0.llist:align(var0.MAX_ROW * var0.MAX_COLUMN)
	setText(arg0.timeTxt, arg0:FormatRecordTime(0))
	setActive(arg0.countDown, true)

	for iter2 = 0, arg0.countDown.childCount - 1 do
		setActive(arg0.countDown:GetChild(iter2), false)
	end

	local var5 = 0
	local var6 = arg0.countDown:GetChild(var5)

	setActive(var6, true)
	setImageAlpha(var6, 0)
	LeanTween.value(go(arg0.countDown), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0 = math.min(arg0 / 0.3, 1)

		setImageAlpha(var6, arg0)
		setLocalScale(var6, {
			x = (1 - arg0) * 2 + 1,
			y = (1 - arg0) * 2 + 1
		})
	end)):setOnComplete(System.Action(function()
		setActive(var6, false)

		var5 = var5 + 1

		if var5 < arg0.countDown.childCount then
			var6 = arg0.countDown:GetChild(var5)

			setActive(var6, true)
			setImageAlpha(var6, 0)
		else
			setActive(arg0.countDown, false)
			arg0:SetState(var0.GAME_STATE_GAMING)
		end
	end)):setRepeat(4):setLoopType(LeanTweenType.punch):setOnCompleteOnRepeat(true):setEase(LeanTweenType.easeOutSine)
end

function var0.GameLoop(arg0)
	local var0 = function(arg0)
		local var0 = 0
		local var1 = 0

		for iter0 = 1, #arg0 - 1 do
			local var2 = arg0[iter0]
			local var3 = arg0[iter0 + 1]
			local var4 = var3.row - var2.row
			local var5 = var3.column - var2.column
			local var6 = arg0.bottom:GetChild(var2.row * var0.MAX_COLUMN + var2.column):Find("lines")

			for iter1 = 0, var6.childCount - 1 do
				setActive(var6:GetChild(iter1), false)
			end

			if var4 ~= 0 then
				setActive(var6:Find("y" .. var4), true)
			elseif var5 ~= 0 then
				setActive(var6:Find("x" .. var5), true)
			end
		end
	end

	local function var1(arg0)
		for iter0 = 1, #arg0 - 1 do
			local var0 = arg0[iter0]
			local var1 = var0.row * var0.MAX_COLUMN + var0.column
			local var2 = arg0.bottom:GetChild(var1):Find("lines")

			for iter1 = 0, var2.childCount - 1 do
				setActive(var2:GetChild(iter1), false)
			end
		end
	end

	local var2
	local var3
	local var4

	arg0.list:each(function(arg0, arg1)
		onButton(arg0, arg1:Find("display/icon"), function()
			local var0 = math.floor(arg0 / var0.MAX_COLUMN)
			local var1 = arg0 % var0.MAX_COLUMN
			local var2 = arg0.cards[var0][var1]

			if var2.state ~= var0.CARD_STATE_NORMAL then
				return
			elseif not var2 then
				var2 = var2
				var3 = arg1

				setActive(arg1:Find("display/selected"), true)
			elseif var4 then
				return
			elseif var2 == var2 then
				setActive(arg1:Find("display/selected"), false)

				var3 = nil
				var2 = nil
			elseif var2.id ~= var2.id then
				setActive(var3:Find("display/selected"), false)

				var3 = nil
				var2 = nil
			else
				local var3 = arg0:LinkLink(var2, var2)

				if not var3 then
					setActive(var3:Find("display/selected"), false)

					var3 = nil
					var2 = nil
				else
					var2.state = var0.CARD_STATE_LINKED
					var2.state = var0.CARD_STATE_LINKED

					setActive(arg1:Find("display/selected"), true)
					var0(var3)

					var4 = true

					local var4 = arg1
					local var5 = var3
					local var6 = GetComponent(var4, typeof(Animator))
					local var7 = GetComponent(var5, typeof(Animator))
					local var8 = GetComponent(var4, "DftAniEvent")
					local var9 = GetComponent(var5, "DftAniEvent")

					var6:SetBool("AniSwitch", true)
					var7:SetBool("AniSwitch", true)
					var9:SetEndEvent(function(arg0)
						var1(var3)

						var4 = false
						var3 = nil
						var2 = nil

						local var0 = true

						for iter0 = 0, var0.MAX_ROW - 1 do
							for iter1 = 0, var0.MAX_COLUMN - 1 do
								if arg0.cards[iter0][iter1].state == var0.CARD_STATE_NORMAL then
									var0 = false

									break
								end
							end
						end

						if var0 then
							arg0:SetState(var0.GAME_STATE_END)
						end
					end)
				end
			end
		end, SFX_PANEL)
	end)

	if IsUnityEditor and AUTO_LINKLINK then
		setActive(arg0.helpBtn, true)
		onButton(arg0, arg0.helpBtn, function()
			var2 = nil
			var3 = nil

			for iter0 = 0, var0.MAX_ROW - 1 do
				for iter1 = 0, var0.MAX_COLUMN - 1 do
					local var0 = arg0.cards[iter0][iter1]
					local var1 = var0.row * var0.MAX_COLUMN + var0.column
					local var2 = arg0.layout:GetChild(var1)

					if var0.state == var0.CARD_STATE_NORMAL then
						for iter2 = 0, var0.MAX_ROW - 1 do
							for iter3 = 0, var0.MAX_COLUMN - 1 do
								if iter0 ~= iter2 or iter1 ~= iter3 then
									local var3 = arg0.cards[iter2][iter3]
									local var4 = var3.row * var0.MAX_COLUMN + var3.column
									local var5 = arg0.layout:GetChild(var4)

									if var0.id == var3.id then
										triggerButton(var2:Find("display/icon"))
										triggerButton(var5:Find("display/icon"))

										if var4 then
											Timer.New(function()
												triggerButton(arg0.helpBtn)
											end, 0.4, 1):Start()

											return
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	end

	local var5 = 0

	onButton(arg0, arg0.resetBtn, function()
		if arg0.state ~= var0.GAME_STATE_GAMING then
			return
		elseif Time.realtimeSinceStartup - var5 < var0.RESET_CD then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_wait"))
		else
			if var2 then
				setActive(var3:Find("display/selected"), false)

				var3 = nil
				var2 = nil
			end

			local var0 = {}
			local var1 = {}

			for iter0 = 0, var0.MAX_ROW - 1 do
				for iter1 = 0, var0.MAX_COLUMN - 1 do
					local var2 = arg0.cards[iter0][iter1]

					if var2.state == var0.CARD_STATE_NORMAL then
						table.insert(var0, {
							row = iter0,
							column = iter1
						})
						table.insert(var1, var2.id)
					end
				end
			end

			local var3 = 1

			while #var1 > 0 do
				local var4 = math.clamp(math.floor(math.random() * #var1 + 1), 1, #var1)

				arg0.cards[var0[var3].row][var0[var3].column].id = var1[var4]

				table.remove(var1, var4)

				var3 = var3 + 1
			end

			arg0.list:each(function(arg0, arg1)
				local var0 = math.floor(arg0 / var0.MAX_COLUMN)
				local var1 = arg0 % var0.MAX_COLUMN
				local var2 = arg0.cards[var0][var1]

				if var2.state == var0.CARD_STATE_NORMAL then
					local var3 = getImageSprite(arg0.resource:GetChild(var2.id))

					setImageSprite(arg1:Find("display/icon"), var3)
				end
			end)

			var5 = Time.realtimeSinceStartup
		end
	end, SFX_PANEL)

	arg0.startTime = Time.realtimeSinceStartup
	arg0.countTimer = Timer.New(function()
		arg0.lastRecord = math.floor((Time.realtimeSinceStartup - arg0.startTime) * 1000)

		local var0 = math.floor(arg0.lastRecord)

		setText(arg0.timeTxt, arg0:FormatRecordTime(var0))
	end, 0.033, -1)

	arg0.countTimer:Start()
	arg0.countTimer.func()
end

function var0.GameEnd(arg0)
	arg0.countTimer:Stop()

	arg0.countTimer = nil

	if arg0.bestScoreTable[arg0.linkGameID] == 0 then
		local var0 = arg0.linkGameID == #pg.activity_event_linkgame.all and 0 or 1

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0.miniGameData:getConfig("hub_id"),
			cmd = MiniGameOPCommand.CMD_COMPLETE,
			args1 = {
				var0,
				arg0.linkGameID
			}
		})

		arg0.bestScoreTable[arg0.linkGameID] = arg0.lastRecord

		setText(arg0.bestTxt, arg0:FormatRecordTime(arg0.bestScoreTable[arg0.linkGameID]))
		SetActive(arg0.resultNewImg, true)
		arg0:StoreDataToServer(arg0.bestScoreTable)
	elseif arg0.lastRecord < arg0.bestScoreTable[arg0.linkGameID] then
		arg0.bestScoreTable[arg0.linkGameID] = arg0.lastRecord

		setText(arg0.bestTxt, arg0:FormatRecordTime(arg0.bestScoreTable[arg0.linkGameID]))
		SetActive(arg0.resultNewImg, true)
		arg0:StoreDataToServer(arg0.bestScoreTable)
		arg0:showResultPanel(true)
	else
		SetActive(arg0.resultNewImg, false)
		arg0:showResultPanel(true)
	end
end

function var0.LinkLink(arg0, arg1, arg2)
	assert(arg1.row ~= arg2.row or arg1.column ~= arg2.column)
	assert(arg1.id == arg2.id)

	local var0 = {
		row = arg1.row,
		column = arg1.column
	}
	local var1 = {
		row = arg2.row,
		column = arg2.column
	}
	local var2 = {}
	local var3 = {}

	table.insert(var2, var0)
	table.insert(var3, var0)

	for iter0 = 1, 3 do
		local var4 = arg0:IterateByOneSnap(var1, arg1.id, var2, var3)

		if var4 then
			local var5 = {
				var4
			}

			while var4 and var4.from do
				if var4.row ~= var4.from.row then
					local var6 = var4.row > var4.from.row and -1 or 1

					for iter1 = var4.row + var6, var4.from.row, var6 do
						table.insert(var5, {
							row = iter1,
							column = var4.column
						})
					end
				elseif var4.from.column ~= var4.column then
					local var7 = var4.column > var4.from.column and -1 or 1

					for iter2 = var4.column + var7, var4.from.column, var7 do
						table.insert(var5, {
							row = var4.row,
							column = iter2
						})
					end
				else
					assert(false)
				end

				var4 = var4.from
			end

			return var5
		end
	end
end

function var0.IterateByOneSnap(arg0, arg1, arg2, arg3, arg4)
	for iter0 = 1, #arg3 do
		local var0 = arg0:FindDirectLinkPoint(arg2, arg3[iter0], arg4, arg1)

		for iter1, iter2 in ipairs(var0) do
			if iter2.row == arg1.row and iter2.column == arg1.column then
				return iter2
			end

			table.insert(arg3, iter2)
		end
	end

	_.each(arg3, function(arg0)
		arg4[arg0.row .. "_" .. arg0.column] = true
	end)
end

function var0.FindDirectLinkPoint(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	for iter0 = arg2.row - 1, 0, -1 do
		local var1 = iter0 .. "_" .. arg2.column
		local var2 = arg0.cards[iter0][arg2.column]

		if var2.state == var0.CARD_STATE_NORMAL and var2.id == arg1 then
			if iter0 == arg4.row and arg2.column == arg4.column then
				table.insert(var0, {
					row = iter0,
					column = arg2.column,
					from = arg2
				})
			end

			break
		end

		if false then
			break
		end

		if var2.state == var0.CARD_STATE_NORMAL and var2.id ~= arg1 or arg3[var1] then
			break
		end

		table.insert(var0, {
			row = iter0,
			column = arg2.column,
			from = arg2
		})
	end

	for iter1 = arg2.row + 1, var0.MAX_ROW - 1 do
		local var3 = iter1 .. "_" .. arg2.column
		local var4 = arg0.cards[iter1][arg2.column]

		if var4.state == var0.CARD_STATE_NORMAL and var4.id == arg1 then
			if iter1 == arg4.row and arg2.column == arg4.column then
				table.insert(var0, {
					row = iter1,
					column = arg2.column,
					from = arg2
				})
			end

			break
		end

		if false then
			break
		end

		if var4.state == var0.CARD_STATE_NORMAL and var4.id ~= arg1 or arg3[var3] then
			break
		end

		table.insert(var0, {
			row = iter1,
			column = arg2.column,
			from = arg2
		})
	end

	for iter2 = arg2.column - 1, 0, -1 do
		local var5 = arg2.row .. "_" .. iter2
		local var6 = arg0.cards[arg2.row][iter2]

		if var6.state == var0.CARD_STATE_NORMAL and var6.id == arg1 then
			if arg2.row == arg4.row and iter2 == arg4.column then
				table.insert(var0, {
					row = arg2.row,
					column = iter2,
					from = arg2
				})
			end

			break
		end

		if false then
			break
		end

		if var6.state == var0.CARD_STATE_NORMAL and var6.id ~= arg1 or arg3[var5] then
			break
		end

		table.insert(var0, {
			row = arg2.row,
			column = iter2,
			from = arg2
		})
	end

	for iter3 = arg2.column + 1, var0.MAX_COLUMN - 1 do
		local var7 = arg2.row .. "_" .. iter3
		local var8 = arg0.cards[arg2.row][iter3]

		if var8.state == var0.CARD_STATE_NORMAL and var8.id == arg1 then
			if arg2.row == arg4.row and iter3 == arg4.column then
				table.insert(var0, {
					row = arg2.row,
					column = iter3,
					from = arg2
				})
			end

			break
		end

		if false then
			break
		end

		if var8.state == var0.CARD_STATE_NORMAL and var8.id ~= arg1 or arg3[var7] then
			break
		end

		table.insert(var0, {
			row = arg2.row,
			column = iter3,
			from = arg2
		})
	end

	return var0
end

function var0.setIconList(arg0)
	local var0 = {}
	local var1 = arg0:GetMGData()
	local var2 = var1:GetRuntimeData("curLinkGameID")

	print("当前地图ID", tostring(var2))

	local var3 = var1:GetConfigCsvLine(var2).block

	for iter0, iter1 in ipairs(var3) do
		local var4 = iter1[1]
		local var5 = iter1[2]

		if var5 % 2 ~= 0 then
			assert(false, "资源名" .. var4 .. "数量不为偶数" .. var5)
		end

		local var6 = var0.NAME_TO_INDEX[var4]

		assert(var6, "没有定义该资源名" .. var4)

		for iter2 = 1, var5 do
			table.insert(var0, var6)
		end
	end

	if #var0 ~= 36 then
		assert(false, "总数不为36")
	end

	return var0
end

function var0.FormatRecordTime(arg0, arg1)
	local var0 = math.floor(arg1 / 60000)

	var0 = var0 >= 10 and var0 or "0" .. var0

	local var1 = math.floor(arg1 % 60000 / 1000)

	var1 = var1 >= 10 and var1 or "0" .. var1

	local var2 = math.floor(arg1 % 1000 / 10)

	var2 = var2 >= 10 and var2 or "0" .. var2

	return var0 .. "'" .. var1 .. "'" .. var2
end

return var0

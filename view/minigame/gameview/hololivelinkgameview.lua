local var0_0 = class("HoloLiveLinkGameView", import("..BaseMiniGameView"))

var0_0.MAX_ROW = 6
var0_0.MAX_COLUMN = 11
var0_0.COUNT_DOWN = 3
var0_0.RESET_CD = 5
var0_0.GAME_STATE_BEGIN = 0
var0_0.GAME_STATE_GAMING = 1
var0_0.GAME_STATE_END = 2
var0_0.CARD_STATE_NORMAL = 0
var0_0.CARD_STATE_LINKED = 1
var0_0.CARD_STATE_BLANK = 2
var0_0.NAME_TO_INDEX = {
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

function var0_0.getUIName(arg0_1)
	return "HoloLiveLinkGameUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3.miniGameData = arg0_3:GetMGData()
	arg0_3.linkGameID = arg0_3.miniGameData:GetRuntimeData("curLinkGameID")
	arg0_3.bestScoreTable = arg0_3.miniGameData:GetRuntimeData("elements")

	if #arg0_3.bestScoreTable == 0 then
		arg0_3.bestScoreTable = {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
		}

		arg0_3.miniGameData:SetRuntimeData("elements", arg0_3.bestScoreTable)
	end

	setText(arg0_3.bestTxt, arg0_3:FormatRecordTime(arg0_3.bestScoreTable[arg0_3.linkGameID]))
	arg0_3:SetState(var0_0.GAME_STATE_BEGIN)
end

function var0_0.OnSendMiniGameOPDone(arg0_4)
	return
end

function var0_0.onBackPressed(arg0_5)
	triggerButton(arg0_5.backBtn)
end

function var0_0.willExit(arg0_6)
	LeanTween.cancel(go(arg0_6.countDown))

	for iter0_6 = 0, arg0_6.layout.childCount - 1 do
		LeanTween.cancel(go(arg0_6.layout:GetChild(iter0_6)))
	end

	if arg0_6.countTimer then
		arg0_6.countTimer:Stop()

		arg0_6.countTimer = nil
	end
end

function var0_0.initData(arg0_7)
	return
end

function var0_0.findUI(arg0_8)
	arg0_8.backBtn = arg0_8:findTF("ForNotchPanel/BackBtn")
	arg0_8.helpBtn = arg0_8:findTF("ForNotchPanel/HelpBtn")
	arg0_8.resetBtn = arg0_8:findTF("ResetBtn")
	arg0_8.timeTxt = arg0_8:findTF("ForNotchPanel/CurTime/Text")
	arg0_8.bestTxt = arg0_8:findTF("ForNotchPanel/BestTime/Text")
	arg0_8.layout = arg0_8:findTF("card_con/layout")
	arg0_8.item = arg0_8.layout:Find("card")
	arg0_8.bottom = arg0_8:findTF("card_con/bottom")
	arg0_8.line = arg0_8.bottom:Find("card")
	arg0_8.countDown = arg0_8:findTF("count_down")
	arg0_8.resource = arg0_8:findTF("resource")
	arg0_8.resultPanel = arg0_8:findTF("ResultPanel")
	arg0_8.resultPanelBG = arg0_8:findTF("BG", arg0_8.resultPanel)

	local var0_8 = arg0_8:findTF("Result", arg0_8.resultPanel)

	arg0_8.resultNewImg = arg0_8:findTF("NewImg", var0_8)
	arg0_8.resultTimeText = arg0_8:findTF("TimeText", var0_8)
	arg0_8.resultRestartBtn = arg0_8:findTF("RestartBtn", var0_8)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_lianliankan.tip
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.resultPanelBG, function()
		arg0_9:showResultPanel(false)
		arg0_9:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.resultRestartBtn, function()
		arg0_9:showResultPanel(false)
		arg0_9:SetState(var0_0.GAME_STATE_BEGIN)
	end, SFX_PANEL)
end

function var0_0.showResultPanel(arg0_14, arg1_14)
	if not arg1_14 then
		SetActive(arg0_14.resultPanel, false)

		return
	end

	setText(arg0_14.resultTimeText, arg0_14:FormatRecordTime(arg0_14.lastRecord))
	SetActive(arg0_14.resultPanel, true)
end

function var0_0.playStory(arg0_15)
	local var0_15 = arg0_15.miniGameData:GetConfigCsvLine(arg0_15.linkGameID).story

	if var0_15 == "" then
		arg0_15:showResultPanel(true)
	else
		local var1_15 = var0_15[1]
		local var2_15 = pg.NewStoryMgr.GetInstance()

		if not var2_15:IsPlayed(var1_15) then
			var2_15:Play(var1_15, function()
				arg0_15:showResultPanel(true)
			end)
		end
	end
end

function var0_0.SetState(arg0_17, arg1_17)
	if arg0_17.state ~= arg1_17 then
		arg0_17.state = arg1_17

		if arg1_17 == var0_0.GAME_STATE_BEGIN then
			arg0_17:GameBegin()
		elseif arg1_17 == var0_0.GAME_STATE_GAMING then
			arg0_17:GameLoop()
		elseif arg1_17 == var0_0.GAME_STATE_END then
			arg0_17:GameEnd()
		end
	end
end

function var0_0.GameBegin(arg0_18)
	arg0_18.cards = {}

	local var0_18 = arg0_18:setIconList()
	local var1_18 = 0

	while #var0_18 > 0 do
		local var2_18 = math.clamp(math.floor(math.random() * #var0_18 + 1), 1, #var0_18)
		local var3_18 = math.floor(var1_18 / (var0_0.MAX_COLUMN - 2)) + 1
		local var4_18 = var1_18 % (var0_0.MAX_COLUMN - 2) + 1

		arg0_18.cards[var3_18] = arg0_18.cards[var3_18] or {}
		arg0_18.cards[var3_18][var4_18] = {
			row = var3_18,
			column = var4_18,
			id = var0_18[var2_18],
			state = var0_0.CARD_STATE_NORMAL
		}

		table.remove(var0_18, var2_18)

		var1_18 = var1_18 + 1
	end

	for iter0_18 = 0, var0_0.MAX_ROW - 1 do
		for iter1_18 = 0, var0_0.MAX_COLUMN - 1 do
			arg0_18.cards[iter0_18] = arg0_18.cards[iter0_18] or {}
			arg0_18.cards[iter0_18][iter1_18] = arg0_18.cards[iter0_18][iter1_18] or {
				row = iter0_18,
				column = iter1_18,
				state = var0_0.CARD_STATE_BLANK
			}
		end
	end

	arg0_18.list = UIItemList.New(arg0_18.layout, arg0_18.item)

	arg0_18.list:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = math.floor(arg1_19 / var0_0.MAX_COLUMN)
			local var1_19 = arg1_19 % var0_0.MAX_COLUMN
			local var2_19 = arg0_18.cards[var0_19][var1_19]

			arg2_19.name = var0_19 .. "_" .. var1_19
			arg2_19.localScale = Vector3.one

			setActive(arg2_19:Find("display"), var2_19.state == var0_0.CARD_STATE_NORMAL)

			if var2_19.state == var0_0.CARD_STATE_NORMAL then
				local var3_19 = getImageSprite(arg0_18.resource:GetChild(var2_19.id))

				setImageSprite(arg2_19:Find("display/icon"), var3_19)
				setActive(arg2_19:Find("display/selected"), false)

				local var4_19 = GetComponent(arg2_19, typeof(Animator))

				var4_19.enabled = true

				var4_19:SetBool("AniSwitch", false)
			end
		end
	end)
	arg0_18.list:align(var0_0.MAX_ROW * var0_0.MAX_COLUMN)

	arg0_18.llist = UIItemList.New(arg0_18.bottom, arg0_18.line)

	arg0_18.llist:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = arg2_20:Find("lines")

			for iter0_20 = 0, var0_20.childCount - 1 do
				setActive(var0_20:GetChild(iter0_20), false)
			end
		end
	end)
	arg0_18.llist:align(var0_0.MAX_ROW * var0_0.MAX_COLUMN)
	setText(arg0_18.timeTxt, arg0_18:FormatRecordTime(0))
	setActive(arg0_18.countDown, true)

	for iter2_18 = 0, arg0_18.countDown.childCount - 1 do
		setActive(arg0_18.countDown:GetChild(iter2_18), false)
	end

	local var5_18 = 0
	local var6_18 = arg0_18.countDown:GetChild(var5_18)

	setActive(var6_18, true)
	setImageAlpha(var6_18, 0)
	LeanTween.value(go(arg0_18.countDown), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_21)
		arg0_21 = math.min(arg0_21 / 0.3, 1)

		setImageAlpha(var6_18, arg0_21)
		setLocalScale(var6_18, {
			x = (1 - arg0_21) * 2 + 1,
			y = (1 - arg0_21) * 2 + 1
		})
	end)):setOnComplete(System.Action(function()
		setActive(var6_18, false)

		var5_18 = var5_18 + 1

		if var5_18 < arg0_18.countDown.childCount then
			var6_18 = arg0_18.countDown:GetChild(var5_18)

			setActive(var6_18, true)
			setImageAlpha(var6_18, 0)
		else
			setActive(arg0_18.countDown, false)
			arg0_18:SetState(var0_0.GAME_STATE_GAMING)
		end
	end)):setRepeat(4):setLoopType(LeanTweenType.punch):setOnCompleteOnRepeat(true):setEase(LeanTweenType.easeOutSine)
end

function var0_0.GameLoop(arg0_23)
	local function var0_23(arg0_24)
		local var0_24 = 0
		local var1_24 = 0

		for iter0_24 = 1, #arg0_24 - 1 do
			local var2_24 = arg0_24[iter0_24]
			local var3_24 = arg0_24[iter0_24 + 1]
			local var4_24 = var3_24.row - var2_24.row
			local var5_24 = var3_24.column - var2_24.column
			local var6_24 = arg0_23.bottom:GetChild(var2_24.row * var0_0.MAX_COLUMN + var2_24.column):Find("lines")

			for iter1_24 = 0, var6_24.childCount - 1 do
				setActive(var6_24:GetChild(iter1_24), false)
			end

			if var4_24 ~= 0 then
				setActive(var6_24:Find("y" .. var4_24), true)
			elseif var5_24 ~= 0 then
				setActive(var6_24:Find("x" .. var5_24), true)
			end
		end
	end

	local function var1_23(arg0_25)
		for iter0_25 = 1, #arg0_25 - 1 do
			local var0_25 = arg0_25[iter0_25]
			local var1_25 = var0_25.row * var0_0.MAX_COLUMN + var0_25.column
			local var2_25 = arg0_23.bottom:GetChild(var1_25):Find("lines")

			for iter1_25 = 0, var2_25.childCount - 1 do
				setActive(var2_25:GetChild(iter1_25), false)
			end
		end
	end

	local var2_23
	local var3_23
	local var4_23

	arg0_23.list:each(function(arg0_26, arg1_26)
		onButton(arg0_23, arg1_26:Find("display/icon"), function()
			local var0_27 = math.floor(arg0_26 / var0_0.MAX_COLUMN)
			local var1_27 = arg0_26 % var0_0.MAX_COLUMN
			local var2_27 = arg0_23.cards[var0_27][var1_27]

			if var2_27.state ~= var0_0.CARD_STATE_NORMAL then
				return
			elseif not var2_23 then
				var2_23 = var2_27
				var3_23 = arg1_26

				setActive(arg1_26:Find("display/selected"), true)
			elseif var4_23 then
				return
			elseif var2_23 == var2_27 then
				setActive(arg1_26:Find("display/selected"), false)

				var3_23 = nil
				var2_23 = nil
			elseif var2_23.id ~= var2_27.id then
				setActive(var3_23:Find("display/selected"), false)

				var3_23 = nil
				var2_23 = nil
			else
				local var3_27 = arg0_23:LinkLink(var2_23, var2_27)

				if not var3_27 then
					setActive(var3_23:Find("display/selected"), false)

					var3_23 = nil
					var2_23 = nil
				else
					var2_27.state = var0_0.CARD_STATE_LINKED
					var2_23.state = var0_0.CARD_STATE_LINKED

					setActive(arg1_26:Find("display/selected"), true)
					var0_23(var3_27)

					var4_23 = true

					local var4_27 = arg1_26
					local var5_27 = var3_23
					local var6_27 = GetComponent(var4_27, typeof(Animator))
					local var7_27 = GetComponent(var5_27, typeof(Animator))
					local var8_27 = GetComponent(var4_27, "DftAniEvent")
					local var9_27 = GetComponent(var5_27, "DftAniEvent")

					var6_27:SetBool("AniSwitch", true)
					var7_27:SetBool("AniSwitch", true)
					var9_27:SetEndEvent(function(arg0_28)
						var1_23(var3_27)

						var4_23 = false
						var3_23 = nil
						var2_23 = nil

						local var0_28 = true

						for iter0_28 = 0, var0_0.MAX_ROW - 1 do
							for iter1_28 = 0, var0_0.MAX_COLUMN - 1 do
								if arg0_23.cards[iter0_28][iter1_28].state == var0_0.CARD_STATE_NORMAL then
									var0_28 = false

									break
								end
							end
						end

						if var0_28 then
							arg0_23:SetState(var0_0.GAME_STATE_END)
						end
					end)
				end
			end
		end, SFX_PANEL)
	end)

	if IsUnityEditor and AUTO_LINKLINK then
		setActive(arg0_23.helpBtn, true)
		onButton(arg0_23, arg0_23.helpBtn, function()
			var2_23 = nil
			var3_23 = nil

			for iter0_29 = 0, var0_0.MAX_ROW - 1 do
				for iter1_29 = 0, var0_0.MAX_COLUMN - 1 do
					local var0_29 = arg0_23.cards[iter0_29][iter1_29]
					local var1_29 = var0_29.row * var0_0.MAX_COLUMN + var0_29.column
					local var2_29 = arg0_23.layout:GetChild(var1_29)

					if var0_29.state == var0_0.CARD_STATE_NORMAL then
						for iter2_29 = 0, var0_0.MAX_ROW - 1 do
							for iter3_29 = 0, var0_0.MAX_COLUMN - 1 do
								if iter0_29 ~= iter2_29 or iter1_29 ~= iter3_29 then
									local var3_29 = arg0_23.cards[iter2_29][iter3_29]
									local var4_29 = var3_29.row * var0_0.MAX_COLUMN + var3_29.column
									local var5_29 = arg0_23.layout:GetChild(var4_29)

									if var0_29.id == var3_29.id then
										triggerButton(var2_29:Find("display/icon"))
										triggerButton(var5_29:Find("display/icon"))

										if var4_23 then
											Timer.New(function()
												triggerButton(arg0_23.helpBtn)
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

	local var5_23 = 0

	onButton(arg0_23, arg0_23.resetBtn, function()
		if arg0_23.state ~= var0_0.GAME_STATE_GAMING then
			return
		elseif Time.realtimeSinceStartup - var5_23 < var0_0.RESET_CD then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_wait"))
		else
			if var2_23 then
				setActive(var3_23:Find("display/selected"), false)

				var3_23 = nil
				var2_23 = nil
			end

			local var0_31 = {}
			local var1_31 = {}

			for iter0_31 = 0, var0_0.MAX_ROW - 1 do
				for iter1_31 = 0, var0_0.MAX_COLUMN - 1 do
					local var2_31 = arg0_23.cards[iter0_31][iter1_31]

					if var2_31.state == var0_0.CARD_STATE_NORMAL then
						table.insert(var0_31, {
							row = iter0_31,
							column = iter1_31
						})
						table.insert(var1_31, var2_31.id)
					end
				end
			end

			local var3_31 = 1

			while #var1_31 > 0 do
				local var4_31 = math.clamp(math.floor(math.random() * #var1_31 + 1), 1, #var1_31)

				arg0_23.cards[var0_31[var3_31].row][var0_31[var3_31].column].id = var1_31[var4_31]

				table.remove(var1_31, var4_31)

				var3_31 = var3_31 + 1
			end

			arg0_23.list:each(function(arg0_32, arg1_32)
				local var0_32 = math.floor(arg0_32 / var0_0.MAX_COLUMN)
				local var1_32 = arg0_32 % var0_0.MAX_COLUMN
				local var2_32 = arg0_23.cards[var0_32][var1_32]

				if var2_32.state == var0_0.CARD_STATE_NORMAL then
					local var3_32 = getImageSprite(arg0_23.resource:GetChild(var2_32.id))

					setImageSprite(arg1_32:Find("display/icon"), var3_32)
				end
			end)

			var5_23 = Time.realtimeSinceStartup
		end
	end, SFX_PANEL)

	arg0_23.startTime = Time.realtimeSinceStartup
	arg0_23.countTimer = Timer.New(function()
		arg0_23.lastRecord = math.floor((Time.realtimeSinceStartup - arg0_23.startTime) * 1000)

		local var0_33 = math.floor(arg0_23.lastRecord)

		setText(arg0_23.timeTxt, arg0_23:FormatRecordTime(var0_33))
	end, 0.033, -1)

	arg0_23.countTimer:Start()
	arg0_23.countTimer.func()
end

function var0_0.GameEnd(arg0_34)
	arg0_34.countTimer:Stop()

	arg0_34.countTimer = nil

	if arg0_34.bestScoreTable[arg0_34.linkGameID] == 0 then
		local var0_34 = arg0_34.linkGameID == #pg.activity_event_linkgame.all and 0 or 1

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_34.miniGameData:getConfig("hub_id"),
			cmd = MiniGameOPCommand.CMD_COMPLETE,
			args1 = {
				var0_34,
				arg0_34.linkGameID
			}
		})

		arg0_34.bestScoreTable[arg0_34.linkGameID] = arg0_34.lastRecord

		setText(arg0_34.bestTxt, arg0_34:FormatRecordTime(arg0_34.bestScoreTable[arg0_34.linkGameID]))
		SetActive(arg0_34.resultNewImg, true)
		arg0_34:StoreDataToServer(arg0_34.bestScoreTable)
	elseif arg0_34.lastRecord < arg0_34.bestScoreTable[arg0_34.linkGameID] then
		arg0_34.bestScoreTable[arg0_34.linkGameID] = arg0_34.lastRecord

		setText(arg0_34.bestTxt, arg0_34:FormatRecordTime(arg0_34.bestScoreTable[arg0_34.linkGameID]))
		SetActive(arg0_34.resultNewImg, true)
		arg0_34:StoreDataToServer(arg0_34.bestScoreTable)
		arg0_34:showResultPanel(true)
	else
		SetActive(arg0_34.resultNewImg, false)
		arg0_34:showResultPanel(true)
	end
end

function var0_0.LinkLink(arg0_35, arg1_35, arg2_35)
	assert(arg1_35.row ~= arg2_35.row or arg1_35.column ~= arg2_35.column)
	assert(arg1_35.id == arg2_35.id)

	local var0_35 = {
		row = arg1_35.row,
		column = arg1_35.column
	}
	local var1_35 = {
		row = arg2_35.row,
		column = arg2_35.column
	}
	local var2_35 = {}
	local var3_35 = {}

	table.insert(var2_35, var0_35)
	table.insert(var3_35, var0_35)

	for iter0_35 = 1, 3 do
		local var4_35 = arg0_35:IterateByOneSnap(var1_35, arg1_35.id, var2_35, var3_35)

		if var4_35 then
			local var5_35 = {
				var4_35
			}

			while var4_35 and var4_35.from do
				if var4_35.row ~= var4_35.from.row then
					local var6_35 = var4_35.row > var4_35.from.row and -1 or 1

					for iter1_35 = var4_35.row + var6_35, var4_35.from.row, var6_35 do
						table.insert(var5_35, {
							row = iter1_35,
							column = var4_35.column
						})
					end
				elseif var4_35.from.column ~= var4_35.column then
					local var7_35 = var4_35.column > var4_35.from.column and -1 or 1

					for iter2_35 = var4_35.column + var7_35, var4_35.from.column, var7_35 do
						table.insert(var5_35, {
							row = var4_35.row,
							column = iter2_35
						})
					end
				else
					assert(false)
				end

				var4_35 = var4_35.from
			end

			return var5_35
		end
	end
end

function var0_0.IterateByOneSnap(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	for iter0_36 = 1, #arg3_36 do
		local var0_36 = arg0_36:FindDirectLinkPoint(arg2_36, arg3_36[iter0_36], arg4_36, arg1_36)

		for iter1_36, iter2_36 in ipairs(var0_36) do
			if iter2_36.row == arg1_36.row and iter2_36.column == arg1_36.column then
				return iter2_36
			end

			table.insert(arg3_36, iter2_36)
		end
	end

	_.each(arg3_36, function(arg0_37)
		arg4_36[arg0_37.row .. "_" .. arg0_37.column] = true
	end)
end

function var0_0.FindDirectLinkPoint(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = {}

	for iter0_38 = arg2_38.row - 1, 0, -1 do
		local var1_38 = iter0_38 .. "_" .. arg2_38.column
		local var2_38 = arg0_38.cards[iter0_38][arg2_38.column]

		if var2_38.state == var0_0.CARD_STATE_NORMAL and var2_38.id == arg1_38 then
			if iter0_38 == arg4_38.row and arg2_38.column == arg4_38.column then
				table.insert(var0_38, {
					row = iter0_38,
					column = arg2_38.column,
					from = arg2_38
				})
			end

			break
		end

		if false then
			break
		end

		if var2_38.state == var0_0.CARD_STATE_NORMAL and var2_38.id ~= arg1_38 or arg3_38[var1_38] then
			break
		end

		table.insert(var0_38, {
			row = iter0_38,
			column = arg2_38.column,
			from = arg2_38
		})
	end

	for iter1_38 = arg2_38.row + 1, var0_0.MAX_ROW - 1 do
		local var3_38 = iter1_38 .. "_" .. arg2_38.column
		local var4_38 = arg0_38.cards[iter1_38][arg2_38.column]

		if var4_38.state == var0_0.CARD_STATE_NORMAL and var4_38.id == arg1_38 then
			if iter1_38 == arg4_38.row and arg2_38.column == arg4_38.column then
				table.insert(var0_38, {
					row = iter1_38,
					column = arg2_38.column,
					from = arg2_38
				})
			end

			break
		end

		if false then
			break
		end

		if var4_38.state == var0_0.CARD_STATE_NORMAL and var4_38.id ~= arg1_38 or arg3_38[var3_38] then
			break
		end

		table.insert(var0_38, {
			row = iter1_38,
			column = arg2_38.column,
			from = arg2_38
		})
	end

	for iter2_38 = arg2_38.column - 1, 0, -1 do
		local var5_38 = arg2_38.row .. "_" .. iter2_38
		local var6_38 = arg0_38.cards[arg2_38.row][iter2_38]

		if var6_38.state == var0_0.CARD_STATE_NORMAL and var6_38.id == arg1_38 then
			if arg2_38.row == arg4_38.row and iter2_38 == arg4_38.column then
				table.insert(var0_38, {
					row = arg2_38.row,
					column = iter2_38,
					from = arg2_38
				})
			end

			break
		end

		if false then
			break
		end

		if var6_38.state == var0_0.CARD_STATE_NORMAL and var6_38.id ~= arg1_38 or arg3_38[var5_38] then
			break
		end

		table.insert(var0_38, {
			row = arg2_38.row,
			column = iter2_38,
			from = arg2_38
		})
	end

	for iter3_38 = arg2_38.column + 1, var0_0.MAX_COLUMN - 1 do
		local var7_38 = arg2_38.row .. "_" .. iter3_38
		local var8_38 = arg0_38.cards[arg2_38.row][iter3_38]

		if var8_38.state == var0_0.CARD_STATE_NORMAL and var8_38.id == arg1_38 then
			if arg2_38.row == arg4_38.row and iter3_38 == arg4_38.column then
				table.insert(var0_38, {
					row = arg2_38.row,
					column = iter3_38,
					from = arg2_38
				})
			end

			break
		end

		if false then
			break
		end

		if var8_38.state == var0_0.CARD_STATE_NORMAL and var8_38.id ~= arg1_38 or arg3_38[var7_38] then
			break
		end

		table.insert(var0_38, {
			row = arg2_38.row,
			column = iter3_38,
			from = arg2_38
		})
	end

	return var0_38
end

function var0_0.setIconList(arg0_39)
	local var0_39 = {}
	local var1_39 = arg0_39:GetMGData()
	local var2_39 = var1_39:GetRuntimeData("curLinkGameID")

	print("当前地图ID", tostring(var2_39))

	local var3_39 = var1_39:GetConfigCsvLine(var2_39).block

	for iter0_39, iter1_39 in ipairs(var3_39) do
		local var4_39 = iter1_39[1]
		local var5_39 = iter1_39[2]

		if var5_39 % 2 ~= 0 then
			assert(false, "资源名" .. var4_39 .. "数量不为偶数" .. var5_39)
		end

		local var6_39 = var0_0.NAME_TO_INDEX[var4_39]

		assert(var6_39, "没有定义该资源名" .. var4_39)

		for iter2_39 = 1, var5_39 do
			table.insert(var0_39, var6_39)
		end
	end

	if #var0_39 ~= 36 then
		assert(false, "总数不为36")
	end

	return var0_39
end

function var0_0.FormatRecordTime(arg0_40, arg1_40)
	local var0_40 = math.floor(arg1_40 / 60000)

	var0_40 = var0_40 >= 10 and var0_40 or "0" .. var0_40

	local var1_40 = math.floor(arg1_40 % 60000 / 1000)

	var1_40 = var1_40 >= 10 and var1_40 or "0" .. var1_40

	local var2_40 = math.floor(arg1_40 % 1000 / 10)

	var2_40 = var2_40 >= 10 and var2_40 or "0" .. var2_40

	return var0_40 .. "'" .. var1_40 .. "'" .. var2_40
end

return var0_0

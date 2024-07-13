local var0_0 = class("LinkLinkScene", import("..base.BaseUI"))

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

function var0_0.getUIName(arg0_1)
	return "LinkLinkUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("BackBtn")
	arg0_2.helpBtn = arg0_2:findTF("top/help_btn")
	arg0_2.resetBtn = arg0_2:findTF("info/reset_button")
	arg0_2.awardTxt = arg0_2:findTF("info/award_txt")
	arg0_2.timeTxt = arg0_2:findTF("info/time_txt")
	arg0_2.bestTxt = arg0_2:findTF("info/best_txt")
	arg0_2.layout = arg0_2:findTF("card_con/layout")
	arg0_2.item = arg0_2.layout:Find("card")
	arg0_2.bottom = arg0_2:findTF("card_con/bottom")
	arg0_2.line = arg0_2.bottom:Find("card")
	arg0_2.result = arg0_2:findTF("result")
	arg0_2.countDown = arg0_2:findTF("count_down")
	arg0_2.resource = arg0_2:findTF("resource")
	arg0_2.bestTitleText = arg0_2:findTF("info/BestTitle")
	arg0_2.curTitleText = arg0_2:findTF("info/CurTitle")

	setText(arg0_2.bestTitleText, i18n("LinkLinkGame_BestTime"))
	setText(arg0_2.curTitleText, i18n("LinkLinkGame_CurTime"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	arg0_3:SetState(var0_0.GAME_STATE_BEGIN)
end

function var0_0.willExit(arg0_5)
	arg0_5:HideResult()
	LeanTween.cancel(go(arg0_5.countDown))

	for iter0_5 = 0, arg0_5.layout.childCount - 1 do
		LeanTween.cancel(go(arg0_5.layout:GetChild(iter0_5)))
	end

	if arg0_5.countTimer then
		arg0_5.countTimer:Stop()

		arg0_5.countTimer = nil
	end
end

function var0_0.SetPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6
end

function var0_0.SetActivity(arg0_7, arg1_7)
	arg0_7.activity = arg1_7
	arg0_7.activityAchieved = arg1_7.data1
	arg0_7.activityProgress = arg1_7.data2
	arg0_7.activityStartTime = arg1_7.data3
	arg0_7.activityBestRecord = arg1_7.data4

	local var0_7 = arg0_7.activity:getConfig("config_client")[3]
	local var1_7 = pg.TimeMgr.GetInstance()

	arg0_7.activityRestTimes = var1_7:DiffDay(arg0_7.activityStartTime, var1_7:GetServerTime()) + 1 - arg0_7.activityProgress
	arg0_7.activityRestTimes = math.clamp(arg0_7.activityRestTimes, 0, #var0_7 - arg0_7.activityProgress)

	setText(arg0_7.awardTxt, arg0_7.activityRestTimes > 0 and var0_7[arg0_7.activityProgress + 1] or 0)
	setText(arg0_7.bestTxt, arg0_7:FormatRecordTime(arg0_7.activityBestRecord))
end

function var0_0.SetState(arg0_8, arg1_8)
	if arg0_8.state ~= arg1_8 then
		arg0_8.state = arg1_8

		if arg1_8 == var0_0.GAME_STATE_BEGIN then
			arg0_8:GameBegin()
		elseif arg1_8 == var0_0.GAME_STATE_GAMING then
			arg0_8:GameLoop()
		elseif arg1_8 == var0_0.GAME_STATE_END then
			arg0_8:GameEnd()
		end
	end
end

function var0_0.GameBegin(arg0_9)
	arg0_9.cards = {}

	local var0_9 = {}

	for iter0_9 = 0, 17 do
		table.insert(var0_9, iter0_9)
		table.insert(var0_9, iter0_9)
	end

	local var1_9 = 0

	while #var0_9 > 0 do
		local var2_9 = math.clamp(math.floor(math.random() * #var0_9 + 1), 1, #var0_9)
		local var3_9 = math.floor(var1_9 / (var0_0.MAX_COLUMN - 2)) + 1
		local var4_9 = var1_9 % (var0_0.MAX_COLUMN - 2) + 1

		arg0_9.cards[var3_9] = arg0_9.cards[var3_9] or {}
		arg0_9.cards[var3_9][var4_9] = {
			row = var3_9,
			column = var4_9,
			id = var0_9[var2_9],
			state = var0_0.CARD_STATE_NORMAL
		}

		table.remove(var0_9, var2_9)

		var1_9 = var1_9 + 1
	end

	for iter1_9 = 0, var0_0.MAX_ROW - 1 do
		for iter2_9 = 0, var0_0.MAX_COLUMN - 1 do
			arg0_9.cards[iter1_9] = arg0_9.cards[iter1_9] or {}
			arg0_9.cards[iter1_9][iter2_9] = arg0_9.cards[iter1_9][iter2_9] or {
				row = iter1_9,
				column = iter2_9,
				state = var0_0.CARD_STATE_BLANK
			}
		end
	end

	arg0_9.list = UIItemList.New(arg0_9.layout, arg0_9.item)

	arg0_9.list:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = math.floor(arg1_10 / var0_0.MAX_COLUMN)
			local var1_10 = arg1_10 % var0_0.MAX_COLUMN
			local var2_10 = arg0_9.cards[var0_10][var1_10]

			arg2_10.name = var0_10 .. "_" .. var1_10
			arg2_10.localScale = Vector3.one

			setActive(arg2_10:Find("display"), var2_10.state == var0_0.CARD_STATE_NORMAL)

			if var2_10.state == var0_0.CARD_STATE_NORMAL then
				local var3_10 = getImageSprite(arg0_9.resource:GetChild(var2_10.id))

				setImageSprite(arg2_10:Find("display/icon"), var3_10)
				setActive(arg2_10:Find("display/selected"), false)
			end
		end
	end)
	arg0_9.list:align(var0_0.MAX_ROW * var0_0.MAX_COLUMN)

	arg0_9.llist = UIItemList.New(arg0_9.bottom, arg0_9.line)

	arg0_9.llist:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg2_11:Find("lines")

			for iter0_11 = 0, var0_11.childCount - 1 do
				setActive(var0_11:GetChild(iter0_11), false)
			end
		end
	end)
	arg0_9.llist:align(var0_0.MAX_ROW * var0_0.MAX_COLUMN)
	setActive(arg0_9.countDown, true)

	for iter3_9 = 0, arg0_9.countDown.childCount - 1 do
		setActive(arg0_9.countDown:GetChild(iter3_9), false)
	end

	local var5_9 = 0
	local var6_9 = arg0_9.countDown:GetChild(var5_9)

	setActive(var6_9, true)
	setImageAlpha(var6_9, 0)
	LeanTween.value(go(arg0_9.countDown), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_12)
		arg0_12 = math.min(arg0_12 / 0.3, 1)

		setImageAlpha(var6_9, arg0_12)
		setLocalScale(var6_9, {
			x = (1 - arg0_12) * 2 + 1,
			y = (1 - arg0_12) * 2 + 1
		})
	end)):setOnComplete(System.Action(function()
		setActive(var6_9, false)

		var5_9 = var5_9 + 1

		if var5_9 < arg0_9.countDown.childCount then
			var6_9 = arg0_9.countDown:GetChild(var5_9)

			setActive(var6_9, true)
			setImageAlpha(var6_9, 0)
		else
			setActive(arg0_9.countDown, false)
			arg0_9:SetState(var0_0.GAME_STATE_GAMING)
		end
	end)):setRepeat(4):setLoopType(LeanTweenType.punch):setOnCompleteOnRepeat(true):setEase(LeanTweenType.easeOutSine)
end

function var0_0.GameLoop(arg0_14)
	local function var0_14(arg0_15)
		local var0_15 = 0
		local var1_15 = 0

		for iter0_15 = 1, #arg0_15 - 1 do
			local var2_15 = arg0_15[iter0_15]
			local var3_15 = arg0_15[iter0_15 + 1]
			local var4_15 = var3_15.row - var2_15.row
			local var5_15 = var3_15.column - var2_15.column
			local var6_15 = arg0_14.bottom:GetChild(var2_15.row * var0_0.MAX_COLUMN + var2_15.column):Find("lines")

			for iter1_15 = 0, var6_15.childCount - 1 do
				setActive(var6_15:GetChild(iter1_15), false)
			end

			if var4_15 ~= 0 then
				setActive(var6_15:Find("y" .. var4_15), true)
			elseif var5_15 ~= 0 then
				setActive(var6_15:Find("x" .. var5_15), true)
			end

			if var4_15 ~= var0_15 and var5_15 ~= var1_15 then
				local var7_15 = 0
				local var8_15 = (var4_15 == -1 and var1_15 == 1 or var0_15 == 1 and var5_15 == -1) and 0 or (var5_15 == -1 and var0_15 == -1 or var4_15 == 1 and var1_15 == 1) and 90 or (var4_15 == 1 and var1_15 == -1 or var0_15 == -1 and var5_15 == 1) and 180 or 270
				local var9_15 = var6_15:Find("joint")

				setActive(var9_15, true)

				var9_15.localEulerAngles = Vector3(0, 0, var8_15)
			elseif var0_15 == 0 and var4_15 ~= 0 or var0_15 ~= 0 and var4_15 == var0_15 then
				local var10_15 = var6_15:Find("cross")

				setActive(var10_15, true)

				var10_15.localEulerAngles = Vector3(0, 0, 90)
			elseif var1_15 == 0 and var5_15 ~= 0 or var1_15 ~= 0 and var5_15 == var1_15 then
				local var11_15 = var6_15:Find("cross")

				setActive(var11_15, true)

				var11_15.localEulerAngles = Vector3(0, 0, 0)
			end

			var0_15, var1_15 = var4_15, var5_15
		end
	end

	local function var1_14(arg0_16)
		for iter0_16 = 1, #arg0_16 - 1 do
			local var0_16 = arg0_16[iter0_16]
			local var1_16 = var0_16.row * var0_0.MAX_COLUMN + var0_16.column
			local var2_16 = arg0_14.bottom:GetChild(var1_16):Find("lines")

			for iter1_16 = 0, var2_16.childCount - 1 do
				setActive(var2_16:GetChild(iter1_16), false)
			end
		end
	end

	local var2_14
	local var3_14
	local var4_14

	arg0_14.list:each(function(arg0_17, arg1_17)
		onButton(arg0_14, arg1_17:Find("display/icon"), function()
			local var0_18 = math.floor(arg0_17 / var0_0.MAX_COLUMN)
			local var1_18 = arg0_17 % var0_0.MAX_COLUMN
			local var2_18 = arg0_14.cards[var0_18][var1_18]

			if var2_18.state ~= var0_0.CARD_STATE_NORMAL then
				return
			elseif not var2_14 then
				var2_14 = var2_18
				var3_14 = arg1_17

				setActive(arg1_17:Find("display/selected"), true)
			elseif var4_14 then
				return
			elseif var2_14 == var2_18 then
				setActive(arg1_17:Find("display/selected"), false)

				var3_14 = nil
				var2_14 = nil
			elseif var2_14.id ~= var2_18.id then
				setActive(var3_14:Find("display/selected"), false)

				var3_14 = nil
				var2_14 = nil
			else
				local var3_18 = arg0_14:LinkLink(var2_14, var2_18)

				if not var3_18 then
					setActive(var3_14:Find("display/selected"), false)

					var3_14 = nil
					var2_14 = nil
				else
					var2_18.state = var0_0.CARD_STATE_LINKED
					var2_14.state = var0_0.CARD_STATE_LINKED

					setActive(arg1_17:Find("display/selected"), true)
					var0_14(var3_18)

					var4_14 = true

					local var4_18 = arg1_17
					local var5_18 = var3_14

					LeanTween.value(go(var4_18), 1, 0.15, 0.3):setEase(LeanTweenType.easeInBack):setOnUpdate(System.Action_float(function(arg0_19)
						var4_18.localScale = Vector3(arg0_19, arg0_19, 1)
						var5_18.localScale = Vector3(arg0_19, arg0_19, 1)
					end)):setOnComplete(System.Action(function()
						var1_14(var3_18)
						setActive(var4_18:Find("display"), false)
						setActive(var5_18:Find("display"), false)

						var4_14 = false
					end))

					var3_14 = nil
					var2_14 = nil

					local var6_18 = true

					for iter0_18 = 0, var0_0.MAX_ROW - 1 do
						for iter1_18 = 0, var0_0.MAX_COLUMN - 1 do
							if arg0_14.cards[iter0_18][iter1_18].state == var0_0.CARD_STATE_NORMAL then
								var6_18 = false

								break
							end
						end
					end

					if var6_18 then
						arg0_14:SetState(var0_0.GAME_STATE_END)
					end
				end
			end
		end, SFX_PANEL)
	end)

	if IsUnityEditor and AUTO_LINKLINK then
		setActive(arg0_14.helpBtn, true)
		onButton(arg0_14, arg0_14.helpBtn, function()
			var2_14 = nil
			var3_14 = nil

			for iter0_21 = 0, var0_0.MAX_ROW - 1 do
				for iter1_21 = 0, var0_0.MAX_COLUMN - 1 do
					local var0_21 = arg0_14.cards[iter0_21][iter1_21]
					local var1_21 = var0_21.row * var0_0.MAX_COLUMN + var0_21.column
					local var2_21 = arg0_14.layout:GetChild(var1_21)

					if var0_21.state == var0_0.CARD_STATE_NORMAL then
						for iter2_21 = 0, var0_0.MAX_ROW - 1 do
							for iter3_21 = 0, var0_0.MAX_COLUMN - 1 do
								if iter0_21 ~= iter2_21 or iter1_21 ~= iter3_21 then
									local var3_21 = arg0_14.cards[iter2_21][iter3_21]
									local var4_21 = var3_21.row * var0_0.MAX_COLUMN + var3_21.column
									local var5_21 = arg0_14.layout:GetChild(var4_21)

									if var0_21.id == var3_21.id then
										triggerButton(var2_21:Find("display/icon"))
										triggerButton(var5_21:Find("display/icon"))

										if var4_14 then
											Timer.New(function()
												triggerButton(arg0_14.helpBtn)
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

	local var5_14 = 0

	onButton(arg0_14, arg0_14.resetBtn, function()
		if arg0_14.state ~= var0_0.GAME_STATE_GAMING then
			return
		elseif Time.realtimeSinceStartup - var5_14 < var0_0.RESET_CD then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_wait"))
		else
			if var2_14 then
				setActive(var3_14:Find("display/selected"), false)

				var3_14 = nil
				var2_14 = nil
			end

			local var0_23 = {}
			local var1_23 = {}

			for iter0_23 = 0, var0_0.MAX_ROW - 1 do
				for iter1_23 = 0, var0_0.MAX_COLUMN - 1 do
					local var2_23 = arg0_14.cards[iter0_23][iter1_23]

					if var2_23.state == var0_0.CARD_STATE_NORMAL then
						table.insert(var0_23, {
							row = iter0_23,
							column = iter1_23
						})
						table.insert(var1_23, var2_23.id)
					end
				end
			end

			local var3_23 = 1

			while #var1_23 > 0 do
				local var4_23 = math.clamp(math.floor(math.random() * #var1_23 + 1), 1, #var1_23)

				arg0_14.cards[var0_23[var3_23].row][var0_23[var3_23].column].id = var1_23[var4_23]

				table.remove(var1_23, var4_23)

				var3_23 = var3_23 + 1
			end

			arg0_14.list:each(function(arg0_24, arg1_24)
				local var0_24 = math.floor(arg0_24 / var0_0.MAX_COLUMN)
				local var1_24 = arg0_24 % var0_0.MAX_COLUMN
				local var2_24 = arg0_14.cards[var0_24][var1_24]

				if var2_24.state == var0_0.CARD_STATE_NORMAL then
					local var3_24 = getImageSprite(arg0_14.resource:GetChild(var2_24.id))

					setImageSprite(arg1_24:Find("display/icon"), var3_24)
				end
			end)

			var5_14 = Time.realtimeSinceStartup
		end
	end, SFX_PANEL)

	arg0_14.startTime = Time.realtimeSinceStartup
	arg0_14.countTimer = Timer.New(function()
		local var0_25 = math.floor((Time.realtimeSinceStartup - arg0_14.startTime) * 1000)

		setText(arg0_14.timeTxt, arg0_14:FormatRecordTime(var0_25))
	end, 0.033, -1)

	arg0_14.countTimer:Start()
	arg0_14.countTimer.func()
end

function var0_0.GameEnd(arg0_26)
	arg0_26.countTimer:Stop()

	arg0_26.countTimer = nil
	arg0_26.lastRecord = math.floor((Time.realtimeSinceStartup - arg0_26.startTime) * 1000)

	if arg0_26.activityRestTimes > 0 or arg0_26.lastRecord < arg0_26.activityBestRecord then
		local var0_26 = arg0_26.activityProgress + (arg0_26.activityRestTimes > 0 and 1 or 0)

		arg0_26:emit(LinkLinkMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_26.activity.id,
			arg1 = var0_26,
			arg2 = arg0_26.lastRecord
		})
	else
		arg0_26:DisplayResult(arg0_26.activity)
	end
end

function var0_0.DisplayResult(arg0_27, arg1_27)
	setActive(arg0_27.result, true)

	local var0_27 = arg0_27.result:Find("bg")

	setActive(var0_27:Find("pic_new_record"), arg1_27.data4 < arg0_27.activityBestRecord)
	setActive(var0_27:Find("pic_win"), arg1_27.data4 >= arg0_27.activityBestRecord)
	setText(var0_27:Find("time_txt"), arg0_27:FormatRecordTime(arg0_27.lastRecord))

	local var1_27 = arg1_27:getConfig("config_client")[3]

	setText(var0_27:Find("award_txt"), arg1_27.data2 > arg0_27.activityProgress and var1_27[arg1_27.data2] or 0)
	onButton(arg0_27, var0_27:Find("button"), function()
		arg0_27:HideResult()
		arg0_27:SetActivity(arg1_27)
		arg0_27:SetState(var0_0.GAME_STATE_BEGIN)
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.result, function()
		triggerButton(arg0_27.backBtn)
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0_27.result)
end

function var0_0.HideResult(arg0_30)
	if isActive(arg0_30.result) then
		setActive(arg0_30.result, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_30.result, arg0_30._tf)
	end
end

function var0_0.FormatRecordTime(arg0_31, arg1_31)
	local var0_31 = math.floor(arg1_31 / 60000)

	var0_31 = var0_31 >= 10 and var0_31 or "0" .. var0_31

	local var1_31 = math.floor(arg1_31 % 60000 / 1000)

	var1_31 = var1_31 >= 10 and var1_31 or "0" .. var1_31

	local var2_31 = math.floor(arg1_31 % 1000 / 10)

	var2_31 = var2_31 >= 10 and var2_31 or "0" .. var2_31

	return var0_31 .. "'" .. var1_31 .. "'" .. var2_31
end

function var0_0.LinkLink(arg0_32, arg1_32, arg2_32)
	assert(arg1_32.row ~= arg2_32.row or arg1_32.column ~= arg2_32.column)
	assert(arg1_32.id == arg2_32.id)

	local var0_32 = {
		row = arg1_32.row,
		column = arg1_32.column
	}
	local var1_32 = {
		row = arg2_32.row,
		column = arg2_32.column
	}
	local var2_32 = {}
	local var3_32 = {}

	table.insert(var2_32, var0_32)
	table.insert(var3_32, var0_32)

	for iter0_32 = 1, 3 do
		local var4_32 = arg0_32:IterateByOneSnap(var1_32, arg1_32.id, var2_32, var3_32)

		if var4_32 then
			local var5_32 = {
				var4_32
			}

			while var4_32 and var4_32.from do
				if var4_32.row ~= var4_32.from.row then
					local var6_32 = var4_32.row > var4_32.from.row and -1 or 1

					for iter1_32 = var4_32.row + var6_32, var4_32.from.row, var6_32 do
						table.insert(var5_32, {
							row = iter1_32,
							column = var4_32.column
						})
					end
				elseif var4_32.from.column ~= var4_32.column then
					local var7_32 = var4_32.column > var4_32.from.column and -1 or 1

					for iter2_32 = var4_32.column + var7_32, var4_32.from.column, var7_32 do
						table.insert(var5_32, {
							row = var4_32.row,
							column = iter2_32
						})
					end
				else
					assert(false)
				end

				var4_32 = var4_32.from
			end

			return var5_32
		end
	end
end

function var0_0.IterateByOneSnap(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	for iter0_33 = 1, #arg3_33 do
		local var0_33 = arg0_33:FindDirectLinkPoint(arg2_33, arg3_33[iter0_33], arg4_33)

		for iter1_33, iter2_33 in ipairs(var0_33) do
			if iter2_33.row == arg1_33.row and iter2_33.column == arg1_33.column then
				return iter2_33
			end

			table.insert(arg3_33, iter2_33)
		end
	end

	_.each(arg3_33, function(arg0_34)
		arg4_33[arg0_34.row .. "_" .. arg0_34.column] = true
	end)
end

function var0_0.FindDirectLinkPoint(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = {}

	for iter0_35 = arg2_35.row - 1, 0, -1 do
		local var1_35 = iter0_35 .. "_" .. arg2_35.column
		local var2_35 = arg0_35.cards[iter0_35][arg2_35.column]

		if var2_35.state == var0_0.CARD_STATE_NORMAL and var2_35.id ~= arg1_35 or arg3_35[var1_35] then
			break
		end

		table.insert(var0_35, {
			row = iter0_35,
			column = arg2_35.column,
			from = arg2_35
		})
	end

	for iter1_35 = arg2_35.row + 1, var0_0.MAX_ROW - 1 do
		local var3_35 = iter1_35 .. "_" .. arg2_35.column
		local var4_35 = arg0_35.cards[iter1_35][arg2_35.column]

		if var4_35.state == var0_0.CARD_STATE_NORMAL and var4_35.id ~= arg1_35 or arg3_35[var3_35] then
			break
		end

		table.insert(var0_35, {
			row = iter1_35,
			column = arg2_35.column,
			from = arg2_35
		})
	end

	for iter2_35 = arg2_35.column - 1, 0, -1 do
		local var5_35 = arg2_35.row .. "_" .. iter2_35
		local var6_35 = arg0_35.cards[arg2_35.row][iter2_35]

		if var6_35.state == var0_0.CARD_STATE_NORMAL and var6_35.id ~= arg1_35 or arg3_35[var5_35] then
			break
		end

		table.insert(var0_35, {
			row = arg2_35.row,
			column = iter2_35,
			from = arg2_35
		})
	end

	for iter3_35 = arg2_35.column + 1, var0_0.MAX_COLUMN - 1 do
		local var7_35 = arg2_35.row .. "_" .. iter3_35
		local var8_35 = arg0_35.cards[arg2_35.row][iter3_35]

		if var8_35.state == var0_0.CARD_STATE_NORMAL and var8_35.id ~= arg1_35 or arg3_35[var7_35] then
			break
		end

		table.insert(var0_35, {
			row = arg2_35.row,
			column = iter3_35,
			from = arg2_35
		})
	end

	return var0_35
end

function var0_0.LinkLink1(arg0_36, arg1_36, arg2_36)
	assert(arg1_36.row ~= arg2_36.row or arg1_36.column ~= arg2_36.column)
	assert(arg1_36.id == arg2_36.id)

	local var0_36
	local var1_36 = {
		[arg1_36.row .. "_" .. arg1_36.column] = {
			rdir = 0,
			cdir = 0,
			snap = 0,
			row = arg1_36.row,
			column = arg1_36.column,
			path = {}
		}
	}
	local var2_36 = {
		row = arg1_36.row,
		column = arg1_36.column
	}
	local var3_36 = {
		row = arg2_36.row,
		column = arg2_36.column
	}
	local var4_36 = {
		var2_36
	}
	local var5_36 = {}

	while #var4_36 > 0 do
		local var6_36 = table.remove(var4_36, 1)

		if var6_36.row == var3_36.row and var6_36.column == var3_36.column then
			var0_36 = var1_36[var6_36.row .. "_" .. var6_36.column].path

			break
		end

		table.insert(var5_36, var6_36)

		local var7_36 = {
			{
				row = 1,
				column = 0
			},
			{
				row = -1,
				column = 0
			},
			{
				row = 0,
				column = 1
			},
			{
				row = 0,
				column = -1
			}
		}

		_.each(var7_36, function(arg0_37)
			arg0_37.row = var6_36.row + arg0_37.row
			arg0_37.column = var6_36.column + arg0_37.column

			local var0_37 = _.any(var4_36, function(arg0_38)
				return arg0_38.row == arg0_37.row and arg0_38.column == arg0_37.column
			end) or _.any(var5_36, function(arg0_39)
				return arg0_39.row == arg0_37.row and arg0_39.column == arg0_37.column
			end)
			local var1_37 = arg0_36.cards[arg0_37.row] and arg0_36.cards[arg0_37.row][arg0_37.column] or nil

			if not var0_37 and (not var1_37 or var1_37.state == var0_0.CARD_STATE_LINKED or var1_37.state == var0_0.CARD_STATE_BLANK or var1_37.id == arg1_36.id) and arg0_37.row >= 0 and arg0_37.row < var0_0.MAX_ROW and arg0_37.column >= 0 and arg0_37.column < var0_0.MAX_COLUMN then
				local var2_37 = var1_36[var6_36.row .. "_" .. var6_36.column]
				local var3_37 = var2_37.snap
				local var4_37 = arg0_37.row - var6_36.row
				local var5_37 = arg0_37.column - var6_36.column

				if var2_37.rdir ~= 0 and var2_37.rdir ~= var4_37 or var2_37.cdir ~= 0 and var2_37.cdir ~= var5_37 then
					var3_37 = var3_37 + 1
				end

				if var3_37 <= 2 then
					local var6_37 = Clone(var2_37.path)

					table.insert(var6_37, arg0_37)

					var1_36[arg0_37.row .. "_" .. arg0_37.column] = {
						row = arg0_37.row,
						column = arg0_37.column,
						snap = var3_37,
						rdir = var4_37,
						cdir = var5_37,
						path = var6_37
					}

					local var7_37 = 0

					for iter0_37 = #var4_36, 1, -1 do
						local var8_37 = var4_36[iter0_37]
						local var9_37 = var1_36[var8_37.row .. "_" .. var8_37.column]

						if var3_37 > var9_37.snap or var3_37 == var9_37.snap and #var6_37 > #var9_37.path then
							var7_37 = iter0_37

							break
						end
					end

					table.insert(var4_36, var7_37 + 1, arg0_37)
				end
			end
		end)
	end

	return var0_36
end

return var0_0

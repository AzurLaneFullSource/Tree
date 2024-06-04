local var0 = class("LinkLinkScene", import("..base.BaseUI"))

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

function var0.getUIName(arg0)
	return "LinkLinkUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("BackBtn")
	arg0.helpBtn = arg0:findTF("top/help_btn")
	arg0.resetBtn = arg0:findTF("info/reset_button")
	arg0.awardTxt = arg0:findTF("info/award_txt")
	arg0.timeTxt = arg0:findTF("info/time_txt")
	arg0.bestTxt = arg0:findTF("info/best_txt")
	arg0.layout = arg0:findTF("card_con/layout")
	arg0.item = arg0.layout:Find("card")
	arg0.bottom = arg0:findTF("card_con/bottom")
	arg0.line = arg0.bottom:Find("card")
	arg0.result = arg0:findTF("result")
	arg0.countDown = arg0:findTF("count_down")
	arg0.resource = arg0:findTF("resource")
	arg0.bestTitleText = arg0:findTF("info/BestTitle")
	arg0.curTitleText = arg0:findTF("info/CurTitle")

	setText(arg0.bestTitleText, i18n("LinkLinkGame_BestTime"))
	setText(arg0.curTitleText, i18n("LinkLinkGame_CurTime"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	arg0:SetState(var0.GAME_STATE_BEGIN)
end

function var0.willExit(arg0)
	arg0:HideResult()
	LeanTween.cancel(go(arg0.countDown))

	for iter0 = 0, arg0.layout.childCount - 1 do
		LeanTween.cancel(go(arg0.layout:GetChild(iter0)))
	end

	if arg0.countTimer then
		arg0.countTimer:Stop()

		arg0.countTimer = nil
	end
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1
	arg0.activityAchieved = arg1.data1
	arg0.activityProgress = arg1.data2
	arg0.activityStartTime = arg1.data3
	arg0.activityBestRecord = arg1.data4

	local var0 = arg0.activity:getConfig("config_client")[3]
	local var1 = pg.TimeMgr.GetInstance()

	arg0.activityRestTimes = var1:DiffDay(arg0.activityStartTime, var1:GetServerTime()) + 1 - arg0.activityProgress
	arg0.activityRestTimes = math.clamp(arg0.activityRestTimes, 0, #var0 - arg0.activityProgress)

	setText(arg0.awardTxt, arg0.activityRestTimes > 0 and var0[arg0.activityProgress + 1] or 0)
	setText(arg0.bestTxt, arg0:FormatRecordTime(arg0.activityBestRecord))
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

	local var0 = {}

	for iter0 = 0, 17 do
		table.insert(var0, iter0)
		table.insert(var0, iter0)
	end

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

	for iter1 = 0, var0.MAX_ROW - 1 do
		for iter2 = 0, var0.MAX_COLUMN - 1 do
			arg0.cards[iter1] = arg0.cards[iter1] or {}
			arg0.cards[iter1][iter2] = arg0.cards[iter1][iter2] or {
				row = iter1,
				column = iter2,
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
	setActive(arg0.countDown, true)

	for iter3 = 0, arg0.countDown.childCount - 1 do
		setActive(arg0.countDown:GetChild(iter3), false)
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

			if var4 ~= var0 and var5 ~= var1 then
				local var7 = 0
				local var8 = (var4 == -1 and var1 == 1 or var0 == 1 and var5 == -1) and 0 or (var5 == -1 and var0 == -1 or var4 == 1 and var1 == 1) and 90 or (var4 == 1 and var1 == -1 or var0 == -1 and var5 == 1) and 180 or 270
				local var9 = var6:Find("joint")

				setActive(var9, true)

				var9.localEulerAngles = Vector3(0, 0, var8)
			elseif var0 == 0 and var4 ~= 0 or var0 ~= 0 and var4 == var0 then
				local var10 = var6:Find("cross")

				setActive(var10, true)

				var10.localEulerAngles = Vector3(0, 0, 90)
			elseif var1 == 0 and var5 ~= 0 or var1 ~= 0 and var5 == var1 then
				local var11 = var6:Find("cross")

				setActive(var11, true)

				var11.localEulerAngles = Vector3(0, 0, 0)
			end

			var0, var1 = var4, var5
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

					LeanTween.value(go(var4), 1, 0.15, 0.3):setEase(LeanTweenType.easeInBack):setOnUpdate(System.Action_float(function(arg0)
						var4.localScale = Vector3(arg0, arg0, 1)
						var5.localScale = Vector3(arg0, arg0, 1)
					end)):setOnComplete(System.Action(function()
						var1(var3)
						setActive(var4:Find("display"), false)
						setActive(var5:Find("display"), false)

						var4 = false
					end))

					var3 = nil
					var2 = nil

					local var6 = true

					for iter0 = 0, var0.MAX_ROW - 1 do
						for iter1 = 0, var0.MAX_COLUMN - 1 do
							if arg0.cards[iter0][iter1].state == var0.CARD_STATE_NORMAL then
								var6 = false

								break
							end
						end
					end

					if var6 then
						arg0:SetState(var0.GAME_STATE_END)
					end
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
		local var0 = math.floor((Time.realtimeSinceStartup - arg0.startTime) * 1000)

		setText(arg0.timeTxt, arg0:FormatRecordTime(var0))
	end, 0.033, -1)

	arg0.countTimer:Start()
	arg0.countTimer.func()
end

function var0.GameEnd(arg0)
	arg0.countTimer:Stop()

	arg0.countTimer = nil
	arg0.lastRecord = math.floor((Time.realtimeSinceStartup - arg0.startTime) * 1000)

	if arg0.activityRestTimes > 0 or arg0.lastRecord < arg0.activityBestRecord then
		local var0 = arg0.activityProgress + (arg0.activityRestTimes > 0 and 1 or 0)

		arg0:emit(LinkLinkMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id,
			arg1 = var0,
			arg2 = arg0.lastRecord
		})
	else
		arg0:DisplayResult(arg0.activity)
	end
end

function var0.DisplayResult(arg0, arg1)
	setActive(arg0.result, true)

	local var0 = arg0.result:Find("bg")

	setActive(var0:Find("pic_new_record"), arg1.data4 < arg0.activityBestRecord)
	setActive(var0:Find("pic_win"), arg1.data4 >= arg0.activityBestRecord)
	setText(var0:Find("time_txt"), arg0:FormatRecordTime(arg0.lastRecord))

	local var1 = arg1:getConfig("config_client")[3]

	setText(var0:Find("award_txt"), arg1.data2 > arg0.activityProgress and var1[arg1.data2] or 0)
	onButton(arg0, var0:Find("button"), function()
		arg0:HideResult()
		arg0:SetActivity(arg1)
		arg0:SetState(var0.GAME_STATE_BEGIN)
	end, SFX_PANEL)
	onButton(arg0, arg0.result, function()
		triggerButton(arg0.backBtn)
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0.result)
end

function var0.HideResult(arg0)
	if isActive(arg0.result) then
		setActive(arg0.result, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.result, arg0._tf)
	end
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
		local var0 = arg0:FindDirectLinkPoint(arg2, arg3[iter0], arg4)

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

function var0.FindDirectLinkPoint(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0 = arg2.row - 1, 0, -1 do
		local var1 = iter0 .. "_" .. arg2.column
		local var2 = arg0.cards[iter0][arg2.column]

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

function var0.LinkLink1(arg0, arg1, arg2)
	assert(arg1.row ~= arg2.row or arg1.column ~= arg2.column)
	assert(arg1.id == arg2.id)

	local var0
	local var1 = {
		[arg1.row .. "_" .. arg1.column] = {
			rdir = 0,
			cdir = 0,
			snap = 0,
			row = arg1.row,
			column = arg1.column,
			path = {}
		}
	}
	local var2 = {
		row = arg1.row,
		column = arg1.column
	}
	local var3 = {
		row = arg2.row,
		column = arg2.column
	}
	local var4 = {
		var2
	}
	local var5 = {}

	while #var4 > 0 do
		local var6 = table.remove(var4, 1)

		if var6.row == var3.row and var6.column == var3.column then
			var0 = var1[var6.row .. "_" .. var6.column].path

			break
		end

		table.insert(var5, var6)

		local var7 = {
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

		_.each(var7, function(arg0)
			arg0.row = var6.row + arg0.row
			arg0.column = var6.column + arg0.column

			local var0 = _.any(var4, function(arg0)
				return arg0.row == arg0.row and arg0.column == arg0.column
			end) or _.any(var5, function(arg0)
				return arg0.row == arg0.row and arg0.column == arg0.column
			end)
			local var1 = arg0.cards[arg0.row] and arg0.cards[arg0.row][arg0.column] or nil

			if not var0 and (not var1 or var1.state == var0.CARD_STATE_LINKED or var1.state == var0.CARD_STATE_BLANK or var1.id == arg1.id) and arg0.row >= 0 and arg0.row < var0.MAX_ROW and arg0.column >= 0 and arg0.column < var0.MAX_COLUMN then
				local var2 = var1[var6.row .. "_" .. var6.column]
				local var3 = var2.snap
				local var4 = arg0.row - var6.row
				local var5 = arg0.column - var6.column

				if var2.rdir ~= 0 and var2.rdir ~= var4 or var2.cdir ~= 0 and var2.cdir ~= var5 then
					var3 = var3 + 1
				end

				if var3 <= 2 then
					local var6 = Clone(var2.path)

					table.insert(var6, arg0)

					var1[arg0.row .. "_" .. arg0.column] = {
						row = arg0.row,
						column = arg0.column,
						snap = var3,
						rdir = var4,
						cdir = var5,
						path = var6
					}

					local var7 = 0

					for iter0 = #var4, 1, -1 do
						local var8 = var4[iter0]
						local var9 = var1[var8.row .. "_" .. var8.column]

						if var3 > var9.snap or var3 == var9.snap and #var6 > #var9.path then
							var7 = iter0

							break
						end
					end

					table.insert(var4, var7 + 1, arg0)
				end
			end
		end)
	end

	return var0
end

return var0

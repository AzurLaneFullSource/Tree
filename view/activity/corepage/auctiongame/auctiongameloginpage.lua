local var0_0 = class("AuctionGameLoginPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.sign = arg0_1.bg:Find("sign")
	arg0_1.playerInfo = arg0_1.bg:Find("playerInfo")
	arg0_1.playerFrame = arg0_1.playerInfo:Find("frame")
	arg0_1.playerIcon = arg0_1.playerInfo:Find("frame/icon")
	arg0_1.playerName = arg0_1.playerInfo:Find("name")
	arg0_1.playerCount = arg0_1.playerInfo:Find("count")
	arg0_1.items = {}

	for iter0_1 = 1, arg0_1.sign.childCount do
		local var0_1 = arg0_1:getItem(iter0_1)

		table.insert(arg0_1.items, var0_1)
	end

	arg0_1.btnGet = arg0_1.bg:Find("btnGet")

	setText(arg0_1.btnGet:Find("text"), i18n("auction_signin_collect"))
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_data")
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.btnGet, function()
		local var0_4 = {}
		local var1_4 = getProxy(PlayerProxy):getRawData()
		local var2_4 = pg.gameset.urpt_chapter_max.description[1]
		local var3_4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var2_4)
		local var4_4, var5_4 = arg0_3:checkCanGetList()

		if table.isEmpty(var5_4) then
			return
		end

		local var6_4, var7_4 = Task.StaticJudgeOverflow(var1_4.gold, var1_4.oil, var3_4, true, true, var4_4)

		if var6_4 then
			table.insert(var0_4, function(arg0_5)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var7_4,
					onYes = arg0_5
				})
			end)
		end

		seriesAsync(var0_4, function()
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT_ONESTEP, var5_4)
		end)
	end)
end

function var0_0.checkCanGetList(arg0_7)
	local var0_7 = {}
	local var1_7 = {}

	local function var2_7(arg0_8)
		for iter0_8, iter1_8 in ipairs(var0_7) do
			if iter1_8[1] == arg0_8[1] and iter1_8[2] == arg0_8[2] then
				iter1_8[3] = iter1_8[3] + arg0_8[3]

				return
			end
		end

		table.insert(var0_7, {
			arg0_8[1],
			arg0_8[2],
			arg0_8[3]
		})
	end

	for iter0_7, iter1_7 in ipairs(arg0_7.taskGroup[1]) do
		local var3_7 = arg0_7.taskProxy:getTaskById(iter1_7)

		if var3_7 and var3_7:getTaskStatus() == 1 then
			local var4_7 = pg.task_data_template[iter1_7]

			for iter2_7, iter3_7 in ipairs(var4_7.award_display) do
				var2_7(iter3_7)
			end

			table.insert(var1_7, {
				id = iter1_7
			})
		end
	end

	return var0_7, var1_7
end

function var0_0.OnUpdateFlush(arg0_9)
	if not arg0_9.activity or not arg0_9.taskGroup then
		return
	end

	arg0_9.nday = arg0_9.activity:getNDay()

	arg0_9:setPlayerInfo()

	local var0_9 = false

	for iter0_9, iter1_9 in ipairs(arg0_9.items) do
		local var1_9 = arg0_9.taskGroup[1][iter0_9]
		local var2_9 = pg.task_data_template[var1_9]
		local var3_9 = Drop.Create(var2_9.award_display[1])

		updateDrop(iter1_9.item, var3_9)
		onButton(arg0_9, iter1_9.frame, function()
			arg0_9:emit(BaseUI.ON_DROP, var3_9)
		end, SFX_PANEL)

		local var4_9 = arg0_9.taskProxy:getTaskById(var1_9) or arg0_9.taskProxy:getFinishTaskById(var1_9)
		local var5_9 = not not var4_9
		local var6_9 = var4_9 and var4_9:getTaskStatus() == 1
		local var7_9 = var4_9 and var4_9:getTaskStatus() == 2

		var0_9 = var0_9 or var6_9

		setActive(iter1_9.lock, not var5_9)
		setActive(iter1_9.get, var6_9 and not var7_9)
		setActive(iter1_9.got, var7_9)
		onButton(arg0_9, iter1_9.get, function()
			local var0_11 = {}
			local var1_11 = var2_9.award_display
			local var2_11 = getProxy(PlayerProxy):getRawData()
			local var3_11 = pg.gameset.urpt_chapter_max.description[1]
			local var4_11 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_11)
			local var5_11, var6_11 = Task.StaticJudgeOverflow(var2_11.gold, var2_11.oil, var4_11, true, true, var1_11)

			if var5_11 then
				table.insert(var0_11, function(arg0_12)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var6_11,
						onYes = arg0_12
					})
				end)
			end

			seriesAsync(var0_11, function()
				arg0_9:emit(ActivityMediator.ON_TASK_SUBMIT, var4_9)
			end)
		end, SFX_PANEL)
	end

	setGray(arg0_9.btnGet, not var0_9)
end

function var0_0.getItem(arg0_14, arg1_14)
	if arg0_14.items[arg1_14] then
		return arg0_14.items[arg1_14]
	end

	local var0_14 = {}
	local var1_14 = arg0_14.sign:GetChild(arg1_14 - 1)

	var0_14.item = var1_14:Find("item")
	var0_14.frame = var1_14:Find("frame")
	var0_14.got = var1_14:Find("got")
	var0_14.get = var1_14:Find("get")
	var0_14.lock = var1_14:Find("lock")

	return var0_14
end

function var0_0.setPlayerInfo(arg0_15)
	local var0_15 = getProxy(PlayerProxy):getRawData()
	local var1_15 = var0_15:GetShipPhantomMarks()[1]
	local var2_15 = getProxy(BayProxy):GetShipPhantom(var1_15)

	GetImageSpriteFromAtlasAsync("SquareIcon/" .. var2_15:getPainting(), "", arg0_15.playerIcon)
	setText(arg0_15.playerName, var0_15.name)
	setText(arg0_15.playerCount, StringHelper.ForamtNumberK(AuctionGameTools.GetCurrencyCnt()))
end

function var0_0.OnDestroy(arg0_16)
	if arg0_16.iconView then
		arg0_16.iconView:Dispose()

		arg0_16.iconView = nil
	end
end

return var0_0

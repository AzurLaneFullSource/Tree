local var0_0 = class("VoteFameHallLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	if PLATFORM_CODE == PLATFORM_CHT then
		return "VoteFameHallUIForCht"
	else
		return "VoteFameHallUI"
	end
end

function var0_0.SetPastVoteData(arg0_2, arg1_2)
	arg0_2.voteData = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.tip = arg0_3:findTF("Text"):GetComponent(typeof(Text))
	arg0_3.backBtn = arg0_3:findTF("adapt/back")
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	arg0_4:InitData()
end

function var0_0.InitData(arg0_6)
	arg0_6.displays = {}
	arg0_6.btns = {}

	local var0_6 = false

	for iter0_6, iter1_6 in pairs(arg0_6.voteData) do
		local var1_6 = arg0_6:findTF("adapt/btns/btn_" .. iter0_6)

		arg0_6.displays[iter0_6] = iter1_6

		onToggle(arg0_6, var1_6, function(arg0_7)
			if arg0_7 then
				arg0_6:Flush(iter0_6)
			end
		end, SFX_PANEL)

		arg0_6.btns[iter0_6] = var1_6

		if not var0_6 then
			triggerToggle(var1_6, true)

			var0_6 = true
		end
	end

	arg0_6:UpdateBtnsTip()
end

function var0_0.Flush(arg0_8, arg1_8)
	local var0_8 = arg0_8.displays[arg1_8]

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var1_8 = pg.vote_champion[iter1_8]
		local var2_8 = arg0_8:findTF(arg1_8 .. "/" .. var1_8.rank)
		local var3_8 = var1_8.story
		local var4_8 = var1_8.task

		onButton(arg0_8, var2_8, function()
			arg0_8:GetAward(var3_8, var4_8)
		end, SFX_PANEL)
	end

	arg0_8:UpdateTips(arg1_8)

	arg0_8.year = arg1_8
end

function var0_0.UpdateTips(arg0_10, arg1_10)
	if not arg1_10 then
		return
	end

	local var0_10 = arg0_10.displays[arg1_10]
	local var1_10 = getProxy(AttireProxy)
	local var2_10 = {
		{
			"",
			false
		},
		{
			"",
			false
		},
		{
			"",
			false
		}
	}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var3_10 = pg.vote_champion[iter1_10]
		local var4_10 = var3_10.story
		local var5_10 = var3_10.task
		local var6_10 = getProxy(TaskProxy)
		local var7_10 = var6_10:getTaskById(var5_10) or var6_10:getFinishTaskById(var5_10)
		local var8_10 = arg0_10:findTF(arg1_10 .. "/" .. var3_10.rank .. "/title/tip")
		local var9_10 = pg.task_data_template[var5_10].award_display[1]
		local var10_10 = var1_10:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var9_10[2])

		var2_10[iter0_10][2] = var10_10 ~= nil and var10_10:isOwned()
		var2_10[iter0_10][1] = ShipGroup.getDefaultShipConfig(var3_10.ship_group).name

		setActive(var8_10, var7_10 and var7_10:isFinish() and not var7_10:isReceive() and (var10_10 == nil or not var10_10:isOwned()))
	end

	local var11_10 = _.map(var2_10, function(arg0_11)
		return arg0_11[2] and arg0_11[1] .. "(<color=#92fc63>" .. i18n("word_got") .. "</color>)" or arg0_11[1]
	end)

	arg0_10.tip.text = i18n("vote_fame_tip", var11_10[1], var11_10[2], var11_10[3])
end

function var0_0.UpdateBtnsTip(arg0_12)
	local var0_12 = getProxy(TaskProxy)
	local var1_12 = getProxy(AttireProxy)

	for iter0_12, iter1_12 in pairs(arg0_12.displays) do
		local var2_12 = _.any(iter1_12, function(arg0_13)
			local var0_13 = pg.vote_champion[arg0_13].task
			local var1_13 = var0_12:getTaskById(var0_13) or var0_12:getFinishTaskById(var0_13)
			local var2_13 = pg.task_data_template[var0_13].award_display[1]
			local var3_13 = var1_12:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var2_13[2])

			return var1_13 and var1_13:isFinish() and not var1_13:isReceive() and (var3_13 == nil or not var3_13:isOwned())
		end)

		setActive(arg0_12.btns[iter0_12]:Find("tip"), var2_12)
	end
end

function var0_0.GetAward(arg0_14, arg1_14, arg2_14)
	local var0_14 = {
		function(arg0_15)
			pg.NewStoryMgr.GetInstance():Play(arg1_14, arg0_15, true)
		end,
		function(arg0_16)
			local var0_16 = getProxy(TaskProxy)
			local var1_16 = var0_16:getTaskById(arg2_14) or var0_16:getFinishTaskById(arg2_14)

			if var1_16 and var1_16:isFinish() and not var1_16:isReceive() then
				arg0_14:emit(VoteFameHallMediator.ON_SUBMIT_TASK, var1_16.id)
			end

			arg0_16()
		end
	}

	seriesAsync(var0_14)
end

function var0_0.willExit(arg0_17)
	return
end

return var0_0

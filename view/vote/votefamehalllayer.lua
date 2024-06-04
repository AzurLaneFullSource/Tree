local var0 = class("VoteFameHallLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	if PLATFORM_CODE == PLATFORM_CHT then
		return "VoteFameHallUIForCht"
	else
		return "VoteFameHallUI"
	end
end

function var0.SetPastVoteData(arg0, arg1)
	arg0.voteData = arg1
end

function var0.init(arg0)
	arg0.tip = arg0:findTF("Text"):GetComponent(typeof(Text))
	arg0.backBtn = arg0:findTF("adapt/back")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	arg0:InitData()
end

function var0.InitData(arg0)
	arg0.displays = {}
	arg0.btns = {}

	local var0 = false

	for iter0, iter1 in pairs(arg0.voteData) do
		local var1 = arg0:findTF("adapt/btns/btn_" .. iter0)

		arg0.displays[iter0] = iter1

		onToggle(arg0, var1, function(arg0)
			if arg0 then
				arg0:Flush(iter0)
			end
		end, SFX_PANEL)

		arg0.btns[iter0] = var1

		if not var0 then
			triggerToggle(var1, true)

			var0 = true
		end
	end

	arg0:UpdateBtnsTip()
end

function var0.Flush(arg0, arg1)
	local var0 = arg0.displays[arg1]

	for iter0, iter1 in ipairs(var0) do
		local var1 = pg.vote_champion[iter1]
		local var2 = arg0:findTF(arg1 .. "/" .. var1.rank)
		local var3 = var1.story
		local var4 = var1.task

		onButton(arg0, var2, function()
			arg0:GetAward(var3, var4)
		end, SFX_PANEL)
	end

	arg0:UpdateTips(arg1)

	arg0.year = arg1
end

function var0.UpdateTips(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = arg0.displays[arg1]
	local var1 = getProxy(AttireProxy)
	local var2 = {
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

	for iter0, iter1 in ipairs(var0) do
		local var3 = pg.vote_champion[iter1]
		local var4 = var3.story
		local var5 = var3.task
		local var6 = getProxy(TaskProxy)
		local var7 = var6:getTaskById(var5) or var6:getFinishTaskById(var5)
		local var8 = arg0:findTF(arg1 .. "/" .. var3.rank .. "/title/tip")
		local var9 = pg.task_data_template[var5].award_display[1]
		local var10 = var1:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var9[2])

		var2[iter0][2] = var10 ~= nil and var10:isOwned()
		var2[iter0][1] = ShipGroup.getDefaultShipConfig(var3.ship_group).name

		setActive(var8, var7 and var7:isFinish() and not var7:isReceive() and (var10 == nil or not var10:isOwned()))
	end

	local var11 = _.map(var2, function(arg0)
		return arg0[2] and arg0[1] .. "(<color=#92fc63>" .. i18n("word_got") .. "</color>)" or arg0[1]
	end)

	arg0.tip.text = i18n("vote_fame_tip", var11[1], var11[2], var11[3])
end

function var0.UpdateBtnsTip(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = getProxy(AttireProxy)

	for iter0, iter1 in pairs(arg0.displays) do
		local var2 = _.any(iter1, function(arg0)
			local var0 = pg.vote_champion[arg0].task
			local var1 = var0:getTaskById(var0) or var0:getFinishTaskById(var0)
			local var2 = pg.task_data_template[var0].award_display[1]
			local var3 = var1:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var2[2])

			return var1 and var1:isFinish() and not var1:isReceive() and (var3 == nil or not var3:isOwned())
		end)

		setActive(arg0.btns[iter0]:Find("tip"), var2)
	end
end

function var0.GetAward(arg0, arg1, arg2)
	local var0 = {
		function(arg0)
			pg.NewStoryMgr.GetInstance():Play(arg1, arg0, true)
		end,
		function(arg0)
			local var0 = getProxy(TaskProxy)
			local var1 = var0:getTaskById(arg2) or var0:getFinishTaskById(arg2)

			if var1 and var1:isFinish() and not var1:isReceive() then
				arg0:emit(VoteFameHallMediator.ON_SUBMIT_TASK, var1.id)
			end

			arg0()
		end
	}

	seriesAsync(var0)
end

function var0.willExit(arg0)
	return
end

return var0

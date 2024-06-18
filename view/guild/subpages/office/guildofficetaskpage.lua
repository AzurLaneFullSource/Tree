local var0_0 = class("GuildOfficeTaskPage", import("...base.GuildBasePage"))

function var0_0.getTargetUI(arg0_1)
	return "GuildOfficeTaskBluePage", "GuildOfficeTaskRedPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.selectTaskPage = GuildOfficeSelectTaskPage.New(arg0_2._tf.parent, arg0_2.event)
	arg0_2.taskTF = arg0_2:findTF("TaskPanel")
	arg0_2.taskUnOpenTF = arg0_2:findTF("TaskPanel/unopen")
	arg0_2.unOpenAdmin = arg0_2.taskUnOpenTF:Find("select")
	arg0_2.unOpenUnAdmin = arg0_2.taskUnOpenTF:Find("lock")
	arg0_2.taskOpenTF = arg0_2:findTF("TaskPanel/open")
	arg0_2.taskDescTxt = arg0_2:findTF("top/desc/Text", arg0_2.taskOpenTF):GetComponent(typeof(Text))
	arg0_2.taskAwardTxt = arg0_2:findTF("top/desc1/Text", arg0_2.taskOpenTF):GetComponent(typeof(Text))
	arg0_2.taskProgressTxt = arg0_2:findTF("top/progress", arg0_2.taskOpenTF):GetComponent(typeof(Text))
	arg0_2.taskProgressBar = arg0_2:findTF("top/progress_bar", arg0_2.taskOpenTF)
	arg0_2.privateTaskDesc = arg0_2:findTF("bottom/desc", arg0_2.taskOpenTF):GetComponent(typeof(Text))
	arg0_2.privateTaskGetBtn = arg0_2:findTF("bottom/get", arg0_2.taskOpenTF)
	arg0_2.privateTaskAcceptBtn = arg0_2:findTF("bottom/accept", arg0_2.taskOpenTF)
	arg0_2.privateTaskProgressTxt = arg0_2:findTF("bottom/progress/Text", arg0_2.taskOpenTF):GetComponent(typeof(Text))
	arg0_2.privateTaskReapeatFlag = arg0_2:findTF("bottom/reapeat", arg0_2.taskOpenTF)
	arg0_2.privateTaskResTxt = arg0_2:findTF("bottom/res/Text", arg0_2.taskOpenTF):GetComponent(typeof(Text))
	arg0_2.taskMaskAll = arg0_2:findTF("TaskPanel/open/mask_all")
	arg0_2.taskMaskTop = arg0_2:findTF("TaskPanel/open/mask_top")
	arg0_2.contributionList = UIItemList.New(arg0_2:findTF("TaskPanel/SubmitPanel/list"), arg0_2:findTF("TaskPanel/SubmitPanel/list/tpl"))
	arg0_2.contributionCntTxt = arg0_2:findTF("TaskPanel/SubmitPanel/cnt/Text"):GetComponent(typeof(Text))
	arg0_2.supplyFrame = arg0_2:findTF("TaskPanel/SupplyPanel/frame")
	arg0_2.supplyOpenTF = arg0_2:findTF("TaskPanel/SupplyPanel/frame/open")
	arg0_2.supplyOpenTimeTxt = arg0_2:findTF("time", arg0_2.supplyOpenTF):GetComponent(typeof(Text))
	arg0_2.supplyOpenLetfCntTxt = arg0_2:findTF("Text", arg0_2.supplyOpenTF):GetComponent(typeof(Text))
	arg0_2.supplyOpenGetBtn = arg0_2:findTF("get", arg0_2.supplyOpenTF)
	arg0_2.supplyOpenGotBtn = arg0_2:findTF("got", arg0_2.supplyOpenTF)
	arg0_2.supplyUnOpenTF = arg0_2:findTF("TaskPanel/SupplyPanel/frame/unopen")
	arg0_2.supplyUnOpenAdminTF = arg0_2:findTF("purchase", arg0_2.supplyUnOpenTF)
	arg0_2.supplyUnOpenResTF = arg0_2.supplyUnOpenAdminTF:Find("Text"):GetComponent(typeof(Text))
	arg0_2.supplyUnOpenLockTF = arg0_2:findTF("lock", arg0_2.supplyUnOpenTF)
end

function var0_0.OnInit(arg0_3)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3.taskTF, {
		pbList = {
			arg0_3.taskTF
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})
	onButton(arg0_3, arg0_3.supplyUnOpenAdminTF, function()
		local var0_4 = arg0_3.guild:getSupplyConsume()

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_start_supply_consume_tip", var0_4),
			onYes = function()
				arg0_3:emit(GuildOfficeMediator.ON_PURCHASE_SUPPLY)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.supplyOpenGetBtn, function()
		arg0_3:emit(GuildOfficeMediator.GET_SUPPLY_AWARD)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.supplyFrame, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_supply_help_tip.tip
		})
	end, SFX_PANEL)
end

function var0_0.Update(arg0_8, arg1_8, arg2_8)
	arg0_8:OnUpdateGuild(arg1_8, arg2_8)
	arg0_8:UpdateTaskPanel(false)
	arg0_8:UpdateContributionPanel()
	arg0_8:UpdateSupplyPanel()
	arg0_8:Show()
end

function var0_0.OnUpdateGuild(arg0_9, arg1_9, arg2_9)
	arg0_9.guild = arg1_9
	arg0_9.isAdmin = arg2_9
end

function var0_0.OnUpdateContribution(arg0_10)
	arg0_10:UpdateContributionPanel()
end

function var0_0.OnUpdateTask(arg0_11, arg1_11)
	arg0_11:UpdateTaskPanel(arg1_11)
end

function var0_0.OnUpdateSupplyPanel(arg0_12)
	arg0_12:UpdateSupplyPanel()
end

function var0_0.UpdateTaskPanel(arg0_13, arg1_13)
	local var0_13 = arg0_13.guild
	local var1_13 = var0_13:getWeeklyTask()
	local var2_13 = var1_13:getState()

	if var2_13 == GuildTask.STATE_EMPTY then
		arg0_13:UpdateLockTask()
	elseif var2_13 == GuildTask.STATE_ONGOING or var2_13 == GuildTask.STATE_FINISHED then
		arg0_13:UpdatePubliceTask(var1_13)
		arg0_13:UpdatePrivateTask(var1_13)
	end

	setActive(arg0_13.taskOpenTF, var2_13 ~= GuildTask.STATE_EMPTY)
	setActive(arg0_13.taskUnOpenTF, var2_13 == GuildTask.STATE_EMPTY)

	if arg1_13 or var0_13:shouldRefreshWeeklyTaskProgress() then
		arg0_13:emit(GuildOfficeMediator.UPDATE_WEEKLY_TASK)
	end
end

function var0_0.UpdateLockTask(arg0_14)
	setActive(arg0_14.unOpenAdmin, arg0_14.isAdmin)
	setActive(arg0_14.unOpenUnAdmin, not arg0_14.isAdmin)

	if arg0_14.isAdmin then
		onButton(arg0_14, arg0_14.unOpenAdmin, function()
			arg0_14.selectTaskPage:ExecuteAction("Show", arg0_14.guild, arg0_14.isAdmin)
		end, SFX_PANEL)
	end
end

function var0_0.UpdatePrivateTask(arg0_16, arg1_16)
	local var0_16 = not arg0_16.guild:hasWeeklyTaskFlag()
	local var1_16 = arg1_16:GetPresonTaskId()
	local var2_16 = getProxy(TaskProxy)
	local var3_16 = var2_16:getTaskById(var1_16) or var2_16:getFinishTaskById(var1_16)
	local var4_16 = var3_16 ~= nil

	if not var4_16 then
		var3_16 = Task.New({
			id = var1_16
		})
	end

	arg0_16.privateTaskDesc.text = var3_16:getConfig("desc")
	arg0_16.privateTaskProgressTxt.text = var3_16.progress .. "/" .. var3_16:getConfig("target_num")
	arg0_16.privateTaskResTxt.text = arg1_16:GetPrivateAward()

	onButton(arg0_16, arg0_16.privateTaskAcceptBtn, function()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_task_accept", arg1_16:getConfig("name"), var3_16:getConfig("name"), var3_16:getConfig("name")),
			onYes = function()
				arg0_16:emit(GuildOfficeMediator.ON_ACCEPT_TASK, var1_16)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.privateTaskGetBtn, function()
		arg0_16:emit(GuildOfficeMediator.ON_SUBMIT_TASK, var1_16)
	end, SFX_PANEL)

	if var3_16:isFinish() and not var3_16:isReceive() and not var0_16 then
		arg0_16:emit(GuildOfficeMediator.ON_SUBMIT_TASK, var1_16)
	elseif not var4_16 and var0_16 then
		arg0_16:emit(GuildOfficeMediator.ON_ACCEPT_TASK, var1_16)
	end

	local var5_16 = not var0_16
	local var6_16 = arg1_16:isFinished() and (not var4_16 or not var0_16)

	setActive(arg0_16.taskMaskAll, var6_16)
	setActive(arg0_16.taskMaskTop, not var6_16 and arg1_16:isFinished())
	setActive(arg0_16.privateTaskReapeatFlag, var5_16)
	setActive(arg0_16.privateTaskResTxt.gameObject.transform.parent, not var5_16)
	setActive(arg0_16.privateTaskAcceptBtn, not var4_16 or var3_16:isReceive())
	setActive(arg0_16.privateTaskGetBtn, var4_16 and var3_16:isFinish() and not var3_16:isReceive())
	setActive(arg0_16.privateTaskProgressTxt.gameObject.transform.parent, var4_16 and not var3_16:isFinish())
end

function var0_0.UpdatePubliceTask(arg0_20, arg1_20)
	local var0_20 = arg1_20:getProgress()
	local var1_20 = arg1_20:getMaxProgress()

	arg0_20.taskProgressTxt.text = var0_20 .. "/<size=40>" .. var1_20 .. "</size>"

	setFillAmount(arg0_20.taskProgressBar, var0_20 / var1_20)

	arg0_20.taskDescTxt.text = var0_20
	arg0_20.taskAwardTxt.text = arg1_20:GetCurrCaptailAward()
end

function var0_0.UpdateContributionPanel(arg0_21)
	local var0_21 = arg0_21.guild
	local var1_21 = var0_21:getDonateTasks()
	local var2_21 = var0_21:getRemainDonateCnt() + var0_21:GetExtraDonateCnt()

	arg0_21.contributionList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var1_21[arg1_22 + 1]
			local var1_22 = GuildDonateCard.New(arg2_22)

			var1_22:update(var0_22)
			onButton(arg0_21, var1_22.commitBtn, function()
				local var0_23 = var0_22:getCommitItem()
				local var1_23 = Drop.New({
					type = var0_23[1],
					id = var0_23[2],
					count = var0_23[3]
				})
				local var2_23 = var1_22:GetResCntByAward(var0_23)
				local var3_23 = var2_23 < var0_23[3] and "#FF5C5CFF" or "#92FC63FF"

				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					content = i18n("guild_donate_tip", var1_23:getConfig("name"), var0_23[3], var2_23, var3_23),
					onYes = function()
						arg0_21:emit(GuildOfficeMediator.ON_COMMIT, var0_22.id)
					end
				})
			end, SFX_PANEL)
			setButtonEnabled(var1_22.commitBtn, var2_21 > 0)
		end
	end)
	arg0_21.contributionList:align(#var1_21)

	arg0_21.contributionCntTxt.text = i18n("guild_left_donate_cnt", var2_21)
end

function var0_0.UpdateSupplyPanel(arg0_25)
	local var0_25 = arg0_25.guild
	local var1_25 = var0_25:isOpenedSupply()

	setActive(arg0_25.supplyOpenTF, var1_25)
	setActive(arg0_25.supplyUnOpenTF, not var1_25)

	if not var1_25 then
		setActive(arg0_25.supplyUnOpenAdminTF, arg0_25.isAdmin)
		setActive(arg0_25.supplyUnOpenLockTF, not arg0_25.isAdmin)

		if arg0_25.isAdmin then
			arg0_25.supplyUnOpenResTF.text = var0_25:getSupplyConsume()
		end
	else
		local var2_25 = var0_25:getSupplyCnt()
		local var3_25 = var0_25:getSupplyLeftCnt()

		setActive(arg0_25.supplyOpenGetBtn, var2_25 > 0)
		setActive(arg0_25.supplyOpenGotBtn, var2_25 <= 0)

		if var3_25 < 0 then
			arg0_25.supplyOpenTimeTxt.text = i18n("guild_exist_unreceived_supply_award")
		else
			arg0_25.supplyOpenTimeTxt.text = i18n("guild_left_supply_day", var3_25)
		end

		arg0_25.supplyOpenLetfCntTxt.text = i18n1(var2_25 .. "/" .. GuildConst.MAX_SUPPLY_CNT)
	end
end

function var0_0.OnDestroy(arg0_26)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_26.taskTF, arg0_26._tf)
	arg0_26.selectTaskPage:Destroy()
end

return var0_0

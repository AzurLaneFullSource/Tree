local var0 = class("GuildOfficeTaskPage", import("...base.GuildBasePage"))

function var0.getTargetUI(arg0)
	return "GuildOfficeTaskBluePage", "GuildOfficeTaskRedPage"
end

function var0.OnLoaded(arg0)
	arg0.selectTaskPage = GuildOfficeSelectTaskPage.New(arg0._tf.parent, arg0.event)
	arg0.taskTF = arg0:findTF("TaskPanel")
	arg0.taskUnOpenTF = arg0:findTF("TaskPanel/unopen")
	arg0.unOpenAdmin = arg0.taskUnOpenTF:Find("select")
	arg0.unOpenUnAdmin = arg0.taskUnOpenTF:Find("lock")
	arg0.taskOpenTF = arg0:findTF("TaskPanel/open")
	arg0.taskDescTxt = arg0:findTF("top/desc/Text", arg0.taskOpenTF):GetComponent(typeof(Text))
	arg0.taskAwardTxt = arg0:findTF("top/desc1/Text", arg0.taskOpenTF):GetComponent(typeof(Text))
	arg0.taskProgressTxt = arg0:findTF("top/progress", arg0.taskOpenTF):GetComponent(typeof(Text))
	arg0.taskProgressBar = arg0:findTF("top/progress_bar", arg0.taskOpenTF)
	arg0.privateTaskDesc = arg0:findTF("bottom/desc", arg0.taskOpenTF):GetComponent(typeof(Text))
	arg0.privateTaskGetBtn = arg0:findTF("bottom/get", arg0.taskOpenTF)
	arg0.privateTaskAcceptBtn = arg0:findTF("bottom/accept", arg0.taskOpenTF)
	arg0.privateTaskProgressTxt = arg0:findTF("bottom/progress/Text", arg0.taskOpenTF):GetComponent(typeof(Text))
	arg0.privateTaskReapeatFlag = arg0:findTF("bottom/reapeat", arg0.taskOpenTF)
	arg0.privateTaskResTxt = arg0:findTF("bottom/res/Text", arg0.taskOpenTF):GetComponent(typeof(Text))
	arg0.taskMaskAll = arg0:findTF("TaskPanel/open/mask_all")
	arg0.taskMaskTop = arg0:findTF("TaskPanel/open/mask_top")
	arg0.contributionList = UIItemList.New(arg0:findTF("TaskPanel/SubmitPanel/list"), arg0:findTF("TaskPanel/SubmitPanel/list/tpl"))
	arg0.contributionCntTxt = arg0:findTF("TaskPanel/SubmitPanel/cnt/Text"):GetComponent(typeof(Text))
	arg0.supplyFrame = arg0:findTF("TaskPanel/SupplyPanel/frame")
	arg0.supplyOpenTF = arg0:findTF("TaskPanel/SupplyPanel/frame/open")
	arg0.supplyOpenTimeTxt = arg0:findTF("time", arg0.supplyOpenTF):GetComponent(typeof(Text))
	arg0.supplyOpenLetfCntTxt = arg0:findTF("Text", arg0.supplyOpenTF):GetComponent(typeof(Text))
	arg0.supplyOpenGetBtn = arg0:findTF("get", arg0.supplyOpenTF)
	arg0.supplyOpenGotBtn = arg0:findTF("got", arg0.supplyOpenTF)
	arg0.supplyUnOpenTF = arg0:findTF("TaskPanel/SupplyPanel/frame/unopen")
	arg0.supplyUnOpenAdminTF = arg0:findTF("purchase", arg0.supplyUnOpenTF)
	arg0.supplyUnOpenResTF = arg0.supplyUnOpenAdminTF:Find("Text"):GetComponent(typeof(Text))
	arg0.supplyUnOpenLockTF = arg0:findTF("lock", arg0.supplyUnOpenTF)
end

function var0.OnInit(arg0)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.taskTF, {
		pbList = {
			arg0.taskTF
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})
	onButton(arg0, arg0.supplyUnOpenAdminTF, function()
		local var0 = arg0.guild:getSupplyConsume()

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_start_supply_consume_tip", var0),
			onYes = function()
				arg0:emit(GuildOfficeMediator.ON_PURCHASE_SUPPLY)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.supplyOpenGetBtn, function()
		arg0:emit(GuildOfficeMediator.GET_SUPPLY_AWARD)
	end, SFX_PANEL)
	onButton(arg0, arg0.supplyFrame, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_supply_help_tip.tip
		})
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1, arg2)
	arg0:OnUpdateGuild(arg1, arg2)
	arg0:UpdateTaskPanel(false)
	arg0:UpdateContributionPanel()
	arg0:UpdateSupplyPanel()
	arg0:Show()
end

function var0.OnUpdateGuild(arg0, arg1, arg2)
	arg0.guild = arg1
	arg0.isAdmin = arg2
end

function var0.OnUpdateContribution(arg0)
	arg0:UpdateContributionPanel()
end

function var0.OnUpdateTask(arg0, arg1)
	arg0:UpdateTaskPanel(arg1)
end

function var0.OnUpdateSupplyPanel(arg0)
	arg0:UpdateSupplyPanel()
end

function var0.UpdateTaskPanel(arg0, arg1)
	local var0 = arg0.guild
	local var1 = var0:getWeeklyTask()
	local var2 = var1:getState()

	if var2 == GuildTask.STATE_EMPTY then
		arg0:UpdateLockTask()
	elseif var2 == GuildTask.STATE_ONGOING or var2 == GuildTask.STATE_FINISHED then
		arg0:UpdatePubliceTask(var1)
		arg0:UpdatePrivateTask(var1)
	end

	setActive(arg0.taskOpenTF, var2 ~= GuildTask.STATE_EMPTY)
	setActive(arg0.taskUnOpenTF, var2 == GuildTask.STATE_EMPTY)

	if arg1 or var0:shouldRefreshWeeklyTaskProgress() then
		arg0:emit(GuildOfficeMediator.UPDATE_WEEKLY_TASK)
	end
end

function var0.UpdateLockTask(arg0)
	setActive(arg0.unOpenAdmin, arg0.isAdmin)
	setActive(arg0.unOpenUnAdmin, not arg0.isAdmin)

	if arg0.isAdmin then
		onButton(arg0, arg0.unOpenAdmin, function()
			arg0.selectTaskPage:ExecuteAction("Show", arg0.guild, arg0.isAdmin)
		end, SFX_PANEL)
	end
end

function var0.UpdatePrivateTask(arg0, arg1)
	local var0 = not arg0.guild:hasWeeklyTaskFlag()
	local var1 = arg1:GetPresonTaskId()
	local var2 = getProxy(TaskProxy)
	local var3 = var2:getTaskById(var1) or var2:getFinishTaskById(var1)
	local var4 = var3 ~= nil

	if not var4 then
		var3 = Task.New({
			id = var1
		})
	end

	arg0.privateTaskDesc.text = var3:getConfig("desc")
	arg0.privateTaskProgressTxt.text = var3.progress .. "/" .. var3:getConfig("target_num")
	arg0.privateTaskResTxt.text = arg1:GetPrivateAward()

	onButton(arg0, arg0.privateTaskAcceptBtn, function()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_task_accept", arg1:getConfig("name"), var3:getConfig("name"), var3:getConfig("name")),
			onYes = function()
				arg0:emit(GuildOfficeMediator.ON_ACCEPT_TASK, var1)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.privateTaskGetBtn, function()
		arg0:emit(GuildOfficeMediator.ON_SUBMIT_TASK, var1)
	end, SFX_PANEL)

	if var3:isFinish() and not var3:isReceive() and not var0 then
		arg0:emit(GuildOfficeMediator.ON_SUBMIT_TASK, var1)
	elseif not var4 and var0 then
		arg0:emit(GuildOfficeMediator.ON_ACCEPT_TASK, var1)
	end

	local var5 = not var0
	local var6 = arg1:isFinished() and (not var4 or not var0)

	setActive(arg0.taskMaskAll, var6)
	setActive(arg0.taskMaskTop, not var6 and arg1:isFinished())
	setActive(arg0.privateTaskReapeatFlag, var5)
	setActive(arg0.privateTaskResTxt.gameObject.transform.parent, not var5)
	setActive(arg0.privateTaskAcceptBtn, not var4 or var3:isReceive())
	setActive(arg0.privateTaskGetBtn, var4 and var3:isFinish() and not var3:isReceive())
	setActive(arg0.privateTaskProgressTxt.gameObject.transform.parent, var4 and not var3:isFinish())
end

function var0.UpdatePubliceTask(arg0, arg1)
	local var0 = arg1:getProgress()
	local var1 = arg1:getMaxProgress()

	arg0.taskProgressTxt.text = var0 .. "/<size=40>" .. var1 .. "</size>"

	setFillAmount(arg0.taskProgressBar, var0 / var1)

	arg0.taskDescTxt.text = var0
	arg0.taskAwardTxt.text = arg1:GetCurrCaptailAward()
end

function var0.UpdateContributionPanel(arg0)
	local var0 = arg0.guild
	local var1 = var0:getDonateTasks()
	local var2 = var0:getRemainDonateCnt() + var0:GetExtraDonateCnt()

	arg0.contributionList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]
			local var1 = GuildDonateCard.New(arg2)

			var1:update(var0)
			onButton(arg0, var1.commitBtn, function()
				local var0 = var0:getCommitItem()
				local var1 = Drop.New({
					type = var0[1],
					id = var0[2],
					count = var0[3]
				})
				local var2 = var1:GetResCntByAward(var0)
				local var3 = var2 < var0[3] and "#FF5C5CFF" or "#92FC63FF"

				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					content = i18n("guild_donate_tip", var1:getConfig("name"), var0[3], var2, var3),
					onYes = function()
						arg0:emit(GuildOfficeMediator.ON_COMMIT, var0.id)
					end
				})
			end, SFX_PANEL)
			setButtonEnabled(var1.commitBtn, var2 > 0)
		end
	end)
	arg0.contributionList:align(#var1)

	arg0.contributionCntTxt.text = i18n("guild_left_donate_cnt", var2)
end

function var0.UpdateSupplyPanel(arg0)
	local var0 = arg0.guild
	local var1 = var0:isOpenedSupply()

	setActive(arg0.supplyOpenTF, var1)
	setActive(arg0.supplyUnOpenTF, not var1)

	if not var1 then
		setActive(arg0.supplyUnOpenAdminTF, arg0.isAdmin)
		setActive(arg0.supplyUnOpenLockTF, not arg0.isAdmin)

		if arg0.isAdmin then
			arg0.supplyUnOpenResTF.text = var0:getSupplyConsume()
		end
	else
		local var2 = var0:getSupplyCnt()
		local var3 = var0:getSupplyLeftCnt()

		setActive(arg0.supplyOpenGetBtn, var2 > 0)
		setActive(arg0.supplyOpenGotBtn, var2 <= 0)

		if var3 < 0 then
			arg0.supplyOpenTimeTxt.text = i18n("guild_exist_unreceived_supply_award")
		else
			arg0.supplyOpenTimeTxt.text = i18n("guild_left_supply_day", var3)
		end

		arg0.supplyOpenLetfCntTxt.text = i18n1(var2 .. "/" .. GuildConst.MAX_SUPPLY_CNT)
	end
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.taskTF, arg0._tf)
	arg0.selectTaskPage:Destroy()
end

return var0

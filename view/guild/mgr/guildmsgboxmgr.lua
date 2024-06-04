pg = pg or {}
pg.GuildMsgBoxMgr = singletonClass("GuildMsgBoxMgr")

local var0 = pg.GuildMsgBoxMgr

function var0.Init(arg0, arg1)
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetUI("GuildMsgBoxUI", true, function(arg0)
		pg.DelegateInfo.New(arg0)

		arg0._go = arg0

		arg0._go:SetActive(false)

		arg0._tf = arg0._go.transform
		arg0.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0._go.transform:SetParent(arg0.UIOverlay.transform, false)

		arg0.confirmBtn = findTF(arg0._go, "frame/confirm_btn")
		arg0.cancelBtn = findTF(arg0._go, "frame/cancel_btn")

		setText(arg0.cancelBtn:Find("Text"), i18n("text_iknow"))
		setText(arg0.confirmBtn:Find("Text"), i18n("text_forward"))

		arg0.contextTxt = findTF(arg0._go, "frame/content/Text"):GetComponent(typeof(Text))

		pg.UIMgr.GetInstance():LoadingOff()

		arg0.isInited = true

		if arg1 then
			arg1()
		end
	end)
end

function var0.Notification(arg0, arg1)
	assert(arg1.condition)

	if arg1.condition() then
		if not arg0.isInited then
			arg0:Init(function()
				arg0:RefreshView(arg1)
			end)
		else
			arg0:RefreshView(arg1)
		end
	elseif arg1.OnNo then
		arg1.OnNo()
	end
end

function var0.RefreshView(arg0, arg1)
	arg0.settings = arg1

	setActive(arg0._tf, true)

	arg0.contextTxt.text = arg1.content or ""

	onButton(arg0, arg0.confirmBtn, function()
		if arg1.OnYes then
			arg1.OnYes()
		end

		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg1.OnNo then
			arg1.OnNo()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		if arg1.OnNo then
			arg1.OnNo()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0._go, "frame/close"), function()
		if arg1.OnNo then
			arg1.OnNo()
		end

		arg0:Hide()
	end, SFX_PANEL)
	pg.UIMgr:GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER,
		blurCamList = arg1.blurCamList
	})
	arg0._tf:SetAsLastSibling()
end

function var0.Close(arg0)
	if arg0._tf and isActive(arg0._tf) then
		arg0.settings = nil

		pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0.UIOverlay)
		setActive(arg0._tf, false)
	end
end

function var0.Hide(arg0)
	if arg0._tf and isActive(arg0._tf) and arg0.settings.OnHide then
		arg0.settings.OnHide()
	end

	arg0:Close()
end

function var0.Destroy(arg0)
	if arg0.isInited then
		pg.DelegateInfo.Dispose(arg0)

		arg0.isInited = nil

		Destroy(arg0._go)
	end
end

function var0.NotificationForGuildEvent(arg0, arg1)
	local var0 = getProxy(GuildProxy):getRawData()

	if var0 then
		local var1 = var0:GetActiveWeeklyTask()

		if var1 and arg1.id == var1:GetPresonTaskId() then
			arg0:Notification({
				condition = function()
					return var1:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_EVENT) and var1:PrivateBeFinished()
				end,
				content = i18n("guild_mission_complate", var1:GetPrivateTaskName()),
				OnYes = function()
					pg.m02:sendNotification(GuildMainMediator.SWITCH_TO_OFFICE)
				end
			})
		end
	end
end

function var0.OnBeginBattle(arg0)
	if not getProxy(GuildProxy) then
		return
	end

	local var0 = getProxy(GuildProxy):getRawData()

	if var0 then
		local var1 = var0:GetActiveWeeklyTask()

		arg0.taskFinished = var1 and var1:PrivateBeFinished() and var1:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_BATTLE)

		print("taskFinished : ", arg0.taskFinished)
	end
end

function var0.OnFinishBattle(arg0, arg1)
	if not getProxy(GuildProxy) then
		return
	end

	local var0 = getProxy(GuildProxy):getRawData()

	if var0 and arg1 and arg1.system >= SYSTEM_SCENARIO and arg1.system <= SYSTEM_WORLD then
		local var1 = var0:GetActiveWeeklyTask()
		local var2 = var1 and var1:PrivateBeFinished() and var1:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_BATTLE)

		if not arg0.taskFinished and var2 then
			arg0.shouldShowBattleTip = true
		end
	end

	arg0.taskFinished = nil
end

function var0.NotificationForBattle(arg0, arg1)
	if arg0.shouldShowBattleTip then
		local var0 = getProxy(GuildProxy):getRawData()
		local var1 = var0 and var0:GetActiveWeeklyTask()

		if var1 then
			local var2 = false

			seriesAsync({
				function(arg0)
					arg0:SubmitTask(function(arg0, arg1, arg2)
						var2 = arg0

						arg0()
					end)
				end,
				function(arg0)
					local var0 = var2 and "\n" .. i18n("guild_task_autoaccept_2", var1:GetPrivateTaskName()) or ""
					local var1 = getProxy(ChapterProxy):getActiveChapter()
					local var2 = {
						pg.UIMgr.CameraLevel
					}

					if var1 and var1:CheckChapterWin() then
						var2 = nil
					end

					arg0:Notification({
						condition = function()
							return true
						end,
						content = i18n("guild_mission_complate", var1:GetPrivateTaskName()) .. var0,
						OnYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end,
						blurCamList = var2,
						OnHide = arg1
					})
				end
			})
		elseif arg1 then
			arg1()
		end
	elseif arg1 then
		arg1()
	end

	arg0.shouldShowBattleTip = nil
end

function var0.NotificationForDailyBattle(arg0)
	if arg0.shouldShowBattleTip then
		local var0 = getProxy(GuildProxy):getRawData()
		local var1 = var0 and var0:GetActiveWeeklyTask()

		if var1 then
			local var2 = false

			seriesAsync({
				function(arg0)
					arg0:SubmitTask(function(arg0, arg1, arg2)
						var2 = arg0

						arg0()
					end)
				end,
				function()
					local var0 = var2 and "\n" .. i18n("guild_task_autoaccept_2", var1:GetPrivateTaskName()) or ""

					arg0:Notification({
						condition = function()
							return true
						end,
						content = i18n("guild_mission_complate", var1:GetPrivateTaskName()) .. var0,
						OnYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end
					})
				end
			})
		end
	end

	arg0.shouldShowBattleTip = nil
end

function var0.NotificationForWorld(arg0, arg1)
	if arg0.shouldShowBattleTip then
		local var0 = getProxy(GuildProxy):getRawData()
		local var1 = var0 and var0:GetActiveWeeklyTask()

		if var1 then
			local var2 = false

			seriesAsync({
				function(arg0)
					arg0:SubmitTask(function(arg0, arg1, arg2)
						var2 = arg0

						arg0()
					end)
				end,
				function()
					local var0 = var2 and "\n" .. i18n("guild_task_autoaccept_2", var1:GetPrivateTaskName()) or ""

					arg0:Notification({
						condition = function()
							return true
						end,
						content = i18n("guild_mission_complate", var1:GetPrivateTaskName()) .. var0,
						OnYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end,
						OnHide = arg1
					})
				end
			})
		elseif arg1 then
			arg1()
		end
	elseif arg1 then
		arg1()
	end

	arg0.shouldShowBattleTip = nil
end

function var0.GetShouldShowBattleTip(arg0)
	return arg0.shouldShowBattleTip
end

function var0.CancelShouldShowBattleTip(arg0)
	arg0.shouldShowBattleTip = nil
end

function var0.SubmitTask(arg0, arg1)
	arg1 = arg1 or function()
		return
	end

	local var0 = getProxy(GuildProxy):getRawData()

	if not var0 then
		arg1()

		return
	end

	local var1 = var0 and var0:GetActiveWeeklyTask()

	if not var1 then
		arg1()

		return
	end

	if var1 and var1:isFinished() then
		arg1()

		return
	end

	local var2 = var1:GetPresonTaskId()
	local var3 = getProxy(TaskProxy)
	local var4 = var3:getTaskById(var2) or var3:getFinishTaskById(var2)

	if var4 and not var4:isFinish() then
		arg1()

		return
	end

	if not var0:hasWeeklyTaskFlag() then
		arg1(false, false, var2)

		return
	end

	local var5 = false
	local var6 = {}

	if var4 and var4:isFinish() and not var4:isReceive() then
		table.insert(var6, function(arg0)
			pg.m02:sendNotification(GAME.SUBMIT_TASK, var2, function(arg0)
				var5 = arg0

				arg0()
			end)
		end)
	end

	table.insert(var6, function(arg0)
		local var0 = var3:getTaskById(var2) or var3:getFinishTaskById(var2)

		if var1 and not var1:isFinished() and (not var0 or var0 and var0:isFinish() and var0:isReceive()) then
			pg.m02:sendNotification(GAME.TRIGGER_TASK, var2, arg0)
		else
			arg0()
		end
	end)
	seriesAsync(var6, function()
		local var0 = var3:getTaskById(var2)

		arg1(var0 ~= nil, var5, var2)
	end)
end

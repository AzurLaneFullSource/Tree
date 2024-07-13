pg = pg or {}
pg.GuildMsgBoxMgr = singletonClass("GuildMsgBoxMgr")

local var0_0 = pg.GuildMsgBoxMgr

function var0_0.Init(arg0_1, arg1_1)
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetUI("GuildMsgBoxUI", true, function(arg0_2)
		pg.DelegateInfo.New(arg0_1)

		arg0_1._go = arg0_2

		arg0_1._go:SetActive(false)

		arg0_1._tf = arg0_1._go.transform
		arg0_1.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_1._go.transform:SetParent(arg0_1.UIOverlay.transform, false)

		arg0_1.confirmBtn = findTF(arg0_1._go, "frame/confirm_btn")
		arg0_1.cancelBtn = findTF(arg0_1._go, "frame/cancel_btn")

		setText(arg0_1.cancelBtn:Find("Text"), i18n("text_iknow"))
		setText(arg0_1.confirmBtn:Find("Text"), i18n("text_forward"))

		arg0_1.contextTxt = findTF(arg0_1._go, "frame/content/Text"):GetComponent(typeof(Text))

		pg.UIMgr.GetInstance():LoadingOff()

		arg0_1.isInited = true

		if arg1_1 then
			arg1_1()
		end
	end)
end

function var0_0.Notification(arg0_3, arg1_3)
	assert(arg1_3.condition)

	if arg1_3.condition() then
		if not arg0_3.isInited then
			arg0_3:Init(function()
				arg0_3:RefreshView(arg1_3)
			end)
		else
			arg0_3:RefreshView(arg1_3)
		end
	elseif arg1_3.OnNo then
		arg1_3.OnNo()
	end
end

function var0_0.RefreshView(arg0_5, arg1_5)
	arg0_5.settings = arg1_5

	setActive(arg0_5._tf, true)

	arg0_5.contextTxt.text = arg1_5.content or ""

	onButton(arg0_5, arg0_5.confirmBtn, function()
		if arg1_5.OnYes then
			arg1_5.OnYes()
		end

		arg0_5:Close()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.cancelBtn, function()
		if arg1_5.OnNo then
			arg1_5.OnNo()
		end

		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf, function()
		if arg1_5.OnNo then
			arg1_5.OnNo()
		end

		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, findTF(arg0_5._go, "frame/close"), function()
		if arg1_5.OnNo then
			arg1_5.OnNo()
		end

		arg0_5:Hide()
	end, SFX_PANEL)
	pg.UIMgr:GetInstance():BlurPanel(arg0_5._tf, false, {
		weight = LayerWeightConst.TOP_LAYER,
		blurCamList = arg1_5.blurCamList
	})
	arg0_5._tf:SetAsLastSibling()
end

function var0_0.Close(arg0_10)
	if arg0_10._tf and isActive(arg0_10._tf) then
		arg0_10.settings = nil

		pg.UIMgr:GetInstance():UnblurPanel(arg0_10._tf, arg0_10.UIOverlay)
		setActive(arg0_10._tf, false)
	end
end

function var0_0.Hide(arg0_11)
	if arg0_11._tf and isActive(arg0_11._tf) and arg0_11.settings.OnHide then
		arg0_11.settings.OnHide()
	end

	arg0_11:Close()
end

function var0_0.Destroy(arg0_12)
	if arg0_12.isInited then
		pg.DelegateInfo.Dispose(arg0_12)

		arg0_12.isInited = nil

		Destroy(arg0_12._go)
	end
end

function var0_0.NotificationForGuildEvent(arg0_13, arg1_13)
	local var0_13 = getProxy(GuildProxy):getRawData()

	if var0_13 then
		local var1_13 = var0_13:GetActiveWeeklyTask()

		if var1_13 and arg1_13.id == var1_13:GetPresonTaskId() then
			arg0_13:Notification({
				condition = function()
					return var1_13:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_EVENT) and var1_13:PrivateBeFinished()
				end,
				content = i18n("guild_mission_complate", var1_13:GetPrivateTaskName()),
				OnYes = function()
					pg.m02:sendNotification(GuildMainMediator.SWITCH_TO_OFFICE)
				end
			})
		end
	end
end

function var0_0.OnBeginBattle(arg0_16)
	if not getProxy(GuildProxy) then
		return
	end

	local var0_16 = getProxy(GuildProxy):getRawData()

	if var0_16 then
		local var1_16 = var0_16:GetActiveWeeklyTask()

		arg0_16.taskFinished = var1_16 and var1_16:PrivateBeFinished() and var1_16:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_BATTLE)

		print("taskFinished : ", arg0_16.taskFinished)
	end
end

function var0_0.OnFinishBattle(arg0_17, arg1_17)
	if not getProxy(GuildProxy) then
		return
	end

	local var0_17 = getProxy(GuildProxy):getRawData()

	if var0_17 and arg1_17 and arg1_17.system >= SYSTEM_SCENARIO and arg1_17.system <= SYSTEM_WORLD then
		local var1_17 = var0_17:GetActiveWeeklyTask()
		local var2_17 = var1_17 and var1_17:PrivateBeFinished() and var1_17:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_BATTLE)

		if not arg0_17.taskFinished and var2_17 then
			arg0_17.shouldShowBattleTip = true
		end
	end

	arg0_17.taskFinished = nil
end

function var0_0.NotificationForBattle(arg0_18, arg1_18)
	if arg0_18.shouldShowBattleTip then
		local var0_18 = getProxy(GuildProxy):getRawData()
		local var1_18 = var0_18 and var0_18:GetActiveWeeklyTask()

		if var1_18 then
			local var2_18 = false

			seriesAsync({
				function(arg0_19)
					arg0_18:SubmitTask(function(arg0_20, arg1_20, arg2_20)
						var2_18 = arg0_20

						arg0_19()
					end)
				end,
				function(arg0_21)
					local var0_21 = var2_18 and "\n" .. i18n("guild_task_autoaccept_2", var1_18:GetPrivateTaskName()) or ""
					local var1_21 = getProxy(ChapterProxy):getActiveChapter()
					local var2_21 = {
						pg.UIMgr.CameraLevel
					}

					if var1_21 and var1_21:CheckChapterWin() then
						var2_21 = nil
					end

					arg0_18:Notification({
						condition = function()
							return true
						end,
						content = i18n("guild_mission_complate", var1_18:GetPrivateTaskName()) .. var0_21,
						OnYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end,
						blurCamList = var2_21,
						OnHide = arg1_18
					})
				end
			})
		elseif arg1_18 then
			arg1_18()
		end
	elseif arg1_18 then
		arg1_18()
	end

	arg0_18.shouldShowBattleTip = nil
end

function var0_0.NotificationForDailyBattle(arg0_24)
	if arg0_24.shouldShowBattleTip then
		local var0_24 = getProxy(GuildProxy):getRawData()
		local var1_24 = var0_24 and var0_24:GetActiveWeeklyTask()

		if var1_24 then
			local var2_24 = false

			seriesAsync({
				function(arg0_25)
					arg0_24:SubmitTask(function(arg0_26, arg1_26, arg2_26)
						var2_24 = arg0_26

						arg0_25()
					end)
				end,
				function()
					local var0_27 = var2_24 and "\n" .. i18n("guild_task_autoaccept_2", var1_24:GetPrivateTaskName()) or ""

					arg0_24:Notification({
						condition = function()
							return true
						end,
						content = i18n("guild_mission_complate", var1_24:GetPrivateTaskName()) .. var0_27,
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

	arg0_24.shouldShowBattleTip = nil
end

function var0_0.NotificationForWorld(arg0_30, arg1_30)
	if arg0_30.shouldShowBattleTip then
		local var0_30 = getProxy(GuildProxy):getRawData()
		local var1_30 = var0_30 and var0_30:GetActiveWeeklyTask()

		if var1_30 then
			local var2_30 = false

			seriesAsync({
				function(arg0_31)
					arg0_30:SubmitTask(function(arg0_32, arg1_32, arg2_32)
						var2_30 = arg0_32

						arg0_31()
					end)
				end,
				function()
					local var0_33 = var2_30 and "\n" .. i18n("guild_task_autoaccept_2", var1_30:GetPrivateTaskName()) or ""

					arg0_30:Notification({
						condition = function()
							return true
						end,
						content = i18n("guild_mission_complate", var1_30:GetPrivateTaskName()) .. var0_33,
						OnYes = function()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end,
						OnHide = arg1_30
					})
				end
			})
		elseif arg1_30 then
			arg1_30()
		end
	elseif arg1_30 then
		arg1_30()
	end

	arg0_30.shouldShowBattleTip = nil
end

function var0_0.GetShouldShowBattleTip(arg0_36)
	return arg0_36.shouldShowBattleTip
end

function var0_0.CancelShouldShowBattleTip(arg0_37)
	arg0_37.shouldShowBattleTip = nil
end

function var0_0.SubmitTask(arg0_38, arg1_38)
	arg1_38 = arg1_38 or function()
		return
	end

	local var0_38 = getProxy(GuildProxy):getRawData()

	if not var0_38 then
		arg1_38()

		return
	end

	local var1_38 = var0_38 and var0_38:GetActiveWeeklyTask()

	if not var1_38 then
		arg1_38()

		return
	end

	if var1_38 and var1_38:isFinished() then
		arg1_38()

		return
	end

	local var2_38 = var1_38:GetPresonTaskId()
	local var3_38 = getProxy(TaskProxy)
	local var4_38 = var3_38:getTaskById(var2_38) or var3_38:getFinishTaskById(var2_38)

	if var4_38 and not var4_38:isFinish() then
		arg1_38()

		return
	end

	if not var0_38:hasWeeklyTaskFlag() then
		arg1_38(false, false, var2_38)

		return
	end

	local var5_38 = false
	local var6_38 = {}

	if var4_38 and var4_38:isFinish() and not var4_38:isReceive() then
		table.insert(var6_38, function(arg0_40)
			pg.m02:sendNotification(GAME.SUBMIT_TASK, var2_38, function(arg0_41)
				var5_38 = arg0_41

				arg0_40()
			end)
		end)
	end

	table.insert(var6_38, function(arg0_42)
		local var0_42 = var3_38:getTaskById(var2_38) or var3_38:getFinishTaskById(var2_38)

		if var1_38 and not var1_38:isFinished() and (not var0_42 or var0_42 and var0_42:isFinish() and var0_42:isReceive()) then
			pg.m02:sendNotification(GAME.TRIGGER_TASK, var2_38, arg0_42)
		else
			arg0_42()
		end
	end)
	seriesAsync(var6_38, function()
		local var0_43 = var3_38:getTaskById(var2_38)

		arg1_38(var0_43 ~= nil, var5_38, var2_38)
	end)
end

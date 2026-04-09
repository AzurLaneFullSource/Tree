local var0_0 = class("IslandActivityCheateTavernDailySignPage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.scrollCom = arg0_1.uiView:GetComponent("LScrollRect")

	function arg0_1.scrollCom.onInitItem(arg0_2)
		arg0_1:InitAward(tf(arg0_2))
	end

	function arg0_1.scrollCom.onUpdateItem(arg0_3, arg1_3)
		arg0_1:UpdateTask(arg0_3, tf(arg1_3))
	end

	onButton(arg0_1, arg0_1.uiGoBtn, function()
		arg0_1:emit(IslandMediator.RECORD_PLAYER_POS)
		arg0_1:emit(IslandMediator.OPEN_PAGE, "IslandCheaterTavernPrepareMainPage")
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.uiRankBtn, function()
		arg0_1:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = PlayRoomRankScene,
			mediator = PlayRoomRankMediator,
			data = {
				gameType = 101
			}
		}))
	end)
	setText(arg0_1.uiGoText, i18n("bar_ui_check1"))
	setText(arg0_1.uiGotText, i18n("bar_ui_check2"))
end

function var0_0.UpdateTaskData(arg0_6)
	arg0_6.taskVOs = arg0_6.actTaskProxy:getTaskById(arg0_6.activity.id)
	arg0_6.finishTaksVOs = arg0_6.actTaskProxy:getFinishTaskById(arg0_6.activity.id)
	arg0_6.taskDic = {}

	_.each(arg0_6.taskVOs, function(arg0_7)
		arg0_6.taskDic[arg0_7.id] = arg0_7
	end)
	_.each(arg0_6.finishTaksVOs, function(arg0_8)
		arg0_6.taskDic[arg0_8.id] = arg0_8
	end)
end

function var0_0.InitAward(arg0_9, arg1_9)
	return
end

function var0_0.UpdateTask(arg0_10, arg1_10, arg2_10)
	local var0_10 = tf(arg2_10)
	local var1_10 = arg1_10 + 1
	local var2_10 = arg0_10.taskGroup[var1_10]
	local var3_10 = arg0_10.taskDic[var2_10]
	local var4_10 = var0_10:Find("IslandItemTpl")
	local var5_10 = Drop.Create(arg0_10.taskConfig[var2_10].award_display[1])

	if var1_10 >= 1 then
		updateCustomDrop(var4_10, var5_10, {
			style = "island"
		})
		onButton(arg0_10, arg2_10, function()
			arg0_10:emit(IslandMediator.SHOW_MSG_BOX, {
				title = i18n("island_word_desc"),
				type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
				dropData = var5_10
			})
		end, SFX_PANEL)
		onButton(arg0_10, var0_10:Find("canget"), function()
			pg.m02:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
				inIsland = true,
				act_id = arg0_10.activity.id,
				task_ids = arg0_10:GetCanSubmitTaskIds()
			})
		end, SFX_PANEL)
	end

	setText(var0_10:Find("target"), "Day" .. tostring(var1_10))
	setActive(var0_10:Find("got"), var3_10 and var3_10:isOver())
	setActive(var0_10:Find("canget"), var3_10 and var3_10:getTaskStatus() == 1 and not var3_10:isOver())
	setActive(var0_10:Find("lock"), var3_10 and var3_10:getTaskStatus() == -1 and not var3_10:isOver())
end

function var0_0.OnDataSetting(arg0_13)
	arg0_13.actTaskProxy = getProxy(ActivityTaskProxy)
	arg0_13.taskGroup = underscore.flatten(arg0_13.activity:getConfig("config_data"))
	arg0_13.taskConfig = pg.task_data_template
end

function var0_0.OnFirstFlush(arg0_14)
	arg0_14.scrollCom:SetTotalCount(5)
end

function var0_0.OnUpdateFlush(arg0_15)
	arg0_15:UpdateTaskData()
	arg0_15.scrollCom:SetTotalCount(5)

	local var0_15 = PlayRoomTools.GetPtScrore(arg0_15:GetGameType())

	setText(arg0_15.uiPtNum, var0_15)

	local var1_15 = PlayRoomTools.GetPtScoreIcon(arg0_15:GetGameType())

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var1_15, "", arg0_15.uiPtIcon)
end

function var0_0.OnShowFlush(arg0_16)
	return
end

function var0_0.GetGameType(arg0_17)
	return 101
end

function var0_0.GetCanSubmitTaskIds(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18.taskVOs) do
		if iter1_18:getTaskStatus() == 1 and not iter1_18:isOver() then
			table.insert(var0_18, iter1_18.id)
		end
	end

	return var0_18
end

function var0_0.OnDestroy(arg0_19)
	ClearLScrollrect(arg0_19.scrollCom)
end

return var0_0

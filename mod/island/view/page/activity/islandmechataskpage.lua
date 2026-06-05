local var0_0 = class("IslandMechaTaskPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.item = arg0_1._tf:Find("bg/tasks/task")
	arg0_1.items = arg0_1._tf:Find("bg/tasks")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.timeTxt = arg0_1._tf:Find("bg/time/Text"):GetComponent(typeof(Text))
	arg0_1.descTxt = arg0_1._tf:Find("bg/desc"):GetComponent(typeof(Text))
	arg0_1.progressTxt = arg0_1._tf:Find("bg/progress"):GetComponent(typeof(Text))
	arg0_1.lookAllBtn = arg0_1._tf:Find("bg/look_all")
	arg0_1.preViewBtn = arg0_1._tf:Find("bg/preview")

	setText(arg0_1._tf:Find("bg/preview/Text"), i18n("island_mecha_task_preview"))
	setText(arg0_1._tf:Find("bg/look_all/Text"), i18n("island_mecha_task_look_all"))

	arg0_1.descPage = IslandMechaTaskDescPage.New(pg.UIMgr.GetInstance().OverlayMain, arg0_1.event)

	onButton(arg0_1, arg0_1.preViewBtn, function()
		pg.m02:sendNotification(IslandMediator.OPEN_MACHA_MODEL_PREVIEW)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.lookAllBtn, function()
		arg0_1.descPage:ExecuteAction("Show", arg0_1.activity:getStartTime(), arg0_1.activity:getDayIndex(), arg0_1.taskGroup)
	end, SFX_PANEL)
	arg0_1.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_1:UpdateTask(arg1_4, arg2_4)
		end
	end)
end

function var0_0.OnFirstFlush(arg0_5)
	IslandTaskActhelper.SetNonFirstEnter(arg0_5.activity.id)
end

function var0_0.OnDataSetting(arg0_6)
	arg0_6.nday = 0
	arg0_6.taskGroup = arg0_6.activity:getIslandConfig("config_data")
end

function var0_0.UpdateTask(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 + 1
	local var1_7 = arg2_7:Find("item")
	local var2_7 = arg0_7.taskGroup[arg0_7.nday][var0_7]
	local var3_7 = IslandTask.New({
		id = var2_7,
		process_list = {}
	})

	assert(var3_7, "without this task by id: " .. var2_7)

	local var4_7 = var3_7:GetAwards()[1]

	updateCustomDrop(var1_7, var4_7)
	onButton(arg0_7, var1_7, function()
		arg0_7:emit(IslandMediator.SHOW_MSG_BOX, {
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var4_7
		})
	end, SFX_PANEL)

	local var5_7 = arg2_7:Find("go_btn")
	local var6_7 = arg2_7:Find("get_btn")
	local var7_7 = arg2_7:Find("got_btn")
	local var8_7 = arg2_7:Find("un_finish")
	local var9_7, var10_7, var11_7 = IslandTaskActhelper.GetIslandTaskState(var2_7)

	setText(arg2_7:Find("description"), var3_7:getConfig("task_desc"))
	setText(arg2_7:Find("progressText"), var9_7 .. "/" .. var10_7)
	setSlider(arg2_7:Find("progress"), 0, var10_7, var9_7)

	local var12_7 = var3_7:GetTargetList()[1]
	local var13_7 = pg.island_task_target[var12_7.id]
	local var14_7 = tonumber(var13_7.tips)
	local var15_7 = tonumber(var13_7.jump_ui)
	local var16_7 = var14_7 or var15_7

	setActive(var8_7, var11_7 == 0 and not var16_7)
	setActive(var5_7, var11_7 == 0 and var16_7)
	setActive(var6_7, var11_7 == 1)
	setActive(var7_7, var11_7 == 2)
	onButton(arg0_7, var5_7, function()
		if not var16_7 then
			return
		end

		if var15_7 then
			arg0_7:_SkipBtn(var15_7)
		elseif var14_7 then
			local var0_9 = pg.island_world_objects[var14_7].mapId

			if IslandMainBtnTipHelper.IsUnlock("map") then
				arg0_7:_SkipObj(var14_7)
			end
		end
	end, SFX_PANEL)
	onButton(arg0_7, var6_7, function()
		pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = var2_7
		})
	end, SFX_PANEL)
end

function var0_0.UpdateAll(arg0_11)
	if not arg0_11.activity then
		return
	end

	arg0_11.nday = IslandTaskActhelper.GetNDay(arg0_11.activity)

	arg0_11:UpdateDay()
	arg0_11:UpdateDesc()
	arg0_11:UpdateProgress()

	local var0_11 = arg0_11.taskGroup[arg0_11.nday] or {}

	arg0_11.uilist:align(#var0_11)
end

function var0_0.OnUpdateFlush(arg0_12)
	arg0_12:UpdateAll()
end

function var0_0.OnShowFlush(arg0_13)
	arg0_13:UpdateAll()
end

function var0_0.UpdateDay(arg0_14)
	local var0_14 = arg0_14.activity:getConfig("time")
	local var1_14 = var0_14[2][1][2]
	local var2_14 = var0_14[2][1][3]
	local var3_14 = var0_14[3][1][2]
	local var4_14 = var0_14[3][1][3]

	arg0_14.timeTxt.text = string.format("%d.%d - %d.%d%s", var1_14, var2_14, var3_14, var4_14, i18n("island_draw_time_1"))
end

function var0_0.UpdateDesc(arg0_15)
	arg0_15.descTxt.text = i18n("island_mecha_task_description")
end

function var0_0.UpdateProgress(arg0_16)
	local var0_16 = arg0_16.nday
	local var1_16 = #arg0_16.taskGroup

	arg0_16.progressTxt.text = i18n("island_mecha_task_progress", var0_16, var1_16)
end

function var0_0.Hide(arg0_17)
	var0_0.super.Hide(arg0_17)

	if arg0_17.descPage and arg0_17.descPage:isShowing() then
		arg0_17.descPage:Hide()
	end
end

function var0_0.OnDestroy(arg0_18)
	if arg0_18.descPage then
		arg0_18.descPage:Destroy()

		arg0_18.descPage = nil
	end

	eachChild(arg0_18.items, function(arg0_19)
		Destroy(arg0_19)
	end)
end

function var0_0._SkipBtn(arg0_20, arg1_20)
	local var0_20 = pg.island_main_btns[arg1_20]

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_20.ability_id) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_taskjump_systemnoopen_tips"))

		return
	end

	if var0_20.open_page ~= "" then
		arg0_20:emit(IslandMediator.OPEN_PAGE, var0_20.open_page, var0_20.page_param)
	end
end

function var0_0._SkipObj(arg0_21, arg1_21)
	local var0_21 = pg.island_world_objects[arg1_21].mapId

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockMap(var0_21) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_taskjump_placenoopen_tips"))

		return
	end

	arg0_21:emit(IslandSeasonPage.CLOSE)

	if _IslandCore and var0_21 == _IslandCore:GetController():GetMapID() then
		return
	end

	arg0_21:emit(IslandBaseMediator.SWITCH_MAP, var0_21, pg.island_map[var0_21].born_object)
end

return var0_0

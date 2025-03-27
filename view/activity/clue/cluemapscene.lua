local var0_0 = class("ClueMapScene", import("view.base.BaseUI"))
local var1_0 = pg.activity_single_enemy
local var2_0 = pg.activity_clue

function var0_0.getUIName(arg0_1)
	return "ClueMapUI"
end

function var0_0.init(arg0_2)
	arg0_2.ui = arg0_2:findTF("ui")
	arg0_2.closeBtn = arg0_2:findTF("ui/top/back_button")
	arg0_2.homeBtn = arg0_2:findTF("ui/top/home_button")
	arg0_2.bgs = {
		arg0_2:findTF("bgs/bg1"),
		arg0_2:findTF("bgs/bg2"),
		arg0_2:findTF("bgs/bg3")
	}
	arg0_2.mapsSwitch = {
		arg0_2:findTF("ui/mapsSwitch/map1"),
		arg0_2:findTF("ui/mapsSwitch/map2"),
		arg0_2:findTF("ui/mapsSwitch/map3")
	}
	arg0_2.chapters = {
		arg0_2:findTF("ui/chapters/t1"),
		arg0_2:findTF("ui/chapters/t2"),
		arg0_2:findTF("ui/chapters/t3"),
		arg0_2:findTF("ui/chapters/t4")
	}
	arg0_2.chapterSp = arg0_2:findTF("ui/chapterSp")
	arg0_2.pt = arg0_2:findTF("ui/pt")
	arg0_2.explore = arg0_2:findTF("ui/exploreTarget")
	arg0_2.taskBtn = arg0_2:findTF("ui/taskBtn")
	arg0_2.bookBtn = arg0_2:findTF("ui/bookBtn")

	setText(arg0_2:findTF("total", arg0_2.pt), i18n("clue_pt_tip"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	arg0_3:ShowResUI()
	arg0_3:InitMapsSwitch()
	arg0_3:UpdateCluePanel()
	setText(arg0_3:findTF("Text", arg0_3.pt), arg0_3.ptData.count)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:StopBgm()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	setActive(arg0_3:findTF("tip", arg0_3.taskBtn), ClueTasksLayer.ShouldShowTip())
	onButton(arg0_3, arg0_3.taskBtn, function()
		arg0_3:emit(ClueMapMediator.OPEN_CLUE_TASk, function()
			if arg0_3._tf then
				setActive(arg0_3:findTF("tip", arg0_3.taskBtn), ClueTasksLayer.ShouldShowTip())

				arg0_3.ptActivity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_PT_ACT_ID)
				arg0_3.ptData = ActivityPtData.New(arg0_3.ptActivity)

				setText(arg0_3:findTF("Text", arg0_3.pt), arg0_3.ptData.count)

				arg0_3.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)

				setText(arg0_3:findTF("ticket/count", arg0_3.chapterSp), "X " .. arg0_3.activity.data1)
			end
		end)
	end, SFX_PANEL)
	setActive(arg0_3:findTF("tip", arg0_3.bookBtn), ClueBookLayer.ShouldShowTip())
	onButton(arg0_3, arg0_3.bookBtn, function()
		arg0_3:emit(ClueMapMediator.OPEN_CLUE_BOOK, function()
			if arg0_3._tf then
				arg0_3:UpdateCluePanel()
				setActive(arg0_3:findTF("tip", arg0_3.bookBtn), ClueBookLayer.ShouldShowTip())

				arg0_3.ptActivity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_PT_ACT_ID)
				arg0_3.ptData = ActivityPtData.New(arg0_3.ptActivity)

				setText(arg0_3:findTF("Text", arg0_3.pt), arg0_3.ptData.count)

				arg0_3.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)

				setText(arg0_3:findTF("ticket/count", arg0_3.chapterSp), "X " .. arg0_3.activity.data1)
			end
		end)
	end, SFX_PANEL)
	pg.NewStoryMgr.GetInstance():Play(arg0_3.enterStory)
	arg0_3:SubmitClueTask()
end

function var0_0.InitData(arg0_10)
	arg0_10.easyChapters = {}
	arg0_10.normalChapters = {}
	arg0_10.hardChapters = {}
	arg0_10.spChapter = nil

	for iter0_10, iter1_10 in ipairs(var1_0.all) do
		local var0_10 = var1_0[iter1_10]

		if var0_10.activity_type == 2 then
			if var0_10.type == 1 then
				table.insert(arg0_10.easyChapters, var0_10)
			elseif var0_10.type == 2 then
				table.insert(arg0_10.normalChapters, var0_10)
			elseif var0_10.type == 3 then
				table.insert(arg0_10.hardChapters, var0_10)
			elseif var0_10.type == 4 then
				arg0_10.spChapter = var0_10
			end
		end
	end

	arg0_10.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)
	arg0_10.ptActivity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_PT_ACT_ID)
	arg0_10.ptData = ActivityPtData.New(arg0_10.ptActivity)
	arg0_10.contextData.mapIndex = defaultValue(arg0_10.contextData.mapIndex, 1)
	arg0_10.submitGroupIds = {}
	arg0_10.canSubmitTaskIds = {}
	arg0_10.submitClueIds = {}

	for iter2_10, iter3_10 in pairs(var2_0.get_id_list_by_group) do
		local var1_10 = false

		for iter4_10, iter5_10 in ipairs(iter3_10) do
			local var2_10 = var2_0[iter5_10]
			local var3_10 = tonumber(var2_10.task_id)

			if getProxy(TaskProxy):getTaskVO(var3_10):getTaskStatus() == 1 then
				if not arg0_10.canSubmitTaskIds[iter2_10] then
					arg0_10.canSubmitTaskIds[iter2_10] = {}
					arg0_10.submitClueIds[iter2_10] = {}
				end

				table.insert(arg0_10.canSubmitTaskIds[iter2_10], var3_10)
				table.insert(arg0_10.submitClueIds[iter2_10], iter5_10)

				var1_10 = true
			end
		end

		if var1_10 then
			table.insert(arg0_10.submitGroupIds, iter2_10)
		end
	end

	local var4_10 = arg0_10.activity:getConfig("config_client")

	arg0_10.enterStory = var4_10.enterStory
	arg0_10.bgms = var4_10.bgm1
end

function var0_0.RefreshPtAndTicket(arg0_11)
	arg0_11.ptActivity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_PT_ACT_ID)
	arg0_11.ptData = ActivityPtData.New(arg0_11.ptActivity)

	setText(arg0_11:findTF("Text", arg0_11.pt), arg0_11.ptData.count)

	arg0_11.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)

	setText(arg0_11:findTF("ticket/count", arg0_11.chapterSp), "X " .. arg0_11.activity.data1)
end

function var0_0.ShowResUI(arg0_12)
	local var0_12 = getProxy(PlayerProxy):getRawData()

	arg0_12.goldMax = findTF(arg0_12._tf, "ui/top/res/gold/max"):GetComponent(typeof(Text))
	arg0_12.goldValue = findTF(arg0_12._tf, "ui/top/res/gold/Text"):GetComponent(typeof(Text))
	arg0_12.oilMax = findTF(arg0_12._tf, "ui/top/res/oil/max"):GetComponent(typeof(Text))
	arg0_12.oilValue = findTF(arg0_12._tf, "ui/top/res/oil/Text"):GetComponent(typeof(Text))
	arg0_12.gemValue = findTF(arg0_12._tf, "ui/top/res/gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_12, arg0_12.goldMax, arg0_12.goldValue, arg0_12.oilMax, arg0_12.oilValue, arg0_12.gemValue)
	onButton(arg0_12, findTF(arg0_12._tf, "ui/top/res/gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_12, findTF(arg0_12._tf, "ui/top/res/oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_12, findTF(arg0_12._tf, "ui/top/res/gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.UpdateCluePanel(arg0_16)
	local var0_16 = ActivityConst.Valleyhospital_ACT_ID
	local var1_16 = getProxy(PlayerProxy):getRawData().id
	local var2_16 = PlayerPrefs.GetInt("investigatingGroupId_" .. var0_16 .. "_" .. var1_16, 0)
	local var3_16 = true
	local var4_16
	local var5_16 = 0

	if var2_16 ~= 0 then
		local var6_16 = var2_0.get_id_list_by_group[var2_16]

		var4_16 = {
			var2_0[var6_16[1]],
			var2_0[var6_16[2]],
			var2_0[var6_16[3]]
		}
		var5_16 = getProxy(TaskProxy):getTaskVO(tonumber(var4_16[3].task_id)):getProgress()

		for iter0_16 = 1, 3 do
			if not getProxy(TaskProxy):getFinishTaskById(tonumber(var4_16[iter0_16].task_id)) then
				var3_16 = false

				break
			end
		end
	end

	if var3_16 then
		setText(arg0_16:findTF("target/Text", arg0_16.explore), i18n("clue_unselect_tip"))
	else
		setText(arg0_16:findTF("target/Text", arg0_16.explore), var4_16[1].unlock_desc .. var4_16[1].unlock_num .. "/" .. var4_16[2].unlock_num .. "/" .. var4_16[3].unlock_num .. i18n("clue_task_tip", var5_16))
	end
end

function var0_0.InitMapsSwitch(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.mapsSwitch) do
		onToggle(arg0_17, iter1_17, function(arg0_18)
			if arg0_18 then
				arg0_17.contextData.mapIndex = iter0_17

				for iter0_18 = 1, 3 do
					setActive(arg0_17.bgs[iter0_18], iter0_18 == iter0_17)

					arg0_17.mapsSwitch[iter0_18]:GetComponent(typeof(CanvasGroup)).alpha = iter0_18 == iter0_17 and 1 or 0.4
				end

				if iter0_17 == 1 then
					for iter1_18, iter2_18 in ipairs(arg0_17.chapters) do
						setActive(arg0_17:findTF("dusk", iter2_18), iter0_17 == 2)
						setActive(arg0_17:findTF("night", iter2_18), iter0_17 == 3)
						setActive(arg0_17:findTF("title", iter2_18), true)
						setActive(arg0_17:findTF("title2", iter2_18), false)
						onButton(arg0_17, iter2_18, function()
							arg0_17:OpenChapterLayer(arg0_17.easyChapters[iter1_18].id)
						end, SFX_PANEL)
					end
				elseif iter0_17 == 2 then
					for iter3_18, iter4_18 in ipairs(arg0_17.chapters) do
						setActive(arg0_17:findTF("dusk", iter4_18), iter0_17 == 2)
						setActive(arg0_17:findTF("night", iter4_18), iter0_17 == 3)
						setActive(arg0_17:findTF("title", iter4_18), true)
						setActive(arg0_17:findTF("title2", iter4_18), false)
						onButton(arg0_17, iter4_18, function()
							arg0_17:OpenChapterLayer(arg0_17.normalChapters[iter3_18].id)
						end, SFX_PANEL)
					end
				else
					for iter5_18, iter6_18 in ipairs(arg0_17.chapters) do
						setActive(arg0_17:findTF("dusk", iter6_18), iter0_17 == 2)
						setActive(arg0_17:findTF("night", iter6_18), iter0_17 == 3)
						setActive(arg0_17:findTF("title", iter6_18), false)
						setActive(arg0_17:findTF("title2", iter6_18), true)
						onButton(arg0_17, iter6_18, function()
							arg0_17:OpenChapterLayer(arg0_17.hardChapters[iter5_18].id)
						end, SFX_PANEL)
					end
				end

				setActive(arg0_17:findTF("dusk", arg0_17.chapterSp), iter0_17 == 2)
				setActive(arg0_17:findTF("night", arg0_17.chapterSp), iter0_17 == 3)
				GetImageSpriteFromAtlasAsync(pg.item_virtual_data_statistics[arg0_17.spChapter.enter_cost].icon, "", arg0_17:findTF("ticket/icon", arg0_17.chapterSp), false)

				arg0_17.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)

				setText(arg0_17:findTF("ticket/count", arg0_17.chapterSp), "X " .. arg0_17.activity.data1)
				onButton(arg0_17, arg0_17.chapterSp, function()
					arg0_17:OpenChapterLayer(arg0_17.spChapter.id)
				end, SFX_PANEL)
				pg.BgmMgr.GetInstance():Push(arg0_17.__cname, arg0_17.bgms[arg0_17.contextData.mapIndex])
			end
		end, SFX_PANEL)

		if arg0_17.contextData.mapIndex == iter0_17 then
			triggerToggle(iter1_17, true)
		end
	end
end

function var0_0.OpenChapterLayer(arg0_23, arg1_23)
	arg0_23:emit(ClueMapMediator.OPEN_STAGE, arg1_23)
end

function var0_0.SubmitClueTask(arg0_24)
	if #arg0_24.submitGroupIds > 0 then
		local var0_24 = ActivityConst.Valleyhospital_TASK_ID

		arg0_24:emit(ClueMapMediator.ON_TASK_SUBMIT_ONESTEP, var0_24, arg0_24.canSubmitTaskIds[arg0_24.submitGroupIds[1]], function(arg0_25)
			if arg0_25 then
				arg0_24:UpdateCluePanel()
				arg0_24:OpenSingleClueGroupPanel()
			end
		end)

		arg0_24.showClueGroupId = table.remove(arg0_24.submitGroupIds, 1)
	end
end

function var0_0.OpenSingleClueGroupPanel(arg0_26)
	arg0_26:emit(ClueMapMediator.OPEN_SINGLE_CLUE_GROUP, arg0_26.showClueGroupId, arg0_26.submitClueIds[arg0_26.showClueGroupId], function()
		arg0_26:SubmitClueTask()
		arg0_26:UpdateCluePanel()
		setActive(arg0_26:findTF("tip", arg0_26.bookBtn), ClueBookLayer.ShouldShowTip())
	end)
end

function var0_0.willExit(arg0_28)
	return
end

function var0_0.onBackPressed(arg0_29)
	arg0_29:StopBgm()
	arg0_29:closeView()
end

return var0_0

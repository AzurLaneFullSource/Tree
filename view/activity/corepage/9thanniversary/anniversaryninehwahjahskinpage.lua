local var0_0 = class("AnniversaryNineHwahJahSkinPage", import("view.activity.CorePage.OutPost.OutPostOmenPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.dayTF = arg0_1.bg:Find("total_progress/day")
	arg0_1.maxDayTF = arg0_1.bg:Find("total_progress/max_day")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnDetail = arg0_1.bg:Find("btn_detail")
	arg0_1.txtDetail = arg0_1.btnDetail:Find("detail")
	arg0_1.btnStory = arg0_1.bg:Find("btn_story")
	arg0_1.taskWindow = AnniversaryNineHwahJahTaskWindow.New(arg0_1._tf, arg0_1.event)

	setActive(arg0_1.item, false)

	arg0_1.progressLabel = arg0_1.bg:Find("total_progress/label_1")

	setText(arg0_1.progressLabel, i18n("Outpost_20250904_Progress"))
	setText(arg0_1.txtDetail, i18n("Outpost_20260514_Detail"))
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:playStory()
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = #arg0_3.taskGroup

	arg0_3.nday = arg0_3:getTaskIdx(arg0_3.activity)

	arg0_3:PlayStory()

	if arg0_3.dayTF then
		setText(arg0_3.dayTF, arg0_3.nday)
		setText(arg0_3.maxDayTF, "/" .. var0_3)
	end

	arg0_3.uilist:align(#arg0_3.taskGroup[arg0_3.nday])

	if arg0_3.taskWindow:isShowing() then
		arg0_3.taskWindow:ExecuteAction("Show", arg0_3.activity)
	end
end

function var0_0.UpdateTask(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4 + 1
	local var1_4 = arg2_4:Find("item")
	local var2_4 = arg0_4.taskGroup[arg0_4.nday][var0_4]
	local var3_4 = arg0_4.taskProxy:getTaskById(var2_4) or arg0_4.taskProxy:getFinishTaskById(var2_4)

	assert(var3_4, "without this task by id: " .. var2_4)

	local var4_4 = Drop.Create(var3_4:getConfig("award_display")[1])

	updateDrop(var1_4, var4_4)
	onButton(arg0_4, var1_4, function()
		arg0_4:emit(BaseUI.ON_DROP, var4_4)
	end, SFX_PANEL)

	local var5_4 = var3_4:getProgress()
	local var6_4 = var3_4:getConfig("target_num")
	local var7_4 = var3_4:getConfig("desc")

	if utf8.len(var7_4) >= 11 then
		setScrollText(arg2_4:Find("mask/description"), var7_4)
	else
		setText(arg2_4:Find("mask/description"), var7_4)
	end

	local var8_4, var9_4 = arg0_4:GetProgressColor()
	local var10_4

	var10_4 = var8_4 and setColorStr(var5_4, var8_4) or var5_4

	local var11_4

	var11_4 = var9_4 and setColorStr("/" .. var6_4, var9_4) or "/" .. var6_4

	setText(arg2_4:Find("progressText"), var10_4 .. var11_4)
	setSlider(arg2_4:Find("progress"), 0, var6_4, var5_4)

	local var12_4 = arg2_4:Find("go_btn")
	local var13_4 = arg2_4:Find("get_btn")
	local var14_4 = arg2_4:Find("got_btn")
	local var15_4 = var3_4:getTaskStatus()

	setActive(var12_4, var15_4 == 0)
	setActive(var13_4, var15_4 == 1)
	setActive(var14_4, var15_4 == 2)
	onButton(arg0_4, var12_4, function()
		arg0_4:emit(ActivityMediator.ON_TASK_GO, var3_4)
	end, SFX_PANEL)
	onButton(arg0_4, var13_4, function()
		local var0_7 = {}
		local var1_7 = var3_4:getConfig("award_display")
		local var2_7 = getProxy(PlayerProxy):getRawData()
		local var3_7 = pg.gameset.urpt_chapter_max.description[1]
		local var4_7 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_7)
		local var5_7, var6_7 = Task.StaticJudgeOverflow(var2_7.gold, var2_7.oil, var4_7, true, true, var1_7)

		if var5_7 then
			table.insert(var0_7, function(arg0_8)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_7,
					onYes = arg0_8
				})
			end)
		end

		seriesAsync(var0_7, function()
			arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var3_4)
		end)
	end, SFX_PANEL)
end

function var0_0.playStory(arg0_10)
	arg0_10.storyList = arg0_10.activity:getConfig("config_client").story

	if not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_10.storyList[1][1]) then
		local var0_10, var1_10 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0_10.storyList[1][1])

		pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
			storyIds = {
				var0_10
			}
		})
	end
end

return var0_0

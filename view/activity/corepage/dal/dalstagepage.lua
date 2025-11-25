local var0_0 = class("DALStagePage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.tabs = arg0_1.AD:Find("tabs")
	arg0_1.tabsList = arg0_1.tabs.transform.childCount

	setText(arg0_1.AD:Find("headline_bg/Text (Legacy)"), i18n("DAL_story_tip"))
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.config_data = arg0_2.activity:getConfig("config_data")
	arg0_2.config_client = arg0_2.activity:getConfig("config_client").story
end

function var0_0.OnUpdateFlush(arg0_3)
	for iter0_3 = 1, #arg0_3.config_data do
		local var0_3 = arg0_3.taskProxy:getTaskVO(arg0_3.config_data[iter0_3]):getTaskStatus()

		SetActive(arg0_3.AD:Find("tabs/" .. iter0_3 .. "/got_red"), var0_3 == 2)
		SetActive(arg0_3.AD:Find("tabs/" .. iter0_3 .. "/red"), var0_3 == 1)

		if var0_3 == 2 and not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_3.config_client[iter0_3][1]) then
			local var1_3, var2_3 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0_3.config_client[iter0_3][1])

			pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
				storyIds = {
					var1_3
				},
				callback = callback
			})
		end
	end

	local var3_3 = -1

	for iter1_3 = 0, arg0_3.tabsList - 1 do
		onToggle(arg0_3, arg0_3.tabs:GetChild(iter1_3), function(arg0_4)
			if arg0_4 then
				if var3_3 ~= iter1_3 then
					arg0_3:OnUpdata(iter1_3 + 1)
				end

				var3_3 = iter1_3
			end
		end, SFX_PANEL)
	end

	triggerToggle(arg0_3.tabs:Find("1"), true)
end

function var0_0.OnUpdata(arg0_5, arg1_5)
	setText(arg0_5.AD:Find("id"), "0" .. arg1_5)
	setText(arg0_5.AD:Find("id/Text"), i18n("dal_story_tip_name_en_" .. arg1_5))
	setText(arg0_5.AD:Find("go/name"), i18n("text_goto"))
	setImageSprite(arg0_5.AD:Find("Image"), LoadSprite("ui/DALStagePage_atlas", arg1_5), true)

	local var0_5 = arg0_5.taskProxy:getTaskVO(arg0_5.config_data[arg1_5])

	setText(arg0_5.AD:Find("Image/lock/Text"), var0_5:getConfig("desc"))
	setText(arg0_5.AD:Find("Text"), var0_5:getConfig("name"))

	local var1_5 = var0_5:getConfig("award_display")[1]
	local var2_5 = {
		type = var1_5[1],
		id = var1_5[2],
		count = var1_5[3]
	}

	updateDrop(arg0_5.AD:Find("award"), var2_5)
	onButton(arg0_5, arg0_5.AD:Find("award/icon_mask"), function()
		arg0_5:emit(BaseUI.ON_DROP, var2_5)
	end, SFX_PANEL)

	local var3_5 = var0_5:getTaskStatus()

	SetActive(arg0_5.AD:Find("award/lock"), var3_5 == 2)
	SetActive(arg0_5.AD:Find("play"), var3_5 == 1 and not arg0_5.IsPlayeds)
	SetActive(arg0_5.AD:Find("go"), var3_5 == 0)
	SetActive(arg0_5.AD:Find("Image/lock"), var3_5 == 0)
	onButton(arg0_5, arg0_5.AD:Find("play"), function()
		pg.NewStoryMgr.GetInstance():Play(arg0_5.config_client[arg1_5][1], function()
			arg0_5:emit(ActivityMediator.ON_TASK_SUBMIT, var0_5)
		end, true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.AD:Find("go"), function()
		arg0_5:emit(ActivityMediator.ON_TASK_GO, var0_5)
	end, SFX_PANEL)

	if var3_5 == 0 then
		setText(arg0_5.AD:Find("rule"), i18n("dal_story_tip1"))
	elseif var3_5 == 1 then
		setText(arg0_5.AD:Find("rule"), i18n("dal_story_tip2"))
	elseif var3_5 == 2 then
		setText(arg0_5.AD:Find("rule"), i18n("dal_story_tip3"))
	end
end

return var0_0

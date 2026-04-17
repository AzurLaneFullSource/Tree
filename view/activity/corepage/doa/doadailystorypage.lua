local var0_0 = class("DOADailyStoryPage", import("view.activity.CorePage.CoreActivityPage"))
local var1_0 = "event_icon"

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.Image = arg0_1.AD:Find("Image")
	arg0_1.pageLock = arg0_1.Image:Find("lock")
	arg0_1.lockTxt = arg0_1.pageLock:Find("Text"):GetComponent("RichText")
	arg0_1.playCombo = arg0_1.AD:Find("playCombo")
	arg0_1.playShow = arg0_1.playCombo:Find("line_on")
	arg0_1.playShowBtn = arg0_1.playShow:Find("play")
	arg0_1.playShowTxt = arg0_1.playShow:Find("Text")
	arg0_1.playClose = arg0_1.playCombo:Find("line_off")
	arg0_1.playCloseTxt1 = arg0_1.playClose:Find("Text")
	arg0_1.playCloseTxt2 = arg0_1.playClose:Find("tip/rule")
	arg0_1.award = arg0_1.playCombo:Find("award")
	arg0_1.gotAward = arg0_1.award:Find("got")
	arg0_1.lockAward = arg0_1.award:Find("lock")
	arg0_1.tabTitle = arg0_1.AD:Find("tabTitle")
	arg0_1.titleTxt1 = arg0_1.tabTitle:Find("title")
	arg0_1.titleTxt2 = arg0_1.tabTitle:Find("normalTitle")
	arg0_1.tabs = arg0_1.AD:Find("tabs")
	arg0_1.tabsListCount = arg0_1.tabs.transform.childCount
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.config_data = arg0_2.activity:getConfig("config_data")
	arg0_2.config_client = arg0_2.activity:getConfig("config_client").story

	arg0_2:InitLocalText()
	arg0_2:OnUpdateFlush()
	arg0_2:OnShowFlush()
end

function var0_0.InitLocalText(arg0_3)
	setText(arg0_3.playCloseTxt2, i18n("doa3_activityPageUI_2"))
	setText(arg0_3.playCloseTxt1, i18n("doa3_activityPageUI_3"))
	setText(arg0_3.titleTxt2, i18n("doa3_activityPageUI_4"))
	setText(arg0_3.playShowTxt, i18n("doa3_activityPageUI_5"))

	local var0_3 = GetSpriteFromAtlas("ui/DOADailyStoryPage_atlas", "icon")

	arg0_3.lockTxt:AddSprite(var1_0, var0_3)
end

function var0_0.OnShowFlush(arg0_4)
	if arg0_4.tabs and arg0_4.config_data then
		triggerToggle(arg0_4.tabs:Find("1"), true)
		arg0_4:OnUpdata(1)
	end
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = -1

	for iter0_5 = 1, #arg0_5.config_data do
		local var1_5 = arg0_5.taskProxy:getTaskVO(arg0_5.config_data[iter0_5]):getTaskStatus()

		arg0_5:SetRedPoint(iter0_5, var1_5)

		local var2_5 = iter0_5

		if var1_5 == 2 and not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_5.config_client[iter0_5][1]) then
			local var3_5, var4_5 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0_5.config_client[iter0_5][1])

			pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
				storyIds = {
					var3_5
				},
				callback = callback
			})
		end
	end

	local var5_5 = -1

	for iter1_5 = 0, arg0_5.tabsListCount - 1 do
		onToggle(arg0_5, arg0_5.tabs:GetChild(iter1_5), function(arg0_6)
			if arg0_6 then
				if var5_5 ~= iter1_5 then
					arg0_5:OnUpdata(iter1_5 + 1)
				end

				var5_5 = iter1_5
			end
		end, SFX_PANEL)
	end
end

function var0_0.SetRedPoint(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.AD:Find("tabs/" .. arg1_7 .. "/red")

	setActive(var0_7, arg2_7 == 1)
end

function var0_0.OnUpdata(arg0_8, arg1_8)
	local var0_8 = arg0_8.taskProxy:getTaskVO(arg0_8.config_data[arg1_8])

	arg0_8:UpdataAward(var0_8)
	arg0_8:UpdateUI(arg1_8, var0_8)
	arg0_8:UpdataBtnInv(arg1_8, var0_8)
end

function var0_0.UpdataAward(arg0_9, arg1_9)
	local var0_9 = arg1_9:getConfig("award_display")[1]
	local var1_9 = {
		type = var0_9[1],
		id = var0_9[2],
		count = var0_9[3]
	}

	onButton(arg0_9, arg0_9.award, function()
		arg0_9:emit(BaseUI.ON_DROP, var1_9)
	end, SFX_PANEL)
	updateDrop(arg0_9.award, var1_9)
end

function var0_0.UpdataBtnInv(arg0_11, arg1_11, arg2_11)
	onButton(arg0_11, arg0_11.playShowBtn, function()
		pg.NewStoryMgr.GetInstance():Play(arg0_11.config_client[arg1_11][1], function()
			arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, arg2_11)
			arg0_11:OnUpdata(arg1_11)
		end, true)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.playClose, function()
		arg0_11:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.UpdateUI(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg2_15:getTaskStatus()
	local var1_15 = 0
	local var2_15 = 0
	local var3_15 = arg2_15:getProgress()
	local var4_15 = arg2_15:getConfig("target_num")

	setImageSprite(arg0_15.Image, LoadSprite("ui/DOADailyStoryPage_atlas", "page_img" .. arg1_15), true)
	setActive(arg0_15.pageLock, var0_15 == 0)

	arg0_15.lockTxt.text = string.format("%s<icon name=%s /> %d/%d", i18n("doa3_activityPageUI_1"), var1_0, var3_15, var4_15)

	setActive(arg0_15.playShow, var0_15 ~= 0)

	local var5_15 = pg.NewStoryMgr.GetInstance():IsPlayed(arg0_15.config_client[arg1_15][1])

	setActive(arg0_15.playShowBtn, var0_15 == 1 and not var5_15)
	setActive(arg0_15.playClose, var0_15 == 0)
	setText(arg0_15.titleTxt1, "0" .. arg1_15 .. arg2_15:getConfig("name"))
	setActive(arg0_15.gotAward, var0_15 == 2 or var5_15)
	setActive(arg0_15.lockAward, var0_15 == 0)
end

return var0_0

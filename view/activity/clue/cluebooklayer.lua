local var0_0 = class("ClueBookLayer", import("view.base.BaseUI"))
local var1_0 = pg.activity_clue
local var2_0 = pg.activity_clue_group
local var3_0 = pg.activity_clue_ending

function var0_0.getUIName(arg0_1)
	return "ClueBookUI"
end

function var0_0.init(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.pageTgs = {
		arg0_2:findTF("frame/toggles/sitePageTg"),
		arg0_2:findTF("frame/toggles/charaPageTg"),
		arg0_2:findTF("frame/toggles/endingPageTg"),
		arg0_2:findTF("frame/toggles/storyPageTg")
	}
	arg0_2.pages = arg0_2:findTF("frame/pages")
	arg0_2.sitePage = arg0_2:findTF("sitePage", arg0_2.pages)
	arg0_2.charaPage = arg0_2:findTF("charaPage", arg0_2.pages)
	arg0_2.endingPage = arg0_2:findTF("endingPage", arg0_2.pages)
	arg0_2.storyPage = arg0_2:findTF("storyPage", arg0_2.pages)
	arg0_2.award = arg0_2:findTF("frame/award")

	setText(arg0_2:findTF("Text", arg0_2.pageTgs[1]), i18n("clue_title_1"))
	setText(arg0_2:findTF("selected/Text", arg0_2.pageTgs[1]), i18n("clue_title_1"))
	setText(arg0_2:findTF("Text", arg0_2.pageTgs[2]), i18n("clue_title_2"))
	setText(arg0_2:findTF("selected/Text", arg0_2.pageTgs[2]), i18n("clue_title_2"))
	setText(arg0_2:findTF("Text", arg0_2.pageTgs[3]), i18n("clue_title_3"))
	setText(arg0_2:findTF("selected/Text", arg0_2.pageTgs[3]), i18n("clue_title_3"))
	setText(arg0_2:findTF("Text", arg0_2.pageTgs[4]), i18n("clue_title_4"))
	setText(arg0_2:findTF("selected/Text", arg0_2.pageTgs[4]), i18n("clue_title_4"))

	for iter0_2 = 1, 3 do
		setText(arg0_2:findTF("right/Viewport/Content/siteGroup" .. iter0_2 .. "/goBtn/Text", arg0_2.sitePage), i18n("clue_task_goto"))
	end

	setText(arg0_2:findTF("right/goBtn/Text", arg0_2.charaPage), i18n("clue_task_goto"))
	setText(arg0_2:findTF("doing/Text", arg0_2.award), i18n("clue_get"))
	setText(arg0_2:findTF("get/Text", arg0_2.award), i18n("clue_get"))
	setText(arg0_2:findTF("got/Text", arg0_2.award), i18n("clue_got"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:StopBgm()
		arg0_3:closeView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("mask"), function()
		arg0_3:StopBgm()
		arg0_3:closeView()
	end, SFX_PANEL)
	arg0_3:InitView()
	arg0_3:UpdateView()
	pg.BgmMgr.GetInstance():Push(arg0_3.__cname, arg0_3.bgm)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false)
end

function var0_0.InitData(arg0_6)
	arg0_6.activityId = ActivityConst.Valleyhospital_ACT_ID
	arg0_6.taskActivityId = ActivityConst.Valleyhospital_TASK_ID
	arg0_6.activity = getProxy(ActivityProxy):getActivityById(arg0_6.activityId)
	arg0_6.taskProxy = getProxy(TaskProxy)

	local var0_6 = arg0_6.activity:getConfig("config_client")

	arg0_6.clueSite = var0_6.clue_site
	arg0_6.clueChara = var0_6.clue_chara
	arg0_6.clueEnding = var0_6.clue_ending
	arg0_6.story = var0_6.story
	arg0_6.storyTaskId = var0_6.storyTaskId
	arg0_6.afterStory = var0_6.afterStory
	arg0_6.bgm = var0_6.bgm2
	arg0_6.pageIndex = 1
	arg0_6.subPageSiteIndex = 1
	arg0_6.subPageCharaIndex = 1
	arg0_6.subPageEndingIndex = 1
	arg0_6.endingIndex = 1
	arg0_6.storyIndex = 1
	arg0_6.playerId = getProxy(PlayerProxy):getRawData().id
	arg0_6.investigatingGroupId = PlayerPrefs.GetInt("investigatingGroupId_" .. arg0_6.activityId .. "_" .. arg0_6.playerId)
end

function var0_0.InitView(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.pageTgs) do
		setActive(arg0_7:findTF("selected", iter1_7), arg0_7.pageIndex == iter0_7)
		onToggle(arg0_7, iter1_7, function(arg0_8)
			if arg0_8 then
				arg0_7.pageIndex = iter0_7

				for iter0_8 = 0, arg0_7.pages.childCount - 1 do
					setActive(arg0_7.pages:GetChild(iter0_8), iter0_8 == iter0_7 - 1)
					setActive(arg0_7:findTF("tip", arg0_7.pageTgs[iter0_8 + 1]), var0_0.ShouldShowTip(iter0_8 + 1))
					setActive(arg0_7:findTF("selected", arg0_7.pageTgs[iter0_8 + 1]), arg0_7.pageIndex == iter0_8 + 1)
				end

				if iter0_7 == 1 then
					arg0_7:ShowSitePage()
				elseif iter0_7 == 2 then
					arg0_7:ShowCharaPage()
				elseif iter0_7 == 3 then
					arg0_7:ShowEndingPage()
				elseif iter0_7 == 4 then
					arg0_7:ShowStoryPage()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.UpdateView(arg0_9)
	triggerToggle(arg0_9.pageTgs[arg0_9.pageIndex], true)
end

function var0_0.SetClueGroup(arg0_10, arg1_10, arg2_10)
	local var0_10 = var2_0[arg1_10]
	local var1_10 = var1_0.get_id_list_by_group[arg1_10]
	local var2_10 = {
		var1_0[var1_10[1]],
		var1_0[var1_10[2]],
		var1_0[var1_10[3]]
	}
	local var3_10 = {}
	local var4_10 = arg0_10.taskProxy:getTaskVO(tonumber(var2_10[3].task_id)):getProgress()

	for iter0_10 = 1, 3 do
		var3_10[iter0_10] = arg0_10.taskProxy:getFinishTaskById(tonumber(var2_10[iter0_10].task_id))
	end

	setText(arg0_10:findTF("title/Text", arg2_10), var0_10.title)
	setActive(arg0_10:findTF("title/Text", arg2_10), var3_10[1] or var3_10[2] or var3_10[3])
	setActive(arg0_10:findTF("title/lock", arg2_10), not var3_10[1] and not var3_10[2] and not var3_10[3])
	LoadImageSpriteAsync("cluepictures/" .. var0_10.pic, arg0_10:findTF("picture", arg2_10), false)
	setActive(arg0_10:findTF("picture/lock", arg2_10), not var3_10[1] and not var3_10[2] and not var3_10[3])

	local var5_10 = false

	for iter1_10 = 1, 3 do
		if var3_10[iter1_10] then
			setText(arg0_10:findTF("clue" .. iter1_10, arg2_10), var2_10[iter1_10].desc)
		elseif arg0_10.investigatingGroupId == arg1_10 then
			setText(arg0_10:findTF("clue" .. iter1_10, arg2_10), "<color=#858593>" .. var2_10[iter1_10].unlock_desc .. var2_10[iter1_10].unlock_num .. i18n("clue_task_tip", var4_10) .. "</color>")
		elseif not var5_10 then
			var5_10 = true

			setText(arg0_10:findTF("clue" .. iter1_10, arg2_10), "<color=#858593>" .. var2_10[iter1_10].unlock_desc .. var2_10[iter1_10].unlock_num .. i18n("clue_task_tip", var4_10) .. "</color>")
		else
			setText(arg0_10:findTF("clue" .. iter1_10, arg2_10), "<color=#858593>？？？</color>")
		end
	end

	setActive(arg0_10:findTF("goBtn", arg2_10), not var3_10[1] or not var3_10[2] or not var3_10[3])
	setActive(arg0_10:findTF("goBtn/selected", arg2_10), arg0_10.investigatingGroupId == arg1_10)
	onButton(arg0_10, arg0_10:findTF("goBtn", arg2_10), function()
		arg0_10.investigatingGroupId = arg1_10

		PlayerPrefs.SetInt("investigatingGroupId_" .. arg0_10.activityId .. "_" .. arg0_10.playerId, arg1_10)
		setActive(arg0_10:findTF("goBtn/selected", arg2_10), true)

		if arg0_10.pageIndex == 1 then
			arg0_10:ShowSitePage()
		elseif arg0_10.pageIndex == 2 then
			arg0_10:ShowCharaPage()
		end

		arg0_10:OpenChapter(arg1_10)
	end, SFX_PANEL)
end

function var0_0.SetAward(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.taskProxy:getTaskVO(arg1_12)
	local var1_12 = var0_12:getConfig("award_display")[1]
	local var2_12 = {
		type = var1_12[1],
		id = var1_12[2],
		count = var1_12[3]
	}

	updateDrop(arg0_12:findTF("mask/IconTpl", arg0_12.award), var2_12)
	onButton(arg0_12, arg0_12:findTF("mask", arg0_12.award), function()
		arg0_12:emit(BaseUI.ON_DROP, var2_12)
	end, SFX_PANEL)

	local var3_12 = var0_12:getTaskStatus()

	setText(arg0_12:findTF("Text", arg0_12.award), var0_12:getConfig("desc"))
	setActive(arg0_12:findTF("mask/IconTpl/mask", arg0_12.award), var3_12 == 2)
	setActive(arg0_12:findTF("doing", arg0_12.award), var3_12 == 0)
	setActive(arg0_12:findTF("get", arg0_12.award), var3_12 == 1)
	setActive(arg0_12:findTF("got", arg0_12.award), var3_12 == 2)

	if arg2_12 then
		onButton(arg0_12, arg0_12:findTF("get", arg0_12.award), function()
			arg0_12:emit(ClueBookMediator.ON_TASK_SUBMIT_ONESTEP, arg0_12.taskActivityId, {
				arg1_12
			}, function(arg0_15)
				if arg0_15 then
					arg2_12()
				end
			end)
		end, SFX_PANEL)
	else
		onButton(arg0_12, arg0_12:findTF("get", arg0_12.award), function()
			local var0_16 = {}
			local var1_16 = var0_12:getConfig("award_display")
			local var2_16 = getProxy(PlayerProxy):getRawData()
			local var3_16 = pg.gameset.urpt_chapter_max.description[1]
			local var4_16 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_16)
			local var5_16, var6_16 = Task.StaticJudgeOverflow(var2_16.gold, var2_16.oil, var4_16, true, true, var1_16)

			if var5_16 then
				table.insert(var0_16, function(arg0_17)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var6_16,
						onYes = arg0_17
					})
				end)
			end

			seriesAsync(var0_16, function()
				arg0_12:emit(ClueBookMediator.ON_TASK_SUBMIT_ONESTEP, arg0_12.taskActivityId, {
					arg1_12
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.ShowSitePage(arg0_19)
	local var0_19 = UIItemList.New(arg0_19:findTF("left/Viewport/Content", arg0_19.sitePage), arg0_19:findTF("left/Viewport/Content/pageTg", arg0_19.sitePage))

	var0_19:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = arg0_19.clueSite[arg1_20 + 1]
			local var1_20 = tonumber(var2_0[var0_20[1]].task_id)
			local var2_20 = arg0_19.taskProxy:getTaskVO(var1_20):getTaskStatus()

			setText(arg2_20:Find("Text"), "PAGE  " .. string.format("%02d", arg1_20 + 1))
			setText(arg2_20:Find("selected/Text"), "PAGE  " .. string.format("%02d", arg1_20 + 1))
			setActive(arg2_20:Find("Text"), arg0_19.subPageSiteIndex ~= arg1_20 + 1)
			setActive(arg2_20:Find("selected"), arg0_19.subPageSiteIndex == arg1_20 + 1)
			setActive(arg2_20:Find("completed"), var2_20 == 2)
			setActive(arg2_20:Find("tip"), var2_20 == 1)
			onToggle(arg0_19, arg2_20, function(arg0_21)
				if arg0_21 then
					arg0_19.subPageSiteIndex = arg1_20 + 1

					for iter0_21 = 1, #arg0_19.clueSite do
						setActive(arg0_19:findTF("left/Viewport/Content", arg0_19.sitePage):GetChild(iter0_21 - 1):Find("Text"), arg0_19.subPageSiteIndex ~= iter0_21)
						setActive(arg0_19:findTF("left/Viewport/Content", arg0_19.sitePage):GetChild(iter0_21 - 1):Find("selected"), arg0_19.subPageSiteIndex == iter0_21)
					end

					for iter1_21 = 1, 3 do
						local var0_21 = var0_20[iter1_21]

						arg0_19:SetClueGroup(var0_21, arg0_19:findTF("right/Viewport/Content/siteGroup" .. iter1_21, arg0_19.sitePage))
					end

					arg0_19:SetAward(var1_20)
				end
			end, SFX_PANEL)

			if arg0_19.subPageSiteIndex == arg1_20 + 1 then
				triggerToggle(arg2_20, true)
			end
		end
	end)
	var0_19:align(#arg0_19.clueSite)
end

function var0_0.ShowCharaPage(arg0_22)
	local var0_22 = UIItemList.New(arg0_22:findTF("left/Viewport/Content", arg0_22.charaPage), arg0_22:findTF("left/Viewport/Content/pageTg", arg0_22.charaPage))

	var0_22:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = arg0_22.clueChara[arg1_23 + 1][1]
			local var1_23 = tonumber(var2_0[var0_23].task_id)
			local var2_23 = arg0_22.taskProxy:getTaskVO(var1_23):getTaskStatus()

			if arg0_22:GetGroupClueCompleteCount(var0_23) == 0 then
				setText(arg2_23:Find("Text"), "？？？")
				setText(arg2_23:Find("selected/Text"), "？？？")
			else
				setText(arg2_23:Find("Text"), var2_0[var0_23].title)
				setText(arg2_23:Find("selected/Text"), var2_0[var0_23].title)
			end

			setActive(arg2_23:Find("Text"), arg0_22.subPageCharaIndex ~= arg1_23 + 1)
			setActive(arg2_23:Find("selected"), arg0_22.subPageCharaIndex == arg1_23 + 1)
			setActive(arg2_23:Find("Text/completed"), var2_23 == 2)
			setActive(arg2_23:Find("selected/Text/completed"), var2_23 == 2)
			setActive(arg2_23:Find("tip"), var2_23 == 1)
			onToggle(arg0_22, arg2_23, function(arg0_24)
				if arg0_24 then
					arg0_22.subPageCharaIndex = arg1_23 + 1

					for iter0_24 = 1, #arg0_22.clueChara do
						setActive(arg0_22:findTF("left/Viewport/Content", arg0_22.charaPage):GetChild(iter0_24 - 1):Find("Text"), arg0_22.subPageCharaIndex ~= iter0_24)
						setActive(arg0_22:findTF("left/Viewport/Content", arg0_22.charaPage):GetChild(iter0_24 - 1):Find("selected"), arg0_22.subPageCharaIndex == iter0_24)
					end

					arg0_22:SetClueGroup(var0_23, arg0_22:findTF("right", arg0_22.charaPage))
					arg0_22:SetAward(var1_23)
				end
			end, SFX_PANEL)

			if arg0_22.subPageCharaIndex == arg1_23 + 1 then
				triggerToggle(arg2_23, true)
			end
		end
	end)
	var0_22:align(#arg0_22.clueChara)
	onScroll(arg0_22, arg0_22:findTF("left", arg0_22.charaPage), function(arg0_25)
		setActive(arg0_22:findTF("triangle", arg0_22.charaPage), arg0_25.y > 0.01)
	end)
end

function var0_0.GetGroupClueCompleteCount(arg0_26, arg1_26)
	local var0_26 = var1_0.get_id_list_by_group[arg1_26]
	local var1_26 = {
		var1_0[var0_26[1]],
		var1_0[var0_26[2]],
		var1_0[var0_26[3]]
	}
	local var2_26 = 0

	for iter0_26 = 1, 3 do
		if arg0_26.taskProxy:getFinishTaskById(tonumber(var1_26[iter0_26].task_id)) then
			var2_26 = var2_26 + 1
		end
	end

	return var2_26
end

function var0_0.ShowEndingPage(arg0_27)
	local var0_27 = UIItemList.New(arg0_27:findTF("left/Viewport/Content", arg0_27.endingPage), arg0_27:findTF("left/Viewport/Content/pageTg", arg0_27.endingPage))

	var0_27:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = arg0_27.clueEnding[arg1_28 + 1][1]
			local var1_28 = arg0_27.clueEnding[arg1_28 + 1][2]
			local var2_28 = arg0_27.taskProxy:getTaskVO(var1_28):getTaskStatus()

			setText(arg2_28:Find("Text"), var3_0[var0_28[#var0_28]].title2)
			setText(arg2_28:Find("selected/Text"), var3_0[var0_28[#var0_28]].title2)
			setActive(arg2_28:Find("Text"), arg0_27.subPageEndingIndex ~= arg1_28 + 1)
			setActive(arg2_28:Find("selected"), arg0_27.subPageEndingIndex == arg1_28 + 1)
			setActive(arg2_28:Find("Text/completed"), var2_28 == 2)
			setActive(arg2_28:Find("selected/Text/completed"), var2_28 == 2)

			local var3_28 = false

			if var2_28 == 1 then
				var3_28 = true
			else
				local var4_28 = true

				for iter0_28 = 1, #var0_28 do
					local var5_28 = var0_28[iter0_28]
					local var6_28 = var3_0[var5_28]
					local var7_28 = arg0_27.taskProxy:getTaskVO(tonumber(var6_28.task_id)):getTaskStatus()

					if var7_28 == 1 and var4_28 then
						var3_28 = true
					end

					if var7_28 ~= 2 then
						var4_28 = false
					end
				end
			end

			setActive(arg2_28:Find("tip"), var3_28)
			onToggle(arg0_27, arg2_28, function(arg0_29)
				if arg0_29 then
					arg0_27.subPageEndingIndex = arg1_28 + 1

					for iter0_29 = 1, #arg0_27.clueEnding do
						setActive(arg0_27:findTF("left/Viewport/Content", arg0_27.endingPage):GetChild(iter0_29 - 1):Find("Text"), arg0_27.subPageEndingIndex ~= iter0_29)
						setActive(arg0_27:findTF("left/Viewport/Content", arg0_27.endingPage):GetChild(iter0_29 - 1):Find("selected"), arg0_27.subPageEndingIndex == iter0_29)
					end

					table.sort(var0_28, function(arg0_30, arg1_30)
						local var0_30 = var3_0[arg0_30]
						local var1_30 = var3_0[arg1_30]

						return var0_30.unlock_pre < var1_30.unlock_pre
					end)

					local var0_29 = true

					for iter1_29 = 1, #var0_28 do
						local var1_29 = var0_28[iter1_29]
						local var2_29 = var3_0[var1_29]
						local var3_29 = arg0_27.taskProxy:getTaskVO(tonumber(var2_29.task_id)):getTaskStatus()

						setActive(arg0_27:findTF("right/ending" .. iter1_29 .. "/icon", arg0_27.endingPage), var0_29)
						setActive(arg0_27:findTF("right/ending" .. iter1_29 .. "/selected", arg0_27.endingPage), arg0_27.endingIndex == iter1_29)
						setActive(arg0_27:findTF("right/ending" .. iter1_29 .. "/lock", arg0_27.endingPage), not var0_29)
						setActive(arg0_27:findTF("right/ending" .. iter1_29 .. "/tip", arg0_27.endingPage), var3_29 == 1 and var0_29)

						arg0_27:findTF("right/ending" .. iter1_29, arg0_27.endingPage):GetComponent(typeof(CanvasGroup)).alpha = var0_29 and 1 or 0.8

						if var0_29 then
							setText(arg0_27:findTF("right/ending" .. iter1_29 .. "/title", arg0_27.endingPage), var2_29.title)
							onToggle(arg0_27, arg0_27:findTF("right/ending" .. iter1_29, arg0_27.endingPage), function(arg0_31)
								if arg0_31 then
									arg0_27.endingIndex = iter1_29

									for iter0_31 = 1, #var0_28 do
										setActive(arg0_27:findTF("right/ending" .. iter0_31 .. "/selected", arg0_27.endingPage), iter0_31 == arg0_27.endingIndex)
									end

									local var0_31 = var2_29.clue
									local var1_31 = var2_29.locate

									setText(arg0_27:findTF("middle/titleBg/Text", arg0_27.endingPage), var2_29.title2)
									setText(arg0_27:findTF("middle/endingDetail/Viewport/Content/detail", arg0_27.endingPage), var2_29.desc)
									onScroll(arg0_27, arg0_27:findTF("middle/endingDetail", arg0_27.endingPage), function(arg0_32)
										setActive(arg0_27:findTF("middle/triangle", arg0_27.endingPage), arg0_32.y > 0.01)
									end)
									setActive(arg0_27:findTF("right/combine", arg0_27.endingPage), var3_29 == 1)
									onButton(arg0_27, arg0_27:findTF("right/combine", arg0_27.endingPage), function()
										arg0_27:emit(ClueBookMediator.ON_TASK_SUBMIT_ONESTEP, arg0_27.taskActivityId, {
											tonumber(var2_29.task_id)
										})
									end, SFX_PANEL)
									setActive(arg0_27:findTF("middle/cluePanel", arg0_27.endingPage), var3_29 ~= 2)

									if var3_29 ~= 2 then
										local var2_31 = UIItemList.New(arg0_27:findTF("middle/cluePanel", arg0_27.endingPage), arg0_27:findTF("middle/cluePanel/clueGroup", arg0_27.endingPage))

										var2_31:make(function(arg0_34, arg1_34, arg2_34)
											if arg0_34 == UIItemList.EventUpdate then
												local var0_34 = var0_31[arg1_34 + 1]
												local var1_34 = var1_31[arg1_34 + 1][1]
												local var2_34 = var1_31[arg1_34 + 1][2]
												local var3_34 = var1_31[arg1_34 + 1][3]

												if var2_29.type == 1 then
													local var4_34 = var2_0[var0_34]

													for iter0_34 = 1, 4 do
														setActive(arg2_34:Find("" .. iter0_34), var1_34 == iter0_34)
													end

													setActive(arg2_34:Find("ending"), false)

													local var5_34 = arg2_34:GetChild(var1_34 - 1)
													local var6_34 = arg0_27:GetGroupClueCompleteCount(var0_34)

													var5_34:GetComponent(typeof(CanvasGroup)).alpha = var6_34 == 0 and 0.4 or 1

													if var6_34 == 0 then
														setText(arg0_27:findTF("name/Text", var5_34), "？？？")
													else
														setText(arg0_27:findTF("name/Text", var5_34), var4_34.title)
													end

													setText(arg0_27:findTF("progress", var5_34), var6_34 .. "/3")
													setActive(arg0_27:findTF("progress", var5_34), var6_34 == 1 or var6_34 == 2)
													setActive(arg0_27:findTF("complete", var5_34), var6_34 == 3)
													onButton(arg0_27, arg2_34, function()
														arg0_27:emit(ClueBookMediator.OPEN_SINGLE_CLUE_GROUP, var0_34)
													end, SFX_PANEL)
												else
													local var7_34 = var3_0[var0_34]

													setText(arg2_34:Find("ending/name"), var7_34.title2)

													for iter1_34 = 1, 4 do
														setActive(arg2_34:Find("" .. iter1_34), false)
													end

													setActive(arg2_34:Find("ending"), true)

													for iter2_34 = 1, 3 do
														setActive(arg2_34:Find("ending/icon" .. iter2_34), arg1_34 + 1 == iter2_34)
													end

													onButton(arg0_27, arg2_34, function()
														triggerToggle(arg0_27:findTF("right/ending" .. arg1_34 + 1, arg0_27.endingPage), true)
													end, SFX_PANEL)
												end

												arg2_34.anchoredPosition = Vector2(var2_34[1], var2_34[2])
												arg2_34.localScale = Vector3(var3_34, var3_34, 1)
											end
										end)
										var2_31:align(#var0_31)
									end
								end
							end, SFX_PANEL)
						else
							local var4_29 = "64646a"

							if iter1_29 == #var0_28 then
								var4_29 = "6683cf"
							end

							setText(arg0_27:findTF("right/ending" .. iter1_29 .. "/title", arg0_27.endingPage), "<color=#" .. var4_29 .. ">" .. var2_29.title .. "</color>")
							removeOnToggle(arg0_27:findTF("right/ending" .. iter1_29, arg0_27.endingPage))
						end

						if var3_29 ~= 2 then
							var0_29 = false
						end
					end

					triggerToggle(arg0_27:findTF("right/ending" .. arg0_27.endingIndex, arg0_27.endingPage), true)
					arg0_27:SetAward(var1_28)
				end
			end, SFX_PANEL)

			if arg0_27.subPageEndingIndex == arg1_28 + 1 then
				triggerToggle(arg2_28, true)
			end
		end
	end)
	var0_27:align(#arg0_27.clueEnding)
end

function var0_0.ShowStoryPage(arg0_37)
	local function var0_37()
		setText(arg0_37:findTF("pageIndex/Text", arg0_37.storyPage), arg0_37.storyIndex .. "/2")
		setActive(arg0_37:findTF("leftBtn", arg0_37.storyPage), arg0_37.storyIndex == 2)
		setActive(arg0_37:findTF("rightBtn", arg0_37.storyPage), arg0_37.storyIndex == 1)
		setActive(arg0_37:findTF("subPages/page1", arg0_37.storyPage), arg0_37.storyIndex == 1)
		setActive(arg0_37:findTF("subPages/page2", arg0_37.storyPage), arg0_37.storyIndex == 2)
	end

	var0_37()
	onButton(arg0_37, arg0_37:findTF("leftBtn", arg0_37.storyPage), function()
		arg0_37.storyIndex = 1

		var0_37()
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37:findTF("rightBtn", arg0_37.storyPage), function()
		arg0_37.storyIndex = 2

		var0_37()
	end, SFX_PANEL)

	for iter0_37 = 1, #arg0_37.story do
		local var1_37

		if iter0_37 <= 5 then
			var1_37 = arg0_37:findTF("subPages/page1", arg0_37.storyPage):GetChild(iter0_37 - 1)
		else
			var1_37 = arg0_37:findTF("subPages/page2", arg0_37.storyPage):GetChild(iter0_37 - 6)
		end

		local var2_37 = arg0_37.story[iter0_37]
		local var3_37 = var2_37[1]
		local var4_37 = var2_37[2]
		local var5_37 = var2_37[3]
		local var6_37 = var2_37[4]
		local var7_37 = arg0_37.taskProxy:getTaskVO(var5_37):getTaskStatus()

		if var3_37 == 1 then
			setText(arg0_37:findTF("lock/Text", var1_37), i18n("clue_lock_tip1"))
		else
			setText(arg0_37:findTF("lock/Text", var1_37), i18n("clue_lock_tip2", var3_0[var4_37].title))
		end

		setActive(arg0_37:findTF("lock", var1_37), var7_37 == 0)
		setActive(arg0_37:findTF("canGet", var1_37), var7_37 == 1)

		var1_37:GetComponent(typeof(CanvasGroup)).alpha = var7_37 == 0 and 0.4 or 1

		if var7_37 == 1 then
			onButton(arg0_37, var1_37, function()
				arg0_37:emit(ClueBookMediator.ON_TASK_SUBMIT_ONESTEP, arg0_37.taskActivityId, {
					var5_37
				}, function(arg0_42)
					if arg0_42 then
						pg.NewStoryMgr.GetInstance():Play(var6_37)
					end
				end)
			end, SFX_PANEL)
		elseif var7_37 == 2 then
			onButton(arg0_37, var1_37, function()
				pg.NewStoryMgr.GetInstance():Play(var6_37, nil, true)
			end, SFX_PANEL)
		else
			removeOnButton(var1_37)
		end
	end

	arg0_37:SetAward(arg0_37.storyTaskId, function()
		pg.NewStoryMgr.GetInstance():Play(arg0_37.afterStory)
	end)
end

function var0_0.OpenChapter(arg0_45, arg1_45)
	arg0_45:emit(ClueBookMediator.OPEN_CLUE_JUMP, arg1_45)
end

function var0_0.willExit(arg0_46)
	return
end

function var0_0.onBackPressed(arg0_47)
	arg0_47:StopBgm()
	arg0_47:closeView()
end

function var0_0.ShouldShowTip(arg0_48)
	local var0_48 = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)
	local var1_48 = getProxy(TaskProxy)
	local var2_48 = var0_48:getConfig("config_client")
	local var3_48 = var2_48.clue_site
	local var4_48 = var2_48.clue_chara
	local var5_48 = var2_48.clue_ending
	local var6_48 = var2_48.story
	local var7_48 = var2_48.storyTaskId

	if not arg0_48 or arg0_48 == 1 then
		for iter0_48 = 1, #var3_48 do
			local var8_48 = var3_48[iter0_48]
			local var9_48 = tonumber(var2_0[var8_48[1]].task_id)

			if var1_48:getTaskVO(var9_48):getTaskStatus() == 1 then
				return true
			end
		end
	end

	if not arg0_48 or arg0_48 == 2 then
		for iter1_48 = 1, #var4_48 do
			local var10_48 = var4_48[iter1_48][1]
			local var11_48 = tonumber(var2_0[var10_48].task_id)

			if var1_48:getTaskVO(var11_48):getTaskStatus() == 1 then
				return true
			end
		end
	end

	if not arg0_48 or arg0_48 == 3 then
		for iter2_48 = 1, #var5_48 do
			local var12_48 = var5_48[iter2_48][1]
			local var13_48 = var5_48[iter2_48][2]

			if var1_48:getTaskVO(var13_48):getTaskStatus() == 1 then
				return true
			end

			local var14_48 = true

			for iter3_48 = 1, #var12_48 do
				local var15_48 = var12_48[iter3_48]
				local var16_48 = var3_0[var15_48]
				local var17_48 = var1_48:getTaskVO(tonumber(var16_48.task_id)):getTaskStatus()

				if var17_48 == 1 and var14_48 then
					return true
				end

				if var17_48 ~= 2 then
					var14_48 = false
				end
			end
		end
	end

	if not arg0_48 or arg0_48 == 4 then
		if var1_48:getTaskVO(var7_48):getTaskStatus() == 1 then
			return true
		end

		for iter4_48 = 1, #var6_48 do
			local var18_48 = var6_48[iter4_48][3]

			if var1_48:getTaskVO(var18_48):getTaskStatus() == 1 then
				return true
			end
		end
	end

	return false
end

return var0_0

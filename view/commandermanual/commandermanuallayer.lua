local var0_0 = class("CommanderManualLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CommanderManualUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("blur_panel/top/CommonTitleAndBack/back_btn")
	arg0_2.helpBtn = arg0_2:findTF("blur_panel/top/helpBtn")
	arg0_2.taskBtn = arg0_2:findTF("blur_panel/panel/pageBtns/taskBtn")
	arg0_2.techBtn = arg0_2:findTF("blur_panel/panel/pageBtns/techBtn")
	arg0_2.guideBtn = arg0_2:findTF("blur_panel/panel/pageBtns/guideBtn")
	arg0_2.topBtns = {
		arg0_2.taskBtn,
		arg0_2.techBtn,
		arg0_2.guideBtn
	}
	arg0_2.pages = arg0_2:findTF("blur_panel/panel/pages")
	arg0_2.taskPage = arg0_2:findTF("blur_panel/panel/pages/taskPage")
	arg0_2.techPage = arg0_2:findTF("blur_panel/panel/pages/techPage")
	arg0_2.guidePage = arg0_2:findTF("blur_panel/panel/pages/guidePage")
	arg0_2.blurPanel = arg0_2._tf:Find("blur_panel")
	arg0_2.pageBg = arg0_2._tf:Find("blur_panel/panel/mask/pageBg")

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2.blurPanel, {
		pbList = {
			arg0_2.pageBg
		}
	})
	setText(arg0_2:findTF("blur_panel/top/CommonTitleAndBack/title"), i18n("handbook_name"))
	setText(arg0_2:findTF("blur_panel/top/CommonTitleAndBack/title/en"), "HANDBOOK")
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/go_btn/Text", arg0_2.taskPage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/get_btn/Text", arg0_2.taskPage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/got_btn/Text", arg0_2.taskPage), i18n("handbook_finished"))
	setText(arg0_2:findTF("page/ptPanel/go_btn/Text", arg0_2.taskPage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/ptPanel/get_btn/Text", arg0_2.taskPage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/ptPanel/got_btn/Text", arg0_2.taskPage), i18n("handbook_finished"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/go_btn/Text", arg0_2.techPage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/lock_btn/Text", arg0_2.techPage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/get_btn/Text", arg0_2.techPage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/got_btn/Text", arg0_2.techPage), i18n("handbook_finished"))
	setText(arg0_2:findTF("page/ptPanel/go_btn/Text", arg0_2.techPage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/ptPanel/get_btn/Text", arg0_2.techPage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/ptPanel/got_btn/Text", arg0_2.techPage), i18n("handbook_finished"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/content/descBg/go_btn/Text", arg0_2.guidePage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/content/descBg/get_btn/Text", arg0_2.guidePage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/normal/content/descBg/got_btn/Text", arg0_2.guidePage), i18n("handbook_finished"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/fold/descBg/go_btn/Text", arg0_2.guidePage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/fold/descBg/get_btn/Text", arg0_2.guidePage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/scroll/Viewport/Content/tpl/fold/descBg/got_btn/Text", arg0_2.guidePage), i18n("handbook_finished"))
	setText(arg0_2:findTF("page/ptPanel/go_btn/Text", arg0_2.guidePage), i18n("handbook_process"))
	setText(arg0_2:findTF("page/ptPanel/get_btn/Text", arg0_2.guidePage), i18n("handbook_claim"))
	setText(arg0_2:findTF("page/ptPanel/got_btn/Text", arg0_2.guidePage), i18n("handbook_finished"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.handbook_gametip.tip
		})
	end, SFX_PANEL)
	arg0_3:InitData()
	arg0_3:RefreshAll()
end

function var0_0.InitData(arg0_6)
	arg0_6.commanderManualProxy = getProxy(CommanderManualProxy)
	arg0_6.taskProxy = getProxy(TaskProxy)
	arg0_6.taskPages = arg0_6.commanderManualProxy:GetPagesByType(1)
	arg0_6.guidePages = arg0_6.commanderManualProxy:GetPagesByType(2)
	arg0_6.topTaskCfg = pg.tutorial_handbook[CommanderManualProxy.TOP_PAGE_TASK]
	arg0_6.topTechCfg = pg.tutorial_handbook[CommanderManualProxy.TOP_PAGE_TECH]
	arg0_6.topGuideCfg = pg.tutorial_handbook[CommanderManualProxy.TOP_PAGE_GUIDE]

	arg0_6:UpdateTechActivity()
end

function var0_0.UpdateTechActivity(arg0_7)
	arg0_7.techActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)

	if not arg0_7.techActivity or arg0_7.techActivity:isEnd() then
		return
	end

	local var0_7 = arg0_7.techActivity

	arg0_7.allTechPhase = #var0_7:getConfig("config_data")[3] + 1

	if var0_7.data1 == 0 then
		arg0_7.phaseId = "ready"
	else
		arg0_7.phaseId = var0_7.data1

		if arg0_7.phaseId == 1 and var0_7.data2 < 1 then
			arg0_7.phaseId = 0
		end
	end

	arg0_7.techFinishTaskId = arg0_7.phaseId ~= "ready" and var0_7:getConfig("config_data")[3][math.max(1, arg0_7.phaseId)][2] or nil
	arg0_7.finishPhaseDic = {}

	for iter0_7, iter1_7 in ipairs(var0_7.data1_list) do
		arg0_7.finishPhaseDic[iter1_7] = true
	end

	arg0_7.finishPhaseDic[0] = arg0_7.finishPhaseDic[1]
	arg0_7.finishPhaseDic[1] = var0_7.data2 == 1 and var0_7.data1 ~= 1
end

function var0_0.RefreshAll(arg0_8)
	local var0_8 = arg0_8.commanderManualProxy:IsTopUnlock(CommanderManualProxy.TOP_PAGE_TASK)
	local var1_8 = arg0_8.commanderManualProxy:IsTopUnlock(CommanderManualProxy.TOP_PAGE_TECH)
	local var2_8 = arg0_8.commanderManualProxy:IsTopUnlock(CommanderManualProxy.TOP_PAGE_GUIDE)

	setActive(arg0_8.taskBtn, not arg0_8.commanderManualProxy:IsTopPageComplete(1))

	local var3_8, var4_8 = TechnologyConst.isTecActOn()

	setActive(arg0_8.techBtn, var3_8)
	setActive(arg0_8:findTF("Text/lock", arg0_8.taskBtn), not var0_8)
	setActive(arg0_8:findTF("Text/lock", arg0_8.techBtn), not var1_8)
	setActive(arg0_8:findTF("Text/lock", arg0_8.guideBtn), not var2_8)
	setText(arg0_8:findTF("Text", arg0_8.taskBtn), var0_8 and arg0_8.topTaskCfg.name or arg0_8.topTaskCfg.lock_name)
	setText(arg0_8:findTF("Text", arg0_8.techBtn), var1_8 and arg0_8.topTechCfg.name or arg0_8.topTechCfg.lock_name)
	setText(arg0_8:findTF("Text", arg0_8.guideBtn), var2_8 and arg0_8.topGuideCfg.name or arg0_8.topGuideCfg.lock_name)
	setText(arg0_8:findTF("select/Text", arg0_8.taskBtn), arg0_8.topTaskCfg.name)
	setText(arg0_8:findTF("select/Text", arg0_8.techBtn), arg0_8.topTechCfg.name)
	setText(arg0_8:findTF("select/Text", arg0_8.guideBtn), arg0_8.topGuideCfg.name)
	setText(arg0_8:findTF("select/en", arg0_8.taskBtn), arg0_8.topTaskCfg.eng_name)
	setText(arg0_8:findTF("select/en", arg0_8.techBtn), arg0_8.topTechCfg.eng_name)
	setText(arg0_8:findTF("select/en", arg0_8.guideBtn), arg0_8.topGuideCfg.eng_name)
	setActive(arg0_8:findTF("tip", arg0_8.taskBtn), arg0_8.commanderManualProxy:ShouldShowTipByType(1))
	setActive(arg0_8:findTF("tip", arg0_8.techBtn), var4_8)
	setActive(arg0_8:findTF("tip", arg0_8.guideBtn), arg0_8.commanderManualProxy:ShouldShowTipByType(2))

	arg0_8.hasRefreshed = false

	onButton(arg0_8, arg0_8.taskBtn, function()
		if arg0_8.contextData.topIndex ~= 1 or not arg0_8.hasRefreshed then
			if var0_8 then
				arg0_8.contextData.topIndex = 1

				if arg0_8.hasRefreshed then
					arg0_8.contextData.currentPageId = nil
				end

				arg0_8:SetPagesActive(1)
				arg0_8:ShowTaskPage()

				for iter0_9, iter1_9 in ipairs(arg0_8.topBtns) do
					setActive(arg0_8:findTF("select", iter1_9), iter1_9 == arg0_8.taskBtn)
				end
			else
				local var0_9 = arg0_8.commanderManualProxy:GetLockTip(CommanderManualProxy.TOP_PAGE_TASK)

				if var0_9 and var0_9 ~= "" then
					pg.TipsMgr.GetInstance():ShowTips(var0_9)
				end
			end
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.techBtn, function()
		if arg0_8.contextData.topIndex ~= 2 or not arg0_8.hasRefreshed then
			if var1_8 then
				arg0_8.contextData.topIndex = 2

				if arg0_8.hasRefreshed then
					arg0_8.contextData.currentPageId = nil
				end

				arg0_8:SetPagesActive(2)
				arg0_8:ShowTechPage()

				for iter0_10, iter1_10 in ipairs(arg0_8.topBtns) do
					setActive(arg0_8:findTF("select", iter1_10), iter1_10 == arg0_8.techBtn)
				end
			else
				local var0_10 = arg0_8.commanderManualProxy:GetLockTip(CommanderManualProxy.TOP_PAGE_TECH)

				if var0_10 and var0_10 ~= "" then
					pg.TipsMgr.GetInstance():ShowTips(var0_10)
				end
			end
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.guideBtn, function()
		if arg0_8.contextData.topIndex ~= 3 or not arg0_8.hasRefreshed then
			if var2_8 then
				arg0_8.contextData.topIndex = 3

				if arg0_8.hasRefreshed then
					arg0_8.contextData.currentPageId = nil
				end

				arg0_8:SetPagesActive(3)
				arg0_8:ShowGuidePage()

				for iter0_11, iter1_11 in ipairs(arg0_8.topBtns) do
					setActive(arg0_8:findTF("select", iter1_11), iter1_11 == arg0_8.guideBtn)
				end
			else
				local var0_11 = arg0_8.commanderManualProxy:GetLockTip(CommanderManualProxy.TOP_PAGE_GUIDE)

				if var0_11 and var0_11 ~= "" then
					pg.TipsMgr.GetInstance():ShowTips(var0_11)
				end
			end
		end
	end, SFX_PANEL)

	if arg0_8.contextData.topIndex then
		triggerButton(arg0_8.topBtns[arg0_8.contextData.topIndex])

		arg0_8.hasRefreshed = true
	else
		local var5_8 = false

		for iter0_8, iter1_8 in ipairs(arg0_8.topBtns) do
			if isActive(iter1_8) and not isActive(arg0_8:findTF("Text/lock", iter1_8)) and isActive(arg0_8:findTF("tip", iter1_8)) then
				triggerButton(iter1_8)

				var5_8 = true
				arg0_8.hasRefreshed = true

				break
			end
		end

		if not var5_8 then
			for iter2_8, iter3_8 in ipairs(arg0_8.topBtns) do
				if isActive(iter3_8) and not isActive(arg0_8:findTF("Text/lock", iter3_8)) then
					triggerButton(iter3_8)

					arg0_8.hasRefreshed = true

					break
				end
			end
		end
	end
end

function var0_0.SetPagesActive(arg0_12, arg1_12)
	for iter0_12 = 1, arg0_12.pages.childCount do
		setActive(arg0_12.pages:GetChild(iter0_12 - 1), iter0_12 == arg1_12)
	end
end

function var0_0.ShowTaskPage(arg0_13)
	local var0_13 = UIItemList.New(arg0_13:findTF("subPageScroll/Viewport/Content", arg0_13.taskPage), arg0_13:findTF("subPageScroll/Viewport/Content/subPageBtn", arg0_13.taskPage))
	local var1_13 = UIItemList.New(arg0_13:findTF("page/scroll/Viewport/Content", arg0_13.taskPage), arg0_13:findTF("page/scroll/Viewport/Content/tpl", arg0_13.taskPage))
	local var2_13 = false

	var0_13:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_13.taskPages[arg1_14 + 1]

			setActive(arg2_14:Find("name/lock"), not var0_14.isUnlock)
			setActive(arg2_14:Find("tip"), var0_14:ShouldShowTip())
			setText(arg2_14:Find("name"), var0_14.isUnlock and var0_14:getConfig("name") or var0_14:getConfig("lock_name"))
			setText(arg2_14:Find("name/en"), var0_14:getConfig("eng_name"))
			setText(arg2_14:Find("select/name"), var0_14:getConfig("name"))
			setText(arg2_14:Find("select/name/en"), var0_14:getConfig("eng_name"))

			arg2_14:GetComponent(typeof(CanvasGroup)).alpha = var0_14.isUnlock and 1 or 0.5

			onButton(arg0_13, arg2_14, function()
				if var0_14.isUnlock then
					arg0_13.contextData.currentPageId = var0_14.id

					for iter0_15 = 1, arg0_13:findTF("subPageScroll/Viewport/Content", arg0_13.taskPage).childCount do
						setActive(arg0_13:findTF("select", arg0_13:findTF("subPageScroll/Viewport/Content", arg0_13.taskPage):GetChild(iter0_15 - 1)), iter0_15 == arg1_14 + 1)
						setActive(arg0_13:findTF("name", arg0_13:findTF("subPageScroll/Viewport/Content", arg0_13.taskPage):GetChild(iter0_15 - 1)), iter0_15 ~= arg1_14 + 1)

						arg0_13:findTF("tip", arg0_13:findTF("subPageScroll/Viewport/Content", arg0_13.taskPage):GetChild(iter0_15 - 1)).anchoredPosition = Vector2(iter0_15 == arg1_14 + 1 and -34.295 or 18, -2)
					end

					var0_14:SortTaskIdList()
					var1_13:make(function(arg0_16, arg1_16, arg2_16)
						if arg0_16 == UIItemList.EventUpdate then
							local var0_16 = var0_14.taskIdList[arg1_16 + 1]
							local var1_16 = pg.task_data_template[var0_16]
							local var2_16 = arg0_13.taskProxy:getTaskById(var0_16)

							setText(arg2_16:Find("normal/number"), string.format("NO.%02d", arg1_16 + 1))
							setText(arg2_16:Find("normal/desc"), var1_16.desc)

							local var3_16 = arg2_16:Find("normal/awards")
							local var4_16 = var3_16:GetChild(0)

							arg0_13:updateTaskAwards(var1_16.award_display, var3_16, var4_16)

							local var5_16 = var1_16.target_num
							local var6_16 = arg2_16:Find("normal/go_btn")
							local var7_16 = arg2_16:Find("normal/get_btn")
							local var8_16 = arg2_16:Find("normal/got_btn")
							local var9_16 = arg2_16:Find("normal")
							local var10_16 = arg2_16:Find("lock")

							if var2_16 then
								local var11_16 = var2_16:getProgress()
								local var12_16 = math.min(var11_16, var5_16)

								setText(arg2_16:Find("normal/progress"), var12_16 .. "/" .. var5_16)
								setSlider(arg2_16:Find("normal/slider"), 0, var5_16, var12_16)

								if var2_16:getTaskStatus() == 0 then
									setActive(var6_16, true)
									setActive(var7_16, false)
									setActive(var8_16, false)
								elseif var2_16:getTaskStatus() == 1 then
									setActive(var6_16, false)
									setActive(var7_16, true)
									setActive(var8_16, false)
								elseif var2_16:getTaskStatus() == 2 then
									setActive(var6_16, false)
									setActive(var7_16, false)
									setActive(var8_16, true)
								end

								onButton(arg0_13, var6_16, function()
									arg0_13:emit(CommanderManualMediator.ON_TASK_GO, var2_16)
								end, SFX_PANEL)
								onButton(arg0_13, var7_16, function()
									arg0_13:TaskAwardsCheckAndSubmit(var2_16)
								end, SFX_PANEL)
								setActive(var9_16, true)
								setActive(var10_16, false)
							elseif var0_14:IsTaskComplete(var0_16) then
								setText(arg2_16:Find("normal/progress"), var5_16 .. "/" .. var5_16)
								setSlider(arg2_16:Find("normal/slider"), 0, var5_16, var5_16)
								setActive(var6_16, false)
								setActive(var7_16, false)
								setActive(var8_16, true)
								setActive(var9_16, true)
								setActive(var10_16, false)
							else
								setText(arg2_16:Find("lock/lockBg/Text"), var0_14:GetTaskLockTip(var0_16))
								setActive(var9_16, false)
								setActive(var10_16, true)
							end

							arg2_16:GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_tpl_update")
						end
					end)
					var1_13:align(#var0_14.taskIdList)
					scrollTo(arg0_13:findTF("page/scroll", arg0_13.taskPage), 0, 1)
					arg0_13:SetPtPanel(arg0_13:findTF("page/ptPanel", arg0_13.taskPage), var0_14)
				else
					local var0_15 = var0_14:GetLockTip()

					if var0_15 and var0_15 ~= "" then
						pg.TipsMgr.GetInstance():ShowTips(var0_15)
					end
				end
			end, SFX_PANEL)

			if arg0_13.contextData.currentPageId == var0_14.id then
				var2_13 = true

				triggerButton(arg2_14)
			end

			if not arg0_13.contextData.currentPageId and var0_14.isUnlock and isActive(arg2_14:Find("tip")) then
				var2_13 = true
				arg0_13.contextData.currentPageId = var0_14.id

				triggerButton(arg2_14)
			end
		end
	end)
	var0_13:align(#arg0_13.taskPages)

	if not var2_13 then
		for iter0_13 = #arg0_13.taskPages, 1, -1 do
			if arg0_13.taskPages[iter0_13].isUnlock then
				triggerButton(arg0_13:findTF("subPageScroll/Viewport/Content", arg0_13.taskPage):GetChild(iter0_13 - 1))

				break
			end
		end
	end

	arg0_13:ShowBottomTip(arg0_13.taskPage, 1)
	onScroll(arg0_13, arg0_13.taskPage:Find("subPageScroll"), function(arg0_19)
		arg0_13:ShowBottomTip(arg0_13.taskPage, arg0_19.y)
	end)
end

function var0_0.ShowGuidePage(arg0_20)
	local var0_20 = UIItemList.New(arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage), arg0_20:findTF("subPageScroll/Viewport/Content/subPageBtn", arg0_20.guidePage))
	local var1_20 = UIItemList.New(arg0_20:findTF("page/scroll/Viewport/Content", arg0_20.guidePage), arg0_20:findTF("page/scroll/Viewport/Content/tpl", arg0_20.guidePage))
	local var2_20 = false

	var0_20:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = arg0_20.guidePages[arg1_21 + 1]

			setActive(arg2_21:Find("lock0/lock"), not var0_21.isUnlock)
			setActive(arg2_21:Find("tip"), var0_21:ShouldShowTip())
			arg2_21:Find("mask/name"):GetComponent("ScrollText"):SetText(var0_21.isUnlock and var0_21:getConfig("name") or var0_21:getConfig("lock_name"))
			setText(arg2_21:Find("en"), var0_21:getConfig("eng_name"))
			arg2_21:Find("select/mask/name"):GetComponent("ScrollText"):SetText(var0_21:getConfig("name"))
			setText(arg2_21:Find("select/en"), var0_21:getConfig("eng_name"))

			arg2_21:GetComponent(typeof(CanvasGroup)).alpha = var0_21.isUnlock and 1 or 0.5

			onButton(arg0_20, arg2_21, function()
				if var0_21.isUnlock then
					arg0_20.contextData.currentPageId = var0_21.id

					for iter0_22 = 1, arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage).childCount do
						setActive(arg0_20:findTF("select", arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage):GetChild(iter0_22 - 1)), iter0_22 == arg1_21 + 1)
						setActive(arg0_20:findTF("lock0", arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage):GetChild(iter0_22 - 1)), iter0_22 ~= arg1_21 + 1)
						setActive(arg0_20:findTF("mask", arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage):GetChild(iter0_22 - 1)), iter0_22 ~= arg1_21 + 1)
						setActive(arg0_20:findTF("en", arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage):GetChild(iter0_22 - 1)), iter0_22 ~= arg1_21 + 1)

						arg0_20:findTF("tip", arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage):GetChild(iter0_22 - 1)).anchoredPosition = Vector2(iter0_22 == arg1_21 + 1 and -34.295 or 18, -2)
					end

					var0_21:SortTaskIdList()
					var1_20:make(function(arg0_23, arg1_23, arg2_23)
						if arg0_23 == UIItemList.EventUpdate then
							local var0_23 = var0_21.taskIdList[arg1_23 + 1]
							local var1_23 = pg.task_data_template[var0_23]
							local var2_23 = arg0_20.taskProxy:getTaskById(var0_23)

							setText(arg2_23:Find("normal/number"), string.format("NO.%02d", arg1_23 + 1))
							setText(arg2_23:Find("normal/name"), var1_23.name)
							setText(arg2_23:Find("normal/content/descBg/desc"), var1_23.desc)
							LoadImageSpriteAsync(var1_23.tutorial_handbook_pic, arg2_23:Find("normal/content/picture"))
							setText(arg2_23:Find("fold/number"), string.format("NO.%02d", arg1_23 + 1))
							setText(arg2_23:Find("fold/name"), var1_23.name)
							setText(arg2_23:Find("fold/descBg/desc"), var1_23.desc)

							local var3_23 = arg2_23:Find("normal/content/descBg/go_btn")
							local var4_23 = arg2_23:Find("normal/content/descBg/get_btn")
							local var5_23 = arg2_23:Find("normal/content/descBg/got_btn")
							local var6_23 = arg2_23:Find("fold/descBg/go_btn")
							local var7_23 = arg2_23:Find("fold/descBg/get_btn")
							local var8_23 = arg2_23:Find("fold/descBg/got_btn")
							local var9_23 = arg2_23:Find("normal")
							local var10_23 = arg2_23:Find("fold")
							local var11_23 = arg2_23:Find("lock")
							local var12_23 = arg2_23:GetComponent(typeof(Animation))
							local var13_23 = arg2_23:GetComponent(typeof(DftAniEvent))

							if var2_23 then
								if var2_23:getTaskStatus() == 0 then
									setActive(var3_23, true)
									setActive(var4_23, false)
									setActive(var5_23, false)
									setActive(var6_23, true)
									setActive(var7_23, false)
									setActive(var8_23, false)
								elseif var2_23:getTaskStatus() == 1 then
									setActive(var3_23, false)
									setActive(var4_23, true)
									setActive(var5_23, false)
									setActive(var6_23, false)
									setActive(var7_23, true)
									setActive(var8_23, false)
								elseif var2_23:getTaskStatus() == 2 then
									setActive(var3_23, false)
									setActive(var4_23, false)
									setActive(var5_23, true)
									setActive(var6_23, false)
									setActive(var7_23, false)
									setActive(var8_23, true)
								end

								onButton(arg0_20, var3_23, function()
									arg0_20:emit(CommanderManualMediator.ON_TASK_GO, var2_23)
								end, SFX_PANEL)
								onButton(arg0_20, var4_23, function()
									arg0_20:TaskAwardsCheckAndSubmit(var2_23)
								end, SFX_PANEL)
								onButton(arg0_20, var6_23, function()
									arg0_20:emit(CommanderManualMediator.ON_TASK_GO, var2_23)
								end, SFX_PANEL)
								onButton(arg0_20, var7_23, function()
									arg0_20:TaskAwardsCheckAndSubmit(var2_23)
								end, SFX_PANEL)
								setActive(arg2_23:Find("normal/content/descBg/triangle"), false)
								setActive(var9_23, true)
								setActive(var10_23, false)
								setActive(var11_23, false)
							elseif var0_21:IsTaskComplete(var0_23) then
								setActive(var3_23, false)
								setActive(var4_23, false)
								setActive(var5_23, true)
								setActive(var6_23, false)
								setActive(var7_23, false)
								setActive(var8_23, true)
								setActive(arg2_23:Find("normal/content/descBg/triangle"), true)
								onButton(arg0_20, arg2_23:Find("normal/content/descBg/triangle"), function()
									setActive(var9_23, true)
									var13_23:SetEndEvent(function()
										setActive(var9_23, false)
										setActive(var10_23, true)
									end)
									var12_23:Play("anim_CommanderManualUI_tpl_guidePage_expand")
								end, SFX_PANEL)
								onButton(arg0_20, arg2_23:Find("fold/descBg/triangle"), function()
									setActive(var9_23, true)
									var13_23:SetEndEvent(function()
										setActive(var10_23, false)
									end)
									var12_23:Play("anim_CommanderManualUI_tpl_guidePage_retract")
								end, SFX_PANEL)
								setActive(var9_23, false)
								setActive(var10_23, true)
								setActive(var11_23, false)
							else
								setText(arg2_23:Find("lock/lockBg/Text"), var0_21:GetTaskLockTip(var0_23))
								setActive(var9_23, false)
								setActive(var10_23, false)
								setActive(var11_23, true)
							end

							var12_23:Play("anim_CommanderManualUI_tpl_guidePage")
						end
					end)
					var1_20:align(#var0_21.taskIdList)
					scrollTo(arg0_20:findTF("page/scroll", arg0_20.guidePage), 0, 1)
					arg0_20:SetPtPanel(arg0_20:findTF("page/ptPanel", arg0_20.guidePage), var0_21)
				else
					local var0_22 = var0_21:GetLockTip()

					if var0_22 and var0_22 ~= "" then
						pg.TipsMgr.GetInstance():ShowTips(var0_22)
					end
				end
			end, SFX_PANEL)

			if arg0_20.contextData.currentPageId == var0_21.id then
				var2_20 = true

				triggerButton(arg2_21)
			end

			if not arg0_20.contextData.currentPageId and var0_21.isUnlock and isActive(arg2_21:Find("tip")) then
				var2_20 = true
				arg0_20.contextData.currentPageId = var0_21.id

				triggerButton(arg2_21)
			end
		end
	end)
	var0_20:align(#arg0_20.guidePages)

	if not var2_20 then
		triggerButton(arg0_20:findTF("subPageScroll/Viewport/Content", arg0_20.guidePage):GetChild(0))
	end

	arg0_20:ShowBottomTip(arg0_20.guidePage, 1)
	onScroll(arg0_20, arg0_20.guidePage:Find("subPageScroll"), function(arg0_32)
		arg0_20:ShowBottomTip(arg0_20.guidePage, arg0_32.y)
	end)
end

function var0_0.SetPtPanel(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg2_33:getConfig("target")
	local var1_33 = arg2_33:getConfig("drop_client")

	setText(arg0_33:findTF("upgrade/progress/progress1", arg1_33), arg2_33.pt)
	setText(arg0_33:findTF("upgrade/progress/progress2", arg1_33), "/" .. #arg2_33.taskIdList)
	setSlider(arg0_33:findTF("slider", arg1_33), 0, #arg2_33.taskIdList, arg2_33.pt)

	if arg2_33.pt == #arg2_33.taskIdList then
		arg1_33:Find("upgrade"):GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_ptPanel_upgrade")
	end

	local var2_33 = arg2_33:GetCurrentPtTarget()

	setText(arg0_33:findTF("desc", arg1_33), i18n("handbook_unfinished", var2_33))

	local var3_33 = arg0_33:findTF("awards", arg1_33)
	local var4_33 = var3_33:GetChild(0)

	arg0_33:updateTaskAwards(arg2_33:GetCurrentPtAward(), var3_33, var4_33)
	setActive(arg0_33:findTF("go_btn", arg1_33), var2_33 > arg2_33.pt)
	setActive(arg0_33:findTF("get_btn", arg1_33), var2_33 <= arg2_33.pt and arg2_33.award < #arg2_33:getConfig("target"))
	setActive(arg0_33:findTF("got_btn", arg1_33), arg2_33.award == #arg2_33:getConfig("target"))
	onButton(arg0_33, arg0_33:findTF("get_btn", arg1_33), function()
		arg0_33:PtAwardsCheckAndSubmit(arg2_33)
	end, SFX_PANEL)
end

function var0_0.updateTaskAwards(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = _.slice(arg1_35, 1, 3)

	for iter0_35 = arg2_35.childCount, #var0_35 - 1 do
		cloneTplTo(arg3_35, arg2_35)
	end

	local var1_35 = arg2_35.childCount

	for iter1_35 = 1, var1_35 do
		local var2_35 = arg2_35:GetChild(iter1_35 - 1)
		local var3_35 = iter1_35 <= #var0_35

		setActive(var2_35, var3_35)

		if var3_35 then
			local var4_35 = var0_35[iter1_35]
			local var5_35 = {
				type = var4_35[1],
				id = var4_35[2],
				count = var4_35[3]
			}

			updateDrop(var2_35, var5_35)
			onButton(arg0_35, var2_35, function()
				arg0_35:emit(BaseUI.ON_DROP, var5_35)
			end, SFX_PANEL)
		end
	end
end

function var0_0.ShowTechPage(arg0_37)
	local var0_37 = arg0_37.techPage:Find("subPageScroll/Viewport/Content")

	UIItemList.StaticAlign(var0_37, var0_37:GetChild(0), arg0_37.allTechPhase, function(arg0_38, arg1_38, arg2_38)
		if arg0_38 == UIItemList.EventUpdate then
			arg2_38.name = "Phase" .. arg1_38

			setText(arg2_38:Find("name"), i18n("tec_catchup_" .. arg1_38))
			setText(arg2_38:Find("name/en"), "")
			setText(arg2_38:Find("select/name"), i18n("tec_catchup_" .. arg1_38))
			setText(arg2_38:Find("select/name/en"), "")
			onToggle(arg0_37, arg2_38, function(arg0_39)
				setActive(arg2_38:Find("select"), arg0_39)
				setCanvasGroupAlpha(arg2_38, not arg0_39 and arg0_37.finishPhaseDic[arg1_38] and 0.5 or 1)

				arg2_38:Find("tip").anchoredPosition = Vector2(arg0_39 and -34.295 or 18, -2)

				setActive(arg2_38:Find("name"), not arg0_39)

				if arg0_39 then
					arg0_37:SetTechDisplayPage(arg1_38)
				end
			end, SFX_PANEL)
		end
	end)
	arg0_37:UpdateTechPageState()

	local var1_37

	var1_37 = arg0_37.phaseId == "ready"

	setActive(arg0_37.techPage:Find("page"), true)

	local var2_37 = arg0_37.phaseId == "ready" and 0 or arg0_37.phaseId

	eachChild(var0_37, function(arg0_40, arg1_40)
		triggerToggle(arg0_40, arg1_40 == var2_37)
	end)
	arg0_37:ShowBottomTip(arg0_37.techPage, 1)
	onScroll(arg0_37, arg0_37.techPage:Find("subPageScroll"), function(arg0_41)
		arg0_37:ShowBottomTip(arg0_37.techPage, arg0_41.y)
	end)
end

function var0_0.GetTechTask(arg0_42, arg1_42, arg2_42)
	local var0_42 = Task.New({
		id = arg1_42
	})

	if arg2_42 then
		var0_42.progress = var0_42:getConfig("target_num")
		var0_42.submitTime = 1
	end

	return var0_42
end

function var0_0.SetTechDisplayPage(arg0_43, arg1_43)
	local var0_43 = arg1_43 == arg0_43.phaseId
	local var1_43 = arg0_43.finishPhaseDic[arg1_43]

	setActive(arg0_43.techPage:Find("page/lock_mask"), not var0_43)

	local var2_43 = arg0_43.techActivity:getConfig("config_data")[3]
	local var3_43, var4_43 = unpack(var2_43[math.max(1, arg1_43)])
	local var5_43 = underscore.map(var3_43, function(arg0_44)
		return arg0_43.taskProxy:getTaskVO(arg0_44) or arg0_43:GetTechTask(arg0_44, var0_43 or var1_43)
	end)

	table.sort(var5_43, CompareFuncs({
		function(arg0_45)
			return arg0_45:isReceive() and 1 or 0
		end,
		function(arg0_46)
			return arg0_46:isFinish() and 0 or 1
		end,
		function(arg0_47)
			return arg0_47.id
		end
	}))

	local var6_43 = arg0_43.techPage:Find("page/scroll/Viewport/Content")

	UIItemList.StaticAlign(var6_43, var6_43:Find("tpl"), #var5_43, function(arg0_48, arg1_48, arg2_48)
		arg1_48 = arg1_48 + 1

		if arg0_48 == UIItemList.EventUpdate then
			local var0_48 = var5_43[arg1_48]

			setText(arg2_48:Find("normal/number"), string.format("NO.%02d", arg1_48))
			setText(arg2_48:Find("normal/desc"), var0_48:getConfig("desc"))

			local var1_48 = arg2_48:Find("normal/awards")
			local var2_48 = var1_48:GetChild(0)

			arg0_43:updateTaskAwards(var0_48:getConfig("award_display"), var1_48, var2_48)

			local var3_48 = arg2_48:Find("normal/go_btn")
			local var4_48 = arg2_48:Find("normal/get_btn")
			local var5_48 = arg2_48:Find("normal/got_btn")
			local var6_48 = arg2_48:Find("normal/lock_btn")
			local var7_48 = arg2_48:Find("normal")
			local var8_48 = arg2_48:Find("lock")
			local var9_48 = var0_48:getConfig("target_num")
			local var10_48 = var0_48:getProgress()
			local var11_48 = math.min(var10_48, var9_48)

			setText(arg2_48:Find("normal/progress"), var11_48 .. "/" .. var9_48)
			setSlider(arg2_48:Find("normal/slider"), 0, var9_48, var11_48)

			if not var0_43 and not var1_43 then
				setActive(var3_48, false)
				setActive(var4_48, false)
				setActive(var5_48, false)
				setActive(var6_48, true)
			else
				local var12_48 = var0_48:getTaskStatus()

				setActive(var3_48, var12_48 == 0)
				setActive(var4_48, var12_48 == 1)
				setActive(var5_48, var12_48 == 2)
				setActive(var6_48, false)
			end

			onButton(arg0_43, var3_48, function()
				arg0_43:emit(CommanderManualMediator.ON_TASK_GO, var0_48)
			end, SFX_PANEL)
			onButton(arg0_43, var4_48, function()
				arg0_43:TaskAwardsCheckAndSubmit(var0_48)
			end, SFX_PANEL)
			setActive(var7_48, true)
			setActive(var8_48, false)
			arg2_48:GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_tpl_update")
		end
	end)
	scrollTo(arg0_43.techPage:Find("page/scroll"), 0, 1)

	local var7_43 = arg0_43.techPage:Find("page/ptPanel")
	local var8_43

	if var0_43 then
		var8_43 = arg0_43.taskProxy:getTaskVO(var4_43)
	elseif var1_43 then
		var8_43 = arg0_43:GetTechTask(var4_43, var1_43)
	end

	if var8_43 then
		if var8_43 and var8_43:isClientTrigger() and not var8_43:isFinish() then
			arg0_43:emit(CommanderManualMediator.ON_UPDATE, var8_43)
		end

		local var9_43 = var8_43:getConfig("target_num")
		local var10_43 = var8_43:getProgress()
		local var11_43 = math.min(var10_43, var9_43)

		setText(var7_43:Find("upgrade/progress/progress1"), var11_43)
		setText(var7_43:Find("upgrade/progress/progress2"), "/" .. var9_43)
		setSlider(var7_43:Find("slider"), 0, var9_43, var11_43)

		if var11_43 == var9_43 then
			var7_43:Find("upgrade"):GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_ptPanel_upgrade")
		end

		setText(var7_43:Find("desc"), var8_43:getConfig("desc"))

		local var12_43 = var7_43:Find("awards")
		local var13_43 = var12_43:GetChild(0)

		arg0_43:updateTaskAwards(var8_43:getConfig("award_display"), var12_43, var13_43)

		local var14_43 = var7_43:Find("go_btn")
		local var15_43 = var7_43:Find("get_btn")
		local var16_43 = var7_43:Find("got_btn")
		local var17_43 = var8_43:getTaskStatus()

		setActive(var14_43, var17_43 == 0)
		setActive(var15_43, var17_43 == 1)
		setActive(var16_43, var17_43 == 2)

		local var18_43 = var7_43:Find("unlock_btn")
		local var19_43 = var7_43:Find("wait_btn")

		setActive(var18_43, false)
		setActive(var19_43, false)
		onButton(arg0_43, var14_43, function()
			arg0_43:emit(CommanderManualMediator.ON_TASK_GO, var8_43)
		end, SFX_PANEL)
		onButton(arg0_43, var15_43, function()
			arg0_43:TaskAwardsCheckAndSubmit(var8_43)
		end, SFX_PANEL)
	else
		local var20_43 = #var5_43
		local var21_43 = var0_43 and underscore.reduce(var5_43, 0, function(arg0_53, arg1_53)
			return arg0_53 + (arg1_53:isReceive() and 1 or 0)
		end) or 0

		setText(var7_43:Find("upgrade/progress/progress1"), var21_43)
		setText(var7_43:Find("upgrade/progress/progress2"), "/" .. var20_43)
		setSlider(var7_43:Find("slider"), 0, var20_43, var21_43)

		if var21_43 == var20_43 then
			var7_43:Find("upgrade"):GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_ptPanel_upgrade")
		end

		setText(var7_43:Find("desc"), i18n("handbook_research_final_task_desc_locked", i18n("tec_catchup_" .. arg1_43)))

		local var22_43 = var7_43:Find("awards")
		local var23_43 = var22_43:GetChild(0)

		arg0_43:updateTaskAwards(pg.task_data_template[var4_43].award_display, var22_43, var23_43)

		local var24_43 = var7_43:Find("go_btn")
		local var25_43 = var7_43:Find("get_btn")
		local var26_43 = var7_43:Find("got_btn")

		setActive(var24_43, false)
		setActive(var25_43, false)
		setActive(var26_43, false)

		if var20_43 <= var21_43 then
			arg0_43:emit(CommanderManualMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = arg0_43.techActivity.id
			})
		end

		local var27_43, var28_43 = TechnologyConst.isTecActOn()
		local var29_43 = arg0_43.techFinishTaskId and arg0_43.taskProxy:getTaskVO(arg0_43.techFinishTaskId)
		local var30_43 = arg0_43.phaseId == "ready" or var27_43 and var29_43 and var29_43:isReceive()
		local var31_43 = not var1_43 and not var0_43
		local var32_43 = var30_43 and (arg1_43 ~= 1 or arg0_43.finishPhaseDic[0] or arg0_43.phaseId == 0)
		local var33_43 = var7_43:Find("unlock_btn")
		local var34_43 = var7_43:Find("wait_btn")

		setText(var33_43:Find("Text"), i18n("handbook_research_confirm", i18n("tec_catchup_" .. arg1_43)))
		setText(var34_43:Find("Text"), i18n("handbook_research_final_task_btn_locked"))
		setActive(var33_43, var31_43 and var32_43)
		setActive(var34_43, var0_43 and var21_43 < var20_43)
		onButton(arg0_43, var33_43, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_catchup_confirm"),
				onYes = function()
					if arg1_43 == 1 then
						arg0_43:emit(CommanderManualMediator.ON_TRIGGER, {
							cmd = 3,
							activity_id = arg0_43.techActivity.id
						})
					else
						arg0_43:emit(CommanderManualMediator.ON_TRIGGER, {
							cmd = 1,
							activity_id = arg0_43.techActivity.id,
							arg1 = math.max(arg1_43, 1)
						})
					end
				end
			})
		end, SFX_CONFIRM)
		onButton(arg0_43, var34_43, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("handbook_research_final_task_desc_locked", i18n("tec_catchup_" .. arg1_43)))
		end, SFX_CONFIRM)
	end
end

function var0_0.UpdateTechPageState(arg0_57)
	local var0_57, var1_57 = TechnologyConst.isTecActOn()
	local var2_57 = arg0_57.techFinishTaskId and arg0_57.taskProxy:getTaskVO(arg0_57.techFinishTaskId)
	local var3_57 = arg0_57.phaseId == "ready" or var0_57 and var2_57 and var2_57:isReceive()

	eachChild(arg0_57.techPage:Find("subPageScroll/Viewport/Content"), function(arg0_58, arg1_58)
		local var0_58 = not arg0_57.finishPhaseDic[arg1_58] and arg0_57.phaseId ~= arg1_58
		local var1_58 = var3_57 and (arg1_58 ~= 1 or arg0_57.finishPhaseDic[0] or arg0_57.phaseId == 0)

		setActive(arg0_58:Find("name/lock"), false)
		setActive(arg0_58:Find("select/bg"), not arg0_57.finishPhaseDic[arg1_58])
		setActive(arg0_58:Find("select/bg_end"), arg0_57.finishPhaseDic[arg1_58])

		if var1_58 then
			setActive(arg0_58:Find("tip"), var0_58)
		else
			setActive(arg0_58:Find("tip"), arg1_58 == arg0_57.phaseId and var1_57)
		end
	end)
end

function var0_0.ShowBottomTip(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg1_59:Find("subPageScroll"):GetComponent(typeof(ScrollRect))
	local var1_59 = arg1_59:Find("subPageScroll/Viewport/Content")
	local var2_59 = var1_59:GetComponent(typeof(VerticalLayoutGroup))
	local var3_59 = var2_59.padding.top
	local var4_59 = var2_59.padding.bottom
	local var5_59 = var2_59.spacing
	local var6_59 = var1_59:GetChild(0).rect.height
	local var7_59 = var3_59 + var4_59 + var6_59 * var1_59.childCount + var5_59 * (var1_59.childCount - 1)
	local var8_59 = arg1_59:Find("subPageScroll/Viewport").rect.height

	if var7_59 < var8_59 + var5_59 + var6_59 then
		setActive(arg1_59:Find("bottomTip"), false)

		return
	end

	local var9_59 = math.floor(var8_59 / (var6_59 + var5_59))
	local var10_59 = math.ceil((var1_59.childCount - var9_59) * (1 - arg2_59) + var9_59)

	if var10_59 < var9_59 then
		var10_59 = var9_59
	end

	if var10_59 > var1_59.childCount - 1 then
		setActive(arg1_59:Find("bottomTip"), false)

		return
	end

	setActive(arg1_59:Find("bottomTip"), false)

	for iter0_59 = var10_59, var1_59.childCount - 1 do
		if isActive(var1_59:GetChild(iter0_59):Find("tip")) then
			setActive(arg1_59:Find("bottomTip"), true)

			break
		end
	end
end

function var0_0.TaskAwardsCheckAndSubmit(arg0_60, arg1_60)
	local var0_60 = {}
	local var1_60 = arg1_60:getConfig("award_display")
	local var2_60 = getProxy(PlayerProxy):getRawData()
	local var3_60 = pg.gameset.urpt_chapter_max.description[1]
	local var4_60 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_60)
	local var5_60, var6_60 = Task.StaticJudgeOverflow(var2_60.gold, var2_60.oil, var4_60, true, true, var1_60)

	if var5_60 then
		table.insert(var0_60, function(arg0_61)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_60,
				onYes = arg0_61
			})
		end)
	end

	seriesAsync(var0_60, function()
		arg0_60:emit(CommanderManualMediator.ON_TASK_SUBMIT, arg1_60)
	end)
end

function var0_0.PtAwardsCheckAndSubmit(arg0_63, arg1_63)
	local var0_63 = {}
	local var1_63 = arg1_63:GetCurrentPtAward()
	local var2_63 = getProxy(PlayerProxy):getRawData()
	local var3_63 = pg.gameset.urpt_chapter_max.description[1]
	local var4_63 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_63)
	local var5_63, var6_63 = Task.StaticJudgeOverflow(var2_63.gold, var2_63.oil, var4_63, true, true, var1_63)

	if var5_63 then
		table.insert(var0_63, function(arg0_64)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_63,
				onYes = arg0_64
			})
		end)
	end

	seriesAsync(var0_63, function()
		arg0_63:emit(CommanderManualMediator.GET_PT_AWARD, arg1_63.id)
	end)
end

function var0_0.willExit(arg0_66)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_66.blurPanel, arg0_66._tf)
end

function var0_0.onBackPressed(arg0_67)
	arg0_67:closeView()
end

return var0_0

local var0_0 = class("CommanderManualLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CommanderManualUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype",
		"ui/iconcolorful",
		"ui/MsgBox"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

function var0_0.init(arg0_3)
	arg0_3.backBtn = arg0_3._tf:Find("blur_panel/top/CommonTitleAndBack/back_btn")
	arg0_3.helpBtn = arg0_3._tf:Find("blur_panel/top/helpBtn")
	arg0_3.taskBtn = arg0_3._tf:Find("blur_panel/panel/pageBtns/taskBtn")
	arg0_3.techBtn = arg0_3._tf:Find("blur_panel/panel/pageBtns/techBtn")
	arg0_3.guideBtn = arg0_3._tf:Find("blur_panel/panel/pageBtns/guideBtn")
	arg0_3.topBtns = {
		arg0_3.taskBtn,
		arg0_3.techBtn,
		arg0_3.guideBtn
	}
	arg0_3.pages = arg0_3._tf:Find("blur_panel/panel/pages")
	arg0_3.taskPage = arg0_3._tf:Find("blur_panel/panel/pages/taskPage")
	arg0_3.techPage = arg0_3._tf:Find("blur_panel/panel/pages/techPage")
	arg0_3.guidePage = arg0_3._tf:Find("blur_panel/panel/pages/guidePage")
	arg0_3.blurPanel = arg0_3._tf:Find("blur_panel")
	arg0_3.pageBg = arg0_3._tf:Find("blur_panel/panel/mask/pageBg")

	arg0_3:OverlayPanel(arg0_3.blurPanel, {
		pbList = {
			arg0_3.pageBg
		}
	})
	setText(arg0_3._tf:Find("blur_panel/top/CommonTitleAndBack/title"), i18n("handbook_name"))
	setText(arg0_3._tf:Find("blur_panel/top/CommonTitleAndBack/title/en"), "HANDBOOK")
	setText(arg0_3.taskPage:Find("page/scroll/Viewport/Content/tpl/normal/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.taskPage:Find("page/scroll/Viewport/Content/tpl/normal/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.taskPage:Find("page/scroll/Viewport/Content/tpl/normal/got_btn/Text"), i18n("handbook_finished"))
	setText(arg0_3.taskPage:Find("page/ptPanel/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.taskPage:Find("page/ptPanel/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.taskPage:Find("page/ptPanel/got_btn/Text"), i18n("handbook_finished"))
	setText(arg0_3.techPage:Find("page/scroll/Viewport/Content/tpl/normal/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.techPage:Find("page/scroll/Viewport/Content/tpl/normal/lock_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.techPage:Find("page/scroll/Viewport/Content/tpl/normal/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.techPage:Find("page/scroll/Viewport/Content/tpl/normal/got_btn/Text"), i18n("handbook_finished"))
	setText(arg0_3.techPage:Find("page/ptPanel/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.techPage:Find("page/ptPanel/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.techPage:Find("page/ptPanel/got_btn/Text"), i18n("handbook_finished"))
	setText(arg0_3.guidePage:Find("page/scroll/Viewport/Content/tpl/normal/content/descBg/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.guidePage:Find("page/scroll/Viewport/Content/tpl/normal/content/descBg/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.guidePage:Find("page/scroll/Viewport/Content/tpl/normal/content/descBg/got_btn/Text"), i18n("handbook_finished"))
	setText(arg0_3.guidePage:Find("page/scroll/Viewport/Content/tpl/fold/descBg/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.guidePage:Find("page/scroll/Viewport/Content/tpl/fold/descBg/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.guidePage:Find("page/scroll/Viewport/Content/tpl/fold/descBg/got_btn/Text"), i18n("handbook_finished"))
	setText(arg0_3.guidePage:Find("page/ptPanel/go_btn/Text"), i18n("handbook_process"))
	setText(arg0_3.guidePage:Find("page/ptPanel/get_btn/Text"), i18n("handbook_claim"))
	setText(arg0_3.guidePage:Find("page/ptPanel/got_btn/Text"), i18n("handbook_finished"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.handbook_gametip.tip
		})
	end, SFX_PANEL)
	arg0_4:InitData()
	arg0_4:RefreshAll()
end

function var0_0.InitData(arg0_7)
	arg0_7.commanderManualProxy = getProxy(CommanderManualProxy)
	arg0_7.taskProxy = getProxy(TaskProxy)
	arg0_7.taskPages = arg0_7.commanderManualProxy:GetPagesByType(1)
	arg0_7.guidePages = arg0_7.commanderManualProxy:GetPagesByType(2)
	arg0_7.topTaskCfg = pg.tutorial_handbook[CommanderManualProxy.TOP_PAGE_TASK]
	arg0_7.topTechCfg = pg.tutorial_handbook[CommanderManualProxy.TOP_PAGE_TECH]
	arg0_7.topGuideCfg = pg.tutorial_handbook[CommanderManualProxy.TOP_PAGE_GUIDE]

	arg0_7:UpdateTechActivity()
end

function var0_0.UpdateTechActivity(arg0_8)
	arg0_8.techActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)

	if not arg0_8.techActivity or arg0_8.techActivity:isEnd() then
		return
	end

	local var0_8 = arg0_8.techActivity

	arg0_8.allTechPhase = #var0_8:getConfig("config_data")[3] + 1

	if var0_8.data1 == 0 then
		arg0_8.phaseId = "ready"
	else
		arg0_8.phaseId = var0_8.data1

		if arg0_8.phaseId == 1 and var0_8.data2 < 1 then
			arg0_8.phaseId = 0
		end
	end

	arg0_8.techFinishTaskId = arg0_8.phaseId ~= "ready" and var0_8:getConfig("config_data")[3][math.max(1, arg0_8.phaseId)][2] or nil
	arg0_8.finishPhaseDic = {}

	for iter0_8, iter1_8 in ipairs(var0_8.data1_list) do
		arg0_8.finishPhaseDic[iter1_8] = true
	end

	arg0_8.finishPhaseDic[0] = arg0_8.finishPhaseDic[1]
	arg0_8.finishPhaseDic[1] = var0_8.data2 == 1 and var0_8.data1 ~= 1
end

function var0_0.RefreshAll(arg0_9)
	local var0_9 = arg0_9.commanderManualProxy:IsTopUnlock(CommanderManualProxy.TOP_PAGE_TASK)
	local var1_9 = arg0_9.commanderManualProxy:IsTopUnlock(CommanderManualProxy.TOP_PAGE_TECH)
	local var2_9 = arg0_9.commanderManualProxy:IsTopUnlock(CommanderManualProxy.TOP_PAGE_GUIDE)

	setActive(arg0_9.taskBtn, not arg0_9.commanderManualProxy:IsTopPageComplete(1))

	local var3_9, var4_9 = TechnologyConst.isTecActOn()

	setActive(arg0_9.techBtn, var3_9)
	setActive(arg0_9.taskBtn:Find("Text/lock"), not var0_9)
	setActive(arg0_9.techBtn:Find("Text/lock"), not var1_9)
	setActive(arg0_9.guideBtn:Find("Text/lock"), not var2_9)
	setText(arg0_9.taskBtn:Find("Text"), var0_9 and arg0_9.topTaskCfg.name or arg0_9.topTaskCfg.lock_name)
	setText(arg0_9.techBtn:Find("Text"), var1_9 and arg0_9.topTechCfg.name or arg0_9.topTechCfg.lock_name)
	setText(arg0_9.guideBtn:Find("Text"), var2_9 and arg0_9.topGuideCfg.name or arg0_9.topGuideCfg.lock_name)
	setText(arg0_9.taskBtn:Find("select/Text"), arg0_9.topTaskCfg.name)
	setText(arg0_9.techBtn:Find("select/Text"), arg0_9.topTechCfg.name)
	setText(arg0_9.guideBtn:Find("select/Text"), arg0_9.topGuideCfg.name)
	setText(arg0_9.taskBtn:Find("select/en"), arg0_9.topTaskCfg.eng_name)
	setText(arg0_9.techBtn:Find("select/en"), arg0_9.topTechCfg.eng_name)
	setText(arg0_9.guideBtn:Find("select/en"), arg0_9.topGuideCfg.eng_name)
	setActive(arg0_9.taskBtn:Find("tip"), arg0_9.commanderManualProxy:ShouldShowTipByType(1))
	setActive(arg0_9.techBtn:Find("tip"), var4_9)
	setActive(arg0_9.guideBtn:Find("tip"), arg0_9.commanderManualProxy:ShouldShowTipByType(2))

	arg0_9.hasRefreshed = false

	onButton(arg0_9, arg0_9.taskBtn, function()
		if arg0_9.contextData.topIndex ~= 1 or not arg0_9.hasRefreshed then
			if var0_9 then
				arg0_9.contextData.topIndex = 1

				if arg0_9.hasRefreshed then
					arg0_9.contextData.currentPageId = nil
				end

				arg0_9:SetPagesActive(1)
				arg0_9:ShowTaskPage()

				for iter0_10, iter1_10 in ipairs(arg0_9.topBtns) do
					setActive(iter1_10:Find("select"), iter1_10 == arg0_9.taskBtn)
				end
			else
				local var0_10 = arg0_9.commanderManualProxy:GetLockTip(CommanderManualProxy.TOP_PAGE_TASK)

				if var0_10 and var0_10 ~= "" then
					pg.TipsMgr.GetInstance():ShowTips(var0_10)
				end
			end
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.techBtn, function()
		if arg0_9.contextData.topIndex ~= 2 or not arg0_9.hasRefreshed then
			if var1_9 then
				arg0_9.contextData.topIndex = 2

				if arg0_9.hasRefreshed then
					arg0_9.contextData.currentPageId = nil
				end

				arg0_9:SetPagesActive(2)
				arg0_9:ShowTechPage()

				for iter0_11, iter1_11 in ipairs(arg0_9.topBtns) do
					setActive(iter1_11:Find("select"), iter1_11 == arg0_9.techBtn)
				end
			else
				local var0_11 = arg0_9.commanderManualProxy:GetLockTip(CommanderManualProxy.TOP_PAGE_TECH)

				if var0_11 and var0_11 ~= "" then
					pg.TipsMgr.GetInstance():ShowTips(var0_11)
				end
			end
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.guideBtn, function()
		if arg0_9.contextData.topIndex ~= 3 or not arg0_9.hasRefreshed then
			if var2_9 then
				arg0_9.contextData.topIndex = 3

				if arg0_9.hasRefreshed then
					arg0_9.contextData.currentPageId = nil
				end

				arg0_9:SetPagesActive(3)
				arg0_9:ShowGuidePage()

				for iter0_12, iter1_12 in ipairs(arg0_9.topBtns) do
					setActive(iter1_12:Find("select"), iter1_12 == arg0_9.guideBtn)
				end
			else
				local var0_12 = arg0_9.commanderManualProxy:GetLockTip(CommanderManualProxy.TOP_PAGE_GUIDE)

				if var0_12 and var0_12 ~= "" then
					pg.TipsMgr.GetInstance():ShowTips(var0_12)
				end
			end
		end
	end, SFX_PANEL)

	if arg0_9.contextData.topIndex then
		triggerButton(arg0_9.topBtns[arg0_9.contextData.topIndex])

		arg0_9.hasRefreshed = true
	else
		local var5_9 = false

		for iter0_9, iter1_9 in ipairs(arg0_9.topBtns) do
			if isActive(iter1_9) and not isActive(iter1_9:Find("Text/lock")) and isActive(iter1_9:Find("tip")) then
				triggerButton(iter1_9)

				var5_9 = true
				arg0_9.hasRefreshed = true

				break
			end
		end

		if not var5_9 then
			for iter2_9, iter3_9 in ipairs(arg0_9.topBtns) do
				if isActive(iter3_9) and not isActive(iter3_9:Find("Text/lock")) then
					triggerButton(iter3_9)

					arg0_9.hasRefreshed = true

					break
				end
			end
		end
	end
end

function var0_0.SetPagesActive(arg0_13, arg1_13)
	for iter0_13 = 1, arg0_13.pages.childCount do
		setActive(arg0_13.pages:GetChild(iter0_13 - 1), iter0_13 == arg1_13)
	end
end

function var0_0.ShowTaskPage(arg0_14)
	if not arg0_14.taskItemAnimTime then
		arg0_14.taskItemAnimTime = {}
	end

	local var0_14 = UIItemList.New(arg0_14.taskPage:Find("subPageScroll/Viewport/Content"), arg0_14.taskPage:Find("subPageScroll/Viewport/Content/subPageBtn"))
	local var1_14 = UIItemList.New(arg0_14.taskPage:Find("page/scroll/Viewport/Content"), arg0_14.taskPage:Find("page/scroll/Viewport/Content/tpl"))
	local var2_14 = false

	var0_14:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_14.taskPages[arg1_15 + 1]

			setActive(arg2_15:Find("name/lock"), not var0_15.isUnlock)
			setActive(arg2_15:Find("tip"), var0_15:ShouldShowTip())
			setText(arg2_15:Find("name"), var0_15.isUnlock and var0_15:getConfig("name") or var0_15:getConfig("lock_name"))
			setText(arg2_15:Find("name/en"), var0_15:getConfig("eng_name"))
			setText(arg2_15:Find("select/name"), var0_15:getConfig("name"))
			setText(arg2_15:Find("select/name/en"), var0_15:getConfig("eng_name"))

			arg2_15:GetComponent(typeof(CanvasGroup)).alpha = var0_15.isUnlock and 1 or 0.5

			onButton(arg0_14, arg2_15, function()
				if var0_15.isUnlock then
					arg0_14.contextData.currentPageId = var0_15.id

					for iter0_16 = 1, arg0_14.taskPage:Find("subPageScroll/Viewport/Content").childCount do
						setActive(arg0_14.taskPage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_16 - 1):Find("select"), iter0_16 == arg1_15 + 1)
						setActive(arg0_14.taskPage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_16 - 1):Find("name"), iter0_16 ~= arg1_15 + 1)

						arg0_14.taskPage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_16 - 1):Find("tip").anchoredPosition = Vector2(iter0_16 == arg1_15 + 1 and -34.295 or 18, -2)
					end

					var0_15:SortTaskIdList()
					var1_14:make(function(arg0_17, arg1_17, arg2_17)
						if arg0_17 == UIItemList.EventUpdate then
							local var0_17 = var0_15.taskIdList[arg1_17 + 1]
							local var1_17 = pg.task_data_template[var0_17]
							local var2_17 = arg0_14.taskProxy:getTaskById(var0_17)

							setText(arg2_17:Find("normal/number"), string.format("NO.%02d", arg1_17 + 1))
							setText(arg2_17:Find("normal/desc"), var1_17.desc)

							local var3_17 = arg2_17:Find("normal/awards")
							local var4_17 = var3_17:GetChild(0)

							arg0_14:updateTaskAwards(var1_17.award_display, var3_17, var4_17)

							local var5_17 = var1_17.target_num
							local var6_17 = arg2_17:Find("normal/go_btn")
							local var7_17 = arg2_17:Find("normal/get_btn")
							local var8_17 = arg2_17:Find("normal/got_btn")
							local var9_17 = arg2_17:Find("normal")
							local var10_17 = arg2_17:Find("lock")

							if var2_17 then
								local var11_17 = var2_17:getProgress()
								local var12_17 = math.min(var11_17, var5_17)

								setText(arg2_17:Find("normal/progress"), var12_17 .. "/" .. var5_17)
								setSlider(arg2_17:Find("normal/slider"), 0, var5_17, var12_17)

								if var2_17:getTaskStatus() == 0 then
									setActive(var6_17, true)
									setActive(var7_17, false)
									setActive(var8_17, false)
								elseif var2_17:getTaskStatus() == 1 then
									setActive(var6_17, false)
									setActive(var7_17, true)
									setActive(var8_17, false)
								elseif var2_17:getTaskStatus() == 2 then
									setActive(var6_17, false)
									setActive(var7_17, false)
									setActive(var8_17, true)
								end

								onButton(arg0_14, var6_17, function()
									arg0_14:emit(CommanderManualMediator.ON_TASK_GO, var2_17)
								end, SFX_PANEL)
								onButton(arg0_14, var7_17, function()
									arg0_14:TaskAwardsCheckAndSubmit(var2_17)
								end, SFX_PANEL)
								setActive(var9_17, true)
								setActive(var10_17, false)
							elseif var0_15:IsTaskComplete(var0_17) then
								setText(arg2_17:Find("normal/progress"), var5_17 .. "/" .. var5_17)
								setSlider(arg2_17:Find("normal/slider"), 0, var5_17, var5_17)
								setActive(var6_17, false)
								setActive(var7_17, false)
								setActive(var8_17, true)
								setActive(var9_17, true)
								setActive(var10_17, false)
							else
								setText(arg2_17:Find("lock/lockBg/Text"), var0_15:GetTaskLockTip(var0_17))
								setActive(var9_17, false)
								setActive(var10_17, true)
							end

							if not arg0_14.taskItemAnimTime[var0_17] or Time.realtimeSinceStartup - arg0_14.taskItemAnimTime[var0_17] > 1 then
								arg2_17:GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_tpl_update")

								arg0_14.taskItemAnimTime[var0_17] = Time.realtimeSinceStartup
							end
						end
					end)
					var1_14:align(#var0_15.taskIdList)
					scrollTo(arg0_14.taskPage:Find("page/scroll"), 0, 1)
					arg0_14:SetPtPanel(arg0_14.taskPage:Find("page/ptPanel"), var0_15)
				else
					local var0_16 = var0_15:GetLockTip()

					if var0_16 and var0_16 ~= "" then
						pg.TipsMgr.GetInstance():ShowTips(var0_16)
					end
				end
			end, SFX_PANEL)

			if arg0_14.contextData.currentPageId == var0_15.id then
				var2_14 = true

				triggerButton(arg2_15)
			end

			if not arg0_14.contextData.currentPageId and var0_15.isUnlock and isActive(arg2_15:Find("tip")) then
				var2_14 = true
				arg0_14.contextData.currentPageId = var0_15.id

				triggerButton(arg2_15)
			end
		end
	end)
	var0_14:align(#arg0_14.taskPages)

	if not var2_14 then
		for iter0_14 = #arg0_14.taskPages, 1, -1 do
			if arg0_14.taskPages[iter0_14].isUnlock then
				triggerButton(arg0_14.taskPage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_14 - 1))

				break
			end
		end
	end

	arg0_14:ShowBottomTip(arg0_14.taskPage, 1)
	onScroll(arg0_14, arg0_14.taskPage:Find("subPageScroll"), function(arg0_20)
		arg0_14:ShowBottomTip(arg0_14.taskPage, arg0_20.y)
	end)
end

function var0_0.ShowGuidePage(arg0_21)
	local var0_21 = UIItemList.New(arg0_21.guidePage:Find("subPageScroll/Viewport/Content"), arg0_21.guidePage:Find("subPageScroll/Viewport/Content/subPageBtn"))
	local var1_21 = UIItemList.New(arg0_21.guidePage:Find("page/scroll/Viewport/Content"), arg0_21.guidePage:Find("page/scroll/Viewport/Content/tpl"))
	local var2_21 = false

	var0_21:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg0_21.guidePages[arg1_22 + 1]
			local var1_22 = var0_22:getConfig("name")
			local var2_22 = var0_22:getConfig("lock_name")

			setActive(arg2_22:Find("lock0/lock"), not var0_22.isUnlock)
			setActive(arg2_22:Find("tip"), var0_22:ShouldShowTip())
			arg2_22:Find("mask/name"):GetComponent("ScrollText"):SetText(var0_22.isUnlock and var1_22 or var2_22 or "")
			setText(arg2_22:Find("en"), var0_22:getConfig("eng_name"))
			arg2_22:Find("select/mask/name"):GetComponent("ScrollText"):SetText(tostring(var1_22 or ""))
			setText(arg2_22:Find("select/en"), var0_22:getConfig("eng_name"))

			arg2_22:GetComponent(typeof(CanvasGroup)).alpha = var0_22.isUnlock and 1 or 0.5

			onButton(arg0_21, arg2_22, function()
				if var0_22.isUnlock then
					arg0_21.contextData.currentPageId = var0_22.id

					for iter0_23 = 1, arg0_21.guidePage:Find("subPageScroll/Viewport/Content").childCount do
						setActive(arg0_21.guidePage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_23 - 1):Find("select"), iter0_23 == arg1_22 + 1)
						setActive(arg0_21.guidePage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_23 - 1):Find("lock0"), iter0_23 ~= arg1_22 + 1)
						setActive(arg0_21.guidePage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_23 - 1):Find("mask"), iter0_23 ~= arg1_22 + 1)
						setActive(arg0_21.guidePage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_23 - 1):Find("en"), iter0_23 ~= arg1_22 + 1)

						arg0_21.guidePage:Find("subPageScroll/Viewport/Content"):GetChild(iter0_23 - 1):Find("tip").anchoredPosition = Vector2(iter0_23 == arg1_22 + 1 and -34.295 or 18, -2)
					end

					var0_22:SortTaskIdList()
					var1_21:make(function(arg0_24, arg1_24, arg2_24)
						if arg0_24 == UIItemList.EventUpdate then
							local var0_24 = var0_22.taskIdList[arg1_24 + 1]
							local var1_24 = pg.task_data_template[var0_24]
							local var2_24 = arg0_21.taskProxy:getTaskById(var0_24)

							setText(arg2_24:Find("normal/number"), string.format("NO.%02d", arg1_24 + 1))
							setText(arg2_24:Find("normal/name"), var1_24.name)
							setText(arg2_24:Find("normal/content/descBg/desc"), var1_24.desc)
							LoadImageSpriteAsync(var1_24.tutorial_handbook_pic, arg2_24:Find("normal/content/picture"))
							setText(arg2_24:Find("fold/number"), string.format("NO.%02d", arg1_24 + 1))
							setText(arg2_24:Find("fold/name"), var1_24.name)
							setText(arg2_24:Find("fold/descBg/desc"), var1_24.desc)

							local var3_24 = arg2_24:Find("normal/content/descBg/go_btn")
							local var4_24 = arg2_24:Find("normal/content/descBg/get_btn")
							local var5_24 = arg2_24:Find("normal/content/descBg/got_btn")
							local var6_24 = arg2_24:Find("fold/descBg/go_btn")
							local var7_24 = arg2_24:Find("fold/descBg/get_btn")
							local var8_24 = arg2_24:Find("fold/descBg/got_btn")
							local var9_24 = arg2_24:Find("normal")
							local var10_24 = arg2_24:Find("fold")
							local var11_24 = arg2_24:Find("lock")
							local var12_24 = arg2_24:GetComponent(typeof(Animation))
							local var13_24 = arg2_24:GetComponent(typeof(DftAniEvent))

							if var2_24 then
								if var2_24:getTaskStatus() == 0 then
									setActive(var3_24, true)
									setActive(var4_24, false)
									setActive(var5_24, false)
									setActive(var6_24, true)
									setActive(var7_24, false)
									setActive(var8_24, false)
								elseif var2_24:getTaskStatus() == 1 then
									setActive(var3_24, false)
									setActive(var4_24, true)
									setActive(var5_24, false)
									setActive(var6_24, false)
									setActive(var7_24, true)
									setActive(var8_24, false)
								elseif var2_24:getTaskStatus() == 2 then
									setActive(var3_24, false)
									setActive(var4_24, false)
									setActive(var5_24, true)
									setActive(var6_24, false)
									setActive(var7_24, false)
									setActive(var8_24, true)
								end

								onButton(arg0_21, var3_24, function()
									arg0_21:emit(CommanderManualMediator.ON_TASK_GO, var2_24)
								end, SFX_PANEL)
								onButton(arg0_21, var4_24, function()
									arg0_21:TaskAwardsCheckAndSubmit(var2_24)
								end, SFX_PANEL)
								onButton(arg0_21, var6_24, function()
									arg0_21:emit(CommanderManualMediator.ON_TASK_GO, var2_24)
								end, SFX_PANEL)
								onButton(arg0_21, var7_24, function()
									arg0_21:TaskAwardsCheckAndSubmit(var2_24)
								end, SFX_PANEL)
								setActive(arg2_24:Find("normal/content/descBg/triangle"), false)
								setActive(var9_24, true)
								setActive(var10_24, false)
								setActive(var11_24, false)
							elseif var0_22:IsTaskComplete(var0_24) then
								setActive(var3_24, false)
								setActive(var4_24, false)
								setActive(var5_24, true)
								setActive(var6_24, false)
								setActive(var7_24, false)
								setActive(var8_24, true)
								setActive(arg2_24:Find("normal/content/descBg/triangle"), true)
								onButton(arg0_21, arg2_24:Find("normal/content/descBg/triangle"), function()
									setActive(var9_24, true)
									var13_24:SetEndEvent(function()
										setActive(var9_24, false)
										setActive(var10_24, true)
									end)
									var12_24:Play("anim_CommanderManualUI_tpl_guidePage_expand")
								end, SFX_PANEL)
								onButton(arg0_21, arg2_24:Find("fold/descBg/triangle"), function()
									setActive(var9_24, true)
									var13_24:SetEndEvent(function()
										setActive(var10_24, false)
									end)
									var12_24:Play("anim_CommanderManualUI_tpl_guidePage_retract")
								end, SFX_PANEL)
								setActive(var9_24, false)
								setActive(var10_24, true)
								setActive(var11_24, false)
							else
								setText(arg2_24:Find("lock/lockBg/Text"), var0_22:GetTaskLockTip(var0_24))
								setActive(var9_24, false)
								setActive(var10_24, false)
								setActive(var11_24, true)
							end

							var12_24:Play("anim_CommanderManualUI_tpl_guidePage")
						end
					end)
					var1_21:align(#var0_22.taskIdList)
					scrollTo(arg0_21.guidePage:Find("page/scroll"), 0, 1)
					arg0_21:SetPtPanel(arg0_21.guidePage:Find("page/ptPanel"), var0_22)
				else
					local var0_23 = var0_22:GetLockTip()

					if var0_23 and var0_23 ~= "" then
						pg.TipsMgr.GetInstance():ShowTips(var0_23)
					end
				end
			end, SFX_PANEL)

			if arg0_21.contextData.currentPageId == var0_22.id then
				var2_21 = true

				triggerButton(arg2_22)
			end

			if not arg0_21.contextData.currentPageId and var0_22.isUnlock and isActive(arg2_22:Find("tip")) then
				var2_21 = true
				arg0_21.contextData.currentPageId = var0_22.id

				triggerButton(arg2_22)
			end
		end
	end)
	var0_21:align(#arg0_21.guidePages)

	if not var2_21 then
		triggerButton(arg0_21.guidePage:Find("subPageScroll/Viewport/Content"):GetChild(0))
	end

	arg0_21:ShowBottomTip(arg0_21.guidePage, 1)
	onScroll(arg0_21, arg0_21.guidePage:Find("subPageScroll"), function(arg0_33)
		arg0_21:ShowBottomTip(arg0_21.guidePage, arg0_33.y)
	end)
end

function var0_0.SetPtPanel(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg2_34:getConfig("target")
	local var1_34 = arg2_34:getConfig("drop_client")

	setText(arg1_34:Find("upgrade/progress/progress1"), arg2_34.pt)
	setText(arg1_34:Find("upgrade/progress/progress2"), "/" .. #arg2_34.taskIdList)
	setSlider(arg1_34:Find("slider"), 0, #arg2_34.taskIdList, arg2_34.pt)

	if arg2_34.pt == #arg2_34.taskIdList then
		arg1_34:Find("upgrade"):GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_ptPanel_upgrade")
	end

	local var2_34 = arg2_34:GetCurrentPtTarget()

	setText(arg1_34:Find("desc"), i18n("handbook_unfinished", var2_34))

	local var3_34 = arg1_34:Find("awards")
	local var4_34 = var3_34:GetChild(0)

	arg0_34:updateTaskAwards(arg2_34:GetCurrentPtAward(), var3_34, var4_34)
	setActive(arg1_34:Find("go_btn"), var2_34 > arg2_34.pt)
	setActive(arg1_34:Find("get_btn"), var2_34 <= arg2_34.pt and arg2_34.award < #arg2_34:getConfig("target"))
	setActive(arg1_34:Find("got_btn"), arg2_34.award == #arg2_34:getConfig("target"))
	onButton(arg0_34, arg1_34:Find("get_btn"), function()
		arg0_34:PtAwardsCheckAndSubmit(arg2_34)
	end, SFX_PANEL)
end

function var0_0.updateTaskAwards(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = _.slice(arg1_36, 1, 3)

	for iter0_36 = arg2_36.childCount, #var0_36 - 1 do
		cloneTplTo(arg3_36, arg2_36)
	end

	local var1_36 = arg2_36.childCount

	for iter1_36 = 1, var1_36 do
		local var2_36 = arg2_36:GetChild(iter1_36 - 1)
		local var3_36 = iter1_36 <= #var0_36

		setActive(var2_36, var3_36)

		if var3_36 then
			local var4_36 = var0_36[iter1_36]
			local var5_36 = {
				type = var4_36[1],
				id = var4_36[2],
				count = var4_36[3]
			}

			updateDrop(var2_36, var5_36)
			onButton(arg0_36, var2_36, function()
				arg0_36:emit(BaseUI.ON_DROP, var5_36)
			end, SFX_PANEL)
		end
	end
end

function var0_0.ShowTechPage(arg0_38)
	local var0_38 = arg0_38.techPage:Find("subPageScroll/Viewport/Content")

	UIItemList.StaticAlign(var0_38, var0_38:GetChild(0), arg0_38.allTechPhase, function(arg0_39, arg1_39, arg2_39)
		if arg0_39 == UIItemList.EventUpdate then
			arg2_39.name = "Phase" .. arg1_39

			setText(arg2_39:Find("name"), i18n("tec_catchup_" .. arg1_39))
			setText(arg2_39:Find("name/en"), "")
			setText(arg2_39:Find("select/name"), i18n("tec_catchup_" .. arg1_39))
			setText(arg2_39:Find("select/name/en"), "")
			onToggle(arg0_38, arg2_39, function(arg0_40)
				setActive(arg2_39:Find("select"), arg0_40)
				setCanvasGroupAlpha(arg2_39, not arg0_40 and arg0_38.finishPhaseDic[arg1_39] and 0.5 or 1)

				arg2_39:Find("tip").anchoredPosition = Vector2(arg0_40 and -34.295 or 18, -2)

				setActive(arg2_39:Find("name"), not arg0_40)

				if arg0_40 then
					arg0_38:SetTechDisplayPage(arg1_39)
				end
			end, SFX_PANEL)
		end
	end)
	arg0_38:UpdateTechPageState()

	local var1_38

	var1_38 = arg0_38.phaseId == "ready"

	setActive(arg0_38.techPage:Find("page"), true)

	local var2_38 = arg0_38.phaseId == "ready" and 0 or arg0_38.phaseId

	eachChild(var0_38, function(arg0_41, arg1_41)
		triggerToggle(arg0_41, arg1_41 == var2_38)
	end)
	arg0_38:ShowBottomTip(arg0_38.techPage, 1)
	onScroll(arg0_38, arg0_38.techPage:Find("subPageScroll"), function(arg0_42)
		arg0_38:ShowBottomTip(arg0_38.techPage, arg0_42.y)
	end)
end

function var0_0.GetTechTask(arg0_43, arg1_43, arg2_43)
	local var0_43 = Task.New({
		id = arg1_43
	})

	if arg2_43 then
		var0_43.progress = var0_43:getConfig("target_num")
		var0_43.submitTime = 1
	end

	return var0_43
end

function var0_0.SetTechDisplayPage(arg0_44, arg1_44)
	local var0_44 = arg1_44 == arg0_44.phaseId
	local var1_44 = arg0_44.finishPhaseDic[arg1_44]

	setActive(arg0_44.techPage:Find("page/lock_mask"), not var0_44)

	local var2_44 = arg0_44.techActivity:getConfig("config_data")[3]
	local var3_44, var4_44 = unpack(var2_44[math.max(1, arg1_44)])
	local var5_44 = underscore.map(var3_44, function(arg0_45)
		return arg0_44.taskProxy:getTaskVO(arg0_45) or arg0_44:GetTechTask(arg0_45, var0_44 or var1_44)
	end)

	table.sort(var5_44, CompareFuncs({
		function(arg0_46)
			return arg0_46:isReceive() and 1 or 0
		end,
		function(arg0_47)
			return arg0_47:isFinish() and 0 or 1
		end,
		function(arg0_48)
			return arg0_48.id
		end
	}))

	local var6_44 = arg0_44.techPage:Find("page/scroll/Viewport/Content")

	UIItemList.StaticAlign(var6_44, var6_44:Find("tpl"), #var5_44, function(arg0_49, arg1_49, arg2_49)
		arg1_49 = arg1_49 + 1

		if arg0_49 == UIItemList.EventUpdate then
			local var0_49 = var5_44[arg1_49]

			setText(arg2_49:Find("normal/number"), string.format("NO.%02d", arg1_49))
			setText(arg2_49:Find("normal/desc"), var0_49:getConfig("desc"))

			local var1_49 = arg2_49:Find("normal/awards")
			local var2_49 = var1_49:GetChild(0)

			arg0_44:updateTaskAwards(var0_49:getConfig("award_display"), var1_49, var2_49)

			local var3_49 = arg2_49:Find("normal/go_btn")
			local var4_49 = arg2_49:Find("normal/get_btn")
			local var5_49 = arg2_49:Find("normal/got_btn")
			local var6_49 = arg2_49:Find("normal/lock_btn")
			local var7_49 = arg2_49:Find("normal")
			local var8_49 = arg2_49:Find("lock")
			local var9_49 = var0_49:getConfig("target_num")
			local var10_49 = var0_49:getProgress()
			local var11_49 = math.min(var10_49, var9_49)

			setText(arg2_49:Find("normal/progress"), var11_49 .. "/" .. var9_49)
			setSlider(arg2_49:Find("normal/slider"), 0, var9_49, var11_49)

			if not var0_44 and not var1_44 then
				setActive(var3_49, false)
				setActive(var4_49, false)
				setActive(var5_49, false)
				setActive(var6_49, true)
			else
				local var12_49 = var0_49:getTaskStatus()

				setActive(var3_49, var12_49 == 0)
				setActive(var4_49, var12_49 == 1)
				setActive(var5_49, var12_49 == 2)
				setActive(var6_49, false)
			end

			onButton(arg0_44, var3_49, function()
				arg0_44:emit(CommanderManualMediator.ON_TASK_GO, var0_49)
			end, SFX_PANEL)
			onButton(arg0_44, var4_49, function()
				arg0_44:TaskAwardsCheckAndSubmit(var0_49)
			end, SFX_PANEL)
			setActive(var7_49, true)
			setActive(var8_49, false)
			arg2_49:GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_tpl_update")
		end
	end)
	scrollTo(arg0_44.techPage:Find("page/scroll"), 0, 1)

	local var7_44 = arg0_44.techPage:Find("page/ptPanel")
	local var8_44

	if var0_44 then
		var8_44 = arg0_44.taskProxy:getTaskVO(var4_44)
	elseif var1_44 then
		var8_44 = arg0_44:GetTechTask(var4_44, var1_44)
	end

	if var8_44 then
		if var8_44 and var8_44:isClientTrigger() and not var8_44:isFinish() then
			arg0_44:emit(CommanderManualMediator.ON_UPDATE, var8_44)
		end

		local var9_44 = var8_44:getConfig("target_num")
		local var10_44 = var8_44:getProgress()
		local var11_44 = math.min(var10_44, var9_44)

		setText(var7_44:Find("upgrade/progress/progress1"), var11_44)
		setText(var7_44:Find("upgrade/progress/progress2"), "/" .. var9_44)
		setSlider(var7_44:Find("slider"), 0, var9_44, var11_44)

		if var11_44 == var9_44 then
			var7_44:Find("upgrade"):GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_ptPanel_upgrade")
		end

		setText(var7_44:Find("desc"), var8_44:getConfig("desc"))

		local var12_44 = var7_44:Find("awards")
		local var13_44 = var12_44:GetChild(0)

		arg0_44:updateTaskAwards(var8_44:getConfig("award_display"), var12_44, var13_44)

		local var14_44 = var7_44:Find("go_btn")
		local var15_44 = var7_44:Find("get_btn")
		local var16_44 = var7_44:Find("got_btn")
		local var17_44 = var8_44:getTaskStatus()

		setActive(var14_44, var17_44 == 0)
		setActive(var15_44, var17_44 == 1)
		setActive(var16_44, var17_44 == 2)

		local var18_44 = var7_44:Find("unlock_btn")
		local var19_44 = var7_44:Find("wait_btn")

		setActive(var18_44, false)
		setActive(var19_44, false)
		onButton(arg0_44, var14_44, function()
			arg0_44:emit(CommanderManualMediator.ON_TASK_GO, var8_44)
		end, SFX_PANEL)
		onButton(arg0_44, var15_44, function()
			arg0_44:TaskAwardsCheckAndSubmit(var8_44)
		end, SFX_PANEL)
	else
		local var20_44 = #var5_44
		local var21_44 = var0_44 and underscore.reduce(var5_44, 0, function(arg0_54, arg1_54)
			return arg0_54 + (arg1_54:isReceive() and 1 or 0)
		end) or 0

		setText(var7_44:Find("upgrade/progress/progress1"), var21_44)
		setText(var7_44:Find("upgrade/progress/progress2"), "/" .. var20_44)
		setSlider(var7_44:Find("slider"), 0, var20_44, var21_44)

		if var21_44 == var20_44 then
			var7_44:Find("upgrade"):GetComponent(typeof(Animation)):Play("anim_CommanderManualUI_ptPanel_upgrade")
		end

		setText(var7_44:Find("desc"), i18n("handbook_research_final_task_desc_locked", i18n("tec_catchup_" .. arg1_44)))

		local var22_44 = var7_44:Find("awards")
		local var23_44 = var22_44:GetChild(0)

		arg0_44:updateTaskAwards(pg.task_data_template[var4_44].award_display, var22_44, var23_44)

		local var24_44 = var7_44:Find("go_btn")
		local var25_44 = var7_44:Find("get_btn")
		local var26_44 = var7_44:Find("got_btn")

		setActive(var24_44, false)
		setActive(var25_44, false)
		setActive(var26_44, false)

		if var20_44 <= var21_44 then
			arg0_44:emit(CommanderManualMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = arg0_44.techActivity.id
			})
		end

		local var27_44, var28_44 = TechnologyConst.isTecActOn()
		local var29_44 = arg0_44.techFinishTaskId and arg0_44.taskProxy:getTaskVO(arg0_44.techFinishTaskId)
		local var30_44 = arg0_44.phaseId == "ready" or var27_44 and var29_44 and var29_44:isReceive()
		local var31_44 = not var1_44 and not var0_44
		local var32_44 = var30_44 and (arg1_44 ~= 1 or arg0_44.finishPhaseDic[0] or arg0_44.phaseId == 0)
		local var33_44 = var7_44:Find("unlock_btn")
		local var34_44 = var7_44:Find("wait_btn")

		setText(var33_44:Find("Text"), i18n("handbook_research_confirm", i18n("tec_catchup_" .. arg1_44)))
		setText(var34_44:Find("Text"), i18n("handbook_research_final_task_btn_locked"))
		setActive(var33_44, var31_44 and var32_44)
		setActive(var34_44, var0_44 and var21_44 < var20_44)
		onButton(arg0_44, var33_44, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_catchup_confirm"),
				onYes = function()
					if arg1_44 == 1 then
						arg0_44:emit(CommanderManualMediator.ON_TRIGGER, {
							cmd = 3,
							activity_id = arg0_44.techActivity.id
						})
					else
						arg0_44:emit(CommanderManualMediator.ON_TRIGGER, {
							cmd = 1,
							activity_id = arg0_44.techActivity.id,
							arg1 = math.max(arg1_44, 1)
						})
					end
				end
			})
		end, SFX_CONFIRM)
		onButton(arg0_44, var34_44, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("handbook_research_final_task_desc_locked", i18n("tec_catchup_" .. arg1_44)))
		end, SFX_CONFIRM)
	end
end

function var0_0.UpdateTechPageState(arg0_58)
	local var0_58, var1_58 = TechnologyConst.isTecActOn()
	local var2_58 = arg0_58.techFinishTaskId and arg0_58.taskProxy:getTaskVO(arg0_58.techFinishTaskId)
	local var3_58 = arg0_58.phaseId == "ready" or var0_58 and var2_58 and var2_58:isReceive()

	eachChild(arg0_58.techPage:Find("subPageScroll/Viewport/Content"), function(arg0_59, arg1_59)
		local var0_59 = not arg0_58.finishPhaseDic[arg1_59] and arg0_58.phaseId ~= arg1_59
		local var1_59 = var3_58 and (arg1_59 ~= 1 or arg0_58.finishPhaseDic[0] or arg0_58.phaseId == 0)

		setActive(arg0_59:Find("name/lock"), false)
		setActive(arg0_59:Find("select/bg"), not arg0_58.finishPhaseDic[arg1_59])
		setActive(arg0_59:Find("select/bg_end"), arg0_58.finishPhaseDic[arg1_59])

		if var1_59 then
			setActive(arg0_59:Find("tip"), var0_59)
		else
			setActive(arg0_59:Find("tip"), arg1_59 == arg0_58.phaseId and var1_58)
		end
	end)
end

function var0_0.ShowBottomTip(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg1_60:Find("subPageScroll"):GetComponent(typeof(ScrollRect))
	local var1_60 = arg1_60:Find("subPageScroll/Viewport/Content")
	local var2_60 = var1_60:GetComponent(typeof(VerticalLayoutGroup))
	local var3_60 = var2_60.padding.top
	local var4_60 = var2_60.padding.bottom
	local var5_60 = var2_60.spacing
	local var6_60 = var1_60:GetChild(0).rect.height
	local var7_60 = var3_60 + var4_60 + var6_60 * var1_60.childCount + var5_60 * (var1_60.childCount - 1)
	local var8_60 = arg1_60:Find("subPageScroll/Viewport").rect.height

	if var7_60 < var8_60 + var5_60 + var6_60 then
		setActive(arg1_60:Find("bottomTip"), false)

		return
	end

	local var9_60 = math.floor(var8_60 / (var6_60 + var5_60))
	local var10_60 = math.ceil((var1_60.childCount - var9_60) * (1 - arg2_60) + var9_60)

	if var10_60 < var9_60 then
		var10_60 = var9_60
	end

	if var10_60 > var1_60.childCount - 1 then
		setActive(arg1_60:Find("bottomTip"), false)

		return
	end

	setActive(arg1_60:Find("bottomTip"), false)

	for iter0_60 = var10_60, var1_60.childCount - 1 do
		if isActive(var1_60:GetChild(iter0_60):Find("tip")) then
			setActive(arg1_60:Find("bottomTip"), true)

			break
		end
	end
end

function var0_0.TaskAwardsCheckAndSubmit(arg0_61, arg1_61)
	local var0_61 = {}
	local var1_61 = arg1_61:getConfig("award_display")
	local var2_61 = getProxy(PlayerProxy):getRawData()
	local var3_61 = pg.gameset.urpt_chapter_max.description[1]
	local var4_61 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_61)
	local var5_61, var6_61 = Task.StaticJudgeOverflow(var2_61.gold, var2_61.oil, var4_61, true, true, var1_61)

	if var5_61 then
		table.insert(var0_61, function(arg0_62)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_61,
				onYes = arg0_62
			})
		end)
	end

	seriesAsync(var0_61, function()
		arg0_61:emit(CommanderManualMediator.ON_TASK_SUBMIT, arg1_61)
	end)
end

function var0_0.PtAwardsCheckAndSubmit(arg0_64, arg1_64)
	local var0_64 = {}
	local var1_64 = arg1_64:GetCurrentPtAward()
	local var2_64 = getProxy(PlayerProxy):getRawData()
	local var3_64 = pg.gameset.urpt_chapter_max.description[1]
	local var4_64 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_64)
	local var5_64, var6_64 = Task.StaticJudgeOverflow(var2_64.gold, var2_64.oil, var4_64, true, true, var1_64)

	if var5_64 then
		table.insert(var0_64, function(arg0_65)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_64,
				onYes = arg0_65
			})
		end)
	end

	seriesAsync(var0_64, function()
		arg0_64:emit(CommanderManualMediator.GET_PT_AWARD, arg1_64.id)
	end)
end

function var0_0.willExit(arg0_67)
	arg0_67:UnOverlayPanel(arg0_67.blurPanel, arg0_67._tf)
end

function var0_0.onBackPressed(arg0_68)
	arg0_68:closeView()
end

return var0_0

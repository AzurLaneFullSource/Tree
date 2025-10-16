local var0_0 = class("HolidayVillaMapScene", import("view.base.BaseUI"))
local var1_0 = pg.activity_holiday_region
local var2_0 = pg.activity_holiday_site

function var0_0.getUIName(arg0_1)
	return "HolidayVillaMapUI"
end

function var0_0.init(arg0_2)
	arg0_2.mapScroll = arg0_2._tf:Find("mapScroll")
	arg0_2.map = arg0_2._tf:Find("mapScroll/Viewport/map")
	arg0_2.regionList = UIItemList.New(arg0_2.map:Find("regions"), arg0_2.map:Find("regions/region"))
	arg0_2.siteList = UIItemList.New(arg0_2.map:Find("sites"), arg0_2.map:Find("sites/site"))
	arg0_2.ani = arg0_2.map:Find("ani")
	arg0_2.backBtn = arg0_2._tf:Find("ui/top/backBtn")
	arg0_2.homeBtn = arg0_2._tf:Find("ui/top/homeBtn")
	arg0_2.helpBtn = arg0_2._tf:Find("ui/top/helpBtn")
	arg0_2.res = arg0_2._tf:Find("ui/top/res")
	arg0_2.watermelonGameBtn = arg0_2._tf:Find("ui/left/watermelonGameBtn")
	arg0_2.minerGameBtn = arg0_2._tf:Find("ui/left/minerGameBtn")
	arg0_2.springBtn = arg0_2._tf:Find("ui/left/springBtn")
	arg0_2.taskBar = arg0_2._tf:Find("ui/taskBar")
	arg0_2.bookBtn = arg0_2._tf:Find("ui/bookBtn")
	arg0_2.taskBtn = arg0_2._tf:Find("ui/taskBtn")
	arg0_2.shopBtn = arg0_2._tf:Find("ui/shopBtn")
	arg0_2.wharfBtn = arg0_2._tf:Find("ui/wharfBtn")
	arg0_2.mapScaleSlider = arg0_2._tf:Find("ui/mapScaleSlider")
	arg0_2.siteDescPage = arg0_2._tf:Find("subPages/siteDescPage")
	arg0_2.allRepairCompletePage = arg0_2._tf:Find("subPages/allRepairCompletePage")

	setText(arg0_2._tf:Find("ui/bookBtn/name"), i18n("holiday_tip_collection"))
	setText(arg0_2._tf:Find("ui/taskBtn/name"), i18n("holiday_tip_task"))
	setText(arg0_2._tf:Find("ui/shopBtn/name"), i18n("holiday_tip_shop"))
	setText(arg0_2._tf:Find("ui/wharfBtn/name"), i18n("holiday_tip_trans"))
	setText(arg0_2._tf:Find("ui/taskBar/title"), i18n("holiday_tip_task_now"))
	setText(arg0_2.allRepairCompletePage:Find("panel/desc"), i18n("holiday_tip_finish"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	arg0_3:RefreshData()
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.holiday_tip_gametip.tip
		})
	end, SFX_PANEL)

	local var0_3 = arg0_3.mapScroll.rect.width
	local var1_3 = arg0_3.mapScroll.rect.height
	local var2_3 = math.max(var0_3 / 4096, var1_3 / 2522)

	arg0_3.mapScaleSlider:GetComponent(typeof(Slider)).minValue = var2_3
	arg0_3.mapScaleSlider:GetComponent(typeof(Slider)).value = 1

	onSlider(arg0_3, arg0_3.mapScaleSlider, function(arg0_7)
		arg0_3.map.localScale = Vector3(arg0_7, arg0_7, 1)

		local var0_7 = Vector3(1 / arg0_7, 1 / arg0_7, 1)

		for iter0_7 = 0, arg0_3.map:Find("regions").childCount - 1 do
			arg0_3.map:Find("regions"):GetChild(iter0_7).localScale = var0_7
		end

		for iter1_7 = 0, arg0_3.map:Find("sites").childCount - 1 do
			arg0_3.map:Find("sites"):GetChild(iter1_7).localScale = var0_7
		end

		setActive(arg0_3.map:Find("regions"), arg0_7 > 0.75)
		setActive(arg0_3.map:Find("sites"), arg0_7 > 0.75)
	end)
	arg0_3:Show()
	setActive(arg0_3.ani, false)
	setActive(arg0_3.siteDescPage, false)
	setActive(arg0_3.allRepairCompletePage, false)
	pg.NewStoryMgr.GetInstance():Play(arg0_3.firstStory, function()
		if not pg.NewStoryMgr.GetInstance():IsPlayed("HOLIDAY_1") then
			pg.NewGuideMgr.GetInstance():Play("HOLIDAY_1")
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "HOLIDAY_1"
			})
		end
	end)
end

function var0_0.InitData(arg0_9)
	arg0_9.activityId = ActivityConst.HOLIDAY_ACT_ID
	arg0_9.taskActivityId = ActivityConst.HOLIDAY_TASK_ID
	arg0_9.activityProxy = getProxy(ActivityProxy)
	arg0_9.taskProxy = getProxy(TaskProxy)
	arg0_9.activity = arg0_9.activityProxy:getActivityById(arg0_9.activityId)
	arg0_9.exchangeTaskId = arg0_9.activity:getConfig("config_data")[1][1]

	local var0_9 = arg0_9.activity:getConfig("config_client")

	arg0_9.taskIdAndPositions = var0_9.task
	arg0_9.mapTimes = var0_9.endingtime
	arg0_9.funtionIds = var0_9.function_id
	arg0_9.firstStory = var0_9.first_story
end

function var0_0.RefreshData(arg0_10)
	arg0_10.activity = arg0_10.activityProxy:getActivityById(arg0_10.activityId)
	arg0_10.hasExchanged = arg0_10.activity.data1 == 1
	arg0_10.clickedSiteIds = arg0_10.activity:getData1List()
end

function var0_0.Show(arg0_11)
	arg0_11:ExchangeAndSiteClick()
	arg0_11:ShowMap()
	arg0_11:ShowUI()
end

function var0_0.ExchangeAndSiteClick(arg0_12)
	local var0_12 = arg0_12.taskProxy:getFinishTaskById(arg0_12.exchangeTaskId)

	if arg0_12.activity:getData1() == 0 and var0_12 and not arg0_12.doingExchange then
		arg0_12.beforeExchangeResList = {
			{
				66001,
				arg0_12.activity:getVitemNumber(66001)
			},
			{
				66002,
				arg0_12.activity:getVitemNumber(66002)
			},
			{
				66003,
				arg0_12.activity:getVitemNumber(66003)
			},
			{
				66004,
				arg0_12.activity:getVitemNumber(66004)
			},
			{
				66005,
				arg0_12.activity:getVitemNumber(66005)
			}
		}

		arg0_12:emit(HolidayVillaMapMediator.EXCHANGE_RESOURCES, arg0_12.activityId)

		arg0_12.doingExchange = true
	end

	for iter0_12, iter1_12 in ipairs(var1_0.all) do
		local var1_12 = var1_0[iter1_12]

		if arg0_12.taskProxy:getTaskVO(var1_12.task_id):getTaskStatus() == 2 and not table.contains(arg0_12.clickedSiteIds, var1_12.site_id) then
			arg0_12:emit(HolidayVillaMapMediator.SITE_CLICKED, arg0_12.activityId, var1_12.site_id)
		end
	end

	for iter2_12, iter3_12 in ipairs(var2_0.all) do
		local var2_12 = var2_0[iter3_12]

		if var2_12.type == 1 and table.contains(arg0_12.clickedSiteIds, var2_12.id) and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_12.jumpto) then
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = var2_12.jumpto
			})
		end
	end
end

function var0_0.ShowMap(arg0_13)
	local var0_13 = 0

	arg0_13.regionList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var1_0.all[arg1_14 + 1]
			local var1_14 = var1_0[var0_14]
			local var2_14 = var2_0[var1_14.site_id]
			local var3_14 = arg0_13.taskProxy:getTaskVO(var1_14.task_id)
			local var4_14 = var3_14:getTaskStatus()

			if var2_14.task_id == 0 then
				setActive(arg2_14, var4_14 ~= 2)
			else
				local var5_14 = arg0_13.taskProxy:getTaskVO(var2_14.task_id):getTaskStatus()

				setActive(arg2_14, var5_14 == 2 and var4_14 ~= 2)
			end

			if var4_14 ~= 2 then
				arg2_14.anchoredPosition = Vector2(var1_14.locate[1], var1_14.locate[2])

				setText(arg2_14:Find("name"), var2_14.name)

				local var6_14 = var3_14:getConfig("target_id_2")

				arg0_13:SetRes(arg2_14:Find("res"), var6_14)
				onButton(arg0_13, arg2_14, function()
					for iter0_15, iter1_15 in ipairs(var6_14) do
						local var0_15 = iter1_15[1]

						if iter1_15[2] > arg0_13.activity:getVitemNumber(var0_15) then
							pg.TipsMgr.GetInstance():ShowTips(i18n("holiday_tip_rebuild_not"))

							return
						end
					end

					setActive(arg0_13.ani, true)

					arg0_13.ani.anchoredPosition = Vector2(var1_14.rebuild_ani[1], var1_14.rebuild_ani[2])

					SetActionCallback(arg0_13.ani, function(arg0_16)
						if arg0_16 == "finish" then
							setActive(arg0_13.ani, false)
							arg0_13:emit(HolidayVillaMapMediator.ON_TASK_SUBMIT_ONESTEP, arg0_13.taskActivityId, {
								var1_14.task_id
							}, function(arg0_17)
								if arg0_17 then
									local var0_17

									if var0_14 == 1 then
										var0_17 = "HOLIDAY_2"
									elseif var0_14 == 3 then
										var0_17 = "HOLIDAY_3"
									elseif var0_14 == 4 then
										var0_17 = "HOLIDAY_4"
									elseif var0_14 == 5 then
										var0_17 = "HOLIDAY_5"
									elseif var0_14 == 6 then
										var0_17 = "HOLIDAY_6"
									end

									arg0_13:ShowSiteDescPage(var2_14, true, function()
										if var0_17 and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_17) then
											pg.NewGuideMgr.GetInstance():Play(var0_17)
											pg.m02:sendNotification(GAME.STORY_UPDATE, {
												storyId = var0_17
											})
										end
									end)
									arg0_13:emit(HolidayVillaMapMediator.SITE_CLICKED, arg0_13.activityId, var1_14.site_id)
								end
							end)
						end
					end)
					SetAction(arg0_13.ani, "normal", false)
				end, SFX_PANEL)
			else
				var0_13 = var0_13 + 1
			end
		end
	end)
	arg0_13.regionList:align(#var1_0.all)

	for iter0_13 = 0, 8 do
		setActive(arg0_13.map:GetChild(iter0_13), false)
	end

	if var0_13 ~= 6 then
		setActive(arg0_13.map:Find("bg" .. var0_13), true)
	else
		local var1_13 = pg.TimeMgr.GetInstance():GetServerHour()

		for iter1_13, iter2_13 in ipairs(arg0_13.mapTimes) do
			local var2_13 = iter2_13[1][1]
			local var3_13 = iter2_13[1][2]
			local var4_13 = iter2_13[2]
			local var5_13 = iter2_13[3]

			if var2_13 <= var1_13 and var1_13 < var3_13 then
				setActive(arg0_13.map:Find("bg" .. var0_13 .. "_" .. var4_13), true)

				if arg0_13.bgm ~= var5_13 then
					arg0_13.bgm = var5_13

					pg.BgmMgr.GetInstance():Push(arg0_13.__cname, var5_13)
				end

				break
			end
		end
	end

	local var6_13 = {
		1,
		2,
		3
	}
	local var7_13 = Clone(var2_0.all)

	for iter3_13 = #var7_13, 1, -1 do
		if not table.contains(var6_13, var2_0[var7_13[iter3_13]].type) then
			table.remove(var7_13, iter3_13)
		end
	end

	arg0_13.siteList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var7_13[arg1_19 + 1]
			local var1_19 = var2_0[var0_19]
			local var2_19 = var1_19.type
			local var3_19 = arg0_13.taskProxy:getFinishTaskById(var1_19.task_id)

			setActive(arg2_19:Find("1"), var2_19 == 2)
			setActive(arg2_19:Find("2"), var2_19 == 1 or var2_19 == 3)

			if var3_19 and not table.contains(arg0_13.clickedSiteIds, var0_19) then
				arg2_19.anchoredPosition = Vector2(var1_19.locate[1], var1_19.locate[2])

				if var2_19 == 1 then
					for iter0_19 = 0, arg2_19:Find("2").childCount - 1 do
						local var4_19 = arg2_19:Find("2"):GetChild(iter0_19)

						setActive(var4_19, var4_19.name == var1_19.icon)
					end

					onButton(arg0_13, arg2_19, function()
						pg.NewStoryMgr.GetInstance():Play(var1_19.jumpto)
						arg0_13:emit(HolidayVillaMapMediator.SITE_CLICKED, arg0_13.activityId, var0_19)
					end, SFX_PANEL)
				elseif var2_19 == 2 then
					setText(arg2_19:Find("1/name"), var1_19.name)
					onButton(arg0_13, arg2_19, function()
						if var0_19 == arg0_13.funtionIds[1] then
							triggerButton(arg0_13.watermelonGameBtn)
						elseif var0_19 == arg0_13.funtionIds[2] then
							triggerButton(arg0_13.minerGameBtn)
						elseif var0_19 == arg0_13.funtionIds[3] then
							triggerButton(arg0_13.springBtn)
						elseif var0_19 == arg0_13.funtionIds[4] then
							triggerButton(arg0_13.wharfBtn)
						end
					end, SFX_PANEL)
				elseif var2_19 == 3 then
					for iter1_19 = 0, arg2_19:Find("2").childCount - 1 do
						local var5_19 = arg2_19:Find("2"):GetChild(iter1_19)

						setActive(var5_19, var5_19.name == var1_19.icon)
					end

					onButton(arg0_13, arg2_19, function()
						arg0_13:ShowSiteDescPage(var1_19, false)
						arg0_13:emit(HolidayVillaMapMediator.SITE_CLICKED, arg0_13.activityId, var0_19)
					end, SFX_PANEL)
				end
			else
				setActive(arg2_19, false)
			end
		end
	end)
	arg0_13.siteList:align(#var7_13)
end

function var0_0.ShowUI(arg0_23)
	local var0_23 = {
		{
			66001,
			arg0_23.activity:getVitemNumber(66001)
		},
		{
			66002,
			arg0_23.activity:getVitemNumber(66002)
		},
		{
			66003,
			arg0_23.activity:getVitemNumber(66003)
		},
		{
			66004,
			arg0_23.activity:getVitemNumber(66004)
		}
	}

	arg0_23:SetRes(arg0_23.res, var0_23)

	local var1_23 = var2_0[arg0_23.funtionIds[1]].task_id
	local var2_23 = arg0_23.taskProxy:getFinishTaskById(var1_23)

	setActive(arg0_23.watermelonGameBtn:Find("lock"), not var2_23)
	setActive(arg0_23.watermelonGameBtn:Find("remain"), var2_23)

	if var2_23 then
		setText(arg0_23.watermelonGameBtn:Find("remain/Text"), getProxy(MiniGameProxy):GetHubByGameId(76).count)
		onButton(arg0_23, arg0_23.watermelonGameBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.OPEN_MINI_GAME, 76)
		end, SFX_PANEL)
	else
		onButton(arg0_23, arg0_23.watermelonGameBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_holiday_function_lock"))
		end, SFX_PANEL)
	end

	local var3_23 = var2_0[arg0_23.funtionIds[2]].task_id
	local var4_23 = arg0_23.taskProxy:getFinishTaskById(var3_23)

	setActive(arg0_23.minerGameBtn:Find("lock"), not var4_23)
	setActive(arg0_23.minerGameBtn:Find("remain"), var4_23)

	if var4_23 then
		setText(arg0_23.minerGameBtn:Find("remain/Text"), getProxy(MiniGameProxy):GetHubByGameId(77).count)
		onButton(arg0_23, arg0_23.minerGameBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.OPEN_MINI_GAME, 77)
		end, SFX_PANEL)
	else
		onButton(arg0_23, arg0_23.minerGameBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_holiday_function_lock"))
		end, SFX_PANEL)
	end

	local var5_23 = var2_0[arg0_23.funtionIds[3]].task_id
	local var6_23 = arg0_23.taskProxy:getFinishTaskById(var5_23)

	setActive(arg0_23.springBtn:Find("lock"), not var6_23)
	setActive(arg0_23.springBtn:Find("tip"), var6_23)

	if var6_23 then
		setActive(arg0_23.springBtn:Find("tip"), false)
		onButton(arg0_23, arg0_23.springBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.GO_HOTSPRING)
		end, SFX_PANEL)
	else
		onButton(arg0_23, arg0_23.springBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_holiday_function_lock"))
		end, SFX_PANEL)
	end

	local var7_23 = arg0_23.taskIdAndPositions[1][1]
	local var8_23 = arg0_23.taskProxy:getFinishTaskById(var7_23)

	setActive(arg0_23.bookBtn, var8_23)
	setActive(arg0_23.taskBtn, var8_23)
	setActive(arg0_23.shopBtn, var8_23)
	setActive(arg0_23.wharfBtn, var8_23)

	if var8_23 then
		setActive(arg0_23.bookBtn:Find("tip"), CollectionBookMediator.GetCollectionBookTip())
		onButton(arg0_23, arg0_23.bookBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.ON_BOOK)
		end, SFX_PANEL)
		setActive(arg0_23.taskBtn:Find("tip"), HolidayVillaTasksLayer.ShouldShowTip())
		onButton(arg0_23, arg0_23.taskBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.OPEN_HolidayVilla_TASk)
		end, SFX_PANEL)
		setText(arg0_23.shopBtn:Find("res/Text"), arg0_23.activity:getVitemNumber(66005))
		onButton(arg0_23, arg0_23.shopBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.ON_SHOP)
		end, SFX_PANEL)
		setText(arg0_23.wharfBtn:Find("res/Text"), arg0_23.activity:getVitemNumber(66006))
		onButton(arg0_23, arg0_23.wharfBtn, function()
			arg0_23:emit(HolidayVillaMapMediator.OPEN_WHARF)
		end, SFX_PANEL)
	end

	arg0_23:SetTaskBar()
end

function var0_0.SetRes(arg0_34, arg1_34, arg2_34)
	for iter0_34 = 0, arg1_34.childCount - 1 do
		setActive(arg1_34:GetChild(iter0_34), false)
	end

	for iter1_34, iter2_34 in ipairs(arg2_34) do
		local var0_34 = iter2_34[1]
		local var1_34 = iter2_34[2]

		for iter3_34 = 0, arg1_34.childCount - 1 do
			local var2_34 = arg1_34:GetChild(iter3_34)

			if var2_34.name == tostring(var0_34) then
				setActive(var2_34, true)
				setText(var2_34:Find("Text"), var1_34)

				break
			end
		end
	end
end

function var0_0.SetTaskBar(arg0_35)
	local var0_35 = false

	for iter0_35, iter1_35 in ipairs(arg0_35.taskIdAndPositions) do
		local var1_35 = iter1_35[1]
		local var2_35 = iter1_35[2]
		local var3_35 = arg0_35.taskProxy:getTaskVO(var1_35)

		if var3_35:getTaskStatus() ~= 2 then
			var0_35 = true

			if arg0_35.nowTaskId ~= var1_35 then
				arg0_35.nowTaskId = var1_35
				arg0_35.initTaskPosition = false
			end

			setText(arg0_35.taskBar:Find("desc"), var3_35:getConfig("desc"))
			onButton(arg0_35, arg0_35.taskBar, function()
				arg0_35.mapScaleSlider:GetComponent(typeof(Slider)).value = 1

				local var0_36 = arg0_35.mapScroll.rect.width
				local var1_36 = arg0_35.mapScroll.rect.height

				scrollTo(arg0_35.mapScroll, ((4096 - var0_36) / 2 - var2_35[1]) / (4096 - var0_36), ((2522 - var1_36) / 2 - var2_35[2]) / (2522 - var1_36))
			end, SFX_PANEL)

			break
		end
	end

	if not var0_35 then
		setText(arg0_35.taskBar:Find("desc"), i18n("holiday_tip_task_finish"))
		onButton(arg0_35, arg0_35.taskBar, function()
			arg0_35.mapScaleSlider:GetComponent(typeof(Slider)).value = 1

			scrollTo(arg0_35.mapScroll, 0.5, 0.5)
		end, SFX_PANEL)
	end

	if not arg0_35.initTaskPosition then
		arg0_35.initTaskPosition = true

		triggerButton(arg0_35.taskBar)
	end
end

function var0_0.ShowSiteDescPage(arg0_38, arg1_38, arg2_38, arg3_38)
	setActive(arg0_38.siteDescPage, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_38.siteDescPage)
	setActive(arg0_38.siteDescPage:Find("repairComplete"), arg2_38)
	setText(arg0_38.siteDescPage:Find("panel/name"), arg1_38.jumpto[1][1])
	setText(arg0_38.siteDescPage:Find("panel/desc"), arg1_38.jumpto[2][1])
	LoadImageSpriteAsync(arg1_38.jumpto[3][1], arg0_38.siteDescPage:Find("panel/picBg/mask/picture"))
	onButton(arg0_38, arg0_38.siteDescPage:Find("bg"), function()
		setActive(arg0_38.siteDescPage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38.siteDescPage, arg0_38._tf:Find("subPages"))

		if arg3_38 then
			arg3_38()
		end
	end, SFX_CANCEL)
	onButton(arg0_38, arg0_38.siteDescPage:Find("closeBtn"), function()
		setActive(arg0_38.siteDescPage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_38.siteDescPage, arg0_38._tf:Find("subPages"))

		if arg3_38 then
			arg3_38()
		end
	end, SFX_CANCEL)
end

function var0_0.ShowAllRepairPage(arg0_41)
	setActive(arg0_41.allRepairCompletePage, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_41.allRepairCompletePage)
	arg0_41:SetRes(arg0_41.allRepairCompletePage:Find("panel/source/res"), arg0_41.beforeExchangeResList)
	setText(arg0_41.allRepairCompletePage:Find("panel/destination/res/Text"), arg0_41.activity:getVitemNumber(66005) - arg0_41.beforeExchangeResList[5][2])
	onButton(arg0_41, arg0_41.allRepairCompletePage:Find("bg"), function()
		setActive(arg0_41.allRepairCompletePage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_41.allRepairCompletePage, arg0_41._tf:Find("subPages"))
	end, SFX_CANCEL)
	onButton(arg0_41, arg0_41.allRepairCompletePage:Find("closeBtn"), function()
		setActive(arg0_41.allRepairCompletePage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_41.allRepairCompletePage, arg0_41._tf:Find("subPages"))
	end, SFX_CANCEL)
end

function var0_0.willExit(arg0_44)
	return
end

function var0_0.onBackPressed(arg0_45)
	if isActive(arg0_45.siteDescPage) then
		setActive(arg0_45.siteDescPage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_45.siteDescPage, arg0_45._tf:Find("subPages"))

		return
	end

	if isActive(arg0_45.allRepairCompletePage) then
		setActive(arg0_45.allRepairCompletePage, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_45.allRepairCompletePage, arg0_45._tf:Find("subPages"))

		return
	end

	arg0_45:closeView()
end

function var0_0.IsShowMainTip(arg0_46)
	local var0_46 = arg0_46:getConfig("config_client").task
	local var1_46 = arg0_46:getConfig("config_client").function_id
	local var2_46 = var2_0[var1_46[1]].task_id
	local var3_46 = getProxy(TaskProxy):getFinishTaskById(var2_46)
	local var4_46 = var2_0[var1_46[2]].task_id
	local var5_46 = getProxy(TaskProxy):getFinishTaskById(var4_46)
	local var6_46 = var0_46[1][1]
	local var7_46 = getProxy(TaskProxy):getFinishTaskById(var6_46)

	return var3_46 and getProxy(MiniGameProxy):GetHubByGameId(76).count > 0 or var5_46 and getProxy(MiniGameProxy):GetHubByGameId(77).count > 0 or var7_46 and CollectionBookMediator.GetCollectionBookTip() or var7_46 and HolidayVillaTasksLayer.ShouldShowTip()
end

return var0_0

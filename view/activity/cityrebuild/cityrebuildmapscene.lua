local var0_0 = class("CityRebuildMapScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CityRebuildMapUI"
end

function var0_0.init(arg0_2)
	arg0_2.ui = arg0_2._tf:Find("ui")
	arg0_2.backBtn = arg0_2.ui:Find("top/backBtn")
	arg0_2.helpBtn = arg0_2.ui:Find("top/helpBtn")
	arg0_2.homeBtn = arg0_2.ui:Find("top/homeBtn")
	arg0_2.cityLevel = arg0_2.ui:Find("left/cityLevel/Text")
	arg0_2.battleLevel = arg0_2.ui:Find("left/battleLevel/Text")
	arg0_2.battleBtn = arg0_2.ui:Find("right/battleBtn")
	arg0_2.taskBtn = arg0_2.ui:Find("right/taskBtn")
	arg0_2.bookBtn = arg0_2.ui:Find("right/bookBtn")
	arg0_2.storyBtn = arg0_2.ui:Find("right/storyBtn")
	arg0_2.award = arg0_2.ui:Find("left/award")
	arg0_2.charaList = UIItemList.New(arg0_2._tf:Find("charas"), arg0_2._tf:Find("charas/chara"))
	arg0_2.buildingList = UIItemList.New(arg0_2._tf:Find("buildings"), arg0_2._tf:Find("buildings/building"))
	arg0_2.storyList = UIItemList.New(arg0_2._tf:Find("stories"), arg0_2._tf:Find("stories/story"))

	setText(arg0_2.ui:Find("right/tip"), i18n("ninja_game_booktip"))
	setText(arg0_2.ui:Find("left/cityLevel/title"), i18n("ninja_game_citylevel"))
	setText(arg0_2.ui:Find("left/battleLevel/title"), i18n("ninja_game_wave"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	arg0_3:emit(CityRebuildMapMediator.GET_DATA, arg0_3.activityId)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(CityRebuildMapMediator.OPEN_BATTLE)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.taskBtn, function()
		arg0_3:emit(CityRebuildMapMediator.OPEN_TASKS)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.bookBtn, function()
		arg0_3:emit(CityRebuildMapMediator.OPEN_BOOK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.storyBtn, function()
		arg0_3:emit(CityRebuildMapMediator.OPEN_STORY)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ninja_game_helper.tip
		})
	end, SFX_PANEL)
	pg.NewStoryMgr.GetInstance():Play(pg.activity_ninja_city[1].story)
end

function var0_0.InitData(arg0_11)
	arg0_11.activityId = ActivityConst.NINJA_CITY_ACT_ID
	arg0_11.cityRebuildProxy = getProxy(CityRebuildProxy)
	arg0_11.taskProxy = getProxy(TaskProxy)
	arg0_11.storyTaskId = pg.activity_template[arg0_11.activityId].config_client.task_id
end

function var0_0.Refresh(arg0_12)
	arg0_12.cityRebuildData = arg0_12.cityRebuildProxy:GetData(arg0_12.activityId)

	setText(arg0_12.cityLevel, "LV." .. arg0_12.cityRebuildData.cityLevel)
	setText(arg0_12.battleLevel, arg0_12.cityRebuildData.maxChooseLevel)

	local var0_12 = arg0_12.taskProxy:getTaskVO(arg0_12.storyTaskId)

	setText(arg0_12.award:Find("title"), var0_12:getConfig("desc"))
	setText(arg0_12.award:Find("title/Text"), var0_12:getProgress() .. "/" .. var0_12:getTargetNumber())

	local var1_12 = var0_12:getConfig("award_display")[1]
	local var2_12 = {
		type = var1_12[1],
		id = var1_12[2],
		count = var1_12[3]
	}

	updateDrop(arg0_12.award:Find("IconTpl"), var2_12)

	local var3_12 = var0_12:isReceive()

	setActive(arg0_12.award:Find("got"), var3_12)
	onButton(arg0_12, arg0_12.award, function()
		arg0_12:emit(BaseUI.ON_DROP, var2_12)
	end, SFX_PANEL)
	arg0_12:SetCharaList()
	arg0_12:SetBuildingList()
	arg0_12:SetStoryList()

	for iter0_12 = 2, 5 do
		local var4_12 = arg0_12._tf:Find("bg/" .. iter0_12)

		setActive(var4_12, iter0_12 > arg0_12.cityRebuildData.cityLevel)
	end

	setActive(arg0_12.bookBtn:Find("tip"), CityRebuildBookLayer.ShouldShowTip())
	setActive(arg0_12.taskBtn:Find("tip"), CityRebuildTasksLayer.ShouldShowTip())
end

function var0_0.SetCharaList(arg0_14)
	arg0_14.charaList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_14.cityRebuildData.allCharaIds[arg1_15 + 1]
			local var1_15 = pg.activity_ninja_building[var0_15]
			local var2_15 = arg0_14.cityRebuildData:IsRepairedOrRecruited(var0_15)
			local var3_15 = var2_15 and var1_15.icon[2] or var1_15.icon[1]
			local var4_15 = var2_15 and var1_15.pos[2] or var1_15.pos[1]

			setActive(arg2_15, var3_15 ~= "")

			if var3_15 ~= "" then
				GetImageSpriteFromAtlasAsync(var3_15, "", arg2_15)

				arg2_15.anchoredPosition = Vector2(var4_15[1], var4_15[2])

				setActive(arg2_15:Find("name"), false)
			end
		end
	end)
	arg0_14.charaList:align(#arg0_14.cityRebuildData.allCharaIds)
end

function var0_0.SetBuildingList(arg0_16)
	arg0_16.buildingList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg0_16.cityRebuildData.allBuildingIds[arg1_17 + 1]
			local var1_17 = pg.activity_ninja_building[var0_17]
			local var2_17 = arg0_16.cityRebuildData:IsRepairedOrRecruited(var0_17)
			local var3_17 = arg0_16.cityRebuildData:IsUnlock(var0_17)
			local var4_17 = var2_17 and var1_17.icon[2] or var1_17.icon[1]
			local var5_17 = var2_17 and var1_17.pos[2] or var1_17.pos[1]

			setActive(arg2_17, var4_17 ~= "")

			if var4_17 ~= "" then
				GetImageSpriteFromAtlasAsync(var4_17, "", arg2_17)

				arg2_17.anchoredPosition = Vector2(var5_17[1], var5_17[2])

				setActive(arg2_17:Find("name"), var3_17)

				if var3_17 then
					onButton(arg0_16, arg2_17, function()
						arg0_16:emit(CityRebuildMapMediator.OPEN_BOOK, CityRebuildBookLayer.Building, var0_17)
					end, SFX_PANEL)
					setText(arg2_17:Find("name/Text"), var2_17 and var1_17.name[2] or var1_17.name[1])
				end
			end
		end
	end)
	arg0_16.buildingList:align(#arg0_16.cityRebuildData.allBuildingIds)
end

function var0_0.SetStoryList(arg0_19)
	local var0_19 = pg.activity_ninja_building.all

	arg0_19.storyList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = var0_19[arg1_20 + 1]
			local var1_20 = pg.activity_ninja_building[var0_20]
			local var2_20 = arg0_19.cityRebuildData:IsRepairedOrRecruited(var0_20) and var1_20.story or ""

			setActive(arg2_20, var2_20 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_20[1]))

			if var2_20 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var2_20[1]) then
				GetImageSpriteFromAtlasAsync(var2_20[2], "", arg2_20:Find("icon"))

				local var3_20 = var2_20[3]

				arg2_20.anchoredPosition = Vector2(var3_20[1], var3_20[2])

				onButton(arg0_19, arg2_20, function()
					pg.NewStoryMgr.GetInstance():Play(var2_20[1])
				end, SFX_PANEL)
				setText(arg2_20:Find("name/Text"), var2_20[5])
			end
		end
	end)
	arg0_19.storyList:align(#var0_19)
end

function var0_0.willExit(arg0_22)
	return
end

return var0_0

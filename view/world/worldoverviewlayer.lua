local var0_0 = class("WorldOverviewLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldOverviewUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {
		"scenes/worldoverview"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.preload(arg0_3, arg1_3)
	arg0_3:LoadAtlasOverall(arg1_3)
end

function var0_0.init(arg0_4)
	local var0_4 = arg0_4._tf

	arg0_4.rtBg = var0_4:Find("bg")

	onButton(arg0_4, arg0_4.rtBg, function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	setText(var0_4:Find("tip/Text"), i18n("click_back_tip"))

	arg0_4.rtTaskPanel = var0_4:Find("panel/middle/info_panel/task_panel")

	setActive(arg0_4.rtTaskPanel, false)
	setActive(arg0_4.rtTaskPanel:Find("btn_next"), false)

	arg0_4.entranceItemList = UIItemList.New(arg0_4.rtTaskPanel:Find("entrance_list/target_list"), arg0_4.rtTaskPanel:Find("entrance_list/target_tpl"))

	arg0_4.entranceItemList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			if arg0_4.entranceIds[arg1_6] then
				local var0_6 = nowWorld():GetEntrance(arg0_4.entranceIds[arg1_6])

				setActive(arg2_6:Find("Image"), true)
				setText(arg2_6:Find("Text"), i18n("world_task_view1") .. var0_6:GetBaseMap():GetName())
			else
				setActive(arg2_6:Find("Image"), true)
				setText(arg2_6:Find("Text"), i18n("world_task_view1") .. i18n("world_task_view2"))
			end
		end
	end)

	arg0_4.areaItemList = UIItemList.New(arg0_4.rtTaskPanel:Find("entrance_list/target_list"), arg0_4.rtTaskPanel:Find("entrance_list/target_tpl"))

	arg0_4.areaItemList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			if arg0_4.areaIds[arg1_7] then
				setActive(arg2_7:Find("Image"), true)
				setText(arg2_7:Find("Text"), i18n("world_task_view1") .. pg.world_regions_data[arg0_4.areaIds[arg1_7]].name)
			else
				setActive(arg2_7:Find("Image"), true)
				setText(arg2_7:Find("Text"), i18n("world_task_view1") .. i18n("world_task_view2"))
			end
		end
	end)

	arg0_4.rtAchievementPanel = var0_4:Find("panel/middle/info_panel/achievement_panel")

	setActive(arg0_4.rtAchievementPanel, false)

	arg0_4.btnAchieve = arg0_4.rtAchievementPanel:Find("btn_all")

	onButton(arg0_4, arg0_4.btnAchieve, function()
		local var0_8, var1_8 = nowWorld():GetFinishAchievements()

		if #var0_8 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without any award")
		else
			arg0_4:emit(WorldOverviewMediator.OnAchieveStar, var0_8)
			arg0_4:closeView()
		end
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.didEnter(arg0_9)
	local var0_9 = arg0_9.contextData.info

	arg0_9.mode = var0_9.mode

	if arg0_9.mode == "Task" then
		arg0_9.taskId = var0_9.taskId

		arg0_9:UpdateTaskPanel()
	elseif arg0_9.mode == "Achievement" then
		arg0_9:UpdateAchievementPanel()
	else
		arg0_9.entranceIds = var0_9.ids
	end

	arg0_9._tf:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_10)
		local var0_10 = {}

		_.each(arg0_9.entranceIds, function(arg0_11)
			var0_10[arg0_11] = true
		end)

		if #arg0_9.entranceIds > 0 then
			arg0_9.wsAtlasOverall:UpdateTargetEntrance(arg0_9.entranceIds[1])
		end

		arg0_9.wsAtlasOverall:UpdateStaticMark(var0_10, arg0_9:GetOverviewMark())
		arg0_9:DisplayAtlasOverall()

		if arg0_9.mode then
			setActive(arg0_9["rt" .. arg0_9.mode .. "Panel"], true)

			if arg0_9.mode == "Task" then
				eachChild(arg0_9.entranceItemList.container, function(arg0_12)
					local var0_12 = GetComponent(arg0_12:Find("Text"), typeof(Typewriter))

					var0_12:setSpeed(0.03)
					var0_12:Play()
				end)

				local var1_10 = arg0_9.rtTaskPanel:Find("entrance_list/target_tpl")
				local var2_10 = GetComponent(var1_10:Find("Text"), typeof(Typewriter))

				var2_10:setSpeed(0.03)
				var2_10:Play()
			end
		end
	end)
end

function var0_0.willExit(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)

	if arg0_13.mode then
		setActive(arg0_13["rt" .. arg0_13.mode .. "Panel"], false)
	end

	arg0_13:HideAtlasOverall()
	arg0_13:DisposeAtlasOverall()
end

function var0_0.GetOverviewMark(arg0_14)
	if arg0_14.mode == "Task" then
		if arg0_14.isTaskArea then
			return {
				"overview_port"
			}
		else
			return {
				"overview_task_port",
				"overview_task"
			}
		end
	elseif arg0_14.mode == "Achievement" then
		return {
			"overview_achievement",
			"overview_achievement"
		}
	else
		return {
			"overview_task_port",
			"overview_task"
		}
	end
end

function var0_0.UpdateTaskPanel(arg0_15)
	local var0_15 = nowWorld()
	local var1_15 = var0_15:GetTaskProxy():getTaskById(arg0_15.taskId)

	assert(var1_15, "without this doing task: " .. arg0_15.taskId)

	local var2_15 = arg0_15.rtTaskPanel:Find("task_info")

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", pg.WorldToastMgr.Type2PictrueName[var1_15.config.type], var2_15:Find("type"), true)
	setText(var2_15:Find("name/Text"), var1_15.config.name)

	local var3_15 = var1_15:GetFollowingAreaId()

	if var3_15 then
		arg0_15.isTaskArea = true
		arg0_15.entranceIds = underscore.to_array(var0_15:GetAreaEntranceIds(var3_15))
		arg0_15.areaIds = {
			var3_15
		}

		arg0_15.areaItemList:align(math.max(#arg0_15.areaIds, 1))
	else
		arg0_15.isTaskArea = false
		arg0_15.entranceIds = {
			var1_15:GetFollowingEntrance()
		}

		arg0_15.entranceItemList:align(math.max(#arg0_15.entranceIds, 1))
	end

	local var4_15 = arg0_15.rtTaskPanel:Find("entrance_list/target_tpl")
	local var5_15 = var0_15:GetActiveEntrance()

	setActive(var4_15:Find("Image"), false)
	setText(var4_15:Find("Text"), i18n("world_task_view2") .. var5_15:GetBaseMap():GetName())
end

function var0_0.UpdateAchievementPanel(arg0_16)
	local var0_16 = nowWorld()
	local var1_16, var2_16, var3_16 = var0_16:CountAchievements()

	setText(arg0_16.rtAchievementPanel:Find("achievement_info/name/info/number"), var1_16 + var2_16 .. "/" .. var3_16)

	local var4_16, var5_16 = var0_16:GetFinishAchievements()
	local var6_16 = 0

	for iter0_16, iter1_16 in ipairs(var4_16) do
		var6_16 = var6_16 + #iter1_16.star_list
	end

	local var7_16 = arg0_16.rtAchievementPanel:Find("word_list/target_tpl")

	setActive(var7_16:Find("Image"), true)
	setText(var7_16:Find("Text"), i18n("world_target_count", "  " .. setColorStr(tostring(var6_16), COLOR_YELLOW) .. "  "))

	arg0_16.entranceIds = var5_16

	local var8_16 = pg.gameset.world_target_obtain.key_value

	setActive(arg0_16.btnAchieve, var8_16 <= #var4_16)
end

function var0_0.DisplayAtlasOverall(arg0_17)
	if arg0_17.wsAtlasOverall then
		setActive(arg0_17.wsAtlasOverall.tfEntity:Find("Plane"), false)
		arg0_17.wsAtlasOverall:ShowOrHide(true)
	end
end

function var0_0.HideAtlasOverall(arg0_18)
	if arg0_18.wsAtlasOverall then
		arg0_18.wsAtlasOverall:ShowOrHide(false)
	end
end

function var0_0.LoadAtlasOverall(arg0_19, arg1_19)
	local var0_19 = {}

	if not arg0_19.wsAtlasOverall then
		table.insert(var0_19, function(arg0_20)
			arg0_19.wsAtlasOverall = WSAtlasOverall.New()

			arg0_19.wsAtlasOverall:Setup()
			arg0_19.wsAtlasOverall:LoadScene(function()
				arg0_19.wsAtlasOverall:UpdateAtlas(nowWorld():GetAtlas())

				return arg0_20()
			end)
		end)
	end

	seriesAsync(var0_19, function()
		return existCall(arg1_19)
	end)
end

function var0_0.DisposeAtlasOverall(arg0_23)
	if arg0_23.wsAtlasOverall then
		arg0_23.wsAtlasOverall:Dispose()

		arg0_23.wsAtlasOverall = nil
	end
end

return var0_0

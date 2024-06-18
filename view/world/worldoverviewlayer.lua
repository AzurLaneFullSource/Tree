local var0_0 = class("WorldOverviewLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldOverviewUI"
end

function var0_0.preload(arg0_2, arg1_2)
	arg0_2:LoadAtlasOverall(arg1_2)
end

function var0_0.init(arg0_3)
	local var0_3 = arg0_3._tf

	arg0_3.rtBg = var0_3:Find("bg")

	onButton(arg0_3, arg0_3.rtBg, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	setText(var0_3:Find("tip/Text"), i18n("click_back_tip"))

	arg0_3.rtTaskPanel = var0_3:Find("panel/middle/info_panel/task_panel")

	setActive(arg0_3.rtTaskPanel, false)
	setActive(arg0_3.rtTaskPanel:Find("btn_next"), false)

	arg0_3.entranceItemList = UIItemList.New(arg0_3.rtTaskPanel:Find("entrance_list/target_list"), arg0_3.rtTaskPanel:Find("entrance_list/target_tpl"))

	arg0_3.entranceItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			if arg0_3.entranceIds[arg1_5] then
				local var0_5 = nowWorld():GetEntrance(arg0_3.entranceIds[arg1_5])

				setActive(arg2_5:Find("Image"), true)
				setText(arg2_5:Find("Text"), i18n("world_task_view1") .. var0_5:GetBaseMap():GetName())
			else
				setActive(arg2_5:Find("Image"), true)
				setText(arg2_5:Find("Text"), i18n("world_task_view1") .. i18n("world_task_view2"))
			end
		end
	end)

	arg0_3.areaItemList = UIItemList.New(arg0_3.rtTaskPanel:Find("entrance_list/target_list"), arg0_3.rtTaskPanel:Find("entrance_list/target_tpl"))

	arg0_3.areaItemList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			if arg0_3.areaIds[arg1_6] then
				setActive(arg2_6:Find("Image"), true)
				setText(arg2_6:Find("Text"), i18n("world_task_view1") .. pg.world_regions_data[arg0_3.areaIds[arg1_6]].name)
			else
				setActive(arg2_6:Find("Image"), true)
				setText(arg2_6:Find("Text"), i18n("world_task_view1") .. i18n("world_task_view2"))
			end
		end
	end)

	arg0_3.rtAchievementPanel = var0_3:Find("panel/middle/info_panel/achievement_panel")

	setActive(arg0_3.rtAchievementPanel, false)

	arg0_3.btnAchieve = arg0_3.rtAchievementPanel:Find("btn_all")

	onButton(arg0_3, arg0_3.btnAchieve, function()
		local var0_7, var1_7 = nowWorld():GetFinishAchievements()

		if #var0_7 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without any award")
		else
			arg0_3:emit(WorldOverviewMediator.OnAchieveStar, var0_7)
			arg0_3:closeView()
		end
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		blurLevelCamera = true,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.didEnter(arg0_8)
	local var0_8 = arg0_8.contextData.info

	arg0_8.mode = var0_8.mode

	if arg0_8.mode == "Task" then
		arg0_8.taskId = var0_8.taskId

		arg0_8:UpdateTaskPanel()
	elseif arg0_8.mode == "Achievement" then
		arg0_8:UpdateAchievementPanel()
	else
		arg0_8.entranceIds = var0_8.ids
	end

	arg0_8._tf:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_9)
		local var0_9 = {}

		_.each(arg0_8.entranceIds, function(arg0_10)
			var0_9[arg0_10] = true
		end)

		if #arg0_8.entranceIds > 0 then
			arg0_8.wsAtlasOverall:UpdateTargetEntrance(arg0_8.entranceIds[1])
		end

		arg0_8.wsAtlasOverall:UpdateStaticMark(var0_9, arg0_8:GetOverviewMark())
		arg0_8:DisplayAtlasOverall()

		if arg0_8.mode then
			setActive(arg0_8["rt" .. arg0_8.mode .. "Panel"], true)

			if arg0_8.mode == "Task" then
				eachChild(arg0_8.entranceItemList.container, function(arg0_11)
					local var0_11 = GetComponent(arg0_11:Find("Text"), typeof(Typewriter))

					var0_11:setSpeed(0.03)
					var0_11:Play()
				end)

				local var1_9 = arg0_8.rtTaskPanel:Find("entrance_list/target_tpl")
				local var2_9 = GetComponent(var1_9:Find("Text"), typeof(Typewriter))

				var2_9:setSpeed(0.03)
				var2_9:Play()
			end
		end
	end)
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parentTf)

	if arg0_12.mode then
		setActive(arg0_12["rt" .. arg0_12.mode .. "Panel"], false)
	end

	arg0_12:HideAtlasOverall()
	arg0_12:DisposeAtlasOverall()
end

function var0_0.GetOverviewMark(arg0_13)
	if arg0_13.mode == "Task" then
		if arg0_13.isTaskArea then
			return {
				"overview_port"
			}
		else
			return {
				"overview_task_port",
				"overview_task"
			}
		end
	elseif arg0_13.mode == "Achievement" then
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

function var0_0.UpdateTaskPanel(arg0_14)
	local var0_14 = nowWorld()
	local var1_14 = var0_14:GetTaskProxy():getTaskById(arg0_14.taskId)

	assert(var1_14, "without this doing task: " .. arg0_14.taskId)

	local var2_14 = arg0_14.rtTaskPanel:Find("task_info")

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", pg.WorldToastMgr.Type2PictrueName[var1_14.config.type], var2_14:Find("type"), true)
	setText(var2_14:Find("name/Text"), var1_14.config.name)

	local var3_14 = var1_14:GetFollowingAreaId()

	if var3_14 then
		arg0_14.isTaskArea = true
		arg0_14.entranceIds = underscore.rest(var0_14:GetAreaEntranceIds(var3_14), 1)
		arg0_14.areaIds = {
			var3_14
		}

		arg0_14.areaItemList:align(math.max(#arg0_14.areaIds, 1))
	else
		arg0_14.isTaskArea = false
		arg0_14.entranceIds = {
			var1_14:GetFollowingEntrance()
		}

		arg0_14.entranceItemList:align(math.max(#arg0_14.entranceIds, 1))
	end

	local var4_14 = arg0_14.rtTaskPanel:Find("entrance_list/target_tpl")
	local var5_14 = var0_14:GetActiveEntrance()

	setActive(var4_14:Find("Image"), false)
	setText(var4_14:Find("Text"), i18n("world_task_view2") .. var5_14:GetBaseMap():GetName())
end

function var0_0.UpdateAchievementPanel(arg0_15)
	local var0_15 = nowWorld()
	local var1_15, var2_15, var3_15 = var0_15:CountAchievements()

	setText(arg0_15.rtAchievementPanel:Find("achievement_info/name/info/number"), var1_15 + var2_15 .. "/" .. var3_15)

	local var4_15, var5_15 = var0_15:GetFinishAchievements()
	local var6_15 = 0

	for iter0_15, iter1_15 in ipairs(var4_15) do
		var6_15 = var6_15 + #iter1_15.star_list
	end

	local var7_15 = arg0_15.rtAchievementPanel:Find("word_list/target_tpl")

	setActive(var7_15:Find("Image"), true)
	setText(var7_15:Find("Text"), i18n("world_target_count", "  " .. setColorStr(tostring(var6_15), COLOR_YELLOW) .. "  "))

	arg0_15.entranceIds = var5_15

	local var8_15 = pg.gameset.world_target_obtain.key_value

	setActive(arg0_15.btnAchieve, var8_15 <= #var4_15)
end

function var0_0.DisplayAtlasOverall(arg0_16)
	if arg0_16.wsAtlasOverall then
		setActive(arg0_16.wsAtlasOverall.tfEntity:Find("Plane"), false)
		arg0_16.wsAtlasOverall:ShowOrHide(true)
	end
end

function var0_0.HideAtlasOverall(arg0_17)
	if arg0_17.wsAtlasOverall then
		arg0_17.wsAtlasOverall:ShowOrHide(false)
	end
end

function var0_0.LoadAtlasOverall(arg0_18, arg1_18)
	local var0_18 = {}

	if not arg0_18.wsAtlasOverall then
		table.insert(var0_18, function(arg0_19)
			arg0_18.wsAtlasOverall = WSAtlasOverall.New()

			arg0_18.wsAtlasOverall:Setup()
			arg0_18.wsAtlasOverall:LoadScene(function()
				arg0_18.wsAtlasOverall:UpdateAtlas(nowWorld():GetAtlas())

				return arg0_19()
			end)
		end)
	end

	seriesAsync(var0_18, function()
		return existCall(arg1_18)
	end)
end

function var0_0.DisposeAtlasOverall(arg0_22)
	if arg0_22.wsAtlasOverall then
		arg0_22.wsAtlasOverall:Dispose()

		arg0_22.wsAtlasOverall = nil
	end
end

return var0_0

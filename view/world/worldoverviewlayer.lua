local var0 = class("WorldOverviewLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "WorldOverviewUI"
end

function var0.preload(arg0, arg1)
	arg0:LoadAtlasOverall(arg1)
end

function var0.init(arg0)
	local var0 = arg0._tf

	arg0.rtBg = var0:Find("bg")

	onButton(arg0, arg0.rtBg, function()
		arg0:closeView()
	end, SFX_CANCEL)
	setText(var0:Find("tip/Text"), i18n("click_back_tip"))

	arg0.rtTaskPanel = var0:Find("panel/middle/info_panel/task_panel")

	setActive(arg0.rtTaskPanel, false)
	setActive(arg0.rtTaskPanel:Find("btn_next"), false)

	arg0.entranceItemList = UIItemList.New(arg0.rtTaskPanel:Find("entrance_list/target_list"), arg0.rtTaskPanel:Find("entrance_list/target_tpl"))

	arg0.entranceItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			if arg0.entranceIds[arg1] then
				local var0 = nowWorld():GetEntrance(arg0.entranceIds[arg1])

				setActive(arg2:Find("Image"), true)
				setText(arg2:Find("Text"), i18n("world_task_view1") .. var0:GetBaseMap():GetName())
			else
				setActive(arg2:Find("Image"), true)
				setText(arg2:Find("Text"), i18n("world_task_view1") .. i18n("world_task_view2"))
			end
		end
	end)

	arg0.areaItemList = UIItemList.New(arg0.rtTaskPanel:Find("entrance_list/target_list"), arg0.rtTaskPanel:Find("entrance_list/target_tpl"))

	arg0.areaItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			if arg0.areaIds[arg1] then
				setActive(arg2:Find("Image"), true)
				setText(arg2:Find("Text"), i18n("world_task_view1") .. pg.world_regions_data[arg0.areaIds[arg1]].name)
			else
				setActive(arg2:Find("Image"), true)
				setText(arg2:Find("Text"), i18n("world_task_view1") .. i18n("world_task_view2"))
			end
		end
	end)

	arg0.rtAchievementPanel = var0:Find("panel/middle/info_panel/achievement_panel")

	setActive(arg0.rtAchievementPanel, false)

	arg0.btnAchieve = arg0.rtAchievementPanel:Find("btn_all")

	onButton(arg0, arg0.btnAchieve, function()
		local var0, var1 = nowWorld():GetFinishAchievements()

		if #var0 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without any award")
		else
			arg0:emit(WorldOverviewMediator.OnAchieveStar, var0)
			arg0:closeView()
		end
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		blurLevelCamera = true,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.info

	arg0.mode = var0.mode

	if arg0.mode == "Task" then
		arg0.taskId = var0.taskId

		arg0:UpdateTaskPanel()
	elseif arg0.mode == "Achievement" then
		arg0:UpdateAchievementPanel()
	else
		arg0.entranceIds = var0.ids
	end

	arg0._tf:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		local var0 = {}

		_.each(arg0.entranceIds, function(arg0)
			var0[arg0] = true
		end)

		if #arg0.entranceIds > 0 then
			arg0.wsAtlasOverall:UpdateTargetEntrance(arg0.entranceIds[1])
		end

		arg0.wsAtlasOverall:UpdateStaticMark(var0, arg0:GetOverviewMark())
		arg0:DisplayAtlasOverall()

		if arg0.mode then
			setActive(arg0["rt" .. arg0.mode .. "Panel"], true)

			if arg0.mode == "Task" then
				eachChild(arg0.entranceItemList.container, function(arg0)
					local var0 = GetComponent(arg0:Find("Text"), typeof(Typewriter))

					var0:setSpeed(0.03)
					var0:Play()
				end)

				local var1 = arg0.rtTaskPanel:Find("entrance_list/target_tpl")
				local var2 = GetComponent(var1:Find("Text"), typeof(Typewriter))

				var2:setSpeed(0.03)
				var2:Play()
			end
		end
	end)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	if arg0.mode then
		setActive(arg0["rt" .. arg0.mode .. "Panel"], false)
	end

	arg0:HideAtlasOverall()
	arg0:DisposeAtlasOverall()
end

function var0.GetOverviewMark(arg0)
	if arg0.mode == "Task" then
		if arg0.isTaskArea then
			return {
				"overview_port"
			}
		else
			return {
				"overview_task_port",
				"overview_task"
			}
		end
	elseif arg0.mode == "Achievement" then
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

function var0.UpdateTaskPanel(arg0)
	local var0 = nowWorld()
	local var1 = var0:GetTaskProxy():getTaskById(arg0.taskId)

	assert(var1, "without this doing task: " .. arg0.taskId)

	local var2 = arg0.rtTaskPanel:Find("task_info")

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", pg.WorldToastMgr.Type2PictrueName[var1.config.type], var2:Find("type"), true)
	setText(var2:Find("name/Text"), var1.config.name)

	local var3 = var1:GetFollowingAreaId()

	if var3 then
		arg0.isTaskArea = true
		arg0.entranceIds = underscore.rest(var0:GetAreaEntranceIds(var3), 1)
		arg0.areaIds = {
			var3
		}

		arg0.areaItemList:align(math.max(#arg0.areaIds, 1))
	else
		arg0.isTaskArea = false
		arg0.entranceIds = {
			var1:GetFollowingEntrance()
		}

		arg0.entranceItemList:align(math.max(#arg0.entranceIds, 1))
	end

	local var4 = arg0.rtTaskPanel:Find("entrance_list/target_tpl")
	local var5 = var0:GetActiveEntrance()

	setActive(var4:Find("Image"), false)
	setText(var4:Find("Text"), i18n("world_task_view2") .. var5:GetBaseMap():GetName())
end

function var0.UpdateAchievementPanel(arg0)
	local var0 = nowWorld()
	local var1, var2, var3 = var0:CountAchievements()

	setText(arg0.rtAchievementPanel:Find("achievement_info/name/info/number"), var1 + var2 .. "/" .. var3)

	local var4, var5 = var0:GetFinishAchievements()
	local var6 = 0

	for iter0, iter1 in ipairs(var4) do
		var6 = var6 + #iter1.star_list
	end

	local var7 = arg0.rtAchievementPanel:Find("word_list/target_tpl")

	setActive(var7:Find("Image"), true)
	setText(var7:Find("Text"), i18n("world_target_count", "  " .. setColorStr(tostring(var6), COLOR_YELLOW) .. "  "))

	arg0.entranceIds = var5

	local var8 = pg.gameset.world_target_obtain.key_value

	setActive(arg0.btnAchieve, var8 <= #var4)
end

function var0.DisplayAtlasOverall(arg0)
	if arg0.wsAtlasOverall then
		setActive(arg0.wsAtlasOverall.tfEntity:Find("Plane"), false)
		arg0.wsAtlasOverall:ShowOrHide(true)
	end
end

function var0.HideAtlasOverall(arg0)
	if arg0.wsAtlasOverall then
		arg0.wsAtlasOverall:ShowOrHide(false)
	end
end

function var0.LoadAtlasOverall(arg0, arg1)
	local var0 = {}

	if not arg0.wsAtlasOverall then
		table.insert(var0, function(arg0)
			arg0.wsAtlasOverall = WSAtlasOverall.New()

			arg0.wsAtlasOverall:Setup()
			arg0.wsAtlasOverall:LoadScene(function()
				arg0.wsAtlasOverall:UpdateAtlas(nowWorld():GetAtlas())

				return arg0()
			end)
		end)
	end

	seriesAsync(var0, function()
		return existCall(arg1)
	end)
end

function var0.DisposeAtlasOverall(arg0)
	if arg0.wsAtlasOverall then
		arg0.wsAtlasOverall:Dispose()

		arg0.wsAtlasOverall = nil
	end
end

return var0

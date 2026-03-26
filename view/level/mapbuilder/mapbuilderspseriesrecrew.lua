local var0_0 = class("MapBuilderSPSeriesRecrew", import(".MapBuilderSPSeriesFull"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESPSERIESRECREW
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectSPSeriesRecrewUI"
end

function var0_0.UpdateStory(arg0_3)
	local var0_3 = {}
	local var1_3 = pg.NewStoryMgr.GetInstance()
	local var2_3 = 0
	local var3_3 = 0

	for iter0_3, iter1_3 in pairs(arg0_3.storyNodesDict) do
		local var4_3 = arg0_3.storyHolder:Find(tostring(iter1_3.id))
		local var5_3 = iter1_3:IsActive(arg0_3.activity, arg0_3.sceneParent.ptActivity)

		setActive(var4_3, var5_3)
		setText(var4_3:Find("main/char/bg/Text"), iter1_3:GetName())
		setText(var4_3:Find("main/talk/bg/Text"), iter1_3:GetName())

		local var6_3 = iter1_3:IsReaded()

		setActive(var4_3:Find("main/char"), not var6_3)
		setActive(var4_3:Find("main/talk"), var6_3)

		local var7_3 = iter1_3:IsRecrew()

		if var7_3 == nil then
			setActive(var4_3:Find("main/recrew"), false)
		else
			setActive(var4_3:Find("main/recrew"), true)
			setActive(var4_3:Find("main/recrew/recrewed"), var7_3)
			setActive(var4_3:Find("main/recrew/not_recrew"), not var7_3)
			setText(var4_3:Find("main/recrew/recrewed/label"), i18n("story_recrewed"))
			setText(var4_3:Find("main/recrew/not_recrew/label"), i18n("story_not_recrew"))
		end

		onButton(arg0_3, var4_3, function()
			local var0_4 = iter1_3:GetParams(BossRushStoryNode.REPEATABLE_KEY)
			local var1_4 = var0_4 and var0_4[2]

			if var6_3 and not var1_4 then
				return
			end

			local var2_4 = iter1_3:GetStory()

			arg0_3:PlayStory(var2_4, function()
				local var0_5 = arg0_3.activity:getConfig("config_client").storys

				if var0_5[#var0_5] == iter1_3.id and not var6_3 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_HELP,
						helps = i18n("multiple_endings_tip")
					})
				end

				arg0_3:UpdateView()
			end, var1_4)
		end)

		var2_3 = var2_3 + (var6_3 and 1 or 0)
		var3_3 = var3_3 + 1
	end

	setText(arg0_3.progressText, var2_3 .. "/" .. var3_3)
	setActive(arg0_3.storyAward, tobool(arg0_3.storyTask))

	if arg0_3.storyTask then
		local var8_3 = arg0_3.storyTask:getConfig("award_display")
		local var9_3 = Drop.Create(var8_3[1])

		updateDrop(arg0_3.storyAward:GetChild(0), var9_3)

		local var10_3 = arg0_3.storyTask:getTaskStatus()

		setActive(arg0_3.storyAward:Find("get"), var10_3 == 1)
		setActive(arg0_3.storyAward:Find("got"), var10_3 == 2)
		onButton(arg0_3, arg0_3.storyAward, function()
			arg0_3:emit(BaseUI.ON_DROP, var9_3)
		end)
	end
end

function var0_0.SwitchStoryMapAndBGM(arg0_7)
	local var0_7 = arg0_7.data:getConfig("default_background")
	local var1_7 = arg0_7.data:getConfig("default_bgm")
	local var2_7 = arg0_7.data:getConfig("ani_name")
	local var3_7 = underscore.keys(arg0_7.storyNodesDict)

	table.sort(var3_7)

	for iter0_7 = 1, #var3_7 do
		local var4_7 = arg0_7.storyNodesDict[var3_7[iter0_7]]

		if var4_7:IsReaded() then
			var0_7 = defaultValue(var4_7:GetCleanBG(), var0_7)
			var1_7 = defaultValue(var4_7:GetCleanBGM(), var1_7)
			var2_7 = defaultValue(var4_7:GetCleanAnimator(), var2_7)
		else
			break
		end
	end

	arg0_7.sceneParent:SwitchBG({
		{
			bgPrefix = "bg",
			BG = var0_7,
			Animator = var2_7
		}
	})
	pg.BgmMgr.GetInstance():Push(arg0_7.__cname, var1_7)
end

return var0_0

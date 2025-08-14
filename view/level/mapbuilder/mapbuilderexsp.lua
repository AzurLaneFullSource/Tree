local var0_0 = class("MapBuilderEXSP", import(".MapBuilderSPSeriesFull"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEATELIERYUMIA
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectEXSPUI"
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)

	arg0_3.personalBtn = arg0_3._tf:Find("Story/PersonalCard")
	arg0_3.personalPage = SecretsAbyssPersonalPage.New(arg0_3._tf, arg0_3, {})

	onButton(arg0_3, arg0_3.personalBtn, function()
		arg0_3.personalPage:ExecuteAction("Show")
	end)
end

function var0_0.UpdateMapVO(arg0_5, arg1_5)
	var0_0.super.UpdateMapVO(arg0_5, arg1_5)

	if arg0_5.activity:getConfig("config_client").roll_task then
		arg0_5.personalPage:RegisterRandomCallback(function()
			arg0_5.sceneParent:emit(LevelMediator2.ON_UPDATE_LOWPRIORITY_TASK, arg0_5.activity:getConfig("config_client").roll_task)
		end)
	end
end

function var0_0.SetDisplayMode(arg0_7, arg1_7)
	var0_0.super.SetDisplayMode(arg0_7, arg1_7)

	if arg0_7.contextData.displayMode == var0_0.DISPLAY.BATTLE then
		quickPlayAnimation(arg0_7._tf, "Anim_LevelSelectAtelierYumia_Battle_In")
	else
		quickPlayAnimation(arg0_7._tf, "Anim_LevelSelectAtelierYumia_In")
	end
end

function var0_0.PlayerLevelTplAnimation(arg0_8, arg1_8, arg2_8)
	quickPlayAnimation(arg1_8, switch(arg2_8.status, {
		Lock = function()
			return "Anim_LevelSelectAtelierYumia_LevelTplLock_In"
		end,
		Normal = function()
			return "Anim_LevelSelectAtelierYumia_LevelTpNormal_In"
		end,
		Hard = function()
			return "Anim_LevelSelectAtelierYumia_LevelTpHard_In"
		end
	}))
end

function var0_0.UpdateStory(arg0_12)
	local var0_12 = {}
	local var1_12 = pg.NewStoryMgr.GetInstance()
	local var2_12 = 0
	local var3_12 = 0
	local var4_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.storyNodesDict) do
		local var5_12 = arg0_12.storyHolder:Find(tostring(iter1_12.id))
		local var6_12 = iter1_12:IsActive(arg0_12.activity, arg0_12.ptActivity)
		local var7_12 = iter1_12:IsReaded()

		if not _G.isActive(var5_12) and var6_12 then
			setActive(var5_12, var6_12)
			quickPlayAnimation(var5_12, switch(iter1_12:GetType(), {
				[BossRushStoryNode.NODE_TYPE.NORMAL] = function()
					return "Anim_LevelSelectAtelierYumia_storytpl_In"
				end,
				[BossRushStoryNode.NODE_TYPE.BATTLE] = function()
					return "Anim_LevelSelectAtelierYumia_bettletpl_In"
				end,
				[BossRushStoryNode.NODE_TYPE.LOCATION] = function()
					return "Anim_LevelSelectAtelierYumia_Item_Lock_In"
				end
			}, function()
				assert(false)
			end))
		else
			setActive(var5_12, var6_12)
		end

		if iter1_12:GetType() ~= BossRushStoryNode.NODE_TYPE.LOCATION then
			var2_12 = var2_12 + (var7_12 and 1 or 0)
			var3_12 = var3_12 + 1

			if var7_12 then
				table.insert(var4_12, iter1_12)
			end
		end

		if var6_12 then
			local var8_12
			local var9_12 = iter1_12:GetParams("item_lock")
			local var10_12 = var9_12 and Drop.Create(var9_12[2]) or nil
			local var11_12 = var10_12 and var10_12.count > var10_12:getOwnedCount() and "item_lock" or switch(iter1_12:GetType(), {
				[BossRushStoryNode.NODE_TYPE.NORMAL] = function()
					return "story"
				end,
				[BossRushStoryNode.NODE_TYPE.BATTLE] = function()
					return "battle"
				end,
				[BossRushStoryNode.NODE_TYPE.LOCATION] = function()
					return "location"
				end
			})

			eachChild(var5_12, function(arg0_20, arg1_20)
				setActive(arg0_20, arg0_20.name == var11_12)
			end)
			switch(var11_12, {
				story = function(arg0_21)
					setText(arg0_21:Find("name/Text"), iter1_12:GetName())
					onButton(arg0_12, arg0_21, function()
						if var7_12 then
							return
						end

						local var0_22 = iter1_12:GetStory()

						arg0_12:PlayStory(var0_22, function()
							arg0_12:UpdateView()
							arg0_12:CheckAutoShowPersonal()
						end)
					end)
				end,
				battle = function(arg0_24)
					setText(arg0_24:Find("name/Text"), iter1_12:GetName())
					onButton(arg0_12, arg0_24, function()
						if var7_12 then
							return
						end

						local var0_25 = iter1_12:GetStory()

						arg0_12:PlayStory(var0_25, function()
							arg0_12:UpdateView()
							arg0_12:CheckAutoShowPersonal()
						end)
					end)
				end,
				location = function(arg0_27)
					setText(arg0_27:Find("name/Text"), iter1_12:GetName())

					if PLATFORM_CODE ~= PLATFORM_US then
						setActive(arg0_27:Find("en"), true)
						setText(arg0_27:Find("en"), iter1_12:getConfig("en_name"))
					end
				end
			}, function()
				warning("error state without any display:", var11_12)
			end, var5_12:Find(var11_12))
		end
	end

	setText(arg0_12.progressText, var2_12 .. "/" .. var3_12)
	setActive(arg0_12.storyAward, tobool(arg0_12.storyTask))

	if arg0_12.storyTask then
		local var12_12 = arg0_12.storyTask:getConfig("award_display")
		local var13_12 = Drop.Create(var12_12[1])

		updateDrop(arg0_12.storyAward:GetChild(0), var13_12)

		local var14_12 = arg0_12.storyTask:getTaskStatus()

		setActive(arg0_12.storyAward:Find("get"), var14_12 == 1)
		setActive(arg0_12.storyAward:Find("got"), var14_12 == 2)
		onButton(arg0_12, arg0_12.storyAward, function()
			arg0_12:emit(BaseUI.ON_DROP, var13_12)
		end)
	end

	table.sort(var4_12, function(arg0_30, arg1_30)
		return arg0_30:getConfig("id") < arg1_30:getConfig("id")
	end)

	local var15_12 = var4_12[#var4_12]
	local var16_12
	local var17_12 = #var4_12 - 1

	while var17_12 > 0 do
		if #arg0_12.personalPage:GetActivitySingleEventOption(var4_12[var17_12]) > 0 then
			var16_12 = var4_12[var17_12]

			break
		end

		var17_12 = var17_12 - 1
	end

	if var15_12 and #arg0_12.personalPage:GetActivitySingleEventOption(var15_12) > 0 or var16_12 and #arg0_12.personalPage:GetActivitySingleEventOption(var16_12) > 0 then
		setActive(arg0_12.personalBtn, true)
	else
		setActive(arg0_12.personalBtn, false)
	end

	var16_12 = var16_12 and var16_12 or var15_12

	arg0_12.personalPage:SetBossRushNode(var15_12, var16_12)

	if var2_12 == var3_12 then
		arg0_12.personalPage:UnlockRandom()
	end

	if arg0_12.activity:getConfig("config_client").first_story then
		pg.NewStoryMgr.GetInstance():Play(arg0_12.activity:getConfig("config_client").first_story)
	end
end

function var0_0.CheckAutoShowPersonal(arg0_31)
	if #arg0_31.personalPage:GetActivitySingleEventOption(arg0_31.personalPage:GetCurrentEvent()) > 0 then
		arg0_31.personalPage:SetUpgrade()
		arg0_31.personalPage:ExecuteAction("Show")
		arg0_31.personalPage:ExecuteAction("UpdateView")
	end
end

var0_0.presonalRandomData = nil

return var0_0

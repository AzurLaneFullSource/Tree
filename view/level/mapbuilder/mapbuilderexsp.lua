local var0_0 = class("MapBuilderEXSP", import(".MapBuilderSPSeriesFull"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEEXSP
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

function var0_0.OnDestroy(arg0_5)
	arg0_5.personalPage:Destroy()

	arg0_5.personalBtn = nil

	var0_0.super.OnDestroy(arg0_5)
end

function var0_0.UpdateMapVO(arg0_6, arg1_6)
	var0_0.super.UpdateMapVO(arg0_6, arg1_6)

	if arg0_6.activity:getConfig("config_client").roll_task then
		arg0_6.personalPage:RegisterRandomCallback(function()
			arg0_6.sceneParent:emit(LevelMediator2.ON_UPDATE_LOWPRIORITY_TASK, arg0_6.activity:getConfig("config_client").roll_task)
		end)
	end
end

function var0_0.SetDisplayMode(arg0_8, arg1_8)
	var0_0.super.SetDisplayMode(arg0_8, arg1_8)

	if arg0_8.contextData.displayMode == var0_0.DISPLAY.BATTLE then
		quickPlayAnimation(arg0_8._tf, "Anim_LevelSelectAtelierYumia_Battle_In")
	else
		quickPlayAnimation(arg0_8._tf, "Anim_LevelSelectAtelierYumia_In")
	end
end

function var0_0.PlayerLevelTplAnimation(arg0_9, arg1_9, arg2_9)
	quickPlayAnimation(arg1_9, switch(arg2_9.status, {
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

function var0_0.UpdateStory(arg0_13)
	local var0_13 = {}
	local var1_13 = pg.NewStoryMgr.GetInstance()
	local var2_13 = 0
	local var3_13 = 0
	local var4_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.storyNodesDict) do
		local var5_13 = arg0_13.storyHolder:Find(tostring(iter1_13.id))
		local var6_13 = iter1_13:IsActive(arg0_13.activity, arg0_13.ptActivity)
		local var7_13 = iter1_13:IsReaded()

		if not _G.isActive(var5_13) and var6_13 then
			setActive(var5_13, var6_13)
			quickPlayAnimation(var5_13, switch(iter1_13:GetType(), {
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
			setActive(var5_13, var6_13)
		end

		if iter1_13:GetType() ~= BossRushStoryNode.NODE_TYPE.LOCATION then
			var2_13 = var2_13 + (var7_13 and 1 or 0)
			var3_13 = var3_13 + 1

			if var7_13 then
				table.insert(var4_13, iter1_13)
			end
		end

		if var6_13 then
			local var8_13
			local var9_13 = iter1_13:GetParams("item_lock")
			local var10_13 = var9_13 and Drop.Create(var9_13[2]) or nil
			local var11_13 = var10_13 and var10_13.count > var10_13:getOwnedCount() and "item_lock" or switch(iter1_13:GetType(), {
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

			eachChild(var5_13, function(arg0_21, arg1_21)
				setActive(arg0_21, arg0_21.name == var11_13)
			end)
			switch(var11_13, {
				story = function(arg0_22)
					setText(arg0_22:Find("name/Text"), iter1_13:GetName())
					onButton(arg0_13, arg0_22, function()
						if var7_13 then
							return
						end

						local var0_23 = iter1_13:GetStory()

						arg0_13:PlayStory(var0_23, function()
							arg0_13:UpdateView()
							arg0_13:CheckAutoShowPersonal()
						end)
					end)
				end,
				battle = function(arg0_25)
					setText(arg0_25:Find("name/Text"), iter1_13:GetName())
					onButton(arg0_13, arg0_25, function()
						if var7_13 then
							return
						end

						local var0_26 = iter1_13:GetStory()

						arg0_13:PlayStory(var0_26, function()
							arg0_13:UpdateView()
							arg0_13:CheckAutoShowPersonal()
						end)
					end)
				end,
				location = function(arg0_28)
					setText(arg0_28:Find("name/Text"), iter1_13:GetName())

					local var0_28 = arg0_28:Find("en")

					if arg0_28:Find("en") then
						setActive(arg0_28:Find("en"), PLATFORM_CODE ~= PLATFORM_US)
						setText(arg0_28:Find("en"), iter1_13:getConfig("en_name"))
					end
				end
			}, function()
				warning("error state without any display:", var11_13)
			end, var5_13:Find(var11_13))
		end
	end

	setText(arg0_13.progressText, var2_13 .. "/" .. var3_13)
	setActive(arg0_13.storyAward, tobool(arg0_13.storyTask))

	if arg0_13.storyTask then
		local var12_13 = arg0_13.storyTask:getConfig("award_display")
		local var13_13 = Drop.Create(var12_13[1])

		updateDrop(arg0_13.storyAward:GetChild(0), var13_13)

		local var14_13 = arg0_13.storyTask:getTaskStatus()

		setActive(arg0_13.storyAward:Find("get"), var14_13 == 1)
		setActive(arg0_13.storyAward:Find("got"), var14_13 == 2)
		onButton(arg0_13, arg0_13.storyAward, function()
			arg0_13:emit(BaseUI.ON_DROP, var13_13)
		end)
	end

	table.sort(var4_13, function(arg0_31, arg1_31)
		return arg0_31:getConfig("id") < arg1_31:getConfig("id")
	end)

	local var15_13 = var4_13[#var4_13]
	local var16_13
	local var17_13 = #var4_13 - 1

	while var17_13 > 0 do
		if #arg0_13.personalPage:GetActivitySingleEventOption(var4_13[var17_13]) > 0 then
			var16_13 = var4_13[var17_13]

			break
		end

		var17_13 = var17_13 - 1
	end

	if var15_13 and #arg0_13.personalPage:GetActivitySingleEventOption(var15_13) > 0 or var16_13 and #arg0_13.personalPage:GetActivitySingleEventOption(var16_13) > 0 then
		setActive(arg0_13.personalBtn, true)
	else
		setActive(arg0_13.personalBtn, false)
	end

	var16_13 = var16_13 and var16_13 or var15_13

	arg0_13.personalPage:SetBossRushNode(var15_13, var16_13)

	if var2_13 == var3_13 then
		arg0_13.personalPage:UnlockRandom()
	end

	if arg0_13.activity:getConfig("config_client").first_story then
		pg.NewStoryMgr.GetInstance():Play(arg0_13.activity:getConfig("config_client").first_story)
	end
end

function var0_0.CheckAutoShowPersonal(arg0_32)
	if #arg0_32.personalPage:GetActivitySingleEventOption(arg0_32.personalPage:GetCurrentEvent()) > 0 then
		arg0_32.personalPage:SetUpgrade()
		arg0_32.personalPage:ExecuteAction("Show")
		arg0_32.personalPage:ExecuteAction("UpdateView")
	end
end

var0_0.presonalRandomData = nil

return var0_0

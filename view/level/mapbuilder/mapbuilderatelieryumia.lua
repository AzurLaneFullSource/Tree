local var0_0 = class("MapBuilderAtelierYumia", import(".MapBuilderSPSeriesFull"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEATELIERYUMIA
end

function var0_0.getUIName(arg0_2)
	return "LevelSelectAtelierYumia"
end

function var0_0.SetDisplayMode(arg0_3, arg1_3)
	var0_0.super.SetDisplayMode(arg0_3, arg1_3)

	if arg0_3.contextData.displayMode == var0_0.DISPLAY.BATTLE then
		quickPlayAnimation(arg0_3._tf, "Anim_LevelSelectAtelierYumia_Battle_In")
	else
		quickPlayAnimation(arg0_3._tf, "Anim_LevelSelectAtelierYumia_In")
	end
end

function var0_0.PlayerLevelTplAnimation(arg0_4, arg1_4, arg2_4)
	quickPlayAnimation(arg1_4, switch(arg2_4.status, {
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

function var0_0.UpdateStory(arg0_8)
	local var0_8 = {}
	local var1_8 = pg.NewStoryMgr.GetInstance()
	local var2_8 = 0
	local var3_8 = 0

	for iter0_8, iter1_8 in pairs(arg0_8.storyNodesDict) do
		local var4_8 = arg0_8.storyHolder:Find(tostring(iter1_8.id))
		local var5_8 = iter1_8:IsActive(arg0_8.activity, arg0_8.ptActivity)
		local var6_8 = iter1_8:IsReaded()

		if not _G.isActive(var4_8) and var5_8 then
			setActive(var4_8, var5_8)
			quickPlayAnimation(var4_8, switch(iter1_8:GetType(), {
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
			setActive(var4_8, var5_8)
		end

		if iter1_8:GetType() ~= BossRushStoryNode.NODE_TYPE.LOCATION then
			var2_8 = var2_8 + (var6_8 and 1 or 0)
			var3_8 = var3_8 + 1
		end

		if var5_8 then
			local var7_8
			local var8_8 = iter1_8:GetParams("item_lock")
			local var9_8 = var8_8 and Drop.Create(var8_8[2]) or nil
			local var10_8 = var9_8 and var9_8.count > var9_8:getOwnedCount() and "item_lock" or switch(iter1_8:GetType(), {
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

			eachChild(var4_8, function(arg0_16, arg1_16)
				setActive(arg0_16, arg0_16.name == var10_8)
			end)
			switch(var10_8, {
				story = function(arg0_17)
					setText(arg0_17:Find("name/Text"), iter1_8:GetName())
					onButton(arg0_8, arg0_17, function()
						if var6_8 then
							return
						end

						local var0_18 = iter1_8:GetStory()

						arg0_8:PlayStory(var0_18, function()
							arg0_8:UpdateView()
						end)
					end)
				end,
				battle = function(arg0_20)
					setText(arg0_20:Find("name/Text"), iter1_8:GetName())
					onButton(arg0_8, arg0_20, function()
						if var6_8 then
							return
						end

						local var0_21 = iter1_8:GetStory()

						arg0_8:PlayStory(var0_21, function()
							arg0_8:UpdateView()
						end)
					end)
				end,
				location = function(arg0_23)
					setText(arg0_23:Find("name/Text"), iter1_8:GetName())
					GetImageSpriteFromAtlasAsync("ui/levelselectatelieryumia_atlas", "yumia_story_" .. iter0_8, arg0_23:Find("name/Image"), false)
				end,
				item_lock = function(arg0_24)
					setText(arg0_24:Find("name/Text"), i18n("yumia_storymode_tip1", var9_8:getName()))
					updateDrop(arg0_24:Find("IconTpl"), var9_8)
					setText(arg0_24:Find("IconTpl/count"), string.format("<color=#23ffedff>%d</color>/%d", var9_8:getOwnedCount(), var9_8.count))
					onButton(arg0_8, arg0_24, function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("yumia_storymode_tip2"))
					end, SFX_UI_CLICK)
				end
			}, function()
				warning("error state without any display:", var10_8)
			end, var4_8:Find(var10_8))
		end
	end

	setText(arg0_8.progressText, var2_8 .. "/" .. var3_8)
	setActive(arg0_8.storyAward, tobool(arg0_8.storyTask))

	if arg0_8.storyTask then
		local var11_8 = arg0_8.storyTask:getConfig("award_display")
		local var12_8 = Drop.Create(var11_8[1])

		updateDrop(arg0_8.storyAward:GetChild(0), var12_8)

		local var13_8 = arg0_8.storyTask:getTaskStatus()

		setActive(arg0_8.storyAward:Find("get"), var13_8 == 1)
		setActive(arg0_8.storyAward:Find("got"), var13_8 == 2)
		onButton(arg0_8, arg0_8.storyAward, function()
			arg0_8:emit(BaseUI.ON_DROP, var12_8)
		end)
	end
end

function var0_0.UpdateButtons(arg0_28)
	var0_0.super.UpdateButtons(arg0_28)

	local var0_28 = arg0_28.contextData.displayMode == var0_0.DISPLAY.BATTLE

	setActive(arg0_28.sceneParent.actAtelierYumiaBuffBtn, var0_28 and arg0_28.contextData.map.configId == 1940002)
end

return var0_0

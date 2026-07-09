local var0_0 = class("BossRushChapterRemasterHelper")
local var1_0 = {
	EX = 1,
	SIA = 4,
	SEA = 3,
	SP = 2
}

function var0_0.GetExOrSp4Filter(arg0_1)
	if arg0_1 == var1_0.EX or arg0_1 == var1_0.SP then
		return arg0_1
	elseif arg0_1 == var1_0.SEA or arg0_1 == var1_0.SIA then
		return var1_0.SP
	end

	return var1_0.EX
end

function var0_0.IsRemasterByActivity(arg0_2)
	local var0_2 = pg.re_map_template[arg0_2].activity_type

	return var0_2 == var1_0.SEA or var0_2 == var1_0.SIA
end

function var0_0.GetRemasterByActivityId(arg0_3)
	if not arg0_3 then
		return nil
	end

	for iter0_3, iter1_3 in ipairs(pg.re_map_template.all) do
		local var0_3 = pg.re_map_template[iter1_3]

		if var0_3.activity_id == arg0_3 then
			return var0_3
		end
	end
end

function var0_0.GetActivityRemasterByFinalSeriesId(arg0_4, arg1_4)
	local var0_4 = var0_0.GetRemasterByActivityId(arg0_4)

	if not var0_4 or not var0_0.IsRemasterByActivity(var0_4.id) then
		return nil
	end

	local var1_4 = var0_4.config_data or {}

	if var1_4[#var1_4] == arg1_4 then
		return var0_4
	end
end

function var0_0.GetMemoryGroupStoryIds(arg0_5)
	local var0_5 = arg0_5 and pg.memory_group[arg0_5]

	if not var0_5 then
		return {}
	end

	local var1_5 = pg.NewStoryMgr.GetInstance()
	local var2_5 = {}
	local var3_5 = {}

	local function var4_5(arg0_6)
		if not arg0_6 or arg0_6 == "" then
			return
		end

		local var0_6, var1_6 = var1_5:StoryName2StoryId(arg0_6)

		if var0_6 and var0_6 > 0 and not var3_5[var0_6] and not var1_5:GetPlayedFlag(var0_6) then
			var3_5[var0_6] = true

			table.insert(var2_5, var0_6)
		end

		if var1_6 and var1_6 > 0 and not var3_5[var1_6] and not var1_5:GetPlayedFlag(var1_6) then
			var3_5[var1_6] = true

			table.insert(var2_5, var1_6)
		end
	end

	for iter0_5, iter1_5 in ipairs(var0_5.memories or {}) do
		local var5_5 = pg.memory_template[iter1_5]

		if var5_5 then
			var4_5(var5_5.story)

			if type(var5_5.unlock_pre) == "table" then
				for iter2_5, iter3_5 in ipairs(var5_5.unlock_pre) do
					var4_5(iter3_5)
				end
			else
				var4_5(var5_5.unlock_pre)
			end
		end
	end

	return var2_5
end

function var0_0.UnlockMemoryGroupStories(arg0_7, arg1_7)
	arg1_7 = arg1_7 or {}

	local var0_7 = var0_0.GetMemoryGroupStoryIds(arg0_7)

	if #var0_7 <= 0 then
		if arg1_7.callback then
			arg1_7.callback()
		end

		return var0_7
	end

	if arg1_7.sync then
		pg.m02:sendNotification(GAME.STORY_UPDATE_LIST, {
			storyIds = var0_7,
			callback = arg1_7.callback
		})
	else
		pg.NewStoryMgr.GetInstance():SetPlayedFlagList(var0_7)

		if arg1_7.callback then
			arg1_7.callback()
		end
	end

	return var0_7
end

function var0_0.ShowUnlockMemoryMsgBox(arg0_8, arg1_8, arg2_8, arg3_8)
	if not arg0_8 or not arg1_8 or #arg1_8 <= 0 then
		if arg3_8 then
			arg3_8()
		end

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yesText = "text_go",
		content = i18n("levelScene_remaster_story_tip", pg.memory_group[arg0_8].title),
		onYes = arg2_8,
		onNo = arg3_8
	})
end

function var0_0.MarkMemoryGroupNotification(arg0_9)
	if not arg0_9 then
		return
	end

	local var0_9 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("MEMORY_GROUP_NOTIFICATION" .. var0_9 .. " " .. arg0_9, 1)
	PlayerPrefs.Save()
end

function var0_0.UnlockMemoryGroupStoriesAndShowMsgBox(arg0_10, arg1_10)
	local var0_10 = var0_0.UnlockMemoryGroupStories(arg0_10)

	if #var0_10 <= 0 then
		return false
	end

	var0_0.ShowUnlockMemoryMsgBox(arg0_10, var0_10, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY,
			memoryGroup = arg0_10
		})
	end, function()
		var0_0.MarkMemoryGroupNotification(arg0_10)

		if arg1_10 then
			arg1_10(var0_10)
		end
	end)

	return true
end

function var0_0.GetPermanentActivityTicketCost(arg0_13, arg1_13)
	if not arg0_13 or not arg1_13 or not pg.activity_task_permanent[arg0_13] then
		return 0
	end

	local var0_13 = var0_0.GetRemasterByActivityId(arg0_13)

	if not var0_13 then
		return 0
	end

	for iter0_13, iter1_13 in ipairs(var0_13.config_data or {}) do
		if iter1_13 == arg1_13 then
			return var0_13.tickets[iter0_13] or 0
		end
	end

	return 0
end

function var0_0.GetChapterIds(arg0_14)
	if var0_0.IsRemasterByActivity(arg0_14) then
		return {}
	else
		local var0_14 = pg.re_map_template[arg0_14]

		return var0_14 and var0_14.config_data or {}
	end
end

function var0_0.GetAllNonActivityIds()
	local var0_15 = {}

	_.each(pg.re_map_template.all, function(arg0_16)
		if not var0_0.IsRemasterByActivity(arg0_16) then
			table.insert(var0_15, arg0_16)
		end
	end)

	return var0_15
end

function var0_0.GetProgress(arg0_17)
	if not arg0_17 then
		return 0
	end

	if var0_0.IsRemasterByActivity(arg0_17) then
		local var0_17 = pg.re_map_template[arg0_17]
		local var1_17 = var0_17 and getProxy(ActivityProxy):getActivityById(var0_17.activity_id)

		if not var1_17 then
			return 0
		end

		local var2_17 = 0

		for iter0_17, iter1_17 in ipairs(var0_17.config_data) do
			if var1_17:HasPassSeries(iter1_17) then
				var2_17 = math.max(var2_17, var0_17.chapter_progress[iter0_17])
			end
		end

		return var2_17
	else
		local var3_17 = getProxy(ChapterProxy)
		local var4_17 = pg.re_map_template[arg0_17]
		local var5_17 = 0

		for iter2_17, iter3_17 in ipairs(var4_17.config_data) do
			if var3_17:getChapterById(iter3_17):isClear() then
				var5_17 = math.max(var5_17, var4_17.chapter_progress[iter2_17])
			end
		end

		return var5_17
	end
end

function var0_0.ChapterAwardInfo(arg0_18, arg1_18)
	if not arg0_18 then
		return nil
	end

	local var0_18
	local var1_18 = getProxy(ChapterProxy)
	local var2_18 = pg.re_map_template[arg0_18]

	arg1_18 = arg1_18 or var2_18.activity_id or 0

	if arg0_18 and #var2_18.drop_gain > 0 then
		for iter0_18, iter1_18 in ipairs(var2_18.drop_gain) do
			local var3_18 = #iter1_18 > 0 and var1_18:getRemasterInfo(arg1_18, iter1_18[1], iter0_18)

			if var3_18 and var3_18.receive == false then
				var0_18 = {
					iter0_18,
					iter1_18,
					arg1_18
				}

				break
			end
		end
	end

	return var0_18
end

function var0_0.ExistCanGetAward(arg0_19, arg1_19)
	if not arg0_19 then
		return false
	end

	local var0_19 = getProxy(ChapterProxy)
	local var1_19 = pg.re_map_template[arg0_19]

	arg1_19 = arg1_19 or var1_19.activity_id or 0

	for iter0_19, iter1_19 in ipairs(var1_19.drop_gain) do
		if #iter1_19 > 0 then
			local var2_19, var3_19, var4_19, var5_19 = unpack(iter1_19)
			local var6_19 = var0_19:getRemasterInfo(arg1_19, var2_19, iter0_19)

			if var6_19 and not var6_19.receive and var5_19 <= var6_19.count then
				return true
			end
		end
	end

	return false
end

function var0_0.GetAwardName(arg0_20, arg1_20)
	if arg0_20 and arg0_20 > 0 then
		local var0_20 = pg.activity_series_enemy and pg.activity_series_enemy[arg1_20] or pg.extraenemy_series_template and pg.extraenemy_series_template[arg1_20]

		return var0_20 and (var0_20.name or var0_20.chapter_name2 or var0_20.chapter_name) or ""
	end

	return pg.chapter_template[arg1_20].chapter_name
end

return var0_0

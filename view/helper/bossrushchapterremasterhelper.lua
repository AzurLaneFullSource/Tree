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

function var0_0.IsAllStoriesPlayed(arg0_10)
	local var0_10 = arg0_10 and pg.memory_group[arg0_10]

	if not var0_10 then
		return false
	end

	local var1_10 = var0_10.memories

	if not var1_10 then
		return true
	end

	local var2_10 = pg.NewStoryMgr.GetInstance()
	local var3_10 = var2_10:GetPlayedList()
	local var4_10 = pg.memory_template

	for iter0_10 = 1, #var1_10 do
		local var5_10 = var4_10[var1_10[iter0_10]]
		local var6_10 = var5_10 and var5_10.story

		if var6_10 and var6_10 ~= "" then
			local var7_10, var8_10 = var2_10:StoryName2StoryId(var6_10)

			if var7_10 and var7_10 > 0 and not var3_10[var7_10] then
				return false
			end
		end
	end

	return true
end

function var0_0.UnlockMemoryGroupStoriesAndShowMsgBox(arg0_11, arg1_11)
	local var0_11 = var0_0.IsAllStoriesPlayed(arg0_11)
	local var1_11 = var0_0.UnlockMemoryGroupStories(arg0_11)

	if #var1_11 <= 0 then
		return false
	end

	if var0_11 then
		return false
	end

	var0_0.ShowUnlockMemoryMsgBox(arg0_11, var1_11, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_MEMORTY,
			memoryGroup = arg0_11
		})
	end, function()
		var0_0.MarkMemoryGroupNotification(arg0_11)

		if arg1_11 then
			arg1_11(var1_11)
		end
	end)

	return true
end

function var0_0.GetPermanentActivityTicketCost(arg0_14, arg1_14)
	if not arg0_14 or not arg1_14 or not pg.activity_task_permanent[arg0_14] then
		return 0
	end

	local var0_14 = var0_0.GetRemasterByActivityId(arg0_14)

	if not var0_14 then
		return 0
	end

	for iter0_14, iter1_14 in ipairs(var0_14.config_data or {}) do
		if iter1_14 == arg1_14 then
			return var0_14.tickets[iter0_14] or 0
		end
	end

	return 0
end

function var0_0.GetChapterIds(arg0_15)
	if var0_0.IsRemasterByActivity(arg0_15) then
		return {}
	else
		local var0_15 = pg.re_map_template[arg0_15]

		return var0_15 and var0_15.config_data or {}
	end
end

function var0_0.GetAllNonActivityIds()
	local var0_16 = {}

	_.each(pg.re_map_template.all, function(arg0_17)
		if not var0_0.IsRemasterByActivity(arg0_17) then
			table.insert(var0_16, arg0_17)
		end
	end)

	return var0_16
end

function var0_0.GetProgress(arg0_18)
	if not arg0_18 then
		return 0
	end

	if var0_0.IsRemasterByActivity(arg0_18) then
		local var0_18 = pg.re_map_template[arg0_18]
		local var1_18 = var0_18 and getProxy(ActivityProxy):getActivityById(var0_18.activity_id)

		if not var1_18 then
			return 0
		end

		local var2_18 = 0

		for iter0_18, iter1_18 in ipairs(var0_18.config_data) do
			if var1_18:HasPassSeries(iter1_18) then
				var2_18 = math.max(var2_18, var0_18.chapter_progress[iter0_18])
			end
		end

		return var2_18
	else
		local var3_18 = getProxy(ChapterProxy)
		local var4_18 = pg.re_map_template[arg0_18]
		local var5_18 = 0

		for iter2_18, iter3_18 in ipairs(var4_18.config_data) do
			if var3_18:getChapterById(iter3_18):isClear() then
				var5_18 = math.max(var5_18, var4_18.chapter_progress[iter2_18])
			end
		end

		return var5_18
	end
end

function var0_0.ChapterAwardInfo(arg0_19, arg1_19)
	if not arg0_19 then
		return nil
	end

	local var0_19
	local var1_19 = getProxy(ChapterProxy)
	local var2_19 = pg.re_map_template[arg0_19]

	arg1_19 = arg1_19 or var2_19.activity_id or 0

	if arg0_19 and #var2_19.drop_gain > 0 then
		for iter0_19, iter1_19 in ipairs(var2_19.drop_gain) do
			local var3_19 = #iter1_19 > 0 and var1_19:getRemasterInfo(arg1_19, iter1_19[1], iter0_19)

			if var3_19 and var3_19.receive == false then
				var0_19 = {
					iter0_19,
					iter1_19,
					arg1_19
				}

				break
			end
		end
	end

	return var0_19
end

function var0_0.ExistCanGetAward(arg0_20, arg1_20)
	if not arg0_20 then
		return false
	end

	local var0_20 = getProxy(ChapterProxy)
	local var1_20 = pg.re_map_template[arg0_20]

	arg1_20 = arg1_20 or var1_20.activity_id or 0

	for iter0_20, iter1_20 in ipairs(var1_20.drop_gain) do
		if #iter1_20 > 0 then
			local var2_20, var3_20, var4_20, var5_20 = unpack(iter1_20)
			local var6_20 = var0_20:getRemasterInfo(arg1_20, var2_20, iter0_20)

			if var6_20 and not var6_20.receive and var5_20 <= var6_20.count then
				return true
			end
		end
	end

	return false
end

function var0_0.GetAwardName(arg0_21, arg1_21)
	if arg0_21 and arg0_21 > 0 then
		local var0_21 = pg.activity_series_enemy and pg.activity_series_enemy[arg1_21] or pg.extraenemy_series_template and pg.extraenemy_series_template[arg1_21]

		return var0_21 and (var0_21.name or var0_21.chapter_name2 or var0_21.chapter_name) or ""
	end

	return pg.chapter_template[arg1_21].chapter_name
end

return var0_0

return {
	GetMaxFormationSuggestionID = function()
		return getProxy(ChapterProxy):getLastUnlockMap().id
	end,
	GetSuggestionMapIDList = function(arg0_2)
		local var0_2 = pg.expedition_data_by_map[arg0_2].type
		local var1_2 = pg.expedition_data_by_map.get_id_list_by_type[var0_2]
		local var2_2 = getProxy(ChapterProxy)
		local var3_2 = {}

		for iter0_2, iter1_2 in ipairs(var1_2) do
			if var2_2:getMapById(iter1_2):isUnlock() and pg.chapter_suggestion_formation.get_id_list_by_chapter[iter1_2] then
				table.insert(var3_2, iter1_2)
			end
		end

		return var3_2
	end,
	HasUnlockSuggestionMap = function()
		local var0_3 = getProxy(ChapterProxy)

		for iter0_3, iter1_3 in ipairs(pg.expedition_data_by_map.get_id_list_by_type[1]) do
			if var0_3:getMapById(iter1_3):isUnlock() and pg.chapter_suggestion_formation.get_id_list_by_chapter[iter1_3] then
				return true
			end
		end

		return false
	end,
	HasUnlockSuggestionHardMap = function()
		local var0_4 = getProxy(ChapterProxy)

		for iter0_4, iter1_4 in ipairs(pg.expedition_data_by_map.get_id_list_by_type[2]) do
			if var0_4:getMapById(iter1_4):isUnlock() and pg.chapter_suggestion_formation.get_id_list_by_chapter[iter1_4] then
				return true
			end
		end
	end
}

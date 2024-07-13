return {
	SORT_TAG = {
		{
			spr = "sort_login",
			tag = i18n("word_default"),
			func = function(arg0_1, arg1_1)
				table.sort(arg0_1, function(arg0_2, arg1_2)
					if arg0_2.unreadCount == arg1_2.unreadCount then
						if arg0_2.online == arg1_2.online then
							if arg0_2.preOnLineTime == arg1_2.preOnLineTime then
								return arg0_2.id < arg1_2.id
							elseif arg1_1 then
								return arg0_2.preOnLineTime < arg1_2.preOnLineTime
							else
								return arg0_2.preOnLineTime > arg1_2.preOnLineTime
							end
						elseif arg1_1 then
							return arg0_2.online < arg1_2.online
						else
							return arg0_2.online > arg1_2.online
						end
					else
						return arg0_2.unreadCount > arg1_2.unreadCount
					end
				end)
			end
		},
		{
			spr = "sort_star",
			tag = i18n("word_star"),
			func = function(arg0_3, arg1_3)
				local var0_3 = pg.ship_data_statistics

				table.sort(arg0_3, function(arg0_4, arg1_4)
					if var0_3[arg0_4.icon].star == var0_3[arg1_4.icon].star then
						if arg0_4.level == arg1_4.level then
							return arg0_4.id < arg1_4.id
						elseif arg1_3 then
							return arg0_4.level < arg1_4.level
						else
							return arg0_4.level > arg1_4.level
						end
					elseif arg1_3 then
						return var0_3[arg0_4.icon].star < var0_3[arg1_4.icon].star
					else
						return var0_3[arg0_4.icon].star > var0_3[arg1_4.icon].star
					end
				end)
			end
		},
		{
			spr = "sort_lv",
			tag = i18n("word_level"),
			func = function(arg0_5, arg1_5)
				table.sort(arg0_5, function(arg0_6, arg1_6)
					if arg0_6.level == arg1_6.level then
						return arg0_6.id < arg1_6.id
					elseif arg1_5 then
						return arg0_6.level < arg1_6.level
					else
						return arg0_6.level > arg1_6.level
					end
				end)
			end
		}
	}
}

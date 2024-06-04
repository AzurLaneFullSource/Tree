return {
	SORT_TAG = {
		{
			spr = "sort_login",
			tag = i18n("word_default"),
			func = function(arg0, arg1)
				table.sort(arg0, function(arg0, arg1)
					if arg0.unreadCount == arg1.unreadCount then
						if arg0.online == arg1.online then
							if arg0.preOnLineTime == arg1.preOnLineTime then
								return arg0.id < arg1.id
							elseif arg1 then
								return arg0.preOnLineTime < arg1.preOnLineTime
							else
								return arg0.preOnLineTime > arg1.preOnLineTime
							end
						elseif arg1 then
							return arg0.online < arg1.online
						else
							return arg0.online > arg1.online
						end
					else
						return arg0.unreadCount > arg1.unreadCount
					end
				end)
			end
		},
		{
			spr = "sort_star",
			tag = i18n("word_star"),
			func = function(arg0, arg1)
				local var0 = pg.ship_data_statistics

				table.sort(arg0, function(arg0, arg1)
					if var0[arg0.icon].star == var0[arg1.icon].star then
						if arg0.level == arg1.level then
							return arg0.id < arg1.id
						elseif arg1 then
							return arg0.level < arg1.level
						else
							return arg0.level > arg1.level
						end
					elseif arg1 then
						return var0[arg0.icon].star < var0[arg1.icon].star
					else
						return var0[arg0.icon].star > var0[arg1.icon].star
					end
				end)
			end
		},
		{
			spr = "sort_lv",
			tag = i18n("word_level"),
			func = function(arg0, arg1)
				table.sort(arg0, function(arg0, arg1)
					if arg0.level == arg1.level then
						return arg0.id < arg1.id
					elseif arg1 then
						return arg0.level < arg1.level
					else
						return arg0.level > arg1.level
					end
				end)
			end
		}
	}
}

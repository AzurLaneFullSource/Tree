local var0_0 = {
	ROLE_TYPE = {
		CHASER = 1,
		PLANNER = 3,
		ALL = 0,
		AMBUSHER = 2
	},
	SPEED_LEVEL = {
		{
			color = "#59606d",
			value = "C",
			range = {
				0,
				99
			}
		},
		{
			color = "#5483c9",
			value = "B",
			range = {
				100,
				149
			}
		},
		{
			color = "#7d54c9",
			value = "A",
			range = {
				150,
				199
			}
		},
		{
			color = "#ff7022",
			value = "S",
			range = {
				200,
				400
			}
		}
	}
}

function var0_0.GetSpeedLevel(arg0_1)
	for iter0_1, iter1_1 in ipairs(var0_0.SPEED_LEVEL) do
		if arg0_1 >= iter1_1.range[1] and arg0_1 <= iter1_1.range[2] then
			return iter1_1
		end
	end
end

return var0_0

local var0_0 = class("CrusingMapInfo")

var0_0.MapInfo = {
	CrusingMap_0 = {
		all = 1260,
		frame = {
			[0] = 0,
			[90] = 1080,
			[100] = 1260,
			[95] = 1185
		}
	},
	CrusingMap_1 = {
		all = 410,
		frame = {
			[0] = 0,
			nil,
			5,
			[40] = 155,
			[63] = 267,
			[62] = 261,
			[70] = 311,
			[74] = 340,
			[50] = 200,
			[54] = 214,
			[90] = 391,
			[82] = 369,
			[60] = 240,
			[10] = 40,
			[100] = 410,
			[30] = 120,
			[80] = 362
		}
	},
	CrusingMap_2 = {
		all = 900,
		frame = {
			[0] = 410,
			[50] = 606,
			[40] = 570,
			[100] = 860,
			[70] = 716,
			[60] = 664,
			[20] = 490,
			[80] = 772,
			[90] = 812,
			[10] = 450,
			[30] = 530
		}
	}
}
var0_0.VersionInfo = {
	map_202212 = "CrusingMap_1",
	map_202308 = "CrusingMap_2",
	map_202208 = "CrusingMap_1",
	map_202312 = "CrusingMap_1",
	map_202306 = "CrusingMap_2",
	map_202406 = "CrusingMap_1",
	map_202110 = "CrusingMap_0",
	map_202204 = "CrusingMap_1",
	map_202202 = "CrusingMap_2",
	map_202302 = "CrusingMap_1",
	map_202210 = "CrusingMap_1",
	map_202310 = "CrusingMap_2",
	map_202112 = "CrusingMap_1",
	map_202304 = "CrusingMap_1",
	map_202206 = "CrusingMap_1",
	map_202404 = "CrusingMap_1",
	map_202402 = "CrusingMap_1"
}

function var0_0.GetPhaseFrame(arg0_1)
	local var0_1 = var0_0.MapInfo[arg0_1]

	return setmetatable(Clone(var0_1.frame), {
		__index = function(arg0_2, arg1_2)
			local var0_2 = 0
			local var1_2 = 100

			for iter0_2, iter1_2 in pairs(arg0_2) do
				if iter0_2 < arg1_2 and var0_2 < iter0_2 then
					var0_2 = iter0_2
				end

				if arg1_2 < iter0_2 and iter0_2 < var1_2 then
					var1_2 = iter0_2
				end
			end

			local var2_2 = (arg1_2 - var0_2) / (var1_2 - var0_2)

			return (1 - var2_2) * arg0_2[var0_2] + var2_2 * arg0_2[var1_2]
		end
	}), var0_1.all
end

return var0_0

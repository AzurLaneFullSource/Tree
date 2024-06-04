local var0 = class("CrusingMapInfo")

var0.MapInfo = {
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
var0.VersionInfo = {
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

function var0.GetPhaseFrame(arg0)
	local var0 = var0.MapInfo[arg0]

	return setmetatable(Clone(var0.frame), {
		__index = function(arg0, arg1)
			local var0 = 0
			local var1 = 100

			for iter0, iter1 in pairs(arg0) do
				if iter0 < arg1 and var0 < iter0 then
					var0 = iter0
				end

				if arg1 < iter0 and iter0 < var1 then
					var1 = iter0
				end
			end

			local var2 = (arg1 - var0) / (var1 - var0)

			return (1 - var2) * arg0[var0] + var2 * arg0[var1]
		end
	}), var0.all
end

return var0

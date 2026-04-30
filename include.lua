pg = pg or {}
ys = ys or {}
cs = cs or {}

local function var0_0(arg0_1)
	return string.gsub(arg0_1 or "", "<%[(.-)%]>", function(arg0_2)
		local var0_2 = pg.equip_data_code[arg0_2]

		return var0_2 and var0_2.text
	end)
end

confNEO = confNEO or {
	__index = function(arg0_3, arg1_3)
		local var0_3 = rawget(arg0_3, "__name")
		local var1_3
		local var2_3 = rawget(arg0_3, "__sub__") or {
			var0_3
		}
		local var3_3 = rawget(arg0_3, "__stream__")

		for iter0_3, iter1_3 in ipairs(var2_3) do
			if var3_3 and cs[iter1_3][arg1_3] and not pg.base[iter1_3][arg1_3] then
				LuaHelper.SetConfVal(iter1_3, cs[iter1_3][arg1_3][1], cs[iter1_3][arg1_3][2])
			end

			var1_3 = pg.base[iter1_3][arg1_3]

			if var1_3 then
				break
			end
		end

		if var1_3 == nil then
			return nil
		end

		local var4_3 = rawget(arg0_3, "__namecode__")
		local var5_3 = rawget(var1_3, "base") or nil

		arg0_3[arg1_3] = setmetatable({}, {
			__index = function(arg0_4, arg1_4)
				local var0_4 = var1_3[arg1_4]

				if var0_4 == nil and var5_3 then
					var0_4 = arg0_3[var5_3][arg1_4]
				end

				if type(var0_4) == "string" then
					if var0_3 == "equip_data_statistics" then
						var0_4 = var0_0(var0_4)
					end

					if var4_3 then
						var0_4 = HXSet.hxLan(var0_4)
					end
				end

				arg0_4[arg1_4] = var0_4

				return var0_4
			end
		})

		return arg0_3[arg1_3]
	end
}

require("localConfig")
require("const")
require("config")
setmetatable(pg, {
	__index = function(arg0_5, arg1_5)
		local var0_5 = "ShareCfg." .. arg1_5

		if ShareCfg[var0_5] then
			require(var0_5)
		else
			local var1_5 = 1

			while ShareCfg[var0_5 .. "_" .. var1_5] do
				require(var0_5 .. "_" .. var1_5)

				var1_5 = var1_5 + 1
			end
		end

		return rawget(pg, arg1_5)
	end
})

ERROR_MESSAGE = setmetatable({}, {
	__index = function(arg0_6, arg1_6)
		if pg.error_message[arg1_6] then
			return pg.error_message[arg1_6].desc
		else
			return "none"
		end
	end
})
BVCurIndex = 1
BVLastIndex = 1

require("Framework/Include")
require("Support/Include")
require("classes")
require("Net/Include")
require("Mgr/Include")
require("GameCfg/Include")
require("Mod/Battle/Include")
require("skillCfg")
require("buffCfg")
require("cardCfg")
require("genVertify")
require("buffFXPreloadList")
require("nodecanvas/Include")

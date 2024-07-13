pg = pg or {}
ys = ys or {}
cs = cs or {}

local function var0_0(arg0_1)
	return string.gsub(arg0_1 or "", "<%[(.-)%]>", function(arg0_2)
		local var0_2 = pg.equip_data_code[arg0_2]

		return var0_2 and var0_2.text
	end)
end

local function var1_0(arg0_3, arg1_3)
	return function(arg0_4, arg1_4)
		local var0_4 = arg0_4.__name

		if arg0_3 == 1 and cs[var0_4][arg1_4] then
			LuaHelper.SetConfVal(var0_4, cs[var0_4][arg1_4][1], cs[var0_4][arg1_4][2])
		end

		if arg0_3 == 2 and cs[var0_4].indexs[arg1_4] then
			local var1_4 = cs[var0_4].subList[cs[var0_4].indexs[arg1_4]]

			if pg.base[var1_4] == nil then
				require("ShareCfg." .. cs[var0_4].subFolderName .. "." .. var1_4)
			end

			var0_4 = var1_4
		end

		local var2_4 = pg.base[var0_4][arg1_4]

		if not var2_4 then
			return nil
		end

		local var3_4 = {}

		for iter0_4, iter1_4 in pairs(var2_4) do
			if type(iter1_4) == "string" then
				var3_4[iter0_4] = var0_0(iter1_4)

				if arg1_3 then
					var3_4[iter0_4] = HXSet.hxLan(var3_4[iter0_4])
				end
			end
		end

		local var4_4 = rawget(var2_4, "base")

		if var4_4 ~= nil then
			arg0_4[arg1_4] = setmetatable(var3_4, {
				__index = function(arg0_5, arg1_5)
					if var2_4[arg1_5] == nil then
						return arg0_4[var4_4][arg1_5]
					else
						return var2_4[arg1_5]
					end
				end
			})
		else
			arg0_4[arg1_4] = setmetatable(var3_4, {
				__index = var2_4
			})
		end

		return arg0_4[arg1_4]
	end
end

confSP = confSP or {
	__index = var1_0(2, true)
}
confMT = confMT or {
	__index = var1_0(1, true)
}
confHX = confHX or {
	__index = var1_0(0, true)
}

require("localConfig")
require("const")
require("config")
setmetatable(pg, {
	__index = function(arg0_6, arg1_6)
		local var0_6 = "ShareCfg." .. arg1_6

		if ShareCfg[var0_6] then
			require(var0_6)

			return rawget(pg, arg1_6)
		end
	end
})

ERROR_MESSAGE = setmetatable({}, {
	__index = function(arg0_7, arg1_7)
		if pg.error_message[arg1_7] then
			return pg.error_message[arg1_7].desc
		else
			return "none"
		end
	end
})
BVCurIndex = 1
BVLastIndex = 1

require("Support/Utils/HXSet")
require("Framework/Include")
require("Support/Include")
require("Net/Include")
require("Mgr/Include")
require("GameCfg/Include")
require("Mod/Battle/Include")
require("skillCfg")
require("buffCfg")
require("cardCfg")
require("genVertify")
require("buffFXPreloadList")

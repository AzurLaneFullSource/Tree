pg = pg or {}
ys = ys or {}
cs = cs or {}

local function var0(arg0)
	return string.gsub(arg0 or "", "<%[(.-)%]>", function(arg0)
		local var0 = pg.equip_data_code[arg0]

		return var0 and var0.text
	end)
end

local function var1(arg0, arg1)
	return function(arg0, arg1)
		local var0 = arg0.__name

		if arg0 == 1 and cs[var0][arg1] then
			LuaHelper.SetConfVal(var0, cs[var0][arg1][1], cs[var0][arg1][2])
		end

		if arg0 == 2 and cs[var0].indexs[arg1] then
			local var1 = cs[var0].subList[cs[var0].indexs[arg1]]

			if pg.base[var1] == nil then
				require("ShareCfg." .. cs[var0].subFolderName .. "." .. var1)
			end

			var0 = var1
		end

		local var2 = pg.base[var0][arg1]

		if not var2 then
			return nil
		end

		local var3 = {}

		for iter0, iter1 in pairs(var2) do
			if type(iter1) == "string" then
				var3[iter0] = var0(iter1)

				if arg1 then
					var3[iter0] = HXSet.hxLan(var3[iter0])
				end
			end
		end

		local var4 = rawget(var2, "base")

		if var4 ~= nil then
			arg0[arg1] = setmetatable(var3, {
				__index = function(arg0, arg1)
					if var2[arg1] == nil then
						return arg0[var4][arg1]
					else
						return var2[arg1]
					end
				end
			})
		else
			arg0[arg1] = setmetatable(var3, {
				__index = var2
			})
		end

		return arg0[arg1]
	end
end

confSP = confSP or {
	__index = var1(2, true)
}
confMT = confMT or {
	__index = var1(1, true)
}
confHX = confHX or {
	__index = var1(0, true)
}

require("localConfig")
require("const")
require("config")
setmetatable(pg, {
	__index = function(arg0, arg1)
		local var0 = "ShareCfg." .. arg1

		if ShareCfg[var0] then
			require(var0)

			return rawget(pg, arg1)
		end
	end
})

ERROR_MESSAGE = setmetatable({}, {
	__index = function(arg0, arg1)
		if pg.error_message[arg1] then
			return pg.error_message[arg1].desc
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

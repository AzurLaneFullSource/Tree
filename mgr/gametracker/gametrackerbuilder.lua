local var0_0 = class("GameTrackerBuilder")
local var1_0 = ";"
local var2_0 = "`"

function var0_0.SerializedItem(arg0_1)
	local var0_1 = table.concat(arg0_1.int_args or {}, var2_0)
	local var1_1 = table.concat(arg0_1.str_args or {}, var2_0)

	return table.concat({
		arg0_1.track_typ or "",
		arg0_1.track_time or "",
		var0_1 or "",
		var1_1 or ""
	}, var1_0)
end

function var0_0.DeSerializedItem(arg0_2)
	local var0_2 = string.split(arg0_2, var1_0)

	if #var0_2 < 2 then
		return false
	end

	local var1_2 = tonumber(var0_2[1] or "")
	local var2_2 = tonumber(var0_2[2] or "")

	if var1_2 == nil or var2_2 == nil then
		return false
	end

	local var3_2 = var0_2[3] or ""
	local var4_2 = string.split(var3_2, var2_0)
	local var5_2 = {}

	for iter0_2, iter1_2 in ipairs(var4_2) do
		local var6_2 = tonumber(iter1_2)

		if var6_2 then
			table.insert(var5_2, var6_2)
		end
	end

	local var7_2 = var0_2[4] or ""
	local var8_2 = string.split(var7_2, var2_0)

	return {
		track_typ = var1_2,
		track_time = var2_2,
		int_args = var5_2,
		str_args = var8_2
	}
end

local function var3_0(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		table.insert(var0_3, tonumber(iter1_3 .. ""))
	end

	for iter2_3, iter3_3 in ipairs(arg2_3) do
		table.insert(var1_3, tostring(iter3_3))
	end

	local var2_3 = pg.TimeMgr.GetInstance():GetServerTime()

	return {
		track_typ = arg0_3,
		track_time = var2_3,
		int_args = var0_3,
		str_args = var1_3
	}
end

function var0_0.BuildStoryStart(arg0_4, arg1_4)
	return var3_0(18, {
		1,
		arg0_4,
		arg1_4
	}, {})
end

function var0_0.BuildStorySkip(arg0_5, arg1_5)
	return var3_0(18, {
		2,
		arg0_5,
		arg1_5
	}, {})
end

function var0_0.BuildNotice(arg0_6)
	return var3_0(19, {}, {
		arg0_6
	})
end

function var0_0.BuildStoryOption(arg0_7, arg1_7)
	return var3_0(20, {
		arg0_7
	}, {
		arg1_7
	})
end

function var0_0.BuildEmoji(arg0_8)
	local var0_8 = "777#(%d+)#777"
	local var1_8 = arg0_8:match(var0_8)
	local var2_8 = tonumber(var1_8)

	if var2_8 and var2_8 > 0 then
		return var3_0(21, {
			var2_8
		}, {})
	else
		return var3_0(21, {
			0
		}, {})
	end
end

function var0_0.BuildExitSilentView(arg0_9, arg1_9, arg2_9)
	return var3_0(22, {
		arg0_9,
		arg1_9
	}, {
		arg2_9
	})
end

function var0_0.BuildTouchBanner(arg0_10)
	return var3_0(23, {}, {
		arg0_10
	})
end

function var0_0.BuildSwitchPainting(arg0_11, arg1_11)
	return var3_0(24, {
		arg0_11,
		arg1_11
	}, {})
end

function var0_0.BuildHubGames(arg0_12, arg1_12, arg2_12)
	return var3_0(25, {
		arg0_12,
		arg1_12
	}, {
		arg2_12
	})
end

function var0_0.BuildUrRedeem(arg0_13, arg1_13)
	return var3_0(26, {
		arg0_13
	}, {
		arg1_13
	})
end

function var0_0.BuildUrJump(arg0_14)
	return var3_0(27, {}, {
		arg0_14
	})
end

function var0_0.BuildDorm3d(arg0_15)
	return var3_0(arg0_15.track_typ, arg0_15.int_args, arg0_15.str_args)
end

return var0_0

local var0_0 = class("GuildLogInfo", import("..BaseVO"))

var0_0.CMD_TYPE_JOIN = 1
var0_0.CMD_TYPE_SET_DUTY = 2
var0_0.CMD_TYPE_QUIT = 3
var0_0.CMD_TYPE_FIRE = 4
var0_0.CMD_TYPE_GET_SHIP = 5
var0_0.CMD_TYPE_FACILITY_CONTRIBUTION = 6
var0_0.CMD_TYPE_FACILITY_CONSUME = 7

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.cmd = arg1_1.cmd
	arg0_1.time = arg1_1.time
	arg0_1.userId = arg1_1.user_id
	arg0_1.name = arg1_1.name
	arg0_1.arg0 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.arg0 or {}) do
		table.insert(arg0_1.arg0, iter1_1)
	end

	arg0_1.arg1 = arg1_1.arg1
end

function var0_0.getConent(arg0_2)
	local var0_2 = getOfflineTimeStamp(arg0_2.time)
	local var1_2 = pg.TimeMgr.GetInstance():STimeDescC(arg0_2.time, "[%m-%d %H:%M]")

	if arg0_2.cmd == var0_0.CMD_TYPE_JOIN then
		return i18n("guild_log_new_guild_join", arg0_2.name), var0_2
	elseif arg0_2.cmd == var0_0.CMD_TYPE_SET_DUTY then
		return i18n("guild_log_duty_change", arg0_2.name, GuildMember.dutyId2Name(arg0_2.arg1)), var0_2
	elseif arg0_2.cmd == var0_0.CMD_TYPE_QUIT then
		return i18n("guild_log_quit", arg0_2.name), var0_2
	elseif arg0_2.cmd == var0_0.CMD_TYPE_FIRE then
		return i18n("guild_log_fire", arg0_2.name), var0_2
	elseif arg0_2.cmd == var0_0.CMD_TYPE_GET_SHIP then
		local var2_2 = Ship.New({
			configId = arg0_2.arg1
		})
		local var3_2 = {
			PublicArg.New({
				type = PublicArg.TypePlayerName,
				string = arg0_2.name
			}),
			PublicArg.New({
				type = PublicArg.TypeShipId,
				int = arg0_2.arg1
			})
		}

		return {
			id = 3,
			args = var3_2
		}, var0_2
	elseif arg0_2.cmd == var0_0.CMD_TYPE_FACILITY_CONTRIBUTION then
		local var4_2 = i18n("word_contribution")
		local var5_2 = Item.New({
			id = id2ItemId(arg0_2.arg0[2])
		})
		local var6_2 = arg0_2.arg0[1] .. var5_2:getConfig("name")
		local var7_2 = i18n("guild_facility_get_gold", arg0_2.arg0[3])

		return arg0_2.name .. arg0_2:getDuty(), var1_2, var4_2, var6_2, var7_2
	elseif arg0_2.cmd == var0_0.CMD_TYPE_FACILITY_CONSUME then
		local var8_2 = i18n("word_consume")
		local var9_2 = arg0_2.arg0[1] .. i18n("word_guild_res")
		local var10_2 = ""

		if arg0_2.arg0[2] then
			local var11_2 = GuildFacility.New({
				id = arg0_2.arg0[2]
			}):getConfig("name")

			var10_2 = i18n("guild_facility_upgrade", var11_2, arg0_2.arg0[3])
		end

		return arg0_2.name .. arg0_2:getDuty(), var1_2, var8_2, var9_2, var10_2
	end
end

function var0_0.getDuty(arg0_3)
	local var0_3 = ""

	if arg0_3.arg1 then
		var0_3 = " （" .. GuildMember.dutyId2Name(arg0_3.arg1) .. "）"
	end

	return var0_3
end

return var0_0

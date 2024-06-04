local var0 = class("GuildLogInfo", import("..BaseVO"))

var0.CMD_TYPE_JOIN = 1
var0.CMD_TYPE_SET_DUTY = 2
var0.CMD_TYPE_QUIT = 3
var0.CMD_TYPE_FIRE = 4
var0.CMD_TYPE_GET_SHIP = 5
var0.CMD_TYPE_FACILITY_CONTRIBUTION = 6
var0.CMD_TYPE_FACILITY_CONSUME = 7

function var0.Ctor(arg0, arg1)
	arg0.cmd = arg1.cmd
	arg0.time = arg1.time
	arg0.userId = arg1.user_id
	arg0.name = arg1.name
	arg0.arg0 = {}

	for iter0, iter1 in ipairs(arg1.arg0 or {}) do
		table.insert(arg0.arg0, iter1)
	end

	arg0.arg1 = arg1.arg1
end

function var0.getConent(arg0)
	local var0 = getOfflineTimeStamp(arg0.time)
	local var1 = pg.TimeMgr.GetInstance():STimeDescC(arg0.time, "[%m-%d %H:%M]")

	if arg0.cmd == var0.CMD_TYPE_JOIN then
		return i18n("guild_log_new_guild_join", arg0.name), var0
	elseif arg0.cmd == var0.CMD_TYPE_SET_DUTY then
		return i18n("guild_log_duty_change", arg0.name, GuildMember.dutyId2Name(arg0.arg1)), var0
	elseif arg0.cmd == var0.CMD_TYPE_QUIT then
		return i18n("guild_log_quit", arg0.name), var0
	elseif arg0.cmd == var0.CMD_TYPE_FIRE then
		return i18n("guild_log_fire", arg0.name), var0
	elseif arg0.cmd == var0.CMD_TYPE_GET_SHIP then
		local var2 = Ship.New({
			configId = arg0.arg1
		})
		local var3 = {
			PublicArg.New({
				type = PublicArg.TypePlayerName,
				string = arg0.name
			}),
			PublicArg.New({
				type = PublicArg.TypeShipId,
				int = arg0.arg1
			})
		}

		return {
			id = 3,
			args = var3
		}, var0
	elseif arg0.cmd == var0.CMD_TYPE_FACILITY_CONTRIBUTION then
		local var4 = i18n("word_contribution")
		local var5 = Item.New({
			id = id2ItemId(arg0.arg0[2])
		})
		local var6 = arg0.arg0[1] .. var5:getConfig("name")
		local var7 = i18n("guild_facility_get_gold", arg0.arg0[3])

		return arg0.name .. arg0:getDuty(), var1, var4, var6, var7
	elseif arg0.cmd == var0.CMD_TYPE_FACILITY_CONSUME then
		local var8 = i18n("word_consume")
		local var9 = arg0.arg0[1] .. i18n("word_guild_res")
		local var10 = ""

		if arg0.arg0[2] then
			local var11 = GuildFacility.New({
				id = arg0.arg0[2]
			}):getConfig("name")

			var10 = i18n("guild_facility_upgrade", var11, arg0.arg0[3])
		end

		return arg0.name .. arg0:getDuty(), var1, var8, var9, var10
	end
end

function var0.getDuty(arg0)
	local var0 = ""

	if arg0.arg1 then
		var0 = " （" .. GuildMember.dutyId2Name(arg0.arg1) .. "）"
	end

	return var0
end

return var0

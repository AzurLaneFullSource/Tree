local var0_0 = class("ShipStatus")

var0_0.flagList = {
	"inChapter",
	"inFleet",
	"inElite",
	"inActivity",
	"inPvP",
	"inExercise",
	"inEvent",
	"inClass",
	"inTactics",
	"inBackyard",
	"inAdmiral",
	"inWorld",
	"isActivityNpc",
	"inGuildEvent",
	"inGuildBossEvent",
	"inChallenge",
	"inSupport"
}

function var0_0.checkShipFlag(arg0_1, arg1_1, arg2_1)
	local var0_1 = defaultValue(arg1_1[arg2_1], var0_0.TAG_HIDE_BASE[arg2_1])

	if type(var0_1) == "boolean" then
		return not var0_1 and arg0_1:getFlag(arg2_1)
	elseif type(var0_1) == "number" then
		return arg0_1:getFlag(arg2_1, var0_1)
	else
		assert(false, "type error")
	end
end

function var0_0.ShipStatusToTag(arg0_2, arg1_2)
	if var0_0.checkShipFlag(arg0_2, arg1_2, "inChapter") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inFight")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inFleet") then
		local var0_2 = getProxy(FleetProxy):GetRegularFleetByShip(arg0_2)

		assert(var0_2)

		local var1_2 = var0_2.id

		if var0_2:isRegularFleet() then
			var1_2 = math.fmod(var1_2, 10)

			return {
				"ui/dockyardui_atlas",
				"biandui0" .. var1_2,
				""
			}
		else
			return {
				"shipstatus",
				"red",
				Fleet.DEFAULT_NAME_FOR_DOCKYARD[var1_2]
			}
		end
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inElite") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inHardFormation")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inSupport") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inSupportFleet")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inActivity") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_activity")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inChallenge") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_challenge")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inPvP") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inPVP")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inEvent") then
		return {
			"shipstatus",
			"green",
			i18n("word_status_inEvent")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inBackyard") then
		if arg0_2.state == Ship.STATE_REST then
			return {
				"shipstatus",
				"purple",
				i18n("word_status_rest")
			}
		elseif arg0_2.state == Ship.STATE_TRAIN then
			return {
				"shipstatus",
				"purple",
				i18n("word_status_train")
			}
		end
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inClass") then
		return {
			"shipstatus",
			"blue",
			i18n("word_status_inClass")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inTactics") then
		return {
			"shipstatus",
			"blue",
			i18n("word_status_inTactics")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inAdmiral") then
		return {
			"shipstatus",
			"light_green",
			i18n("common_flag_ship")
		}
	elseif var0_0.checkShipFlag(arg0_2, arg1_2, "inWorld") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_world")
		}
	elseif getProxy(SettingsProxy):IsRandomFlagShip(arg0_2.id) then
		return {
			"shipstatus",
			"light_yellow",
			i18n("random_flag_ship")
		}
	end
end

var0_0.FILTER_SHIPS_FLAGS_1 = {
	inExercise = false,
	inChapter = true,
	inFleet = false,
	inSupport = true,
	inPvP = false,
	inActivity = true,
	inTactics = false,
	inElite = false,
	inGuildEvent = true,
	inEvent = true,
	inBackyard = false,
	inClass = true,
	isActivityNpc = true,
	inChallenge = true,
	inWorld = true,
	inAdmiral = true
}
var0_0.FILTER_SHIPS_FLAGS_2 = {
	inGuildBossEvent = true,
	inChallenge = true,
	inBackyard = true,
	inSupport = true,
	inClass = true,
	inActivity = true,
	inGuildEvent = true,
	isActivityNpc = true,
	inWorld = true,
	inAdmiral = true,
	inExercise = true,
	inChapter = true,
	inFleet = true,
	inPvP = true,
	inTactics = true,
	inElite = true,
	inEvent = true
}
var0_0.FILTER_SHIPS_FLAGS_3 = {
	inExercise = false,
	inChapter = true,
	inFleet = false,
	inSupport = true,
	inPvP = false,
	inActivity = true,
	inTactics = false,
	inElite = false,
	inGuildEvent = true,
	inEvent = true,
	inBackyard = false,
	inClass = true,
	isActivityNpc = true,
	inChallenge = true,
	inWorld = true,
	inAdmiral = false
}
var0_0.FILTER_SHIPS_FLAGS_4 = {
	inPvP = true,
	inChallenge = true,
	inBackyard = true,
	inSupport = true,
	inClass = true,
	inActivity = true,
	inGuildEvent = true,
	isActivityNpc = true,
	inWorld = true,
	inAdmiral = true,
	inExercise = true,
	inChapter = true,
	inFleet = true,
	inGuildBossEvent = true,
	inTactics = true,
	inElite = true,
	inEvent = true
}
var0_0.TAG_HIDE_ALL = {
	inExercise = true,
	inChallenge = true,
	inChapter = true,
	inFleet = true,
	inPvP = true,
	inActivity = true,
	inTactics = true,
	inElite = true,
	inClass = true,
	inEvent = true,
	inBackyard = true,
	isActivityNpc = true,
	inWorld = true,
	inAdmiral = true
}
var0_0.TAG_HIDE_BASE = {
	inExercise = true,
	inChallenge = false,
	inChapter = false,
	inSupport = false,
	inPvP = false,
	inActivity = false,
	inTactics = false,
	inElite = true,
	inClass = false,
	inEvent = false,
	inFleet = false,
	inBackyard = false,
	isActivityNpc = false,
	inWorld = false,
	inAdmiral = false
}
var0_0.TAG_HIDE_ACTIVITY_BOSS = {
	inChallenge = true,
	inChapter = true,
	inPvP = true,
	inFleet = true,
	inClass = true,
	inBackyard = true,
	inTactics = true,
	inAdmiral = true
}
var0_0.TAG_HIDE_BACKYARD = {
	inExercise = false,
	inChallenge = true,
	inChapter = true,
	inEvent = true,
	inPvP = true,
	inActivity = true,
	inTactics = true
}
var0_0.TAG_HIDE_PVP = {
	inExercise = false,
	inChapter = true,
	inChallenge = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true,
	inPvP = true
}
var0_0.TAG_HIDE_DEFENSE = {
	inExercise = false,
	inChapter = true,
	inChallenge = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true,
	inPvP = true,
	inEvent = true
}
var0_0.TAG_HIDE_LEVEL = {
	inBackyard = true,
	inChallenge = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inAdmiral = true
}
var0_0.TAG_HIDE_SUPPORT = {
	inBackyard = true,
	inChallenge = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inAdmiral = true
}
var0_0.TAG_HIDE_NORMAL = {
	inExercise = false,
	inChallenge = true,
	inPvP = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true
}
var0_0.TAG_HIDE_CHALLENGE = {
	inPvP = true,
	inChapter = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true,
	inEvent = false,
	inAdmiral = true
}
var0_0.TAG_HIDE_EVENT = {
	inExercise = false,
	inChallenge = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true
}
var0_0.TAG_HIDE_TACTICES = {
	inExercise = false,
	inChapter = true,
	inChallenge = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true,
	inPvP = true,
	inEvent = true
}
var0_0.TAG_HIDE_ADMIRAL = {
	inExercise = false,
	inChapter = true,
	inChallenge = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true,
	inPvP = true,
	inEvent = true
}
var0_0.TAG_HIDE_FORMATION = {
	inExercise = false,
	inChallenge = true,
	inPvP = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true
}
var0_0.TAG_HIDE_WORLD = {
	inActivity = true,
	inChallenge = true,
	inFleet = true
}
var0_0.TAG_HIDE_DESTROY = {
	inElite = false
}
var0_0.TAG_BLOCK_EVENT = {
	inEvent = true
}
var0_0.TAG_BLOCK_PVP = {
	inEvent = true
}
var0_0.TAG_BLOCK_BACKYARD = {
	inClass = true
}
var0_0.STATE_CHANGE_OK = -1
var0_0.STATE_CHANGE_FAIL = 0
var0_0.STATE_CHANGE_CHECK = 1
var0_0.STATE_CHANGE_TIP = 2

local var1_0 = {
	inFleet = {
		inEvent = 0,
		inSupport = 1
	},
	inSupport = {
		inEvent = 0,
		inFleet = 0
	},
	inElite = {
		inEvent = 0,
		inElite = 0
	},
	inActivity = {
		isActivityNpc = 0,
		inEvent = 0
	},
	inChallenge = {
		isActivityNpc = 0,
		inEvent = 0
	},
	inEvent = {
		inEvent = 0,
		inChapter = 0,
		inSupport = 0,
		inFleet = 1,
		isActivityNpc = 0,
		inPvP = 1
	},
	inClass = {
		isActivityNpc = 0,
		inClass = 0,
		inBackyard = 1
	},
	inTactics = {
		inTactics = 0
	},
	inBackyard = {
		inClass = 0,
		isActivityNpc = 0
	},
	inWorld = {
		isActivityNpc = 0
	},
	onPropose = {
		inChapter = 0,
		inEvent = 0
	},
	onModify = {
		inChapter = 0
	},
	onDestroy = {
		inExercise = 1,
		inChallenge = 0,
		inSupport = 0,
		inFleet = 1,
		inClass = 0,
		inActivity = 0,
		inTactics = 1,
		inBackyard = 1,
		inGuildEvent = 0,
		inEvent = 0,
		inChapter = 0,
		inPvP = 1,
		isActivityNpc = 0,
		inGuildBossEvent = 1,
		inWorld = 0,
		inAdmiral = 0
	},
	onTeamChange = {
		inExercise = 1,
		inChallenge = 0,
		inChapter = 0,
		inFleet = 1,
		inPvP = 1,
		inActivity = 0,
		inWorld = 1,
		inGuildBossEvent = 1
	}
}
local var2_0 = {
	inChapter = {
		tips_block = "word_shipState_fight"
	},
	inFleet = {
		tips_block = "word_shipState_fight"
	},
	inElite = {
		tips_block = "word_shipState_fight"
	},
	inActivity = {
		tips_block = "shipmodechange_reject_inactivity"
	},
	inChallenge = {
		tips_block = "shipmodechange_reject_inchallenge"
	},
	inPvP = {
		tips_block = "word_shipState_fight"
	},
	inExercise = {
		tips_block = "word_shipState_fight"
	},
	inEvent = {
		tips_block = "word_shipState_event"
	},
	inClass = {
		tips_block = "word_shipState_study"
	},
	inTactics = {
		tips_block = "word_shipState_tactics"
	},
	inBackyard = {
		tips_block = "word_shipState_rest"
	},
	inAdmiral = {
		tips_block = "playerinfo_ship_is_already_flagship"
	},
	inGuildEvent = {
		tips_block = "word_shipState_guild_event"
	},
	inGuildBossEvent = {
		tips_block = "word_shipState_guild_event"
	},
	isActivityNpc = {
		tips_block = "word_shipState_npc"
	},
	inWorld = {
		tips_block = "word_shipState_world"
	},
	inSupport = {
		tips_block = "word_shipState_support"
	}
}

function var0_0.ShipStatusCheck(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3, var1_3 = var0_0.ShipStatusConflict(arg0_3, arg1_3, arg3_3)

	if var0_3 == var0_0.STATE_CHANGE_FAIL then
		return false, i18n(var1_3)
	elseif var0_3 == var0_0.STATE_CHANGE_CHECK then
		if arg2_3 then
			return var0_0.ChangeStatusCheckBox(var1_3, arg1_3, arg2_3)
		else
			return false
		end
	elseif var0_3 == var0_0.STATE_CHANGE_TIP then
		return var0_0.ChangeStatusTipBox(var1_3, arg1_3)
	elseif var0_3 == var0_0.STATE_CHANGE_OK then
		return true
	else
		assert(false, "unknow error")
	end
end

function var0_0.ShipStatusConflict(arg0_4, arg1_4, arg2_4)
	local var0_4 = var1_0[arg0_4]

	arg2_4 = arg2_4 or {}

	for iter0_4, iter1_4 in ipairs(var0_0.flagList) do
		if var0_4[iter1_4] == var0_0.STATE_CHANGE_FAIL and arg1_4:getFlag(iter1_4, arg2_4[iter1_4]) then
			return var0_0.STATE_CHANGE_FAIL, var2_0[iter1_4].tips_block
		end
	end

	for iter2_4, iter3_4 in ipairs(var0_0.flagList) do
		if var0_4[iter3_4] == var0_0.STATE_CHANGE_CHECK and arg1_4:getFlag(iter3_4, arg2_4[iter3_4]) then
			return var0_0.STATE_CHANGE_CHECK, iter3_4
		end
	end

	for iter4_4, iter5_4 in ipairs(var0_0.flagList) do
		if var0_4[iter5_4] == var0_0.STATE_CHANGE_TIP and arg1_4:getFlag(iter5_4, arg2_4[iter5_4]) then
			return var0_0.STATE_CHANGE_TIP, iter5_4
		end
	end

	return var0_0.STATE_CHANGE_OK
end

function var0_0.ChangeStatusCheckBox(arg0_5, arg1_5, arg2_5)
	if arg0_5 == "inBackyard" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_vo_moveout_backyard"),
			onYes = function()
				pg.m02:sendNotification(GAME.EXIT_SHIP, {
					callback = arg2_5,
					shipId = arg1_5.id
				})
			end
		})

		return false, nil
	elseif arg0_5 == "inFleet" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("shipchange_alert_infleet"),
			onYes = function()
				local var0_7 = getProxy(FleetProxy):GetRegularFleetByShip(arg1_5)

				if var0_7:canRemove(arg1_5) then
					var0_7:removeShip(arg1_5)
					pg.m02:sendNotification(GAME.UPDATE_FLEET, {
						callback = arg2_5,
						fleet = var0_7
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("shipmodechange_reject_1stfleet_only"))
				end
			end
		})

		return false, nil
	elseif arg0_5 == "inPvP" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("shipchange_alert_inpvp"),
			onYes = function()
				local var0_8 = getProxy(FleetProxy):getFleetById(FleetProxy.PVP_FLEET_ID)

				if var0_8:canRemove(arg1_5) then
					var0_8:removeShip(arg1_5)
					pg.m02:sendNotification(GAME.UPDATE_FLEET, {
						callback = arg2_5,
						fleet = var0_8
					})
				else
					local var1_8 = arg1_5:getTeamType()

					if var1_8 == TeamType.Vanguard then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_vanguardFleet_must_hasShip"))
					elseif var1_8 == TeamType.Main then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_mainFleet_must_hasShip"))
					end
				end
			end
		})

		return false, nil
	elseif arg0_5 == "inExercise" then
		local var0_5 = getProxy(MilitaryExerciseProxy):getExerciseFleet()

		if var0_5:canRemove(arg1_5) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("shipchange_alert_inexercise"),
				onYes = function()
					var0_5:removeShip(arg1_5)
					pg.m02:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
						fleet = var0_5,
						callback = arg2_5
					})
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function()
					var0_5:removeShip(arg1_5)
					pg.m02:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
						fleet = var0_5,
						callback = arg2_5
					})
				end
			})
		end

		return false, nil
	elseif arg0_5 == "inTactics" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tactics_lesson_cancel"),
			onYes = function()
				local var0_11 = getProxy(NavalAcademyProxy):getStudentIdByShipId(arg1_5.id)

				pg.m02:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
					callback = arg2_5,
					shipId = var0_11,
					type = Student.CANCEL_TYPE_MANUAL
				})
			end
		})

		return false, nil
	elseif arg0_5 == "inGuildBossEvent" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("word_shipState_guild_boss"),
			onYes = function()
				local var0_12 = getProxy(GuildProxy):getRawData()

				if not var0_12 then
					return
				end

				local var1_12 = var0_12:GetActiveEvent()

				if not var1_12 then
					return
				end

				local var2_12 = var1_12:GetBossMission()

				if not var2_12 or not var2_12:IsActive() then
					return
				end

				local var3_12 = getProxy(PlayerProxy):getRawData().id
				local var4_12 = var2_12:GetFleetUserId(var3_12, arg1_5.id)

				if not var4_12 then
					return
				end

				local var5_12 = Clone(var4_12)

				var5_12:RemoveUserShip(var3_12, arg1_5.id)
				pg.m02:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
					force = true,
					editFleet = {
						[var5_12.id] = var5_12
					},
					callback = arg2_5
				})
			end
		})

		return false, nil
	elseif arg0_5 == "inWorld" then
		local var1_5 = nowWorld()

		if var1_5.type == World.TypeBase then
			WorldConst.ReqWorldCheck(arg2_5)

			return false, nil
		else
			local var2_5 = var1_5:GetShip(arg1_5.id).fleetId

			if #var1_5:GetFleet(var2_5)[arg1_5:getTeamType()] > 1 then
				return true
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("shipmodechange_reject_worldfleet_only"))

				return false, nil
			end
		end
	end

	return true
end

function var0_0.ChangeStatusTipBox(arg0_13, arg1_13)
	if arg0_13 == "inElite" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("ship_vo_moveout_hardFormation")
		})
	end

	return true
end

function var0_0.canDestroyShip(arg0_14, arg1_14)
	if arg0_14:isBluePrintShip() then
		return false, i18n("blueprint_destory_tip")
	elseif arg0_14:GetLockState() == Ship.LOCK_STATE_LOCK then
		return false, i18n("ship_vo_locked")
	elseif arg0_14:isMetaShip() then
		return false, i18n("meta_destroy_tip")
	end

	return var0_0.ShipStatusCheck("onDestroy", arg0_14, arg1_14)
end

return var0_0

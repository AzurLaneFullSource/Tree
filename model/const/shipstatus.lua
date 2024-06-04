local var0 = class("ShipStatus")

var0.flagList = {
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

function var0.checkShipFlag(arg0, arg1, arg2)
	local var0 = defaultValue(arg1[arg2], var0.TAG_HIDE_BASE[arg2])

	if type(var0) == "boolean" then
		return not var0 and arg0:getFlag(arg2)
	elseif type(var0) == "number" then
		return arg0:getFlag(arg2, var0)
	else
		assert(false, "type error")
	end
end

function var0.ShipStatusToTag(arg0, arg1)
	if var0.checkShipFlag(arg0, arg1, "inChapter") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inFight")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inFleet") then
		local var0 = getProxy(FleetProxy):GetRegularFleetByShip(arg0)

		assert(var0)

		local var1 = var0.id

		if var0:isRegularFleet() then
			var1 = math.fmod(var1, 10)

			return {
				"ui/dockyardui_atlas",
				"biandui0" .. var1,
				""
			}
		else
			return {
				"shipstatus",
				"red",
				Fleet.DEFAULT_NAME_FOR_DOCKYARD[var1]
			}
		end
	elseif var0.checkShipFlag(arg0, arg1, "inElite") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inHardFormation")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inSupport") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inSupportFleet")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inActivity") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_activity")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inChallenge") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_challenge")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inPvP") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_inPVP")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inEvent") then
		return {
			"shipstatus",
			"green",
			i18n("word_status_inEvent")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inBackyard") then
		if arg0.state == Ship.STATE_REST then
			return {
				"shipstatus",
				"purple",
				i18n("word_status_rest")
			}
		elseif arg0.state == Ship.STATE_TRAIN then
			return {
				"shipstatus",
				"purple",
				i18n("word_status_train")
			}
		end
	elseif var0.checkShipFlag(arg0, arg1, "inClass") then
		return {
			"shipstatus",
			"blue",
			i18n("word_status_inClass")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inTactics") then
		return {
			"shipstatus",
			"blue",
			i18n("word_status_inTactics")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inAdmiral") then
		return {
			"shipstatus",
			"light_green",
			i18n("common_flag_ship")
		}
	elseif var0.checkShipFlag(arg0, arg1, "inWorld") then
		return {
			"shipstatus",
			"red",
			i18n("word_status_world")
		}
	elseif getProxy(SettingsProxy):IsRandomFlagShip(arg0.id) then
		return {
			"shipstatus",
			"light_yellow",
			i18n("random_flag_ship")
		}
	end
end

var0.FILTER_SHIPS_FLAGS_1 = {
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
var0.FILTER_SHIPS_FLAGS_2 = {
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
var0.FILTER_SHIPS_FLAGS_3 = {
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
var0.FILTER_SHIPS_FLAGS_4 = {
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
var0.TAG_HIDE_ALL = {
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
var0.TAG_HIDE_BASE = {
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
var0.TAG_HIDE_ACTIVITY_BOSS = {
	inChallenge = true,
	inChapter = true,
	inPvP = true,
	inFleet = true,
	inClass = true,
	inBackyard = true,
	inTactics = true,
	inAdmiral = true
}
var0.TAG_HIDE_BACKYARD = {
	inExercise = false,
	inChallenge = true,
	inChapter = true,
	inEvent = true,
	inPvP = true,
	inActivity = true,
	inTactics = true
}
var0.TAG_HIDE_PVP = {
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
var0.TAG_HIDE_DEFENSE = {
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
var0.TAG_HIDE_LEVEL = {
	inBackyard = true,
	inChallenge = true,
	inFleet = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inAdmiral = true
}
var0.TAG_HIDE_SUPPORT = {
	inBackyard = true,
	inChallenge = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inAdmiral = true
}
var0.TAG_HIDE_NORMAL = {
	inExercise = false,
	inChallenge = true,
	inPvP = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true
}
var0.TAG_HIDE_CHALLENGE = {
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
var0.TAG_HIDE_EVENT = {
	inExercise = false,
	inChallenge = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true
}
var0.TAG_HIDE_TACTICES = {
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
var0.TAG_HIDE_ADMIRAL = {
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
var0.TAG_HIDE_FORMATION = {
	inExercise = false,
	inChallenge = true,
	inPvP = true,
	inClass = true,
	inActivity = true,
	inTactics = true,
	inBackyard = true
}
var0.TAG_HIDE_WORLD = {
	inActivity = true,
	inChallenge = true,
	inFleet = true
}
var0.TAG_HIDE_DESTROY = {
	inElite = false
}
var0.TAG_BLOCK_EVENT = {
	inEvent = true
}
var0.TAG_BLOCK_PVP = {
	inEvent = true
}
var0.TAG_BLOCK_BACKYARD = {
	inClass = true
}
var0.STATE_CHANGE_OK = -1
var0.STATE_CHANGE_FAIL = 0
var0.STATE_CHANGE_CHECK = 1
var0.STATE_CHANGE_TIP = 2

local var1 = {
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
local var2 = {
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

function var0.ShipStatusCheck(arg0, arg1, arg2, arg3)
	local var0, var1 = var0.ShipStatusConflict(arg0, arg1, arg3)

	if var0 == var0.STATE_CHANGE_FAIL then
		return false, i18n(var1)
	elseif var0 == var0.STATE_CHANGE_CHECK then
		if arg2 then
			return var0.ChangeStatusCheckBox(var1, arg1, arg2)
		else
			return false
		end
	elseif var0 == var0.STATE_CHANGE_TIP then
		return var0.ChangeStatusTipBox(var1, arg1)
	elseif var0 == var0.STATE_CHANGE_OK then
		return true
	else
		assert(false, "unknow error")
	end
end

function var0.ShipStatusConflict(arg0, arg1, arg2)
	local var0 = var1[arg0]

	arg2 = arg2 or {}

	for iter0, iter1 in ipairs(var0.flagList) do
		if var0[iter1] == var0.STATE_CHANGE_FAIL and arg1:getFlag(iter1, arg2[iter1]) then
			return var0.STATE_CHANGE_FAIL, var2[iter1].tips_block
		end
	end

	for iter2, iter3 in ipairs(var0.flagList) do
		if var0[iter3] == var0.STATE_CHANGE_CHECK and arg1:getFlag(iter3, arg2[iter3]) then
			return var0.STATE_CHANGE_CHECK, iter3
		end
	end

	for iter4, iter5 in ipairs(var0.flagList) do
		if var0[iter5] == var0.STATE_CHANGE_TIP and arg1:getFlag(iter5, arg2[iter5]) then
			return var0.STATE_CHANGE_TIP, iter5
		end
	end

	return var0.STATE_CHANGE_OK
end

function var0.ChangeStatusCheckBox(arg0, arg1, arg2)
	if arg0 == "inBackyard" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_vo_moveout_backyard"),
			onYes = function()
				pg.m02:sendNotification(GAME.EXIT_SHIP, {
					callback = arg2,
					shipId = arg1.id
				})
			end
		})

		return false, nil
	elseif arg0 == "inFleet" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("shipchange_alert_infleet"),
			onYes = function()
				local var0 = getProxy(FleetProxy):GetRegularFleetByShip(arg1)

				if var0:canRemove(arg1) then
					var0:removeShip(arg1)
					pg.m02:sendNotification(GAME.UPDATE_FLEET, {
						callback = arg2,
						fleet = var0
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("shipmodechange_reject_1stfleet_only"))
				end
			end
		})

		return false, nil
	elseif arg0 == "inPvP" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("shipchange_alert_inpvp"),
			onYes = function()
				local var0 = getProxy(FleetProxy):getFleetById(FleetProxy.PVP_FLEET_ID)

				if var0:canRemove(arg1) then
					var0:removeShip(arg1)
					pg.m02:sendNotification(GAME.UPDATE_FLEET, {
						callback = arg2,
						fleet = var0
					})
				else
					local var1 = arg1:getTeamType()

					if var1 == TeamType.Vanguard then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_vanguardFleet_must_hasShip"))
					elseif var1 == TeamType.Main then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_vo_mainFleet_must_hasShip"))
					end
				end
			end
		})

		return false, nil
	elseif arg0 == "inExercise" then
		local var0 = getProxy(MilitaryExerciseProxy):getExerciseFleet()

		if var0:canRemove(arg1) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("shipchange_alert_inexercise"),
				onYes = function()
					var0:removeShip(arg1)
					pg.m02:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
						fleet = var0,
						callback = arg2
					})
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function()
					var0:removeShip(arg1)
					pg.m02:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
						fleet = var0,
						callback = arg2
					})
				end
			})
		end

		return false, nil
	elseif arg0 == "inTactics" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tactics_lesson_cancel"),
			onYes = function()
				local var0 = getProxy(NavalAcademyProxy):getStudentIdByShipId(arg1.id)

				pg.m02:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
					callback = arg2,
					shipId = var0,
					type = Student.CANCEL_TYPE_MANUAL
				})
			end
		})

		return false, nil
	elseif arg0 == "inGuildBossEvent" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("word_shipState_guild_boss"),
			onYes = function()
				local var0 = getProxy(GuildProxy):getRawData()

				if not var0 then
					return
				end

				local var1 = var0:GetActiveEvent()

				if not var1 then
					return
				end

				local var2 = var1:GetBossMission()

				if not var2 or not var2:IsActive() then
					return
				end

				local var3 = getProxy(PlayerProxy):getRawData().id
				local var4 = var2:GetFleetUserId(var3, arg1.id)

				if not var4 then
					return
				end

				local var5 = Clone(var4)

				var5:RemoveUserShip(var3, arg1.id)
				pg.m02:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
					force = true,
					editFleet = {
						[var5.id] = var5
					},
					callback = arg2
				})
			end
		})

		return false, nil
	elseif arg0 == "inWorld" then
		local var1 = nowWorld()

		if var1.type == World.TypeBase then
			WorldConst.ReqWorldCheck(arg2)

			return false, nil
		else
			local var2 = var1:GetShip(arg1.id).fleetId

			if #var1:GetFleet(var2)[arg1:getTeamType()] > 1 then
				return true
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("shipmodechange_reject_worldfleet_only"))

				return false, nil
			end
		end
	end

	return true
end

function var0.ChangeStatusTipBox(arg0, arg1)
	if arg0 == "inElite" then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("ship_vo_moveout_hardFormation")
		})
	end

	return true
end

function var0.canDestroyShip(arg0, arg1)
	if arg0:isBluePrintShip() then
		return false, i18n("blueprint_destory_tip")
	elseif arg0:GetLockState() == Ship.LOCK_STATE_LOCK then
		return false, i18n("ship_vo_locked")
	elseif arg0:isMetaShip() then
		return false, i18n("meta_destroy_tip")
	end

	return var0.ShipStatusCheck("onDestroy", arg0, arg1)
end

return var0

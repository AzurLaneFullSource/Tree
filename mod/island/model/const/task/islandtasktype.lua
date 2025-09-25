local var0_0 = class("IslandTaskType")

var0_0.MAIN = 1
var0_0.BRANCH = 2
var0_0.DAILY = 3
var0_0.WEEKLY = 4
var0_0.ACTIVITY_BRANCH = 5
var0_0.ACTIVITY_DAILY = 6
var0_0.ACTIVITY_WEEKLY = 7
var0_0.SEASON = 8
var0_0.HIDE = 9

function var0_0.GetPermanentTypes()
	return {
		var0_0.MAIN,
		var0_0.BRANCH,
		var0_0.ACTIVITY_BRANCH,
		var0_0.SEASON,
		var0_0.HIDE
	}
end

var0_0.SHOW_ALL = 0
var0_0.SHOW_MAIN = 1
var0_0.SHOW_BRANCH = 2
var0_0.SHOW_DAILY = 3
var0_0.SHOW_WEEKLY = 4
var0_0.SHOW_ACTIVITY = 5
var0_0.Type2ShowType = {
	[var0_0.MAIN] = var0_0.SHOW_MAIN,
	[var0_0.BRANCH] = var0_0.SHOW_BRANCH,
	[var0_0.DAILY] = var0_0.SHOW_DAILY,
	[var0_0.WEEKLY] = var0_0.SHOW_WEEKLY,
	[var0_0.ACTIVITY_BRANCH] = var0_0.SHOW_ACTIVITY,
	[var0_0.ACTIVITY_DAILY] = var0_0.SHOW_ACTIVITY,
	[var0_0.ACTIVITY_WEEKLY] = var0_0.SHOW_ACTIVITY,
	[var0_0.SEASON] = nil,
	[var0_0.HIDE] = var0_0.SHOW_MAIN
}
var0_0.ShowTypeFields = {
	[var0_0.SHOW_MAIN] = "main",
	[var0_0.SHOW_BRANCH] = "branch",
	[var0_0.SHOW_DAILY] = "daily",
	[var0_0.SHOW_WEEKLY] = "weekly",
	[var0_0.SHOW_ACTIVITY] = "activity"
}
var0_0.ShowTypeUnlockId = {
	[var0_0.SHOW_MAIN] = 0,
	[var0_0.SHOW_BRANCH] = 42,
	[var0_0.SHOW_DAILY] = 43,
	[var0_0.SHOW_WEEKLY] = 44,
	[var0_0.SHOW_ACTIVITY] = 45
}
var0_0.ShowTypeNames = {
	[var0_0.SHOW_ALL] = i18n("island_task_type_1"),
	[var0_0.SHOW_MAIN] = i18n("island_task_type_2"),
	[var0_0.SHOW_BRANCH] = i18n("island_task_type_3"),
	[var0_0.SHOW_DAILY] = i18n("island_task_type_4"),
	[var0_0.SHOW_WEEKLY] = i18n("island_task_type_5"),
	[var0_0.SHOW_ACTIVITY] = i18n("island_task_type_6")
}
var0_0.ShowTypeColors = {
	[var0_0.SHOW_MAIN] = "#36bdff",
	[var0_0.SHOW_BRANCH] = "#f775ff",
	[var0_0.SHOW_DAILY] = "#a891ff",
	[var0_0.SHOW_WEEKLY] = "#46cd92",
	[var0_0.SHOW_ACTIVITY] = "#ffc561"
}
var0_0.EXCLUED_TRACK_TYPES = {
	var0_0.SEASON,
	var0_0.HIDE
}

function var0_0.GetTrackPriority(arg0_2)
	return switch(arg0_2, {
		[var0_0.MAIN] = function()
			return 1
		end,
		[var0_0.ACTIVITY_BRANCH] = function()
			return 2
		end,
		[var0_0.BRANCH] = function()
			return 3
		end,
		[var0_0.ACTIVITY_DAILY] = function()
			return 4
		end,
		[var0_0.DAILY] = function()
			return 5
		end,
		[var0_0.ACTIVITY_WEEKLY] = function()
			return 6
		end,
		[var0_0.WEEKLY] = function()
			return 7
		end
	}, function()
		return 999
	end)
end

function var0_0.GetHudPriority(arg0_11)
	return switch(type, {
		[var0_0.SHOW_MAIN] = function()
			return 1
		end,
		[var0_0.SHOW_BRANCH] = function()
			return 2
		end,
		[var0_0.SHOW_ACTIVITY] = function()
			return 3
		end,
		[var0_0.SHOW_DAILY] = function()
			return 4
		end,
		[var0_0.SHOW_WEEKLY] = function()
			return 5
		end
	}, function()
		return 999
	end)
end

return var0_0

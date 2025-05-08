local var0_0 = class("IslandTaskType")

var0_0.MAIN = 1
var0_0.BRANCH = 2
var0_0.DAILY = 3
var0_0.WEEKLY = 4
var0_0.ACTIVITY_BRANCH = 5
var0_0.ACTIVITY_DAILY = 6
var0_0.ACTIVITY_WEEKLY = 7
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
	[var0_0.ACTIVITY_WEEKLY] = var0_0.SHOW_ACTIVITY
}
var0_0.ShowTypeFields = {
	[var0_0.SHOW_MAIN] = "main",
	[var0_0.SHOW_BRANCH] = "branch",
	[var0_0.SHOW_DAILY] = "daily",
	[var0_0.SHOW_WEEKLY] = "weekly",
	[var0_0.SHOW_ACTIVITY] = "activity"
}
var0_0.ShowTypeNames = {
	[var0_0.SHOW_ALL] = i18n1("全部"),
	[var0_0.SHOW_MAIN] = i18n1("主线"),
	[var0_0.SHOW_BRANCH] = i18n1("支线"),
	[var0_0.SHOW_DAILY] = i18n1("每日"),
	[var0_0.SHOW_WEEKLY] = i18n1("每周"),
	[var0_0.SHOW_ACTIVITY] = i18n1("活动")
}
var0_0.ShowTypeColors = {
	[var0_0.SHOW_MAIN] = "#36bdff",
	[var0_0.SHOW_BRANCH] = "#f775ff",
	[var0_0.SHOW_DAILY] = "#a891ff",
	[var0_0.SHOW_WEEKLY] = "#46cd92",
	[var0_0.SHOW_ACTIVITY] = "#ffc561"
}

function var0_0.GetPermanentTypes()
	return {
		var0_0.MAIN,
		var0_0.BRANCH,
		var0_0.ACTIVITY_BRANCH
	}
end

return var0_0

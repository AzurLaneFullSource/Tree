local var0 = singletonClass("WorldGuider", import("....Mod.Experiment.BaseEntity"))

var0.Fields = {
	tempGridPos = "table",
	tStamina = "number"
}

function var0.Init(arg0)
	arg0.tempGridPos = {}
end

function var0.SetTempGridPos(arg0, arg1, arg2)
	arg2 = arg2 or 1

	local var0 = pg.NewGuideMgr.GetInstance()._tf:InverseTransformPoint(arg1)

	arg0.tempGridPos[arg2] = var0
end

function var0.SetTempGridPos2(arg0, arg1, arg2)
	local var0 = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera)):WorldToScreenPoint(arg1)
	local var1 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)):ScreenToWorldPoint(var0)

	arg0:SetTempGridPos(var1, arg2)
end

function var0.GetTempGridPos(arg0, arg1)
	arg1 = arg1 or 1

	return arg0.tempGridPos[arg1]
end

function var0.CheckPlayChooseCamp(arg0)
	local var0 = nowWorld():GetRealm()

	if var0 == nil or var0 < 1 then
		arg0:PlayGuide("WorldG001")
	end
end

function var0.CheckIntruduce(arg0)
	local var0 = nowWorld():GetRealm()

	if var0 and var0 > 0 then
		if var0 == 1 then
			arg0:PlayGuide("WorldG002_1")
		elseif var0 == 2 then
			arg0:PlayGuide("WorldG002_2")
		end
	end
end

function var0.CheckUseStaminaItem(arg0)
	local var0 = {
		251,
		252,
		253
	}
	local var1 = nowWorld():GetInventoryProxy()
	local var2 = 0

	for iter0, iter1 in ipairs(var0) do
		var2 = var2 + var1:GetItemCount(iter1)
	end

	if var2 > 0 then
		arg0:PlayGuide("WorldG020")
	end
end

function var0.CheckMapLimit(arg0)
	pg.NewGuideMgr.GetInstance():Play("WorldG012")
end

function var0.SpecialCheck(arg0, arg1)
	if arg1 == "WorldG008" then
		local var0 = nowWorld():GetActiveMap()

		if var0 ~= nil and var0.findex == 2 then
			return "WorldG008_2"
		end
	end

	return arg1
end

var0.interruptReplayList = {
	"WorldG007",
	"WorldG021",
	"WorldG100",
	"WorldG121",
	"WorldG141",
	"WorldG151"
}

function var0.PlayGuide(arg0, arg1, arg2, arg3)
	local var0 = pg.NewGuideMgr.GetInstance()

	if not GUIDE_WROLD or not arg2 and pg.NewStoryMgr.GetInstance():IsPlayed(arg1) or not var0:CanPlay() then
		existCall(arg3)

		return false
	end

	if not _.any(var0.interruptReplayList, function(arg0)
		return arg1 == arg0
	end) then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1
		})
	end

	var0:Play(arg1, nil, function()
		return existCall(arg3)
	end)

	return true
end

var0.WORLD_HIDE_UI = "world hide ui"
var0.WORLD_OPEN_MAP_OVERVIEW = "world open map overview"
var0.WORLD_SHOW_MARGIN = "world show margin"
var0.WORLD_SCANNER_DISPLAY = "world scanner display"
var0.WORLD_GET_COMPASS_POS = "world get compass pos"
var0.WORLD_GET_COMPASS_MAP_POS = "world get compass map pos"
var0.WORLD_GET_SLG_TILE_POS = "world get slg tile pos"
var0.WORLD_GET_SCANNER_POS = "world get scanner pos"
var0.WORLD_OPEN_TRANSPORT_POS = "world open transport pos"
var0.WORLD_SELECT_MODEL_MAP = "world select model map"
var0.WORLD_FOCUS_EDGE = "world focus edge"
var0.WORLD_FOCUS_EVENT = "world focus event"
var0.WORLD_SCANNER_EVENT = "world scanner event"
var0.WORLD_HELP_EVENT = "world help event"
var0.WORLD_RECALL = "world recall"

local var1 = {
	[var0.WORLD_HIDE_UI] = function(arg0, arg1, arg2)
		if arg1.type == 1 then
			arg2:HideMapRightCompass()
		elseif arg1.type == 2 then
			arg2:HideMapRightMemo()
		elseif arg1.type == 3 then
			-- block empty
		elseif arg1.type == 4 then
			arg2:HideOverall()
		end
	end,
	[var0.WORLD_GET_COMPASS_POS] = function(arg0, arg1, arg2)
		arg2:GetCompassGridPos(arg1.row, arg1.column, arg1.cachedIndex)
	end,
	[var0.WORLD_GET_COMPASS_MAP_POS] = function(arg0, arg1, arg2)
		arg2:GetEntranceTrackMark(arg1.mapId, arg1.cachedIndex)
	end,
	[var0.WORLD_GET_SLG_TILE_POS] = function(arg0, arg1, arg2)
		arg2:GetSlgTilePos(arg1.row, arg1.column, arg1.cachedIndex)
	end,
	[var0.WORLD_GET_SCANNER_POS] = function(arg0, arg1, arg2)
		arg2:GetScannerPos(arg1 and arg1.cachedIndex or 1)
	end,
	[var0.WORLD_OPEN_MAP_OVERVIEW] = function(arg0, arg1, arg2)
		arg2:Op("OpShowMarkOverview", {
			ids = arg1.mapIds
		})
	end,
	[var0.WORLD_SHOW_MARGIN] = function(arg0, arg1, arg2)
		arg2:ShowMargin(arg1.tdType)
	end,
	[var0.WORLD_SCANNER_DISPLAY] = function(arg0, arg1, arg2)
		if arg1.open == 1 then
			arg2:OnLongPressMap(arg1.row, arg1.column)
		else
			arg2:HideScannerPanel()
		end
	end,
	[var0.WORLD_OPEN_TRANSPORT_POS] = function(arg0, arg1, arg2)
		arg2:EnterTransportWorld()
	end,
	[var0.WORLD_SELECT_MODEL_MAP] = function(arg0, arg1, arg2)
		arg2:GuideSelectModelMap(arg1.mapId)
	end,
	[var0.WORLD_FOCUS_EDGE] = function(arg0, arg1, arg2)
		arg2:Op("OpMoveCameraTarget", arg1.line, arg1.stayTime)
	end,
	[var0.WORLD_FOCUS_EVENT] = function(arg0, arg1, arg2)
		arg2:Op("OpMoveCamera", arg1.eventId, arg1.stayTime)
	end,
	[var0.WORLD_SCANNER_EVENT] = function(arg0, arg1, arg2)
		arg2:GuideShowScannerEvent(arg1.eventId)
	end,
	[var0.WORLD_HELP_EVENT] = function(arg0, arg1, arg2)
		arg2:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = arg1.titleId,
				pageId = arg1.pageId
			}
		}))
	end,
	[var0.WORLD_RECALL] = function(arg0, arg1, arg2)
		arg2:Op("OpInteractive")
	end
}

function var0.GetWorldGuiderNotifies(arg0)
	return underscore.keys(var1)
end

function var0.WorldGuiderNotifyHandler(arg0, arg1, arg2, arg3)
	switch(arg1, var1, nil, arg1, arg2, arg3)
end

return var0

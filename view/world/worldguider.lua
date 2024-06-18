local var0_0 = singletonClass("WorldGuider", import("....Mod.Experiment.BaseEntity"))

var0_0.Fields = {
	tempGridPos = "table",
	tStamina = "number"
}

function var0_0.Init(arg0_1)
	arg0_1.tempGridPos = {}
end

function var0_0.SetTempGridPos(arg0_2, arg1_2, arg2_2)
	arg2_2 = arg2_2 or 1

	local var0_2 = pg.NewGuideMgr.GetInstance()._tf:InverseTransformPoint(arg1_2)

	arg0_2.tempGridPos[arg2_2] = var0_2
end

function var0_0.SetTempGridPos2(arg0_3, arg1_3, arg2_3)
	local var0_3 = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera)):WorldToScreenPoint(arg1_3)
	local var1_3 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)):ScreenToWorldPoint(var0_3)

	arg0_3:SetTempGridPos(var1_3, arg2_3)
end

function var0_0.GetTempGridPos(arg0_4, arg1_4)
	arg1_4 = arg1_4 or 1

	return arg0_4.tempGridPos[arg1_4]
end

function var0_0.CheckPlayChooseCamp(arg0_5)
	local var0_5 = nowWorld():GetRealm()

	if var0_5 == nil or var0_5 < 1 then
		arg0_5:PlayGuide("WorldG001")
	end
end

function var0_0.CheckIntruduce(arg0_6)
	local var0_6 = nowWorld():GetRealm()

	if var0_6 and var0_6 > 0 then
		if var0_6 == 1 then
			arg0_6:PlayGuide("WorldG002_1")
		elseif var0_6 == 2 then
			arg0_6:PlayGuide("WorldG002_2")
		end
	end
end

function var0_0.CheckUseStaminaItem(arg0_7)
	local var0_7 = {
		251,
		252,
		253
	}
	local var1_7 = nowWorld():GetInventoryProxy()
	local var2_7 = 0

	for iter0_7, iter1_7 in ipairs(var0_7) do
		var2_7 = var2_7 + var1_7:GetItemCount(iter1_7)
	end

	if var2_7 > 0 then
		arg0_7:PlayGuide("WorldG020")
	end
end

function var0_0.CheckMapLimit(arg0_8)
	pg.NewGuideMgr.GetInstance():Play("WorldG012")
end

function var0_0.SpecialCheck(arg0_9, arg1_9)
	if arg1_9 == "WorldG008" then
		local var0_9 = nowWorld():GetActiveMap()

		if var0_9 ~= nil and var0_9.findex == 2 then
			return "WorldG008_2"
		end
	end

	return arg1_9
end

var0_0.interruptReplayList = {
	"WorldG007",
	"WorldG021",
	"WorldG100",
	"WorldG121",
	"WorldG141",
	"WorldG151"
}

function var0_0.PlayGuide(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = pg.NewGuideMgr.GetInstance()

	if not GUIDE_WROLD or not arg2_10 and pg.NewStoryMgr.GetInstance():IsPlayed(arg1_10) or not var0_10:CanPlay() then
		existCall(arg3_10)

		return false
	end

	if not _.any(var0_0.interruptReplayList, function(arg0_11)
		return arg1_10 == arg0_11
	end) then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg1_10
		})
	end

	var0_10:Play(arg1_10, nil, function()
		return existCall(arg3_10)
	end)

	return true
end

var0_0.WORLD_HIDE_UI = "world hide ui"
var0_0.WORLD_OPEN_MAP_OVERVIEW = "world open map overview"
var0_0.WORLD_SHOW_MARGIN = "world show margin"
var0_0.WORLD_SCANNER_DISPLAY = "world scanner display"
var0_0.WORLD_GET_COMPASS_POS = "world get compass pos"
var0_0.WORLD_GET_COMPASS_MAP_POS = "world get compass map pos"
var0_0.WORLD_GET_SLG_TILE_POS = "world get slg tile pos"
var0_0.WORLD_GET_SCANNER_POS = "world get scanner pos"
var0_0.WORLD_OPEN_TRANSPORT_POS = "world open transport pos"
var0_0.WORLD_SELECT_MODEL_MAP = "world select model map"
var0_0.WORLD_FOCUS_EDGE = "world focus edge"
var0_0.WORLD_FOCUS_EVENT = "world focus event"
var0_0.WORLD_SCANNER_EVENT = "world scanner event"
var0_0.WORLD_HELP_EVENT = "world help event"
var0_0.WORLD_RECALL = "world recall"

local var1_0 = {
	[var0_0.WORLD_HIDE_UI] = function(arg0_13, arg1_13, arg2_13)
		if arg1_13.type == 1 then
			arg2_13:HideMapRightCompass()
		elseif arg1_13.type == 2 then
			arg2_13:HideMapRightMemo()
		elseif arg1_13.type == 3 then
			-- block empty
		elseif arg1_13.type == 4 then
			arg2_13:HideOverall()
		end
	end,
	[var0_0.WORLD_GET_COMPASS_POS] = function(arg0_14, arg1_14, arg2_14)
		arg2_14:GetCompassGridPos(arg1_14.row, arg1_14.column, arg1_14.cachedIndex)
	end,
	[var0_0.WORLD_GET_COMPASS_MAP_POS] = function(arg0_15, arg1_15, arg2_15)
		arg2_15:GetEntranceTrackMark(arg1_15.mapId, arg1_15.cachedIndex)
	end,
	[var0_0.WORLD_GET_SLG_TILE_POS] = function(arg0_16, arg1_16, arg2_16)
		arg2_16:GetSlgTilePos(arg1_16.row, arg1_16.column, arg1_16.cachedIndex)
	end,
	[var0_0.WORLD_GET_SCANNER_POS] = function(arg0_17, arg1_17, arg2_17)
		arg2_17:GetScannerPos(arg1_17 and arg1_17.cachedIndex or 1)
	end,
	[var0_0.WORLD_OPEN_MAP_OVERVIEW] = function(arg0_18, arg1_18, arg2_18)
		arg2_18:Op("OpShowMarkOverview", {
			ids = arg1_18.mapIds
		})
	end,
	[var0_0.WORLD_SHOW_MARGIN] = function(arg0_19, arg1_19, arg2_19)
		arg2_19:ShowMargin(arg1_19.tdType)
	end,
	[var0_0.WORLD_SCANNER_DISPLAY] = function(arg0_20, arg1_20, arg2_20)
		if arg1_20.open == 1 then
			arg2_20:OnLongPressMap(arg1_20.row, arg1_20.column)
		else
			arg2_20:HideScannerPanel()
		end
	end,
	[var0_0.WORLD_OPEN_TRANSPORT_POS] = function(arg0_21, arg1_21, arg2_21)
		arg2_21:EnterTransportWorld()
	end,
	[var0_0.WORLD_SELECT_MODEL_MAP] = function(arg0_22, arg1_22, arg2_22)
		arg2_22:GuideSelectModelMap(arg1_22.mapId)
	end,
	[var0_0.WORLD_FOCUS_EDGE] = function(arg0_23, arg1_23, arg2_23)
		arg2_23:Op("OpMoveCameraTarget", arg1_23.line, arg1_23.stayTime)
	end,
	[var0_0.WORLD_FOCUS_EVENT] = function(arg0_24, arg1_24, arg2_24)
		arg2_24:Op("OpMoveCamera", arg1_24.eventId, arg1_24.stayTime)
	end,
	[var0_0.WORLD_SCANNER_EVENT] = function(arg0_25, arg1_25, arg2_25)
		arg2_25:GuideShowScannerEvent(arg1_25.eventId)
	end,
	[var0_0.WORLD_HELP_EVENT] = function(arg0_26, arg1_26, arg2_26)
		arg2_26:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = arg1_26.titleId,
				pageId = arg1_26.pageId
			}
		}))
	end,
	[var0_0.WORLD_RECALL] = function(arg0_27, arg1_27, arg2_27)
		arg2_27:Op("OpInteractive")
	end
}

function var0_0.GetWorldGuiderNotifies(arg0_28)
	return underscore.keys(var1_0)
end

function var0_0.WorldGuiderNotifyHandler(arg0_29, arg1_29, arg2_29, arg3_29)
	switch(arg1_29, var1_0, nil, arg1_29, arg2_29, arg3_29)
end

return var0_0

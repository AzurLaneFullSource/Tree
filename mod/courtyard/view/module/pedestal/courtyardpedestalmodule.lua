local var0 = class("CourtYardPedestalModule", import("..CourtYardBaseModule"))

function var0.OnInit(arg0)
	arg0.storey = arg0.data
	arg0.scrollView = arg0._tf.parent:Find("scroll_view")
	arg0.wallPaper = CourtYardPedestalWallPaper.New(arg0)
	arg0.floorPaper = CourtYardPedestalFloorPaper.New(arg0)
	arg0.road = CourtYardPedestalRoad.New(arg0)
	arg0.wallBase = CourtYardPedestalWallBase.New(arg0)
	arg0.msgBox = CourtYardExtendTipPage.New(arg0)
end

function var0.AddListeners(arg0)
	arg0:AddListener(CourtYardEvent.UPDATE_STOREY, arg0.OnUpdate)
	arg0:AddListener(CourtYardEvent.UPDATE_WALLPAPER, arg0.OnWallPaperUpdate)
	arg0:AddListener(CourtYardEvent.UPDATE_FLOORPAPER, arg0.OnFloorPaperUpdate)
end

function var0.RemoveListeners(arg0)
	arg0:RemoveListener(CourtYardEvent.UPDATE_STOREY, arg0.OnUpdate)
	arg0:RemoveListener(CourtYardEvent.UPDATE_WALLPAPER, arg0.OnWallPaperUpdate)
	arg0:RemoveListener(CourtYardEvent.UPDATE_FLOORPAPER, arg0.OnFloorPaperUpdate)
end

function var0.OnWallPaperUpdate(arg0, arg1)
	arg0.wallPaper:Update(arg1, arg0.level)
end

function var0.OnFloorPaperUpdate(arg0, arg1)
	arg0.floorPaper:Update(arg1, arg0.level)
end

function var0.OnUpdate(arg0, arg1)
	arg0.level = arg1

	arg0.road:Update(arg1)
	arg0.wallBase:Update(arg1)
	arg0:InitScrollRect(arg1)
end

function var0.InitScrollRect(arg0, arg1)
	local var0 = 1080 + (arg1 - 1) * 150

	arg0._tf.sizeDelta = Vector2(arg0._tf.sizeDelta.x, var0)

	scrollTo(arg0.scrollView, 0.508, 0.655)
end

function var0.OnDispose(arg0)
	arg0.msgBox:Destroy()

	arg0.msgBox = nil

	arg0.wallPaper:Dispose()

	arg0.wallPaper = nil

	arg0.floorPaper:Dispose()

	arg0.floorPaper = nil

	arg0.road:Dispose()

	arg0.road = nil

	arg0.wallBase:Dispose()

	arg0.wallBase = nil
end

return var0

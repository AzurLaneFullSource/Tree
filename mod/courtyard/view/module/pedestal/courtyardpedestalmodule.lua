local var0_0 = class("CourtYardPedestalModule", import("..CourtYardBaseModule"))

function var0_0.OnInit(arg0_1)
	arg0_1.storey = arg0_1.data
	arg0_1.scrollView = arg0_1._tf.parent:Find("scroll_view")
	arg0_1.wallPaper = CourtYardPedestalWallPaper.New(arg0_1)
	arg0_1.floorPaper = CourtYardPedestalFloorPaper.New(arg0_1)
	arg0_1.road = CourtYardPedestalRoad.New(arg0_1)
	arg0_1.wallBase = CourtYardPedestalWallBase.New(arg0_1)
	arg0_1.msgBox = CourtYardExtendTipPage.New(arg0_1)
end

function var0_0.AddListeners(arg0_2)
	arg0_2:AddListener(CourtYardEvent.UPDATE_STOREY, arg0_2.OnUpdate)
	arg0_2:AddListener(CourtYardEvent.UPDATE_WALLPAPER, arg0_2.OnWallPaperUpdate)
	arg0_2:AddListener(CourtYardEvent.UPDATE_FLOORPAPER, arg0_2.OnFloorPaperUpdate)
end

function var0_0.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(CourtYardEvent.UPDATE_STOREY, arg0_3.OnUpdate)
	arg0_3:RemoveListener(CourtYardEvent.UPDATE_WALLPAPER, arg0_3.OnWallPaperUpdate)
	arg0_3:RemoveListener(CourtYardEvent.UPDATE_FLOORPAPER, arg0_3.OnFloorPaperUpdate)
end

function var0_0.OnWallPaperUpdate(arg0_4, arg1_4)
	arg0_4.wallPaper:Update(arg1_4, arg0_4.level)
end

function var0_0.OnFloorPaperUpdate(arg0_5, arg1_5)
	arg0_5.floorPaper:Update(arg1_5, arg0_5.level)
end

function var0_0.OnUpdate(arg0_6, arg1_6)
	arg0_6.level = arg1_6

	arg0_6.road:Update(arg1_6)
	arg0_6.wallBase:Update(arg1_6)
	arg0_6:InitScrollRect(arg1_6)
end

function var0_0.InitScrollRect(arg0_7, arg1_7)
	local var0_7 = 1080 + (arg1_7 - 1) * 150

	arg0_7._tf.sizeDelta = Vector2(arg0_7._tf.sizeDelta.x, var0_7)

	scrollTo(arg0_7.scrollView, 0.508, 0.655)
end

function var0_0.OnDispose(arg0_8)
	arg0_8.msgBox:Destroy()

	arg0_8.msgBox = nil

	arg0_8.wallPaper:Dispose()

	arg0_8.wallPaper = nil

	arg0_8.floorPaper:Dispose()

	arg0_8.floorPaper = nil

	arg0_8.road:Dispose()

	arg0_8.road = nil

	arg0_8.wallBase:Dispose()

	arg0_8.wallBase = nil
end

return var0_0

local var0_0 = class("IslandDevicePage", import("...base.IslandBasePage"))

var0_0.SPECIAL_BTN = {
	order = "IslandDeviceOrderBtn",
	ship_order = "IslandDeviceShipOrderBtn"
}

function var0_0.getUIName(arg0_1)
	return "IslandDeviceUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.exitBtn = arg0_2._tf:Find("panel/exit")
	arg0_2.timeTxt = arg0_2._tf:Find("panel/top/time"):GetComponent(typeof(Text))
	arg0_2.electricTF = arg0_2._tf:Find("panel/top/battery/electric")
	arg0_2.bannerTF = arg0_2._tf:Find("panel/banner")
	arg0_2.bannerEmptyTF = arg0_2._tf:Find("panel/banner_empty")
	arg0_2.scrollSnap = IslandBannerScrollRect.New(arg0_2.bannerTF:Find("mask/content"), arg0_2.bannerTF:Find("dots"))
	arg0_2.btnContainer = arg0_2._tf:Find("panel/btn_container")
	arg0_2.systemTimeUtil = LocalSystemTimeUtil.New()
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("close"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.exitBtn, function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	setActive(arg0_3.exitBtn, not ISLAND_PLAYER_TESTING)
	arg0_3:InitBtns()
	arg0_3:InitBanner()
end

function var0_0.InitBtns(arg0_6)
	arg0_6.btns = {}

	local var0_6 = pg.island_main_btns.get_id_list_by_main_type[2]
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		var1_6[pg.island_main_btns[iter1_6].btn_name] = iter1_6
	end

	eachChild(arg0_6.btnContainer, function(arg0_7)
		local var0_7 = arg0_7.name
		local var1_7 = var1_6[var0_7]

		if var1_7 then
			if var0_0.SPECIAL_BTN[var0_7] then
				local var2_7 = var0_0.SPECIAL_BTN[var0_7]

				arg0_6.btns[var0_7] = _G[var2_7].New(arg0_7, arg0_6.event, var1_7)
			else
				arg0_6.btns[var0_7] = IslandDeviceBaseBtn.New(arg0_7, arg0_6.event, var1_7)
			end
		end
	end)
end

function var0_0.InitBanner(arg0_8)
	local var0_8 = arg0_8:GetBannerDisplays()

	arg0_8.banners = var0_8

	for iter0_8 = 0, #var0_8 - 1 do
		local var1_8 = var0_8[iter0_8 + 1]
		local var2_8 = arg0_8.scrollSnap:AddChild()

		LoadImageSpriteAsync("island/islandbanner/" .. var1_8.pic, var2_8)
		onButton(arg0_8, var2_8, function()
			arg0_8:BannerSkip(var1_8)
		end, SFX_MAIN)
	end

	arg0_8.scrollSnap:SetUp()
end

function var0_0.OnShow(arg0_10)
	arg0_10:AddTimer()
	arg0_10:Flush()
	arg0_10:FlushBattery()
	arg0_10:FlushTime()
	arg0_10:emitCore(ISLAND_EVT.DEVIEE_STATE_CHANGE, true)

	if IslandCameraMgr.instance then
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)
	end
end

function var0_0.Flush(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.btns) do
		iter1_11:Flush()
	end

	local var0_11 = arg0_11:GetBannerDisplays()
	local var1_11 = #var0_11 ~= 0

	setActive(arg0_11.bannerEmptyTF, not var1_11)
	setActive(arg0_11.bannerTF, var1_11)

	if var1_11 then
		if #arg0_11.banners ~= #var0_11 then
			arg0_11.scrollSnap:Reset()
			arg0_11:InitBanner()
		else
			arg0_11.scrollSnap:Resume()
		end
	end
end

function var0_0.FlushBattery(arg0_12)
	local var0_12 = SystemInfo.batteryLevel

	if var0_12 < 0 then
		var0_12 = 1
	end

	setFillAmount(arg0_12.electricTF, var0_12)
end

function var0_0.FlushTime(arg0_13)
	arg0_13.systemTimeUtil:SetUp(function(arg0_14, arg1_14, arg2_14)
		arg0_13.timeTxt.text = arg0_14 .. ":" .. arg1_14
	end)
end

function var0_0.AddTimer(arg0_15)
	arg0_15:RemoveTimer()

	arg0_15.timer = Timer.New(function()
		arg0_15:FlushBattery()
		arg0_15:FlushTime()
	end, 60, -1)

	arg0_15.timer:Start()
end

function var0_0.RemoveTimer(arg0_17)
	if arg0_17.timer then
		arg0_17.timer:Stop()

		arg0_17.timer = nil
	end
end

function var0_0.OnHide(arg0_18)
	arg0_18:RemoveTimer()
	arg0_18:emitCore(ISLAND_EVT.DEVIEE_STATE_CHANGE, false)

	if IslandCameraMgr.instance then
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	end
end

function var0_0.OnEnable(arg0_19)
	arg0_19:OnShow()
end

function var0_0.OnDisable(arg0_20)
	arg0_20:OnHide()
end

function var0_0.OnDestroy(arg0_21)
	arg0_21:OnHide()
	arg0_21:RemoveTimer()
	arg0_21.systemTimeUtil:Dispose()

	arg0_21.systemTimeUtil = nil

	arg0_21.scrollSnap:Dispose()

	arg0_21.scrollSnap = nil

	for iter0_21, iter1_21 in pairs(arg0_21.btns) do
		iter1_21:Dispose()
	end

	arg0_21.btns = nil
end

function var0_0.GetBannerDisplays(arg0_22)
	return underscore(pg.island_banner.all):chain():map(function(arg0_23)
		return pg.island_banner[arg0_23]
	end):select(function(arg0_24)
		return pg.TimeMgr.GetInstance():inTime(arg0_24.time)
	end):value()
end

function var0_0.BannerSkip(arg0_25, arg1_25)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandDeviceBanner(arg1_25.id))

	if arg1_25.type == IslandConst.BANNER_TYPE_OPEN_URL then
		Application.OpenURL(arg1_25.param)
	elseif arg1_25.type == IslandConst.BANNER_TYPE_SWITCH_MAP then
		arg0_25:Hide()
		arg0_25:emit(IslandBaseMediator.SWITCH_MAP, unpack(arg1_25.param))
	elseif arg1_25.type == IslandConst.BANNER_TYPE_OPEN_PAGE then
		arg0_25:Hide()
		arg0_25:emit(IslandMediator.OPEN_PAGE, arg1_25.param[1], arg1_25.param[2])
	elseif arg1_25.type == IslandConst.BANNER_TYPE_SURVEY then
		local var0_25, var1_25 = getProxy(ActivityProxy):isSurveyOpen()

		if var0_25 then
			pg.m02:sendNotification(GAME.SURVEY_REQUEST, {
				surveyID = var1_25,
				surveyUrlStr = getSurveyUrl(var1_25)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
		end
	end
end

return var0_0

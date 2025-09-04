local var0_0 = class("IslandDevicePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandDeviceUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.systemTimeUtil = LocalSystemTimeUtil.New()
	arg0_2.exitBtn = arg0_2._tf:Find("panel/exit")
	arg0_2.timeTxt = arg0_2._tf:Find("panel/time"):GetComponent(typeof(Text))
	arg0_2.electricTF = arg0_2._tf:Find("panel/battery/electric")
	arg0_2.btnEmptyTF = arg0_2._tf:Find("panel/content_empty")
	arg0_2.btnContainer = arg0_2._tf:Find("panel/content")
	arg0_2.btnTpl = arg0_2.btnContainer:Find("tpl")

	setActive(arg0_2.btnTpl, false)

	arg0_2.bannerTF = arg0_2._tf:Find("panel/banner")
	arg0_2.bannerEmptyTF = arg0_2._tf:Find("panel/banner_empty")
	arg0_2.scrollSnap = BannerScrollRect4Mellow.New(arg0_2.bannerTF:Find("mask/content"), arg0_2.bannerTF:Find("dots"))
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("close"), function()
		arg0_3.dftAniEvent:SetEndEvent(function()
			arg0_3.dftAniEvent:SetEndEvent(nil)
			arg0_3:Hide()
		end)
		arg0_3.animationPlayer:Play("IslandDeviceUI_out")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.exitBtn, function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	setActive(arg0_3.exitBtn, not ISLAND_PLAYER_TESTING)
	arg0_3:InitBtns()
	arg0_3:InitBanner()
end

function var0_0.InitBtns(arg0_7)
	arg0_7.btns = {}

	local var0_7 = pg.island_main_btns.get_id_list_by_main_type[2]

	table.sort(var0_7, CompareFuncs({
		function(arg0_8)
			return pg.island_main_btns[arg0_8].order
		end,
		function(arg0_9)
			return arg0_9
		end
	}))

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var1_7 = pg.island_main_btns[iter1_7].btn_name

		arg0_7.btns[var1_7] = IslandDeviceBaseBtn.New(cloneTplTo(arg0_7.btnTpl, arg0_7.btnContainer), arg0_7.event, iter1_7)
	end
end

function var0_0.InitBanner(arg0_10)
	local var0_10 = arg0_10:GetBannerDisplays()

	arg0_10.banners = var0_10

	for iter0_10 = 0, #var0_10 - 1 do
		local var1_10 = var0_10[iter0_10 + 1]
		local var2_10 = arg0_10.scrollSnap:AddChild()

		LoadImageSpriteAsync("island/islandbanner/" .. var1_10.pic, var2_10)
		onButton(arg0_10, var2_10, function()
			arg0_10:BannerSkip(var1_10)
		end, SFX_MAIN)
	end

	arg0_10.scrollSnap:SetUp()
end

function var0_0.OnShow(arg0_12)
	arg0_12:AddTimer()
	arg0_12:Flush()
	arg0_12:FlushBattery()
	arg0_12:FlushTime()
	arg0_12:emitCore(ISLAND_EVT.DEVIEE_STATE_CHANGE, true)

	if IslandCameraMgr.instance then
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOCUS_CAMERA_NAME)
	end
end

function var0_0.Flush(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.btns) do
		iter1_13:Flush()
	end

	local var0_13 = arg0_13:GetBannerDisplays()
	local var1_13 = #var0_13 ~= 0

	setActive(arg0_13.bannerEmptyTF, not var1_13)
	setActive(arg0_13.bannerTF, var1_13)

	if var1_13 then
		if #arg0_13.banners ~= #var0_13 then
			arg0_13.scrollSnap:Reset()
			arg0_13:InitBanner()
		else
			arg0_13.scrollSnap:Resume()
		end
	end
end

function var0_0.FlushBattery(arg0_14)
	local var0_14 = SystemInfo.batteryLevel

	if var0_14 < 0 then
		var0_14 = 1
	end

	setFillAmount(arg0_14.electricTF, var0_14)
end

function var0_0.FlushTime(arg0_15)
	arg0_15.systemTimeUtil:SetUp(function(arg0_16, arg1_16, arg2_16)
		arg0_15.timeTxt.text = arg0_16 .. ":" .. arg1_16
	end)
end

function var0_0.AddTimer(arg0_17)
	arg0_17:RemoveTimer()

	arg0_17.timer = Timer.New(function()
		arg0_17:FlushBattery()
		arg0_17:FlushTime()
	end, 60, -1)

	arg0_17.timer:Start()
end

function var0_0.RemoveTimer(arg0_19)
	if arg0_19.timer then
		arg0_19.timer:Stop()

		arg0_19.timer = nil
	end
end

function var0_0.OnHide(arg0_20)
	arg0_20:RemoveTimer()
	arg0_20:emitCore(ISLAND_EVT.DEVIEE_STATE_CHANGE, false)

	if IslandCameraMgr.instance then
		IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
	end
end

function var0_0.OnDisable(arg0_21)
	arg0_21:OnHide()
end

function var0_0.OnDestroy(arg0_22)
	arg0_22.systemTimeUtil:Dispose()

	arg0_22.systemTimeUtil = nil

	arg0_22.scrollSnap:Dispose()

	arg0_22.scrollSnap = nil

	for iter0_22, iter1_22 in pairs(arg0_22.btns) do
		iter1_22:Dispose()
	end

	arg0_22.btns = nil
end

function var0_0.GetBannerDisplays(arg0_23)
	return underscore(pg.island_banner.all):chain():map(function(arg0_24)
		return pg.island_banner[arg0_24]
	end):select(function(arg0_25)
		return pg.TimeMgr.GetInstance():inTime(arg0_25.time)
	end):value()
end

function var0_0.BannerSkip(arg0_26, arg1_26)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandDeviceBanner(arg1_26.id))

	if arg1_26.type == IslandConst.BANNER_TYPE_OPEN_URL then
		Application.OpenURL(arg1_26.param)
	elseif arg1_26.type == IslandConst.BANNER_TYPE_SWITCH_MAP then
		arg0_26.dftAniEvent:SetEndEvent(function()
			arg0_26.dftAniEvent:SetEndEvent(nil)
			arg0_26:Hide()
			arg0_26:emit(IslandBaseMediator.SWITCH_MAP, unpack(arg1_26.param))
		end)
		arg0_26.animationPlayer:Play("IslandDeviceUI_out")
	elseif arg1_26.type == IslandConst.BANNER_TYPE_OPEN_PAGE then
		arg0_26:Hide()
		arg0_26:emit(IslandMediator.OPEN_PAGE, arg1_26.param[1], arg1_26.param[2])
	elseif arg1_26.type == IslandConst.BANNER_TYPE_SURVEY then
		local var0_26, var1_26 = getProxy(ActivityProxy):isSurveyOpen()

		if var0_26 then
			pg.m02:sendNotification(GAME.SURVEY_REQUEST, {
				surveyID = var1_26,
				surveyUrlStr = getSurveyUrl(var1_26)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))
		end
	end
end

return var0_0

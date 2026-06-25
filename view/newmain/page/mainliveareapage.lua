local var0_0 = class("MainLiveAreaPage", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1:bind(NewMainScene.UPDATE_COVER, function(arg0_2)
		arg0_1:ExecuteAction("UpdateCover")
	end)
end

function var0_0.getUIName(arg0_3)
	return "MainLiveAreaUI"
end

function var0_0.OnLoaded(arg0_4)
	arg0_4._bg = arg0_4._tf:Find("bg")

	setText(arg0_4._bg:Find("day/Text"), i18n("word_harbour"))
	setText(arg0_4._bg:Find("night/Text"), i18n("word_harbour"))

	arg0_4.timeCfg = pg.gameset.main_live_area_time.description
	arg0_4._coverBtn = arg0_4._tf:Find("cover_btn")
	arg0_4._academyBtn = arg0_4._tf:Find("school_btn")
	arg0_4._haremBtn = arg0_4._tf:Find("backyard_btn")
	arg0_4._commanderBtn = arg0_4._tf:Find("commander_btn")
	arg0_4._educateBtn = arg0_4._tf:Find("educate_btn")
	arg0_4._islandBtn = arg0_4._tf:Find("island_btn")
	arg0_4.islandAwardTF = arg0_4._islandBtn:Find("banners/award")

	setText(arg0_4.islandAwardTF:Find("Text"), i18n("island_post_acceptable"))

	arg0_4.islandEmptyTF = arg0_4._islandBtn:Find("banners/empty")

	setText(arg0_4.islandEmptyTF:Find("Text"), i18n("island_post_vacant"))

	arg0_4._dormBtn = arg0_4._tf:Find("dorm_btn")
	arg0_4._islandBtnEffect = arg0_4._islandBtn:Find("VX")
	arg0_4.coverPage = LivingAreaCoverPage.New(arg0_4._tf, arg0_4.event, {
		onHide = function()
			arg0_4:UpdateCoverTip()
		end,
		onSelected = function(arg0_6)
			arg0_4:UpdateCoverTemp(arg0_6)
		end
	})

	local var0_4 = pg.EasyRedDotMgr.GetInstance()

	arg0_4.redDotUIList = {
		arg0_4._haremBtn:Find("tip"),
		arg0_4._academyBtn:Find("tip"),
		arg0_4._commanderBtn:Find("tip")
	}

	var0_4:RegisterRedDot(arg0_4.redDotUIList[1], {
		"COURTYARD"
	}, function(arg0_7)
		setActive(arg0_7, getProxy(DormProxy):IsShowRedDot())
	end)
	var0_4:RegisterRedDot(arg0_4.redDotUIList[2], {
		"SCHOOL"
	}, function(arg0_8)
		setActive(arg0_8, getProxy(NavalAcademyProxy):IsShowTip())
	end)
	var0_4:RegisterRedDot(arg0_4.redDotUIList[3], {
		"COMMANDER"
	}, function(arg0_9)
		if getProxy(PlayerProxy):getRawData().level < 40 then
			setActive(arg0_9, false)

			return
		end

		local var0_9 = getProxy(CommanderProxy):IsFinishAllBox()

		if not LOCK_CATTERY then
			setActive(arg0_9, var0_9 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse())
		else
			setActive(arg0_9, var0_9)
		end
	end)
end

function var0_0.OnInit(arg0_10)
	arg0_10.mediator = MainLiveAreaPageMediator.New()

	onButton(arg0_10, arg0_10._coverBtn, function()
		arg0_10.coverPage:ExecuteAction("Show")
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._commanderBtn, function()
		arg0_10.mediator:GoScene(SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_10:Hide()
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._haremBtn, function()
		arg0_10.mediator:GoScene(SCENE.COURTYARD)
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._academyBtn, function()
		arg0_10.mediator:GoScene(SCENE.NAVALACADEMYSCENE)
		arg0_10:Hide()
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._educateBtn, function()
		if LOCK_EDUCATE_SYSTEM then
			return
		end

		if LOCK_NEW_EDUCATE_SYSTEM then
			arg0_10.mediator:GoScene(SCENE.EDUCATE, {
				isMainEnter = true
			})
		else
			arg0_10.mediator:GoScene(SCENE.NEW_EDUCATE_SELECT)
		end

		arg0_10:Hide()
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._islandBtn, function()
		if LOCK_ISLAND_DISPLAY then
			return
		end

		local var0_16 = {}
		local var1_16 = "MAP"

		if Application.isEditor or GroupHelper.IsGroupVerLastest(var1_16) or not GroupHelper.IsGroupWaitToUpdate(var1_16) then
			-- block empty
		else
			local var2_16 = GroupHelper.GetGroupSize(var1_16)
			local var3_16 = HashUtil.BytesToString(var2_16)

			if var2_16 > 0 then
				table.insert(var0_16, function(arg0_17)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						locked = true,
						type = MSGBOX_TYPE_FILE_DOWNLOAD,
						content = string.format(i18n("group_download_tip", var3_16)),
						onYes = arg0_17
					})
				end)
			end

			table.insert(var0_16, function(arg0_18)
				local var0_18 = {}
				local var1_18 = GroupHelper.GetGroupMgrByName(var1_16)

				if var1_18.toUpdate then
					local var2_18 = var1_18.toUpdate.Count

					for iter0_18 = 0, var2_18 - 1 do
						local var3_18 = var1_18.toUpdate[iter0_18][0]

						table.insert(var0_18, var3_18)
					end
				end

				local var4_18 = {
					groupName = var1_16,
					fileNameList = var0_18
				}
				local var5_18 = {
					dataList = {
						var4_18
					},
					onFinish = arg0_18
				}

				pg.FileDownloadMgr.GetInstance():Main(var5_18)
			end)
		end

		local var4_16 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true)

		if not LOCK_ISLAND_ENTER_TIP_WINDOW and PlayerPrefs.GetString("ISLAND_ENTER_TIP_WINDOW", "") ~= var4_16 then
			table.insert(var0_16, function(arg0_19)
				local function var0_19()
					if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
						PlayerPrefs.SetString("ISLAND_ENTER_TIP_WINDOW", var4_16)
					end

					arg0_19()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					toggleStatus = true,
					showStopRemind = true,
					type = MSGBOX_TYPE_HELP,
					helps = i18n("island_urgent_notice"),
					onYes = var0_19,
					onNo = var0_19
				})
			end)
		end

		seriesAsync(var0_16, function()
			arg0_10.mediator:GoIsland(getProxy(PlayerProxy):getRawData().id)
			arg0_10:Hide()
		end)
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._dormBtn, function()
		arg0_10.mediator:OpenDormSelectLayer()
		arg0_10:Hide()
	end, SFX_MAIN)
	onButton(arg0_10, arg0_10._tf, function()
		arg0_10:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_24, arg1_24, arg2_24)
	var0_0.super.Show(arg0_24)
	pg.UIMgr.GetInstance():BlurPanel(arg0_24._tf, {
		staticBlur = true
	})

	local var0_24 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_24.level, "CommanderCatMediator") then
		arg0_24._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_24._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_24.level, "CourtYardMediator") then
		arg0_24._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_24._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	local var1_24 = LOCK_NEW_EDUCATE_SYSTEM and "EducateMediator" or "NewEducateSelectMediator"

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_24.level, var1_24) then
		arg0_24._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_24._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	setActive(arg0_24._educateBtn:Find("tip"), NewEducateHelper.IsShowNewChildTip())

	local var2_24 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_24.level, "SelectDorm3DMediator")

	if not var2_24 then
		arg0_24._dormBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_24._dormBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	;(function()
		local var0_25 = var2_24 and Dorm3dShopUI.ShouldShowAllTip()
		local var1_25 = var2_24 and Dorm3dFurniture.IsTimelimitShopTip()

		setActive(arg0_24._dormBtn:Find("tip"), var0_25 or getProxy(ApartmentProxy):HasGiftExpireSoon())
		setActive(arg0_24._dormBtn:Find("tagFurniture"), var1_25)
	end)()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_24.level, "IslandMediator") then
		arg0_24._islandBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_24._islandBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0_24:UpdataIslandTip()
	arg0_24:UpdateCover()
	arg0_24:UpdateCoverTip()
	arg0_24:UpdateTime()

	arg0_24.timer = Timer.New(function()
		arg0_24:UpdateTime()
	end, 60, -1)

	arg0_24.timer:Start()
	setActive(arg0_24._islandBtnEffect, tobool(arg1_24))

	if arg2_24 then
		arg2_24()
	end
end

function var0_0.UpdateTime(arg0_27)
	local var0_27 = pg.TimeMgr.GetInstance()
	local var1_27 = var0_27:GetServerHour()
	local var2_27 = var1_27 < 12

	setActive(arg0_27._bg:Find("AM"), var2_27)
	setActive(arg0_27._bg:Find("PM"), not var2_27)

	local var3_27 = arg0_27:getCoverType(var1_27)

	setActive(arg0_27._bg:Find("day"), var3_27 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_27._bg:Find("night"), var3_27 == LivingAreaCover.TYPE_NIGHT)
	setActive(arg0_27._islandBtn:Find("lock/day"), var3_27 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_27._islandBtn:Find("lock/night"), var3_27 ~= LivingAreaCover.TYPE_DAY)

	local var4_27 = var0_27:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_27._bg:Find("date"), var4_27)

	local var5_27 = var0_27:CurrentSTimeDesc(":%M", true)

	if var1_27 > 12 then
		var1_27 = var1_27 - 12
	end

	setText(arg0_27._bg:Find("time"), var1_27 .. var5_27)

	local var6_27 = EducateHelper.GetWeekStrByNumber(var0_27:GetServerWeek())

	setText(arg0_27._bg:Find("date/week"), var6_27)
end

function var0_0.getCoverType(arg0_28, arg1_28)
	for iter0_28, iter1_28 in ipairs(arg0_28.timeCfg) do
		local var0_28 = iter1_28[1]

		if arg1_28 >= var0_28[1] and arg1_28 < var0_28[2] then
			return iter1_28[2]
		end
	end

	return LivingAreaCover.TYPE_DAY
end

function var0_0.UpdateCover(arg0_29)
	local var0_29 = getProxy(LivingAreaCoverProxy):GetCurCover()

	if arg0_29.cover and arg0_29.cover.id == var0_29.id then
		return
	end

	arg0_29.cover = var0_29

	arg0_29:_loadBg()
end

function var0_0.UpdateCoverTemp(arg0_30, arg1_30)
	if arg0_30.cover and arg0_30.cover.id == arg1_30.id then
		return
	end

	arg0_30.cover = arg1_30

	arg0_30:_loadBg()
end

function var0_0._loadBg(arg0_31)
	setImageSprite(arg0_31._bg:Find("day"), GetSpriteFromAtlas(arg0_31.cover:GetBg(LivingAreaCover.TYPE_DAY), ""), true)
	setImageSprite(arg0_31._bg:Find("night"), GetSpriteFromAtlas(arg0_31.cover:GetBg(LivingAreaCover.TYPE_NIGHT), ""), true)
end

function var0_0.UpdateCoverTip(arg0_32)
	setActive(arg0_32._coverBtn:Find("tip"), getProxy(LivingAreaCoverProxy):IsTip())
end

function var0_0.UpdataIslandTip(arg0_33)
	setActive(arg0_33._islandBtn:Find("banners"), not LOCK_ISLAND_DISPLAY)

	if LOCK_ISLAND_DISPLAY then
		return
	end

	local var0_33, var1_33 = getProxy(SystemTipProxy):GetIslandTipInfos()

	setActive(arg0_33.islandAwardTF, var0_33 > 0)
	setActive(arg0_33.islandEmptyTF, var1_33 > 0)
end

function var0_0.Hide(arg0_34)
	if arg0_34.coverPage and arg0_34.coverPage:GetLoaded() and arg0_34.coverPage:isShowing() then
		arg0_34.coverPage:Hide()

		return
	end

	if arg0_34:isShowing() then
		var0_0.super.Hide(arg0_34)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_34._tf, arg0_34._parentTf)
	end

	if arg0_34.timer ~= nil then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end
end

function var0_0.OnDestroy(arg0_35)
	local var0_35 = pg.EasyRedDotMgr.GetInstance()

	for iter0_35, iter1_35 in ipairs(arg0_35.redDotUIList) do
		var0_35:UnRegisterRedDot(iter1_35)
	end

	arg0_35.redDotUIList = nil

	arg0_35.mediator:Dispose()

	arg0_35.mediator = nil

	arg0_35:Hide()
	arg0_35.coverPage:Destroy()

	arg0_35.coverPage = nil
	arg0_35.cover = nil
end

return var0_0

local var0_0 = class("MainLiveAreaPage", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1:bind(NewMainScene.UPDATE_COVER, function(arg0_2)
		arg0_1:ExecuteAction("UpdateCover")
	end)
end

function var0_0.getResource(arg0_3)
	local var0_3 = {}
	local var1_3 = getProxy(LivingAreaCoverProxy):GetCurCover()

	table.insert(var0_3, var1_3:GetBg(LivingAreaCover.TYPE_DAY))
	table.insert(var0_3, var1_3:GetBg(LivingAreaCover.TYPE_NIGHT))

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3))
end

function var0_0.getUIName(arg0_4)
	return "MainLiveAreaUI"
end

function var0_0.OnLoaded(arg0_5)
	arg0_5._bg = arg0_5._tf:Find("bg")

	setText(arg0_5._bg:Find("day/Text"), i18n("word_harbour"))
	setText(arg0_5._bg:Find("night/Text"), i18n("word_harbour"))

	arg0_5.timeCfg = pg.gameset.main_live_area_time.description
	arg0_5._coverBtn = arg0_5._tf:Find("cover_btn")
	arg0_5._academyBtn = arg0_5._tf:Find("school_btn")
	arg0_5._haremBtn = arg0_5._tf:Find("backyard_btn")
	arg0_5._commanderBtn = arg0_5._tf:Find("commander_btn")
	arg0_5._educateBtn = arg0_5._tf:Find("educate_btn")
	arg0_5._islandBtn = arg0_5._tf:Find("island_btn")
	arg0_5.islandAwardTF = arg0_5._islandBtn:Find("banners/award")

	setText(arg0_5.islandAwardTF:Find("Text"), i18n("island_post_acceptable"))

	arg0_5.islandEmptyTF = arg0_5._islandBtn:Find("banners/empty")

	setText(arg0_5.islandEmptyTF:Find("Text"), i18n("island_post_vacant"))

	arg0_5._dormBtn = arg0_5._tf:Find("dorm_btn")
	arg0_5._islandBtnEffect = arg0_5._islandBtn:Find("VX")
	arg0_5.coverPage = LivingAreaCoverPage.New(arg0_5._tf, arg0_5.event, {
		onHide = function()
			arg0_5:UpdateCoverTip()
		end,
		onSelected = function(arg0_7)
			arg0_5:UpdateCoverTemp(arg0_7)
		end
	})

	local var0_5 = pg.EasyRedDotMgr.GetInstance()

	arg0_5.redDotUIList = {
		arg0_5._haremBtn:Find("tip"),
		arg0_5._academyBtn:Find("tip"),
		arg0_5._commanderBtn:Find("tip")
	}

	var0_5:RegisterRedDot(arg0_5.redDotUIList[1], {
		"COURTYARD"
	}, function(arg0_8)
		setActive(arg0_8, getProxy(DormProxy):IsShowRedDot())
	end)
	var0_5:RegisterRedDot(arg0_5.redDotUIList[2], {
		"SCHOOL"
	}, function(arg0_9)
		setActive(arg0_9, getProxy(NavalAcademyProxy):IsShowTip())
	end)
	var0_5:RegisterRedDot(arg0_5.redDotUIList[3], {
		"COMMANDER"
	}, function(arg0_10)
		if getProxy(PlayerProxy):getRawData().level < 40 then
			setActive(arg0_10, false)

			return
		end

		local var0_10 = getProxy(CommanderProxy):IsFinishAllBox()

		if not LOCK_CATTERY then
			setActive(arg0_10, var0_10 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse())
		else
			setActive(arg0_10, var0_10)
		end
	end)
end

function var0_0.OnInit(arg0_11)
	arg0_11.mediator = MainLiveAreaPageMediator.New()

	onButton(arg0_11, arg0_11._coverBtn, function()
		arg0_11.coverPage:ExecuteAction("Show")
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._commanderBtn, function()
		arg0_11.mediator:GoScene(SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_11:Hide()
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._haremBtn, function()
		arg0_11.mediator:GoScene(SCENE.COURTYARD)
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._academyBtn, function()
		arg0_11.mediator:GoScene(SCENE.NAVALACADEMYSCENE)
		arg0_11:Hide()
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._educateBtn, function()
		if LOCK_EDUCATE_SYSTEM then
			return
		end

		if LOCK_NEW_EDUCATE_SYSTEM then
			arg0_11.mediator:GoScene(SCENE.EDUCATE, {
				isMainEnter = true
			})
		else
			arg0_11.mediator:GoScene(SCENE.NEW_EDUCATE_SELECT)
		end

		arg0_11:Hide()
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._islandBtn, function()
		if LOCK_ISLAND_DISPLAY then
			return
		end

		local var0_17 = {}
		local var1_17 = "MAP"

		if Application.isEditor or GroupHelper.IsGroupVerLastest(var1_17) or not GroupHelper.IsGroupWaitToUpdate(var1_17) then
			-- block empty
		else
			local var2_17 = GroupHelper.GetGroupSize(var1_17)
			local var3_17 = HashUtil.BytesToString(var2_17)

			if var2_17 > 0 then
				table.insert(var0_17, function(arg0_18)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						locked = true,
						type = MSGBOX_TYPE_FILE_DOWNLOAD,
						content = string.format(i18n("group_download_tip", var3_17)),
						onYes = arg0_18
					})
				end)
			end

			table.insert(var0_17, function(arg0_19)
				local var0_19 = {}
				local var1_19 = GroupHelper.GetGroupMgrByName(var1_17)

				if var1_19.toUpdate then
					local var2_19 = var1_19.toUpdate.Count

					for iter0_19 = 0, var2_19 - 1 do
						local var3_19 = var1_19.toUpdate[iter0_19][0]

						table.insert(var0_19, var3_19)
					end
				end

				local var4_19 = {
					groupName = var1_17,
					fileNameList = var0_19
				}
				local var5_19 = {
					dataList = {
						var4_19
					},
					onFinish = arg0_19
				}

				pg.FileDownloadMgr.GetInstance():Main(var5_19)
			end)
		end

		local var4_17 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true)

		if not LOCK_ISLAND_ENTER_TIP_WINDOW and PlayerPrefs.GetString("ISLAND_ENTER_TIP_WINDOW", "") ~= var4_17 then
			table.insert(var0_17, function(arg0_20)
				local function var0_20()
					if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
						PlayerPrefs.SetString("ISLAND_ENTER_TIP_WINDOW", var4_17)
					end

					arg0_20()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					toggleStatus = true,
					showStopRemind = true,
					type = MSGBOX_TYPE_HELP,
					helps = i18n("island_urgent_notice"),
					onYes = var0_20,
					onNo = var0_20
				})
			end)
		end

		seriesAsync(var0_17, function()
			arg0_11.mediator:GoIsland(getProxy(PlayerProxy):getRawData().id)
			arg0_11:Hide()
		end)
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._dormBtn, function()
		arg0_11.mediator:OpenDormSelectLayer()
		arg0_11:Hide()
	end, SFX_MAIN)
	onButton(arg0_11, arg0_11._tf, function()
		arg0_11:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_25, arg1_25, arg2_25)
	var0_0.super.Show(arg0_25)
	pg.UIMgr.GetInstance():BlurPanel(arg0_25._tf, {
		staticBlur = true
	})

	local var0_25 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_25.level, "CommanderCatMediator") then
		arg0_25._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_25._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_25.level, "CourtYardMediator") then
		arg0_25._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_25._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	local var1_25 = LOCK_NEW_EDUCATE_SYSTEM and "EducateMediator" or "NewEducateSelectMediator"

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_25.level, var1_25) then
		arg0_25._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_25._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	setActive(arg0_25._educateBtn:Find("tip"), NewEducateHelper.IsShowNewChildTip())

	local var2_25 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_25.level, "SelectDorm3DMediator")

	if not var2_25 then
		arg0_25._dormBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_25._dormBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	;(function()
		local var0_26 = var2_25 and Dorm3dShopUI.ShouldShowAllTip()
		local var1_26 = var2_25 and Dorm3dFurniture.IsTimelimitShopTip()

		setActive(arg0_25._dormBtn:Find("tip"), var0_26 or getProxy(ApartmentProxy):HasGiftExpireSoon())
		setActive(arg0_25._dormBtn:Find("tagFurniture"), var1_26)
	end)()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_25.level, "IslandMediator") then
		arg0_25._islandBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_25._islandBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0_25:UpdataIslandTip()
	arg0_25:UpdateCover()
	arg0_25:UpdateCoverTip()
	arg0_25:UpdateTime()

	arg0_25.timer = Timer.New(function()
		arg0_25:UpdateTime()
	end, 60, -1)

	arg0_25.timer:Start()
	setActive(arg0_25._islandBtnEffect, tobool(arg1_25))

	if arg2_25 then
		arg2_25()
	end
end

function var0_0.UpdateTime(arg0_28)
	local var0_28 = pg.TimeMgr.GetInstance()
	local var1_28 = var0_28:GetServerHour()
	local var2_28 = var1_28 < 12

	setActive(arg0_28._bg:Find("AM"), var2_28)
	setActive(arg0_28._bg:Find("PM"), not var2_28)

	local var3_28 = arg0_28:getCoverType(var1_28)

	setActive(arg0_28._bg:Find("day"), var3_28 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_28._bg:Find("night"), var3_28 == LivingAreaCover.TYPE_NIGHT)
	setActive(arg0_28._islandBtn:Find("lock/day"), var3_28 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_28._islandBtn:Find("lock/night"), var3_28 ~= LivingAreaCover.TYPE_DAY)

	local var4_28 = var0_28:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_28._bg:Find("date"), var4_28)

	local var5_28 = var0_28:CurrentSTimeDesc(":%M", true)

	if var1_28 > 12 then
		var1_28 = var1_28 - 12
	end

	setText(arg0_28._bg:Find("time"), var1_28 .. var5_28)

	local var6_28 = EducateHelper.GetWeekStrByNumber(var0_28:GetServerWeek())

	setText(arg0_28._bg:Find("date/week"), var6_28)
end

function var0_0.getCoverType(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.timeCfg) do
		local var0_29 = iter1_29[1]

		if arg1_29 >= var0_29[1] and arg1_29 < var0_29[2] then
			return iter1_29[2]
		end
	end

	return LivingAreaCover.TYPE_DAY
end

function var0_0.UpdateCover(arg0_30)
	local var0_30 = getProxy(LivingAreaCoverProxy):GetCurCover()

	if arg0_30.cover and arg0_30.cover.id == var0_30.id then
		return
	end

	arg0_30.cover = var0_30

	arg0_30:_loadBg()
end

function var0_0.UpdateCoverTemp(arg0_31, arg1_31)
	if arg0_31.cover and arg0_31.cover.id == arg1_31.id then
		return
	end

	arg0_31.cover = arg1_31

	arg0_31:_loadBg()
end

function var0_0._loadBg(arg0_32)
	setImageSprite(arg0_32._bg:Find("day"), GetSpriteFromAtlas(arg0_32.cover:GetBg(LivingAreaCover.TYPE_DAY), ""), true)
	setImageSprite(arg0_32._bg:Find("night"), GetSpriteFromAtlas(arg0_32.cover:GetBg(LivingAreaCover.TYPE_NIGHT), ""), true)
end

function var0_0.UpdateCoverTip(arg0_33)
	setActive(arg0_33._coverBtn:Find("tip"), getProxy(LivingAreaCoverProxy):IsTip())
end

function var0_0.UpdataIslandTip(arg0_34)
	setActive(arg0_34._islandBtn:Find("banners"), not LOCK_ISLAND_DISPLAY)

	if LOCK_ISLAND_DISPLAY then
		return
	end

	local var0_34, var1_34 = getProxy(SystemTipProxy):GetIslandTipInfos()

	setActive(arg0_34.islandAwardTF, var0_34 > 0)
	setActive(arg0_34.islandEmptyTF, var1_34 > 0)
end

function var0_0.Hide(arg0_35)
	if arg0_35.coverPage and arg0_35.coverPage:GetLoaded() and arg0_35.coverPage:isShowing() then
		arg0_35.coverPage:Hide()

		return
	end

	if arg0_35:isShowing() then
		var0_0.super.Hide(arg0_35)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_35._tf, arg0_35._parentTf)
	end

	if arg0_35.timer ~= nil then
		arg0_35.timer:Stop()

		arg0_35.timer = nil
	end
end

function var0_0.OnDestroy(arg0_36)
	local var0_36 = pg.EasyRedDotMgr.GetInstance()

	for iter0_36, iter1_36 in ipairs(arg0_36.redDotUIList) do
		var0_36:UnRegisterRedDot(iter1_36)
	end

	arg0_36.redDotUIList = nil

	arg0_36.mediator:Dispose()

	arg0_36.mediator = nil

	arg0_36:Hide()
	arg0_36.coverPage:Destroy()

	arg0_36.coverPage = nil
	arg0_36.cover = nil
end

return var0_0

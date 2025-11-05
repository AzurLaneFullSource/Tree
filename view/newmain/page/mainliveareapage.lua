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
	arg0_4.redList = {
		RedDotNode.New(arg0_4._haremBtn:Find("tip"), {
			pg.RedDotMgr.TYPES.COURTYARD
		}),
		SelfRefreshRedDotNode.New(arg0_4._academyBtn:Find("tip"), {
			pg.RedDotMgr.TYPES.SCHOOL
		}),
		SelfRefreshRedDotNode.New(arg0_4._commanderBtn:Find("tip"), {
			pg.RedDotMgr.TYPES.COMMANDER
		})
	}

	for iter0_4, iter1_4 in ipairs(arg0_4.redList) do
		pg.redDotHelper:AddNode(iter1_4)
	end
end

function var0_0.OnInit(arg0_7)
	arg0_7.mediator = MainLiveAreaPageMediator.New()

	onButton(arg0_7, arg0_7._coverBtn, function()
		arg0_7.coverPage:ExecuteAction("Show")
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._commanderBtn, function()
		arg0_7.mediator:GoScene(SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._haremBtn, function()
		arg0_7.mediator:GoScene(SCENE.COURTYARD)
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._academyBtn, function()
		arg0_7.mediator:GoScene(SCENE.NAVALACADEMYSCENE)
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._educateBtn, function()
		if LOCK_EDUCATE_SYSTEM then
			return
		end

		if LOCK_NEW_EDUCATE_SYSTEM then
			arg0_7.mediator:GoScene(SCENE.EDUCATE, {
				isMainEnter = true
			})
		else
			arg0_7.mediator:GoScene(SCENE.NEW_EDUCATE_SELECT)
		end

		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._islandBtn, function()
		if LOCK_ISLAND_DISPLAY then
			return
		end

		local var0_13 = {}
		local var1_13 = "MAP"

		if Application.isEditor or GroupHelper.IsGroupVerLastest(var1_13) or not GroupHelper.IsGroupWaitToUpdate(var1_13) then
			-- block empty
		else
			local var2_13 = GroupHelper.GetGroupSize(var1_13)
			local var3_13 = HashUtil.BytesToString(var2_13)

			if var2_13 > 0 then
				table.insert(var0_13, function(arg0_14)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						locked = true,
						type = MSGBOX_TYPE_FILE_DOWNLOAD,
						content = string.format(i18n("group_download_tip", var3_13)),
						onYes = arg0_14
					})
				end)
			end

			table.insert(var0_13, function(arg0_15)
				local var0_15 = {}
				local var1_15 = GroupHelper.GetGroupMgrByName(var1_13)

				if var1_15.toUpdate then
					local var2_15 = var1_15.toUpdate.Count

					for iter0_15 = 0, var2_15 - 1 do
						local var3_15 = var1_15.toUpdate[iter0_15][0]

						table.insert(var0_15, var3_15)
					end
				end

				local var4_15 = {
					groupName = var1_13,
					fileNameList = var0_15
				}
				local var5_15 = {
					dataList = {
						var4_15
					},
					onFinish = arg0_15
				}

				pg.FileDownloadMgr.GetInstance():Main(var5_15)
			end)
		end

		local var4_13 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true)

		if not LOCK_ISLAND_ENTER_TIP_WINDOW and PlayerPrefs.GetString("ISLAND_ENTER_TIP_WINDOW", "") ~= var4_13 then
			table.insert(var0_13, function(arg0_16)
				local function var0_16()
					if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
						PlayerPrefs.SetString("ISLAND_ENTER_TIP_WINDOW", var4_13)
					end

					arg0_16()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					toggleStatus = true,
					showStopRemind = true,
					type = MSGBOX_TYPE_HELP,
					helps = i18n("island_urgent_notice"),
					onYes = var0_16,
					onNo = var0_16
				})
			end)
		end

		seriesAsync(var0_13, function()
			arg0_7.mediator:GoIsland(getProxy(PlayerProxy):getRawData().id)
			arg0_7:Hide()
		end)
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._dormBtn, function()
		arg0_7.mediator:OpenDormSelectLayer()
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_21, arg1_21, arg2_21)
	var0_0.super.Show(arg0_21)
	pg.UIMgr.GetInstance():BlurPanel(arg0_21._tf, {
		staticBlur = true
	})

	local var0_21 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_21.level, "CommanderCatMediator") then
		arg0_21._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_21._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_21.level, "CourtYardMediator") then
		arg0_21._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_21._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	local var1_21 = LOCK_NEW_EDUCATE_SYSTEM and "EducateMediator" or "NewEducateSelectMediator"

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_21.level, var1_21) then
		arg0_21._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_21._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	setActive(arg0_21._educateBtn:Find("tip"), NewEducateHelper.IsShowNewChildTip())

	local var2_21 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_21.level, "SelectDorm3DMediator")

	if not var2_21 then
		arg0_21._dormBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_21._dormBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	;(function()
		local var0_22 = var2_21 and Dorm3dShopUI.ShouldShowAllTip()
		local var1_22 = var2_21 and Dorm3dFurniture.IsTimelimitShopTip()

		setActive(arg0_21._dormBtn:Find("tip"), var0_22)
		setActive(arg0_21._dormBtn:Find("tagFurniture"), var1_22)
	end)()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_21.level, "IslandMediator") then
		arg0_21._islandBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_21._islandBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0_21:UpdataIslandTip()
	arg0_21:UpdateCover()
	arg0_21:UpdateCoverTip()
	arg0_21:UpdateTime()

	arg0_21.timer = Timer.New(function()
		arg0_21:UpdateTime()
	end, 60, -1)

	arg0_21.timer:Start()
	setActive(arg0_21._islandBtnEffect, tobool(arg1_21))

	if arg2_21 then
		arg2_21()
	end
end

function var0_0.UpdateTime(arg0_24)
	local var0_24 = pg.TimeMgr.GetInstance()
	local var1_24 = var0_24:GetServerHour()
	local var2_24 = var1_24 < 12

	setActive(arg0_24._bg:Find("AM"), var2_24)
	setActive(arg0_24._bg:Find("PM"), not var2_24)

	local var3_24 = arg0_24:getCoverType(var1_24)

	setActive(arg0_24._bg:Find("day"), var3_24 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_24._bg:Find("night"), var3_24 == LivingAreaCover.TYPE_NIGHT)
	setActive(arg0_24._islandBtn:Find("lock/day"), var3_24 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_24._islandBtn:Find("lock/night"), var3_24 ~= LivingAreaCover.TYPE_DAY)

	local var4_24 = var0_24:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_24._bg:Find("date"), var4_24)

	local var5_24 = var0_24:CurrentSTimeDesc(":%M", true)

	if var1_24 > 12 then
		var1_24 = var1_24 - 12
	end

	setText(arg0_24._bg:Find("time"), var1_24 .. var5_24)

	local var6_24 = EducateHelper.GetWeekStrByNumber(var0_24:GetServerWeek())

	setText(arg0_24._bg:Find("date/week"), var6_24)
end

function var0_0.getCoverType(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.timeCfg) do
		local var0_25 = iter1_25[1]

		if arg1_25 >= var0_25[1] and arg1_25 < var0_25[2] then
			return iter1_25[2]
		end
	end

	return LivingAreaCover.TYPE_DAY
end

function var0_0.UpdateCover(arg0_26)
	local var0_26 = getProxy(LivingAreaCoverProxy):GetCurCover()

	if arg0_26.cover and arg0_26.cover.id == var0_26.id then
		return
	end

	arg0_26.cover = var0_26

	arg0_26:_loadBg()
end

function var0_0.UpdateCoverTemp(arg0_27, arg1_27)
	if arg0_27.cover and arg0_27.cover.id == arg1_27.id then
		return
	end

	arg0_27.cover = arg1_27

	arg0_27:_loadBg()
end

function var0_0._loadBg(arg0_28)
	setImageSprite(arg0_28._bg:Find("day"), GetSpriteFromAtlas(arg0_28.cover:GetBg(LivingAreaCover.TYPE_DAY), ""), true)
	setImageSprite(arg0_28._bg:Find("night"), GetSpriteFromAtlas(arg0_28.cover:GetBg(LivingAreaCover.TYPE_NIGHT), ""), true)
end

function var0_0.UpdateCoverTip(arg0_29)
	setActive(arg0_29._coverBtn:Find("tip"), getProxy(LivingAreaCoverProxy):IsTip())
end

function var0_0.UpdataIslandTip(arg0_30)
	setActive(arg0_30._islandBtn:Find("banners"), not LOCK_ISLAND_DISPLAY)

	if LOCK_ISLAND_DISPLAY then
		return
	end

	local var0_30, var1_30 = getProxy(SystemTipProxy):GetIslandTipInfos()

	setActive(arg0_30.islandAwardTF, var0_30 > 0)
	setActive(arg0_30.islandEmptyTF, var1_30 > 0)
end

function var0_0.Hide(arg0_31)
	if arg0_31.coverPage and arg0_31.coverPage:GetLoaded() and arg0_31.coverPage:isShowing() then
		arg0_31.coverPage:Hide()

		return
	end

	if arg0_31:isShowing() then
		var0_0.super.Hide(arg0_31)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_31._tf, arg0_31._parentTf)
	end

	if arg0_31.timer ~= nil then
		arg0_31.timer:Stop()

		arg0_31.timer = nil
	end
end

function var0_0.OnDestroy(arg0_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.redList) do
		pg.redDotHelper:RemoveNode(iter1_32)
	end

	arg0_32.redList = nil

	arg0_32.mediator:Dispose()

	arg0_32.mediator = nil

	arg0_32:Hide()
	arg0_32.coverPage:Destroy()

	arg0_32.coverPage = nil
	arg0_32.cover = nil
end

return var0_0

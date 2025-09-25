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
	arg0_4._bg = arg0_4:findTF("bg")

	setText(arg0_4:findTF("day/Text", arg0_4._bg), i18n("word_harbour"))
	setText(arg0_4:findTF("night/Text", arg0_4._bg), i18n("word_harbour"))

	arg0_4.timeCfg = pg.gameset.main_live_area_time.description
	arg0_4._coverBtn = arg0_4:findTF("cover_btn")
	arg0_4._academyBtn = arg0_4:findTF("school_btn")
	arg0_4._haremBtn = arg0_4:findTF("backyard_btn")
	arg0_4._commanderBtn = arg0_4:findTF("commander_btn")
	arg0_4._educateBtn = arg0_4:findTF("educate_btn")
	arg0_4._islandBtn = arg0_4:findTF("island_btn")
	arg0_4.islandAwardTF = arg0_4._islandBtn:Find("banners/award")

	setText(arg0_4.islandAwardTF:Find("Text"), i18n("island_post_acceptable"))

	arg0_4.islandEmptyTF = arg0_4._islandBtn:Find("banners/empty")

	setText(arg0_4.islandEmptyTF:Find("Text"), i18n("island_post_vacant"))

	arg0_4._dormBtn = arg0_4:findTF("dorm_btn")
	arg0_4._islandBtnEffect = arg0_4:findTF("VX", arg0_4._islandBtn)
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

		local function var0_13()
			arg0_7.mediator:GoIsland(getProxy(PlayerProxy):getRawData().id)
			arg0_7:Hide()
		end

		local var1_13 = "MAP"

		if Application.isEditor or GroupHelper.IsGroupVerLastest(var1_13) or not GroupHelper.IsGroupWaitToUpdate(var1_13) then
			var0_13()

			return
		end

		local var2_13 = {}
		local var3_13 = GroupHelper.GetGroupSize(var1_13)
		local var4_13 = HashUtil.BytesToString(var3_13)

		if var3_13 > 0 then
			table.insert(var2_13, function(arg0_15)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					locked = true,
					type = MSGBOX_TYPE_FILE_DOWNLOAD,
					content = string.format(i18n("group_download_tip", var4_13)),
					onYes = arg0_15
				})
			end)
		end

		table.insert(var2_13, function(arg0_16)
			local var0_16 = {}
			local var1_16 = GroupHelper.GetGroupMgrByName(var1_13)

			if var1_16.toUpdate then
				local var2_16 = var1_16.toUpdate.Count

				for iter0_16 = 0, var2_16 - 1 do
					local var3_16 = var1_16.toUpdate[iter0_16][0]

					table.insert(var0_16, var3_16)
				end
			end

			local var4_16 = {
				groupName = var1_13,
				fileNameList = var0_16
			}
			local var5_16 = {
				dataList = {
					var4_16
				},
				onFinish = arg0_16
			}

			pg.FileDownloadMgr.GetInstance():Main(var5_16)
		end)
		seriesAsync(var2_13, var0_13)
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._dormBtn, function()
		arg0_7.mediator:OpenDormSelectLayer()
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_19, arg1_19, arg2_19)
	var0_0.super.Show(arg0_19)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19._tf, {
		staticBlur = true
	})

	local var0_19 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_19.level, "CommanderCatMediator") then
		arg0_19._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_19._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_19.level, "CourtYardMediator") then
		arg0_19._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_19._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	local var1_19 = LOCK_NEW_EDUCATE_SYSTEM and "EducateMediator" or "NewEducateSelectMediator"

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_19.level, var1_19) then
		arg0_19._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_19._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	setActive(arg0_19._educateBtn:Find("tip"), NewEducateHelper.IsShowNewChildTip())

	local var2_19 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_19.level, "SelectDorm3DMediator")

	if not var2_19 then
		arg0_19._dormBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_19._dormBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	;(function()
		local var0_20 = var2_19 and Dorm3dShopUI.ShouldShowAllTip()
		local var1_20 = var2_19 and Dorm3dFurniture.IsTimelimitShopTip()

		setActive(arg0_19._dormBtn:Find("tip"), var0_20)
		setActive(arg0_19._dormBtn:Find("tagFurniture"), var1_20)
	end)()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_19.level, "IslandMediator") then
		arg0_19._islandBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_19._islandBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0_19:UpdataIslandTip()
	arg0_19:UpdateCover()
	arg0_19:UpdateCoverTip()
	arg0_19:UpdateTime()

	arg0_19.timer = Timer.New(function()
		arg0_19:UpdateTime()
	end, 60, -1)

	arg0_19.timer:Start()
	setActive(arg0_19._islandBtnEffect, tobool(arg1_19))

	if arg2_19 then
		arg2_19()
	end
end

function var0_0.UpdateTime(arg0_22)
	local var0_22 = pg.TimeMgr.GetInstance()
	local var1_22 = var0_22:GetServerHour()
	local var2_22 = var1_22 < 12

	setActive(arg0_22:findTF("AM", arg0_22._bg), var2_22)
	setActive(arg0_22:findTF("PM", arg0_22._bg), not var2_22)

	local var3_22 = arg0_22:getCoverType(var1_22)

	setActive(arg0_22:findTF("day", arg0_22._bg), var3_22 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_22:findTF("night", arg0_22._bg), var3_22 == LivingAreaCover.TYPE_NIGHT)
	setActive(arg0_22:findTF("lock/day", arg0_22._islandBtn), var3_22 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_22:findTF("lock/night", arg0_22._islandBtn), var3_22 ~= LivingAreaCover.TYPE_DAY)

	local var4_22 = var0_22:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_22:findTF("date", arg0_22._bg), var4_22)

	local var5_22 = var0_22:CurrentSTimeDesc(":%M", true)

	if var1_22 > 12 then
		var1_22 = var1_22 - 12
	end

	setText(arg0_22:findTF("time", arg0_22._bg), var1_22 .. var5_22)

	local var6_22 = EducateHelper.GetWeekStrByNumber(var0_22:GetServerWeek())

	setText(arg0_22:findTF("date/week", arg0_22._bg), var6_22)
end

function var0_0.getCoverType(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.timeCfg) do
		local var0_23 = iter1_23[1]

		if arg1_23 >= var0_23[1] and arg1_23 < var0_23[2] then
			return iter1_23[2]
		end
	end

	return LivingAreaCover.TYPE_DAY
end

function var0_0.UpdateCover(arg0_24)
	local var0_24 = getProxy(LivingAreaCoverProxy):GetCurCover()

	if arg0_24.cover and arg0_24.cover.id == var0_24.id then
		return
	end

	arg0_24.cover = var0_24

	arg0_24:_loadBg()
end

function var0_0.UpdateCoverTemp(arg0_25, arg1_25)
	if arg0_25.cover and arg0_25.cover.id == arg1_25.id then
		return
	end

	arg0_25.cover = arg1_25

	arg0_25:_loadBg()
end

function var0_0._loadBg(arg0_26)
	setImageSprite(arg0_26:findTF("day", arg0_26._bg), GetSpriteFromAtlas(arg0_26.cover:GetBg(LivingAreaCover.TYPE_DAY), ""), true)
	setImageSprite(arg0_26:findTF("night", arg0_26._bg), GetSpriteFromAtlas(arg0_26.cover:GetBg(LivingAreaCover.TYPE_NIGHT), ""), true)
end

function var0_0.UpdateCoverTip(arg0_27)
	setActive(arg0_27:findTF("tip", arg0_27._coverBtn), getProxy(LivingAreaCoverProxy):IsTip())
end

function var0_0.UpdataIslandTip(arg0_28)
	setActive(arg0_28._islandBtn:Find("banners"), not LOCK_ISLAND_DISPLAY)

	if LOCK_ISLAND_DISPLAY then
		return
	end

	local var0_28, var1_28 = getProxy(SystemTipProxy):GetIslandTipInfos()

	setActive(arg0_28.islandAwardTF, var0_28 > 0)
	setActive(arg0_28.islandEmptyTF, var1_28 > 0)
end

function var0_0.Hide(arg0_29)
	if arg0_29.coverPage and arg0_29.coverPage:GetLoaded() and arg0_29.coverPage:isShowing() then
		arg0_29.coverPage:Hide()

		return
	end

	if arg0_29:isShowing() then
		var0_0.super.Hide(arg0_29)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_29._tf, arg0_29._parentTf)
	end

	if arg0_29.timer ~= nil then
		arg0_29.timer:Stop()

		arg0_29.timer = nil
	end
end

function var0_0.OnDestroy(arg0_30)
	for iter0_30, iter1_30 in ipairs(arg0_30.redList) do
		pg.redDotHelper:RemoveNode(iter1_30)
	end

	arg0_30.redList = nil

	arg0_30.mediator:Dispose()

	arg0_30.mediator = nil

	arg0_30:Hide()
	arg0_30.coverPage:Destroy()

	arg0_30.coverPage = nil
	arg0_30.cover = nil
end

return var0_0

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
	arg0_4._dormBtn = arg0_4:findTF("dorm_btn")
	arg0_4.coverPage = LivingAreaCoverPage.New(arg0_4._tf, arg0_4.event, {
		onHide = function()
			arg0_4:UpdateCoverTip()
		end,
		onSelected = function(arg0_6)
			arg0_4:UpdateCoverTemp(arg0_6)
		end
	})

	pg.redDotHelper:AddNode(RedDotNode.New(arg0_4._haremBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COURTYARD
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0_4._academyBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.SCHOOL
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0_4._commanderBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COMMANDER
	}))
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7._coverBtn, function()
		arg0_7.coverPage:ExecuteAction("Show")
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._commanderBtn, function()
		arg0_7:emit(NewMainMediator.GO_SCENE, SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._haremBtn, function()
		arg0_7:emit(NewMainMediator.GO_SCENE, SCENE.COURTYARD)
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._academyBtn, function()
		arg0_7:emit(NewMainMediator.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._educateBtn, function()
		if LOCK_EDUCATE_SYSTEM then
			return
		end

		if LOCK_NEW_EDUCATE_SYSTEM then
			arg0_7:emit(NewMainMediator.GO_SCENE, SCENE.EDUCATE, {
				isMainEnter = true
			})
		else
			arg0_7:emit(NewMainMediator.GO_SCENE, SCENE.NEW_EDUCATE_SELECT)
		end

		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._islandBtn, function()
		return
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._dormBtn, function()
		arg0_7:emit(NewMainMediator.OPEN_DORM_SELECT_LAYER)
		arg0_7:Hide()
	end, SFX_MAIN)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_16)
	var0_0.super.Show(arg0_16)
	pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf, true, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0_16 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_16.level, "CommanderCatMediator") then
		arg0_16._commanderBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_16._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_16.level, "CourtYardMediator") then
		arg0_16._haremBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_16._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	local var1_16 = LOCK_NEW_EDUCATE_SYSTEM and "EducateMediator" or "NewEducateSelectMediator"

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_16.level, var1_16) then
		arg0_16._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_16._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	setActive(arg0_16._educateBtn:Find("tip"), NewEducateHelper.IsShowNewChildTip())

	local var2_16 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_16.level, "SelectDorm3DMediator")

	if not var2_16 then
		arg0_16._dormBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_16._dormBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	;(function()
		local var0_17 = var2_16 and Dorm3dGift.NeedViewTip()
		local var1_17 = var2_16 and Dorm3dFurniture.NeedViewTip()
		local var2_17 = var2_16 and Dorm3dFurniture.IsTimelimitShopTip()

		setActive(arg0_16._dormBtn:Find("tip"), not var2_17 and (var0_17 or var1_17))
		setActive(arg0_16._dormBtn:Find("tagFurniture"), var2_17)
	end)()
	arg0_16:UpdateCover()
	arg0_16:UpdateCoverTip()
	arg0_16:UpdateTime()

	arg0_16.timer = Timer.New(function()
		arg0_16:UpdateTime()
	end, 60, -1)

	arg0_16.timer:Start()
end

function var0_0.UpdateTime(arg0_19)
	local var0_19 = pg.TimeMgr.GetInstance()
	local var1_19 = var0_19:GetServerHour()
	local var2_19 = var1_19 < 12

	setActive(arg0_19:findTF("AM", arg0_19._bg), var2_19)
	setActive(arg0_19:findTF("PM", arg0_19._bg), not var2_19)

	local var3_19 = arg0_19:getCoverType(var1_19)

	setActive(arg0_19:findTF("day", arg0_19._bg), var3_19 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_19:findTF("night", arg0_19._bg), var3_19 == LivingAreaCover.TYPE_NIGHT)
	setActive(arg0_19:findTF("day", arg0_19._islandBtn), var3_19 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_19:findTF("night", arg0_19._islandBtn), var3_19 ~= LivingAreaCover.TYPE_DAY)

	local var4_19 = var0_19:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_19:findTF("date", arg0_19._bg), var4_19)

	local var5_19 = var0_19:CurrentSTimeDesc(":%M", true)

	if var1_19 > 12 then
		var1_19 = var1_19 - 12
	end

	setText(arg0_19:findTF("time", arg0_19._bg), var1_19 .. var5_19)

	local var6_19 = EducateHelper.GetWeekStrByNumber(var0_19:GetServerWeek())

	setText(arg0_19:findTF("date/week", arg0_19._bg), var6_19)
end

function var0_0.getCoverType(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.timeCfg) do
		local var0_20 = iter1_20[1]

		if arg1_20 >= var0_20[1] and arg1_20 < var0_20[2] then
			return iter1_20[2]
		end
	end

	return LivingAreaCover.TYPE_DAY
end

function var0_0.UpdateCover(arg0_21)
	local var0_21 = getProxy(LivingAreaCoverProxy):GetCurCover()

	if arg0_21.cover and arg0_21.cover.id == var0_21.id then
		return
	end

	arg0_21.cover = var0_21

	arg0_21:_loadBg()
end

function var0_0.UpdateCoverTemp(arg0_22, arg1_22)
	if arg0_22.cover and arg0_22.cover.id == arg1_22.id then
		return
	end

	arg0_22.cover = arg1_22

	arg0_22:_loadBg()
end

function var0_0._loadBg(arg0_23)
	setImageSprite(arg0_23:findTF("day", arg0_23._bg), GetSpriteFromAtlas(arg0_23.cover:GetBg(LivingAreaCover.TYPE_DAY), ""), true)
	setImageSprite(arg0_23:findTF("night", arg0_23._bg), GetSpriteFromAtlas(arg0_23.cover:GetBg(LivingAreaCover.TYPE_NIGHT), ""), true)
end

function var0_0.UpdateCoverTip(arg0_24)
	setActive(arg0_24:findTF("tip", arg0_24._coverBtn), getProxy(LivingAreaCoverProxy):IsTip())
end

function var0_0.Hide(arg0_25)
	if arg0_25.coverPage and arg0_25.coverPage:GetLoaded() and arg0_25.coverPage:isShowing() then
		arg0_25.coverPage:Hide()

		return
	end

	if arg0_25:isShowing() then
		var0_0.super.Hide(arg0_25)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_25._tf, arg0_25._parentTf)
	end

	if arg0_25.timer ~= nil then
		arg0_25.timer:Stop()

		arg0_25.timer = nil
	end
end

function var0_0.OnDestroy(arg0_26)
	arg0_26.coverPage:Destroy()

	arg0_26.coverPage = nil
	arg0_26.cover = nil

	arg0_26:Hide()
end

return var0_0

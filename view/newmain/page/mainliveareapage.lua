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
	pg.redDotHelper:AddNode(RedDotNode.New(arg0_4._dormBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.DORM3D_GIFT,
		pg.RedDotMgr.TYPES.DORM3D_FURNITURE
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

		arg0_7:emit(NewMainMediator.GO_SCENE, SCENE.EDUCATE, {
			isMainEnter = true
		})
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

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_16.level, "EducateMediator") then
		arg0_16._educateBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_16._educateBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_16.level, "SelectDorm3DMediator") then
		arg0_16._dormBtn:GetComponent(typeof(Image)).color = Color(0.5, 0.5, 0.5, 1)
	else
		arg0_16._dormBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	arg0_16:UpdateCover()
	arg0_16:UpdateCoverTip()
	arg0_16:UpdateTime()

	arg0_16.timer = Timer.New(function()
		arg0_16:UpdateTime()
	end, 60, -1)

	arg0_16.timer:Start()
end

function var0_0.UpdateTime(arg0_18)
	local var0_18 = pg.TimeMgr.GetInstance()
	local var1_18 = var0_18:GetServerHour()
	local var2_18 = var1_18 < 12

	setActive(arg0_18:findTF("AM", arg0_18._bg), var2_18)
	setActive(arg0_18:findTF("PM", arg0_18._bg), not var2_18)

	local var3_18 = arg0_18:getCoverType(var1_18)

	setActive(arg0_18:findTF("day", arg0_18._bg), var3_18 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_18:findTF("night", arg0_18._bg), var3_18 == LivingAreaCover.TYPE_NIGHT)
	setActive(arg0_18:findTF("day", arg0_18._islandBtn), var3_18 == LivingAreaCover.TYPE_DAY)
	setActive(arg0_18:findTF("night", arg0_18._islandBtn), var3_18 ~= LivingAreaCover.TYPE_DAY)

	local var4_18 = var0_18:CurrentSTimeDesc("%Y/%m/%d", true)

	setText(arg0_18:findTF("date", arg0_18._bg), var4_18)

	local var5_18 = var0_18:CurrentSTimeDesc(":%M", true)

	if var1_18 > 12 then
		var1_18 = var1_18 - 12
	end

	setText(arg0_18:findTF("time", arg0_18._bg), var1_18 .. var5_18)

	local var6_18 = EducateHelper.GetWeekStrByNumber(var0_18:GetServerWeek())

	setText(arg0_18:findTF("date/week", arg0_18._bg), var6_18)
end

function var0_0.getCoverType(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.timeCfg) do
		local var0_19 = iter1_19[1]

		if arg1_19 >= var0_19[1] and arg1_19 < var0_19[2] then
			return iter1_19[2]
		end
	end

	return LivingAreaCover.TYPE_DAY
end

function var0_0.UpdateCover(arg0_20)
	local var0_20 = getProxy(LivingAreaCoverProxy):GetCurCover()

	if arg0_20.cover and arg0_20.cover.id == var0_20.id then
		return
	end

	arg0_20.cover = var0_20

	arg0_20:_loadBg()
end

function var0_0.UpdateCoverTemp(arg0_21, arg1_21)
	if arg0_21.cover and arg0_21.cover.id == arg1_21.id then
		return
	end

	arg0_21.cover = arg1_21

	arg0_21:_loadBg()
end

function var0_0._loadBg(arg0_22)
	setImageSprite(arg0_22:findTF("day", arg0_22._bg), GetSpriteFromAtlas(arg0_22.cover:GetBg(LivingAreaCover.TYPE_DAY), ""), true)
	setImageSprite(arg0_22:findTF("night", arg0_22._bg), GetSpriteFromAtlas(arg0_22.cover:GetBg(LivingAreaCover.TYPE_NIGHT), ""), true)
end

function var0_0.UpdateCoverTip(arg0_23)
	setActive(arg0_23:findTF("tip", arg0_23._coverBtn), getProxy(LivingAreaCoverProxy):IsTip())
end

function var0_0.Hide(arg0_24)
	if arg0_24.coverPage and arg0_24.coverPage:GetLoaded() and arg0_24.coverPage:isShowing() then
		arg0_24.coverPage:Hide()

		return
	end

	if arg0_24:isShowing() then
		var0_0.super.Hide(arg0_24)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_24._tf, arg0_24._parentTf)
	end

	if arg0_24.timer ~= nil then
		arg0_24.timer:Stop()

		arg0_24.timer = nil
	end
end

function var0_0.OnDestroy(arg0_25)
	arg0_25.coverPage:Destroy()

	arg0_25.coverPage = nil
	arg0_25.cover = nil

	arg0_25:Hide()
end

return var0_0

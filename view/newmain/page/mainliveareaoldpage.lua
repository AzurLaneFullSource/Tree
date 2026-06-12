local var0_0 = class("MainLiveAreaOldPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MainLiveAreaOldUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._academyBtn = arg0_2._tf:Find("school_btn")
	arg0_2._haremBtn = arg0_2._tf:Find("backyard_btn")
	arg0_2._commanderBtn = arg0_2._tf:Find("commander_btn")

	local var0_2 = pg.EasyRedDotMgr.GetInstance()

	arg0_2._haremTip = arg0_2._haremBtn:Find("tip")
	arg0_2._academyTip = arg0_2._academyBtn:Find("tip")
	arg0_2._commanderTip = arg0_2._commanderBtn:Find("tip")

	var0_2:RegisterRedDot(arg0_2._haremTip, {
		"COURTYARD"
	}, function(arg0_3)
		setActive(arg0_3, getProxy(DormProxy):IsShowRedDot())
	end)
	var0_2:RegisterRedDot(arg0_2._academyTip, {
		"SCHOOL"
	}, function(arg0_4)
		setActive(arg0_4, getProxy(NavalAcademyProxy):IsShowTip())
	end)
	var0_2:RegisterRedDot(arg0_2._commanderTip, {
		"COMMANDER"
	}, function(arg0_5)
		if getProxy(PlayerProxy):getRawData().level < 40 then
			setActive(arg0_5, false)

			return
		end

		local var0_5 = getProxy(CommanderProxy):IsFinishAllBox()

		if not LOCK_CATTERY then
			setActive(arg0_5, var0_5 or getProxy(CommanderProxy):AnyCatteryExistOP() or getProxy(CommanderProxy):AnyCatteryCanUse())
		else
			setActive(arg0_5, var0_5)
		end
	end)
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6._commanderBtn, function()
		arg0_6:emit(NewMainMediator.GO_SCENE, SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_6:Hide()
	end, SFX_MAIN)
	onButton(arg0_6, arg0_6._haremBtn, function()
		arg0_6:emit(NewMainMediator.GO_SCENE, SCENE.COURTYARD)
		arg0_6:Hide()
	end, SFX_MAIN)
	onButton(arg0_6, arg0_6._academyBtn, function()
		arg0_6:emit(NewMainMediator.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		arg0_6:Hide()
	end, SFX_MAIN)
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_11)
	var0_0.super.Show(arg0_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, {
		staticBlur = true
	})

	local var0_11 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_11.level, "CommanderCatMediator") then
		arg0_11._commanderBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		arg0_11._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_11.level, "CourtYardMediator") then
		arg0_11._haremBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		arg0_11._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end
end

function var0_0.Hide(arg0_12)
	if arg0_12:isShowing() then
		var0_0.super.Hide(arg0_12)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf, arg0_12._parentTf)
	end
end

function var0_0.OnDestroy(arg0_13)
	local var0_13 = pg.EasyRedDotMgr.GetInstance()

	var0_13:UnRegisterRedDot(arg0_13._haremTip)
	var0_13:UnRegisterRedDot(arg0_13._academyTip)
	var0_13:UnRegisterRedDot(arg0_13._commanderTip)
	arg0_13:Hide()
end

return var0_0

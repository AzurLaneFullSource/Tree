local var0_0 = class("MainLiveAreaOldPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MainLiveAreaOldUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._academyBtn = arg0_2:findTF("school_btn")
	arg0_2._haremBtn = arg0_2:findTF("backyard_btn")
	arg0_2._commanderBtn = arg0_2:findTF("commander_btn")

	pg.redDotHelper:AddNode(RedDotNode.New(arg0_2._haremBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COURTYARD
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0_2._academyBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.SCHOOL
	}))
	pg.redDotHelper:AddNode(SelfRefreshRedDotNode.New(arg0_2._commanderBtn:Find("tip"), {
		pg.RedDotMgr.TYPES.COMMANDER
	}))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._commanderBtn, function()
		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.COMMANDERCAT, {
			fromMain = true,
			fleetType = CommanderCatScene.FLEET_TYPE_COMMON
		})
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._haremBtn, function()
		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.COURTYARD)
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._academyBtn, function()
		arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.NAVALACADEMYSCENE)
		arg0_3:Hide()
	end, SFX_MAIN)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf, true, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0_8 = getProxy(PlayerProxy):getRawData()

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_8.level, "CommanderCatMediator") then
		arg0_8._commanderBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		arg0_8._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_8.level, "CourtYardMediator") then
		arg0_8._haremBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		arg0_8._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end
end

function var0_0.Hide(arg0_9)
	if arg0_9:isShowing() then
		var0_0.super.Hide(arg0_9)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
	end
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:Hide()
end

return var0_0

local var0_0 = class("SpringFestivalTownScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "SpringFestivalTownUI"
end

function var0_0.getBGM(arg0_2)
	return "story-china"
end

var0_0.HUB_ID = 5
var0_0.edge2area = {
	default = "_middle",
	["9_9"] = "_bottom",
	["4_4"] = "_front"
}

function var0_0.init(arg0_3)
	arg0_3.top = arg0_3:findTF("top")
	arg0_3._closeBtn = arg0_3:findTF("top/return_btn")
	arg0_3._homeBtn = arg0_3:findTF("top/return_main_btn")
	arg0_3._helpBtn = arg0_3:findTF("top/help_btn")
	arg0_3._map = arg0_3:findTF("map")

	for iter0_3 = 0, arg0_3._map.childCount - 1 do
		local var0_3 = arg0_3._map:GetChild(iter0_3)
		local var1_3 = go(var0_3).name

		arg0_3["_" .. var1_3] = var0_3
	end

	arg0_3._front = arg0_3._map:Find("top")
	arg0_3._middle = arg0_3._map:Find("middle")
	arg0_3._bottom = arg0_3._map:Find("bottom")
	arg0_3.containers = {
		arg0_3._front,
		arg0_3._middle,
		arg0_3._bottom
	}
	arg0_3._shipTpl = arg0_3._map:Find("ship")
	arg0_3.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestivalTownGraph"))
	arg0_3._upper = arg0_3:findTF("upper")
	arg0_3.usableTxt = arg0_3.top:Find("usable_count/Text"):GetComponent(typeof(Text))
	arg0_3.diedieleTF = arg0_3.top:Find("diediele_count")
	arg0_3.diedieleTxt = arg0_3.diedieleTF:Find("Text"):GetComponent(typeof(Text))
	arg0_3.effectReq = LoadPrefabRequestPackage.New("ui/map_donghuangchunjie", "map_donghuangchunjie", function(arg0_4)
		setParent(arg0_4, arg0_3._map, false)

		local var0_4 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder
		local var1_4 = arg0_4:GetComponentsInChildren(typeof(Renderer))

		for iter0_4 = 0, var1_4.Length - 1 do
			var1_4[iter0_4].sortingOrder = var0_4 + 1
		end

		arg0_3.mapeffect = arg0_4
	end):Start()

	arg0_3:managedTween(LeanTween.value, nil, go(arg0_3._map), System.Action_UnityEngine_Color(function(arg0_5)
		go(arg0_3._map):GetComponent(typeof(Image)).material:SetColor("_Color", arg0_5)
	end), Color(0, 0, 0, 0), Color(1, 1, 0, 0), 1.5):setLoopPingPong(-1)
end

function var0_0.didEnter(arg0_6)
	local var0_6 = getProxy(MiniGameProxy)

	onButton(arg0_6, arg0_6._closeBtn, function()
		arg0_6:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_6, arg0_6.diedieleTF, function()
		arg0_6:emit(NewYearFestivalMediator.ON_OPEN_PILE_SIGNED)
	end)
	onButton(arg0_6, arg0_6._homeBtn, function()
		arg0_6:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_6, arg0_6._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_feast.tip
		})
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "kaihongbao", function()
		arg0_6:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				if arg0_6.mapeffect then
					setActive(arg0_6.mapeffect, true)
				end
			end
		}), function()
			if arg0_6.mapeffect then
				setActive(arg0_6.mapeffect, false)
			end
		end)
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "danianshou", function()
		arg0_6:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.BEAT_MONSTER_NIAN_2020
		})
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "dafuweng", function()
		arg0_6:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.MONOPOLY_2020
		})
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "diediele", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 9)
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "jianzao", function()
		arg0_6:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "sishu", function()
		arg0_6:emit(NewYearFestivalMediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0_6:InitFacilityCross(arg0_6._map, arg0_6._upper, "pifushangdian", function()
		arg0_6:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6.top, false)
	arg0_6:InitStudents(ActivityConst.ACTIVITY_478, 3, 5)
	arg0_6:UpdateView()
end

function var0_0.UpdateView(arg0_20)
	local var0_20
	local var1_20
	local var2_20 = getProxy(ActivityProxy)
	local var3_20 = getProxy(MiniGameProxy)
	local var4_20 = arg0_20._upper:Find("danianshou/tip")
	local var5_20 = var2_20:getActivityById(ActivityConst.BEAT_MONSTER_NIAN_2020)

	setActive(var4_20, var5_20 and var5_20:readyToAchieve())

	local var6_20 = arg0_20._upper:Find("dafuweng/tip")
	local var7_20 = var2_20:getActivityById(ActivityConst.MONOPOLY_2020)

	setActive(var6_20, var7_20 and var7_20:readyToAchieve())

	local var8_20 = arg0_20._upper:Find("sishu/tip")

	setActive(var8_20, getProxy(ColoringProxy):CheckTodayTip())

	local var9_20 = arg0_20._upper:Find("jianzao/tip")

	setActive(var9_20, false)

	local var10_20 = arg0_20._upper:Find("pifushangdian/tip")

	setActive(var10_20, false)

	local var11_20 = arg0_20._upper:Find("kaihongbao/tip")

	setActive(var11_20, RedPacketLayer.isShowRedPoint())

	local var12_20 = var3_20:GetHubByHubId(arg0_20.HUB_ID)
	local var13_20 = arg0_20._upper:Find("diediele/tip")

	setActive(var13_20, var12_20.count > 0)
	arg0_20:UpdateDieDieleCnt(var12_20)
end

function var0_0.UpdateDieDieleCnt(arg0_21, arg1_21)
	arg0_21.usableTxt.text = "X" .. arg1_21.count
	arg0_21.diedieleTxt.text = arg1_21.usedtime .. "/" .. arg1_21:getConfig("reward_need")
end

function var0_0.TryPlayStory(arg0_22)
	return
end

function var0_0.willExit(arg0_23)
	arg0_23.effectReq:Stop()

	arg0_23.mapeffect = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23.top, arg0_23._tf)
	arg0_23:clearStudents()
end

return var0_0

local var0 = class("SpringFestivalTownScene", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "SpringFestivalTownUI"
end

function var0.getBGM(arg0)
	return "story-china"
end

var0.HUB_ID = 5
var0.edge2area = {
	default = "_middle",
	["9_9"] = "_bottom",
	["4_4"] = "_front"
}

function var0.init(arg0)
	arg0.top = arg0:findTF("top")
	arg0._closeBtn = arg0:findTF("top/return_btn")
	arg0._homeBtn = arg0:findTF("top/return_main_btn")
	arg0._helpBtn = arg0:findTF("top/help_btn")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["_" .. var1] = var0
	end

	arg0._front = arg0._map:Find("top")
	arg0._middle = arg0._map:Find("middle")
	arg0._bottom = arg0._map:Find("bottom")
	arg0.containers = {
		arg0._front,
		arg0._middle,
		arg0._bottom
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.SpringFestivalTownGraph"))
	arg0._upper = arg0:findTF("upper")
	arg0.usableTxt = arg0.top:Find("usable_count/Text"):GetComponent(typeof(Text))
	arg0.diedieleTF = arg0.top:Find("diediele_count")
	arg0.diedieleTxt = arg0.diedieleTF:Find("Text"):GetComponent(typeof(Text))
	arg0.effectReq = LoadPrefabRequestPackage.New("ui/map_donghuangchunjie", "map_donghuangchunjie", function(arg0)
		setParent(arg0, arg0._map, false)

		local var0 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder
		local var1 = arg0:GetComponentsInChildren(typeof(Renderer))

		for iter0 = 0, var1.Length - 1 do
			var1[iter0].sortingOrder = var0 + 1
		end

		arg0.mapeffect = arg0
	end):Start()

	arg0:managedTween(LeanTween.value, nil, go(arg0._map), System.Action_UnityEngine_Color(function(arg0)
		go(arg0._map):GetComponent(typeof(Image)).material:SetColor("_Color", arg0)
	end), Color(0, 0, 0, 0), Color(1, 1, 0, 0), 1.5):setLoopPingPong(-1)
end

function var0.didEnter(arg0)
	local var0 = getProxy(MiniGameProxy)

	onButton(arg0, arg0._closeBtn, function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0.diedieleTF, function()
		arg0:emit(NewYearFestivalMediator.ON_OPEN_PILE_SIGNED)
	end)
	onButton(arg0, arg0._homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end)
	onButton(arg0, arg0._helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_feast.tip
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "kaihongbao", function()
		arg0:emit(NewYearFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer,
			onRemoved = function()
				if arg0.mapeffect then
					setActive(arg0.mapeffect, true)
				end
			end
		}), function()
			if arg0.mapeffect then
				setActive(arg0.mapeffect, false)
			end
		end)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "danianshou", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.BEAT_MONSTER_NIAN_2020
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "dafuweng", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.MONOPOLY_2020
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "diediele", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 9)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "jianzao", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "sishu", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.COLORING)
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "pifushangdian", function()
		arg0:emit(NewYearFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top, false)
	arg0:InitStudents(ActivityConst.ACTIVITY_478, 3, 5)
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	local var0
	local var1
	local var2 = getProxy(ActivityProxy)
	local var3 = getProxy(MiniGameProxy)
	local var4 = arg0._upper:Find("danianshou/tip")
	local var5 = var2:getActivityById(ActivityConst.BEAT_MONSTER_NIAN_2020)

	setActive(var4, var5 and var5:readyToAchieve())

	local var6 = arg0._upper:Find("dafuweng/tip")
	local var7 = var2:getActivityById(ActivityConst.MONOPOLY_2020)

	setActive(var6, var7 and var7:readyToAchieve())

	local var8 = arg0._upper:Find("sishu/tip")

	setActive(var8, getProxy(ColoringProxy):CheckTodayTip())

	local var9 = arg0._upper:Find("jianzao/tip")

	setActive(var9, false)

	local var10 = arg0._upper:Find("pifushangdian/tip")

	setActive(var10, false)

	local var11 = arg0._upper:Find("kaihongbao/tip")

	setActive(var11, RedPacketLayer.isShowRedPoint())

	local var12 = var3:GetHubByHubId(arg0.HUB_ID)
	local var13 = arg0._upper:Find("diediele/tip")

	setActive(var13, var12.count > 0)
	arg0:UpdateDieDieleCnt(var12)
end

function var0.UpdateDieDieleCnt(arg0, arg1)
	arg0.usableTxt.text = "X" .. arg1.count
	arg0.diedieleTxt.text = arg1.usedtime .. "/" .. arg1:getConfig("reward_need")
end

function var0.TryPlayStory(arg0)
	return
end

function var0.willExit(arg0)
	arg0.effectReq:Stop()

	arg0.mapeffect = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
	arg0:clearStudents()
end

return var0

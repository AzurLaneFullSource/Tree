local var0_0 = class("MusicFestivalScene3", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "MusicFestivalUI3"
end

var0_0.edge2area = {
	default = "_SDPlace"
}

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._map = arg0_2:findTF("map")

	for iter0_2 = 0, arg0_2._map.childCount - 1 do
		local var0_2 = arg0_2._map:GetChild(iter0_2)
		local var1_2 = go(var0_2).name

		arg0_2["map_" .. var1_2] = var0_2
	end

	arg0_2._upper = arg0_2:findTF("upper")

	for iter1_2 = 0, arg0_2._upper.childCount - 1 do
		local var2_2 = arg0_2._upper:GetChild(iter1_2)
		local var3_2 = go(var2_2).name

		arg0_2["upper_" .. var3_2] = var2_2
	end

	arg0_2._SDPlace = arg0_2._upper:Find("SDPlace")
	arg0_2.containers = {
		arg0_2._SDPlace
	}
	arg0_2._shipTpl = arg0_2._map:Find("ship")
	arg0_2.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.MusicFestivalGraph3"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idol3rd_houshan.tip
		})
	end, SFX_PANEL)

	local var0_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_3)

	arg0_3:InitStudents(var0_3 and var0_3.id, 3, 4)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end)

	local var1_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_PT_ID_3)

	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "huodongye", function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var1_3.id
		})
	end)
	arg0_3:InitFacilityCross(arg0_3._map, arg0_3._upper, "dalaozhang", function()
		arg0_3:emit(MusicFestivalMediator.GO_SCENE, SCENE.IDOL_MEDAL_COLLECTION_SCENE3)
	end)
	arg0_3:BindItemActivityShop()
	arg0_3:BindItemSkinShop()
	arg0_3:BindItemBuildShip()
	arg0_3:BindItemBattle()
	arg0_3:UpdateView()
end

function var0_0.MiniGameTip()
	return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MUSIC_FESTIVAL_ID_3)
end

function var0_0.MedalTip()
	local var0_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0_11)
end

function var0_0.ActivityTip()
	local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_PT_ID_3)

	return Activity.IsActivityReady(var0_12)
end

function var0_0.UpdateView(arg0_13)
	setActive(arg0_13.upper_xiaoyouxi:Find("Tip"), var0_0.MiniGameTip())
	setActive(arg0_13.upper_dalaozhang:Find("Tip"), var0_0.MedalTip())
	setActive(arg0_13.upper_huodongye:Find("Tip"), var0_0.ActivityTip())
end

function var0_0.IsShowMainTip(arg0_14)
	if arg0_14 and not arg0_14:isEnd() then
		return var0_0.MiniGameTip() or var0_0.MedalTip() or var0_0.ActivityTip()
	end
end

function var0_0.willExit(arg0_15)
	arg0_15:clearStudents()
	var0_0.super.willExit(arg0_15)
end

return var0_0

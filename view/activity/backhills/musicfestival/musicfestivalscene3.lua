local var0 = class("MusicFestivalScene3", import("..TemplateMV.BackHillTemplate"))

function var0.getUIName(arg0)
	return "MusicFestivalUI3"
end

var0.edge2area = {
	default = "_SDPlace"
}

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.top = arg0:findTF("top")
	arg0._map = arg0:findTF("map")

	for iter0 = 0, arg0._map.childCount - 1 do
		local var0 = arg0._map:GetChild(iter0)
		local var1 = go(var0).name

		arg0["map_" .. var1] = var0
	end

	arg0._upper = arg0:findTF("upper")

	for iter1 = 0, arg0._upper.childCount - 1 do
		local var2 = arg0._upper:GetChild(iter1)
		local var3 = go(var2).name

		arg0["upper_" .. var3] = var2
	end

	arg0._SDPlace = arg0._upper:Find("SDPlace")
	arg0.containers = {
		arg0._SDPlace
	}
	arg0._shipTpl = arg0._map:Find("ship")
	arg0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.MusicFestivalGraph3"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idol3rd_houshan.tip
		})
	end, SFX_PANEL)

	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_3)

	arg0:InitStudents(var0 and var0.id, 3, 4)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "xiaoyouxi", function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_PT_ID_3)

	arg0:InitFacilityCross(arg0._map, arg0._upper, "huodongye", function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var1.id
		})
	end)
	arg0:InitFacilityCross(arg0._map, arg0._upper, "dalaozhang", function()
		arg0:emit(MusicFestivalMediator.GO_SCENE, SCENE.IDOL_MEDAL_COLLECTION_SCENE3)
	end)
	arg0:BindItemActivityShop()
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:BindItemBattle()
	arg0:UpdateView()
end

function var0.MiniGameTip()
	return BackHillTemplate.IsMiniActNeedTip(ActivityConst.MUSIC_FESTIVAL_ID_3)
end

function var0.MedalTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)

	return Activity.IsActivityReady(var0)
end

function var0.ActivityTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_PT_ID_3)

	return Activity.IsActivityReady(var0)
end

function var0.UpdateView(arg0)
	setActive(arg0.upper_xiaoyouxi:Find("Tip"), var0.MiniGameTip())
	setActive(arg0.upper_dalaozhang:Find("Tip"), var0.MedalTip())
	setActive(arg0.upper_huodongye:Find("Tip"), var0.ActivityTip())
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.MiniGameTip() or var0.MedalTip() or var0.ActivityTip()
	end
end

function var0.willExit(arg0)
	arg0:clearStudents()
	var0.super.willExit(arg0)
end

return var0

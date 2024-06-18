local var0_0 = class("LinerBackHillScene", import("..TemplateMV.BackHillTemplate"))

var0_0.optionsPath = {
	"top/btn_home"
}
var0_0.ACT_ID = ActivityConst.LINER_ID
var0_0.MINIGAME_ID = 65
var0_0.TASK_ACT_ID = ActivityConst.LINER_SIGN_ID
var0_0.NAME_ID = ActivityConst.LINER_NAMED_ID

function var0_0.getUIName(arg0_1)
	return "LinerBackHillUI"
end

function var0_0.getBGM(arg0_2)
	return arg0_2.activity:getConfig("config_client").backHillBgm[var0_0.IsDay() and "day" or "night"]
end

function var0_0.IsDay()
	local var0_3 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1_3 = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)

	assert(var1_3 and not var1_3:isEnd(), "not exist liner act, type: " .. var0_0.ACT_ID)

	local var2_3 = var1_3:getConfig("config_client").time

	return var0_3 >= var2_3[1] and var0_3 < var2_3[2]
end

function var0_0.init(arg0_4)
	arg0_4._dayTF = arg0_4:findTF("day")
	arg0_4._nightTF = arg0_4:findTF("night")

	for iter0_4 = 0, arg0_4._dayTF.childCount - 1 do
		local var0_4 = arg0_4._dayTF:GetChild(iter0_4)
		local var1_4 = go(var0_4).name

		arg0_4["day_" .. var1_4] = var0_4
	end

	for iter1_4 = 0, arg0_4._nightTF.childCount - 1 do
		local var2_4 = arg0_4._nightTF:GetChild(iter1_4)
		local var3_4 = go(var2_4).name

		arg0_4["night_" .. var3_4] = var2_4
	end

	arg0_4._map = arg0_4._dayTF
	arg0_4._upper = arg0_4._nightTF
	arg0_4._log_tip = arg0_4:findTF("top/btn_log/tip")
	arg0_4._unlock = arg0_4:findTF("top/unlock_info")
	arg0_4.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	arg0_4.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5:findTF("top/btn_back"), function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5:findTF("top/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["7th_main_tip"].tip
		})
	end, SFX_PANEL)
	arg0_5:BindItemSkinShop()
	arg0_5:BindItemBuildShip()
	arg0_5:InitFacilityCross(arg0_5._dayTF, arg0_5._nightTF, "btn_game", function()
		arg0_5:emit(LinerBackHillMediator.GO_MINIGAME, var0_0.MINIGAME_ID)
	end)
	arg0_5:InitFacilityCross(arg0_5._dayTF, arg0_5._nightTF, "btn_cruise", function()
		arg0_5:emit(LinerBackHillMediator.GO_SCENE, SCENE.LINER)
		PlayerPrefs.SetString("LinerBackHillScene", var0_0.GetDate())
	end)
	arg0_5:InitFacilityCross(arg0_5._dayTF, arg0_5._nightTF, "btn_task", function()
		arg0_5:emit(LinerBackHillMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var0_0.TASK_ACT_ID
		})
	end)

	local var0_5 = getProxy(ActivityProxy):getActivityById(var0_0.TASK_ACT_ID):getConfig("config_client").preStory
	local var1_5 = not pg.NewStoryMgr.GetInstance():IsPlayed(var0_5)

	onButton(arg0_5, arg0_5:findTF("top/btn_log"), function()
		if var1_5 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("liner_activity_lock"))
		else
			arg0_5:emit(LinerBackHillMediator.GO_SUBLAYER, Context.New({
				mediator = LinerLogBookMediator,
				viewComponent = LinerLogBookLayer
			}))
		end
	end, SFX_PANEL)
	setActive(arg0_5.day_btn_task, var1_5)
	setActive(arg0_5.night_btn_task, var1_5)
	setActive(arg0_5._unlock, var1_5)
	setActive(arg0_5.day_btn_cruise, not var1_5)
	setActive(arg0_5.night_btn_cruise, not var1_5)
	setActive(arg0_5._dayTF, var0_0.IsDay())
	setActive(arg0_5._nightTF, not var0_0.IsDay())
	arg0_5:UpdateView()
end

function var0_0.UpdateView(arg0_12)
	setActive(arg0_12._log_tip, var0_0.LogTip())
	setActive(arg0_12:findTF("tip", arg0_12.day_btn_game), var0_0.MiniGameTip())
	setActive(arg0_12:findTF("tip", arg0_12.night_btn_game), var0_0.MiniGameTip())
	setActive(arg0_12:findTF("tip", arg0_12.day_btn_cruise), var0_0.CruiseTip())
	setActive(arg0_12:findTF("tip", arg0_12.night_btn_cruise), var0_0.CruiseTip())
end

function var0_0.GetDate()
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.LogTip()
	return LinerLogBookLayer.IsTip()
end

function var0_0.MiniGameTip()
	return getProxy(MiniGameProxy):GetHubByGameId(var0_0.MINIGAME_ID).count > 0
end

function var0_0.CruiseTip()
	local var0_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER):IsFinishAllTime()
	local var1_16 = PlayerPrefs.GetString("LinerBackHillScene") == var0_0.GetDate()

	return not var0_16 and not var1_16
end

function var0_0.IsShowMainTip(arg0_17)
	if arg0_17 and not arg0_17:isEnd() then
		return var0_0.LogTip() or var0_0.MiniGameTip() or var0_0.CruiseTip()
	end
end

function var0_0.willExit(arg0_18)
	return
end

return var0_0

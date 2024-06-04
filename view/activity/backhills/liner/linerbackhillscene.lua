local var0 = class("LinerBackHillScene", import("..TemplateMV.BackHillTemplate"))

var0.optionsPath = {
	"top/btn_home"
}
var0.ACT_ID = ActivityConst.LINER_ID
var0.MINIGAME_ID = 65
var0.TASK_ACT_ID = ActivityConst.LINER_SIGN_ID
var0.NAME_ID = ActivityConst.LINER_NAMED_ID

function var0.getUIName(arg0)
	return "LinerBackHillUI"
end

function var0.getBGM(arg0)
	return arg0.activity:getConfig("config_client").backHillBgm[var0.IsDay() and "day" or "night"]
end

function var0.IsDay()
	local var0 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1 = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)

	assert(var1 and not var1:isEnd(), "not exist liner act, type: " .. var0.ACT_ID)

	local var2 = var1:getConfig("config_client").time

	return var0 >= var2[1] and var0 < var2[2]
end

function var0.init(arg0)
	arg0._dayTF = arg0:findTF("day")
	arg0._nightTF = arg0:findTF("night")

	for iter0 = 0, arg0._dayTF.childCount - 1 do
		local var0 = arg0._dayTF:GetChild(iter0)
		local var1 = go(var0).name

		arg0["day_" .. var1] = var0
	end

	for iter1 = 0, arg0._nightTF.childCount - 1 do
		local var2 = arg0._nightTF:GetChild(iter1)
		local var3 = go(var2).name

		arg0["night_" .. var3] = var2
	end

	arg0._map = arg0._dayTF
	arg0._upper = arg0._nightTF
	arg0._log_tip = arg0:findTF("top/btn_log/tip")
	arg0._unlock = arg0:findTF("top/unlock_info")
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	arg0.timeMgr = pg.TimeMgr.GetInstance()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/btn_back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["7th_main_tip"].tip
		})
	end, SFX_PANEL)
	arg0:BindItemSkinShop()
	arg0:BindItemBuildShip()
	arg0:InitFacilityCross(arg0._dayTF, arg0._nightTF, "btn_game", function()
		arg0:emit(LinerBackHillMediator.GO_MINIGAME, var0.MINIGAME_ID)
	end)
	arg0:InitFacilityCross(arg0._dayTF, arg0._nightTF, "btn_cruise", function()
		arg0:emit(LinerBackHillMediator.GO_SCENE, SCENE.LINER)
		PlayerPrefs.SetString("LinerBackHillScene", var0.GetDate())
	end)
	arg0:InitFacilityCross(arg0._dayTF, arg0._nightTF, "btn_task", function()
		arg0:emit(LinerBackHillMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = var0.TASK_ACT_ID
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(var0.TASK_ACT_ID):getConfig("config_client").preStory
	local var1 = not pg.NewStoryMgr.GetInstance():IsPlayed(var0)

	onButton(arg0, arg0:findTF("top/btn_log"), function()
		if var1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("liner_activity_lock"))
		else
			arg0:emit(LinerBackHillMediator.GO_SUBLAYER, Context.New({
				mediator = LinerLogBookMediator,
				viewComponent = LinerLogBookLayer
			}))
		end
	end, SFX_PANEL)
	setActive(arg0.day_btn_task, var1)
	setActive(arg0.night_btn_task, var1)
	setActive(arg0._unlock, var1)
	setActive(arg0.day_btn_cruise, not var1)
	setActive(arg0.night_btn_cruise, not var1)
	setActive(arg0._dayTF, var0.IsDay())
	setActive(arg0._nightTF, not var0.IsDay())
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	setActive(arg0._log_tip, var0.LogTip())
	setActive(arg0:findTF("tip", arg0.day_btn_game), var0.MiniGameTip())
	setActive(arg0:findTF("tip", arg0.night_btn_game), var0.MiniGameTip())
	setActive(arg0:findTF("tip", arg0.day_btn_cruise), var0.CruiseTip())
	setActive(arg0:findTF("tip", arg0.night_btn_cruise), var0.CruiseTip())
end

function var0.GetDate()
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0.LogTip()
	return LinerLogBookLayer.IsTip()
end

function var0.MiniGameTip()
	return getProxy(MiniGameProxy):GetHubByGameId(var0.MINIGAME_ID).count > 0
end

function var0.CruiseTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER):IsFinishAllTime()
	local var1 = PlayerPrefs.GetString("LinerBackHillScene") == var0.GetDate()

	return not var0 and not var1
end

function var0.IsShowMainTip(arg0)
	if arg0 and not arg0:isEnd() then
		return var0.LogTip() or var0.MiniGameTip() or var0.CruiseTip()
	end
end

function var0.willExit(arg0)
	return
end

return var0

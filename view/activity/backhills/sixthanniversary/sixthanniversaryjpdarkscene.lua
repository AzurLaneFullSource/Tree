local var0 = class("SixthAnniversaryJPDarkScene", import("view.base.BaseUI"))

var0.STATUS_LOCK = 1
var0.STATUS_FOG = 2
var0.STATUS_STORY = 3
var0.STATUS_NOROMAL = 4
var0.ARROW_ANIM_DELTA = 20
var0.ARROW_ANIM_TIME = 0.5

function var0.getUIName(arg0)
	return "SixthAnniversaryJPDarkUI"
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.top = arg0:findTF("top")
	arg0._bg = arg0:findTF("BG")
	arg0.countText = arg0:findTF("top/Count/Text")

	setText(arg0:findTF("top/Count/explain"), i18n("jp6th_lihoushan_pt1"))

	arg0.levelcontainer = arg0:findTF("upper")
	arg0.player = getProxy(PlayerProxy):getRawData()
	arg0.activityID = ActivityConst.MINIGAME_ZUMA
	arg0.config = pg.activity_template[arg0.activityID]
	arg0.arrowPosYList = {}

	for iter0 = 1, 7 do
		local var0 = arg0:findTF(tostring(iter0), arg0.levelcontainer)

		arg0.arrowPosYList[iter0] = arg0:findTF("arrow", var0).localPosition.y
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.jp6th_lihoushan_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Shop"), function()
		arg0:emit(SixthAnniversaryJPDarkMediator.GO_SCENE, SCENE.ZUMA_PT_SHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/Task"), function()
		arg0:emit(SixthAnniversaryJPDarkMediator.GO_SCENE, SCENE.LAUNCH_BALL_TASK)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("BG/door"), function()
		pg.SceneAnimMgr.GetInstance():SixthAnniversaryJPCoverGoScene(SCENE.SIXTH_ANNIVERSARY_JP)
	end, SFX_PANEL)
	arg0:UpdateView()

	local var0 = arg0.config.config_client.lihoushanstory

	pg.NewStoryMgr.GetInstance():Play(var0)
end

function var0.UpdateView(arg0)
	arg0:UpdateLevels()
	arg0:UpdateCount()
	arg0:UpdateTaskTip()
end

function var0.UpdateLevels(arg0)
	arg0.unlockCnt = LaunchBallActivityMgr.GetActivityDay(arg0.activityID)
	arg0.finishCnt = LaunchBallActivityMgr.GetRoundCount(arg0.activityID)
	arg0.maxCnt = LaunchBallActivityMgr.GetRoundCountMax(arg0.activityID)
	arg0.curIndex = arg0.finishCnt < arg0.maxCnt and arg0.finishCnt + 1 or -1

	for iter0 = 1, 7 do
		local var0 = arg0:findTF(tostring(iter0), arg0.levelcontainer)
		local var1 = arg0:GetLevelStatus(iter0)

		arg0:UpdateLevelByStatus(var0, var1)
	end

	for iter1 = 1, 3 do
		local var2 = arg0:findTF("role" .. iter1, arg0.levelcontainer)
		local var3 = LaunchBallActivityMgr.CheckZhuanShuAble(arg0.activityID, iter1)
		local var4 = LaunchBallActivityMgr.IsFinishZhuanShu(arg0.activityID, iter1)

		setActive(var2, var3 and not var4)
		onButton(arg0, var2, function()
			local var0 = arg0.config.config_client.roleStory[iter1]

			pg.NewStoryMgr.GetInstance():Play(var0, function()
				LaunchBallActivityMgr.OpenGame(LaunchBallGameConst.round_type_zhuanshu, iter1)
			end)
		end, SFX_PANEL)
	end

	local var5 = arg0:findTF("endless", arg0.levelcontainer)
	local var6 = arg0.finishCnt >= arg0.maxCnt

	setActive(var5, var6)
	onButton(arg0, var5, function()
		LaunchBallActivityMgr.OpenGame(LaunchBallGameConst.round_type_wuxian, 1)
	end, SFX_PANEL)
end

function var0.GetLevelStatus(arg0, arg1)
	local var0 = var0.STATUS_NOROMAL

	if arg1 <= arg0.finishCnt then
		var0 = var0.STATUS_NOROMAL
	elseif arg1 == arg0.curIndex then
		if arg1 <= arg0.unlockCnt then
			local var1 = arg0.config.config_client.zumaStory[arg1]

			if pg.NewStoryMgr.GetInstance():IsPlayed(var1) then
				var0 = var0.STATUS_NOROMAL
			else
				var0 = var0.STATUS_STORY
			end
		else
			var0 = var0.STATUS_LOCK
		end
	else
		var0 = var0.STATUS_FOG
	end

	return var0
end

function var0.UpdateLevelByStatus(arg0, arg1, arg2)
	if arg2 == var0.STATUS_LOCK then
		setActive(arg0:findTF("lock", arg1), true)
		setActive(arg0:findTF("title/lock", arg1), true)
		setActive(arg0:findTF("fog", arg1), false)
		setActive(arg0:findTF("tag", arg1), false)
		onButton(arg0, arg1, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("jp6th_lihoushan_time"))
		end, SFX_PANEL)
	elseif arg2 == var0.STATUS_FOG then
		setActive(arg0:findTF("lock", arg1), false)
		setActive(arg0:findTF("title/lock", arg1), false)
		setActive(arg0:findTF("fog", arg1), true)
		setActive(arg0:findTF("tag", arg1), false)
		onButton(arg0, arg1, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("jp6th_lihoushan_order"))
		end, SFX_PANEL)
	elseif arg2 == var0.STATUS_STORY then
		setActive(arg0:findTF("lock", arg1), false)
		setActive(arg0:findTF("title/lock", arg1), false)
		setActive(arg0:findTF("fog", arg1), false)
		setActive(arg0:findTF("tag", arg1), false)
		onButton(arg0, arg1, function()
			local var0 = arg0.config.config_client.zumaStory[tonumber(arg1.name)]

			pg.NewStoryMgr.GetInstance():Play(var0, function()
				arg0:UpdateLevels()
			end)
		end, SFX_PANEL)
	elseif arg2 == var0.STATUS_NOROMAL then
		setActive(arg0:findTF("lock", arg1), false)
		setActive(arg0:findTF("title/lock", arg1), false)
		setActive(arg0:findTF("fog", arg1), false)
		setActive(arg0:findTF("tag", arg1), true)
		onButton(arg0, arg1, function()
			LaunchBallActivityMgr.OpenGame(LaunchBallGameConst.round_type_juqing, tonumber(arg1.name))
		end, SFX_PANEL)
	end

	local var0 = arg0:findTF("arrow", arg1)

	LeanTween.cancel(var0.gameObject)

	local var1 = tonumber(arg1.name)

	if var1 == arg0.curIndex then
		setLocalPosition(var0, {
			y = arg0.arrowPosYList[var1]
		})
		setActive(var0, true)
		LeanTween.moveY(var0, arg0.arrowPosYList[var1] + var0.ARROW_ANIM_DELTA, var0.ARROW_ANIM_TIME):setLoopPingPong()
	else
		setActive(var0, false)
	end
end

function var0.UpdateCount(arg0)
	setText(arg0.countText, LaunchBallActivityMgr.GetRemainCount(arg0.activityID))
end

function var0.UpdateTaskTip(arg0)
	setActive(arg0:findTF("Task/Tip", arg0.top), LaunchBallTaskMgr.GetRedTip())
end

function var0.onBackPressed(arg0)
	arg0:emit(SixthAnniversaryJPDarkMediator.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP)
end

return var0

local var0_0 = class("SixthAnniversaryJPDarkScene", import("view.base.BaseUI"))

var0_0.STATUS_LOCK = 1
var0_0.STATUS_FOG = 2
var0_0.STATUS_STORY = 3
var0_0.STATUS_NOROMAL = 4
var0_0.ARROW_ANIM_DELTA = 20
var0_0.ARROW_ANIM_TIME = 0.5

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryJPDarkUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.top = arg0_2:findTF("top")
	arg0_2._bg = arg0_2:findTF("BG")
	arg0_2.countText = arg0_2:findTF("top/Count/Text")

	setText(arg0_2:findTF("top/Count/explain"), i18n("jp6th_lihoushan_pt1"))

	arg0_2.levelcontainer = arg0_2:findTF("upper")
	arg0_2.player = getProxy(PlayerProxy):getRawData()
	arg0_2.activityID = ActivityConst.MINIGAME_ZUMA
	arg0_2.config = pg.activity_template[arg0_2.activityID]
	arg0_2.arrowPosYList = {}

	for iter0_2 = 1, 7 do
		local var0_2 = arg0_2:findTF(tostring(iter0_2), arg0_2.levelcontainer)

		arg0_2.arrowPosYList[iter0_2] = arg0_2:findTF("arrow", var0_2).localPosition.y
	end
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("top/Back"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("top/Home"), function()
		arg0_3:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.jp6th_lihoushan_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Shop"), function()
		arg0_3:emit(SixthAnniversaryJPDarkMediator.GO_SCENE, SCENE.ZUMA_PT_SHOP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("top/Task"), function()
		arg0_3:emit(SixthAnniversaryJPDarkMediator.GO_SCENE, SCENE.LAUNCH_BALL_TASK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("BG/door"), function()
		pg.SceneAnimMgr.GetInstance():SixthAnniversaryJPCoverGoScene(SCENE.SIXTH_ANNIVERSARY_JP)
	end, SFX_PANEL)
	arg0_3:UpdateView()

	local var0_3 = arg0_3.config.config_client.lihoushanstory

	pg.NewStoryMgr.GetInstance():Play(var0_3)
end

function var0_0.UpdateView(arg0_10)
	arg0_10:UpdateLevels()
	arg0_10:UpdateCount()
	arg0_10:UpdateTaskTip()
end

function var0_0.UpdateLevels(arg0_11)
	arg0_11.unlockCnt = LaunchBallActivityMgr.GetActivityDay(arg0_11.activityID)
	arg0_11.finishCnt = LaunchBallActivityMgr.GetRoundCount(arg0_11.activityID)
	arg0_11.maxCnt = LaunchBallActivityMgr.GetRoundCountMax(arg0_11.activityID)
	arg0_11.curIndex = arg0_11.finishCnt < arg0_11.maxCnt and arg0_11.finishCnt + 1 or -1

	for iter0_11 = 1, 7 do
		local var0_11 = arg0_11:findTF(tostring(iter0_11), arg0_11.levelcontainer)
		local var1_11 = arg0_11:GetLevelStatus(iter0_11)

		arg0_11:UpdateLevelByStatus(var0_11, var1_11)
	end

	for iter1_11 = 1, 3 do
		local var2_11 = arg0_11:findTF("role" .. iter1_11, arg0_11.levelcontainer)
		local var3_11 = LaunchBallActivityMgr.CheckZhuanShuAble(arg0_11.activityID, iter1_11)
		local var4_11 = LaunchBallActivityMgr.IsFinishZhuanShu(arg0_11.activityID, iter1_11)

		setActive(var2_11, var3_11 and not var4_11)
		onButton(arg0_11, var2_11, function()
			local var0_12 = arg0_11.config.config_client.roleStory[iter1_11]

			pg.NewStoryMgr.GetInstance():Play(var0_12, function()
				LaunchBallActivityMgr.OpenGame(LaunchBallGameConst.round_type_zhuanshu, iter1_11)
			end)
		end, SFX_PANEL)
	end

	local var5_11 = arg0_11:findTF("endless", arg0_11.levelcontainer)
	local var6_11 = arg0_11.finishCnt >= arg0_11.maxCnt

	setActive(var5_11, var6_11)
	onButton(arg0_11, var5_11, function()
		LaunchBallActivityMgr.OpenGame(LaunchBallGameConst.round_type_wuxian, 1)
	end, SFX_PANEL)
end

function var0_0.GetLevelStatus(arg0_15, arg1_15)
	local var0_15 = var0_0.STATUS_NOROMAL

	if arg1_15 <= arg0_15.finishCnt then
		var0_15 = var0_0.STATUS_NOROMAL
	elseif arg1_15 == arg0_15.curIndex then
		if arg1_15 <= arg0_15.unlockCnt then
			local var1_15 = arg0_15.config.config_client.zumaStory[arg1_15]

			if pg.NewStoryMgr.GetInstance():IsPlayed(var1_15) then
				var0_15 = var0_0.STATUS_NOROMAL
			else
				var0_15 = var0_0.STATUS_STORY
			end
		else
			var0_15 = var0_0.STATUS_LOCK
		end
	else
		var0_15 = var0_0.STATUS_FOG
	end

	return var0_15
end

function var0_0.UpdateLevelByStatus(arg0_16, arg1_16, arg2_16)
	if arg2_16 == var0_0.STATUS_LOCK then
		setActive(arg0_16:findTF("lock", arg1_16), true)
		setActive(arg0_16:findTF("title/lock", arg1_16), true)
		setActive(arg0_16:findTF("fog", arg1_16), false)
		setActive(arg0_16:findTF("tag", arg1_16), false)
		onButton(arg0_16, arg1_16, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("jp6th_lihoushan_time"))
		end, SFX_PANEL)
	elseif arg2_16 == var0_0.STATUS_FOG then
		setActive(arg0_16:findTF("lock", arg1_16), false)
		setActive(arg0_16:findTF("title/lock", arg1_16), false)
		setActive(arg0_16:findTF("fog", arg1_16), true)
		setActive(arg0_16:findTF("tag", arg1_16), false)
		onButton(arg0_16, arg1_16, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("jp6th_lihoushan_order"))
		end, SFX_PANEL)
	elseif arg2_16 == var0_0.STATUS_STORY then
		setActive(arg0_16:findTF("lock", arg1_16), false)
		setActive(arg0_16:findTF("title/lock", arg1_16), false)
		setActive(arg0_16:findTF("fog", arg1_16), false)
		setActive(arg0_16:findTF("tag", arg1_16), false)
		onButton(arg0_16, arg1_16, function()
			local var0_19 = arg0_16.config.config_client.zumaStory[tonumber(arg1_16.name)]

			pg.NewStoryMgr.GetInstance():Play(var0_19, function()
				arg0_16:UpdateLevels()
			end)
		end, SFX_PANEL)
	elseif arg2_16 == var0_0.STATUS_NOROMAL then
		setActive(arg0_16:findTF("lock", arg1_16), false)
		setActive(arg0_16:findTF("title/lock", arg1_16), false)
		setActive(arg0_16:findTF("fog", arg1_16), false)
		setActive(arg0_16:findTF("tag", arg1_16), true)
		onButton(arg0_16, arg1_16, function()
			LaunchBallActivityMgr.OpenGame(LaunchBallGameConst.round_type_juqing, tonumber(arg1_16.name))
		end, SFX_PANEL)
	end

	local var0_16 = arg0_16:findTF("arrow", arg1_16)

	LeanTween.cancel(var0_16.gameObject)

	local var1_16 = tonumber(arg1_16.name)

	if var1_16 == arg0_16.curIndex then
		setLocalPosition(var0_16, {
			y = arg0_16.arrowPosYList[var1_16]
		})
		setActive(var0_16, true)
		LeanTween.moveY(var0_16, arg0_16.arrowPosYList[var1_16] + var0_0.ARROW_ANIM_DELTA, var0_0.ARROW_ANIM_TIME):setLoopPingPong()
	else
		setActive(var0_16, false)
	end
end

function var0_0.UpdateCount(arg0_22)
	setText(arg0_22.countText, LaunchBallActivityMgr.GetRemainCount(arg0_22.activityID))
end

function var0_0.UpdateTaskTip(arg0_23)
	setActive(arg0_23:findTF("Task/Tip", arg0_23.top), LaunchBallTaskMgr.GetRedTip())
end

function var0_0.onBackPressed(arg0_24)
	arg0_24:emit(SixthAnniversaryJPDarkMediator.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP)
end

return var0_0

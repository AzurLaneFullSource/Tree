local var0_0 = class("JavelinComicSkinPage", import(".TemplatePage.SkinTemplatePage"))

var0_0.FADE_OUT_TIME = 1

function var0_0.OnFirstFlush(arg0_1)
	arg0_1:InitView()
	arg0_1:RegisterEvent()
	var0_0.super.OnFirstFlush(arg0_1)
end

function var0_0.InitView(arg0_2)
	arg0_2.animations = {}
	arg0_2.puzzle = arg0_2:findTF("Puzzle", arg0_2.bg)
	arg0_2.linkActId = arg0_2:GetLinkId()
	arg0_2.activityProxy = getProxy(ActivityProxy)
	arg0_2.chargeIDList = Clone(arg0_2.activityProxy:getActivityById(arg0_2.linkActId).data1_list)
	arg0_2.puzzleIDList = Clone(pg.activity_template[arg0_2.linkActId].config_data)

	arg0_2:CheckFinalAward()
end

function var0_0.RegisterEvent(arg0_3)
	arg0_3.helpBtn = arg0_3:findTF("HelpBtn", arg0_3.bg)

	onButton(arg0_3, arg0_3.helpBtn, function()
		if pg.gametip.comic_help then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.comic_help.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
end

function var0_0.GetLinkId(arg0_5)
	return pg.activity_const.JAVELIN_COMIC_PUZZLE_TASK.act_id
end

function var0_0.OnUpdateFlush(arg0_6)
	var0_0.super.OnUpdateFlush(arg0_6)

	arg0_6.linkActivity = arg0_6.activityProxy:getActivityById(arg0_6.linkActId)

	local var0_6 = true

	for iter0_6 = 1, #arg0_6.puzzleIDList do
		local var1_6 = arg0_6.puzzle:GetChild(iter0_6 - 1)
		local var2_6 = arg0_6.puzzleIDList[iter0_6]
		local var3_6 = table.contains(arg0_6.linkActivity.data1_list, var2_6)

		arg0_6:UpdatePuzzle(var1_6, var3_6, var2_6)

		if not var3_6 then
			var0_6 = false
		end
	end

	arg0_6:UpdateMainView(var0_6)
end

function var0_0.UpdatePuzzle(arg0_7, arg1_7, arg2_7, arg3_7)
	if arg2_7 and not table.contains(arg0_7.chargeIDList, arg3_7) then
		table.insert(arg0_7.chargeIDList, arg3_7)
		arg0_7:DoPieceAnimation(arg1_7, 0, 1, function()
			setActive(arg1_7, arg2_7)
			arg0_7:CheckFinalAward()
		end)
	else
		setActive(arg1_7, arg2_7)
	end
end

function var0_0.DoPieceAnimation(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	if LeanTween.isTweening(arg1_9) then
		LeanTween.cancel(go(arg1_9), true)

		arg0_9.animations[arg1_9] = nil
	end

	arg0_9.animations[arg1_9] = true

	LeanTween.alpha(arg1_9, arg3_9, var0_0.FADE_OUT_TIME):setFrom(arg2_9):setOnComplete(System.Action(arg4_9))
end

function var0_0.UpdateMainView(arg0_10, arg1_10)
	local var0_10

	if #arg0_10.chargeIDList == #arg0_10.taskGroup then
		var0_10 = "<color=#00FF00><size=48>" .. #arg0_10.chargeIDList .. "</size></color><color=#00B8FF><size=28>     " .. #arg0_10.taskGroup .. "</size></color>"
	else
		var0_10 = "<color=#E75198><size=48>" .. #arg0_10.chargeIDList .. "</size></color><color=#00B8FF><size=28>     " .. #arg0_10.taskGroup .. "</size></color>"
	end

	setText(arg0_10.dayTF, var0_10)
end

function var0_0.OnDestroy(arg0_11)
	var0_0.super.OnDestroy(arg0_11)

	for iter0_11, iter1_11 in pairs(arg0_11.animations or {}) do
		if LeanTween.isTweening(iter0_11.gameObject) then
			LeanTween.cancel(iter0_11.gameObject)
		end
	end

	arg0_11.animations = nil
end

function var0_0.CheckFinalAward(arg0_12)
	local var0_12 = arg0_12.activityProxy:getActivityById(arg0_12.linkActId)

	if #var0_12.data1_list == #arg0_12.puzzleIDList then
		if var0_12.data1 == 0 then
			arg0_12:FetchFinalAward()
		else
			arg0_12:OnFetchFinalAwardDone()
		end
	end
end

function var0_0.FetchFinalAward(arg0_13)
	arg0_13:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 1,
		activity_id = arg0_13.linkActId
	})
end

function var0_0.OnFetchFinalAwardDone(arg0_14)
	return
end

return var0_0

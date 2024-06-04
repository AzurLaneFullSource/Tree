local var0 = class("JavelinComicSkinPage", import(".TemplatePage.SkinTemplatePage"))

var0.FADE_OUT_TIME = 1

function var0.OnFirstFlush(arg0)
	arg0:InitView()
	arg0:RegisterEvent()
	var0.super.OnFirstFlush(arg0)
end

function var0.InitView(arg0)
	arg0.animations = {}
	arg0.puzzle = arg0:findTF("Puzzle", arg0.bg)
	arg0.linkActId = arg0:GetLinkId()
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.chargeIDList = Clone(arg0.activityProxy:getActivityById(arg0.linkActId).data1_list)
	arg0.puzzleIDList = Clone(pg.activity_template[arg0.linkActId].config_data)

	arg0:CheckFinalAward()
end

function var0.RegisterEvent(arg0)
	arg0.helpBtn = arg0:findTF("HelpBtn", arg0.bg)

	onButton(arg0, arg0.helpBtn, function()
		if pg.gametip.comic_help then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.comic_help.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
end

function var0.GetLinkId(arg0)
	return pg.activity_const.JAVELIN_COMIC_PUZZLE_TASK.act_id
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	arg0.linkActivity = arg0.activityProxy:getActivityById(arg0.linkActId)

	local var0 = true

	for iter0 = 1, #arg0.puzzleIDList do
		local var1 = arg0.puzzle:GetChild(iter0 - 1)
		local var2 = arg0.puzzleIDList[iter0]
		local var3 = table.contains(arg0.linkActivity.data1_list, var2)

		arg0:UpdatePuzzle(var1, var3, var2)

		if not var3 then
			var0 = false
		end
	end

	arg0:UpdateMainView(var0)
end

function var0.UpdatePuzzle(arg0, arg1, arg2, arg3)
	if arg2 and not table.contains(arg0.chargeIDList, arg3) then
		table.insert(arg0.chargeIDList, arg3)
		arg0:DoPieceAnimation(arg1, 0, 1, function()
			setActive(arg1, arg2)
			arg0:CheckFinalAward()
		end)
	else
		setActive(arg1, arg2)
	end
end

function var0.DoPieceAnimation(arg0, arg1, arg2, arg3, arg4)
	if LeanTween.isTweening(arg1) then
		LeanTween.cancel(go(arg1), true)

		arg0.animations[arg1] = nil
	end

	arg0.animations[arg1] = true

	LeanTween.alpha(arg1, arg3, var0.FADE_OUT_TIME):setFrom(arg2):setOnComplete(System.Action(arg4))
end

function var0.UpdateMainView(arg0, arg1)
	local var0

	if #arg0.chargeIDList == #arg0.taskGroup then
		var0 = "<color=#00FF00><size=48>" .. #arg0.chargeIDList .. "</size></color><color=#00B8FF><size=28>     " .. #arg0.taskGroup .. "</size></color>"
	else
		var0 = "<color=#E75198><size=48>" .. #arg0.chargeIDList .. "</size></color><color=#00B8FF><size=28>     " .. #arg0.taskGroup .. "</size></color>"
	end

	setText(arg0.dayTF, var0)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	for iter0, iter1 in pairs(arg0.animations or {}) do
		if LeanTween.isTweening(iter0.gameObject) then
			LeanTween.cancel(iter0.gameObject)
		end
	end

	arg0.animations = nil
end

function var0.CheckFinalAward(arg0)
	local var0 = arg0.activityProxy:getActivityById(arg0.linkActId)

	if #var0.data1_list == #arg0.puzzleIDList then
		if var0.data1 == 0 then
			arg0:FetchFinalAward()
		else
			arg0:OnFetchFinalAwardDone()
		end
	end
end

function var0.FetchFinalAward(arg0)
	arg0:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 1,
		activity_id = arg0.linkActId
	})
end

function var0.OnFetchFinalAwardDone(arg0)
	return
end

return var0

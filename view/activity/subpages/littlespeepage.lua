local var0_0 = class("LittleSpeePage", import(".TemplatePage.PtTemplatePage"))

var0_0.FILL_ANI_TIME = 0.5
var0_0.IMAGE_ANI_TIME = 0.5
var0_0.IMAGE_MAX_SCALE = Vector3(2, 2, 2)
var0_0.TEXT_ANI_TIME = 0.3
var0_0.TEXT_MAX_SCALE = Vector3(3, 3, 3)

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.heartTpl = arg0_1:findTF("HeartTpl", arg0_1.bg)
	arg0_1.heartContainer = arg0_1:findTF("HeartContainer", arg0_1.bg)
	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.getFinalBtn = arg0_1:findTF("get_final_btn", arg0_1.bg)
	arg0_1.gotFinalBtn = arg0_1:findTF("got_final_btn", arg0_1.bg)
	arg0_1.performBtn = arg0_1:findTF("perform_btn", arg0_1.bg)
	arg0_1.performImage = arg0_1:findTF("image", arg0_1.performBtn)
	arg0_1.performText = arg0_1:findTF("text", arg0_1.performBtn)
	arg0_1.performReBtn = arg0_1:findTF("perform_re_btn", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	arg0_2.storyName = arg0_2.activity:getConfig("config_client").performStory
	arg0_2.activateStoryName = arg0_2.activity:getConfig("config_client").activateStory
	arg0_2.heartUIItemList = UIItemList.New(arg0_2.heartContainer, arg0_2.heartTpl)

	arg0_2.heartUIItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg1_3 + 1

			arg2_3.name = var0_3

			local var1_3 = arg0_2.ptData:GetLevel()
			local var2_3 = arg0_2:findTF("Full", arg2_3)

			setFillAmount(var2_3, 1)
			setActive(var2_3, var0_3 <= var1_3)
		end
	end)
	onButton(arg0_2, arg0_2.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.littleSpee_npc.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.getBtn, function()
		arg0_2:OnGetBtnClick()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.getFinalBtn, function()
		arg0_2:OnGetBtnClick()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.performBtn, function()
		local var0_8 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0_2.storyName)

		assert(var0_8 and var0_8 ~= 0, "Missing Story Stage ID: " .. (arg0_2.storyName or "NIL"))
		arg0_2:emit(ActivityMediator.GO_PERFORM_COMBAT, {
			stageId = var0_8
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.performReBtn, function()
		local var0_9 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0_2.storyName)

		assert(var0_9 and var0_9 ~= 0, "Missing Story Stage ID: " .. (arg0_2.storyName or "NIL"))
		arg0_2:emit(ActivityMediator.GO_PERFORM_COMBAT, {
			memory = true,
			stageId = var0_9
		})
	end, SFX_PANEL)
	setActive(arg0_2.performReBtn, false)
	setActive(arg0_2.performBtn, false)
	setActive(arg0_2.getFinalBtn, false)

	arg0_2.inGetProcess = false
end

function var0_0.OnUpdateFlush(arg0_10)
	var0_0.super.OnUpdateFlush(arg0_10)

	local var0_10, var1_10 = arg0_10.ptData:GetLevelProgress()

	arg0_10.heartUIItemList:align(var1_10)

	if var0_10 == var1_10 then
		setActive(arg0_10.getBtn, false)
		setActive(arg0_10.gotBtn, false)

		local var2_10 = arg0_10.ptData:CanGetAward()
		local var3_10 = arg0_10.ptData:CanGetNextAward()
		local var4_10 = pg.NewStoryMgr.GetInstance():IsPlayed(arg0_10.storyName)

		setActive(arg0_10.performBtn, not var4_10 and var2_10)
		setActive(arg0_10.performReBtn, var4_10)
		setActive(arg0_10.getFinalBtn, var4_10 and var2_10)
		setActive(arg0_10.gotFinalBtn, var4_10 and not var3_10)

		if not var4_10 and var2_10 then
			pg.NewStoryMgr.GetInstance():Play(arg0_10.activateStoryName)
			setActive(arg0_10.performBtn, true)
			setLocalScale(arg0_10.performImage, Vector3.one)
			arg0_10:managedTween(LeanTween.scale, nil, arg0_10.performImage, var0_0.IMAGE_MAX_SCALE, var0_0.IMAGE_ANI_TIME)
			arg0_10:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_10.performImage, typeof(CanvasGroup)), 1, var0_0.IMAGE_ANI_TIME / 2):setFrom(0)
			arg0_10:managedTween(LeanTween.delayedCall, function()
				arg0_10:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_10.performImage, typeof(CanvasGroup)), 0, var0_0.IMAGE_ANI_TIME / 2)
			end, var0_0.IMAGE_ANI_TIME / 2, nil)
			setLocalScale(arg0_10.performText, var0_0.TEXT_MAX_SCALE)
			arg0_10:managedTween(LeanTween.scale, nil, arg0_10.performText, Vector3.one, var0_0.TEXT_ANI_TIME)
			arg0_10:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0_10.performText, typeof(CanvasGroup)), 1, var0_0.TEXT_ANI_TIME):setFrom(0)
		else
			setActive(arg0_10.performBtn, false)
		end
	end
end

function var0_0.OnGetBtnClick(arg0_12)
	if arg0_12.inGetProcess then
		return
	end

	arg0_12.inGetProcess = true

	local var0_12 = {}
	local var1_12 = arg0_12.ptData:GetAward()
	local var2_12 = getProxy(PlayerProxy):getRawData()
	local var3_12 = pg.gameset.urpt_chapter_max.description[1]
	local var4_12 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_12)
	local var5_12, var6_12 = Task.StaticJudgeOverflow(var2_12.gold, var2_12.oil, var4_12, true, true, {
		{
			var1_12.type,
			var1_12.id,
			var1_12.count
		}
	})

	if var5_12 then
		table.insert(var0_12, function(arg0_13)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6_12,
				onYes = arg0_13
			})
		end)

		arg0_12.inGetProcess = false
	end

	table.insert(var0_12, function(arg0_14)
		local var0_14 = arg0_12.ptData:GetLevelProgress()
		local var1_14 = arg0_12:findTF(var0_14 .. "/Full", arg0_12.heartContainer)

		setFillAmount(var1_14, 0)
		setActive(var1_14, true)
		arg0_12:managedTween(LeanTween.value, nil, go(var1_14), 0, 1, var0_0.FILL_ANI_TIME):setOnUpdate(System.Action_float(function(arg0_15)
			setFillAmount(var1_14, arg0_15)
		end)):setOnComplete(System.Action(function()
			arg0_14()
		end))
	end)
	seriesAsync(var0_12, function()
		local var0_17, var1_17 = arg0_12.ptData:GetResProgress()

		arg0_12:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_12.ptData:GetId(),
			arg1 = var1_17
		})

		arg0_12.inGetProcess = false
	end)
end

return var0_0

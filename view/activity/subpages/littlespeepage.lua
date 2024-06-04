local var0 = class("LittleSpeePage", import(".TemplatePage.PtTemplatePage"))

var0.FILL_ANI_TIME = 0.5
var0.IMAGE_ANI_TIME = 0.5
var0.IMAGE_MAX_SCALE = Vector3(2, 2, 2)
var0.TEXT_ANI_TIME = 0.3
var0.TEXT_MAX_SCALE = Vector3(3, 3, 3)

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.heartTpl = arg0:findTF("HeartTpl", arg0.bg)
	arg0.heartContainer = arg0:findTF("HeartContainer", arg0.bg)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.getFinalBtn = arg0:findTF("get_final_btn", arg0.bg)
	arg0.gotFinalBtn = arg0:findTF("got_final_btn", arg0.bg)
	arg0.performBtn = arg0:findTF("perform_btn", arg0.bg)
	arg0.performImage = arg0:findTF("image", arg0.performBtn)
	arg0.performText = arg0:findTF("text", arg0.performBtn)
	arg0.performReBtn = arg0:findTF("perform_re_btn", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.storyName = arg0.activity:getConfig("config_client").performStory
	arg0.activateStoryName = arg0.activity:getConfig("config_client").activateStory
	arg0.heartUIItemList = UIItemList.New(arg0.heartContainer, arg0.heartTpl)

	arg0.heartUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1

			arg2.name = var0

			local var1 = arg0.ptData:GetLevel()
			local var2 = arg0:findTF("Full", arg2)

			setFillAmount(var2, 1)
			setActive(var2, var0 <= var1)
		end
	end)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.littleSpee_npc.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:OnGetBtnClick()
	end, SFX_PANEL)
	onButton(arg0, arg0.getFinalBtn, function()
		arg0:OnGetBtnClick()
	end, SFX_PANEL)
	onButton(arg0, arg0.performBtn, function()
		local var0 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0.storyName)

		assert(var0 and var0 ~= 0, "Missing Story Stage ID: " .. (arg0.storyName or "NIL"))
		arg0:emit(ActivityMediator.GO_PERFORM_COMBAT, {
			stageId = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.performReBtn, function()
		local var0 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg0.storyName)

		assert(var0 and var0 ~= 0, "Missing Story Stage ID: " .. (arg0.storyName or "NIL"))
		arg0:emit(ActivityMediator.GO_PERFORM_COMBAT, {
			memory = true,
			stageId = var0
		})
	end, SFX_PANEL)
	setActive(arg0.performReBtn, false)
	setActive(arg0.performBtn, false)
	setActive(arg0.getFinalBtn, false)

	arg0.inGetProcess = false
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1 = arg0.ptData:GetLevelProgress()

	arg0.heartUIItemList:align(var1)

	if var0 == var1 then
		setActive(arg0.getBtn, false)
		setActive(arg0.gotBtn, false)

		local var2 = arg0.ptData:CanGetAward()
		local var3 = arg0.ptData:CanGetNextAward()
		local var4 = pg.NewStoryMgr.GetInstance():IsPlayed(arg0.storyName)

		setActive(arg0.performBtn, not var4 and var2)
		setActive(arg0.performReBtn, var4)
		setActive(arg0.getFinalBtn, var4 and var2)
		setActive(arg0.gotFinalBtn, var4 and not var3)

		if not var4 and var2 then
			pg.NewStoryMgr.GetInstance():Play(arg0.activateStoryName)
			setActive(arg0.performBtn, true)
			setLocalScale(arg0.performImage, Vector3.one)
			arg0:managedTween(LeanTween.scale, nil, arg0.performImage, var0.IMAGE_MAX_SCALE, var0.IMAGE_ANI_TIME)
			arg0:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0.performImage, typeof(CanvasGroup)), 1, var0.IMAGE_ANI_TIME / 2):setFrom(0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0.performImage, typeof(CanvasGroup)), 0, var0.IMAGE_ANI_TIME / 2)
			end, var0.IMAGE_ANI_TIME / 2, nil)
			setLocalScale(arg0.performText, var0.TEXT_MAX_SCALE)
			arg0:managedTween(LeanTween.scale, nil, arg0.performText, Vector3.one, var0.TEXT_ANI_TIME)
			arg0:managedTween(LeanTween.alphaCanvas, nil, GetOrAddComponent(arg0.performText, typeof(CanvasGroup)), 1, var0.TEXT_ANI_TIME):setFrom(0)
		else
			setActive(arg0.performBtn, false)
		end
	end
end

function var0.OnGetBtnClick(arg0)
	if arg0.inGetProcess then
		return
	end

	arg0.inGetProcess = true

	local var0 = {}
	local var1 = arg0.ptData:GetAward()
	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = pg.gameset.urpt_chapter_max.description[1]
	local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
	local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
		{
			var1.type,
			var1.id,
			var1.count
		}
	})

	if var5 then
		table.insert(var0, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var6,
				onYes = arg0
			})
		end)

		arg0.inGetProcess = false
	end

	table.insert(var0, function(arg0)
		local var0 = arg0.ptData:GetLevelProgress()
		local var1 = arg0:findTF(var0 .. "/Full", arg0.heartContainer)

		setFillAmount(var1, 0)
		setActive(var1, true)
		arg0:managedTween(LeanTween.value, nil, go(var1), 0, 1, var0.FILL_ANI_TIME):setOnUpdate(System.Action_float(function(arg0)
			setFillAmount(var1, arg0)
		end)):setOnComplete(System.Action(function()
			arg0()
		end))
	end)
	seriesAsync(var0, function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})

		arg0.inGetProcess = false
	end)
end

return var0

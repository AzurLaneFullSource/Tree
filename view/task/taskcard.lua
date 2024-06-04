local var0 = class("TaskCard")
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3
local var5 = 4
local var6 = 0.3

function var0.Type2Tag(arg0)
	if not var0.types then
		var0.types = {
			"subtitle_main",
			"subtitle_brach",
			"subtitle_daily",
			"subtitle_week",
			"subtitle_brach",
			"subtitle_activity",
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			"subtitle_week",
			[26] = "subtitle_activity",
			[36] = "subtitle_activity"
		}
	end

	return var0.types[arg0]
end

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = tf(arg0._go)
	arg0.viewComponent = arg2
	arg0.frame = arg0._tf:Find("frame")
	arg0.descTxt = arg0._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0.tagTF = arg0._tf:Find("frame/tag"):GetComponent(typeof(Image))
	arg0.rewardPanel = arg0._tf:Find("frame/awards")
	arg0._rewardModel = arg0.rewardPanel:GetChild(0)
	arg0.progressBar = arg0._tf:Find("frame/slider"):GetComponent(typeof(Slider))
	arg0.progressNum = arg0._tf:Find("frame/slider/Text"):GetComponent(typeof(Text))
	arg0.GotoBtn = arg0._tf:Find("frame/go_btn")
	arg0.GetBtn = arg0._tf:Find("frame/get_btn")
	arg0.storyIconFrame = arg0._tf:Find("frame/storyIcon")
	arg0.storyIcon = arg0._tf:Find("frame/storyIcon/icon")
	arg0._modelWidth = arg0.frame.rect.width + 100
	arg0.finishBg = arg0._tf:Find("frame/finish_bg")
	arg0.unfinishBg = arg0._tf:Find("frame/unfinish_bg")
	arg0.tip = arg0._tf:Find("frame/tip")
	arg0.cg = GetOrAddComponent(arg0._tf, "CanvasGroup")
	arg0.height = arg0._tf.rect.height
	arg0.urTag = arg0._tf:Find("frame/urTag")
	arg0.lockBg = arg0._tf:Find("lock_bg")
	arg0.lockTxt = arg0.lockBg:Find("btn/Text"):GetComponent(typeof(Text))
	arg0.sIconOldPosition = Vector2(0, 20)
end

function var0.update(arg0, arg1)
	assert(isa(arg1, Task), "should be an instance of Task")

	arg0.taskVO = arg1

	if arg1.id == 10302 then
		arg0._go.name = arg1.id
	end

	arg0.descTxt.text = arg1:getConfig("desc")
	arg0.tagTF.sprite = GetSpriteFromAtlas("ui/TaskUI_atlas", var0.Type2Tag(arg1:GetRealType()))

	local var0 = arg1:getConfig("target_num")

	arg0:updateAwards(arg1:getConfig("award_display"))

	local var1 = arg1:getProgress()

	if arg1:isFinish() then
		arg0.progressNum.text = "COMPLETE"
	elseif arg1:getConfig("sub_type") == 1012 then
		arg0.progressNum.text = math.floor(var1 / 100) .. "/" .. math.floor(var0 / 100)
	else
		arg0.progressNum.text = var1 .. "/" .. var0
	end

	arg0.progressBar.value = var1 / var0

	arg0:updateBtnState(arg1)

	local var2 = arg1:getConfig("story_id")
	local var3 = arg1:IsUrTask()

	setActive(arg0.urTag, var3)
	setActive(arg0.storyIconFrame, var2 and var2 ~= "" and not var3)

	if var2 and var2 ~= "" then
		local var4 = arg1:getConfig("story_icon")

		if not var4 or var4 == "" then
			var4 = "task_icon_default"
		end

		LoadSpriteAsync("shipmodels/" .. var4, function(arg0)
			if arg0 then
				setImageSprite(arg0.storyIcon, arg0, true)
				arg0:UpdateStoryIconPosition(arg1)
			end
		end)
		onButton(arg0, arg0.storyIconFrame, function()
			pg.NewStoryMgr.GetInstance():Play(var2, nil, true)
		end, SFX_PANEL)
	else
		removeOnButton(arg0.storyIconFrame)
	end

	arg0.cg.alpha = 1

	setActive(arg0.frame, true)
	setActive(arg0._go, true)
end

function var0.UpdateStoryIconPosition(arg0, arg1)
	local var0 = arg1:getConfig("story_icon_shift")

	if type(var0) == "table" and #var0 >= 2 then
		local var1 = var0[1]
		local var2 = var0[2]
		local var3 = arg0.sIconOldPosition

		setAnchoredPosition(arg0.storyIcon, {
			x = var3.x + var1,
			y = var3.y + var2
		})
	else
		local var4 = 0
		local var5 = 0
		local var6 = arg0.sIconOldPosition

		setAnchoredPosition(arg0.storyIcon, {
			x = var6.x + var4,
			y = var6.y + var5
		})
	end
end

function var0.updateBtnState(arg0, arg1)
	local var0 = var1

	removeOnButton(arg0.GotoBtn)
	removeOnButton(arg0.GetBtn)

	if arg1:isLock() then
		var0 = var5
	elseif arg1:isFinish() then
		var0 = arg1:isReceive() and var4 or var3

		onButton(arg0, arg0.GetBtn, function()
			local function var0()
				if not arg0.isClick then
					arg0.isClick = true

					arg0:DoSubmitAnim(function()
						arg0.isClick = nil

						arg0:Submit(arg1)
					end)
				end
			end

			local var1

			local function var2()
				if arg1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM or arg1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM or arg1:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
					local var0 = DROP_TYPE_ITEM

					if arg1:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
						var0 = DROP_TYPE_RESOURCE
					end

					local var1 = {
						type = var0,
						id = tonumber(arg1:getConfig("target_id")),
						count = arg1:getConfig("target_num")
					}
					local var2 = {
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("sub_item_warning"),
						items = {
							var1
						},
						onYes = function()
							var1()
						end
					}

					pg.MsgboxMgr.GetInstance():ShowMsgBox(var2)
					coroutine.yield()
				end

				local var3, var4 = arg1:judgeOverflow()

				if var3 then
					local var5 = {
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var4,
						onYes = function()
							var1()
						end
					}

					pg.MsgboxMgr.GetInstance():ShowMsgBox(var5)
					coroutine.yield()
				end

				var0()
			end

			var1 = coroutine.wrap(var2)

			var1()
		end, SFX_PANEL)
	else
		var0 = var2

		onButton(arg0, arg0.GotoBtn, function()
			arg0:Skip(arg1)
		end, SFX_PANEL)
	end

	SetActive(arg0.GotoBtn, var0 == var2)
	SetActive(arg0.GetBtn, var0 == var3)
	setActive(arg0.finishBg, var0 == var3 or var0 == var4)
	setActive(arg0.unfinishBg, var0 ~= var3 and var0 ~= var4)
	setActive(arg0.tip, var0 == var3 or var0 == var4)
	setActive(arg0.lockBg, var0 == var5)
	setGray(arg0.frame, var0 == var5, true)

	if var0 == var5 then
		arg0.lockTxt.text = i18n("task_lock", arg1:getConfig("level"))
	end
end

function var0.Submit(arg0, arg1)
	if arg1.isWeekTask then
		arg0.viewComponent:onSubmitForWeek(arg1)
	elseif arg1:isAvatarTask() then
		arg0.viewComponent:onSubmitForAvatar(arg1)
	else
		arg0.viewComponent:onSubmit(arg1)
	end
end

function var0.Skip(arg0, arg1)
	arg0.viewComponent:onGo(arg1)
end

function var0.updateAwards(arg0, arg1)
	local var0 = _.slice(arg1, 1, 3)

	for iter0 = arg0.rewardPanel.childCount, #var0 - 1 do
		cloneTplTo(arg0._rewardModel, arg0.rewardPanel)
	end

	local var1 = arg0.rewardPanel.childCount

	for iter1 = 1, var1 do
		local var2 = arg0.rewardPanel:GetChild(iter1 - 1)
		local var3 = iter1 <= #var0

		setActive(var2, var3)

		if var3 then
			local var4 = var0[iter1]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			}

			updateDrop(var2, var5)
			onButton(arg0, var2, function()
				arg0.viewComponent:emit(TaskMediator.ON_DROP, var5)
			end, SFX_PANEL)
		end
	end
end

function var0.DoSubmitAnim(arg0, arg1)
	local var0 = arg0.frame.localPosition

	LeanTween.alphaCanvas(arg0.cg, 0, var6):setFrom(1)
	LeanTween.value(go(arg0.frame), var0.x, var0.x + arg0._modelWidth, var6):setOnUpdate(System.Action_float(function(arg0)
		arg0.frame.transform.localPosition = Vector3(arg0, var0.y, var0.z)
	end)):setOnComplete(System.Action(function()
		arg0.frame.transform.localPosition = var0

		setActive(arg0.frame, false)
		arg1()
	end))
end

function var0.dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0

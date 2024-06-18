local var0_0 = class("TaskCard")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4
local var6_0 = 0.3

function var0_0.Type2Tag(arg0_1)
	if not var0_0.types then
		var0_0.types = {
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

	return var0_0.types[arg0_1]
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	pg.DelegateInfo.New(arg0_2)

	arg0_2._go = arg1_2
	arg0_2._tf = tf(arg0_2._go)
	arg0_2.viewComponent = arg2_2
	arg0_2.frame = arg0_2._tf:Find("frame")
	arg0_2.descTxt = arg0_2._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0_2.tagTF = arg0_2._tf:Find("frame/tag"):GetComponent(typeof(Image))
	arg0_2.rewardPanel = arg0_2._tf:Find("frame/awards")
	arg0_2._rewardModel = arg0_2.rewardPanel:GetChild(0)
	arg0_2.progressBar = arg0_2._tf:Find("frame/slider"):GetComponent(typeof(Slider))
	arg0_2.progressNum = arg0_2._tf:Find("frame/slider/Text"):GetComponent(typeof(Text))
	arg0_2.GotoBtn = arg0_2._tf:Find("frame/go_btn")
	arg0_2.GetBtn = arg0_2._tf:Find("frame/get_btn")
	arg0_2.storyIconFrame = arg0_2._tf:Find("frame/storyIcon")
	arg0_2.storyIcon = arg0_2._tf:Find("frame/storyIcon/icon")
	arg0_2._modelWidth = arg0_2.frame.rect.width + 100
	arg0_2.finishBg = arg0_2._tf:Find("frame/finish_bg")
	arg0_2.unfinishBg = arg0_2._tf:Find("frame/unfinish_bg")
	arg0_2.tip = arg0_2._tf:Find("frame/tip")
	arg0_2.cg = GetOrAddComponent(arg0_2._tf, "CanvasGroup")
	arg0_2.height = arg0_2._tf.rect.height
	arg0_2.urTag = arg0_2._tf:Find("frame/urTag")
	arg0_2.lockBg = arg0_2._tf:Find("lock_bg")
	arg0_2.lockTxt = arg0_2.lockBg:Find("btn/Text"):GetComponent(typeof(Text))
	arg0_2.sIconOldPosition = Vector2(0, 20)
end

function var0_0.update(arg0_3, arg1_3)
	assert(isa(arg1_3, Task), "should be an instance of Task")

	arg0_3.taskVO = arg1_3

	if arg1_3.id == 10302 then
		arg0_3._go.name = arg1_3.id
	end

	arg0_3.descTxt.text = arg1_3:getConfig("desc")
	arg0_3.tagTF.sprite = GetSpriteFromAtlas("ui/TaskUI_atlas", var0_0.Type2Tag(arg1_3:GetRealType()))

	local var0_3 = arg1_3:getConfig("target_num")

	arg0_3:updateAwards(arg1_3:getConfig("award_display"))

	local var1_3 = arg1_3:getProgress()

	if arg1_3:isFinish() then
		arg0_3.progressNum.text = "COMPLETE"
	elseif arg1_3:getConfig("sub_type") == 1012 then
		arg0_3.progressNum.text = math.floor(var1_3 / 100) .. "/" .. math.floor(var0_3 / 100)
	else
		arg0_3.progressNum.text = var1_3 .. "/" .. var0_3
	end

	arg0_3.progressBar.value = var1_3 / var0_3

	arg0_3:updateBtnState(arg1_3)

	local var2_3 = arg1_3:getConfig("story_id")
	local var3_3 = arg1_3:IsUrTask()

	setActive(arg0_3.urTag, var3_3)
	setActive(arg0_3.storyIconFrame, var2_3 and var2_3 ~= "" and not var3_3)

	if var2_3 and var2_3 ~= "" then
		local var4_3 = arg1_3:getConfig("story_icon")

		if not var4_3 or var4_3 == "" then
			var4_3 = "task_icon_default"
		end

		LoadSpriteAsync("shipmodels/" .. var4_3, function(arg0_4)
			if arg0_4 then
				setImageSprite(arg0_3.storyIcon, arg0_4, true)
				arg0_3:UpdateStoryIconPosition(arg1_3)
			end
		end)
		onButton(arg0_3, arg0_3.storyIconFrame, function()
			pg.NewStoryMgr.GetInstance():Play(var2_3, nil, true)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_3.storyIconFrame)
	end

	arg0_3.cg.alpha = 1

	setActive(arg0_3.frame, true)
	setActive(arg0_3._go, true)
end

function var0_0.UpdateStoryIconPosition(arg0_6, arg1_6)
	local var0_6 = arg1_6:getConfig("story_icon_shift")

	if type(var0_6) == "table" and #var0_6 >= 2 then
		local var1_6 = var0_6[1]
		local var2_6 = var0_6[2]
		local var3_6 = arg0_6.sIconOldPosition

		setAnchoredPosition(arg0_6.storyIcon, {
			x = var3_6.x + var1_6,
			y = var3_6.y + var2_6
		})
	else
		local var4_6 = 0
		local var5_6 = 0
		local var6_6 = arg0_6.sIconOldPosition

		setAnchoredPosition(arg0_6.storyIcon, {
			x = var6_6.x + var4_6,
			y = var6_6.y + var5_6
		})
	end
end

function var0_0.updateBtnState(arg0_7, arg1_7)
	local var0_7 = var1_0

	removeOnButton(arg0_7.GotoBtn)
	removeOnButton(arg0_7.GetBtn)

	if arg1_7:isLock() then
		var0_7 = var5_0
	elseif arg1_7:isFinish() then
		var0_7 = arg1_7:isReceive() and var4_0 or var3_0

		onButton(arg0_7, arg0_7.GetBtn, function()
			local function var0_8()
				if not arg0_7.isClick then
					arg0_7.isClick = true

					arg0_7:DoSubmitAnim(function()
						arg0_7.isClick = nil

						arg0_7:Submit(arg1_7)
					end)
				end
			end

			local var1_8

			local function var2_8()
				if arg1_7:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM or arg1_7:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM or arg1_7:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
					local var0_11 = DROP_TYPE_ITEM

					if arg1_7:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
						var0_11 = DROP_TYPE_RESOURCE
					end

					local var1_11 = {
						type = var0_11,
						id = tonumber(arg1_7:getConfig("target_id")),
						count = arg1_7:getConfig("target_num")
					}
					local var2_11 = {
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("sub_item_warning"),
						items = {
							var1_11
						},
						onYes = function()
							var1_8()
						end
					}

					pg.MsgboxMgr.GetInstance():ShowMsgBox(var2_11)
					coroutine.yield()
				end

				local var3_11, var4_11 = arg1_7:judgeOverflow()

				if var3_11 then
					local var5_11 = {
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var4_11,
						onYes = function()
							var1_8()
						end
					}

					pg.MsgboxMgr.GetInstance():ShowMsgBox(var5_11)
					coroutine.yield()
				end

				var0_8()
			end

			var1_8 = coroutine.wrap(var2_8)

			var1_8()
		end, SFX_PANEL)
	else
		var0_7 = var2_0

		onButton(arg0_7, arg0_7.GotoBtn, function()
			arg0_7:Skip(arg1_7)
		end, SFX_PANEL)
	end

	SetActive(arg0_7.GotoBtn, var0_7 == var2_0)
	SetActive(arg0_7.GetBtn, var0_7 == var3_0)
	setActive(arg0_7.finishBg, var0_7 == var3_0 or var0_7 == var4_0)
	setActive(arg0_7.unfinishBg, var0_7 ~= var3_0 and var0_7 ~= var4_0)
	setActive(arg0_7.tip, var0_7 == var3_0 or var0_7 == var4_0)
	setActive(arg0_7.lockBg, var0_7 == var5_0)
	setGray(arg0_7.frame, var0_7 == var5_0, true)

	if var0_7 == var5_0 then
		arg0_7.lockTxt.text = i18n("task_lock", arg1_7:getConfig("level"))
	end
end

function var0_0.Submit(arg0_15, arg1_15)
	if arg1_15.isWeekTask then
		arg0_15.viewComponent:onSubmitForWeek(arg1_15)
	elseif arg1_15:isAvatarTask() then
		arg0_15.viewComponent:onSubmitForAvatar(arg1_15)
	else
		arg0_15.viewComponent:onSubmit(arg1_15)
	end
end

function var0_0.Skip(arg0_16, arg1_16)
	arg0_16.viewComponent:onGo(arg1_16)
end

function var0_0.updateAwards(arg0_17, arg1_17)
	local var0_17 = _.slice(arg1_17, 1, 3)

	for iter0_17 = arg0_17.rewardPanel.childCount, #var0_17 - 1 do
		cloneTplTo(arg0_17._rewardModel, arg0_17.rewardPanel)
	end

	local var1_17 = arg0_17.rewardPanel.childCount

	for iter1_17 = 1, var1_17 do
		local var2_17 = arg0_17.rewardPanel:GetChild(iter1_17 - 1)
		local var3_17 = iter1_17 <= #var0_17

		setActive(var2_17, var3_17)

		if var3_17 then
			local var4_17 = var0_17[iter1_17]
			local var5_17 = {
				type = var4_17[1],
				id = var4_17[2],
				count = var4_17[3]
			}

			updateDrop(var2_17, var5_17)
			onButton(arg0_17, var2_17, function()
				arg0_17.viewComponent:emit(TaskMediator.ON_DROP, var5_17)
			end, SFX_PANEL)
		end
	end
end

function var0_0.DoSubmitAnim(arg0_19, arg1_19)
	local var0_19 = arg0_19.frame.localPosition

	LeanTween.alphaCanvas(arg0_19.cg, 0, var6_0):setFrom(1)
	LeanTween.value(go(arg0_19.frame), var0_19.x, var0_19.x + arg0_19._modelWidth, var6_0):setOnUpdate(System.Action_float(function(arg0_20)
		arg0_19.frame.transform.localPosition = Vector3(arg0_20, var0_19.y, var0_19.z)
	end)):setOnComplete(System.Action(function()
		arg0_19.frame.transform.localPosition = var0_19

		setActive(arg0_19.frame, false)
		arg1_19()
	end))
end

function var0_0.dispose(arg0_22)
	pg.DelegateInfo.Dispose(arg0_22)
end

return var0_0

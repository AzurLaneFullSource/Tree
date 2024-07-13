pg = pg or {}

local var0_0 = singletonClass("PerformMgr")

pg.PerformMgr = var0_0

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = 0
local var9_0 = 1
local var10_0 = 2

require("Mgr/Perform/Include")

local var11_0 = true

local function var12_0(...)
	if var11_0 and IsUnityEditor then
		originalPrint(...)
	end
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.status = var1_0
	arg0_2.playedList = {}
	arg0_2.playQueue = {}

	if arg1_2 then
		arg1_2()
	end
end

function var0_0.CheckLoad(arg0_3, arg1_3)
	seriesAsync({
		function(arg0_4)
			if not arg0_3._go then
				PoolMgr.GetInstance():GetUI("PerformUI", true, function(arg0_5)
					arg0_3._go = arg0_5
					arg0_3._tf = tf(arg0_3._go)
					arg0_3.UIOverlay = GameObject.Find("Overlay/UIOverlay")

					arg0_3._go.transform:SetParent(arg0_3.UIOverlay.transform, false)

					arg0_3.cpkPlayer = CpkPerformPlayer.New(findTF(arg0_3._tf, "window_cpk"))
					arg0_3.dialoguePlayer = DialoguePerformPlayer.New(findTF(arg0_3._tf, "window_dialogue"))
					arg0_3.picturePlayer = PictruePerformPlayer.New(findTF(arg0_3._tf, "window_picture"))
					arg0_3.storyPlayer = StoryPerformPlayer.New(findTF(arg0_3._tf, "window_story"))

					setActive(arg0_3._go, false)

					arg0_3.status = var2_0

					arg0_4()
				end)
			else
				arg0_4()
			end
		end
	}, function()
		if arg1_3 then
			arg1_3()
		end
	end)
end

function var0_0.PlayOne(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	assert(pg.child_performance[arg1_7], "child_performance not exist id: " .. arg1_7)

	if not arg0_7:CheckState() then
		var12_0("perform state error" .. arg0_7.status)

		return nil
	end

	var12_0("OnlyOne Play")
	arg0_7:Show()

	local function var0_7()
		arg0_7:Hide()

		if arg2_7 then
			arg2_7()
		end
	end

	arg0_7:play(arg1_7, var0_7, arg3_7, arg4_7)
end

function var0_0.PlayGroup(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		table.insert(var0_9, function(arg0_10)
			arg0_9:play(iter1_9, arg0_10, arg3_9, arg4_9)
		end)
	end

	arg0_9:Show()
	seriesAsync(var0_9, function(arg0_11)
		arg0_9:Hide()

		if arg2_9 then
			arg2_9()
		end
	end)
end

function var0_0.play(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	assert(pg.child_performance[arg1_12], "child_performance not exist id: " .. arg1_12)

	if not arg0_12:CheckState() then
		var12_0("perform state error" .. arg0_12.status)

		return nil
	end

	var12_0("Play Perform:", arg1_12)
	arg0_12:addTaskProgress(arg1_12)

	arg0_12.status = var4_0

	local function var0_12()
		arg0_12.status = var5_0

		if arg2_12 then
			arg2_12()
		end
	end

	local var1_12 = pg.child_performance[arg1_12]

	arg0_12:setWindowStatus(var1_12)
	switch(var1_12.type, {
		[EducateConst.PERFORM_TYPE_ANIM] = function()
			arg0_12.cpkPlayer:Play(var1_12, var0_12, arg4_12)
		end,
		[EducateConst.PERFORM_TYPE_WORD] = function()
			local var0_15 = setmetatable({
				drops = arg3_12 or {}
			}, {
				__index = var1_12
			})

			arg0_12.dialoguePlayer:Play(var0_15, var0_12)
		end,
		[EducateConst.PERFORM_TYPE_STORY] = function()
			arg0_12.storyPlayer:Play(var1_12, var0_12)
		end,
		[EducateConst.PERFORM_TYPE_PICTURE] = function()
			arg0_12.picturePlayer:Play(var1_12, var0_12, arg4_12)
		end
	})
end

function var0_0.addTaskProgress(arg0_18, arg1_18)
	local var0_18 = getProxy(EducateProxy):GetTaskProxy():GetPerformAddTasks(arg1_18)
	local var1_18 = {}
	local var2_18 = {}
	local var3_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if iter1_18:IsMind() then
			table.insert(var1_18, {
				progress = 1,
				task_id = iter1_18.id
			})
		end

		if iter1_18:IsTarget() then
			table.insert(var2_18, {
				progress = 1,
				task_id = iter1_18.id
			})
		end

		if iter1_18:IsMain() then
			table.insert(var3_18, {
				progress = 1,
				task_id = iter1_18.id
			})
		end
	end

	if #var1_18 > 0 then
		pg.m02:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_MIND,
			progresses = var1_18
		})
	end

	if #var2_18 > 0 then
		pg.m02:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_TARGET,
			progresses = var2_18
		})
	end

	if #var3_18 > 0 then
		pg.m02:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = EducateTask.STSTEM_TYPE_MAIN,
			progresses = var3_18
		})
	end
end

function var0_0.PlayGroupNoHide(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		table.insert(var0_19, function(arg0_20)
			arg0_19:play(iter1_19, arg0_20, arg3_19, arg4_19)
		end)
	end

	seriesAsync(var0_19, arg2_19)
end

function var0_0.setWindowStatus(arg0_21, arg1_21)
	setActive(arg0_21.cpkPlayer._tf, arg1_21.cpk_status == var10_0)
	setActive(arg0_21.dialoguePlayer._tf, arg1_21.dialogue_status == var10_0)
	setActive(arg0_21.picturePlayer._tf, arg1_21.picture_status == var10_0)
	setActive(arg0_21.storyPlayer._tf, arg1_21.story_status == var10_0)
end

function var0_0.CheckState(arg0_22)
	if arg0_22.status == var1_0 then
		return false
	end

	return true
end

function var0_0.IsRunning(arg0_23)
	return arg0_23.status == var3_0 or arg0_23.status == var4_0 or arg0_23.status == var5_0
end

function var0_0.Show(arg0_24)
	arg0_24:CheckLoad(function()
		arg0_24:_Show()
	end)
end

function var0_0._Show(arg0_26)
	arg0_26.status = var3_0

	setActive(arg0_26._go, true)
	arg0_26._tf:SetAsLastSibling()
end

function var0_0.Clear(arg0_27)
	arg0_27.cpkPlayer:Clear()
	arg0_27.dialoguePlayer:Clear()
	arg0_27.picturePlayer:Clear()
	arg0_27.storyPlayer:Clear()
end

function var0_0.Show(arg0_28)
	arg0_28:CheckLoad(function()
		arg0_28:_Show()
	end)
end

function var0_0.Hide(arg0_30)
	arg0_30:Clear()
	setActive(arg0_30._go, false)

	arg0_30.status = var6_0
end

function var0_0.Quit(arg0_31)
	arg0_31.status = var7_0
end

function var0_0.SetParamForUI(arg0_32, arg1_32)
	arg0_32:CheckLoad(function()
		arg0_32:_SetParamForUI(arg1_32)
	end)
end

function var0_0._SetParamForUI(arg0_34, arg1_34)
	local var0_34 = var0_0.UI_PARAM[arg1_34] or var0_0.UI_PARAM.Default

	arg0_34.cpkPlayer:SetUIParam(var0_34)
end

var0_0.UI_PARAM = {
	Default = {
		showCpkBg = true,
		sliderPos = {
			x = 0,
			y = 358
		},
		cpkPos = {
			x = 0,
			y = -25
		},
		cpkCoverPos = {
			x = 0,
			y = -380
		}
	},
	EducateSchedulePerformLayer = {
		showCpkBg = false,
		sliderPos = {
			x = 144,
			y = 344
		},
		cpkPos = {
			x = 144,
			y = -25
		},
		cpkCoverPos = {
			x = 144,
			y = -383
		}
	}
}

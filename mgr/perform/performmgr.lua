pg = pg or {}

local var0 = singletonClass("PerformMgr")

pg.PerformMgr = var0

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6
local var7 = 7
local var8 = 0
local var9 = 1
local var10 = 2

require("Mgr/Perform/Include")

local var11 = true

local function var12(...)
	if var11 and IsUnityEditor then
		originalPrint(...)
	end
end

function var0.Init(arg0, arg1)
	arg0.status = var1
	arg0.playedList = {}
	arg0.playQueue = {}

	if arg1 then
		arg1()
	end
end

function var0.CheckLoad(arg0, arg1)
	seriesAsync({
		function(arg0)
			if not arg0._go then
				PoolMgr.GetInstance():GetUI("PerformUI", true, function(arg0)
					arg0._go = arg0
					arg0._tf = tf(arg0._go)
					arg0.UIOverlay = GameObject.Find("Overlay/UIOverlay")

					arg0._go.transform:SetParent(arg0.UIOverlay.transform, false)

					arg0.cpkPlayer = CpkPerformPlayer.New(findTF(arg0._tf, "window_cpk"))
					arg0.dialoguePlayer = DialoguePerformPlayer.New(findTF(arg0._tf, "window_dialogue"))
					arg0.picturePlayer = PictruePerformPlayer.New(findTF(arg0._tf, "window_picture"))
					arg0.storyPlayer = StoryPerformPlayer.New(findTF(arg0._tf, "window_story"))

					setActive(arg0._go, false)

					arg0.status = var2

					arg0()
				end)
			else
				arg0()
			end
		end
	}, function()
		if arg1 then
			arg1()
		end
	end)
end

function var0.PlayOne(arg0, arg1, arg2, arg3, arg4)
	assert(pg.child_performance[arg1], "child_performance not exist id: " .. arg1)

	if not arg0:CheckState() then
		var12("perform state error" .. arg0.status)

		return nil
	end

	var12("OnlyOne Play")
	arg0:Show()

	local function var0()
		arg0:Hide()

		if arg2 then
			arg2()
		end
	end

	arg0:play(arg1, var0, arg3, arg4)
end

function var0.PlayGroup(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			arg0:play(iter1, arg0, arg3, arg4)
		end)
	end

	arg0:Show()
	seriesAsync(var0, function(arg0)
		arg0:Hide()

		if arg2 then
			arg2()
		end
	end)
end

function var0.play(arg0, arg1, arg2, arg3, arg4)
	assert(pg.child_performance[arg1], "child_performance not exist id: " .. arg1)

	if not arg0:CheckState() then
		var12("perform state error" .. arg0.status)

		return nil
	end

	var12("Play Perform:", arg1)
	arg0:addTaskProgress(arg1)

	arg0.status = var4

	local function var0()
		arg0.status = var5

		if arg2 then
			arg2()
		end
	end

	local var1 = pg.child_performance[arg1]

	arg0:setWindowStatus(var1)
	switch(var1.type, {
		[EducateConst.PERFORM_TYPE_ANIM] = function()
			arg0.cpkPlayer:Play(var1, var0, arg4)
		end,
		[EducateConst.PERFORM_TYPE_WORD] = function()
			local var0 = setmetatable({
				drops = arg3 or {}
			}, {
				__index = var1
			})

			arg0.dialoguePlayer:Play(var0, var0)
		end,
		[EducateConst.PERFORM_TYPE_STORY] = function()
			arg0.storyPlayer:Play(var1, var0)
		end,
		[EducateConst.PERFORM_TYPE_PICTURE] = function()
			arg0.picturePlayer:Play(var1, var0, arg4)
		end
	})
end

function var0.addTaskProgress(arg0, arg1)
	local var0 = getProxy(EducateProxy):GetTaskProxy():GetPerformAddTasks(arg1)
	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsMind() then
			table.insert(var1, {
				progress = 1,
				task_id = iter1.id
			})
		end

		if iter1:IsTarget() then
			table.insert(var2, {
				progress = 1,
				task_id = iter1.id
			})
		end

		if iter1:IsMain() then
			table.insert(var3, {
				progress = 1,
				task_id = iter1.id
			})
		end
	end

	if #var1 > 0 then
		pg.m02:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_MIND,
			progresses = var1
		})
	end

	if #var2 > 0 then
		pg.m02:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = EducateTask.SYSTEM_TYPE_TARGET,
			progresses = var2
		})
	end

	if #var3 > 0 then
		pg.m02:sendNotification(GAME.EDUCATE_ADD_TASK_PROGRESS, {
			system = EducateTask.STSTEM_TYPE_MAIN,
			progresses = var3
		})
	end
end

function var0.PlayGroupNoHide(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			arg0:play(iter1, arg0, arg3, arg4)
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.setWindowStatus(arg0, arg1)
	setActive(arg0.cpkPlayer._tf, arg1.cpk_status == var10)
	setActive(arg0.dialoguePlayer._tf, arg1.dialogue_status == var10)
	setActive(arg0.picturePlayer._tf, arg1.picture_status == var10)
	setActive(arg0.storyPlayer._tf, arg1.story_status == var10)
end

function var0.CheckState(arg0)
	if arg0.status == var1 then
		return false
	end

	return true
end

function var0.IsRunning(arg0)
	return arg0.status == var3 or arg0.status == var4 or arg0.status == var5
end

function var0.Show(arg0)
	arg0:CheckLoad(function()
		arg0:_Show()
	end)
end

function var0._Show(arg0)
	arg0.status = var3

	setActive(arg0._go, true)
	arg0._tf:SetAsLastSibling()
end

function var0.Clear(arg0)
	arg0.cpkPlayer:Clear()
	arg0.dialoguePlayer:Clear()
	arg0.picturePlayer:Clear()
	arg0.storyPlayer:Clear()
end

function var0.Show(arg0)
	arg0:CheckLoad(function()
		arg0:_Show()
	end)
end

function var0.Hide(arg0)
	arg0:Clear()
	setActive(arg0._go, false)

	arg0.status = var6
end

function var0.Quit(arg0)
	arg0.status = var7
end

function var0.SetParamForUI(arg0, arg1)
	arg0:CheckLoad(function()
		arg0:_SetParamForUI(arg1)
	end)
end

function var0._SetParamForUI(arg0, arg1)
	local var0 = var0.UI_PARAM[arg1] or var0.UI_PARAM.Default

	arg0.cpkPlayer:SetUIParam(var0)
end

var0.UI_PARAM = {
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

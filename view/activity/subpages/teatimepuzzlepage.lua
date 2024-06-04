local var0 = class("TeaTimePuzzlePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.total = 15
	arg0.Text = arg0:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0.container = arg0:findTF("AD/container")
	arg0.GOBtn = arg0:findTF("AD/go")
	arg0.got = arg0:findTF("AD/got")
end

function var0.OnFirstFlush(arg0)
	local var0 = arg0.activity:getData1List()
	local var1 = {}

	for iter0, iter1 in ipairs(var0 or {}) do
		local var2 = iter1 - 59800

		assert(var2 > 0, "puzzlaIndex should more than zero" .. iter1)
		table.insert(var1, var2)
	end

	local var3 = {}

	if arg0.activity:left4Day() then
		for iter2 = 1, arg0.total do
			table.insert(var3, pg.gametip["activity_puzzle_get" .. iter2].tip)
		end
	end

	local var4 = getProxy(TaskProxy)
	local var5 = getProxy(ActivityProxy)

	onButton(arg0, arg0.GOBtn, function()
		local var0 = var4:getTasks()
		local var1 = var5:getActivityById(ActivityConst.TEATIME_TW)

		if not var1 or var1:isEnd() then
			return
		end

		local var2 = var1:getConfig("config_data")
		local var3 = false

		for iter0, iter1 in pairs(var0) do
			if _.any(_.flatten(var2), function(arg0)
				return arg0 == iter1.id
			end) then
				var3 = true

				break
			end
		end

		if var3 then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = "activity"
			})
		else
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE)
		end
	end, SFX_PANEL)

	local var6 = var4:getTasks()
	local var7 = var5:getActivityById(ActivityConst.TEATIME_TW):isEnd()

	setActive(arg0.GOBtn, not var7)
	setActive(arg0.got, var7)

	arg0.Text.text = "<color=#A9F548FF>" .. #var1 .. "</color>/" .. arg0.total
	arg0.puzzlaView = PuzzlaView.New({
		bg = "bg_1",
		go = arg0.container,
		list = var1,
		descs = var3,
		fetch = arg0.activity.data1 == 1
	}, nil)

	function arg0.puzzlaView.onFinish()
		if arg0.activity.data1 ~= 1 then
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0.activity.id
			})
		end
	end
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)

	if arg0.puzzlaView then
		arg0.puzzlaView:dispose()
	end
end

return var0

local var0_0 = class("TeaTimePuzzlePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.total = 15
	arg0_1.Text = arg0_1:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0_1.container = arg0_1:findTF("AD/container")
	arg0_1.GOBtn = arg0_1:findTF("AD/go")
	arg0_1.got = arg0_1:findTF("AD/got")
end

function var0_0.OnFirstFlush(arg0_2)
	local var0_2 = arg0_2.activity:getData1List()
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(var0_2 or {}) do
		local var2_2 = iter1_2 - 59800

		assert(var2_2 > 0, "puzzlaIndex should more than zero" .. iter1_2)
		table.insert(var1_2, var2_2)
	end

	local var3_2 = {}

	if arg0_2.activity:left4Day() then
		for iter2_2 = 1, arg0_2.total do
			table.insert(var3_2, pg.gametip["activity_puzzle_get" .. iter2_2].tip)
		end
	end

	local var4_2 = getProxy(TaskProxy)
	local var5_2 = getProxy(ActivityProxy)

	onButton(arg0_2, arg0_2.GOBtn, function()
		local var0_3 = var4_2:getTasks()
		local var1_3 = var5_2:getActivityById(ActivityConst.TEATIME_TW)

		if not var1_3 or var1_3:isEnd() then
			return
		end

		local var2_3 = var1_3:getConfig("config_data")
		local var3_3 = false

		for iter0_3, iter1_3 in pairs(var0_3) do
			if _.any(_.flatten(var2_3), function(arg0_4)
				return arg0_4 == iter1_3.id
			end) then
				var3_3 = true

				break
			end
		end

		if var3_3 then
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
				page = "activity"
			})
		else
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE)
		end
	end, SFX_PANEL)

	local var6_2 = var4_2:getTasks()
	local var7_2 = var5_2:getActivityById(ActivityConst.TEATIME_TW):isEnd()

	setActive(arg0_2.GOBtn, not var7_2)
	setActive(arg0_2.got, var7_2)

	arg0_2.Text.text = "<color=#A9F548FF>" .. #var1_2 .. "</color>/" .. arg0_2.total
	arg0_2.puzzlaView = PuzzlaView.New({
		bg = "bg_1",
		go = arg0_2.container,
		list = var1_2,
		descs = var3_2,
		fetch = arg0_2.activity.data1 == 1
	}, nil)

	function arg0_2.puzzlaView.onFinish()
		if arg0_2.activity.data1 ~= 1 then
			arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.activity.id
			})
		end
	end
end

function var0_0.OnDestroy(arg0_6)
	clearImageSprite(arg0_6.bg)

	if arg0_6.puzzlaView then
		arg0_6.puzzlaView:dispose()
	end
end

return var0_0

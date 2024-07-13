local var0_0 = class("SandiegoReformPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.progress = arg0_1:findTF("progress/left", arg0_1.bg)
	arg0_1.gameBtn = arg0_1:findTF("start", arg0_1.bg)
	arg0_1.helpBtn = arg0_1:findTF("mic", arg0_1.bg)
	arg0_1.getSign = arg0_1:findTF("get", arg0_1.bg)
	arg0_1.days = arg0_1:findTF("days", arg0_1.bg)
	arg0_1.nums = arg0_1:findTF("count", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client")[1][1]

	if var0_2 ~= nil then
		pg.NewStoryMgr.GetInstance():Play(var0_2)
	end
end

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = arg0_3.activity
	local var1_3 = var0_3:getConfig("config_client")[3]

	setText(arg0_3.nums, _.reduce(_.slice(var1_3, 1, var0_3.data2), 0, function(arg0_4, arg1_4)
		return arg0_4 + arg1_4
	end))
	setActive(arg0_3.getSign, var0_3.data1 == 1)

	local var2_3 = var0_3:getConfig("config_data")[4]

	arg0_3.progress.sizeDelta = Vector2.New(10 + 90 * math.max(var0_3.data2 - 1, 0), arg0_3.progress.sizeDelta.y)

	local var3_3 = Color.New(1, 0.83, 0.15)
	local var4_3 = Color.New(0.59, 0.62, 0.69)

	for iter0_3 = 1, 7 do
		local var5_3 = arg0_3.days:Find(iter0_3)

		setTextColor(var5_3, iter0_3 <= var0_3.data2 and var3_3 or var4_3)
	end

	onButton(arg0_3, arg0_3.gameBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LINK_LINK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("link_link_help_tip")
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	return
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0

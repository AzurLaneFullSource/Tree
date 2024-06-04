local var0 = class("SandiegoReformPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.progress = arg0:findTF("progress/left", arg0.bg)
	arg0.gameBtn = arg0:findTF("start", arg0.bg)
	arg0.helpBtn = arg0:findTF("mic", arg0.bg)
	arg0.getSign = arg0:findTF("get", arg0.bg)
	arg0.days = arg0:findTF("days", arg0.bg)
	arg0.nums = arg0:findTF("count", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_client")[1][1]

	if var0 ~= nil then
		pg.NewStoryMgr.GetInstance():Play(var0)
	end
end

function var0.OnFirstFlush(arg0)
	local var0 = arg0.activity
	local var1 = var0:getConfig("config_client")[3]

	setText(arg0.nums, _.reduce(_.slice(var1, 1, var0.data2), 0, function(arg0, arg1)
		return arg0 + arg1
	end))
	setActive(arg0.getSign, var0.data1 == 1)

	local var2 = var0:getConfig("config_data")[4]

	arg0.progress.sizeDelta = Vector2.New(10 + 90 * math.max(var0.data2 - 1, 0), arg0.progress.sizeDelta.y)

	local var3 = Color.New(1, 0.83, 0.15)
	local var4 = Color.New(0.59, 0.62, 0.69)

	for iter0 = 1, 7 do
		local var5 = arg0.days:Find(iter0)

		setTextColor(var5, iter0 <= var0.data2 and var3 or var4)
	end

	onButton(arg0, arg0.gameBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LINK_LINK)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("link_link_help_tip")
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0

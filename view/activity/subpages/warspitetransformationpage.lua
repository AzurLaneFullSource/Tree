local var0 = class("WarspiteTransformationPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD", arg0._tf)
	arg0.btn = arg0:findTF("battle_btn", arg0.bg)
	arg0.tip = arg0:findTF("help", arg0.bg)
	arg0.mainAward = arg0:findTF("award", arg0.bg)
	arg0.subAwards = CustomIndexLayer.Clone2Full(arg0:findTF("list", arg0.bg), 7)
	arg0.step = arg0:findTF("receivetimes", arg0.bg)
	arg0.score = arg0:findTF("highscore", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity

	if var0.data4 == 0 and var0.data2 >= 7 then
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 3,
			activity_id = var0.id
		})

		return true
	elseif defaultValue(var0.data2_list[1], 0) > 0 or defaultValue(var0.data2_list[2], 0) > 0 then
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = var0.id
		})

		return true
	end
end

function var0.OnFirstFlush(arg0)
	local var0 = arg0.activity
	local var1 = var0:getConfig("config_client")[2]
	local var2 = {
		type = var1[1],
		id = var1[2],
		count = var1[3]
	}

	onButton(arg0, arg0.mainAward, function()
		arg0:emit(BaseUI.ON_DROP, var2)
	end, SFX_PANEL)

	for iter0 = 1, 7 do
		local var3 = arg0.subAwards[iter0]
		local var4 = var0:getConfig("config_client")[1]
		local var5 = {
			type = var4[1],
			id = var4[2],
			count = var4[3]
		}

		onButton(arg0, var3, function()
			arg0:emit(BaseUI.ON_DROP, var5)
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.tip, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.goldship_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.btn, function()
		arg0:emit(ActivityMediator.GO_DODGEM)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = var1:DiffDay(var0.data1, var1:GetServerTime()) + 1

	setActive(findTF(arg0.mainAward, "get"), var0.data4 > 0)

	for iter0 = 1, 7 do
		local var3 = arg0.subAwards[iter0]

		setActive(findTF(var3, "get"), iter0 <= var0.data2)
		setActive(findTF(var3, "lock"), var2 < iter0)
	end

	setText(arg0.step, var0.data2)
	setText(arg0.score, var0.data1_list[1])
end

return var0

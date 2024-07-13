local var0_0 = class("USSkirmishPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1:initUI()
	arg0_1:initData()
	arg0_1:addListener()
end

function var0_0.OnFirstFlush(arg0_2)
	return
end

function var0_0.OnUpdateFlush(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.taskVOList) do
		local var0_3 = iter1_3.state
		local var1_3 = arg0_3.progress:GetChild(iter0_3 - 1)
		local var2_3 = arg0_3:findTF("Empty", var1_3)
		local var3_3 = arg0_3:findTF("Full", var1_3)

		if var0_3 < SkirmishVO.StateClear then
			setActive(var2_3, true)
			setActive(var3_3, false)
		else
			setActive(var2_3, false)
			setActive(var3_3, true)
		end
	end
end

function var0_0.initUI(arg0_4)
	arg0_4.bg = arg0_4:findTF("AD")
	arg0_4.progress = arg0_4:findTF("Progress")
	arg0_4.helpBtn = arg0_4:findTF("HelpBtn")
	arg0_4.battleBtn = arg0_4:findTF("BattleBtn")
end

function var0_0.initData(arg0_5)
	arg0_5.taskGroup = Clone(pg.activity_template[ActivityConst.ACTIVITY_ID_US_SKIRMISH].config_data)
	arg0_5.taskCount = #arg0_5.taskGroup
	arg0_5.skirmishProxy = getProxy(SkirmishProxy)

	arg0_5.skirmishProxy:UpdateSkirmishProgress()

	arg0_5.taskVOList = Clone(arg0_5.skirmishProxy.data)
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6.helpBtn, function()
		if pg.gametip.help_tempesteve then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.help_tempesteve.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.battleBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			mapIdx = SkirmishProxy.SkirmishMap
		})
	end, SFX_PANEL)
end

return var0_0

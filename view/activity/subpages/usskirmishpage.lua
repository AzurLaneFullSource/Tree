local var0 = class("USSkirmishPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0:initUI()
	arg0:initData()
	arg0:addListener()
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	for iter0, iter1 in ipairs(arg0.taskVOList) do
		local var0 = iter1.state
		local var1 = arg0.progress:GetChild(iter0 - 1)
		local var2 = arg0:findTF("Empty", var1)
		local var3 = arg0:findTF("Full", var1)

		if var0 < SkirmishVO.StateClear then
			setActive(var2, true)
			setActive(var3, false)
		else
			setActive(var2, false)
			setActive(var3, true)
		end
	end
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.progress = arg0:findTF("Progress")
	arg0.helpBtn = arg0:findTF("HelpBtn")
	arg0.battleBtn = arg0:findTF("BattleBtn")
end

function var0.initData(arg0)
	arg0.taskGroup = Clone(pg.activity_template[ActivityConst.ACTIVITY_ID_US_SKIRMISH].config_data)
	arg0.taskCount = #arg0.taskGroup
	arg0.skirmishProxy = getProxy(SkirmishProxy)

	arg0.skirmishProxy:UpdateSkirmishProgress()

	arg0.taskVOList = Clone(arg0.skirmishProxy.data)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.helpBtn, function()
		if pg.gametip.help_tempesteve then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.help_tempesteve.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			mapIdx = SkirmishProxy.SkirmishMap
		})
	end, SFX_PANEL)
end

return var0

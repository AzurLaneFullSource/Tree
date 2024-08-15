local var0_0 = class("CowboyTownBackHillScene", import("..TemplateMV.BackHillTemplate"))

function var0_0.getUIName(arg0_1)
	return "CowboyTownBackHillUI"
end

function var0_0.didEnter(arg0_2)
	onButton(arg0_2, arg0_2:findTF("top/btn_back"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_2, arg0_2:findTF("top/btn_home"), function()
		arg0_2:emit(var0_0.ON_HOME)
	end)
	onButton(arg0_2, arg0_2:findTF("top/info/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["0815_main_help"].tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("btn/btn_game"), function()
		arg0_2:emit(CowboyTownMediator.MINI_GAME)
	end)
	onButton(arg0_2, arg0_2:findTF("btn/btn_skin"), function()
		arg0_2:emit(CowboyTownMediator.SKIN)
	end)
	onButton(arg0_2, arg0_2:findTF("btn/btn_expansion"), function()
		arg0_2:emit(CowboyTownMediator.EXPANSION)
	end)
	onButton(arg0_2, arg0_2:findTF("btn/btn_task"), function()
		arg0_2:emit(CowboyTownMediator.TASK)
	end)
	onButton(arg0_2, arg0_2:findTF("btn/btn_story"), function()
		arg0_2:emit(CowboyTownMediator.STORY)
	end)
	arg0_2:UpdateView()
end

function var0_0.UpdateView(arg0_11)
	setActive(arg0_11:findTF("btn/btn_game/tip"), var0_0.MiniGameTip())
	setActive(arg0_11:findTF("btn/btn_expansion/tip"), var0_0.ExpansionTips())
	arg0_11:UpdateTaskTips()
	arg0_11:UpdateStoryView()
end

function var0_0.IsShowMainTip(arg0_12)
	return var0_0.MiniGameTip() or var0_0.ExpansionTips() or SixYearUsTaskMediator.GetTaskRedTip() or var0_0.StoryTips()
end

function var0_0.UpdateStoryView(arg0_13)
	setActive(arg0_13:findTF("btn/btn_story/tip"), var0_0.StoryTips())
end

function var0_0.UpdateActivity(arg0_14, arg1_14)
	return
end

function var0_0.MiniGameTip()
	return getProxy(MiniGameProxy):GetHubByGameId(CowboyTownMediator.MINI_GAME_ID).count > 0
end

function var0_0.ExpansionTips()
	return TownScene.ShowEntranceTip()
end

function var0_0.UpdateTaskTips(arg0_17)
	setActive(arg0_17:findTF("btn/btn_task/tip"), SixYearUsTaskMediator.GetTaskRedTip())
end

function var0_0.StoryTips()
	if getProxy(ActivityProxy):getActivityById(5535).data1 > 0 then
		return true
	end

	return false
end

return var0_0

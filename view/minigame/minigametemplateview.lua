local var0_0 = class("MiniGameTemplateView", import("view.miniGame.BaseMiniGameView"))

var0_0.canSelectStage = true

function var0_0.getUIName(arg0_1)
	return nil
end

function var0_0.getGameController(arg0_2)
	return nil
end

function var0_0.getShowSide(arg0_3)
	return true
end

function var0_0.updateMainUI(arg0_4)
	if arg0_4:getShowSide() then
		local var0_4 = arg0_4:GetMGHubData()
		local var1_4 = var0_4:getConfig("reward_need")
		local var2_4 = var0_4.usedtime
		local var3_4 = var2_4 + var0_4.count
		local var4_4 = math.min(var0_4.usedtime + 1, var3_4)
		local var5_4 = arg0_4.itemList.container
		local var6_4 = var5_4.childCount

		for iter0_4 = 1, var6_4 do
			local var7_4 = {}

			if iter0_4 <= var2_4 then
				var7_4.finish = true
			elseif iter0_4 <= var3_4 then
				-- block empty
			else
				var7_4.lock = true
			end

			local var8_4 = var5_4:GetChild(iter0_4 - 1)

			setActive(var8_4:Find("finish"), var7_4.finish)
			setActive(var8_4:Find("lock"), var7_4.lock)
			setToggleEnabled(var8_4, arg0_4.canSelectStage and iter0_4 <= var4_4)
			triggerToggle(var8_4, iter0_4 == var4_4)
		end

		local var9_4 = var5_4:GetChild(0).anchoredPosition.y - var5_4:GetChild(var4_4 - 1).anchoredPosition.y
		local var10_4 = var5_4.rect.height
		local var11_4 = var5_4:GetComponent(typeof(ScrollRect)).viewport.rect.height
		local var12_4 = math.clamp(var9_4, 0, var10_4 - var11_4) / (var10_4 - var11_4)

		scrollTo(var5_4, nil, 1 - var12_4)
	end

	arg0_4:checkGet()
end

function var0_0.checkGet(arg0_5)
	local var0_5 = arg0_5:GetMGHubData()

	if var0_5.ultimate == 0 then
		if var0_5.usedtime < var0_5:getConfig("reward_need") then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_5.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.initPageUI(arg0_6)
	arg0_6.rtTitlePage = arg0_6._tf:Find("TitlePage")

	local var0_6 = arg0_6.rtTitlePage:Find("main")

	onButton(arg0_6, var0_6:Find("btn_back"), function()
		arg0_6:closeView()
	end, SFX_CANCEL)
	onButton(arg0_6, var0_6:Find("btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["2023spring_minigame_help"].tip
		})
	end, SFX_PANEL)

	local var1_6 = arg0_6:GetMGData():GetSimpleValue("story")

	onButton(arg0_6, var0_6:Find("btn_start"), function()
		local var0_9 = {}
		local var1_9 = checkExist(var1_6, {
			arg0_6.stageIndex
		}, {
			1
		})

		if var1_9 then
			table.insert(var0_9, function(arg0_10)
				pg.NewStoryMgr.GetInstance():Play(var1_9, arg0_10)
			end)
		end

		seriesAsync(var0_9, function()
			arg0_6:openUI("countdown")
		end)
	end, SFX_PANEL)

	arg0_6.stageIndex = 0

	if arg0_6:getShowSide() then
		local var2_6 = pg.mini_game[arg0_6:GetMGData().id].simple_config_data.drop
		local var3_6 = var0_6:Find("side_panel/award/content")

		arg0_6.itemList = UIItemList.New(var3_6, var3_6:GetChild(0))

		arg0_6.itemList:make(function(arg0_12, arg1_12, arg2_12)
			arg1_12 = arg1_12 + 1

			if arg0_12 == UIItemList.EventUpdate then
				local var0_12 = arg2_12:Find("IconTpl")
				local var1_12 = {}

				var1_12.type, var1_12.id, var1_12.count = unpack(var2_6[arg1_12])

				updateDrop(var0_12, var1_12)
				onButton(arg0_6, var0_12, function()
					arg0_6:emit(var0_0.ON_DROP, var1_12)
				end, SFX_PANEL)
				onToggle(arg0_6, arg2_12, function(arg0_14)
					if arg0_14 then
						arg0_6.stageIndex = arg1_12
					end
				end)
			end
		end)
		arg0_6.itemList:align(#var2_6)
	end

	arg0_6.rtTitlePage:Find("countdown"):Find("bg/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_6:openUI()
		arg0_6.gameController:StartGame()
	end)

	local var4_6 = arg0_6.rtTitlePage:Find("pause")

	onButton(arg0_6, var4_6:Find("window/btn_confirm"), function()
		arg0_6:openUI()
		arg0_6.gameController:ResumeGame()
	end, SFX_CONFIRM)

	local var5_6 = arg0_6.rtTitlePage:Find("exit")

	onButton(arg0_6, var5_6:Find("window/btn_cancel"), function()
		arg0_6:openUI()
		arg0_6.gameController:ResumeGame()
	end, SFX_CANCEL)
	onButton(arg0_6, var5_6:Find("window/btn_confirm"), function()
		arg0_6:openUI()
		arg0_6.gameController:EndGame()
	end, SFX_CONFIRM)

	local var6_6 = arg0_6.rtTitlePage:Find("result")

	onButton(arg0_6, var6_6:Find("window/btn_finish"), function()
		arg0_6:openUI("main")
	end, SFX_CONFIRM)
end

function var0_0.initControllerUI(arg0_20)
	local var0_20 = arg0_20._tf:Find("Controller/top")

	onButton(arg0_20, var0_20:Find("btn_back"), function()
		arg0_20:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0_20, var0_20:Find("btn_pause"), function()
		arg0_20:openUI("pause")
	end)
end

function var0_0.SaveDataChange(arg0_23, arg1_23)
	arg0_23:StoreDataToServer(arg1_23)
end

function var0_0.didEnter(arg0_24)
	arg0_24:initPageUI()
	arg0_24:initControllerUI()

	arg0_24.gameController = arg0_24:getGameController().New(arg0_24, arg0_24._tf)

	arg0_24:openUI("main")
end

function var0_0.initOpenUISwich(arg0_25)
	arg0_25.openSwitchDic = {
		main = function()
			arg0_25:updateMainUI()
		end,
		pause = function()
			arg0_25.gameController:PauseGame()
		end,
		exit = function()
			arg0_25.gameController:PauseGame()
		end,
		result = function()
			local var0_29 = arg0_25:GetMGData():GetRuntimeData("elements") or {}
			local var1_29 = arg0_25.gameController.point
			local var2_29 = var0_29[1] or 0
			local var3_29 = arg0_25.rtTitlePage:Find("result")

			setActive(var3_29:Find("window/now/new"), var2_29 < var1_29)

			if var2_29 <= var1_29 then
				var2_29 = var1_29
				var0_29[1] = var1_29
			end

			arg0_25:SaveDataChange(var0_29)
			setText(var3_29:Find("window/high/Text"), var2_29)
			setText(var3_29:Find("window/now/Text"), var1_29)

			local var4_29 = arg0_25:GetMGHubData()

			if (not arg0_25:getShowSide() or arg0_25.stageIndex == var4_29.usedtime + 1) and var4_29.count > 0 then
				arg0_25:SendSuccess(0)
			end
		end
	}
end

function var0_0.openUI(arg0_30, arg1_30)
	if not arg0_30.openSwitchDic then
		arg0_30:initOpenUISwich()
	end

	if arg0_30.status then
		setActive(arg0_30.rtTitlePage:Find(arg0_30.status), false)
	end

	if arg1_30 then
		setActive(arg0_30.rtTitlePage:Find(arg1_30), true)
	end

	arg0_30.status = arg1_30

	switch(arg1_30, arg0_30.openSwitchDic)
end

function var0_0.initBackPressSwitch(arg0_31)
	arg0_31.backPressSwitchDic = {
		main = function()
			var0_0.super.onBackPressed(arg0_31)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0_31:openUI()
			arg0_31.gameController:ResumeGame()
		end,
		exit = function()
			arg0_31:openUI()
			arg0_31.gameController:ResumeGame()
		end,
		result = function()
			return
		end
	}
end

function var0_0.onBackPressed(arg0_37)
	if not arg0_37.backPressSwitchDic then
		arg0_37:initBackPressSwitch()
	end

	switch(arg0_37.status, arg0_37.backPressSwitchDic, function()
		assert(arg0_37.gameController.isStart)
		arg0_37:openUI("pause")
	end)
end

function var0_0.willExit(arg0_39)
	return
end

return var0_0

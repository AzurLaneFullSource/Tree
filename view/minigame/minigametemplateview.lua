local var0 = class("MiniGameTemplateView", import("view.miniGame.BaseMiniGameView"))

var0.canSelectStage = true

function var0.getUIName(arg0)
	return nil
end

function var0.getGameController(arg0)
	return nil
end

function var0.getShowSide(arg0)
	return true
end

function var0.updateMainUI(arg0)
	if arg0:getShowSide() then
		local var0 = arg0:GetMGHubData()
		local var1 = var0:getConfig("reward_need")
		local var2 = var0.usedtime
		local var3 = var2 + var0.count
		local var4 = math.min(var0.usedtime + 1, var3)
		local var5 = arg0.itemList.container
		local var6 = var5.childCount

		for iter0 = 1, var6 do
			local var7 = {}

			if iter0 <= var2 then
				var7.finish = true
			elseif iter0 <= var3 then
				-- block empty
			else
				var7.lock = true
			end

			local var8 = var5:GetChild(iter0 - 1)

			setActive(var8:Find("finish"), var7.finish)
			setActive(var8:Find("lock"), var7.lock)
			setToggleEnabled(var8, arg0.canSelectStage and iter0 <= var4)
			triggerToggle(var8, iter0 == var4)
		end

		local var9 = var5:GetChild(0).anchoredPosition.y - var5:GetChild(var4 - 1).anchoredPosition.y
		local var10 = var5.rect.height
		local var11 = var5:GetComponent(typeof(ScrollRect)).viewport.rect.height
		local var12 = math.clamp(var9, 0, var10 - var11) / (var10 - var11)

		scrollTo(var5, nil, 1 - var12)
	end

	arg0:checkGet()
end

function var0.checkGet(arg0)
	local var0 = arg0:GetMGHubData()

	if var0.ultimate == 0 then
		if var0.usedtime < var0:getConfig("reward_need") then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.initPageUI(arg0)
	arg0.rtTitlePage = arg0._tf:Find("TitlePage")

	local var0 = arg0.rtTitlePage:Find("main")

	onButton(arg0, var0:Find("btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, var0:Find("btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["2023spring_minigame_help"].tip
		})
	end, SFX_PANEL)

	local var1 = arg0:GetMGData():GetSimpleValue("story")

	onButton(arg0, var0:Find("btn_start"), function()
		local var0 = {}
		local var1 = checkExist(var1, {
			arg0.stageIndex
		}, {
			1
		})

		if var1 then
			table.insert(var0, function(arg0)
				pg.NewStoryMgr.GetInstance():Play(var1, arg0)
			end)
		end

		seriesAsync(var0, function()
			arg0:openUI("countdown")
		end)
	end, SFX_PANEL)

	arg0.stageIndex = 0

	if arg0:getShowSide() then
		local var2 = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop
		local var3 = var0:Find("side_panel/award/content")

		arg0.itemList = UIItemList.New(var3, var3:GetChild(0))

		arg0.itemList:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				local var0 = arg2:Find("IconTpl")
				local var1 = {}

				var1.type, var1.id, var1.count = unpack(var2[arg1])

				updateDrop(var0, var1)
				onButton(arg0, var0, function()
					arg0:emit(var0.ON_DROP, var1)
				end, SFX_PANEL)
				onToggle(arg0, arg2, function(arg0)
					if arg0 then
						arg0.stageIndex = arg1
					end
				end)
			end
		end)
		arg0.itemList:align(#var2)
	end

	arg0.rtTitlePage:Find("countdown"):Find("bg/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:openUI()
		arg0.gameController:StartGame()
	end)

	local var4 = arg0.rtTitlePage:Find("pause")

	onButton(arg0, var4:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0.gameController:ResumeGame()
	end, SFX_CONFIRM)

	local var5 = arg0.rtTitlePage:Find("exit")

	onButton(arg0, var5:Find("window/btn_cancel"), function()
		arg0:openUI()
		arg0.gameController:ResumeGame()
	end, SFX_CANCEL)
	onButton(arg0, var5:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0.gameController:EndGame()
	end, SFX_CONFIRM)

	local var6 = arg0.rtTitlePage:Find("result")

	onButton(arg0, var6:Find("window/btn_finish"), function()
		arg0:openUI("main")
	end, SFX_CONFIRM)
end

function var0.initControllerUI(arg0)
	local var0 = arg0._tf:Find("Controller/top")

	onButton(arg0, var0:Find("btn_back"), function()
		arg0:openUI("exit")
	end, SFX_PANEL)
	onButton(arg0, var0:Find("btn_pause"), function()
		arg0:openUI("pause")
	end)
end

function var0.SaveDataChange(arg0, arg1)
	arg0:StoreDataToServer(arg1)
end

function var0.didEnter(arg0)
	arg0:initPageUI()
	arg0:initControllerUI()

	arg0.gameController = arg0:getGameController().New(arg0, arg0._tf)

	arg0:openUI("main")
end

function var0.initOpenUISwich(arg0)
	arg0.openSwitchDic = {
		main = function()
			arg0:updateMainUI()
		end,
		pause = function()
			arg0.gameController:PauseGame()
		end,
		exit = function()
			arg0.gameController:PauseGame()
		end,
		result = function()
			local var0 = arg0:GetMGData():GetRuntimeData("elements") or {}
			local var1 = arg0.gameController.point
			local var2 = var0[1] or 0
			local var3 = arg0.rtTitlePage:Find("result")

			setActive(var3:Find("window/now/new"), var2 < var1)

			if var2 <= var1 then
				var2 = var1
				var0[1] = var1
			end

			arg0:SaveDataChange(var0)
			setText(var3:Find("window/high/Text"), var2)
			setText(var3:Find("window/now/Text"), var1)

			local var4 = arg0:GetMGHubData()

			if (not arg0:getShowSide() or arg0.stageIndex == var4.usedtime + 1) and var4.count > 0 then
				arg0:SendSuccess(0)
			end
		end
	}
end

function var0.openUI(arg0, arg1)
	if not arg0.openSwitchDic then
		arg0:initOpenUISwich()
	end

	if arg0.status then
		setActive(arg0.rtTitlePage:Find(arg0.status), false)
	end

	if arg1 then
		setActive(arg0.rtTitlePage:Find(arg1), true)
	end

	arg0.status = arg1

	switch(arg1, arg0.openSwitchDic)
end

function var0.initBackPressSwitch(arg0)
	arg0.backPressSwitchDic = {
		main = function()
			var0.super.onBackPressed(arg0)
		end,
		countdown = function()
			return
		end,
		pause = function()
			arg0:openUI()
			arg0.gameController:ResumeGame()
		end,
		exit = function()
			arg0:openUI()
			arg0.gameController:ResumeGame()
		end,
		result = function()
			return
		end
	}
end

function var0.onBackPressed(arg0)
	if not arg0.backPressSwitchDic then
		arg0:initBackPressSwitch()
	end

	switch(arg0.status, arg0.backPressSwitchDic, function()
		assert(arg0.gameController.isStart)
		arg0:openUI("pause")
	end)
end

function var0.willExit(arg0)
	return
end

return var0

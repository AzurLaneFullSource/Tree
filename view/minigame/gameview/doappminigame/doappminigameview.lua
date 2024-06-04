local var0 = class("DOAPPMiniGameView", import("view.miniGame.MiniGameTemplateView"))

var0.canSelectStage = false

function var0.getUIName(arg0)
	return "DOAPPMiniGameUI"
end

function var0.getGameController(arg0)
	return DOAPPMiniGameController
end

function var0.initPageUI(arg0)
	var0.super.initPageUI(arg0)
	onButton(arg0, arg0.rtTitlePage:Find("main/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.doa_minigame_help.tip
		})
	end, SFX_PANEL)

	local var0 = arg0:GetMGData():GetSimpleValue("story")

	onButton(arg0, arg0.rtTitlePage:Find("main/btn_start"), function()
		local var0 = {}
		local var1 = checkExist(var0, {
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
			arg0:openUI("select")
		end)
	end, SFX_PANEL)

	local var1 = arg0.rtTitlePage:Find("select")

	onButton(arg0, var1:Find("btn_back"), function()
		arg0:openUI("main")
	end, SFX_CANCEL)
	onButton(arg0, var1:Find("btn/confirm"), function()
		if not arg0.character then
			pg.TipsMgr.GetInstance():ShowTips("without selected character")

			return
		end

		arg0.gameController:ResetGame()
		arg0.gameController:ReadyGame({
			name = arg0.character
		})
		arg0:openUI("countdown")
	end, SFX_CONFIRM)
	eachChild(var1:Find("content"), function(arg0)
		setText(arg0:Find("name/Text"), i18n("doa_minigame_" .. arg0.name))
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				arg0.character = arg0.name

				setAnchoredPosition(arg0:Find(arg0.name), {
					x = 70
				})
				quickPlayAnimator(arg0:Find(arg0.name .. "/Image"), "Win")
			else
				if arg0.character == arg0.name then
					arg0.character = nil
				end

				setAnchoredPosition(arg0:Find(arg0.name), {
					x = 110
				})
				quickPlayAnimator(arg0:Find(arg0.name .. "/Image"), "Idle")
			end
		end, SFX_PANEL)
	end)
end

local function var1(arg0, arg1, arg2, arg3)
	eachChild(arg0:Find("mask"), function(arg0)
		setActive(arg0, arg0.name == arg1)
	end)
	setText(arg0:Find("name/Text"), i18n("doa_minigame_" .. arg1))
	eachChild(arg0:Find("name/Text"), function(arg0)
		setActive(arg0, arg0.name == arg1)
	end)
	setActive(arg0:Find("result/lose"), arg3 < 0)
	setActive(arg0:Find("result/win"), arg3 > 0)
	eachChild(arg0:Find("point"), function(arg0)
		setActive(arg0, tonumber(arg0.name) <= arg2)
	end)
end

function var0.initOpenUISwich(arg0)
	var0.super.initOpenUISwich(arg0)

	function arg0.openSwitchDic.result()
		var1(arg0.rtTitlePage:Find("result/window/self"), arg0.gameController:GetResultInfo(false))
		var1(arg0.rtTitlePage:Find("result/window/other"), arg0.gameController:GetResultInfo(true))

		local var0 = arg0:GetMGHubData()

		if arg0.stageIndex == var0.usedtime + 1 and var0.count > 0 then
			arg0:SendSuccess(0)
		end
	end

	function arg0.openSwitchDic.select()
		triggerToggle(arg0.rtTitlePage:Find("select/content/Marie"), true)
	end
end

function var0.initBackPressSwitch(arg0)
	var0.super.initBackPressSwitch(arg0)

	function arg0.backPressSwitchDic.select()
		arg0:openUI("main")
	end
end

function var0.willExit(arg0)
	arg0.gameController:willExit()
end

return var0

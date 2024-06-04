local var0 = class("LaunchBallGameMenuUI")

var0.player_item = {
	{
		skill_1_desc = "launch_ball_hatsuduki_skill_1_desc",
		name = "Hatsuduki",
		skill_1 = "launch_ball_hatsuduki_skill_1",
		skill_2 = "launch_ball_hatsuduki_skill_2",
		id = 1,
		skill_2_desc = "launch_ball_hatsuduki_skill_2_desc"
	},
	{
		skill_1_desc = "launch_ball_shinano_skill_1_desc",
		name = "Shinano",
		skill_1 = "launch_ball_shinano_skill_1",
		skill_2 = "launch_ball_shinano_skill_2",
		id = 2,
		skill_2_desc = "launch_ball_shinano_skill_2_desc"
	},
	{
		skill_1_desc = "launch_ball_yura_skill_1_desc",
		name = "Yura",
		skill_1 = "launch_ball_yura_skill_1",
		skill_2 = "launch_ball_yura_skill_2",
		id = 3,
		skill_2_desc = "launch_ball_yura_skill_2_desc"
	},
	{
		skill_1_desc = "launch_ball_shimakaze_skill_1_desc",
		name = "Shimakaze",
		skill_1 = "launch_ball_shimakaze_skill_1",
		skill_2 = "launch_ball_shimakaze_skill_2",
		id = 4,
		skill_2_desc = "launch_ball_shimakaze_skill_2_desc"
	}
}
var0.skill_detail_desc = "launch_ball_skill_desc"

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0.menuUI = findTF(arg0._tf, "ui/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = LaunchBallGameVo.total_times
	arg0.battleItems = {}
	arg0.dropItems = {}

	onButton(arg0._event, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnBack"), function()
		arg0._event:emit(BeachGuardGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.menuUI, "btnRule"), function()
		arg0._event:emit(BeachGuardGameView.SHOW_RULE)
	end, SFX_CANCEL)

	arg0.btnStart = findTF(arg0.menuUI, "btnStart")

	onButton(arg0._event, findTF(arg0.menuUI, "btnStart"), function()
		if arg0.playerId == nil then
			return
		end

		arg0._event:emit(BeachGuardGameView.READY_START)
	end, SFX_CANCEL)

	local var0 = findTF(arg0.menuUI, "tplBattleItem")

	for iter0 = 1, 7 do
		local var1 = tf(instantiate(var0))

		var1.name = "battleItem_" .. iter0

		setParent(var1, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var2 = iter0
		local var3 = findTF(var1, "icon")

		onButton(arg0._event, var3, function()
			return
		end, SFX_PANEL)
		table.insert(arg0.dropItems, var3)
		setActive(var1, true)
		table.insert(arg0.battleItems, var1)
	end

	arg0.players = {}

	for iter1 = 1, #var0.player_item do
		local var4 = var0.player_item[iter1]
		local var5 = findTF(arg0.menuUI, "player/" .. var4.name)
		local var6 = LaunchBallActivityMgr.GetPlayerZhuanshuIndex(var4.id)
		local var7 = false

		if var6 then
			var7 = LaunchBallActivityMgr.CheckZhuanShuAble(ActivityConst.MINIGAME_ZUMA, var6)
		else
			var7 = true
		end

		setActive(findTF(var5, "ad/mask"), not var7)
		setScrollText(findTF(var5, "ad/skillPanel/skill1/text"), i18n(var4.skill_1))
		setScrollText(findTF(var5, "ad/skillPanel/skill2/text"), i18n(var4.skill_2))
		setText(findTF(var5, "ad/skillPanel/detail/img"), i18n(var0.skill_detail_desc))

		local var8 = GetComponent(findTF(var5, "ad/icon"), typeof(Animator))

		onButton(arg0._event, findTF(var5, "ad/click"), function()
			if not var7 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZUMA_PT_SHOP)

				return
			end

			if arg0.playerId == var4.id then
				arg0:selectPlayer(nil)
			else
				arg0:selectPlayer(var4.id)
			end
		end, SFX_CONFIRM)
		onButton(arg0._event, findTF(var5, "ad/skillPanel"), function()
			arg0:showSkillPanel(var4)
			setActive(arg0.skillDetailPanel, true)
		end, SFX_CONFIRM)
		table.insert(arg0.players, {
			tf = var5,
			data = var4,
			anim = var8
		})
	end

	arg0.skillDetailPanel = findTF(arg0.menuUI, "skillDetail")

	setActive(arg0.skillDetailPanel, false)
	onButton(arg0._event, findTF(arg0.skillDetailPanel, "ad"), function()
		setActive(arg0.skillDetailPanel, false)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0.skillDetailPanel, "ad/btnOk"), function()
		setActive(arg0.skillDetailPanel, false)
	end, SFX_CANCEL)

	arg0.selectMask = findTF(arg0.menuUI, "selectMask")

	setText(findTF(arg0.menuUI, "select"), i18n(LaunchBallGameVo.launchball_minigame_select))
	setText(findTF(arg0.menuUI, "selectMask/unSelect"), i18n(LaunchBallGameVo.launchball_minigame_un_select))
	arg0:selectPlayer(nil)
end

function var0.selectPlayer(arg0, arg1)
	for iter0 = 1, #arg0.players do
		if arg0.players[iter0].data.id == arg1 then
			setActive(findTF(arg0.players[iter0].tf, "ad/select"), true)
			arg0.players[iter0].anim:Play("Attack")
		else
			setActive(findTF(arg0.players[iter0].tf, "ad/select"), false)
			arg0.players[iter0].anim:Play("Idle")
		end
	end

	arg0.playerId = arg1

	LaunchBallGameVo.SetPlayer(arg0.playerId)

	if arg0.playerId == nil then
		setActive(arg0.btnStart, false)
		setActive(arg0.selectMask, false)
		setActive(findTF(arg0.menuUI, "select"), true)
	else
		setActive(arg0.btnStart, true)
		setActive(arg0.selectMask, true)
		setActive(findTF(arg0.menuUI, "select"), false)
	end
end

function var0.showSkillPanel(arg0, arg1)
	local var0 = i18n(arg1.skill_1)
	local var1 = i18n(arg1.skill_1_desc)
	local var2 = i18n(arg1.skill_2)
	local var3 = i18n(arg1.skill_2_desc)

	if var0 then
		setText(findTF(arg0.skillDetailPanel, "ad/skill1Bg/skill1Name"), var0)
		setText(findTF(arg0.skillDetailPanel, "ad/skill1Desc"), var1)
		setActive(findTF(arg0.skillDetailPanel, "ad/skill1Desc"), true)
		setActive(findTF(arg0.skillDetailPanel, "ad/skill1Bg"), true)
	else
		setActive(findTF(arg0.skillDetailPanel, "ad/skill1Desc"), false)
		setActive(findTF(arg0.skillDetailPanel, "ad/skill1Bg"), false)
	end

	if var2 then
		setText(findTF(arg0.skillDetailPanel, "ad/skill2Bg/skill2Name"), var2)
		setText(findTF(arg0.skillDetailPanel, "ad/skill2Desc"), var3)
		setActive(findTF(arg0.skillDetailPanel, "ad/skill2Desc"), true)
		setActive(findTF(arg0.skillDetailPanel, "ad/skill2Bg"), true)
	else
		setActive(findTF(arg0.skillDetailPanel, "ad/skill2Desc"), false)
		setActive(findTF(arg0.skillDetailPanel, "ad/skill2Bg"), false)
	end
end

function var0.show(arg0, arg1)
	setActive(arg0.menuUI, arg1)
end

function var0.update(arg0, arg1)
	arg0.mgHubData = arg1

	local var0 = arg0:getGameUsedTimes(arg1)
	local var1 = arg0:getGameTimes(arg1)

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_clear/icon"))
			setActive(arg0.dropItems[iter0], true)
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_current/icon"))
			setActive(arg0.dropItems[iter0], true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_open/icon"))
			setActive(arg0.dropItems[iter0], true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_closed/icon"))
			setActive(arg0.dropItems[iter0], true)
		end
	end

	local var2 = 1 - (var0 - 3 < 0 and 0 or var0 - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
end

function var0.CheckGet(arg0)
	local var0 = arg0.mgHubData

	setActive(findTF(arg0.menuUI, "got"), false)

	local var1 = arg0:getUltimate(var0)

	if var1 and var1 ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if var1 == 0 then
		if LaunchBallGameVo.total_times > arg0:getGameUsedTimes(var0) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.getGameTimes(arg0, arg1)
	return arg1.count
end

function var0.getGameUsedTimes(arg0, arg1)
	return arg1.usedtime
end

function var0.getUltimate(arg0, arg1)
	return arg1.ultimate
end

return var0

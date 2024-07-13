local var0_0 = class("LaunchBallGameMenuUI")

var0_0.player_item = {
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
var0_0.skill_detail_desc = "launch_ball_skill_desc"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.menuUI = findTF(arg0_1._tf, "ui/menuUI")
	arg0_1.battleScrollRect = GetComponent(findTF(arg0_1.menuUI, "battList"), typeof(ScrollRect))
	arg0_1.totalTimes = LaunchBallGameVo.total_times
	arg0_1.battleItems = {}
	arg0_1.dropItems = {}

	onButton(arg0_1._event, findTF(arg0_1.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_2 = arg0_1.battleScrollRect.normalizedPosition.y + 1 / (arg0_1.totalTimes - 4)

		if var0_2 > 1 then
			var0_2 = 1
		end

		scrollTo(arg0_1.battleScrollRect, 0, var0_2)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_3 = arg0_1.battleScrollRect.normalizedPosition.y - 1 / (arg0_1.totalTimes - 4)

		if var0_3 < 0 then
			var0_3 = 0
		end

		scrollTo(arg0_1.battleScrollRect, 0, var0_3)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnBack"), function()
		arg0_1._event:emit(BeachGuardGameView.CLOSE_GAME)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnRule"), function()
		arg0_1._event:emit(BeachGuardGameView.SHOW_RULE)
	end, SFX_CANCEL)

	arg0_1.btnStart = findTF(arg0_1.menuUI, "btnStart")

	onButton(arg0_1._event, findTF(arg0_1.menuUI, "btnStart"), function()
		if arg0_1.playerId == nil then
			return
		end

		arg0_1._event:emit(BeachGuardGameView.READY_START)
	end, SFX_CANCEL)

	local var0_1 = findTF(arg0_1.menuUI, "tplBattleItem")

	for iter0_1 = 1, 7 do
		local var1_1 = tf(instantiate(var0_1))

		var1_1.name = "battleItem_" .. iter0_1

		setParent(var1_1, findTF(arg0_1.menuUI, "battList/Viewport/Content"))

		local var2_1 = iter0_1
		local var3_1 = findTF(var1_1, "icon")

		onButton(arg0_1._event, var3_1, function()
			return
		end, SFX_PANEL)
		table.insert(arg0_1.dropItems, var3_1)
		setActive(var1_1, true)
		table.insert(arg0_1.battleItems, var1_1)
	end

	arg0_1.players = {}

	for iter1_1 = 1, #var0_0.player_item do
		local var4_1 = var0_0.player_item[iter1_1]
		local var5_1 = findTF(arg0_1.menuUI, "player/" .. var4_1.name)
		local var6_1 = LaunchBallActivityMgr.GetPlayerZhuanshuIndex(var4_1.id)
		local var7_1 = false

		if var6_1 then
			var7_1 = LaunchBallActivityMgr.CheckZhuanShuAble(ActivityConst.MINIGAME_ZUMA, var6_1)
		else
			var7_1 = true
		end

		setActive(findTF(var5_1, "ad/mask"), not var7_1)
		setScrollText(findTF(var5_1, "ad/skillPanel/skill1/text"), i18n(var4_1.skill_1))
		setScrollText(findTF(var5_1, "ad/skillPanel/skill2/text"), i18n(var4_1.skill_2))
		setText(findTF(var5_1, "ad/skillPanel/detail/img"), i18n(var0_0.skill_detail_desc))

		local var8_1 = GetComponent(findTF(var5_1, "ad/icon"), typeof(Animator))

		onButton(arg0_1._event, findTF(var5_1, "ad/click"), function()
			if not var7_1 then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ZUMA_PT_SHOP)

				return
			end

			if arg0_1.playerId == var4_1.id then
				arg0_1:selectPlayer(nil)
			else
				arg0_1:selectPlayer(var4_1.id)
			end
		end, SFX_CONFIRM)
		onButton(arg0_1._event, findTF(var5_1, "ad/skillPanel"), function()
			arg0_1:showSkillPanel(var4_1)
			setActive(arg0_1.skillDetailPanel, true)
		end, SFX_CONFIRM)
		table.insert(arg0_1.players, {
			tf = var5_1,
			data = var4_1,
			anim = var8_1
		})
	end

	arg0_1.skillDetailPanel = findTF(arg0_1.menuUI, "skillDetail")

	setActive(arg0_1.skillDetailPanel, false)
	onButton(arg0_1._event, findTF(arg0_1.skillDetailPanel, "ad"), function()
		setActive(arg0_1.skillDetailPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1.skillDetailPanel, "ad/btnOk"), function()
		setActive(arg0_1.skillDetailPanel, false)
	end, SFX_CANCEL)

	arg0_1.selectMask = findTF(arg0_1.menuUI, "selectMask")

	setText(findTF(arg0_1.menuUI, "select"), i18n(LaunchBallGameVo.launchball_minigame_select))
	setText(findTF(arg0_1.menuUI, "selectMask/unSelect"), i18n(LaunchBallGameVo.launchball_minigame_un_select))
	arg0_1:selectPlayer(nil)
end

function var0_0.selectPlayer(arg0_12, arg1_12)
	for iter0_12 = 1, #arg0_12.players do
		if arg0_12.players[iter0_12].data.id == arg1_12 then
			setActive(findTF(arg0_12.players[iter0_12].tf, "ad/select"), true)
			arg0_12.players[iter0_12].anim:Play("Attack")
		else
			setActive(findTF(arg0_12.players[iter0_12].tf, "ad/select"), false)
			arg0_12.players[iter0_12].anim:Play("Idle")
		end
	end

	arg0_12.playerId = arg1_12

	LaunchBallGameVo.SetPlayer(arg0_12.playerId)

	if arg0_12.playerId == nil then
		setActive(arg0_12.btnStart, false)
		setActive(arg0_12.selectMask, false)
		setActive(findTF(arg0_12.menuUI, "select"), true)
	else
		setActive(arg0_12.btnStart, true)
		setActive(arg0_12.selectMask, true)
		setActive(findTF(arg0_12.menuUI, "select"), false)
	end
end

function var0_0.showSkillPanel(arg0_13, arg1_13)
	local var0_13 = i18n(arg1_13.skill_1)
	local var1_13 = i18n(arg1_13.skill_1_desc)
	local var2_13 = i18n(arg1_13.skill_2)
	local var3_13 = i18n(arg1_13.skill_2_desc)

	if var0_13 then
		setText(findTF(arg0_13.skillDetailPanel, "ad/skill1Bg/skill1Name"), var0_13)
		setText(findTF(arg0_13.skillDetailPanel, "ad/skill1Desc"), var1_13)
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill1Desc"), true)
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill1Bg"), true)
	else
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill1Desc"), false)
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill1Bg"), false)
	end

	if var2_13 then
		setText(findTF(arg0_13.skillDetailPanel, "ad/skill2Bg/skill2Name"), var2_13)
		setText(findTF(arg0_13.skillDetailPanel, "ad/skill2Desc"), var3_13)
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill2Desc"), true)
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill2Bg"), true)
	else
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill2Desc"), false)
		setActive(findTF(arg0_13.skillDetailPanel, "ad/skill2Bg"), false)
	end
end

function var0_0.show(arg0_14, arg1_14)
	setActive(arg0_14.menuUI, arg1_14)
end

function var0_0.update(arg0_15, arg1_15)
	arg0_15.mgHubData = arg1_15

	local var0_15 = arg0_15:getGameUsedTimes(arg1_15)
	local var1_15 = arg0_15:getGameTimes(arg1_15)

	for iter0_15 = 1, #arg0_15.battleItems do
		setActive(findTF(arg0_15.battleItems[iter0_15], "state_open"), false)
		setActive(findTF(arg0_15.battleItems[iter0_15], "state_closed"), false)
		setActive(findTF(arg0_15.battleItems[iter0_15], "state_clear"), false)
		setActive(findTF(arg0_15.battleItems[iter0_15], "state_current"), false)

		if iter0_15 <= var0_15 then
			SetParent(arg0_15.dropItems[iter0_15], findTF(arg0_15.battleItems[iter0_15], "state_clear/icon"))
			setActive(arg0_15.dropItems[iter0_15], true)
			setActive(findTF(arg0_15.battleItems[iter0_15], "state_clear"), true)
		elseif iter0_15 == var0_15 + 1 and var1_15 >= 1 then
			setActive(findTF(arg0_15.battleItems[iter0_15], "state_current"), true)
			SetParent(arg0_15.dropItems[iter0_15], findTF(arg0_15.battleItems[iter0_15], "state_current/icon"))
			setActive(arg0_15.dropItems[iter0_15], true)
		elseif var0_15 < iter0_15 and iter0_15 <= var0_15 + var1_15 then
			setActive(findTF(arg0_15.battleItems[iter0_15], "state_open"), true)
			SetParent(arg0_15.dropItems[iter0_15], findTF(arg0_15.battleItems[iter0_15], "state_open/icon"))
			setActive(arg0_15.dropItems[iter0_15], true)
		else
			setActive(findTF(arg0_15.battleItems[iter0_15], "state_closed"), true)
			SetParent(arg0_15.dropItems[iter0_15], findTF(arg0_15.battleItems[iter0_15], "state_closed/icon"))
			setActive(arg0_15.dropItems[iter0_15], true)
		end
	end

	local var2_15 = 1 - (var0_15 - 3 < 0 and 0 or var0_15 - 3) / (arg0_15.totalTimes - 4)

	if var2_15 > 1 then
		var2_15 = 1
	end

	scrollTo(arg0_15.battleScrollRect, 0, var2_15)
	setActive(findTF(arg0_15.menuUI, "btnStart/tip"), var1_15 > 0)
end

function var0_0.CheckGet(arg0_16)
	local var0_16 = arg0_16.mgHubData

	setActive(findTF(arg0_16.menuUI, "got"), false)

	local var1_16 = arg0_16:getUltimate(var0_16)

	if var1_16 and var1_16 ~= 0 then
		setActive(findTF(arg0_16.menuUI, "got"), true)
	end

	if var1_16 == 0 then
		if LaunchBallGameVo.total_times > arg0_16:getGameUsedTimes(var0_16) then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = var0_16.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_16.menuUI, "got"), true)
	end
end

function var0_0.getGameTimes(arg0_17, arg1_17)
	return arg1_17.count
end

function var0_0.getGameUsedTimes(arg0_18, arg1_18)
	return arg1_18.usedtime
end

function var0_0.getUltimate(arg0_19, arg1_19)
	return arg1_19.ultimate
end

return var0_0

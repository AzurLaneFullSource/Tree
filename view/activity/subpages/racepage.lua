local var0_0 = class("RacePage", import("...base.BaseActivityPage"))
local var1_0 = 58

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.help = arg0_1:findTF("help", arg0_1.bg)
	arg0_1.goBtn = arg0_1:findTF("go_btn", arg0_1.bg)
	arg0_1.ticketStat = arg0_1:findTF("ticket_static", arg0_1.bg)
	arg0_1.ticketNum = arg0_1:findTF("ticket_num", arg0_1.bg)
	arg0_1.costTf = arg0_1:findTF("cost", arg0_1.bg)
	arg0_1.progressBar = arg0_1:findTF("progress_bar", arg0_1.bg)
	arg0_1.progressTpl = arg0_1:findTF("progress_tpl", arg0_1.bg)
	arg0_1.progressContainer = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.progressList = UIItemList.New(arg0_1.progressContainer, arg0_1.progressTpl)
	arg0_1.rankBtn = arg0_1:findTF("rank_btn", arg0_1.bg)
	arg0_1.rankPanel = arg0_1:findTF("rank_panel", arg0_1.bg)
	arg0_1.rankBlank = arg0_1:findTF("rank_panel/static/blank_img", arg0_1.bg)
	arg0_1.rankSelf = arg0_1:findTF("rank_panel/self", arg0_1.bg)
	arg0_1.rankContainer = arg0_1:findTF("rank_panel/list_panel/view_content/list", arg0_1.bg)
	arg0_1.rankTpl = arg0_1:findTF("rank_panel/list_panel/view_content/tpl", arg0_1.bg)
	arg0_1.rankMask = arg0_1:findTF("rank_panel/mask", arg0_1.bg)

	arg0_1:hideRankPanel()
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_id")
	local var1_2 = getProxy(MiniGameProxy):GetHubByHubId(var0_2)

	var1_0 = arg0_2.activity:getConfig("config_client").gameid and var1_0
	arg0_2.is_ranking = pg.mini_game[var1_0].is_ranking == 1
	arg0_2.needCount = var1_2:getConfig("reward_need")
	arg0_2.leftCount = var1_2.count
	arg0_2.playedCount = var1_2.usedtime
	arg0_2.curDay = arg0_2.leftCount + arg0_2.playedCount
end

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = getProxy(MiniGameProxy)

	if var0_3:CanFetchRank(var1_0) then
		pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
			id = var1_0,
			callback = function(...)
				arg0_3:updateRankTf(...)
			end
		})
	else
		local var1_3 = var0_3:GetRank(var1_0)

		arg0_3:updateRankTf(var1_3)
	end

	setActive(arg0_3.rankBtn, arg0_3.is_ranking)
	onButton(arg0_3, arg0_3.rankBtn, function()
		local var0_5 = isActive(arg0_3.rankPanel)

		setActive(arg0_3.rankPanel, not var0_5)

		if not var0_5 then
			local var1_5 = arg0_3.activity:getConfig("config_id")
			local var2_5 = getProxy(MiniGameProxy):GetHubByHubId(var1_5)
			local var3_5 = 103

			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var2_5.id,
				cmd = MiniGameOPCommand.CMD_SPECIAL_TRACK,
				args1 = {
					var1_0,
					var3_5
				}
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rankMask, function()
		arg0_3:hideRankPanel()
	end, SFX_PANEL)
	arg0_3.progressList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			local var0_7 = arg0_3:findTF("item_mask/item", arg2_7)
			local var1_7 = pg.mini_game[var1_0].simple_config_data.drop[arg1_7 + 1]
			local var2_7 = {
				type = var1_7[1],
				id = var1_7[2],
				count = var1_7[3]
			}

			updateDrop(var0_7, var2_7)
			onButton(arg0_3, arg2_7, function()
				arg0_3:emit(BaseUI.ON_DROP, var2_7)
			end, SFX_PANEL)
			setText(arg2_7:Find("text"), arg1_7 + 1)
		elseif arg0_7 == UIItemList.EventUpdate then
			setActive(arg2_7:Find("item_mask/got"), arg1_7 < arg0_3.playedCount)
			setActive(arg2_7:Find("got_sequence"), arg1_7 < arg0_3.playedCount)
		end
	end)
	arg0_3.progressList:align(arg0_3.needCount)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1_0)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.racing_minigame_help.tip
		})
	end, SFX_PANEL)
	setText(arg0_3.costTf:Find("cost_static"), i18n("racing_cost"))
	setText(arg0_3.rankPanel:Find("static/top_text"), i18n("racing_rank_top_text"))
	setText(arg0_3.rankPanel:Find("static/half_h_static"), i18n("racing_rank_half_h"))
	setText(arg0_3.rankBlank:Find("text"), i18n("racing_rank_no_data"))
end

function var0_0.OnUpdateFlush(arg0_11)
	setActive(arg0_11.ticketStat, arg0_11.leftCount ~= 0)
	setText(arg0_11.ticketNum, arg0_11.leftCount)
	setText(arg0_11.costTf, arg0_11.playedCount)
	setSlider(arg0_11.progressBar, 0, 1, arg0_11.playedCount / arg0_11.needCount)
end

function var0_0.updateRankTf(arg0_12, arg1_12)
	local var0_12 = getProxy(FriendProxy)
	local var1_12 = getProxy(PlayerProxy):getData()

	arg1_12 = underscore.filter(arg1_12, function(arg0_13)
		return var0_12:isFriend(arg0_13.player_id) or arg0_13.player_id == var1_12.id
	end)

	setActive(arg0_12.rankPanel:Find("list_panel/scroll_bar/handle"), #arg1_12 > 5)

	if #arg1_12 == 0 then
		setActive(arg0_12.rankBlank, true)
		arg0_12:updateRankSelfTf(#arg1_12)

		return
	end

	setActive(arg0_12.rankBlank, false)
	UIItemList.StaticAlign(arg0_12.rankContainer, arg0_12.rankTpl, #arg1_12, function(arg0_14, arg1_14, arg2_14)
		if arg0_14 ~= UIItemList.EventUpdate then
			return
		end

		setText(arg2_14:Find("name"), arg1_12[arg1_14 + 1].name)
		setText(arg2_14:Find("score"), arg0_12:getScoreString(arg1_12[arg1_14 + 1].score))
		arg0_12:updateRankPosTf(arg2_14:Find("position"), arg1_12[arg1_14 + 1].position)
		arg0_12:updateRankFaceTf(arg2_14:Find("face"), arg1_12[arg1_14 + 1].display, arg1_12[arg1_14 + 1].position)
	end)

	local var2_12 = underscore.detect(arg1_12, function(arg0_15)
		return arg0_15.player_id == var1_12.id
	end)

	arg0_12:updateRankSelfTf(#arg1_12, var2_12)
end

function var0_0.updateRankPosTf(arg0_16, arg1_16, arg2_16)
	setActive(arg1_16:Find("img1"), arg2_16 == 1)
	setActive(arg1_16:Find("img2"), arg2_16 == 2)
	setActive(arg1_16:Find("img3"), arg2_16 == 3)
	setActive(arg1_16:Find("text"), arg2_16 > 3 or arg2_16 == 0)

	if arg2_16 > 3 then
		setText(arg1_16:Find("text"), arg2_16)
	end

	if arg2_16 == 0 then
		setText(arg1_16:Find("text"), "--")
	end
end

function var0_0.updateRankFaceTf(arg0_17, arg1_17, arg2_17, arg3_17)
	if arg3_17 then
		setActive(arg1_17:Find("frame1"), arg3_17 == 1)
		setActive(arg1_17:Find("frame2"), arg3_17 == 2)
		setActive(arg1_17:Find("frame3"), arg3_17 == 3)
		setActive(arg1_17:Find("frame4"), arg3_17 > 3)
	end

	local var0_17 = pg.ship_data_statistics[arg2_17.icon]
	local var1_17 = Ship.New({
		configId = arg2_17.icon,
		skin_id = arg2_17.skinId,
		propose = arg2_17.proposeTime
	})

	LoadSpriteAsync("qicon/" .. var1_17:getPainting(), function(arg0_18)
		arg1_17:Find("mask/icon"):GetComponent(typeof(Image)).sprite = arg0_18
	end)
end

function var0_0.updateRankSelfTf(arg0_19, arg1_19, arg2_19)
	local var0_19 = getProxy(PlayerProxy):getData()
	local var1_19 = getProxy(BayProxy):getShipById(var0_19.character)
	local var2_19 = getProxy(MiniGameProxy)
	local var3_19 = {
		position = arg2_19 and arg2_19.position or 0,
		id = var0_19.id,
		name = var0_19.name,
		score = var2_19:GetHighScore(var1_0),
		display = {
			icon = var1_19:getConfig("id"),
			skinId = var1_19.skinId,
			proposeTime = var1_19.proposeTime
		}
	}

	setText(arg0_19.rankSelf:Find("name"), var3_19.name)
	setText(arg0_19.rankSelf:Find("score"), arg0_19:getScoreString(var3_19.score))
	arg0_19:updateRankPosTf(arg0_19.rankSelf:Find("position"), var3_19.position)
	arg0_19:updateRankFaceTf(arg0_19.rankSelf:Find("face"), var3_19.display, nil)
	setActive(arg0_19.rankSelf, true)
end

function var0_0.showRankPanel(arg0_20)
	setActive(arg0_20.rankPanel, true)
end

function var0_0.hideRankPanel(arg0_21)
	setActive(arg0_21.rankPanel, false)
end

function var0_0.getScoreString(arg0_22, arg1_22)
	arg1_22 = arg1_22 or 0

	return string.format("%.2fM", arg1_22 / 100)
end

return var0_0

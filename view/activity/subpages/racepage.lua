local var0 = class("RacePage", import("...base.BaseActivityPage"))
local var1 = 58

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.help = arg0:findTF("help", arg0.bg)
	arg0.goBtn = arg0:findTF("go_btn", arg0.bg)
	arg0.ticketStat = arg0:findTF("ticket_static", arg0.bg)
	arg0.ticketNum = arg0:findTF("ticket_num", arg0.bg)
	arg0.costTf = arg0:findTF("cost", arg0.bg)
	arg0.progressBar = arg0:findTF("progress_bar", arg0.bg)
	arg0.progressTpl = arg0:findTF("progress_tpl", arg0.bg)
	arg0.progressContainer = arg0:findTF("progress", arg0.bg)
	arg0.progressList = UIItemList.New(arg0.progressContainer, arg0.progressTpl)
	arg0.rankBtn = arg0:findTF("rank_btn", arg0.bg)
	arg0.rankPanel = arg0:findTF("rank_panel", arg0.bg)
	arg0.rankBlank = arg0:findTF("rank_panel/static/blank_img", arg0.bg)
	arg0.rankSelf = arg0:findTF("rank_panel/self", arg0.bg)
	arg0.rankContainer = arg0:findTF("rank_panel/list_panel/view_content/list", arg0.bg)
	arg0.rankTpl = arg0:findTF("rank_panel/list_panel/view_content/tpl", arg0.bg)
	arg0.rankMask = arg0:findTF("rank_panel/mask", arg0.bg)

	arg0:hideRankPanel()
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_id")
	local var1 = getProxy(MiniGameProxy):GetHubByHubId(var0)

	var1 = arg0.activity:getConfig("config_client").gameid and var1
	arg0.is_ranking = pg.mini_game[var1].is_ranking == 1
	arg0.needCount = var1:getConfig("reward_need")
	arg0.leftCount = var1.count
	arg0.playedCount = var1.usedtime
	arg0.curDay = arg0.leftCount + arg0.playedCount
end

function var0.OnFirstFlush(arg0)
	local var0 = getProxy(MiniGameProxy)

	if var0:CanFetchRank(var1) then
		pg.m02:sendNotification(GAME.MINI_GAME_FRIEND_RANK, {
			id = var1,
			callback = function(...)
				arg0:updateRankTf(...)
			end
		})
	else
		local var1 = var0:GetRank(var1)

		arg0:updateRankTf(var1)
	end

	setActive(arg0.rankBtn, arg0.is_ranking)
	onButton(arg0, arg0.rankBtn, function()
		local var0 = isActive(arg0.rankPanel)

		setActive(arg0.rankPanel, not var0)

		if not var0 then
			local var1 = arg0.activity:getConfig("config_id")
			local var2 = getProxy(MiniGameProxy):GetHubByHubId(var1)
			local var3 = 103

			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = var2.id,
				cmd = MiniGameOPCommand.CMD_SPECIAL_TRACK,
				args1 = {
					var1,
					var3
				}
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.rankMask, function()
		arg0:hideRankPanel()
	end, SFX_PANEL)
	arg0.progressList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg0:findTF("item_mask/item", arg2)
			local var1 = pg.mini_game[var1].simple_config_data.drop[arg1 + 1]
			local var2 = {
				type = var1[1],
				id = var1[2],
				count = var1[3]
			}

			updateDrop(var0, var2)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var2)
			end, SFX_PANEL)
			setText(arg2:Find("text"), arg1 + 1)
		elseif arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("item_mask/got"), arg1 < arg0.playedCount)
			setActive(arg2:Find("got_sequence"), arg1 < arg0.playedCount)
		end
	end)
	arg0.progressList:align(arg0.needCount)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var1)
	end, SFX_PANEL)
	onButton(arg0, arg0.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.racing_minigame_help.tip
		})
	end, SFX_PANEL)
	setText(arg0.costTf:Find("cost_static"), i18n("racing_cost"))
	setText(arg0.rankPanel:Find("static/top_text"), i18n("racing_rank_top_text"))
	setText(arg0.rankPanel:Find("static/half_h_static"), i18n("racing_rank_half_h"))
	setText(arg0.rankBlank:Find("text"), i18n("racing_rank_no_data"))
end

function var0.OnUpdateFlush(arg0)
	setActive(arg0.ticketStat, arg0.leftCount ~= 0)
	setText(arg0.ticketNum, arg0.leftCount)
	setText(arg0.costTf, arg0.playedCount)
	setSlider(arg0.progressBar, 0, 1, arg0.playedCount / arg0.needCount)
end

function var0.updateRankTf(arg0, arg1)
	local var0 = getProxy(FriendProxy)
	local var1 = getProxy(PlayerProxy):getData()

	arg1 = underscore.filter(arg1, function(arg0)
		return var0:isFriend(arg0.player_id) or arg0.player_id == var1.id
	end)

	setActive(arg0.rankPanel:Find("list_panel/scroll_bar/handle"), #arg1 > 5)

	if #arg1 == 0 then
		setActive(arg0.rankBlank, true)
		arg0:updateRankSelfTf(#arg1)

		return
	end

	setActive(arg0.rankBlank, false)
	UIItemList.StaticAlign(arg0.rankContainer, arg0.rankTpl, #arg1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		setText(arg2:Find("name"), arg1[arg1 + 1].name)
		setText(arg2:Find("score"), arg0:getScoreString(arg1[arg1 + 1].score))
		arg0:updateRankPosTf(arg2:Find("position"), arg1[arg1 + 1].position)
		arg0:updateRankFaceTf(arg2:Find("face"), arg1[arg1 + 1].display, arg1[arg1 + 1].position)
	end)

	local var2 = underscore.detect(arg1, function(arg0)
		return arg0.player_id == var1.id
	end)

	arg0:updateRankSelfTf(#arg1, var2)
end

function var0.updateRankPosTf(arg0, arg1, arg2)
	setActive(arg1:Find("img1"), arg2 == 1)
	setActive(arg1:Find("img2"), arg2 == 2)
	setActive(arg1:Find("img3"), arg2 == 3)
	setActive(arg1:Find("text"), arg2 > 3 or arg2 == 0)

	if arg2 > 3 then
		setText(arg1:Find("text"), arg2)
	end

	if arg2 == 0 then
		setText(arg1:Find("text"), "--")
	end
end

function var0.updateRankFaceTf(arg0, arg1, arg2, arg3)
	if arg3 then
		setActive(arg1:Find("frame1"), arg3 == 1)
		setActive(arg1:Find("frame2"), arg3 == 2)
		setActive(arg1:Find("frame3"), arg3 == 3)
		setActive(arg1:Find("frame4"), arg3 > 3)
	end

	local var0 = pg.ship_data_statistics[arg2.icon]
	local var1 = Ship.New({
		configId = arg2.icon,
		skin_id = arg2.skinId,
		propose = arg2.proposeTime
	})

	LoadSpriteAsync("qicon/" .. var1:getPainting(), function(arg0)
		arg1:Find("mask/icon"):GetComponent(typeof(Image)).sprite = arg0
	end)
end

function var0.updateRankSelfTf(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = getProxy(BayProxy):getShipById(var0.character)
	local var2 = getProxy(MiniGameProxy)
	local var3 = {
		position = arg2 and arg2.position or 0,
		id = var0.id,
		name = var0.name,
		score = var2:GetHighScore(var1),
		display = {
			icon = var1:getConfig("id"),
			skinId = var1.skinId,
			proposeTime = var1.proposeTime
		}
	}

	setText(arg0.rankSelf:Find("name"), var3.name)
	setText(arg0.rankSelf:Find("score"), arg0:getScoreString(var3.score))
	arg0:updateRankPosTf(arg0.rankSelf:Find("position"), var3.position)
	arg0:updateRankFaceTf(arg0.rankSelf:Find("face"), var3.display, nil)
	setActive(arg0.rankSelf, true)
end

function var0.showRankPanel(arg0)
	setActive(arg0.rankPanel, true)
end

function var0.hideRankPanel(arg0)
	setActive(arg0.rankPanel, false)
end

function var0.getScoreString(arg0, arg1)
	arg1 = arg1 or 0

	return string.format("%.2fM", arg1 / 100)
end

return var0

pg = pg or {}
pg.WorldBossTipMgr = singletonClass("WorldBossTipMgr")

local var0_0 = pg.WorldBossTipMgr
local var1_0 = true
local var2_0 = false
local var3_0 = {
	"LevelMediator2",
	"WorldMediator",
	"WorldBossMediator"
}

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.isInit = true
	arg0_1.list = {}

	PoolMgr.GetInstance():GetUI("WorldBossTipUI", true, function(arg0_2)
		arg0_1._go = arg0_2
		arg0_1._tf = tf(arg0_2)

		setActive(arg0_1._go, true)

		arg0_1.tipTF = arg0_1._tf:Find("BG")
		arg0_1.tipTFCG = arg0_1.tipTF:GetComponent(typeof(CanvasGroup))
		arg0_1.scrollText = arg0_1.tipTF:Find("Text"):GetComponent("ScrollText")

		setParent(arg0_1._tf, GameObject.Find("OverlayCamera/Overlay/UIOverlay").transform)

		arg0_1.richText = arg0_1.tipTF:Find("Text"):GetComponent("RichText")

		setActive(arg0_1.tipTF, false)

		if arg1_1 then
			arg1_1()
		end
	end)
end

function var0_0.Show(arg0_3, arg1_3)
	if var2_0 then
		local function var0_3()
			if arg0_3:IsEnable(arg1_3:GetType()) then
				table.insert(arg0_3.list, arg1_3)

				if #arg0_3.list == 1 then
					arg0_3:Start()
				end
			else
				print("Message intercepted")
			end
		end

		if not arg0_3.isInit then
			arg0_3:Init(var0_3)
		else
			var0_3()
		end
	end

	if var1_0 and arg0_3:IsEnableNotify(arg1_3:GetType()) then
		local var1_3 = arg1_3:GetRoleName()
		local var2_3 = arg1_3:GetType()
		local var3_3
		local var4_3

		if WorldBoss.SUPPORT_TYPE_FRIEND == var2_3 then
			var3_3 = ChatConst.ChannelFriend
			var4_3 = i18n("world_word_friend")
		elseif WorldBoss.SUPPORT_TYPE_GUILD == var2_3 then
			var3_3 = ChatConst.ChannelGuild
			var4_3 = i18n("world_word_guild_member")
		else
			var3_3 = ChatConst.ChannelWorldBoss
			var4_3 = i18n("world_word_guild_player")
		end

		assert(var3_3)

		local var5_3 = arg1_3:GetPlayer()
		local var6_3 = getProxy(PlayerProxy):getData()

		print(var3_3, var4_3)

		local var7_3 = {
			id = 4,
			timestamp = pg.TimeMgr.GetInstance():GetServerTime(),
			args = {
				isDeath = false,
				supportType = var4_3,
				playerName = var1_3,
				bossName = arg1_3.config.name,
				level = arg1_3.level,
				wordBossId = arg1_3.id,
				lastTime = arg1_3.lastTime,
				wordBossConfigId = arg1_3.configId
			},
			player = var5_3 or var6_3,
			uniqueId = arg1_3.id .. "_" .. arg1_3.lastTime
		}

		if var3_3 == ChatConst.ChannelGuild then
			arg0_3:AddGuildMsg(var3_3, var7_3)
		else
			getProxy(ChatProxy):addNewMsg(ChatMsg.New(var3_3, var7_3))
		end
	end
end

function var0_0.AddGuildMsg(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(GuildProxy):getRawData()

	if not var0_5 then
		return
	end

	local var1_5 = var0_5:getMemberById(arg2_5.player.id)

	if not var1_5 then
		return
	end

	arg2_5.player = var1_5

	getProxy(GuildProxy):AddNewMsg(ChatMsg.New(arg1_5, arg2_5))
end

function var0_0.IsEnableNotify(arg0_6, arg1_6)
	return true
end

function var0_0.IsEnable(arg0_7, arg1_7)
	local var0_7 = arg0_7:IsEnableNotify(arg1_7)
	local var1_7 = (function()
		local var0_8 = getProxy(ContextProxy):getCurrentContext()

		return _.any(var3_0, function(arg0_9)
			return var0_8.mediator.__cname == arg0_9
		end)
	end)()

	return var0_7 and var1_7
end

function var0_0.Start(arg0_10)
	if #arg0_10.list > 0 then
		arg0_10:AddTimer()
	end
end

function var0_0.BuildClickableTxt(arg0_11, arg1_11)
	local var0_11 = arg1_11:BuildTipText()

	return string.format("<material=underline c=#FFFFFF h=1 event=onClick args=" .. arg1_11.id .. ">%s</material>", var0_11)
end

function var0_0.AddTimer(arg0_12)
	local var0_12 = arg0_12.list[1]

	arg0_12:RemoveTimer()
	setActive(arg0_12.tipTF, true)
	arg0_12.scrollText:SetText(arg0_12:BuildClickableTxt(var0_12))
	LeanTween.value(go(arg0_12.tipTF), 1, 0, 1):setOnUpdate(System.Action_float(function(arg0_13)
		arg0_12.tipTFCG.alpha = arg0_13
	end)):setOnComplete(System.Action(function()
		setActive(arg0_12.tipTF, false)
		arg0_12.scrollText:SetText("")

		arg0_12.tipTFCG.alpha = 1

		table.remove(arg0_12.list, 1)
		arg0_12:Start()
	end)):setDelay(4)
end

local function var4_0(arg0_15, arg1_15)
	if not arg0_15 or #arg0_15 == 0 then
		return
	end

	local var0_15 = _.detect(arg0_15, function(arg0_16)
		return arg0_16.id == tonumber(arg1_15)
	end)

	if not var0_15 or var0_15:isDeath() then
		return
	end

	return true
end

function var0_0.OnClick(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = nowWorld()

	if not var0_17 or not var0_17:IsActivate() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_unactivated"))

		return
	end

	local var1_17 = var0_17:GetBossProxy()

	if not var1_17 then
		return
	end

	local function var2_17(arg0_18)
		local var0_18 = getProxy(ContextProxy)
		local var1_18 = var0_18:getCurrentContext()

		local function var2_18()
			local function var0_19()
				var1_18 = var0_18:getCurrentContext()

				if var1_18:getContextByMediator(CombatLoadMediator) then
					return
				end

				if var1_18.mediator.__cname == "WorldBossMediator" then
					return
				end

				pg.m02:sendNotification(GAME.GO_WORLD_BOSS_SCENE)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS, {
					worldBossId = tonumber(arg2_17)
				})
			end

			pg.m02:sendNotification(GAME.CHECK_WORLD_BOSS_STATE, {
				bossId = tonumber(arg2_17),
				time = arg3_17,
				callback = var0_19,
				failedCallback = arg4_17
			})
		end

		if var1_18.mediator.__cname == "BattleMediator" then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_joint_exit_battle_tip"),
				onYes = function()
					pg.m02:sendNotification(GAME.QUIT_BATTLE)
					var2_18()
				end
			})
		else
			var2_18()
		end
	end

	if var1_17.isSetup then
		local var3_17 = var1_17:GetBossById(tonumber(arg2_17))

		if not var3_17 or var3_17:isDeath() then
			local var4_17 = getProxy(ChatProxy)
			local var5_17 = var3_17 and var3_17.lastTime or "0"
			local var6_17 = var4_17:GetMessagesByUniqueId(tonumber(arg2_17) .. "_" .. var5_17)

			for iter0_17, iter1_17 in ipairs(var6_17) do
				iter1_17.args.isDeath = true

				var4_17:UpdateMsg(iter1_17)
			end

			local var7_17 = getProxy(GuildProxy)
			local var8_17 = var7_17:GetMessagesByUniqueId(tonumber(arg2_17) .. "_" .. var5_17)

			for iter2_17, iter3_17 in ipairs(var8_17) do
				iter3_17.args.isDeath = true

				var7_17:UpdateMsg(iter3_17)
			end

			arg4_17()
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_boss_none"))

			return
		end

		var2_17()
	end
end

function var0_0.RemoveTimer(arg0_22)
	if LeanTween.isTweening(go(arg0_22.tipTF)) then
		LeanTween.cancel(go(arg0_22.tipTF))
	end
end

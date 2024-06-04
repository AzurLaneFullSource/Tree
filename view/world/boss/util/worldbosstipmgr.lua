pg = pg or {}
pg.WorldBossTipMgr = singletonClass("WorldBossTipMgr")

local var0 = pg.WorldBossTipMgr
local var1 = true
local var2 = false
local var3 = {
	"LevelMediator2",
	"WorldMediator",
	"WorldBossMediator"
}

function var0.Init(arg0, arg1)
	arg0.isInit = true
	arg0.list = {}

	PoolMgr.GetInstance():GetUI("WorldBossTipUI", true, function(arg0)
		arg0._go = arg0
		arg0._tf = tf(arg0)

		setActive(arg0._go, true)

		arg0.tipTF = arg0._tf:Find("BG")
		arg0.tipTFCG = arg0.tipTF:GetComponent(typeof(CanvasGroup))
		arg0.scrollText = arg0.tipTF:Find("Text"):GetComponent("ScrollText")

		setParent(arg0._tf, GameObject.Find("OverlayCamera/Overlay/UIOverlay").transform)

		arg0.richText = arg0.tipTF:Find("Text"):GetComponent("RichText")

		setActive(arg0.tipTF, false)

		if arg1 then
			arg1()
		end
	end)
end

function var0.Show(arg0, arg1)
	if var2 then
		local function var0()
			if arg0:IsEnable(arg1:GetType()) then
				table.insert(arg0.list, arg1)

				if #arg0.list == 1 then
					arg0:Start()
				end
			else
				print("Message intercepted")
			end
		end

		if not arg0.isInit then
			arg0:Init(var0)
		else
			var0()
		end
	end

	if var1 and arg0:IsEnableNotify(arg1:GetType()) then
		local var1 = arg1:GetRoleName()
		local var2 = arg1:GetType()
		local var3
		local var4

		if WorldBoss.SUPPORT_TYPE_FRIEND == var2 then
			var3 = ChatConst.ChannelFriend
			var4 = i18n("world_word_friend")
		elseif WorldBoss.SUPPORT_TYPE_GUILD == var2 then
			var3 = ChatConst.ChannelGuild
			var4 = i18n("world_word_guild_member")
		else
			var3 = ChatConst.ChannelWorldBoss
			var4 = i18n("world_word_guild_player")
		end

		assert(var3)

		local var5 = arg1:GetPlayer()
		local var6 = getProxy(PlayerProxy):getData()

		print(var3, var4)

		local var7 = {
			id = 4,
			timestamp = pg.TimeMgr.GetInstance():GetServerTime(),
			args = {
				isDeath = false,
				supportType = var4,
				playerName = var1,
				bossName = arg1.config.name,
				level = arg1.level,
				wordBossId = arg1.id,
				lastTime = arg1.lastTime,
				wordBossConfigId = arg1.configId
			},
			player = var5 or var6,
			uniqueId = arg1.id .. "_" .. arg1.lastTime
		}

		if var3 == ChatConst.ChannelGuild then
			arg0:AddGuildMsg(var3, var7)
		else
			getProxy(ChatProxy):addNewMsg(ChatMsg.New(var3, var7))
		end
	end
end

function var0.AddGuildMsg(arg0, arg1, arg2)
	local var0 = getProxy(GuildProxy):getRawData()

	if not var0 then
		return
	end

	local var1 = var0:getMemberById(arg2.player.id)

	if not var1 then
		return
	end

	arg2.player = var1

	getProxy(GuildProxy):AddNewMsg(ChatMsg.New(arg1, arg2))
end

function var0.IsEnableNotify(arg0, arg1)
	return true
end

function var0.IsEnable(arg0, arg1)
	local var0 = arg0:IsEnableNotify(arg1)
	local var1 = (function()
		local var0 = getProxy(ContextProxy):getCurrentContext()

		return _.any(var3, function(arg0)
			return var0.mediator.__cname == arg0
		end)
	end)()

	return var0 and var1
end

function var0.Start(arg0)
	if #arg0.list > 0 then
		arg0:AddTimer()
	end
end

function var0.BuildClickableTxt(arg0, arg1)
	local var0 = arg1:BuildTipText()

	return string.format("<material=underline c=#FFFFFF h=1 event=onClick args=" .. arg1.id .. ">%s</material>", var0)
end

function var0.AddTimer(arg0)
	local var0 = arg0.list[1]

	arg0:RemoveTimer()
	setActive(arg0.tipTF, true)
	arg0.scrollText:SetText(arg0:BuildClickableTxt(var0))
	LeanTween.value(go(arg0.tipTF), 1, 0, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.tipTFCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		setActive(arg0.tipTF, false)
		arg0.scrollText:SetText("")

		arg0.tipTFCG.alpha = 1

		table.remove(arg0.list, 1)
		arg0:Start()
	end)):setDelay(4)
end

local function var4(arg0, arg1)
	if not arg0 or #arg0 == 0 then
		return
	end

	local var0 = _.detect(arg0, function(arg0)
		return arg0.id == tonumber(arg1)
	end)

	if not var0 or var0:isDeath() then
		return
	end

	return true
end

function var0.OnClick(arg0, arg1, arg2, arg3, arg4)
	local var0 = nowWorld()

	if not var0 or not var0:IsActivate() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_unactivated"))

		return
	end

	local var1 = var0:GetBossProxy()

	if not var1 then
		return
	end

	local function var2(arg0)
		local var0 = getProxy(ContextProxy)
		local var1 = var0:getCurrentContext()

		local function var2()
			local var0 = function()
				var1 = var0:getCurrentContext()

				if var1:getContextByMediator(CombatLoadMediator) then
					return
				end

				if var1.mediator.__cname == "WorldBossMediator" then
					return
				end

				pg.m02:sendNotification(GAME.GO_WORLD_BOSS_SCENE)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS, {
					worldBossId = tonumber(arg2)
				})
			end

			pg.m02:sendNotification(GAME.CHECK_WORLD_BOSS_STATE, {
				bossId = tonumber(arg2),
				time = arg3,
				callback = var0,
				failedCallback = arg4
			})
		end

		if var1.mediator.__cname == "BattleMediator" then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_joint_exit_battle_tip"),
				onYes = function()
					pg.m02:sendNotification(GAME.QUIT_BATTLE)
					var2()
				end
			})
		else
			var2()
		end
	end

	if var1.isSetup then
		local var3 = var1:GetBossById(tonumber(arg2))

		if not var3 or var3:isDeath() then
			local var4 = getProxy(ChatProxy)
			local var5 = var3 and var3.lastTime or "0"
			local var6 = var4:GetMessagesByUniqueId(tonumber(arg2) .. "_" .. var5)

			for iter0, iter1 in ipairs(var6) do
				iter1.args.isDeath = true

				var4:UpdateMsg(iter1)
			end

			local var7 = getProxy(GuildProxy)
			local var8 = var7:GetMessagesByUniqueId(tonumber(arg2) .. "_" .. var5)

			for iter2, iter3 in ipairs(var8) do
				iter3.args.isDeath = true

				var7:UpdateMsg(iter3)
			end

			arg4()
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_boss_none"))

			return
		end

		var2()
	end
end

function var0.RemoveTimer(arg0)
	if LeanTween.isTweening(go(arg0.tipTF)) then
		LeanTween.cancel(go(arg0.tipTF))
	end
end

local var0 = class("Summary", import(".BaseVO"))

function var0.Ctor(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance()

	arg0.name = getProxy(PlayerProxy):getData().name
	arg0.registerTime = var0:STimeDescC(arg1.register_date, "%Y.%m.%d")

	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY):getStartTime()

	arg0.days = math.max(math.ceil((var1 - arg1.register_date) / 86400), 0) + 1

	local var2 = getProxy(UserProxy):getRawData()
	local var3 = getProxy(ServerProxy):getRawData()[var2 and var2.server or 0]

	arg0.serverName = var3 and var3.name or ""

	local var4 = math.max(arg1.chapter_id, 101)
	local var5 = pg.chapter_template[var4]

	if PLATFORM_CODE == PLATFORM_US and var5.model == ChapterConst.TypeMainSub then
		arg0.chapterName = pg.chapter_template[var4 - 1].chapter_name .. " " .. var5.name
	else
		arg0.chapterName = var5.chapter_name .. " " .. var5.name
	end

	arg0.guildName = arg1.guild_name
	arg0.proposeCount = arg1.marry_number
	arg0.medalCount = arg1.medal_number
	arg0.furnitureCount = arg1.furniture_number
	arg0.furnitureWorth = arg1.furniture_worth
	arg0.flagShipId = arg1.character_id
	arg0.firstLadyId = arg1.first_lady_id
	arg0.isProPose = arg0.proposeCount > 0
	arg0.firstProposeName = ""

	if arg0.firstLadyId > 0 then
		arg0.firstProposeName = Ship.New({
			configId = arg0.firstLadyId
		}):getConfig("name")
	end

	if arg1.first_lady_name ~= "" then
		arg0.firstProposeName = arg1.first_lady_name
	end

	arg0.proposeTime = math.ceil((var1 - arg1.first_lady_time) / 86400) + 1
	arg0.firstLadyTime = var0:STimeDescC(arg1.first_lady_time, "%Y-%m-%d %H:%M")
	arg0.unMarryShipId = 100001

	local var6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

	arg0.furnitures = {}

	for iter0, iter1 in pairs(getProxy(DormProxy):getRawData().furnitures) do
		arg0.furnitures[iter1.id] = iter1
	end

	arg0.medalList = underscore.filter(var6:getConfig("config_data"), function(arg0)
		return tobool(arg0.furnitures[arg0])
	end)

	local var7 = getProxy(AttireProxy)

	arg0.iconFrameList = underscore.filter(var6:getConfig("config_client")[1], function(arg0)
		return var7:getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0[1]):isOwned()
	end)
	arg0.worldProgressTask = arg1.world_max_task
	arg0.collectionNum = string.format("%0.1f", arg1.collect_num / var6:getConfig("config_client")[2] * 100)
	arg0.powerRaw = math.floor(arg1.combat^0.667)
	arg0.totalShipNum = arg1.ship_num_total
	arg0.topShipNum = arg1.ship_num_120
	arg0.bestShipNum = arg1.ship_num_125
	arg0.maxIntimacyNum = arg1.love200_num
	arg0.skinNum = arg1.skin_num
	arg0.skinShipNum = arg1.skin_ship_num
	arg0.skinId = 0

	local var8 = {}

	for iter2, iter3 in ipairs(getProxy(ShipSkinProxy):GetShopShowingSkins()) do
		if iter3.buyCount > 0 then
			var8[iter3:getSkinId()] = true
		end
	end

	local var9 = getProxy(BayProxy)

	for iter4, iter5 in ipairs(getProxy(PlayerProxy):getRawData().characters) do
		local var10 = var9:getShipById(iter5)

		if var10 and var8[var10.skinId] then
			arg0.skinId = var10.skinId

			break
		end
	end

	if arg0.skinId == 0 then
		local var11 = underscore.keys(var8)

		if #var11 > 0 then
			arg0.skinId = var11[math.max(1, math.ceil(math.random() * #var11))]
		end
	end
end

function var0.hasGuild(arg0)
	return arg0.guildName and arg0.guildName ~= ""
end

function var0.hasMedal(arg0)
	return arg0.medalCount > 0
end

return var0

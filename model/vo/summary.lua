local var0_0 = class("Summary", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = pg.TimeMgr.GetInstance()

	arg0_1.name = getProxy(PlayerProxy):getData().name
	arg0_1.registerTime = var0_1:STimeDescC(arg1_1.register_date, "%Y.%m.%d")

	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY):getStartTime()

	arg0_1.days = math.max(math.ceil((var1_1 - arg1_1.register_date) / 86400), 0) + 1

	local var2_1 = getProxy(UserProxy):getRawData()
	local var3_1 = getProxy(ServerProxy):getRawData()[var2_1 and var2_1.server or 0]

	arg0_1.serverName = var3_1 and var3_1.name or ""

	local var4_1 = math.max(arg1_1.chapter_id, 101)
	local var5_1 = pg.chapter_template[var4_1]

	if PLATFORM_CODE == PLATFORM_US and var5_1.model == ChapterConst.TypeMainSub then
		arg0_1.chapterName = pg.chapter_template[var4_1 - 1].chapter_name .. " " .. var5_1.name
	else
		arg0_1.chapterName = var5_1.chapter_name .. " " .. var5_1.name
	end

	arg0_1.guildName = arg1_1.guild_name
	arg0_1.proposeCount = arg1_1.marry_number
	arg0_1.medalCount = arg1_1.medal_number
	arg0_1.furnitureCount = arg1_1.furniture_number
	arg0_1.furnitureWorth = arg1_1.furniture_worth
	arg0_1.flagShipId = arg1_1.character_id
	arg0_1.firstLadyId = arg1_1.first_lady_id
	arg0_1.isProPose = arg0_1.proposeCount > 0
	arg0_1.firstProposeName = ""

	if arg0_1.firstLadyId > 0 then
		arg0_1.firstProposeName = Ship.New({
			configId = arg0_1.firstLadyId
		}):getConfig("name")
	end

	if arg1_1.first_lady_name ~= "" then
		arg0_1.firstProposeName = arg1_1.first_lady_name
	end

	arg0_1.proposeTime = math.ceil((var1_1 - arg1_1.first_lady_time) / 86400) + 1
	arg0_1.firstLadyTime = var0_1:STimeDescC(arg1_1.first_lady_time, "%Y-%m-%d %H:%M")
	arg0_1.unMarryShipId = 100001

	local var6_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

	arg0_1.furnitures = {}

	for iter0_1, iter1_1 in pairs(getProxy(DormProxy):getRawData().furnitures) do
		arg0_1.furnitures[iter1_1.id] = iter1_1
	end

	arg0_1.medalList = underscore.filter(var6_1:getConfig("config_data"), function(arg0_2)
		return tobool(arg0_1.furnitures[arg0_2])
	end)

	local var7_1 = getProxy(AttireProxy)

	arg0_1.iconFrameList = underscore.filter(var6_1:getConfig("config_client")[1], function(arg0_3)
		return var7_1:getAttireFrame(AttireConst.TYPE_ICON_FRAME, arg0_3[1]):isOwned()
	end)
	arg0_1.worldProgressTask = arg1_1.world_max_task
	arg0_1.collectionNum = string.format("%0.1f", arg1_1.collect_num / var6_1:getConfig("config_client")[2] * 100)
	arg0_1.powerRaw = math.floor(arg1_1.combat^0.667)
	arg0_1.totalShipNum = arg1_1.ship_num_total
	arg0_1.topShipNum = arg1_1.ship_num_120
	arg0_1.bestShipNum = arg1_1.ship_num_125
	arg0_1.maxIntimacyNum = arg1_1.love200_num
	arg0_1.skinNum = arg1_1.skin_num
	arg0_1.skinShipNum = arg1_1.skin_ship_num
	arg0_1.skinId = 0

	local var8_1 = {}

	for iter2_1, iter3_1 in ipairs(getProxy(ShipSkinProxy):GetShopShowingSkins()) do
		if iter3_1.buyCount > 0 then
			var8_1[iter3_1:getSkinId()] = true
		end
	end

	local var9_1 = getProxy(BayProxy)

	for iter4_1, iter5_1 in ipairs(getProxy(PlayerProxy):getRawData().characters) do
		local var10_1 = var9_1:getShipById(iter5_1)

		if var10_1 and var8_1[var10_1.skinId] then
			arg0_1.skinId = var10_1.skinId

			break
		end
	end

	if arg0_1.skinId == 0 then
		local var11_1 = underscore.keys(var8_1)

		if #var11_1 > 0 then
			arg0_1.skinId = var11_1[math.max(1, math.ceil(math.random() * #var11_1))]
		end
	end
end

function var0_0.hasGuild(arg0_4)
	return arg0_4.guildName and arg0_4.guildName ~= ""
end

function var0_0.hasMedal(arg0_5)
	return arg0_5.medalCount > 0
end

return var0_0

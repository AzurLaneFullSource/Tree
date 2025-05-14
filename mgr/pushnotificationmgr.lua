pg = pg or {}

local var0_0 = pg

var0_0.PushNotificationMgr = singletonClass("PushNotificationMgr")

local var1_0 = var0_0.PushNotificationMgr

var1_0.PUSH_TYPE_EVENT = 1
var1_0.PUSH_TYPE_GOLD = 2
var1_0.PUSH_TYPE_OIL = 3
var1_0.PUSH_TYPE_BACKYARD = 4
var1_0.PUSH_TYPE_SCHOOL = 5
var1_0.PUSH_TYPE_CLASS = 6
var1_0.PUSH_TYPE_TECHNOLOGY = 7
var1_0.PUSH_TYPE_BLUEPRINT = 8
var1_0.PUSH_TYPE_COMMANDER = 9
var1_0.PUSH_TYPE_GUILD_MISSION_FORMATION = 10

local var2_0 = {}
local var3_0 = false

function var1_0.Init(arg0_1)
	var2_0 = {}

	for iter0_1, iter1_1 in ipairs(var0_0.push_data_template) do
		local var0_1 = PlayerPrefs.GetInt("push_setting_" .. iter1_1.id)

		var2_0[iter1_1.id] = var0_1 == 0
	end

	var3_0 = PlayerPrefs.GetInt("setting_ship_name") == 1
end

function var1_0.Reset(arg0_2)
	var2_0 = {}

	for iter0_2, iter1_2 in ipairs(var0_0.push_data_template) do
		PlayerPrefs.SetInt("push_setting_" .. iter1_2.id, 0)

		var2_0[iter1_2.id] = true
	end

	PlayerPrefs.SetInt("setting_ship_name", 0)

	var3_0 = false
end

function var1_0.setSwitch(arg0_3, arg1_3, arg2_3)
	if not var0_0.push_data_template[arg1_3] then
		return
	end

	var2_0[arg1_3] = arg2_3

	PlayerPrefs.SetInt("push_setting_" .. arg1_3, arg2_3 and 0 or 1)
end

function var1_0.setSwitchShipName(arg0_4, arg1_4)
	var3_0 = arg1_4

	PlayerPrefs.SetInt("setting_ship_name", arg1_4 and 1 or 0)
end

function var1_0.isEnabled(arg0_5, arg1_5)
	return var2_0[arg1_5]
end

function var1_0.isEnableShipName(arg0_6)
	return var3_0
end

local var4_0 = {}

function var1_0.Push(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg3_7 - var0_0.TimeMgr.GetInstance():GetServerTime()
	local var1_7 = os.time() + var0_7

	arg0_7:log(arg1_7, arg2_7, var1_7)

	local var2_7 = {
		title = arg1_7,
		content = arg2_7,
		offsetSecond = var0_7
	}

	table.insert(var4_0, var2_7)
end

function var1_0.PushCache(arg0_8)
	for iter0_8, iter1_8 in ipairs(var4_0) do
		local var0_8 = iter0_8
		local var1_8 = iter1_8.title
		local var2_8 = iter1_8.content
		local var3_8 = iter1_8.offsetSecond * 1000

		YSNormalTool.NotificationTool.ScheduleNotification(var0_8, var1_8, var2_8, var3_8)
	end
end

function var1_0.cancelAll(arg0_9)
	originalPrint("取消通知")
	YSNormalTool.NotificationTool.CancelAllNotification()

	var4_0 = {}
end

function var1_0.PushAll(arg0_10)
	local var0_10 = getProxy(PlayerProxy)

	if var0_10 and var0_10:getInited() then
		if not PUSH_NOTIFICATION_TEST_TAG then
			arg0_10:cancelAll()
		end

		if var2_0[var1_0.PUSH_TYPE_EVENT] then
			arg0_10:PushEvent()
		end

		if var2_0[var1_0.PUSH_TYPE_GOLD] then
			arg0_10:PushGold()
		end

		if var2_0[var1_0.PUSH_TYPE_OIL] then
			arg0_10:PushOil()
		end

		if var2_0[var1_0.PUSH_TYPE_BACKYARD] then
			arg0_10:PushBackyard()
		end

		if var2_0[var1_0.PUSH_TYPE_SCHOOL] then
			arg0_10:PushSchool()
		end

		if var2_0[var1_0.PUSH_TYPE_TECHNOLOGY] then
			arg0_10:PushTechnlogy()
		end

		if var2_0[var1_0.PUSH_TYPE_BLUEPRINT] then
			arg0_10:PushBluePrint()
		end

		if var2_0[var1_0.PUSH_TYPE_COMMANDER] then
			arg0_10:PushCommander()
		end

		if var2_0[var1_0.PUSH_TYPE_GUILD_MISSION_FORMATION] then
			arg0_10:PushGuildMissionFormation()
		end

		arg0_10:PushCache()
	end
end

function var1_0.PushEvent(arg0_11)
	local var0_11 = getProxy(EventProxy):getActiveEvents()
	local var1_11 = var0_0.push_data_template[arg0_11.PUSH_TYPE_EVENT]

	for iter0_11, iter1_11 in ipairs(var0_11) do
		local var2_11 = string.gsub(var1_11.content, "$1", iter1_11.template.title)

		arg0_11:Push(var1_11.title, var2_11, iter1_11.finishTime)
	end
end

function var1_0.PushGold(arg0_12)
	local var0_12 = getProxy(NavalAcademyProxy):GetGoldVO()
	local var1_12 = var0_12:bindConfigTable()
	local var2_12 = var0_12:GetLevel()
	local var3_12 = var1_12[var2_12].store
	local var4_12 = var1_12[var2_12].production
	local var5_12 = var1_12[var2_12].hour_time
	local var6_12 = getProxy(PlayerProxy).data
	local var7_12 = var6_12.resUpdateTm
	local var8_12 = var6_12.goldField

	if var8_12 < var3_12 then
		local var9_12 = var7_12 + (var3_12 - var8_12) / var4_12 * 60 * 60 / 3

		if var9_12 > var0_0.TimeMgr.GetInstance():GetServerTime() then
			local var10_12 = var0_0.push_data_template[arg0_12.PUSH_TYPE_GOLD]

			arg0_12:Push(var10_12.title, var10_12.content, var9_12)
		end
	end
end

function var1_0.PushOil(arg0_13)
	local var0_13 = getProxy(NavalAcademyProxy):GetOilVO()
	local var1_13 = var0_13:bindConfigTable()
	local var2_13 = var0_13:GetLevel()
	local var3_13 = var1_13[var2_13].store
	local var4_13 = var1_13[var2_13].production
	local var5_13 = var1_13[var2_13].hour_time
	local var6_13 = getProxy(PlayerProxy).data
	local var7_13 = var6_13.resUpdateTm
	local var8_13 = var6_13.oilField

	if var8_13 < var3_13 then
		local var9_13 = var7_13 + (var3_13 - var8_13) / var4_13 * 60 * 60 / 3

		if var9_13 > var0_0.TimeMgr.GetInstance():GetServerTime() then
			local var10_13 = var0_0.push_data_template[arg0_13.PUSH_TYPE_OIL]

			arg0_13:Push(var10_13.title, var10_13.content, var9_13)
		end
	end
end

function var1_0.PushBackyard(arg0_14)
	local var0_14 = getProxy(DormProxy):getRawData():getFoodLeftTime()

	if var0_14 > var0_0.TimeMgr.GetInstance():GetServerTime() then
		local var1_14 = var0_0.push_data_template[arg0_14.PUSH_TYPE_BACKYARD]

		arg0_14:Push(var1_14.title, var1_14.content, var0_14)
	end
end

function var1_0.PushSchool(arg0_15)
	local var0_15 = getProxy(NavalAcademyProxy):getStudents()
	local var1_15 = var0_0.push_data_template[arg0_15.PUSH_TYPE_SCHOOL]
	local var2_15 = getProxy(BayProxy):getData()

	for iter0_15, iter1_15 in ipairs(var0_15) do
		if iter1_15.finishTime > var0_0.TimeMgr.GetInstance():GetServerTime() then
			local var3_15 = var2_15[iter1_15.shipId]
			local var4_15 = iter1_15:getSkillId(var3_15)
			local var5_15 = var3_15.skills[var4_15]
			local var6_15 = var3_15:getName()
			local var7_15 = getSkillName(iter1_15:getSkillId(var3_15))
			local var8_15 = string.gsub(var1_15.content, "$1", var6_15)
			local var9_15 = string.gsub(var8_15, "$2", var7_15)

			arg0_15:Push(var1_15.title, var9_15, iter1_15.finishTime)
		end
	end
end

function var1_0.PushTechnlogy(arg0_16)
	local var0_16 = var0_0.push_data_template[var1_0.PUSH_TYPE_TECHNOLOGY]
	local var1_16 = getProxy(TechnologyProxy)

	if var0_16 and var1_16 then
		local var2_16 = var1_16:getPlanningTechnologys()

		if #var2_16 > 0 and not var2_16[#var2_16]:isFinish() then
			arg0_16:Push(var0_16.title, var0_16.content, var2_16[#var2_16].time)
		end
	end
end

function var1_0.PushBluePrint(arg0_17)
	local var0_17 = var0_0.push_data_template[var1_0.PUSH_TYPE_BLUEPRINT]
	local var1_17 = getProxy(TechnologyProxy)
	local var2_17 = getProxy(TaskProxy)

	if var0_17 and var1_17 and var2_17 then
		local var3_17 = var1_17:getBuildingBluePrint()

		if var3_17 then
			local var4_17 = var3_17:getTaskIds()

			for iter0_17, iter1_17 in ipairs(var4_17) do
				local var5_17 = var3_17:getTaskOpenTimeStamp(iter1_17)

				if var5_17 > var0_0.TimeMgr.GetInstance():GetServerTime() then
					local var6_17 = var2_17:getTaskById(iter1_17) or var2_17:getFinishTaskById(iter1_17)
					local var7_17 = var2_17:isFinishPrevTasks(iter1_17)

					if not var6_17 and var7_17 then
						local var8_17 = var3_17:getShipVO()
						local var9_17 = string.gsub(var0_17.content, "$1", var8_17:getConfig("name"))

						arg0_17:Push(var0_17.title, var9_17, var5_17)
					end
				end
			end
		end
	end
end

function var1_0.PushCommander(arg0_18)
	local var0_18 = var0_0.push_data_template[var1_0.PUSH_TYPE_COMMANDER]
	local var1_18 = getProxy(CommanderProxy)

	if var0_18 and var1_18 then
		local var2_18 = var1_18:getBoxes()

		for iter0_18, iter1_18 in pairs(var2_18) do
			if iter1_18:getState() == CommanderBox.STATE_STARTING then
				local var3_18 = var0_18.content

				arg0_18:Push(var0_18.title, var3_18, iter1_18.finishTime)

				break
			end
		end
	end
end

function var1_0.PushGuildMissionFormation(arg0_19)
	local var0_19 = getProxy(GuildProxy):getRawData()

	if not var0_19 then
		return
	end

	local var1_19 = var0_19:GetActiveEvent()

	if not var1_19 or var1_19 and not var1_19:IsParticipant() then
		return
	end

	local var2_19 = var1_19:GetUnlockMission()

	if not var2_19 then
		return
	end

	local var3_19 = var2_19:GetNextFormationTime()

	if var3_19 <= var0_0.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	local var4_19 = var0_0.push_data_template[var1_0.PUSH_TYPE_GUILD_MISSION_FORMATION]

	arg0_19:Push(var4_19.title, var4_19.content, var3_19)
end

function var1_0.log(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg3_20 - os.time()
	local var1_20 = var0_0.TimeMgr.GetInstance():CTimeDescC(arg3_20)

	originalPrint(var1_20, "-", arg1_20, " - ", arg2_20, " - ", var0_20, "s后推送")
end

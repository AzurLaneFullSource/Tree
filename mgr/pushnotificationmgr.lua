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

function var1_0.Push(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg3_7 - var0_0.TimeMgr.GetInstance():GetServerTime()
	local var1_7 = os.time() + var0_7

	NotificationMgr.Inst:ScheduleLocalNotification(arg1_7, arg2_7, var1_7)
	arg0_7:log(arg1_7, arg2_7, var1_7)
end

function var1_0.cancelAll(arg0_8)
	NotificationMgr.Inst:CancelAllLocalNotifications()
end

function var1_0.PushAll(arg0_9)
	local var0_9 = getProxy(PlayerProxy)

	if var0_9 and var0_9:getInited() then
		arg0_9:cancelAll()

		if var2_0[var1_0.PUSH_TYPE_EVENT] then
			arg0_9:PushEvent()
		end

		if var2_0[var1_0.PUSH_TYPE_GOLD] then
			arg0_9:PushGold()
		end

		if var2_0[var1_0.PUSH_TYPE_OIL] then
			arg0_9:PushOil()
		end

		if var2_0[var1_0.PUSH_TYPE_BACKYARD] then
			arg0_9:PushBackyard()
		end

		if var2_0[var1_0.PUSH_TYPE_SCHOOL] then
			arg0_9:PushSchool()
		end

		if var2_0[var1_0.PUSH_TYPE_TECHNOLOGY] then
			arg0_9:PushTechnlogy()
		end

		if var2_0[var1_0.PUSH_TYPE_BLUEPRINT] then
			arg0_9:PushBluePrint()
		end

		if var2_0[var1_0.PUSH_TYPE_COMMANDER] then
			arg0_9:PushCommander()
		end

		if var2_0[var1_0.PUSH_TYPE_GUILD_MISSION_FORMATION] then
			arg0_9:PushGuildMissionFormation()
		end
	end
end

function var1_0.PushEvent(arg0_10)
	local var0_10 = getProxy(EventProxy):getActiveEvents()
	local var1_10 = var0_0.push_data_template[arg0_10.PUSH_TYPE_EVENT]

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var2_10 = string.gsub(var1_10.content, "$1", iter1_10.template.title)

		arg0_10:Push(var1_10.title, var2_10, iter1_10.finishTime)
	end
end

function var1_0.PushGold(arg0_11)
	local var0_11 = getProxy(NavalAcademyProxy):GetGoldVO()
	local var1_11 = var0_11:bindConfigTable()
	local var2_11 = var0_11:GetLevel()
	local var3_11 = var1_11[var2_11].store
	local var4_11 = var1_11[var2_11].production
	local var5_11 = var1_11[var2_11].hour_time
	local var6_11 = getProxy(PlayerProxy).data
	local var7_11 = var6_11.resUpdateTm
	local var8_11 = var6_11.goldField

	if var8_11 < var3_11 then
		local var9_11 = var7_11 + (var3_11 - var8_11) / var4_11 * 60 * 60 / 3

		if var9_11 > var0_0.TimeMgr.GetInstance():GetServerTime() then
			local var10_11 = var0_0.push_data_template[arg0_11.PUSH_TYPE_GOLD]

			arg0_11:Push(var10_11.title, var10_11.content, var9_11)
		end
	end
end

function var1_0.PushOil(arg0_12)
	local var0_12 = getProxy(NavalAcademyProxy):GetOilVO()
	local var1_12 = var0_12:bindConfigTable()
	local var2_12 = var0_12:GetLevel()
	local var3_12 = var1_12[var2_12].store
	local var4_12 = var1_12[var2_12].production
	local var5_12 = var1_12[var2_12].hour_time
	local var6_12 = getProxy(PlayerProxy).data
	local var7_12 = var6_12.resUpdateTm
	local var8_12 = var6_12.oilField

	if var8_12 < var3_12 then
		local var9_12 = var7_12 + (var3_12 - var8_12) / var4_12 * 60 * 60 / 3

		if var9_12 > var0_0.TimeMgr.GetInstance():GetServerTime() then
			local var10_12 = var0_0.push_data_template[arg0_12.PUSH_TYPE_OIL]

			arg0_12:Push(var10_12.title, var10_12.content, var9_12)
		end
	end
end

function var1_0.PushBackyard(arg0_13)
	local var0_13 = getProxy(DormProxy):getRawData():getFoodLeftTime()

	if var0_13 > var0_0.TimeMgr.GetInstance():GetServerTime() then
		local var1_13 = var0_0.push_data_template[arg0_13.PUSH_TYPE_BACKYARD]

		arg0_13:Push(var1_13.title, var1_13.content, var0_13)
	end
end

function var1_0.PushSchool(arg0_14)
	local var0_14 = getProxy(NavalAcademyProxy):getStudents()
	local var1_14 = var0_0.push_data_template[arg0_14.PUSH_TYPE_SCHOOL]
	local var2_14 = getProxy(BayProxy):getData()

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if iter1_14.finishTime > var0_0.TimeMgr.GetInstance():GetServerTime() then
			local var3_14 = var2_14[iter1_14.shipId]
			local var4_14 = iter1_14:getSkillId(var3_14)
			local var5_14 = var3_14.skills[var4_14]
			local var6_14 = var3_14:getName()
			local var7_14 = getSkillName(iter1_14:getSkillId(var3_14))
			local var8_14 = string.gsub(var1_14.content, "$1", var6_14)
			local var9_14 = string.gsub(var8_14, "$2", var7_14)

			arg0_14:Push(var1_14.title, var9_14, iter1_14.finishTime)
		end
	end
end

function var1_0.PushTechnlogy(arg0_15)
	local var0_15 = var0_0.push_data_template[var1_0.PUSH_TYPE_TECHNOLOGY]
	local var1_15 = getProxy(TechnologyProxy)

	if var0_15 and var1_15 then
		local var2_15 = var1_15:getPlanningTechnologys()

		if #var2_15 > 0 and not var2_15[#var2_15]:isFinish() then
			arg0_15:Push(var0_15.title, var0_15.content, var2_15[#var2_15].time)
		end
	end
end

function var1_0.PushBluePrint(arg0_16)
	local var0_16 = var0_0.push_data_template[var1_0.PUSH_TYPE_BLUEPRINT]
	local var1_16 = getProxy(TechnologyProxy)
	local var2_16 = getProxy(TaskProxy)

	if var0_16 and var1_16 and var2_16 then
		local var3_16 = var1_16:getBuildingBluePrint()

		if var3_16 then
			local var4_16 = var3_16:getTaskIds()

			for iter0_16, iter1_16 in ipairs(var4_16) do
				local var5_16 = var3_16:getTaskOpenTimeStamp(iter1_16)

				if var5_16 > var0_0.TimeMgr.GetInstance():GetServerTime() then
					local var6_16 = var2_16:getTaskById(iter1_16) or var2_16:getFinishTaskById(iter1_16)
					local var7_16 = var2_16:isFinishPrevTasks(iter1_16)

					if not var6_16 and var7_16 then
						local var8_16 = var3_16:getShipVO()
						local var9_16 = string.gsub(var0_16.content, "$1", var8_16:getConfig("name"))

						arg0_16:Push(var0_16.title, var9_16, var5_16)
					end
				end
			end
		end
	end
end

function var1_0.PushCommander(arg0_17)
	local var0_17 = var0_0.push_data_template[var1_0.PUSH_TYPE_COMMANDER]
	local var1_17 = getProxy(CommanderProxy)

	if var0_17 and var1_17 then
		local var2_17 = var1_17:getBoxes()

		for iter0_17, iter1_17 in pairs(var2_17) do
			if iter1_17:getState() == CommanderBox.STATE_STARTING then
				local var3_17 = var0_17.content

				arg0_17:Push(var0_17.title, var3_17, iter1_17.finishTime)

				break
			end
		end
	end
end

function var1_0.PushGuildMissionFormation(arg0_18)
	local var0_18 = getProxy(GuildProxy):getRawData()

	if not var0_18 then
		return
	end

	local var1_18 = var0_18:GetActiveEvent()

	if not var1_18 or var1_18 and not var1_18:IsParticipant() then
		return
	end

	local var2_18 = var1_18:GetUnlockMission()

	if not var2_18 then
		return
	end

	local var3_18 = var2_18:GetNextFormationTime()

	if var3_18 <= var0_0.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	local var4_18 = var0_0.push_data_template[var1_0.PUSH_TYPE_GUILD_MISSION_FORMATION]

	arg0_18:Push(var4_18.title, var4_18.content, var3_18)
end

function var1_0.log(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg3_19 - os.time()

	originalPrint(arg1_19, " - ", arg2_19, " - ", var0_19, "s后推送")
end

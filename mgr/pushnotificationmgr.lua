pg = pg or {}

local var0 = pg

var0.PushNotificationMgr = singletonClass("PushNotificationMgr")

local var1 = var0.PushNotificationMgr

var1.PUSH_TYPE_EVENT = 1
var1.PUSH_TYPE_GOLD = 2
var1.PUSH_TYPE_OIL = 3
var1.PUSH_TYPE_BACKYARD = 4
var1.PUSH_TYPE_SCHOOL = 5
var1.PUSH_TYPE_CLASS = 6
var1.PUSH_TYPE_TECHNOLOGY = 7
var1.PUSH_TYPE_BLUEPRINT = 8
var1.PUSH_TYPE_COMMANDER = 9
var1.PUSH_TYPE_GUILD_MISSION_FORMATION = 10

local var2 = {}
local var3 = false

function var1.Init(arg0)
	var2 = {}

	for iter0, iter1 in ipairs(var0.push_data_template) do
		local var0 = PlayerPrefs.GetInt("push_setting_" .. iter1.id)

		var2[iter1.id] = var0 == 0
	end

	var3 = PlayerPrefs.GetInt("setting_ship_name") == 1
end

function var1.Reset(arg0)
	var2 = {}

	for iter0, iter1 in ipairs(var0.push_data_template) do
		PlayerPrefs.SetInt("push_setting_" .. iter1.id, 0)

		var2[iter1.id] = true
	end

	PlayerPrefs.SetInt("setting_ship_name", 0)

	var3 = false
end

function var1.setSwitch(arg0, arg1, arg2)
	if not var0.push_data_template[arg1] then
		return
	end

	var2[arg1] = arg2

	PlayerPrefs.SetInt("push_setting_" .. arg1, arg2 and 0 or 1)
end

function var1.setSwitchShipName(arg0, arg1)
	var3 = arg1

	PlayerPrefs.SetInt("setting_ship_name", arg1 and 1 or 0)
end

function var1.isEnabled(arg0, arg1)
	return var2[arg1]
end

function var1.isEnableShipName(arg0)
	return var3
end

function var1.Push(arg0, arg1, arg2, arg3)
	local var0 = arg3 - var0.TimeMgr.GetInstance():GetServerTime()
	local var1 = os.time() + var0

	NotificationMgr.Inst:ScheduleLocalNotification(arg1, arg2, var1)
	arg0:log(arg1, arg2, var1)
end

function var1.cancelAll(arg0)
	NotificationMgr.Inst:CancelAllLocalNotifications()
end

function var1.PushAll(arg0)
	local var0 = getProxy(PlayerProxy)

	if var0 and var0:getInited() then
		arg0:cancelAll()

		if var2[var1.PUSH_TYPE_EVENT] then
			arg0:PushEvent()
		end

		if var2[var1.PUSH_TYPE_GOLD] then
			arg0:PushGold()
		end

		if var2[var1.PUSH_TYPE_OIL] then
			arg0:PushOil()
		end

		if var2[var1.PUSH_TYPE_BACKYARD] then
			arg0:PushBackyard()
		end

		if var2[var1.PUSH_TYPE_SCHOOL] then
			arg0:PushSchool()
		end

		if var2[var1.PUSH_TYPE_TECHNOLOGY] then
			arg0:PushTechnlogy()
		end

		if var2[var1.PUSH_TYPE_BLUEPRINT] then
			arg0:PushBluePrint()
		end

		if var2[var1.PUSH_TYPE_COMMANDER] then
			arg0:PushCommander()
		end

		if var2[var1.PUSH_TYPE_GUILD_MISSION_FORMATION] then
			arg0:PushGuildMissionFormation()
		end
	end
end

function var1.PushEvent(arg0)
	local var0 = getProxy(EventProxy):getActiveEvents()
	local var1 = var0.push_data_template[arg0.PUSH_TYPE_EVENT]

	for iter0, iter1 in ipairs(var0) do
		local var2 = string.gsub(var1.content, "$1", iter1.template.title)

		arg0:Push(var1.title, var2, iter1.finishTime)
	end
end

function var1.PushGold(arg0)
	local var0 = getProxy(NavalAcademyProxy):GetGoldVO()
	local var1 = var0:bindConfigTable()
	local var2 = var0:GetLevel()
	local var3 = var1[var2].store
	local var4 = var1[var2].production
	local var5 = var1[var2].hour_time
	local var6 = getProxy(PlayerProxy).data
	local var7 = var6.resUpdateTm
	local var8 = var6.goldField

	if var8 < var3 then
		local var9 = var7 + (var3 - var8) / var4 * 60 * 60 / 3

		if var9 > var0.TimeMgr.GetInstance():GetServerTime() then
			local var10 = var0.push_data_template[arg0.PUSH_TYPE_GOLD]

			arg0:Push(var10.title, var10.content, var9)
		end
	end
end

function var1.PushOil(arg0)
	local var0 = getProxy(NavalAcademyProxy):GetOilVO()
	local var1 = var0:bindConfigTable()
	local var2 = var0:GetLevel()
	local var3 = var1[var2].store
	local var4 = var1[var2].production
	local var5 = var1[var2].hour_time
	local var6 = getProxy(PlayerProxy).data
	local var7 = var6.resUpdateTm
	local var8 = var6.oilField

	if var8 < var3 then
		local var9 = var7 + (var3 - var8) / var4 * 60 * 60 / 3

		if var9 > var0.TimeMgr.GetInstance():GetServerTime() then
			local var10 = var0.push_data_template[arg0.PUSH_TYPE_OIL]

			arg0:Push(var10.title, var10.content, var9)
		end
	end
end

function var1.PushBackyard(arg0)
	local var0 = getProxy(DormProxy):getRawData():getFoodLeftTime()

	if var0 > var0.TimeMgr.GetInstance():GetServerTime() then
		local var1 = var0.push_data_template[arg0.PUSH_TYPE_BACKYARD]

		arg0:Push(var1.title, var1.content, var0)
	end
end

function var1.PushSchool(arg0)
	local var0 = getProxy(NavalAcademyProxy):getStudents()
	local var1 = var0.push_data_template[arg0.PUSH_TYPE_SCHOOL]
	local var2 = getProxy(BayProxy):getData()

	for iter0, iter1 in ipairs(var0) do
		if iter1.finishTime > var0.TimeMgr.GetInstance():GetServerTime() then
			local var3 = var2[iter1.shipId]
			local var4 = iter1:getSkillId(var3)
			local var5 = var3.skills[var4]
			local var6 = var3:getName()
			local var7 = getSkillName(iter1:getSkillId(var3))
			local var8 = string.gsub(var1.content, "$1", var6)
			local var9 = string.gsub(var8, "$2", var7)

			arg0:Push(var1.title, var9, iter1.finishTime)
		end
	end
end

function var1.PushTechnlogy(arg0)
	local var0 = var0.push_data_template[var1.PUSH_TYPE_TECHNOLOGY]
	local var1 = getProxy(TechnologyProxy)

	if var0 and var1 then
		local var2 = var1:getPlanningTechnologys()

		if #var2 > 0 and not var2[#var2]:isFinish() then
			arg0:Push(var0.title, var0.content, var2[#var2].time)
		end
	end
end

function var1.PushBluePrint(arg0)
	local var0 = var0.push_data_template[var1.PUSH_TYPE_BLUEPRINT]
	local var1 = getProxy(TechnologyProxy)
	local var2 = getProxy(TaskProxy)

	if var0 and var1 and var2 then
		local var3 = var1:getBuildingBluePrint()

		if var3 then
			local var4 = var3:getTaskIds()

			for iter0, iter1 in ipairs(var4) do
				local var5 = var3:getTaskOpenTimeStamp(iter1)

				if var5 > var0.TimeMgr.GetInstance():GetServerTime() then
					local var6 = var2:getTaskById(iter1) or var2:getFinishTaskById(iter1)
					local var7 = var2:isFinishPrevTasks(iter1)

					if not var6 and var7 then
						local var8 = var3:getShipVO()
						local var9 = string.gsub(var0.content, "$1", var8:getConfig("name"))

						arg0:Push(var0.title, var9, var5)
					end
				end
			end
		end
	end
end

function var1.PushCommander(arg0)
	local var0 = var0.push_data_template[var1.PUSH_TYPE_COMMANDER]
	local var1 = getProxy(CommanderProxy)

	if var0 and var1 then
		local var2 = var1:getBoxes()

		for iter0, iter1 in pairs(var2) do
			if iter1:getState() == CommanderBox.STATE_STARTING then
				local var3 = var0.content

				arg0:Push(var0.title, var3, iter1.finishTime)

				break
			end
		end
	end
end

function var1.PushGuildMissionFormation(arg0)
	local var0 = getProxy(GuildProxy):getRawData()

	if not var0 then
		return
	end

	local var1 = var0:GetActiveEvent()

	if not var1 or var1 and not var1:IsParticipant() then
		return
	end

	local var2 = var1:GetUnlockMission()

	if not var2 then
		return
	end

	local var3 = var2:GetNextFormationTime()

	if var3 <= var0.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	local var4 = var0.push_data_template[var1.PUSH_TYPE_GUILD_MISSION_FORMATION]

	arg0:Push(var4.title, var4.content, var3)
end

function var1.log(arg0, arg1, arg2, arg3)
	local var0 = arg3 - os.time()

	originalPrint(arg1, " - ", arg2, " - ", var0, "s后推送")
end

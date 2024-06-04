local var0 = class("NavalAcademyProxy", import(".NetProxy"))

var0.COURSE_START = "NavalAcademyProxy:COURSE_START"
var0.COURSE_UPDATED = "NavalAcademyProxy:COURSE_UPDATED"
var0.COURSE_REWARD = "NavalAcademyProxy:COURSE_REWARD"
var0.COURSE_CANCEL = "NavalAcademyProxy:COURSE_CANCEL"
var0.RESOURCE_UPGRADE = "NavalAcademyProxy:RESOURCE_UPGRADE"
var0.RESOURCE_UPGRADE_DONE = "NavalAcademyProxy:RESOURCE_UPGRADE_DONE"
var0.BUILDING_FINISH = "NavalAcademyProxy:BUILDING_FINISH"
var0.START_LEARN_TACTICS = "NavalAcademyProxy:START_LEARN_TACTICS"
var0.CANCEL_LEARN_TACTICS = "NavalAcademyProxy:CANCEL_LEARN_TACTICS"
var0.SKILL_CLASS_POS_UPDATED = "NavalAcademyProxy:SKILL_CLASS_POS_UPDATED"

function var0.register(arg0)
	arg0.timers = {}
	arg0.students = {}
	arg0.course = AcademyCourse.New()
	arg0.recentShips = {}

	arg0:on(22001, function(arg0)
		local var0 = OilResourceField.New()

		var0:SetLevel(arg0.oil_well_level)
		var0:SetUpgradeTimeStamp(arg0.oil_well_lv_up_time)

		arg0._oilVO = var0

		local var1 = GoldResourceField.New()

		var1:SetLevel(arg0.gold_well_level)
		var1:SetUpgradeTimeStamp(arg0.gold_well_lv_up_time)

		arg0._goldVO = var1

		local var2 = ClassResourceField.New()

		var2:SetLevel(arg0.class_lv)
		var2:SetUpgradeTimeStamp(arg0.class_lv_up_time)

		arg0._classVO = var2

		arg0.course:update(arg0.class)

		local var3 = {}

		for iter0, iter1 in ipairs(arg0.skill_class_list) do
			local var4 = Student.New(iter1)

			var3[var4.id] = var4
		end

		arg0.skillClassNum = LOCK_CLASSROOM and 2 or arg0.skill_class_num or 2

		arg0:setStudents(var3)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inClass")
		arg0:CheckResFields()

		arg0.dailyFinsihCnt = arg0.daily_finish_buff_cnt or 0
	end)
	arg0:on(22013, function(arg0)
		arg0.course:SetProficiency(arg0.proficiency)

		local var0 = getProxy(PlayerProxy):getData()

		var0.expField = arg0.exp_in_well

		getProxy(PlayerProxy):updatePlayer(var0)
		arg0:sendNotification(var0.COURSE_UPDATED)
	end)
end

function var0.GetRecentShips(arg0)
	if #arg0.recentShips > 0 then
		for iter0 = #arg0.recentShips, 1, -1 do
			local var0 = arg0.recentShips[iter0]
			local var1 = getProxy(BayProxy):RawGetShipById(var0)

			if not var1 or _.all(var1:getSkillList(), function(arg0)
				return ShipSkill.New(var1.skills[arg0]):IsMaxLevel()
			end) then
				table.remove(arg0.recentShips, iter0)
			end
		end

		return arg0.recentShips
	end

	local var2 = getProxy(PlayerProxy):getRawData().id
	local var3 = PlayerPrefs.GetString("NavTacticsRecentShipId" .. var2)
	local var4 = string.split(var3, "#")

	for iter1, iter2 in ipairs(var4) do
		local var5 = tonumber(iter2) or 0

		if var5 > 0 then
			local var6 = getProxy(BayProxy):RawGetShipById(var5)

			if var6 and not table.contains(arg0.recentShips, var5) and _.any(var6:getSkillList(), function(arg0)
				return not ShipSkill.New(var6.skills[arg0]):IsMaxLevel()
			end) then
				table.insert(arg0.recentShips, var5)
			end
		end
	end

	return arg0.recentShips
end

function var0.SaveRecentShip(arg0, arg1)
	if not table.contains(arg0.recentShips, arg1) then
		table.insert(arg0.recentShips, arg1)

		for iter0 = 1, #arg0.recentShips - 11 do
			table.remove(arg0.recentShips, iter0)
		end

		local var0 = table.concat(arg0.recentShips, "#")
		local var1 = getProxy(PlayerProxy):getRawData().id

		PlayerPrefs.SetString("NavTacticsRecentShipId" .. var1, var0)
		PlayerPrefs.Save()
	end
end

function var0.getSkillClassNum(arg0)
	return arg0.skillClassNum
end

var0.MAX_SKILL_CLASS_NUM = 4

function var0.inCreaseKillClassNum(arg0)
	arg0.skillClassNum = math.min(arg0.skillClassNum + 1, var0.MAX_SKILL_CLASS_NUM)

	arg0:sendNotification(var0.SKILL_CLASS_POS_UPDATED, arg0.skillClassNum)
end

function var0.onRemove(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = nil

	var0.super.onRemove(arg0)
end

function var0.ExistStudent(arg0, arg1)
	return arg0.students[arg1] ~= nil
end

function var0.getStudentById(arg0, arg1)
	if arg0.students[arg1] then
		return arg0.students[arg1]:clone()
	end
end

function var0.getStudentIdByShipId(arg0, arg1)
	for iter0, iter1 in pairs(arg0.students) do
		if iter1.shipId == arg1 then
			return iter1.id
		end
	end
end

function var0.getStudentByShipId(arg0, arg1)
	for iter0, iter1 in pairs(arg0.students) do
		if iter1.shipId == arg1 then
			return iter1
		end
	end
end

function var0.setStudents(arg0, arg1)
	arg0.students = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
end

function var0.getStudents(arg0)
	return Clone(arg0.students)
end

function var0.RawGetStudentList(arg0)
	return arg0.students
end

function var0.addStudent(arg0, arg1)
	arg0.students[arg1.id] = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
	arg0:sendNotification(var0.START_LEARN_TACTICS, Clone(arg1))
end

function var0.updateStudent(arg0, arg1)
	arg0.students[arg1.id] = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
end

function var0.deleteStudent(arg0, arg1)
	arg0.students[arg1] = nil

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inTactics")
	arg0:sendNotification(var0.CANCEL_LEARN_TACTICS, arg1)
end

function var0.GetOilVO(arg0)
	return arg0._oilVO
end

function var0.GetGoldVO(arg0)
	return arg0._goldVO
end

function var0.GetClassVO(arg0)
	return arg0._classVO
end

function var0.getCourse(arg0)
	return Clone(arg0.course)
end

function var0.setCourse(arg0, arg1)
	arg0.course = arg1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inClass")
end

function var0.GetShipIDs(arg0)
	return {}
end

function var0.CheckResFields(arg0)
	if arg0._oilVO:IsStarting() then
		arg0:AddResFieldListener(arg0._oilVO)
	end

	if arg0._goldVO:IsStarting() then
		arg0:AddResFieldListener(arg0._goldVO)
	end

	if arg0._classVO:IsStarting() then
		arg0:AddResFieldListener(arg0._classVO)
	end
end

function var0.StartUpGradeSuccess(arg0, arg1)
	local var0 = arg1:bindConfigTable()[arg1:GetLevel()].time

	arg1:SetUpgradeTimeStamp(pg.TimeMgr.GetInstance():GetServerTime() + var0)
	arg0:AddResFieldListener(arg1)
	arg0.facade:sendNotification(var0.RESOURCE_UPGRADE, {
		resVO = arg1
	})
end

function var0.AddResFieldListener(arg0, arg1)
	local var0 = arg1._upgradeTimeStamp - pg.TimeMgr.GetInstance():GetServerTime()

	if var0 > 0 then
		local var1 = arg1:GetUpgradeType()

		if arg0.timers[var1] then
			arg0.timers[var1]:Stop()

			arg0.timers[var1] = nil
		end

		arg0.timers[var1] = Timer.New(function()
			arg0:UpgradeFinish()
			arg0.timers[var1]:Stop()

			arg0.timers[var1] = nil
		end, var0, 1)

		arg0.timers[var1]:Start()
	end
end

function var0.UpgradeFinish(arg0)
	if arg0._goldVO:GetDuration() and arg0._goldVO:GetDuration() <= 0 then
		local var0 = arg0._goldVO:bindConfigTable()[arg0._goldVO:GetLevel()].store

		arg0._goldVO:SetLevel(arg0._goldVO:GetLevel() + 1)
		arg0._goldVO:SetUpgradeTimeStamp(0)

		local var1 = arg0._goldVO:bindConfigTable()[arg0._goldVO:GetLevel()].store

		arg0:sendNotification(var0.RESOURCE_UPGRADE_DONE, {
			field = arg0._goldVO,
			value = var1 - var0
		})
	end

	if arg0._oilVO:GetDuration() and arg0._oilVO:GetDuration() <= 0 then
		local var2 = arg0._oilVO:bindConfigTable()[arg0._oilVO:GetLevel()].store

		arg0._oilVO:SetLevel(arg0._oilVO:GetLevel() + 1)
		arg0._oilVO:SetUpgradeTimeStamp(0)

		local var3 = arg0._oilVO:bindConfigTable()[arg0._oilVO:GetLevel()].store

		arg0:sendNotification(var0.RESOURCE_UPGRADE_DONE, {
			field = arg0._oilVO,
			value = var3 - var2
		})
	end

	if arg0._classVO:GetDuration() and arg0._classVO:GetDuration() <= 0 then
		local var4 = arg0._classVO:bindConfigTable()[arg0._classVO:GetLevel()].store
		local var5 = arg0._classVO:bindConfigTable()[arg0._classVO:GetLevel()].proficency_get_percent
		local var6 = arg0._classVO:bindConfigTable()[arg0._classVO:GetLevel()].proficency_cost_per_min

		arg0._classVO:SetLevel(arg0._classVO:GetLevel() + 1)
		arg0._classVO:SetUpgradeTimeStamp(0)

		local var7 = arg0._classVO:bindConfigTable()[arg0._classVO:GetLevel()].store
		local var8 = arg0._classVO:bindConfigTable()[arg0._classVO:GetLevel()].proficency_get_percent
		local var9 = arg0._classVO:bindConfigTable()[arg0._classVO:GetLevel()].proficency_cost_per_min

		arg0:sendNotification(var0.RESOURCE_UPGRADE_DONE, {
			field = arg0._classVO,
			value = var7 - var4,
			rate = var8 - var5,
			exp = (var9 - var6) * 60
		})
	end
end

function var0.isResourceFieldUpgradeConditionSatisfy(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	if arg0:GetOilVO():CanUpgrade(var0.level, var0.gold) or arg0:GetGoldVO():CanUpgrade(var0.level, var0.gold) or arg0:GetClassVO():CanUpgrade(var0.level, var0.gold) then
		return true
	end

	return false
end

function var0.AddCourseProficiency(arg0, arg1)
	local var0 = arg0:getCourse()
	local var1 = arg0:GetClassVO()
	local var2 = var1:GetExp2ProficiencyRatio() * var0:getExtraRate()
	local var3 = var0:GetProficiency() + math.floor(arg1 * var2 * 0.01)
	local var4 = math.min(var3, var1:GetMaxProficiency())

	var0:SetProficiency(var4)
	arg0:setCourse(var0)
end

function var0.fillStudens(arg0, arg1)
	local var0 = pg.gameset.academy_random_ship_count.key_value
	local var1 = {}

	for iter0, iter1 in pairs(arg1) do
		var1[iter1.groupId] = true
		var0 = var0 - 1
	end

	local var2 = pg.gameset.academy_random_ship_coldtime.key_value

	if not arg0._timeStamp or var2 < os.time() - arg0._timeStamp then
		arg0._studentsFiller = nil
	end

	if not arg0._studentsFiller then
		local var3 = math.random(1, var0)

		arg0._timeStamp = os.time()
		arg0._studentsFiller = {}

		local var4 = getProxy(CollectionProxy):getGroups()
		local var5 = getProxy(BayProxy)
		local var6 = getProxy(ShipSkinProxy):getSkinList()
		local var7 = {}

		for iter2, iter3 in pairs(var4) do
			if not table.contains(var1, iter2) then
				var7[#var7 + 1] = iter2
			end
		end

		local var8 = #var7

		while var3 > 0 and var8 > 0 do
			local var9 = math.random(#var7)
			local var10 = var7[var9]
			local var11 = var4[var10]
			local var12 = var10 * 10 + 1
			local var13 = 10000000000 + var12
			local var14 = ShipGroup.getSkinList(var10)
			local var15 = {}
			local var16
			local var17 = {}

			for iter4, iter5 in ipairs(var14) do
				local var18 = iter5.skin_type

				if var18 == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var6, iter5.id) or var18 == ShipSkin.SKIN_TYPE_REMAKE and var11.trans or var18 == ShipSkin.SKIN_TYPE_PROPOSE and var11.married == 1 then
					var17[#var17 + 1] = iter5.id
				end

				var16 = var17[math.random(#var17)]
			end

			local var19 = {
				id = var13,
				groupId = var10,
				configId = var12,
				skin_id = var16
			}

			table.remove(var7, var9)

			var8 = var8 - 1
			var3 = var3 - 1
			arg0._studentsFiller[#arg0._studentsFiller + 1] = var19
		end
	end

	for iter6, iter7 in ipairs(arg0._studentsFiller) do
		arg1[#arg1 + 1] = Ship.New(iter7)
	end

	return arg1
end

function var0.IsShowTip(arg0)
	local var0 = getProxy(PlayerProxy)

	if var0 and var0:getData() and arg0:isResourceFieldUpgradeConditionSatisfy() then
		return true
	end

	local var1 = getProxy(ShopsProxy)

	if var1 then
		local var2 = var1:getShopStreet()

		if var2 and var2:isUpdateGoods() then
			return true
		end
	end

	local var3 = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0, iter1 in pairs(arg0.students) do
		if var3 >= iter1:getFinishTime() then
			return true
		end
	end

	if getProxy(CollectionProxy):unclaimTrophyCount() > 0 then
		return true
	end

	local var4 = getProxy(TaskProxy)

	if _.any(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST), function(arg0)
		local var0 = arg0:getTaskShip()
		local var1 = var0 and var4:getAcademyTask(var0.groupId) or nil
		local var2 = var4:getTaskById(var1)
		local var3 = var4:getFinishTaskById(var1)

		return var0 and (var1 and not var2 and not var3 or var2 and var2:isFinish())
	end) then
		return true
	end

	return false
end

function var0.getDailyFinishCnt(arg0)
	local var0 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0)
		return arg0:getConfig("benefit_type") == "skill_learn_time"
	end)

	return (var0 and tonumber(var0:getConfig("benefit_effect")) or 0) - arg0.dailyFinsihCnt
end

function var0.updateUsedDailyFinishCnt(arg0)
	arg0.dailyFinsihCnt = arg0.dailyFinsihCnt + 1
end

function var0.resetUsedDailyFinishCnt(arg0)
	arg0.dailyFinsihCnt = 0
end

return var0

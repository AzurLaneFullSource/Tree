local var0 = class("MetaProgress", import("..BaseVO"))

var0.STATE_LESS_PT = 1
var0.STATE_LESS_STORY = 2
var0.STATE_CAN_AWARD = 3
var0.STATE_CAN_FINISH = 4
var0.STATE_GOT_SHIP = 5

function var0.bindConfigTable(arg0)
	return pg.ship_strengthen_meta
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.metaType = arg0:getConfig("type")
	arg0.actID = arg0:getConfig("activity_id")
	arg0.metaShipVO = nil

	if arg0:isPtType() then
		arg0.unlockPTNum = arg0:getConfig("synchronize")
		arg0.unlockPTLevel = nil
		arg0.metaPtData = MetaPTData.New({
			group_id = arg0.id
		})

		local var0

		for iter0, iter1 in ipairs(pg.world_joint_boss_template.all) do
			local var1 = pg.world_joint_boss_template[iter1]

			if var1.meta_id == arg0.id then
				var0 = var1

				break
			end
		end

		if var0 then
			arg0.timeConfig = var0.state
		end
	end
end

function var0.updateMetaPtData(arg0, arg1)
	if arg0.metaPtData then
		arg0.metaPtData:Update(arg1)
	end
end

function var0.getSynRate(arg0)
	local var0, var1, var2 = arg0.metaPtData:GetResProgress()

	return var0 / arg0.unlockPTNum
end

function var0.getStoryIndexList(arg0)
	return arg0:getConfig("unlock_story") or {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
end

function var0.getCurLevelStoryIndex(arg0)
	local var0, var1, var2 = arg0.metaPtData:GetLevelProgress()

	return arg0:getStoryIndexList()[var0]
end

function var0.isFinishCurLevelStory(arg0)
	local var0 = arg0:getCurLevelStoryIndex()
	local var1 = false

	if var0 == 0 then
		var1 = true
	else
		local var2 = pg.NewStoryMgr.GetInstance()
		local var3 = var2:StoryName2StoryId(var0)

		if var2:IsPlayed(var3) then
			var1 = true
		end
	end

	return var1
end

function var0.getCurLevelStoryName(arg0)
	local var0 = arg0:getCurLevelStoryIndex()

	return pg.memory_template[var0].title
end

function var0.isCanGetAward(arg0)
	local var0 = arg0.metaPtData:CanGetAward()
	local var1 = arg0:getCurLevelStoryIndex()
	local var2 = false

	if var1 == 0 then
		var2 = true
	else
		local var3 = pg.NewStoryMgr.GetInstance()
		local var4 = var3:GetStoryByName("index")[var1]

		if var3:IsPlayed(var1) then
			var2 = true
		end
	end

	return var0 and var2
end

function var0.getMetaProgressPTState(arg0)
	local var0 = arg0.metaPtData:CanGetAward()
	local var1 = arg0:isFinishCurLevelStory()
	local var2 = arg0:isUnlocked()
	local var3 = arg0.metaPtData.level + 1

	if var3 < arg0.unlockPTLevel then
		if not var0 then
			return var0.STATE_LESS_PT
		elseif var1 == false then
			return var0.STATE_LESS_STORY
		elseif var1 == true then
			return var0.STATE_CAN_AWARD
		end
	elseif var3 == arg0.unlockPTLevel then
		if not var0 then
			return var0.STATE_LESS_PT
		elseif var1 == false then
			return var0.STATE_LESS_STORY
		elseif var1 == true then
			return var0.STATE_CAN_FINISH
		end
	elseif var3 > arg0.unlockPTLevel then
		return var0.STATE_GOT_SHIP
	end
end

function var0.IsGotAllAwards(arg0)
	return arg0:isInAct() and arg0:isInArchive() and not arg0.metaPtData:CanGetNextAward()
end

function var0.getRepairRateFromMetaCharacter(arg0)
	assert(arg0.metaShipVO, "metaShipVO is null")

	local var0 = arg0.metaShipVO.metaCharacter

	assert(var0, "metaCharacterVO is null")

	return (var0:getRepairRate())
end

function var0.isPtType(arg0)
	return arg0.metaType == MetaCharacterConst.Meta_Type_Act_PT
end

function var0.isPassType(arg0)
	return arg0.metaType == MetaCharacterConst.Meta_Type_Pass
end

function var0.isBuildType(arg0)
	return arg0.metaType == MetaCharacterConst.Meta_Type_Build
end

function var0.isInAct(arg0)
	if arg0:isPtType() then
		return WorldBossConst.IsCurrBoss(arg0.id)
	elseif arg0:isPassType() or arg0:isBuildType() then
		local var0 = arg0:getConfig("activity_id")
		local var1 = getProxy(ActivityProxy):getActivityById(var0)

		return var1 and not var1:isEnd()
	end
end

function var0.isInArchive(arg0)
	return WorldBossConst.IsAchieveBoss(arg0.id)
end

function var0.isUnlocked(arg0)
	return arg0.metaShipVO ~= nil
end

function var0.isShow(arg0)
	local var0 = arg0:isInAct()
	local var1 = arg0:isInArchive()
	local var2 = arg0:isUnlocked()
	local var3 = true

	if var2 then
		return true
	elseif var1 then
		return true
	elseif var0 then
		if arg0:isPtType() and var3 then
			return true
		elseif arg0:isPassType() or arg0:isBuildType() then
			return true
		else
			return false
		end
	else
		return false
	end
end

function var0.getMetaShipFromBayProxy(arg0)
	local var0 = getProxy(BayProxy):getMetaShipByGroupId(arg0.configId)

	arg0.metaShipVO = var0

	return var0
end

function var0.getShip(arg0)
	return arg0.metaShipVO
end

function var0.updateShip(arg0, arg1)
	assert(arg1, "metaShipVO can not be null!")

	arg0.metaShipVO = arg1
end

function var0.setDataBeforeGet(arg0)
	arg0.metaShipVO = arg0:getMetaShipFromBayProxy()

	if arg0:isPtType() and arg0.metaPtData and not arg0.unlockPTLevel then
		local var0 = arg0.metaPtData.targets

		for iter0, iter1 in ipairs(var0) do
			if iter1 == arg0.unlockPTNum then
				arg0.unlockPTLevel = iter0

				break
			end
		end
	end

	if (arg0:isPassType() or arg0:isBuildType()) and not arg0.timeConfig then
		local var1 = arg0:getConfig("activity_id")
		local var2 = getProxy(ActivityProxy):getActivityById(var1)

		if var2 then
			arg0.timeConfig = {
				var2:getConfig("time")[2],
				var2:getConfig("time")[3]
			}
		end
	end
end

function var0.updateDataAfterAddShip(arg0)
	arg0.metaShipVO = arg0:getMetaShipFromBayProxy()
end

function var0.addPT(arg0, arg1)
	if arg0:isPtType() and arg0.metaPtData then
		arg0.metaPtData:addPT(arg1)
	end
end

function var0.updatePTLevel(arg0, arg1)
	if arg0:isPtType() and arg0.metaPtData then
		arg0.metaPtData:updateLevel(arg1)
	end
end

function var0.getPaintPathAndName(arg0)
	local var0 = arg0:isUnlocked()
	local var1, var2 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0.configId, var0)

	return var1, var2
end

function var0.getBannerPathAndName(arg0)
	local var0, var1 = MetaCharacterConst.GetMetaCharacterBannerPath(arg0.configId)

	return var0, var1
end

function var0.getBGNamePathAndName(arg0)
	local var0, var1 = MetaCharacterConst.GetMetaCharacterNamePath(arg0.configId)

	return var0, var1
end

function var0.getPtIconPath(arg0)
	assert(arg0:isPtType() and arg0.metaPtData)

	return Item.getConfigData(arg0.metaPtData.resId).icon
end

return var0

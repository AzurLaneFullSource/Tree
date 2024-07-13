pg = pg or {}
pg.SystemOpenMgr = singletonClass("SystemOpenMgr")

local var0_0 = pg.SystemOpenMgr
local var1_0 = true
local var2_0 = pg.open_systems_limited

function var0_0.Init(arg0_1, arg1_1)
	print("initializing SystemOpenMgr manager...")
	arg1_1()
end

local var3_0 = pm.Facade.sendNotification

function pm.Facade.sendNotification(arg0_2, arg1_2, arg2_2, arg3_2)
	if var1_0 and arg1_2 == GAME.LOAD_SCENE and arg2_2.context.mediator then
		local var0_2 = getProxy(PlayerProxy)
		local var1_2 = arg2_2.context.mediator.__cname

		if var0_2 then
			local var2_2 = var0_2:getRawData()

			if var2_2 then
				local var3_2, var4_2 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var2_2.level, var1_2)

				if not var3_2 then
					pg.TipsMgr.GetInstance():ShowTips(var4_2)

					return
				end
			end
		end

		if HXSet.isHxSkin() and var1_2 == "SkinShopMediator" then
			return
		end

		var3_0(arg0_2, GAME.CHECK_HOTFIX_VER, {
			mediatorName = var1_2
		})
	end

	if arg1_2 == GAME.BEGIN_STAGE then
		pg.GuildMsgBoxMgr.GetInstance():OnBeginBattle()
	end

	if arg1_2 == GAME.FINISH_STAGE_DONE then
		pg.GuildMsgBoxMgr.GetInstance():OnFinishBattle(arg2_2)
	end

	var3_0(arg0_2, arg1_2, arg2_2, arg3_2)
end

local function var4_0(arg0_3)
	local var0_3 = var2_0[14].level
	local var1_3 = var2_0[14].name

	if var0_3 == arg0_3 then
		if pg.NewStoryMgr.GetInstance():IsPlayed("ZHIHUIMIAO1") or IsUnityEditor then
			return true
		else
			return false, i18n("no_open_system_tip", var1_3, var0_3)
		end
	elseif var0_3 < arg0_3 then
		return true
	else
		return false, i18n("no_open_system_tip", var1_3, var0_3)
	end
end

function var0_0.isOpenSystem(arg0_4, arg1_4, arg2_4)
	if arg2_4 == "EquipmentTransformTreeMediator" and LOCK_EQUIPMENT_TRANSFORM then
		return false
	end

	if arg2_4 == "CommanderCatMediator" then
		return var4_0(arg1_4)
	else
		for iter0_4, iter1_4 in pairs(var2_0.all) do
			if var2_0[iter1_4].mediator == arg2_4 and arg1_4 < var2_0[iter1_4].level then
				return false, i18n("no_open_system_tip", var2_0[iter1_4].name, var2_0[iter1_4].level)
			end
		end

		return true
	end
end

local function var5_0(arg0_5)
	local var0_5 = _.sort(var2_0.all, function(arg0_6, arg1_6)
		return var2_0[arg0_6].level > var2_0[arg1_6].level
	end)

	for iter0_5, iter1_5 in pairs(var0_5) do
		local var1_5 = var2_0[iter1_5]

		if arg0_5 >= var1_5.level then
			return var1_5
		end
	end
end

function var0_0.notification(arg0_7, arg1_7)
	if not var1_0 then
		return
	end

	local var0_7 = var5_0(arg1_7)

	if var0_7 and not pg.MsgboxMgr.GetInstance()._go.activeSelf and var0_7.story_id and var0_7.story_id ~= "" and not arg0_7.active and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_7.story_id) and not pg.SeriesGuideMgr.GetInstance():isNotFinish() then
		arg0_7.active = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("open_system_tip", var0_7.name),
			weight = LayerWeightConst.TOP_LAYER,
			onYes = function()
				arg0_7:doSystemGuide(var0_7.id)
			end
		})
	end
end

function var0_0.doSystemGuide(arg0_9, arg1_9)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	local var0_9 = pg.open_systems_limited[arg1_9]
	local var1_9 = var0_9.story_id

	if var1_9 and var1_9 ~= "" then
		if getProxy(ContextProxy):getCurrentContext().scene ~= SCENE[var0_9.scene] then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[var0_9.scene])
		end

		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var1_9, {}, function()
			arg0_9.active = nil
		end)
	end
end

pg = pg or {}
pg.SystemOpenMgr = singletonClass("SystemOpenMgr")

local var0 = pg.SystemOpenMgr
local var1 = true
local var2 = pg.open_systems_limited

function var0.Init(arg0, arg1)
	print("initializing SystemOpenMgr manager...")
	arg1()
end

local var3 = pm.Facade.sendNotification

function pm.Facade.sendNotification(arg0, arg1, arg2, arg3)
	if var1 and arg1 == GAME.LOAD_SCENE and arg2.context.mediator then
		local var0 = getProxy(PlayerProxy)
		local var1 = arg2.context.mediator.__cname

		if var0 then
			local var2 = var0:getRawData()

			if var2 then
				local var3, var4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var2.level, var1)

				if not var3 then
					pg.TipsMgr.GetInstance():ShowTips(var4)

					return
				end
			end
		end

		if HXSet.isHxSkin() and var1 == "SkinShopMediator" then
			return
		end

		var3(arg0, GAME.CHECK_HOTFIX_VER, {
			mediatorName = var1
		})
	end

	if arg1 == GAME.BEGIN_STAGE then
		pg.GuildMsgBoxMgr.GetInstance():OnBeginBattle()
	end

	if arg1 == GAME.FINISH_STAGE_DONE then
		pg.GuildMsgBoxMgr.GetInstance():OnFinishBattle(arg2)
	end

	var3(arg0, arg1, arg2, arg3)
end

local function var4(arg0)
	local var0 = var2[14].level
	local var1 = var2[14].name

	if var0 == arg0 then
		if pg.NewStoryMgr.GetInstance():IsPlayed("ZHIHUIMIAO1") or IsUnityEditor then
			return true
		else
			return false, i18n("no_open_system_tip", var1, var0)
		end
	elseif var0 < arg0 then
		return true
	else
		return false, i18n("no_open_system_tip", var1, var0)
	end
end

function var0.isOpenSystem(arg0, arg1, arg2)
	if arg2 == "EquipmentTransformTreeMediator" and LOCK_EQUIPMENT_TRANSFORM then
		return false
	end

	if arg2 == "CommanderCatMediator" then
		return var4(arg1)
	else
		for iter0, iter1 in pairs(var2.all) do
			if var2[iter1].mediator == arg2 and arg1 < var2[iter1].level then
				return false, i18n("no_open_system_tip", var2[iter1].name, var2[iter1].level)
			end
		end

		return true
	end
end

local function var5(arg0)
	local var0 = _.sort(var2.all, function(arg0, arg1)
		return var2[arg0].level > var2[arg1].level
	end)

	for iter0, iter1 in pairs(var0) do
		local var1 = var2[iter1]

		if arg0 >= var1.level then
			return var1
		end
	end
end

function var0.notification(arg0, arg1)
	if not var1 then
		return
	end

	local var0 = var5(arg1)

	if var0 and not pg.MsgboxMgr.GetInstance()._go.activeSelf and var0.story_id and var0.story_id ~= "" and not arg0.active and not pg.NewStoryMgr.GetInstance():IsPlayed(var0.story_id) and not pg.SeriesGuideMgr.GetInstance():isNotFinish() then
		arg0.active = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("open_system_tip", var0.name),
			weight = LayerWeightConst.TOP_LAYER,
			onYes = function()
				arg0:doSystemGuide(var0.id)
			end
		})
	end
end

function var0.doSystemGuide(arg0, arg1)
	if IsUnityEditor and not ENABLE_GUIDE then
		return
	end

	local var0 = pg.open_systems_limited[arg1]
	local var1 = var0.story_id

	if var1 and var1 ~= "" then
		if getProxy(ContextProxy):getCurrentContext().scene ~= SCENE[var0.scene] then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[var0.scene])
		end

		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var1, {}, function()
			arg0.active = nil
		end)
	end
end

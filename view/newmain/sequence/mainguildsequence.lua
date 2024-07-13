local var0_0 = class("MainGuildSequence")

function var0_0.Ctor(arg0_1)
	arg0_1.ignores = {}
	arg0_1.refreshTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.Execute(arg0_2, arg1_2)
	local var0_2 = getProxy(GuildProxy):getRawData()

	if not var0_2 then
		arg1_2()

		return
	end

	local var1_2 = var0_2:GetActiveEvent()

	if not var1_2 or not var1_2:IsParticipant() then
		arg1_2()

		return
	end

	local var2_2, var3_2 = var1_2:AnyMissionFirstFleetCanFroamtion()

	if var2_2 and var3_2 and table.contains(arg0_2.ignores, var3_2.id) then
		arg1_2()

		return
	end

	if var2_2 then
		arg0_2:Notify(arg1_2)
	elseif pg.TimeMgr.GetInstance():GetServerTime() - arg0_2.refreshTime > 900 then
		arg0_2:RefreshEvent(var1_2, false, arg1_2)
	else
		arg0_2:Notify(arg1_2)
	end
end

function var0_0.RefreshEvent(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg1_3:GetUnlockMission()

	if var0_3 and (not arg2_3 or var0_3.id ~= arg2_3.id) then
		pg.m02:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = var0_3.id,
			callback = function()
				arg0_3:RefreshEvent(arg1_3, var0_3, arg3_3)
			end
		})

		arg0_3.refreshTime = pg.TimeMgr.GetInstance():GetServerTime()
	else
		arg0_3:Notify(arg3_3)
	end
end

function var0_0.Notify(arg0_5, arg1_5)
	pg.GuildMsgBoxMgr.GetInstance():Notification({
		condition = function()
			local var0_6, var1_6 = getProxy(GuildProxy):getRawData():GetActiveEvent():AnyMissionFirstFleetCanFroamtion()

			if var0_6 and not table.contains(arg0_5.ignores, var1_6.id) then
				table.insert(arg0_5.ignores, var1_6.id)

				return true
			end

			return false
		end,
		content = i18n("guild_operation_event_occurrence"),
		OnYes = function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
				page = "battle"
			})
		end,
		OnNo = arg1_5
	})
end

function var0_0.Dispose(arg0_8)
	arg0_8.ignores = {}
	arg0_8.refreshTime = nil
end

return var0_0

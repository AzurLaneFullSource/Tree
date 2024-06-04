local var0 = class("MainGuildSequence")

function var0.Ctor(arg0)
	arg0.ignores = {}
	arg0.refreshTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.Execute(arg0, arg1)
	local var0 = getProxy(GuildProxy):getRawData()

	if not var0 then
		arg1()

		return
	end

	local var1 = var0:GetActiveEvent()

	if not var1 or not var1:IsParticipant() then
		arg1()

		return
	end

	local var2, var3 = var1:AnyMissionFirstFleetCanFroamtion()

	if var2 and var3 and table.contains(arg0.ignores, var3.id) then
		arg1()

		return
	end

	if var2 then
		arg0:Notify(arg1)
	elseif pg.TimeMgr.GetInstance():GetServerTime() - arg0.refreshTime > 900 then
		arg0:RefreshEvent(var1, false, arg1)
	else
		arg0:Notify(arg1)
	end
end

function var0.RefreshEvent(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetUnlockMission()

	if var0 and (not arg2 or var0.id ~= arg2.id) then
		pg.m02:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = var0.id,
			callback = function()
				arg0:RefreshEvent(arg1, var0, arg3)
			end
		})

		arg0.refreshTime = pg.TimeMgr.GetInstance():GetServerTime()
	else
		arg0:Notify(arg3)
	end
end

function var0.Notify(arg0, arg1)
	pg.GuildMsgBoxMgr.GetInstance():Notification({
		condition = function()
			local var0, var1 = getProxy(GuildProxy):getRawData():GetActiveEvent():AnyMissionFirstFleetCanFroamtion()

			if var0 and not table.contains(arg0.ignores, var1.id) then
				table.insert(arg0.ignores, var1.id)

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
		OnNo = arg1
	})
end

function var0.Dispose(arg0)
	arg0.ignores = {}
	arg0.refreshTime = nil
end

return var0

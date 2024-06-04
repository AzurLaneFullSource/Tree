local var0 = class("GameHallListPanel")
local var1 = false

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0.content = findTF(arg0._tf, "ad/viewport/content")
	arg0.listTpl = findTF(arg0.content, "listTpl")

	setActive(arg0.listTpl, false)

	arg0.gameRoomDatas = {}

	for iter0, iter1 in ipairs(pg.game_room_template.all) do
		local var0 = pg.game_room_template[iter1].unlock_time

		if pg.TimeMgr:GetInstance():Table2ServerTime({
			year = var0[1][1],
			month = var0[1][2],
			day = var0[1][3],
			hour = var0[2][1],
			min = var0[2][2],
			sec = var0[2][3]
		}) < pg.TimeMgr:GetInstance():GetServerTime() then
			table.insert(arg0.gameRoomDatas, Clone(pg.game_room_template[iter1]))
		end
	end

	for iter2 = 1, #arg0.gameRoomDatas do
		local var1 = tf(instantiate(go(arg0.listTpl)))
		local var2 = arg0.gameRoomDatas[iter2]

		setParent(var1, arg0.content)
		setActive(var1, true)

		local var3 = var2.icon
		local var4 = var2.id
		local var5 = getProxy(GameRoomProxy):getRoomScore(var4)

		setActive(findTF(var1, "empty"), var5 == 0)
		setActive(findTF(var1, "total"), var5 > 0)
		setActive(findTF(var1, "txtScore"), var5 > 0)

		local var6

		if var5 < 10 then
			var6 = "00" .. var5
		elseif var5 < 100 then
			var6 = "0" .. var5
		else
			var6 = "" .. var5
		end

		setText(findTF(var1, "txtScore"), var6)
		setImageSprite(findTF(var1, "mask/gameIcon"), LoadSprite("gamehallicon/" .. var3), true)
		onButton(arg0._event, var1, function()
			arg0._event:emit(GameHallMediator.OPEN_MINI_GAME, var2)
		end, SFX_CANCEL)
	end
end

function var0.setVisible(arg0, arg1)
	setActive(arg0._tf, arg1)

	if arg1 then
		local var0 = getProxy(GameRoomProxy):ticketMaxTip()

		if var0 and not GameRoomProxy.ticket_remind then
			GameRoomProxy.ticket_remind = true

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0,
				onYes = function()
					return
				end,
				onNo = function()
					arg0:setVisible(false)
				end
			})
		end
	end
end

function var0.getVisible(arg0)
	return isActive(arg0._tf)
end

function var0.dispose(arg0)
	return
end

return var0

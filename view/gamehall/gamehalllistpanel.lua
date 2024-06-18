local var0_0 = class("GameHallListPanel")
local var1_0 = false

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.content = findTF(arg0_1._tf, "ad/viewport/content")
	arg0_1.listTpl = findTF(arg0_1.content, "listTpl")

	setActive(arg0_1.listTpl, false)

	arg0_1.gameRoomDatas = {}

	for iter0_1, iter1_1 in ipairs(pg.game_room_template.all) do
		local var0_1 = pg.game_room_template[iter1_1].unlock_time

		if pg.TimeMgr:GetInstance():Table2ServerTime({
			year = var0_1[1][1],
			month = var0_1[1][2],
			day = var0_1[1][3],
			hour = var0_1[2][1],
			min = var0_1[2][2],
			sec = var0_1[2][3]
		}) < pg.TimeMgr:GetInstance():GetServerTime() then
			table.insert(arg0_1.gameRoomDatas, Clone(pg.game_room_template[iter1_1]))
		end
	end

	for iter2_1 = 1, #arg0_1.gameRoomDatas do
		local var1_1 = tf(instantiate(go(arg0_1.listTpl)))
		local var2_1 = arg0_1.gameRoomDatas[iter2_1]

		setParent(var1_1, arg0_1.content)
		setActive(var1_1, true)

		local var3_1 = var2_1.icon
		local var4_1 = var2_1.id
		local var5_1 = getProxy(GameRoomProxy):getRoomScore(var4_1)

		setActive(findTF(var1_1, "empty"), var5_1 == 0)
		setActive(findTF(var1_1, "total"), var5_1 > 0)
		setActive(findTF(var1_1, "txtScore"), var5_1 > 0)

		local var6_1

		if var5_1 < 10 then
			var6_1 = "00" .. var5_1
		elseif var5_1 < 100 then
			var6_1 = "0" .. var5_1
		else
			var6_1 = "" .. var5_1
		end

		setText(findTF(var1_1, "txtScore"), var6_1)
		setImageSprite(findTF(var1_1, "mask/gameIcon"), LoadSprite("gamehallicon/" .. var3_1), true)
		onButton(arg0_1._event, var1_1, function()
			arg0_1._event:emit(GameHallMediator.OPEN_MINI_GAME, var2_1)
		end, SFX_CANCEL)
	end
end

function var0_0.setVisible(arg0_3, arg1_3)
	setActive(arg0_3._tf, arg1_3)

	if arg1_3 then
		local var0_3 = getProxy(GameRoomProxy):ticketMaxTip()

		if var0_3 and not GameRoomProxy.ticket_remind then
			GameRoomProxy.ticket_remind = true

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var0_3,
				onYes = function()
					return
				end,
				onNo = function()
					arg0_3:setVisible(false)
				end
			})
		end
	end
end

function var0_0.getVisible(arg0_6)
	return isActive(arg0_6._tf)
end

function var0_0.dispose(arg0_7)
	return
end

return var0_0

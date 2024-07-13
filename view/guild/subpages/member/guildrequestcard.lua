local var0_0 = class("GuildRequestCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tf = tf(arg1_1)
	arg0_1.nameTF = arg0_1.tf:Find("frame/request_info/name"):GetComponent(typeof(Text))
	arg0_1.levelTF = arg0_1.tf:Find("frame/request_info/level"):GetComponent(typeof(Text))
	arg0_1.dateTF = arg0_1.tf:Find("frame/request_info/date"):GetComponent(typeof(Text))
	arg0_1.msg = arg0_1.tf:Find("frame/request_content/Text"):GetComponent(typeof(Text))
	arg0_1.iconTF = arg0_1.tf:Find("frame/shipicon/icon"):GetComponent(typeof(Image))
	arg0_1.starsTF = arg0_1.tf:Find("frame/shipicon/stars")
	arg0_1.circle = arg0_1.tf:Find("frame/shipicon/frame")
	arg0_1.starTF = arg0_1.tf:Find("frame/shipicon/stars/star")
	arg0_1.rejectBtn = arg0_1.tf:Find("frame/refuse_btn")
	arg0_1.accpetBtn = arg0_1.tf:Find("frame/accpet_btn")
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2:Clear()

	arg0_2.requestVO = arg1_2
	arg0_2.nameTF.text = arg1_2.player.name
	arg0_2.levelTF.text = "Lv." .. arg1_2.player.level

	local var0_2 = getOfflineTimeStamp(arg1_2.timestamp)

	arg0_2.dateTF.text = var0_2
	arg0_2.msg.text = arg1_2.content

	local var1_2 = arg1_2.player
	local var2_2 = AttireFrame.attireFrameRes(var1_2, var1_2.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var1_2.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_2, var2_2, true, function(arg0_3)
		if IsNil(arg0_2.tf) then
			return
		end

		if arg0_2.circle then
			arg0_3.name = var2_2
			findTF(arg0_3.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_3, arg0_2.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_2, var2_2, arg0_3)
		end
	end)

	local var3_2 = pg.ship_data_statistics[arg1_2.player.icon]

	if var3_2 then
		local var4_2 = arg1_2.player:getPainting()

		LoadSpriteAsync("qicon/" .. var4_2, function(arg0_4)
			arg0_2.iconTF.sprite = arg0_4
		end)

		local var5_2 = arg0_2.starsTF.childCount

		for iter0_2 = var5_2, var3_2.star - 1 do
			cloneTplTo(arg0_2.starTF, arg0_2.starsTF)
		end

		for iter1_2 = 1, var5_2 do
			local var6_2 = arg0_2.starsTF:GetChild(iter1_2 - 1)

			setActive(var6_2, iter1_2 <= var3_2.star)
		end
	end
end

function var0_0.Clear(arg0_5)
	if arg0_5.circle.childCount > 0 then
		local var0_5 = arg0_5.circle:GetChild(0)
		local var1_5 = var0_5.gameObject.name

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1_5, var1_5, var0_5.gameObject)
	end
end

function var0_0.Dispose(arg0_6)
	arg0_6:Clear()
end

return var0_0
